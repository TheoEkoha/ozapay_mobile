import 'package:faker/faker.dart';
import 'package:ozapay/core/ozapay/ozapay.dart';

final fakeTransactions = List.filled(
  10,
  TransactionHistory(
    signature: faker.lorem.words(10).join(" "),
    timestamp: faker.date.dateTime(),
    instruction: InstructionInfo(
      amount: 0,
      source: "",
      destination: "",
    ),
  ),
);

final fakeTokens = List.filled(
  10,
  TokenBalanceInfoModel(
    address: faker.jwt.secret,
    associatedAccount: faker.jwt.secret,
    balance: 0.0,
    balanceInCurrency: 0.0,
    info: TokenInfo(
      name: "Ozapay",
      symbol: "OZA",
      image: "https://ozapay-crypto.mypreprod.xyz/oza.png",
    ),
  ),
);
