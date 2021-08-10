Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF0F3E5621
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 11:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238500AbhHJJBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 05:01:13 -0400
Received: from mga03.intel.com ([134.134.136.65]:47247 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238246AbhHJJBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 05:01:12 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="214891722"
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="214891722"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 02:00:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="674842384"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 10 Aug 2021 02:00:49 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 10 Aug 2021 02:00:49 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 10 Aug 2021 02:00:48 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 10 Aug 2021 02:00:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 10 Aug 2021 02:00:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLD3Nqs55ThgpZbzdDWg9q3HCLl49dpk0TLEzigATczi2ZPc1jB8zFKuEnBsw/oUceq2R3sLfTLx+xmCbqz5WJjT+0yc1yFmPZq+C6oSAbXWLy+ViMpQOHGNaoqxE3EEIsdt4Vzrrb99VDB9nL+9mJt1huBeG0T1iikbvH3OcKwiy9uAfI7qbl5lSHTptbcpi1qD0VGOtfr0GYyg/8Thiw6G38ybZsiYIOwS5cVzfeOCVEUtUotUXf/K2A3BTDIQqBfdr8QDtj7qSJ/GZPwTc0LaXRsUmDJVmED92uj68tXawTaPzUqb5msNHdEZS9vUHL0qaEcjpVSiKFASGsUKQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=28QU3ywfJ6mY3KfB4laItfoLqhJNqq7GOeFa1Uxl4Nw=;
 b=bs+YevTRcQJsgMtY1/IUwp3WTnsaqYa0BMIfMBlBQgZrFySil9n5gBTMdmvEOs/eTSzMTtBWmsGtPWOXMe4qoxujxk2U7XpJiLXlrd2S/yQjid2wZXi43PfulPaW0psQV44bgHQq7qTNvIBqsqPYyAESmu2mG4qAcEak64x3ljNoPXHLEnmUsK7PU/DoQt1/QlOoGRRjLz5+7KBoNAMjsN3oRtFa7HIYERMR2vTT23DYsiXEEEalWp0rHfN86CFC4oxAkckvKYP4W/+dItHrZV2s7BuO1dpm1an/Ykp4Cbc7Sy/KqD6c410E/iehdUSvDDAGnnh5NnSM44Omt1HDog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=28QU3ywfJ6mY3KfB4laItfoLqhJNqq7GOeFa1Uxl4Nw=;
 b=PPLKD4CSZwsRgZA/2tWXp8FfozJ/xQZ0KRzRZxpvNCOSiSSwTw3LJSwLI94QFCeohogqV5GXpoVSLq9K0E2XkmRKSF0Q5yIjj31EIfsxBN0MYNrrM55+c4dIOffZ/eVNK1gmTAmHKFcUIjO/nXMCpMqAYiGwy2U90p/TR2toDq4=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN7PR11MB2753.namprd11.prod.outlook.com (2603:10b6:406:b0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 09:00:46 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce%4]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 09:00:46 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Jason Wang" <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>
CC:     Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: RE: [RFC v2] /dev/iommu uAPI proposal
Thread-Topic: [RFC v2] /dev/iommu uAPI proposal
Thread-Index: Add0lrMH87IsTsl5Rp6WN1oQU6kGMQUsvqiAAA+DMpABDABXAAACjD3g
Date:   Tue, 10 Aug 2021 09:00:46 +0000
Message-ID: <BN9PR11MB5433FC19698D3A86B63850128CF79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <b83a25de-7c32-42c4-d99d-f7242cc9e2da@redhat.com>
 <BN9PR11MB5433453DED3546F5011C3BDD8CF29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <cec41751-c300-40f2-a8d6-f4916fb4a34e@redhat.com>
In-Reply-To: <cec41751-c300-40f2-a8d6-f4916fb4a34e@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b98c53e-1673-4ab6-18d0-08d95bdd579a
x-ms-traffictypediagnostic: BN7PR11MB2753:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR11MB275324BD1004817920433A818CF79@BN7PR11MB2753.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3b3RaL+evn1DLzmBogSn1l/+ClUVShF9no3E6c/svWa6GtfRFN0tTTMJWNFJnJBbepS5QBvvRPynGtRjQOyZvbufI0j4/+OCCL9KyxRV0Xf4UnaASFqp6Wlzl4GfGrYsjCWUmddt+zZBbG9hI8PTunWbK8/cSdMMHryHEEqYI89esXH6rUdiKYTLvmNzCLu5n3CmMPOT3GSy9P7w+NXzS1HhDdU8BSurmgy4btToWF7DYKyI+iNgM+2EpwlncazV2DLqncV32I5zK8PKiWfHEqgZgW/7EtwipjxiyOYi+x0IwB4tkTzj/ya9u+B4OLoHqwplpphnypkea32JJsKMqlJxQWvEefiG4UiL5rN5N/mToCaSFLkcjGOKO+OZrSQ/SONJCyzSNnAujf6X+BloSLR8HEJ4vJfTrGaisAd7jtn+Uuqfoc7r4MEVDBmT9zM4f+LqQFFQlBWE4s3c5P7ofhNFjirjH1EUnBT+9vXDsMxyQ1XEkUfeNwdwKVympEfkLSbgq0V3Rifguc9wFGGcsWDg18sO3dNvk30M1xvpDv+9LLWWqPIWnEjdvVeMaAeZ1amEs7GcqPIokV29KZJV7FP3BMKBVlRmJ+exzmm1Za8JjSkCzPfFtDhAT468G1+1pFEHDCf4AATlEPPNtexkzJkmqNxpkZR+Oz7bk8uFP89V61UNGzk3GElXJlKnylCkuDEvB9exOIoW5nWkjaRYTClX/nlKK9v18wuF2fxAlkjIbg9wiSsRZlX0lglcTB9xhFXi3O9uyhJUXU5OvNp8eomZ6a6hOuBw+zYEik0MeVssXwdKj4gTviQfHVeRE2kL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(110136005)(9686003)(55016002)(38100700002)(83380400001)(76116006)(52536014)(8676002)(54906003)(316002)(122000001)(2906002)(38070700005)(33656002)(26005)(966005)(4326008)(8936002)(64756008)(478600001)(186003)(7696005)(71200400001)(5660300002)(66946007)(921005)(86362001)(66476007)(53546011)(6506007)(7416002)(66556008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnZES1lkUERpZ3NNdmlDclUvdU1nWFpCWS96MVdCcEhmRE9QSG1iblNTbVZL?=
 =?utf-8?B?WGg4Y1VhK29MeFg0RlFUNzhtMTBQT0hTZkJJR0E5R2YwZ2Vyc09HbWtFRGg2?=
 =?utf-8?B?Y2hBcW5qRVc5VW1oeFBSeWc3ci9CYlVwM09nMmJyRzdQSStaS0w3MFM3QnRN?=
 =?utf-8?B?UGtzRFR6L0xyMGw2R09UMkZJUUt4MGRkNVE4ZWlDNUlnWUZrTWZRbmlaaks4?=
 =?utf-8?B?SnBJbi93Z0JNYmVLVGI3Uk0ySmo0cTA5OTJtcmVENVJaUEZmN245V3RhVDJy?=
 =?utf-8?B?MEl1OThGTWFFQUdnTUFqbjZoUjNOSy9UQnZwWjlETW9BYzYwaVdjM0dJQkRJ?=
 =?utf-8?B?QTVLNlFkSFhSYlFRVWp4UWEwSnNBNllzTlJXVFlSRTJCMlhveTNNMS9WbmJt?=
 =?utf-8?B?ZWFaWVZDcWVCRzNLVmRsZzNtRDAvQW5XdkhyUjVZRUx6UTlia01vRjE1dUk5?=
 =?utf-8?B?QkNHVzdMZGVBQlh1cFRML3pTdysxbjJyMkpES3RyejMrb2Q3b3N5WkV0R0o5?=
 =?utf-8?B?SWJFck9DM3Q0Y3Nka21ZRkN4Y2IvWDBoMi9UT1d3ZUJyanZkY1JJUWlnVnYz?=
 =?utf-8?B?QURIQ2JqZW5sakJYQU1OYnoxM2MyOFZySHdnMUtHRy9ZaU5QcXM4clJqTmtL?=
 =?utf-8?B?THAxK2xYZ3Q4eXFqOUQwbkM4K3VhMkdZQ3ErbG0wNy9neDJPVnVybHZVcGMw?=
 =?utf-8?B?aUYyd0JWcTdGTU5ZVjBXczZlZHh5LzlOZWFwRUYvZXJJMDM4bkRHNXFnTTdt?=
 =?utf-8?B?K1oxR01QOVBJbVY3ZmJldVU0YWpLbjZkS0JzNFQ4N1NYZHNESmlFSmJESzBp?=
 =?utf-8?B?VE5ETU9YSlhrZldJOFJIT2JoS29NQlFIOW1VVVJQTGwxM2F2RUdXZ2tTRHRs?=
 =?utf-8?B?cFVaM0xVSjZ5K25UZWVhaXl6dUc3TTcwWkVFcGNLUTZ2a0pIcjh2eTZZcy9I?=
 =?utf-8?B?QXN0cjZPK0VuM1lnQ2Jwd3I3SkZLbVhDTE1kM1ZMZ1UwUldFWnJLZ1NNZzhM?=
 =?utf-8?B?ZGMyR2d1blQzZE9FaU12M3kwcFVEL3VLYmp2a3lTQWMxc2ZhQklMd21oNmp3?=
 =?utf-8?B?M1g0NnlQVStacjc2dUxOWEo5MlNOb0tIbGsyQ3g4eFRZUXFIQnJrNUxjOXhJ?=
 =?utf-8?B?RUxNZHN3YTV4dnZ5NVVwMERHUlk3WGVRajdBcDd3MUZjL0xWWDdLeDNRdHZp?=
 =?utf-8?B?Y0NoRlc0VFdrdUxSbWNyVzFhS1BQMXVGaGlLOElBUXg5QUZVcHR5U2dLckFV?=
 =?utf-8?B?T1g4cGRyeDFmb2lENFhxSWw4S3N4YTZScUpVR2hYLzdvSFVEU0JEdXB0WlJV?=
 =?utf-8?B?alIyMWdWakJ3M3QrZDE3VkRJdDUxK1NUaDkweThJNmEyQkZvL3dQY2lpeHNa?=
 =?utf-8?B?eDhuV1hPMWxIV05Ha3ZDZE5XZkZBR2NJSzEvRVhGdGRvUnhPVTVwYlV6b0dG?=
 =?utf-8?B?WVNtSzRMYmtjUkJEd1VyTFFHWGZyUTh4YUJPMGF1VUZ6NjZnWnZ1eG11eE5p?=
 =?utf-8?B?a29aOHVKNGFkUmhwYTRaTlVQZzVJS3RORUJOTzZuYnNESjFsYlc1WHBCZkpp?=
 =?utf-8?B?NlI2dGRzdVQybndvamtFNndyNk5NWlZkVEhpM0FROFpMRkpYbitLMlMyczZG?=
 =?utf-8?B?c1EyTEY3TDZmblZROHJVNzJRakxjWVg2TnhLNTRYamhsRzVHK3J5MGlWRzJP?=
 =?utf-8?B?Z3lheWVPMnZLcWlvM2lLeHNjY1JLNzY0Nkhvc2hZQW9ibUFQblU0K3IrOHJW?=
 =?utf-8?Q?Gczp54wH0B9CaJyjzDoHtDrnlB44YhU9WK7E8VR?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b98c53e-1673-4ab6-18d0-08d95bdd579a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 09:00:46.3918
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8i+Fk8BrcMg9mEQkN+EUP5vuDwz/OWahSihQ9vzdA3yHuffuC6usEMqv+k7/ulUeoXiEUUORzxkXoHjBPEjiHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2753
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFR1ZXNk
YXksIEF1Z3VzdCAxMCwgMjAyMSAzOjE3IFBNDQo+IA0KPiBIaSBLZXZpbiwNCj4gDQo+IE9uIDgv
NS8yMSAyOjM2IEFNLCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPj4gRnJvbTogRXJpYyBBdWdlciA8
ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiA+PiBTZW50OiBXZWRuZXNkYXksIEF1Z3VzdCA0LCAy
MDIxIDExOjU5IFBNDQo+ID4+DQo+ID4gWy4uLl0NCj4gPj4+IDEuMi4gQXR0YWNoIERldmljZSB0
byBJL08gYWRkcmVzcyBzcGFjZQ0KPiA+Pj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrDQo+ID4+Pg0KPiA+Pj4gRGV2aWNlIGF0dGFjaC9iaW5kIGlzIGluaXRpYXRlZCB0
aHJvdWdoIHBhc3N0aHJvdWdoIGZyYW1ld29yayB1QVBJLg0KPiA+Pj4NCj4gPj4+IERldmljZSBh
dHRhY2hpbmcgaXMgYWxsb3dlZCBvbmx5IGFmdGVyIGEgZGV2aWNlIGlzIHN1Y2Nlc3NmdWxseSBi
b3VuZCB0bw0KPiA+Pj4gdGhlIElPTU1VIGZkLiBVc2VyIHNob3VsZCBwcm92aWRlIGEgZGV2aWNl
IGNvb2tpZSB3aGVuIGJpbmRpbmcgdGhlDQo+ID4+PiBkZXZpY2UgdGhyb3VnaCBWRklPIHVBUEku
IFRoaXMgY29va2llIGlzIHVzZWQgd2hlbiB0aGUgdXNlciBxdWVyaWVzDQo+ID4+PiBkZXZpY2Ug
Y2FwYWJpbGl0eS9mb3JtYXQsIGlzc3VlcyBwZXItZGV2aWNlIGlvdGxiIGludmFsaWRhdGlvbiBh
bmQNCj4gPj4+IHJlY2VpdmVzIHBlci1kZXZpY2UgSS9PIHBhZ2UgZmF1bHQgZGF0YSB2aWEgSU9N
TVUgZmQuDQo+ID4+Pg0KPiA+Pj4gU3VjY2Vzc2Z1bCBiaW5kaW5nIHB1dHMgdGhlIGRldmljZSBp
bnRvIGEgc2VjdXJpdHkgY29udGV4dCB3aGljaCBpc29sYXRlcw0KPiA+Pj4gaXRzIERNQSBmcm9t
IHRoZSByZXN0IHN5c3RlbS4gVkZJTyBzaG91bGQgbm90IGFsbG93IHVzZXIgdG8gYWNjZXNzIHRo
ZQ0KPiA+PiBzL2Zyb20gdGhlIHJlc3Qgc3lzdGVtL2Zyb20gdGhlIHJlc3Qgb2YgdGhlIHN5c3Rl
bQ0KPiA+Pj4gZGV2aWNlIGJlZm9yZSBiaW5kaW5nIGlzIGNvbXBsZXRlZC4gU2ltaWxhcmx5LCBW
RklPIHNob3VsZCBwcmV2ZW50IHRoZQ0KPiA+Pj4gdXNlciBmcm9tIHVuYmluZGluZyB0aGUgZGV2
aWNlIGJlZm9yZSB1c2VyIGFjY2VzcyBpcyB3aXRoZHJhd24uDQo+ID4+IFdpdGggSW50ZWwgc2Nh
bGFibGUgSU9WLCBJIHVuZGVyc3RhbmQgeW91IGNvdWxkIGFzc2lnbiBhbiBSSUQvUEFTSUQgdG8N
Cj4gPj4gb25lIFZNIGFuZCBhbm90aGVyIG9uZSB0byBhbm90aGVyIFZNICh3aGljaCBpcyBub3Qg
dGhlIGNhc2UgZm9yIEFSTSkuDQo+IElzDQo+ID4+IGl0IGEgdGFyZ2V0dGVkIHVzZSBjYXNlP0hv
dyB3b3VsZCBpdCBiZSBoYW5kbGVkPyBJcyBpdCByZWxhdGVkIHRvIHRoZQ0KPiA+PiBzdWItZ3Jv
dXBzIGV2b2tlZCBoZXJlYWZ0ZXI/DQo+ID4gTm90IHJlbGF0ZWQgdG8gc3ViLWdyb3VwLiBFYWNo
IG1kZXYgaXMgYm91bmQgdG8gdGhlIElPTU1VIGZkDQo+IHJlc3BlY3RpdmVseQ0KPiA+IHdpdGgg
dGhlIGRlZlBBU0lEIHdoaWNoIHJlcHJlc2VudHMgdGhlIG1kZXYuDQo+IEJ1dCBob3cgZG9lcyBp
dCB3b3JrIGluIHRlcm0gb2Ygc2VjdXJpdHkuIFRoZSBkZXZpY2UgKFJJRCkgaXMgYm91bmQgdG8N
Cj4gYW4gSU9NTVUgZmQuIEJ1dCB0aGVuIGVhY2ggU0lEL1BBU0lEIG1heSBiZSB3b3JraW5nIGZv
ciBhIGRpZmZlcmVudCBWTS4NCj4gSG93IGRvIHlvdSBkZXRlY3QgdGhpcyBpcyBzYWZlIGFzIGVh
Y2ggU0lEIGNhbiB3b3JrIHNhZmVseSBmb3IgYQ0KPiBkaWZmZXJlbnQgVk0gdmVyc3VzIHRoZSBB
Uk0gY2FzZSB3aGVyZSBpdCBpcyBub3QgcG9zc2libGUuDQoNClBBU0lEIGlzIG1hbmFnZWQgYnkg
dGhlIHBhcmVudCBkcml2ZXIsIHdoaWNoIGtub3dzIHdoaWNoIFBBU0lEIHRvIGJlIA0KdXNlZCBn
aXZlbiBhIG1kZXYgd2hlbiBsYXRlciBhdHRhY2hpbmcgaXQgdG8gYW4gSU9BU0lELiANCg0KPiAN
Cj4gMS4zIHNheXMNCj4gIg0KPiANCj4gMSkgIEEgc3VjY2Vzc2Z1bCBiaW5kaW5nIGNhbGwgZm9y
IHRoZSBmaXJzdCBkZXZpY2UgaW4gdGhlIGdyb3VwIGNyZWF0ZXMNCj4gICAgIHRoZSBzZWN1cml0
eSBjb250ZXh0IGZvciB0aGUgZW50aXJlIGdyb3VwLCBieToNCj4gIg0KPiBXaGF0IGRvZXMgaXQg
bWVhbiBmb3IgYWJvdmUgc2NhbGFibGUgSU9WIHVzZSBjYXNlPw0KPiANCg0KVGhpcyBpcyBhIGdv
b2QgcXVlc3Rpb24gKGFzIEFsZXggcmFpc2VkKSB3aGljaCBuZWVkcyBtb3JlIGV4cGxhbmF0aW9u
IA0KaW4gbmV4dCB2ZXJzaW9uOg0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1pb21t
dS8yMDIxMDcxMjEyNDE1MC4yYmY0MjFkMS5hbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbS8NCg0K
SW4gZ2VuZXJhbCB3ZSBuZWVkIHByb3ZpZGUgZGlmZmVyZW50IGhlbHBlcnMgZm9yIGJpbmRpbmcg
cGRldi9tZGV2Lw0Kc3cgbWRldi4gMS4zIGluIHYyIGRlc2NyaWJlcyB0aGUgYmVoYXZpb3IgZm9y
IHBkZXYgdmlhIGlvbW11X3JlZ2lzdGVyXw0KZGV2aWNlKCkuIGZvciBtZGV2IGEgbmV3IGhlbHBl
ciAoZS5nLiBpb21tdV9yZWdpc3Rlcl9kZXZpY2VfcGFzaWQoKSkgDQppcyByZXF1aXJlZCBhbmQg
dGhlbiB0aGUgSU9NTVUtQVBJIHdpbGwgYWxzbyBwcm92aWRlIGEgcGFzaWQgdmFyaWF0aW9uIA0K
Zm9yIGNyZWF0aW5nIHNlY3VyaXR5IGNvbnRleHQgcGVyIHBhc2lkLiBzdyBtZGV2IHdpbGwgYWxz
byBoYXZlIGl0cyBiaW5kaW5nIA0KaGVscGVyIHRvIGluZGljYXRlIG5vIHJvdXRpbmcgaW5mbyBy
ZXF1aXJlZCBpbiBpb2FzaWQgYXR0YWNoaW5nLg0KDQpUaGFua3MNCktldmluIA0K
