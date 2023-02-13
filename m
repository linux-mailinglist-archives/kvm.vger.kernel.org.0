Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158CE6952F5
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 22:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjBMVWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 16:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBMVWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 16:22:12 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167161E29E;
        Mon, 13 Feb 2023 13:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676323329; x=1707859329;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w3uii+j80ZazjgbyxXAmig2qiVQMqGwspGLM/KfYIOs=;
  b=HeBaDbVTlZ+K/5UFy6ThDuwt7jACiK+CZlikYnwnLhmYoUXYaSY5s6E0
   3C0Ul68uC2uiO10u3ZDJbnyRrlv6O3lweOmOn62xBmXj2/R2hLWnFpZ1B
   jHGRzaXG1SeZWewO5Tf/3g4lwhbYviJ4d9H7Pjv5o0B8dMRZokppgfv59
   MU4sRwggQN7xWmMTg4sm+1Ft5s/FhZxvP+4sV2Dzoyznq1QnHfVWb/OgU
   e4yrm+kPpDopzsSD+ZYHVCg1whOi31zJOQF3yFhBoROK6n8MFxauC9ojH
   5GVHmlJN3dvg3cvTvz0uLkAoggGOxn6dNWgE6PZqOoA8GmNMs5Qtd6VB/
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="314648653"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="314648653"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 13:21:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="646526873"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="646526873"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 13 Feb 2023 13:21:50 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 13:21:49 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 13:21:49 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 13:21:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvyV40/ZZKHrB+vJqBsaevK0/3WOeathxsOESJ1FhOkurr185PVwyGIL+57ShOTtl/ZD2d433Vpnid0KfZZGjZBfQ2nM2SSh9ssfU6uOC1B0ZFmQ8KxdjFjBcAZ8UvA5r2Qu19pfpFcf903joESOgCeSHwP9zEMO0jZMUV/ZSw4P6TD+gIEIamwUwWgjZd02VYXFNozb12RLqf+2vPE0T1eidfI7XLYk0+s4ZYl3DLkt09Wgf0yC+DQtsuD3cXyG3TkcxHqqhd15nZiQpEIbb60ylFrk2CVSOcQiUtqdPWPFW7Kjm09Rn3uAE3bPzA7zZDdAjrFuXWK+8V6kWj/cAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w3uii+j80ZazjgbyxXAmig2qiVQMqGwspGLM/KfYIOs=;
 b=XvtVoHYj7/I4dFZ0YAU+ABS3G6Q6BFuhVOxahPap/Jk1AL4HAs37YEItXw6YqgYzIgwIXM8rhvjPOJbHg9QPnqcQqOj20jrQt53sTtYBw6AyF7TnksGE6zDk64db8AhxtOSNVjJZLugtzYfqJD5IEwq/jEm/0+0QFYwe9GDrsDMLy/eCw4/h7Yi51tV8QkuUKYTbnYyiG7E3M0ZEv/r3snhuuTHSSoYwckWdy2wyBJPpYl6nVuEf+Yi374zbvDh56XlCpG8JTZfjBPM0iwUITxopTiX1Gx4wzDTCfdyueLThUvrZeKEZU5ruLdac2OQuhuoWFtDJx09qzZeyO9Llyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA0PR11MB4734.namprd11.prod.outlook.com (2603:10b6:806:99::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 21:21:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6086.023; Mon, 13 Feb 2023
 21:21:45 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>
Subject: RE: [PATCH v9 05/18] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Topic: [PATCH v9 05/18] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Index: AQHZP5usrWInYEMBIEu01+xNPQ5Ox67NJ5CAgAA63rA=
Date:   Mon, 13 Feb 2023 21:21:45 +0000
Message-ID: <BL1PR11MB597838368ECEC7C54DA0FE74F7DD9@BL1PR11MB5978.namprd11.prod.outlook.com>
References: <cover.1676286526.git.kai.huang@intel.com>
 <dd18d6b42768e0107d212fdebedae92cfd72cfe1.1676286526.git.kai.huang@intel.com>
 <13348209-40da-226e-7852-9dcd16758ed6@intel.com>
In-Reply-To: <13348209-40da-226e-7852-9dcd16758ed6@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA0PR11MB4734:EE_
x-ms-office365-filtering-correlation-id: 22cd3a16-f980-4684-a6c1-08db0e084f49
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CeFTS+imQMJtJq1Hos7QPSa8SqMGXpvIFlU0pKB00VwHPS7sBmmyfAtgQkyZ1PENVSwg3F2WosFHI58bLVud6hFT27u3SiCy+A5BFkvNvwZ4JTmoj+aF03JJcke4oi9Lams7epicnI2muoqxvDG03P0tMPnwkfNj3OnF5sWBy9xHLylssENVIi/iZ0LZoDcqI3wO4h08qWc5ipsLM6bDbc9DwxjAuK+1mgR2+d2Z4FAyjmTEDHNKCSub9UP1BvzE1ZUHy3xC4fx9mEJoWjDPOywKxKftrzOQvKNGgendr4bFedU/+Nvt8XkJ+7E1weiScLPqE5dhUKR2s0AwupUWy/MsC4AtbLAlmQX+vnAQvXOTYh5gaCbz5XNXgklziPj+ISNmewV8c0rhonmGj5UKOAfU+WjojExGGBLFRiA1niuDR6wn4UpqgX9EJcPwaLc4q2GN1z9oWX8qrMGdH2pYjeWKZ+d7bTJTXE/JYJE0EScb+q4RUppJK1ObP+q+vYzvYl7M8E7EK8z9oBOEF7j9UtHplm2TcPccN8Y/Ga7VuzjAG9Foc64dsyESlln8l7+abjxgej6eEwbWzHnxOOvcNQsqlpNOlhM8n3h6Whm87hZJBR9VwtXfwMNboXIYSunuXkD1QkzkywoKKRd+DQaA/65qcLXaaeqXrspcrDBBOv+pcC956dSUBj9Eyqph/ktQ0QEugVXjPbJ3VofVLoLYjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199018)(2906002)(82960400001)(86362001)(71200400001)(38100700002)(122000001)(7696005)(9686003)(53546011)(6506007)(186003)(26005)(33656002)(55016003)(38070700005)(76116006)(66946007)(54906003)(83380400001)(316002)(110136005)(41300700001)(4326008)(8676002)(478600001)(64756008)(52536014)(66446008)(66476007)(7416002)(8936002)(66556008)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDNwTm9HakNYVUwwQnBTdHhVdlozc2t2MFZvczZZZmVhd3RTUHZGTUVxNzNY?=
 =?utf-8?B?ck5oTk5reUNwbXBQaG4wUC9XQ0tucWhmemZLWnd2YnhWRDhUcDNubFRndG53?=
 =?utf-8?B?a1BGdkxaWGliWENhNnh1bjd2aTJRdUJRdXRuNWFuUEJiak50dHBTVFR2UlhG?=
 =?utf-8?B?LzBpcEFvSVYrR2J4V2x6eHY1V0ZSMm0vVm9HVHh3OUp4TGtOSkFqVE5PdlFx?=
 =?utf-8?B?VzN0S1BrT0g4cndSWHVqSlNOTzBYdzR1U3FhUXBkTmRrckJjZEJDUy9QT3JW?=
 =?utf-8?B?R3dVWGVaeDVJK2RadFBHeVEyTnQ4K3NmSWovajVUcGZ3OWZ4RFBiYW9ldGpC?=
 =?utf-8?B?Q2NCc241akdOaUc4VzQrNW1EYkRzRWNFeDFoVjhCcHltMFozalo3dWV1UWNm?=
 =?utf-8?B?K2I4bjBLZXlXbWZIVWN3RzBwQ2k4R2ttKzd1TFNvZEd0OCsrMVVPWlJwUTNs?=
 =?utf-8?B?QThEQXFvTkRYZkV2WkxHY1RmTXZ0UE8ybkVRclRlaWJkc2JzaXZ0K28ySFFN?=
 =?utf-8?B?WEE4R2VLcjVGRm5OWWRTTGZHT3lKT1ZxNlY1SElVUE5VSVZCcTFMYjBuaHI5?=
 =?utf-8?B?NkVBZzhEZ3BKNHN3SzgzbHlOZmRVMWFwZU15eDBiQVdvZjc3dWphTWtjSXBV?=
 =?utf-8?B?aEgwRHlEM1l5VE9jZTc0elBCbmpjNndQUjF5UnMrNXZzY0x4SzR4aUVKQTIw?=
 =?utf-8?B?Njdic3k5dUVZWURCNGdtTTFPUXA0dW50WngrRFc0YktOUDVWVEQ3VlJ0cW0r?=
 =?utf-8?B?eXViMXE3OVRCS1IxdmEwSkpKYlo3OW1IOHdxeTN0Tmh0VGNDd0oxNVFwNnlm?=
 =?utf-8?B?REh1bUNjeGd2MmNNdDJXS1c3ZmtJbnBDMUtTODBEUHZjWnZrRzc1cVlsSEVj?=
 =?utf-8?B?R2IwZ2NRRHA3UEJoTkVLaTVMUWFUWjR0Q0lZMVc0ekR6RWF6dldIeDRlNERR?=
 =?utf-8?B?WGQ4MDQ1TEY5eXBOQ0sycENLS29UbGdsTlJac0hzb2E1YmJBS0JoT2p0a3Vv?=
 =?utf-8?B?RGx2bnhnT3FNTlJCTkNlbUdUT0ljc0pPRzIvbUhDU292VSsyYVNMb2hFWG5n?=
 =?utf-8?B?Z1NkSHpySEpnYzQ0YXNjeHQyWG9zUmFxME9kTVhkK1hGL1R6VGZPQSswOUJM?=
 =?utf-8?B?TDlQeEdweWM4cXBQSzg4VExHQkZGb20zTEZJR2NrMHBWMlZwelcxSXR3cTVH?=
 =?utf-8?B?YlcyQzhISGN1MWJkMVFnTndIQUliTFkxNytQZVQ3TjYyWUtXT3RmcnRVZWRm?=
 =?utf-8?B?cENzM2U2NDFkZE9LQ1JWNy96ZG5iVitQdXZ1ZUNham5PL1RZWXZVZkpLRXFL?=
 =?utf-8?B?SWNRcVczcEsvRmo5aWE4NXczaWNTcHFhcmFxM2tNNFRaemZKaVJ2QnZ5YkV1?=
 =?utf-8?B?Ykh6ZzNobGhjcW03WmQ5NlBBdVBhN0FPRldOMC84WHJsY0E5WkE0a3paYTdh?=
 =?utf-8?B?SjloYUZ2Ri83US94bk9YQ3pwK0tQRlpNczJnN1dDYm1EdUtZbkR1RzVuc1BZ?=
 =?utf-8?B?ZTkyZm1seTJmM09TVVFUYzkxNE5sUk9raTJpKzdONlRYNWxvUURZMDYwS0E0?=
 =?utf-8?B?amZ2SnJRdC9iTHJFSFhLa0trVnRLOVBNZHUrWnphakV5SnJDQzB1OS9nUzlN?=
 =?utf-8?B?K0grakdwNnA4MGJLK0tCMnNxTGIra05uZXZrU2tiOTgxZU9Vem9nTzV2VGo1?=
 =?utf-8?B?K29qcEtJMzd6bmdYbEV4eDZ5VHAwQmZZSHdES1MzMGlTcFhSTnFHM2hlRUQr?=
 =?utf-8?B?Y1RqNWtEM21hejVISlFoR3Y4OFU0TUZYOERGTm1oZXpHVHdWYUpHc2lJZGRx?=
 =?utf-8?B?UXkzNXJaTXJVczdOZU5ZeUJ0czd2dTMvbGVIamk5WUNWTk9aalVXTDZ4UTBT?=
 =?utf-8?B?UTRGQXZoMHZUbDFCc3ZvaEJIMDhXeDZoYWV6QmZBZFRpWEd4VVVCNkNldktC?=
 =?utf-8?B?K01ab2Q0MVBITUNJNVFiMXJ0VXVRL0dKSHlxMG5KTG4rVG0yUmlGby8yejRm?=
 =?utf-8?B?L2Yzalgxb0ZuTDVGWTIwRGJtb3drSWJad2J6NkNMWXg4UUdMd0l4K2pEQ1lQ?=
 =?utf-8?B?MzBZTnZJVWhaZzJOWDRLOW1keU1PUitoa2kvQkt3SW1xaXQ2VzdTWktXQ1c1?=
 =?utf-8?Q?/XxZDjU/kr5MMFcjiaODsMyVt?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22cd3a16-f980-4684-a6c1-08db0e084f49
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 21:21:45.5342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RZ9m8L2uc0ugMZmdc8mztVM5PMx+0CkwR18GVobhGKzbD2jA4LyWItODV2HvxAF7hr0/KF8IL/pvlvFK2SWbWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4734
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiAyLzEzLzIzIDAzOjU5LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gZGlmZiAtLWdpdCBhL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCj4g
PiBpbmRleCA0YTNlZTY0YzFjYTcuLjVjNWVjZmRkYjE1YiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiA+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Rk
eC5oDQo+ID4gQEAgLTgsNiArOCwxMCBAQA0KPiA+ICAjaW5jbHVkZSA8YXNtL3B0cmFjZS5oPg0K
PiA+ICAjaW5jbHVkZSA8YXNtL3NoYXJlZC90ZHguaD4NCj4gPg0KPiA+ICsjaWZkZWYgQ09ORklH
X0lOVEVMX1REWF9IT1NUDQo+IC4uLg0KPiA+ICsjZGVmaW5lIFREWF9TRUFNQ0FMTF9HUAkJCShU
RFhfU1dfRVJST1IgfA0KPiBYODZfVFJBUF9HUCkNCj4gPiArI2RlZmluZSBURFhfU0VBTUNBTExf
VUQJCQkoVERYX1NXX0VSUk9SIHwNCj4gWDg2X1RSQVBfVUQpDQo+ID4gKw0KPiA+ICsjZW5kaWYN
Cj4gDQo+IEFsbCB0aGVzZSBraW5kcyBvZiBoZWFkZXIgI2lmZGVmcyBkbyBpdCBtYWtlIGl0IGhh
cmRlciB0byB3cml0ZSBjb2RlIGluIC5jIGZpbGVzDQo+IHdpdGhvdXQgbWF0Y2hpbmcgI2lmZGVm
cy4gIFRoaW5rIG9mIGNvZGUgbGlrZSB0aGlzIGNvbXBsZXRlbHkgbWFkZSB1cCBleGFtcGxlOg0K
PiANCj4gCWlmICghdGR4X2VuYWJsZSgpKSB7DQo+IAkJLy8gU3VjY2VzcyEgIE1ha2UgYSBzZWFt
Y2FsbDoNCj4gCQlpbnQgc29tZXRoaW5nID0gdGR4X3NlYW1jYWxsKCk7DQo+IAkJaWYgKHNvbWV0
aGluZyA9PSBURFhfU0VBTUNBTExfVUQpDQo+IAkJCS8vIG9oIG5vIQ0KPiAJfQ0KPiANCj4gdGR4
X2VuYWJsZSgpIGNhbiBuZXZlciByZXR1cm4gMCBpZiBDT05GSUdfSU5URUxfVERYX0hPU1Q9biwg
c28gdGhlIGVudGlyZSBpZigpDQo+IGJsb2NrIGlzIG9wdGltaXplZCBhd2F5IGJ5IHRoZSBjb21w
aWxlci4gICpCVVQqLCBpZiB5b3UndmUgI2lmZGVmJ2QgYXdheQ0KPiBURFhfU0VBTUNBTExfVUQs
IHlvdSdsbCBnZXQgYSBjb21waWxlIGVycm9yLiAgUGVvcGxlIHVzdWFsbHkgZml4IHRoZSBjb21w
aWxlDQo+IGVycm9yIGxpa2UgdGhpczoNCj4gDQo+IAlpZiAoIXRkeF9lbmFibGUoKSkgew0KPiAj
aWZkZWYgQ09ORklHX0lOVEVMX1REWF9IT1NUDQo+IAkJLy8gU3VjY2VzcyEgIE1ha2UgYSBzZWFt
Y2FsbDoNCj4gCQlpbnQgc29tZXRoaW5nID0gdGR4X3NlYW1jYWxsKCk7DQo+IAkJaWYgKHNvbWV0
aGluZyA9PSBURFhfU0VBTUNBTExfVUQpDQo+IAkJCS8vIG9oIG5vIQ0KPiAjZW5kaWYNCj4gCX0N
Cj4gDQo+IFdoaWNoIGlzbid0IGdyZWF0Lg0KPiANCj4gRGVmaW5pbmcgdGhpbmdzIHVuY29uZGl0
aW9uYWxseSBpbiBoZWFkZXIgZmlsZXMgaXMgKkZJTkUqLCBhcyBsb25nIGFzIHRoZSAjaWZkZWZz
DQo+IGFyZSB0aGVyZSBzb21ld2hlcmUgdG8gbWFrZSB0aGUgY29kZSBnbyBhd2F5IGF0IGNvbXBp
bGUgdGltZS4NCg0KVGhhbmtzIGZvciB0aGUgZXhwbGFuYXRpb24gYWJvdmUhDQoNCj4gDQo+IFBs
ZWFzZSBwb3N0IGFuIHVwZGF0ZWQgKGFuZCB0ZXN0ZWQpIHBhdGNoIGFzIGEgcmVwbHkgdG8gdGhp
cy4NCg0KV2lsbCBkby4NCg==
