Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018AB41D0B5
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 02:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347387AbhI3AoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 20:44:05 -0400
Received: from mga04.intel.com ([192.55.52.120]:56757 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346306AbhI3AoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 20:44:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="223183497"
X-IronPort-AV: E=Sophos;i="5.85,334,1624345200"; 
   d="scan'208";a="223183497"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 17:42:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,334,1624345200"; 
   d="scan'208";a="479576898"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 29 Sep 2021 17:42:20 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 29 Sep 2021 17:42:19 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 29 Sep 2021 17:42:19 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 29 Sep 2021 17:42:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7mWp12oqmDAvphBT3fZDNSDPQfPZqYx+NDA3FtKBXYaob+5V17PvykxgPIUA9eI/5YxT53z9nYRKkptsBvF294DealEFQyANtg6YJTk06Z8ZNTbGBpsK5dgaFaHf/ht6zQjxfuTK8RL/a3Z42cl9Ab3db2104EcfN9SmmXboPjR5luX6fnk5hDLmVAsq5K2W23Vw/bVYNF2DpXbhz1zh21/sJzeVIezmqaPaUo0/+Z7nhcIBAUP/RRPO3YLUpDmX7mMiNSU7SnaCCnnV7w3w6MwHcvIMmTqyHFlnYorPMZI+Hg54CdSwLS33i360fAc3DD+3gklfdDVWTDR8yXIWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=hBp4xCKNevZFnFqD9hAi0C3coJ+q+w8optcKwQ7MMWE=;
 b=L8e9OEQMzh299LjaR3qF7aELob95bCFvW1QKEkhbun1k9RFjsRAbxSjjkMaPRSugvUTAPX5GhukT7aEuv0tUKYLpJ1z5TAqAKv6iPYp+avJDY7g/5+cRz/27Qoio83JU4ALYsxz1Q6mwqd8fAXj+bUdHjduLuG3z6wtC/k9S8pReZdfMN+KMUu8sDBEuvpokwPJbAbDMdKS3cXOkQpsaO27n6csPbkuuDD9w11bdfUtuDaT6aThHYgcbbb9SRlWVMaVcAWGdedqpEz1qIEE2Dkloe3clP34FPPyLXcdF9Zel9UYtTpZVNVyft4JNHs9LXTAay4qpQQjOb76HXsiIEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBp4xCKNevZFnFqD9hAi0C3coJ+q+w8optcKwQ7MMWE=;
 b=jhLPKx++ZOYht0vufr+obdbKxbql30hy/fsJmH03srNqGuFdpVh4F2L6p+c41Kw/nKamkp9QbEWJpENfxs9Mr05DSe6nB8K7K56U7B4LtY2L+bZ3ytWM5X0QrKY6pSCvi4HzwGyKrLnKf1PMshka9SFN3uEti0UyZ+9cFE4JICY=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB3891.namprd11.prod.outlook.com (2603:10b6:405:77::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Thu, 30 Sep
 2021 00:42:16 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.021; Thu, 30 Sep 2021
 00:42:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: RE: [PATCH v3 0/6] vfio/hisilicon: add acc live migration driver
Thread-Topic: [PATCH v3 0/6] vfio/hisilicon: add acc live migration driver
Thread-Index: AQHXqhc5lUNcPisp4UyTMpTu0c9BsKu6db8wgABPxQCAAAa9IIAABOGAgAD+1fA=
Date:   Thu, 30 Sep 2021 00:42:16 +0000
Message-ID: <BN9PR11MB543384431856FEF80C1AA4C58CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <BN9PR11MB5433DDA5FD4FC6C5EED62C278CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <2e0c062947b044179603ab45989808ff@huawei.com>
 <BN9PR11MB54338A0821C061FEE018F43E8CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <a128301751974352a648bcc0f50bc464@huawei.com>
In-Reply-To: <a128301751974352a648bcc0f50bc464@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 905c3232-c630-4715-cb04-08d983ab26cd
x-ms-traffictypediagnostic: BN6PR11MB3891:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB3891B383DEECBE4E1F63D7828CAA9@BN6PR11MB3891.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OcptYXYkWZtokIsYfwD6Ov0Z2P9Xhsl9bKJnn2e4jtDTi/kIR477LvcFIDaDL5t8aWHeG/KYPtfMpDxVQwvb9U0tQ8Lc8Q5LRrGQkpqKBi3wTAkZezss/rggkb2yJTxQ02goqM77O6Ozn7kk4aAIeqRVkyWer1Q+7dLgxSSoit2FeX2HN5SlENDTkUHprxNEarVeE6QRjfeFy5RsYrM83H6spvIEr5opwmPgyPZWMYyt1c0150DaE58zDou3b0UDc2OPJC52XvHY+cxISI3TKLlGjsxoJZDCiGFlVOIvmUzvpLJSTU4sFcnK5by7Xd9bm660qBt/FZV8UA6PQfT8Bdjgy9qfEB/W3AIB7auhsfx1L48tw71w8uBzAA1MLNg508j/oSRT6E9Ub3az1R7GxLdCHK9qEiBeMafppzoKFCwBe3JisiAR6nQINxDDWIzZQbCeqsxXkFYW0mtmzOL0iBI/TtTGE16kUWz090gnPE/gtzw5JPjhOfJX9fbnR4srPI9oLvpY8kBOuB5pgnieYgx9gNitXx2Yl+D22RSqA1PWav81RHd4Q+Qj3Cid976lJVBmFECbrdyvUDd1FG2k794v0BE/g+CZcJckhGDnrpJHTJwBWfGMb9mkxOBfAPteJf8/PLoFT0DYR/9DbsTqnwdXLM9QzyPa7nPsurnt/P1/BwfnKZYfKwGEPv76VEUhFCe0u53HYoX0dnIEbMxG3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(64756008)(8676002)(66446008)(66946007)(38070700005)(66476007)(66556008)(33656002)(86362001)(26005)(71200400001)(8936002)(52536014)(9686003)(76116006)(55016002)(6506007)(122000001)(83380400001)(54906003)(4326008)(110136005)(107886003)(2906002)(186003)(316002)(5660300002)(38100700002)(7696005)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3VPejlKWUtOZ1FsbW1zVW5vVS9UQnJyb2x1b2ZyTHZaOXBISGJwejZIUzBG?=
 =?utf-8?B?aTJzYWlVaVd5ZEd4WFk5aFY5cnJnOXREWE9lc21qUThzRDVnSm5ITXE3dXFY?=
 =?utf-8?B?d1pxNCtlZWVBRXl5azFwWjY2UGxqL3drK0FvTWIwZ3JtTnNtd04zaVBkTWtX?=
 =?utf-8?B?VWZseVZacEdCZ1JtSjNJd0tmek1hcUR1MGcvcW9aUU1rdXZPUmI3NzNkSmZJ?=
 =?utf-8?B?d0RDTFIzTnZNZkl0UC8wbjk0aEF2ak1MTjNXTEdISmlWWTgzRytiUXBMWm95?=
 =?utf-8?B?bWl2NE5DK3NmOVRkdHRaM01jSFJ6VnNCd0Jla0NadmhnT3J4ZkdHMW5CYkNZ?=
 =?utf-8?B?ZHp4Y01CZ0l4WGExZ0pZc0IzdkdZUDQzN2RndUVZUXpkbkpoRW9JdkdEY1NT?=
 =?utf-8?B?bW9LZ2JqY29lS1dSQnZFV2hwdEF3V2RmL3htOUNiaE1sVEU1bWhSQS9UaXU4?=
 =?utf-8?B?NEpVRFZpU0hzWWJISWhjTFlrTjgzakRxSUN1WmtYSlBrZjhHY0ovVlZDeWNB?=
 =?utf-8?B?RUZEK0RQWll2ak80Y0gyQUJNaGdPanJHd09HenRmYTNnOVpia1A1c25SQnVU?=
 =?utf-8?B?aXg1aHE3bVIvTS9xYjlJdHVJeUh3d3hZN1hzRDdlVkprSEgra3ZhOEFiYVhX?=
 =?utf-8?B?eUw4R0xSblB2R0lZd0pRSHFSMHBKV3dZSUR3UzRDN2RaQmE4ZDB0VWtXN0pp?=
 =?utf-8?B?SW4za1NIcGErKzRjSndjYlNjYzFQNFg0bGIwaGQzS2J3Z0NYZXNyK2JTTDR5?=
 =?utf-8?B?dHBGY0NML2RCOXVyYWJMZ2plYkJSUjVoSVo3THBYSFJjT05NMlp0bUhQeUYz?=
 =?utf-8?B?L2xXVGdtQm8wMUwyeTNRdGtHbGxRdW5GbkdHbkkyY1h1ZldWeFF0eWpBay9t?=
 =?utf-8?B?enNSMXhXMm1KYnF3b00zc2EvL0dybjByTCs0eUVFdGRPL1BmaTMwcEFRTHl5?=
 =?utf-8?B?V1lINTNrdU8yZEh1aDVtcGJ3eUZOeW1RZVJ0UFByZ1JEVU4xeUdXamRON25j?=
 =?utf-8?B?VlVEd3VyL1BFMGtNZ21icm8wQXZxZjd2MGhhY0l0bTFxU1RGbEhiSjhwSW5N?=
 =?utf-8?B?N3hmWTZzVmR3ZU42aFFpUmxTWjdybWZWNkt0NElJUy81dU91Zk0vMFRpTG55?=
 =?utf-8?B?S09lOTVuNzJFbDBaSENGMmhTcEJQWU9JUmRNcWl3K2kyQnQ3cUtWQzVORk5M?=
 =?utf-8?B?ZzlKbUVHcSs0Q1VvMkxPQUlObWN1cHozTm1SV3BSVWpqMUNnSEFvZU9takdT?=
 =?utf-8?B?U0tTT1NXYWFDTlcyUjExY3JpN2M4TXBLbG5ydkFkWnYveW1nZGxVRWIwcndF?=
 =?utf-8?B?WXIxUno0c011WUtnQ1lacjhWeUVBMDYyTzFFQWJpWVNURmZVWlVKWG9IZkdl?=
 =?utf-8?B?TnU5TkNhTEQ4bW43eVluejl4WlhaQkIydG5oUkdFeTl4eGdhVXI0M2M3U0kx?=
 =?utf-8?B?dkJERXF1S2tWc21tSUx0Y2FkcFhyWkQzT21QVGYrRXZ5NEcyaEx2SUFFSXF3?=
 =?utf-8?B?MENBeGprSk9jYmpxenBwU2ZtNHNva0xrN1pZTlZPWXlRckFleTVYcW53OHZO?=
 =?utf-8?B?RExodDVqaTZ4SDdMWlRIT1ZHdHY1Sld4S2VTck9OcTgwZ1hkM2h5em1zUWlu?=
 =?utf-8?B?RStrcnhHcTR6UnpSMnkzZld4TUgvZGFqTFFwaUNkeGZHVFFYWGFEZDVzeFlQ?=
 =?utf-8?B?bWl1RHJoOVlsVzdvY3p0VTNnQlpHYlpsWFBiWmlTTjhqaTRLdjhiL1VjS3Vs?=
 =?utf-8?Q?VO69VHMVuw2DJv+WlYWxJjizxIIm0KfJE5uF+rD?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 905c3232-c630-4715-cb04-08d983ab26cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 00:42:16.2257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iyYmtYLk+K/QoNvwB5oOE09QyXo/xnDGslXe7GajjrGvMHQDIViPJtwH87/hVKdJmKYHPmKhS3I8pPrqeUd/zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3891
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBTaGFtZWVyYWxpIEtvbG90aHVtIFRob2RpDQo+IDxzaGFtZWVyYWxpLmtvbG90aHVt
LnRob2RpQGh1YXdlaS5jb20+DQo+IA0KPiA+IEZyb206IFRpYW4sIEtldmluIFttYWlsdG86a2V2
aW4udGlhbkBpbnRlbC5jb21dDQo+ID4gU2VudDogMjkgU2VwdGVtYmVyIDIwMjEgMTA6MDYNCj4g
Pg0KPiA+ID4gRnJvbTogU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9kaQ0KPiA+ID4gPHNoYW1lZXJh
bGkua29sb3RodW0udGhvZGlAaHVhd2VpLmNvbT4NCj4gPiA+DQo+ID4gPiBIaSBLZXZpbiwNCj4g
PiA+DQo+ID4gPiA+IEZyb206IFRpYW4sIEtldmluIFttYWlsdG86a2V2aW4udGlhbkBpbnRlbC5j
b21dDQo+ID4gPiA+IFNlbnQ6IDI5IFNlcHRlbWJlciAyMDIxIDA0OjU4DQo+ID4gPiA+DQo+ID4g
PiA+IEhpLCBTaGFtZWVyLA0KPiA+ID4gPg0KPiA+ID4gPiA+IEZyb206IFNoYW1lZXIgS29sb3Ro
dW0gPHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlAaHVhd2VpLmNvbT4NCj4gPiA+ID4gPiBTZW50
OiBXZWRuZXNkYXksIFNlcHRlbWJlciAxNSwgMjAyMSA1OjUxIFBNDQo+ID4gPiA+ID4NCj4gPiA+
ID4gPiBIaSwNCj4gPiA+ID4gPg0KPiA+ID4gPiA+IFRoYW5rcyB0byB0aGUgaW50cm9kdWN0aW9u
IG9mIHZmaW9fcGNpX2NvcmUgc3Vic3lzdGVtIGZyYW1ld29ya1swXSwNCj4gPiA+ID4gPiBub3cg
aXQgaXMgcG9zc2libGUgdG8gcHJvdmlkZSB2ZW5kb3Igc3BlY2lmaWMgZnVuY3Rpb25hbGl0eSB0
bw0KPiA+ID4gPiA+IHZmaW8gcGNpIGRldmljZXMuIFRoaXMgc2VyaWVzIGF0dGVtcHRzIHRvIGFk
ZCB2ZmlvIGxpdmUgbWlncmF0aW9uDQo+ID4gPiA+ID4gc3VwcG9ydCBmb3IgSGlTaWxpY29uIEFD
QyBWRiBkZXZpY2VzIGJhc2VkIG9uIHRoZSBuZXcgZnJhbWV3b3JrLg0KPiA+ID4gPiA+DQo+ID4g
PiA+ID4gSGlTaWxpY29uIEFDQyBWRiBkZXZpY2UgTU1JTyBzcGFjZSBpbmNsdWRlcyBib3RoIHRo
ZSBmdW5jdGlvbmFsDQo+ID4gPiA+ID4gcmVnaXN0ZXIgc3BhY2UgYW5kIG1pZ3JhdGlvbiBjb250
cm9sIHJlZ2lzdGVyIHNwYWNlLiBBcyBkaXNjdXNzZWQNCj4gPiA+ID4gPiBpbiBSRkN2MVsxXSwg
dGhpcyBtYXkgY3JlYXRlIHNlY3VyaXR5IGlzc3VlcyBhcyB0aGVzZSByZWdpb25zIGdldA0KPiA+
ID4gPiA+IHNoYXJlZCBiZXR3ZWVuIHRoZSBHdWVzdCBkcml2ZXIgYW5kIHRoZSBtaWdyYXRpb24g
ZHJpdmVyLg0KPiA+ID4gPiA+IEJhc2VkIG9uIHRoZSBmZWVkYmFjaywgd2UgdHJpZWQgdG8gYWRk
cmVzcyB0aG9zZSBjb25jZXJucyBpbg0KPiA+ID4gPiA+IHRoaXMgdmVyc2lvbi4NCj4gPiA+ID4N
Cj4gPiA+ID4gVGhpcyBzZXJpZXMgZG9lc24ndCBtZW50aW9uIGFueXRoaW5nIHJlbGF0ZWQgdG8g
ZGlydHkgcGFnZSB0cmFja2luZy4NCj4gPiA+ID4gQXJlIHlvdSByZWx5IG9uIEtlcWlhbidzIHNl
cmllcyBmb3IgdXRpbGl6aW5nIGhhcmR3YXJlIGlvbW11IGRpcnR5DQo+ID4gPiA+IGJpdCAoZS5n
LiBTTU1VIEhUVFUpPw0KPiA+ID4NCj4gPiA+IFllcywgdGhpcyBkb2Vzbid0IGhhdmUgZGlydHkg
cGFnZSB0cmFja2luZyBhbmQgdGhlIHBsYW4gaXMgdG8gbWFrZSB1c2Ugb2YNCj4gPiA+IEtlcWlh
bidzIFNNTVUgSFRUVSB3b3JrIHRvIGltcHJvdmUgcGVyZm9ybWFuY2UuIFdlIGhhdmUgZG9uZSBi
YXNpYw0KPiA+ID4gc2FuaXR5IHRlc3Rpbmcgd2l0aCB0aG9zZSBwYXRjaGVzLg0KPiA+ID4NCj4g
Pg0KPiA+IERvIHlvdSBwbGFuIHRvIHN1cHBvcnQgbWlncmF0aW9uIHcvbyBIVFRVIGFzIHRoZSBm
YWxsYmFjayBvcHRpb24/DQo+ID4gR2VuZXJhbGx5IG9uZSB3b3VsZCBleHBlY3QgdGhlIGJhc2lj
IGZ1bmN0aW9uYWxpdHkgcmVhZHkgYmVmb3JlIHRhbGtpbmcNCj4gPiBhYm91dCBvcHRpbWl6YXRp
b24uDQo+IA0KPiBZZXMsIHRoZSBwbGFuIGlzIHRvIGdldCB0aGUgYmFzaWMgbGl2ZSBtaWdyYXRp
b24gd29ya2luZyBhbmQgdGhlbiB3ZSBjYW4NCj4gb3B0aW1pemUNCj4gaXQgd2l0aCBTTU1VIEhU
VFUgd2hlbiBpdCBpcyBhdmFpbGFibGUuDQoNClRoZSBpbnRlcmVzdGluZyB0aGluZyBpcyB0aGF0
IHcvbyBIVFRVIHZmaW8gd2lsbCBqdXN0IHJlcG9ydCBldmVyeSBwaW5uZWQNCnBhZ2UgYXMgZGly
dHksIGkuZS4gdGhlIGVudGlyZSBndWVzdCBtZW1vcnkgaXMgZGlydHkuIFRoaXMgY29tcGxldGVs
eSBraWxscw0KdGhlIGJlbmVmaXQgb2YgcHJlY29weSBwaGFzZSBzaW5jZSBRZW11IHN0aWxsIG5l
ZWRzIHRvIHRyYW5zZmVyIHRoZSBlbnRpcmUNCmd1ZXN0IG1lbW9yeSBpbiB0aGUgc3RvcC1jb3B5
IHBoYXNlLiBUaGlzIGlzIG5vdCBhICd3b3JraW5nJyBtb2RlbCBmb3INCmxpdmUgbWlncmF0aW9u
Lg0KDQpTbyBpdCBuZWVkcyB0byBiZSBjbGVhciB3aGV0aGVyIEhUVFUgaXMgcmVhbGx5IGFuIG9w
dGltaXphdGlvbiBvcg0KYSBoYXJkIGZ1bmN0aW9uYWwtcmVxdWlyZW1lbnQgZm9yIG1pZ3JhdGlu
ZyBzdWNoIGRldmljZS4gSWYgdGhlIGxhdHRlcg0KdGhlIG1pZ3JhdGlvbiByZWdpb24gaW5mbyBp
cyBub3QgYSBuaWNlLXRvLWhhdmUgdGhpbmcuDQoNCmJ0dyB0aGUgZmFsbGJhY2sgb3B0aW9uIHRo
YXQgSSByYWlzZWQgZWFybGllciBpcyBtb3JlIGxpa2Ugc29tZSBzb2Z0d2FyZSANCm1pdGlnYXRp
b24gZm9yIGNvbGxlY3RpbmcgZGlydHkgcGFnZXMsIGUuZy4gYW5hbHl6aW5nIHRoZSByaW5nIGRl
c2NyaXB0b3JzDQp0byBidWlsZCBzb2Z0d2FyZS10cmFja2VkIGRpcnR5IGluZm8gYnkgbWVkaWF0
aW5nIHRoZSBjbWQgcG9ydGFsDQood2hpY2ggcmVxdWlyZXMgZHluYW1pY2FsbHkgdW5tYXBwaW5n
IGNtZCBwb3J0YWwgZnJvbSB0aGUgZmFzdC1wYXRoDQp0byBlbmFibGUgbWVkaWF0aW9uKS4gV2Ug
YXJlIGxvb2tpbmcgaW50byB0aGlzIG9wdGlvbiBmb3Igc29tZSBwbGF0Zm9ybQ0Kd2hpY2ggbGFj
a3Mgb2YgSU9NTVUgZGlydHkgYml0IHN1cHBvcnQuDQoNClRoYW5rcw0KS2V2aW4NCg==
