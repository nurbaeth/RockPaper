// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RockPaperScam {
    enum Move { None, Rock, Paper, Scissors }

    struct Game {
        address player1;
        address player2;
        bytes32 commit1;
        bytes32 commit2;
        Move move1;
        Move move2;
        uint256 commitDeadline;
        uint256 revealDeadline;
    }

    mapping(uint256 => Game) public games;
    uint256 public gameCounter;

    event GameCreated(uint256 indexed gameId, address indexed player1);
    event PlayerJoined(uint256 indexed gameId, address indexed player2);
    event MoveCommitted(uint256 indexed gameId, address indexed player);
    event MoveRevealed(uint256 indexed gameId, address indexed player, Move move);
    event GameResult(uint256 indexed gameId, address winner);

    modifier onlyPlayers(uint256 gameId) {
        require(
            msg.sender == games[gameId].player1 || msg.sender == games[gameId].player2,
            "Not a participant"
        );
        _;
    }

    function createGame() external {
        gameCounter++;
        games[gameCounter] = Game(
            msg.sender,
            address(0),
            bytes32(0),
            bytes32(0),
            Move.None,
            Move.None,
            block.timestamp + 1 days,
            0
        );

        emit GameCreated(gameCounter, msg.sender);
    }

    function joinGame(uint256 gameId) external {
        Game storage game = games[gameId];
        require(game.player2 == address(0), "Game is full");
        require(msg.sender != game.player1, "Cannot play against yourself");

        game.player2 = msg.sender;
        game.commitDeadline = block.timestamp + 10 minutes;

        emit PlayerJoined(gameId, msg.sender);
    }

    function commitMove(uint256 gameId, bytes32 moveHash) external onlyPlayers(gameId) {
        Game storage game = games[gameId];
        require(block.timestamp <= game.commitDeadline, "Commit time expired");

        if (msg.sender == game.player1) {
            require(game.commit1 == bytes32(0), "Move already committed");
            game.commit1 = moveHash;
        } else {
            require(game.commit2 == bytes32(0), "Move already committed");
            game.commit2 = moveHash;
        }

        emit MoveCommitted(gameId, msg.sender);
    }

    function revealMove(uint256 gameId, Move move, string memory secret) external onlyPlayers(gameId) {
        Game storage game = games[gameId];
        require(block.timestamp <= game.revealDeadline, "Reveal time expired");

        bytes32 moveHash = keccak256(abi.encodePacked(move, secret));

        if (msg.sender == game.player1) {
            require(game.move1 == Move.None, "Already revealed");
            require(game.commit1 == moveHash, "Invalid move or secret");
            game.move1 = move;
        } else {
            require(game.move2 == Move.None, "Already revealed");
            require(game.commit2 == moveHash, "Invalid move or secret");
            game.move2 = move;
        }

        emit MoveRevealed(gameId, msg.sender, move);

        if (game.move1 != Move.None && game.move2 != Move.None) {
            address winner = determineWinner(game.move1, game.move2, game.player1, game.player2);
            emit GameResult(gameId, winner);
        }
    }

    function determineWinner(
        Move move1,
        Move move2,
        address player1,
        address player2
    ) private pure returns (address) {
        if (move1 == move2) return address(0);
        if (
            (move1 == Move.Rock && move2 == Move.Scissors) ||
            (move1 == Move.Paper && move2 == Move.Rock) ||
            (move1 == Move.Scissors && move2 == Move.Paper)
        ) {
            return player1;
        } else {
            return player2;
        }
    }
}
