import 'package:connect_social/model/MyBalance.dart';
import 'package:connect_social/model/Transactions.dart';
import 'package:connect_social/model/directories/transactions_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:connect_social/model/NpDateTime.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/model/apis/api_response.dart';

class WalletViewModel extends ChangeNotifier {

  Transactions? transactionResponse=Transactions();
  TransactionsRepo _transactionRepo=TransactionsRepo();
  WalletViewModel({this.transactionResponse});

  List<Transactions?> _transactions=[];
  List<Transactions?> get getTransactions => _transactions;

  ApiResponse _transactionStatus=ApiResponse();
  ApiResponse get getTransactionStatus => _transactionStatus;

  void setMyTransactions(List<Transactions> _noti) {
    _transactions = _noti;
    notifyListeners();
  }

  Future fetchTransactions(dynamic data,String token) async {
    try{
      _transactionStatus = ApiResponse.loading('Fetching transactions');
      final response =  await _transactionRepo.fetchTransactionsApi(data,token);
      List<Transactions?> _trx=[];
      response['data'].forEach((item) {
        item['trx']=item['journal']['trx'];
        item['narration']=item['journal']['narration'];
        item['type']=item['journal']['type'];
        item['user']=User.fromJson(item['user']);
        item['createdat']=NpDateTime.fromJson(item['createdat']);
        _trx.add(Transactions.fromJson(item));
      });
      _transactionStatus = ApiResponse.completed(_trx);
      _transactions=_trx;
      notifyListeners();

    }catch(e){
      _transactionStatus = ApiResponse.error('Please try again.!');
      notifyListeners();
    }
  }

  List<Transactions?> _transactionsTier1=[];
  List<Transactions?> get getTier1Transactions => _transactionsTier1;

  ApiResponse _transactionTier1Status=ApiResponse();
  ApiResponse get getTier1NotificationStatus => _transactionTier1Status;

  void setTier1Transactions(List<Transactions> _noti) {
    _transactionsTier1 = _noti;
    notifyListeners();
  }

  Future fetchTier1Transactions(dynamic data,String token) async {
    try{
      _transactionTier1Status = ApiResponse.loading('Fetching tier 1 transactions');
      final response =  await _transactionRepo.fetchTransactionsApi(data,token);
      List<Transactions?> _trx=[];
      response['data'].forEach((item) {
        if(item['journal']['type']=='Tier 1 Reward'){
          item['trx']=item['journal']['trx'];
          item['narration']=item['journal']['narration'];
          item['type']=item['journal']['type'];
          item['user']=User.fromJson(item['user']);
          item['createdat']=NpDateTime.fromJson(item['createdat']);
          _trx.add(Transactions.fromJson(item));
        }
      });
      _transactionTier1Status = ApiResponse.completed(_trx);
      _transactionsTier1=_trx;
      notifyListeners();
    }catch(e){
      _transactionTier1Status = ApiResponse.error('Please try again.!');
      notifyListeners();
    }
  }
  List<Transactions?> _transactionsTier2=[];
  List<Transactions?> get getTier2Transactions => _transactionsTier2;

  ApiResponse _transactionTier2Status=ApiResponse();
  ApiResponse get getTier2NotificationStatus => _transactionTier2Status;

  void setTier2Transactions(List<Transactions> _noti) {
    _transactionsTier2 = _noti;
    notifyListeners();
  }

  Future fetchTier2Transactions(dynamic data,String token) async {
    try{
      _transactionTier2Status = ApiResponse.loading('Fetching tier 1 transactions');
      final response =  await _transactionRepo.fetchTransactionsApi(data,token);
      List<Transactions?> _trx=[];
      response['data'].forEach((item) {
        if(item['journal']['type']=='Tier 2 Reward'){
          item['trx']=item['journal']['trx'];
          item['narration']=item['journal']['narration'];
          item['type']=item['journal']['type'];
          item['user']=User.fromJson(item['user']);
          item['createdat']=NpDateTime.fromJson(item['createdat']);
          _trx.add(Transactions.fromJson(item));
        }
      });
      _transactionTier2Status = ApiResponse.completed(_trx);
      _transactionsTier2=_trx;
      notifyListeners();
    }catch(e){
      _transactionTier2Status = ApiResponse.error('Please try again.!');
      notifyListeners();
    }
  }

  MyBalance my_Balance=new MyBalance();
  MyBalance get getMyBalance => my_Balance;

  void setMyBalance(MyBalance _bal) {
    my_Balance = _bal;
    notifyListeners();
  }
  Future myBalance(dynamic data,String token) async {
    try{
      final response =  await _transactionRepo.fetchMyBalance(data,token);
      my_Balance=new MyBalance();
      my_Balance=MyBalance.fromJson(response['data']);
      notifyListeners();

    }catch(e){
      notifyListeners();
    }
  }
}