Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2045F144D
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 23:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbiI3VEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 17:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbiI3VEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 17:04:42 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2CBF7F
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 14:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664571876; x=1696107876;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=w8GVKdml32gEB8OkyuYMOq1MdMk7CwtcH/vwE62oExs=;
  b=AwIwnW7aZzaKrgcHqDxn2c101cY2ISfGgHAZY2R6jWWjyOuDSkTV10uZ
   mX3D/yWYBNpZA0euhwYsRpISIETKDxEM8MKSRpXG65nRfSXrziQk9u6GC
   OcMJX7IYyJs1ej0hq4GV5K/aDxQ/6Ic+Q+G/DIo7umf+lIzVQ5FpLnPyg
   KEltSEuQOlfYpMVd69zn2unEwX5yzKigpjSrfJaWrHlmM5zLIeYnEYmja
   WjXZQEI+1Vl75dw1PmzeTEGXpSVFcQX8w3AOiIMJP/KCWUpvsLMg3/fXj
   uUjACckyItB0YNtIhMsIBlwJEHQN0H/hqEwDtYpMMESL18xPmNqulcaH8
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="302268973"
X-IronPort-AV: E=Sophos;i="5.93,359,1654585200"; 
   d="scan'208";a="302268973"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 14:04:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="951692962"
X-IronPort-AV: E=Sophos;i="5.93,359,1654585200"; 
   d="scan'208";a="951692962"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 30 Sep 2022 14:04:34 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 14:04:34 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 14:04:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 30 Sep 2022 14:04:33 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 30 Sep 2022 14:04:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CSPIX4EJhYvRsV4bzhNLwjoqcGQpYDn08r2Pih1pVxKRXVfsB/mI3cSnspt4e+M7LfFrQgcIb73To/2NkYanDYUVv7fz9QzYMmc8aSbarM7zkpNqJ7Bs2WEOaeBtQyzMfiNbC0hb7OVcJ9xXoYy/OLxjMxCLkrsYxhNLt60tb3/67Vqr4k588zOH362ZtF05OrpjzxubjNafK3m4XjGekE/rq6jUqt2wNcLwwa3hr6sp1e8mmEAviRnMiB0ylrSB3YfDzZGc+j6Wl0gqIS5KWP9bBMrIO5Yov+ZghiJ3ovtyGZuA48mNjgea1ZINGEw6yQhvNHvixK0oOLHYpK0TDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w8GVKdml32gEB8OkyuYMOq1MdMk7CwtcH/vwE62oExs=;
 b=fG07edVjWCB046DQRVeKIz/loOlLWWdx6THfMoh8pcRZWSDw9rCIDhBVyFwrrZmKMUo2dV/y/q2EflewkA/2x/+UDQZ8mQNlmTI1bUYlo0RNX6YZNO4arQUh+UgfTGs6UPQlH4//Bw16Lmq7qSbpfNaihykghuyAbbJpwjMeQOPi+BxECae9GvndCckwZH/OmdsyXnA9CpxHN04D5pgLohzb1gGXIwc4yTwudWhOeCiZTF0RlBlUyvUu4xslKavm03RKFNp5QvtNLEYLSkl+cU0AXCQZn0UgfT03igGfn1Y0TotcTgEkhK/9W+oL2bq/E+OnqLn2nIwiRuZoCgPTwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3042.namprd11.prod.outlook.com (2603:10b6:208:78::17)
 by PH7PR11MB5765.namprd11.prod.outlook.com (2603:10b6:510:139::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Fri, 30 Sep
 2022 21:04:31 +0000
Received: from BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::b52e:e73e:ac99:8a5]) by BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::b52e:e73e:ac99:8a5%3]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 21:04:31 +0000
From:   "Dong, Eddie" <eddie.dong@intel.com>
To:     Jim Mattson <jmattson@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: RE: [PATCH 1/6] KVM: x86: Mask off reserved bits in CPUID.80000001H
Thread-Topic: [PATCH 1/6] KVM: x86: Mask off reserved bits in CPUID.80000001H
Thread-Index: AQHY1FYkQH3ZJy4wuUS6hS48ZuPMbK34d4BQ
Date:   Fri, 30 Sep 2022 21:04:31 +0000
Message-ID: <BL0PR11MB30425351024AC155FFC377268A569@BL0PR11MB3042.namprd11.prod.outlook.com>
References: <20220929225203.2234702-1-jmattson@google.com>
In-Reply-To: <20220929225203.2234702-1-jmattson@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3042:EE_|PH7PR11MB5765:EE_
x-ms-office365-filtering-correlation-id: dc1ef216-6dc6-4d78-20a4-08daa3275e9b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lgbesi2bwr7qzuk0wpi4SGayY+f6oS2J39+GQyAYdiuA58ar2VF7wgBRWV3kJrUPiW83C30KnZUI1D0wb5/ckYIYJYvIl3p+PkI04Xi4Z04tCua8EFgjysEnzxwOtcAB7pehRG0G7lMxij8EHEBQeSFlDvFaygVs44ojSEQOza/XrVxlx15di7STPj/6f8JsXbUUgD2xsaVc89ZAd41gTiLW9clCzTjiOMV2LsuvFmk+kj5WoAQe79Xrhl464RklerfN/9pT1yehSi89JCKFeEhK55Av6zTlNF2duedeQQGm2ihb9tx5TTiHA645P8mh3U4AHb3ZHpWp3g0SoWsDDnXIsUidMVMLTT+HKRbtFBNG+D1rjDtCAS/Vkg3SaNxHpsT0iPS8yQz9ajGo1BkZUfux9dL9KlP6EzHr8YM1psnQlMiF250au4Bj7MI/qie7tyz2H6hhQWq/it9bmSq3itrllL90T1abiD11GGCnS0w5FBZgOCaKlfeuwFrj8NEIzQuJIetLkZyCnkzBLQUNjzLR++/XJhErUp1kIFBrwEfRhRk+hWG/dp9edPFLTUz7AOzKpRnmX9y3/wjBk9TCLaehwETevdRldKvRHNc2ZZh60/g9NQJdBqF1xTPh/aXvpwHbF92ZgDZeSMWYaXcBKx+0cx86HvHAM3F2nb/DO1R/jhQqq8hnIJr06g+cSadgWIbIN8Qgfz8nwMQ7ZVrH9DJ2eISOhGgALDyGHd1K90OIt1+a8uSOSnK6qFg0l5Jj5drnrjmxLGetKeKHMmMPcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3042.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(39860400002)(346002)(376002)(451199015)(86362001)(5660300002)(122000001)(52536014)(8936002)(66556008)(6506007)(41300700001)(76116006)(2906002)(26005)(55016003)(66946007)(7696005)(83380400001)(53546011)(33656002)(82960400001)(316002)(38100700002)(110136005)(71200400001)(478600001)(9686003)(8676002)(66476007)(186003)(38070700005)(66446008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3ZUdGc3UElFb1REN3pDSWVybElvREhFSU9CUDFjVENrOGQyRmdkR2Zxbkdz?=
 =?utf-8?B?dmJhOU5udVpWZG9Jb0VocWRDdjE4dEIvNjV1SHBZdTVtNUpKWjZYVEprYXVW?=
 =?utf-8?B?VVBQVFlZbEtnVjNXeUJqYnAwWGNtc1UydWJXdFJtVE1xRWhPNlQxSUhzbXk3?=
 =?utf-8?B?UUxDUkpjbGdSRllRWVp2enArV09iY2dkTlgxNVlNZmF3RnlCMmUxU1BYS1hp?=
 =?utf-8?B?Wk9TSURYU1NUL1VEMkhNekRHWkJZMGtvTUVIcGtOa0ttSFpuUW5GT2NJSDNk?=
 =?utf-8?B?Ty82Vi9GU3VjbFFiVU15TEVqUzdYN1licUdUeStuVnNubStRM3VqcVVDZjU2?=
 =?utf-8?B?MlhjOFhVVnErSGJjVHhab0c1ajV5Rm1Udk9sMzE2U2hoWi9iU3NNanV5NldK?=
 =?utf-8?B?aXhlVlRlYTNlblBMMnV2aCtwWkFoekpIRWNEaDlQVkxVNm4vdnB2bmQrQXVv?=
 =?utf-8?B?bEVob2ZzZ2dqdGxvRjVUQ3YzN2dMZEMzbHR2OENzVlRrT0JHZ29wSTdDUFNI?=
 =?utf-8?B?ZFhicHoybmtlNHVORlRQSCtqVHhGV1U4VTYrRkpOcGljK0FrWkRrOTJ5THIz?=
 =?utf-8?B?cmV4WExJeU94YlptYlBxOHg2T3grM1NnYkIvR2pxcmM1TWtVV1Q1RjQwWjRN?=
 =?utf-8?B?aG5PeXlMZTNpbDhnblZMTStweHRzZEpaNzI1UXhoRytIeDF6dXFvZGJYMjZB?=
 =?utf-8?B?ZlhIRWFvZU1zbnltZk1ucCtvRUpXTVZKbktoZFg4MHd0WkhYTHhMMS9DQ3Zw?=
 =?utf-8?B?VWJLS2dpQUJQYytqS0thRjdQTnRYd2FETWdkQkQyREFUWmMxUml6YmZoMXIx?=
 =?utf-8?B?QXErWVd2TmEyQityK0oveU9SK0l5WGg4TFRCNGtwVXdDQUw5OHdHT2gxS0dS?=
 =?utf-8?B?MEk5U2xVVFNEQzNWTWJYa0RkbEtwdGdwMlhmZzVOdDNUZHJvL2xEOHEvN2Za?=
 =?utf-8?B?YlFab0pqSE4vY3c3LzQ4TVRqd1I5Y0pPMkxQaFg3UGoyOFNSSGFscmZ0RWRE?=
 =?utf-8?B?bmtHWkFlMEYyN3NKSHkyRVl4eVNYSDZDRE1rTDhSVDVBNVNiRFpmUUVKWk4z?=
 =?utf-8?B?RUlHZnk4Wk9TRnVIdENGdDVkVlRIZWFNdjBINC9VMUhaNlluUnhWSXc4QkZw?=
 =?utf-8?B?RC96S2k1UFY1cWtNdlRpYnBOK1FGaGV0MThJUGVpTWJETmhyUURYN3ZxMTVC?=
 =?utf-8?B?YlNFZkNjcXZDVjdqMVdzd21BYkJwaWhBYVYwaFlna3VLZXpnUm1wNUpKc2ht?=
 =?utf-8?B?aVBCN0NTNHptT3U0NkFOMlZPOHNHbm5iT050cURhVjFzUzFtQXRvWk1xY2dD?=
 =?utf-8?B?MHc0c3NzN3BGZEJPMFRZNUVVMXpRS0xYajFaZDBiLzFoM1hvOWtqVlZaOGdT?=
 =?utf-8?B?UzBWbVFNbTBvZ1o2cnBDZk9OYXltcXY2MjlpRUdpVEJtZXkxNXFBTFZFZytv?=
 =?utf-8?B?dFdQOTlBeTZsT3BaY0RYYzlnRnp4aUd5OFREVU1sS3YxVTRtRjR4WHN4T0ZX?=
 =?utf-8?B?V0ZYbW1HMHJuRW56b2MwTytaQmpxaU5aOUFMSUJDMkVpelhWR3hIUm42anly?=
 =?utf-8?B?ZzlYbS9URFNLZ1N6LzV3YTE1ZWthZlJXcTB4WjBjb3pGbTJ2Rkx1dSszbHo3?=
 =?utf-8?B?RnlrZjZsRzZLL0NJM05XWGNRekFBekc2bHpGekxVUk9rV1Q3S25sUTZ5NmhJ?=
 =?utf-8?B?ZHEzNTdVbFlPK2R4RFd5OUcrWmdkZVlHbWM2UnJ1amp0MWwvOTRCYUp2UGNT?=
 =?utf-8?B?MFF0eU13Q1ZtOTdaTzczaUZ3K0Q1WTZyUGtBU1RmZlA3UHBkKzZ1R1AzQkRv?=
 =?utf-8?B?WjdnRzBGOEt4VkpHQTNYT0pQeWU4QUFtb0NRd1ZGYjRnM043cEZJUU10VkE1?=
 =?utf-8?B?c0dNeUZXUDdMSXJSTWtHbWdKcFN3QXd1VFVvcjYybUovK0xaVUduSHpXc282?=
 =?utf-8?B?UjNoelZ5dzcvNHV0dENWUHNFWjRNVG4yNEpxQURaRjNvTGdjWWFNYlFkZnFM?=
 =?utf-8?B?ekwzR2czUm5FMHZEL3lUUmNYK09ZdDkxZFhPRERJNWR3MzlWWlI5STQxNmRE?=
 =?utf-8?B?TS9vTkFpUUxOMXpwZThXQ1ZhRlVzK2xTZ2ZJNlg2RzhXL05vVnl6QWxhZnNu?=
 =?utf-8?Q?RKkfrihx0qfJfUyNZV2D0SymD?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3042.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc1ef216-6dc6-4d78-20a4-08daa3275e9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2022 21:04:31.2467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QEOgLH1FyUx8cbCg/ZymzVp6A/lD0QY/+oflC6D9wibNdqdxH1VCp4bWz5zyYXZUubGrVwFZViejAcS1ibXFJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5765
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmltIE1hdHRzb24gPGpt
YXR0c29uQGdvb2dsZS5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBTZXB0ZW1iZXIgMjksIDIwMjIg
Mzo1MiBQTQ0KPiBUbzoga3ZtQHZnZXIua2VybmVsLm9yZzsgcGJvbnppbmlAcmVkaGF0LmNvbTsg
Q2hyaXN0b3BoZXJzb24sLCBTZWFuDQo+IDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gQ2M6IEppbSBN
YXR0c29uIDxqbWF0dHNvbkBnb29nbGUuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggMS82XSBLVk06
IHg4NjogTWFzayBvZmYgcmVzZXJ2ZWQgYml0cyBpbiBDUFVJRC44MDAwMDAwMUgNCj4gDQo+IEtW
TV9HRVRfU1VQUE9SVEVEX0NQVUlEIHNob3VsZCBvbmx5IGVudW1lcmF0ZSBmZWF0dXJlcyB0aGF0
IEtWTQ0KPiBhY3R1YWxseSBzdXBwb3J0cy4gQ1BVSUQuODAwMDAwMDE6RUJYWzI3OjE2XSBhcmUg
cmVzZXJ2ZWQgYml0cyBhbmQgc2hvdWxkDQo+IGJlIG1hc2tlZCBvZmYuDQo+IA0KPiBGaXhlczog
MDc3MTY3MTc0OWI1ICgiS1ZNOiBFbmhhbmNlIGd1ZXN0IGNwdWlkIG1hbmFnZW1lbnQiKQ0KPiBT
aWduZWQtb2ZmLWJ5OiBKaW0gTWF0dHNvbiA8am1hdHRzb25AZ29vZ2xlLmNvbT4NCj4gLS0tDQo+
ICBhcmNoL3g4Ni9rdm0vY3B1aWQuYyB8IDEgKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2NwdWlkLmMgYi9hcmNoL3g4
Ni9rdm0vY3B1aWQuYyBpbmRleA0KPiA0YzFjMmMwNmU5NmIuLmVhNGUyMTNiY2JmYiAxMDA2NDQN
Cj4gLS0tIGEvYXJjaC94ODYva3ZtL2NwdWlkLmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL2NwdWlk
LmMNCj4gQEAgLTExMTksNiArMTExOSw3IEBAIHN0YXRpYyBpbmxpbmUgaW50IF9fZG9fY3B1aWRf
ZnVuYyhzdHJ1Y3QNCj4ga3ZtX2NwdWlkX2FycmF5ICphcnJheSwgdTMyIGZ1bmN0aW9uKQ0KPiAg
CQkJZW50cnktPmVheCA9IG1heChlbnRyeS0+ZWF4LCAweDgwMDAwMDIxKTsNCj4gIAkJYnJlYWs7
DQo+ICAJY2FzZSAweDgwMDAwMDAxOg0KPiArCQllbnRyeS0+ZWJ4ICY9IH5HRU5NQVNLKDI3LCAx
Nik7DQoNCmVieCBvZiBsZWFmIDB4ODAwMDAwMDEgaXMgcmVzZXJ2ZWQsIGF0IGxlYXN0IGZyb20g
U0RNIG9mIEludGVsIHByb2Nlc3Nvci4gRG8gSSBtaXNzIHNvbWV0aGluZz8NCg0KPiAgCQljcHVp
ZF9lbnRyeV9vdmVycmlkZShlbnRyeSwgQ1BVSURfODAwMF8wMDAxX0VEWCk7DQo+ICAJCWNwdWlk
X2VudHJ5X292ZXJyaWRlKGVudHJ5LCBDUFVJRF84MDAwXzAwMDFfRUNYKTsNCj4gIAkJYnJlYWs7
DQo+IC0tDQo+IDIuMzguMC5yYzEuMzYyLmdlZDBkNDE5ZDNjLWdvb2cNCg0K
