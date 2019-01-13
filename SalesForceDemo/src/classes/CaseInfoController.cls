public without sharing class CaseInfoController {

	// 検索条件を宣言する
   	public CaseInfoSearchService caseInfoService{ get;set; }

    	// 検索条件を宣言する
   	public CaseInfoService caseService{ get;set; }

   	// 検索結果リスト
	public List<CaseBaseInfo__c> results { get;set; }

    // 見出しのソート用リンクを押された際のフィールド名
    public String sortingField { get;set; }

    // 選択された案件番号
    public String selectedCaseId { get;set; }

    //案件基本情報
    public CaseBaseInfo__c caseBaseInfo{get; set;}

    /**
     * 初期化処理
     */
    public void init(){
        this.caseInfoService = new CaseInfoSearchService();
        this.caseService = new CaseInfoService();
        this.results = new List<CaseBaseInfo__c>();
    }
    /**
     * 検索ボタン処理
     */
    public PageReference searchCaseInfo(){
		// バリデーションチェック
        if( caseInfoService.hasError() ){
            return null;
        }

        // 検索条件からSOQLを作成
        String soqlQuery = caseInfoService.getSoqlQuery();
        System.debug('[soql] ' + soqlQuery);

        try{
            this.results = database.query(soqlQuery);
            System.debug('抽出件数：' + results.size());
        }catch(DmlException e){
            ApexPages.addMessages(e);
        }catch(Exception e){
            ApexPages.addMessages(e);
        }
        return null;
    }

	/**
     * クリアボタン処理
     */
    public PageReference clear(){
        init();
        return null;
    }

    /**
     * ソートリンク処理
     */
    public PageReference sort(){

        // ソートを行う対象フィールドが不明な場合は何もしない
        if(this.sortingField == null ){
            return null;
        }

        // ソートを行う対象が、現在ソートしているフィールドと同じ場合はソート順を反対にする
        if(this.sortingField == this.caseInfoService.sortkey){
            this.caseInfoService.setOrderReverse();
        }
        // ソートを行う対象が、現在ソートしているフィールドと違う場合は新しい項目でソートするようにする
        else {
            this.caseInfoService.sortkey = this.sortingField;
        }

        // 検索実行
        searchCaseInfo();
        return null;
    }

    /**
     * 現在のソートキーを取得するためのメソッド
     *
     * ・検索結果の見出しにソート順を出すために使う
     * ・本来はgetSortOrderも含めて、ロジックもApex側で持ちたいが、
     * 　VisualForceから引数ありでメソッドが呼べないため、このようにしている。
     *
     */
    public String getSortKey(){
        return this.caseInfoService.sortkey;
    }

    /**
     * 現在のソート順を取得するためのメソッド（▲ or ▼を返す）
     */
    public String getSortOrder(){
        return this.caseInfoService.sortOrderToString();
    }

   /**
     * 取引先へを受注申請することを行う
     */
    public PageReference receiveOrder(){
     	selectedCaseId = ApexPages.currentPage().getParameters().get('selectedCaseId');
        caseBaseInfo = caseService.getCaseInfoById(selectedCaseId);
     	return Page.CaseInfoDetailPage;
    }
    
    public PageReference receiveRealOrder(){
        //メール送信
        Messaging.reserveSingleEmailCapacity(2);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {'kai.kaku@rigelsoft.co.jp'};
		mail.setToAddresses(toAddresses);
		// Specify the address used when the recipients reply to the email.
        mail.setReplyTo('ghw307261305@gmail.com');
        // Specify the name used as the display name.
        mail.setSenderDisplayName('Salesforce Support');
        // Specify the subject line for your email address.
        mail.setSubject('New Case Created : ' + case.Id);
        // Set to True if you want to BCC yourself on the email.
        mail.setBccSender(false);
        // Optionally append the salesforce.com email signature to the email.
        // The email address of the user executing the Apex Code will be used.
        mail.setUseSignature(false);
        // Specify the text content of the email.
        mail.setPlainTextBody('Your Case: ' + case.Id +' has been created.');
        mail.setHtmlBody('Your case:<b> ' + case.Id +' </b>has been created.<p>'+
             'To view your case <a href=https://yourInstance.salesforce.com/'+case.Id+'>click here.</a>');
        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        return Page.CaseInfoDetailPage;
    }

}