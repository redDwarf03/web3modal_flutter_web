import 'dart:convert';
import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_application_1/application/actions/get_account.dart';
import 'package:flutter_web_application_1/application/actions/get_balance.dart';
import 'package:flutter_web_application_1/application/actions/get_chain_id.dart';
import 'package:flutter_web_application_1/application/actions/get_token.dart';
import 'package:flutter_web_application_1/application/actions/sign_message.dart';
import 'package:flutter_web_application_1/application/actions/write_contract.dart';
import 'package:flutter_web_application_1/domain/actions/get_balance.dart';
import 'package:flutter_web_application_1/domain/actions/get_token.dart';
import 'package:flutter_web_application_1/domain/actions/sign_message.dart';
import 'package:flutter_web_application_1/domain/actions/write_contract.dart';
import 'package:flutter_web_application_1/domain/bigint.dart';
import 'package:flutter_web_application_1/domain/models/account.dart';
import 'package:flutter_web_application_1/domain/window.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int chainId = 0;
  String? token;
  Account? account;
  String? signedMessage;
  String? hashApproval;
  String? balance;
  final tokenAddressToSearch = '0x8a3d77e9d6968b780564936d15B09805827C21fa';
  final messageToSign = 'Hello World';

  late String? abiERC20;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final abiTokenStringJson = jsonDecode(
        await rootBundle.loadString(
          'lib/abi/ERC20.json',
        ),
      );

      abiERC20 = jsonEncode(abiTokenStringJson['abi']);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Web3Modal')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: openModal,
                child: const Text('Connect Wallet'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    signedMessage = null;
                    account = getAccount();
                    chainId = getChainId().toDartInt;
                  });
                },
                child: const Text('Get Account info'),
              ),
              const SizedBox(
                height: 10,
              ),
              Text('account address: ${account?.address ?? 'unknown'}'),
              Text('account status:  ${account?.status ?? 'unknown'}'),
              Text('account chain ID: ${account?.chainId ?? 'unknown'}'),
              Text('Chain ID: $chainId'),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  final getBalanceParameters =
                      GetBalanceParameters(address: account!.address!);
                  final getBalanceReturnType =
                      await getBalance(getBalanceParameters);
                  setState(() {
                    balance =
                        '${getBalanceReturnType.formatted} ${getBalanceReturnType.symbol}';
                  });
                },
                child: const Text('Get Balance'),
              ),
              const SizedBox(
                height: 10,
              ),
              Text('balance: ${balance ?? 'unknown'}'),
              ElevatedButton(
                onPressed: () async {
                  final getTokenParameters = GetTokenParameters(
                    address: tokenAddressToSearch.toJS,
                    chainId: account!.chainId,
                  );
                  final getTokenReturnType = await getToken(getTokenParameters);
                  setState(() {
                    token =
                        '${getTokenReturnType.name} ${getTokenReturnType.symbol}';
                  });
                },
                child: Text(
                  'Get Token info ($tokenAddressToSearch / ${account?.chainId})',
                ),
              ),
              if (token != null) Text('token: $token'),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  final signMessageParameters = SignMessageParameters(
                    account: account!.address!,
                    message: messageToSign.toJS,
                  );

                  try {
                    final signMessageReturnType =
                        await signMessage(signMessageParameters);

                    setState(() {
                      signedMessage = signMessageReturnType.toString();
                    });
                  } catch (e) {
                    print('erreur sign $e');
                  }
                },
                child: Text('Personal sign ($messageToSign)'),
              ),
              if (signedMessage != null)
                Column(
                  children: [
                    Text('message signed: $signedMessage'),
                  ],
                ),
              ElevatedButton(
                onPressed: () async {
                  final writeContractParameters = WriteContractParameters(
                    abi: [
                      {
                        "inputs".toJS: [
                          {
                            "internalType".toJS: "address".toJS,
                            "name".toJS: "spender".toJS,
                            "type".toJS: "address".toJS
                          },
                          {
                            "internalType".toJS: "uint256".toJS,
                            "name".toJS: "amount".toJS,
                            "type".toJS: "uint256".toJS
                          }
                        ],
                        "name".toJS: "approve".toJS,
                        "outputs".toJS: [
                          {
                            "internalType".toJS: "bool".toJS,
                            "name".toJS: "".toJS,
                            "type".toJS: "bool".toJS
                          }
                        ],
                        "stateMutability".toJS: "nonpayable".toJS,
                        "type".toJS: "function".toJS
                      }.jsify(),
                    ].toJS,
                    address: '0x8a3d77e9d6968b780564936d15B09805827C21fa'.toJS,
                    account: account?.address,
                    functionName: 'approve'.toJS,
                    gas: createBigInt('1500000'),
                    args: [
                      '0x346Dba8b51485FfBd4b07B0BCb84F48117751AD9'.toJS,
                      createBigInt('498500000000000'),
                    ].toJS,
                    chainId: chainId.toJS,
                  );

                  final writeContractReturnType =
                      await writeContract(writeContractParameters);

                  setState(() {
                    hashApproval = writeContractReturnType.hash.toDart;
                  });
                },
                child: const Text('Call approve'),
              ),
              if (hashApproval != null)
                Column(
                  children: [
                    Text('Hash approval: $hashApproval'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void openModal() {
    window.openModal();
  }

  void closeModal() {
    window.closeModal();
  }
}
