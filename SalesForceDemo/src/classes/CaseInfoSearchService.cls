public without sharing class CaseInfoSearchService {

	// 抽出対象となるフィールドリスト
    private static List<String> TARGET_FIELDS = new List<String>{
         'Id'
        ,'Name'
        ,'caseId__c'
        ,'caseSummary__c'
        ,'caseName__c'
        ,'workStartDate__c'
        ,'workEndDate__c'
        ,'workSpace__c'
        ,'workContent__c'
        ,'workerCount__c'
        ,'price__c'
        ,'LastModifiedDate'
    };
    //検索オブジェクト
	public CaseBaseInfo__c searchObj {get;set;}
	// ソートキー
	public String sortkey { get;set; }
	// ソート順
    public String order { get;set; }

	public CaseInfoSearchService() {
        // デフォルトは最終更新日時の降順とする
        sortkey = 'LastModifiedDate';
        order = 'DESC';
        searchObj = new CaseBaseInfo__c();
	}

    public Boolean hasError(){
        return false;
    }

     // 最終的なSOQLを生成（最大500件というのは固定）
	public String getSoqlQuery(){
		List<String> param = new String[]{ getFieldList(), getWhere(), getOrder() };
		return String.format('SELECT {0} FROM CaseBaseInfo__c {1} {2} LIMIT 100', param);
     }

	// SELECT対象フィールド
	private String getFieldList(){
		return String.join(TARGET_FIELDS, ',');
	}

	// WHERE句作成
	private String getWhere(){
		List<String> param = new String[]{ };

		// 案件番号
        if( !String.isBlank(this.searchObj.caseId__c)){
         	param.add('caseId__c = \'' + searchObj.caseId__c + '\'');
      	}
        // 案件名称
        if( !String.isBlank(this.searchObj.caseName__c)){
           param.add('caseName__c = \'' + searchObj.caseName__c + '\'');
        }
       	// パラメータがない場合
        if(param.isEmpty()){
            return '';
        }
        return 'WHERE ' + String.join(param, ' AND ');
    }

    // ORDERBY句作成
    private String getOrder(){
        List<String> param = new String[]{ sortkey, order };
       	return String.format('ORDER BY {0} {1}', param);
    }

    // ソート順を見出しに表示する記号に変換する
    public String sortOrderToString(){
        if(this.order == 'DESC'){
            return '▼';
        }
        return '▲';
    }

    // ソート順を逆にする
    public void setOrderReverse(){
        if(this.order == 'DESC'){
            this.order = 'ASC';
        }
        else {
            this.order = 'DESC';
        }
    }

}