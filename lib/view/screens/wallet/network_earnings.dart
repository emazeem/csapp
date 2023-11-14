import 'package:connect_social/model/Transactions.dart';
import 'package:connect_social/model/apis/api_response.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view_model/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletNetworkEarning extends StatefulWidget {
  const WalletNetworkEarning({Key? key}) : super(key: key);

  @override
  State<WalletNetworkEarning> createState() => _WalletNetworkEarningState();
}

class _WalletNetworkEarningState extends State<WalletNetworkEarning> {
  var authToken;
  int? authId;

  Future<void> _pullRefresh(ctx) async {
    Map data = {'id': '${authId}','latest':'false'};
    Provider.of<WalletViewModel>(context, listen: false).setTier1Transactions([]);
    Provider.of<WalletViewModel>(context, listen: false).fetchTier1Transactions(data, '${authToken}');
    Provider.of<WalletViewModel>(context, listen: false).setTier2Transactions([]);
    Provider.of<WalletViewModel>(context, listen: false).fetchTier2Transactions(data, '${authToken}');
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      authId = await AppSharedPref.getAuthId();
      _pullRefresh(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    WalletViewModel walletViewModel = Provider.of<WalletViewModel>(context);
    List<Transactions?> transactionsTier1 = walletViewModel.getTier1Transactions;
    List<Transactions?> transactionsTier2 = walletViewModel.getTier2Transactions;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Constants.titleImage2(context),
      ),
      body: Container(
          color: Constants.np_bg_clr,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: RefreshIndicator(
                onRefresh: () async {
                  _pullRefresh(context);
                },
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Network Earnings',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Divider(),
                    if (walletViewModel.getTier1NotificationStatus.status == Status.IDLE) ...[
                      if (transactionsTier1.length == 0) ...[
                        Card(
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(Constants.np_padding),
                            child: Text('No Tier 1 Reward'),
                          ),
                        )
                      ] else ...[
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Tier 1 Rewards',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Card(
                            child: Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              child: DataTable(
                                columnSpacing: 20,
                                columns: [
                                  DataColumn(
                                      label: Text('User', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Type', style: TextStyle(                                           fontSize: 18,                                           fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Activity',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),


                                  DataColumn(
                                      label: Text('Date',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Coins',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),

                                ],
                                rows: [
                                  for (var trx1 in transactionsTier1) ...[
                                    notificationCard(trx1),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        )
                      ]
                    ] else if (walletViewModel
                        .getTier1NotificationStatus.status ==
                        Status.BUSY) ...[
                      Utils.LoadingIndictorWidtet(),
                    ],

                    Divider(),
                    if (walletViewModel.getTier2NotificationStatus.status == Status.IDLE) ...[
                      if (transactionsTier2.length == 0) ...[
                        Card(
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(Constants.np_padding),
                            child: Text('No Tier 2 Reward'),
                          ),
                        )
                      ] else ...[
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Tier 1 Rewards',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Card(
                            child: Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              child: DataTable(
                                columnSpacing: 20,
                                columns: [
                                  DataColumn(
                                      label: Text('User', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Type', style: TextStyle(                                           fontSize: 18,                                           fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Activity',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),


                                  DataColumn(
                                      label: Text('Date',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Coins',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),

                                ],
                                rows: [
                                  for (var trx2 in transactionsTier2) ...[
                                    notificationCard(trx2),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        )
                      ]
                    ] else if (walletViewModel
                        .getTier1NotificationStatus.status ==
                        Status.BUSY) ...[
                      Utils.LoadingIndictorWidtet(),
                    ],






                  ],
                ),
              ))),
      backgroundColor: Colors.white,
    );
  }

  DataRow notificationCard(Transactions? trx) {
    return DataRow(cells: [
      DataCell(Text('${trx?.user?.fname} ${trx?.user?.lname}',style: TextStyle(fontSize: 12),)),
      DataCell(Text('${trx?.type}',style: TextStyle(fontSize: 12),)),
      DataCell(
          Container(
            width: 130,
            child: Text('${trx?.narration}',softWrap: true,style: TextStyle(fontSize: 12),),
          )
      ),
      DataCell(
        Text('${trx?.createdat?.m}-${trx?.createdat?.m}-${trx?.createdat?.Y}',style: TextStyle(fontSize: 12)),
      ),
    DataCell(
    (trx?.dr != null)? Text('+${trx?.dr}',style: TextStyle(fontSize: 12),)
        : Text('-${trx?.cr}',style: TextStyle(fontSize: 12),))
    ]);
  }
}
