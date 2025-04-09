🎮 RockPaperChain – On-Chain Rock, Paper, Scissors
RockPaperChain is a fully on-chain Rock, Paper, Scissors game built on Solidity. It ensures fair play using a commit-reveal scheme, preventing cheating. No bets, no fees—just pure Web3 gaming fun!

✨ Features
✅ Fair Gameplay – Uses commit-reveal to prevent cheating.
✅ Gas-Only – No bets or fees, just transaction costs.
✅ Trustless & Transparent – All moves are recorded on-chain.
✅ Time-Limited Rounds – Players must reveal within 10 minutes.
✅ Leaderboard Ready – Can be expanded for on-chain score tracking. 
 
📜 How It Works 
1️⃣ Create a Game 
solidity  
Копировать  
Редактировать    
createGame();  
You become Player 1.
The game is open for a second player.
2️⃣ Join a Game
solidity 
Копировать
Редактировать
joinGame(gameId);
You become Player 2.
The commit phase starts (10 min deadline).
3️⃣ Commit Your Move
Each player submits a hashed move:

solidity
Копировать
Редактировать
commitMove(gameId, keccak256(abi.encodePacked(move, secret)));
move: 1 = Rock, 2 = Paper, 3 = Scissors.
secret: Any random string (used to prevent cheating).
4️⃣ Reveal Your Move
After both players commit, they must reveal:

solidity
Копировать
Редактировать
revealMove(gameId, move, secret);
The contract checks if the move matches the commit hash.
If both players reveal, the winner is determined.
5️⃣ Winner is Declared! 🎉
The smart contract determines the winner based on classic rules.
If a player doesn’t reveal within 10 minutes, they lose by default.
🛠 Deployment & Testing
To deploy on a testnet, use Remix, Hardhat, or Foundry.

Compile the contract
Deploy to a testnet
Interact using Etherscan, Remix, or custom frontend
🎯 Future Improvements
✅ On-Chain Leaderboard
✅ More Game Modes (Best of 3, Tournaments, etc.)
✅ NFT Badges for Winners

🤝 Contributing
Feel free to fork, improve, and submit PRs!

📜 License
MIT License – Free to use, modify, and deploy.

