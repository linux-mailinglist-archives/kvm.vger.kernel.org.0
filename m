Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2FB39B90E
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 14:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhFDMeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 08:34:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:5593 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhFDMeI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 08:34:08 -0400
IronPort-SDR: 52MAQpH+JEm8Zghp4QL+zHOaKV+yP6Nq7NlPH/OgeXOV2L0kga1Ks0ADGMb2hRetAxfPo+88lJ
 TiqJSj/oH5Ew==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="191389326"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="191389326"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 05:32:21 -0700
IronPort-SDR: 26mkCQiLByzzfrahWLke9/SXtFsT5wXqYuNB+7mwinsh7/n9my9gJOYaYuIUC/cU4x8zSvUspQ
 27MX3OzuVhkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="618246638"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 04 Jun 2021 05:32:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 4 Jun 2021 05:32:20 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 4 Jun 2021 05:32:19 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 4 Jun 2021 05:32:19 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 4 Jun 2021 05:32:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bg3Nu22AcsgAPf2Wi+a4ZOyVmjqAoPGaG5XPiWsCraCsj4ElmnxQeXRKHaUBnktt2nibo4TDnJRYaNk3GwcFXpy2gtIjGmL401Ztd40/o5rmw7O/GOK7O2VpT8i2LmiAhyuN6n4MlE1YFJ38KPrGlwvThywXjVA+XjPNXy2tgzbqmMExCbwCyXzE0FjCftmBUGqdVdcQVVjumLB4vAVY0ctRb0pM1vSU6PX2sRTSsK0Iso466mkLMDUYRvbI7TBBi5kyHOos2TiPj/zPPlbhBvmsBf8G0dy0vT7BahZen0ySpSPjGmqu5Uh3Bc0EpQ5FEbA3xmI8IRMJjFCCdDz9Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6clbl1K3oxdfurPafBJE28oqUsIYJVfo7DPgvnc3K0=;
 b=gvKkaSjI+wsQBgdUqtiWpbAcWEsZYrKmpdQXIr5voBRVoK3Qmwh1iP1Yt4eZDIAGj/xKUibD1FTd9fNNSJozXsiHBN8hhv7qxg+XFfTfAq4rrho+zCpqxwS/4jkVq1Ov0eonw21wjbecdIkbi0A0EnpDqV+0OhjKvH27bCGbxHzMFPoYlML+gOp5CwVNKxAr6Bev/j/IhyFZedR9TY0yvJObM4i3kVbRaiseHHqAt5Ud1ebuIZwf8p1GwXgC1A+jOgV3pImF+PUY7VX8nMCOOYkepM1b1wYppUqBNfN0GtMeB5A4ghmPBbfkFmCCncRq+z+jRfuXKL9Uv0hs9UbYCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6clbl1K3oxdfurPafBJE28oqUsIYJVfo7DPgvnc3K0=;
 b=a1OY3DhYIFrTySBNpCA6NmNQniRfn6DJn60RMzNxhgoNqXeytQJTtxLtdhMBbqPgWgcn2laUVU/aLXLXuFNYnBJi6d4PlsMSSF7HxCvuoB9CWVEH/S76sR3XkGfDR/OzXBDM9kn3kyQ6bxA1xpsWJppCiFxcCIlmOHjrrRQS9fE=
Received: from DM6PR11MB3115.namprd11.prod.outlook.com (2603:10b6:5:66::33) by
 DM6PR11MB3850.namprd11.prod.outlook.com (2603:10b6:5:13c::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.24; Fri, 4 Jun 2021 12:32:18 +0000
Received: from DM6PR11MB3115.namprd11.prod.outlook.com
 ([fe80::6d2f:50ab:cdf0:3465]) by DM6PR11MB3115.namprd11.prod.outlook.com
 ([fe80::6d2f:50ab:cdf0:3465%7]) with mapi id 15.20.4173.030; Fri, 4 Jun 2021
 12:32:18 +0000
From:   "Sun, Yi" <yi.sun@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [kvm-unit-tests PATCH 2/2] x86: Create ISO images according to
 unittests.cfg
Thread-Topic: [kvm-unit-tests PATCH 2/2] x86: Create ISO images according to
 unittests.cfg
Thread-Index: AQHXWOo86XUHYgZSU0qrii8ea7woGasDK0uAgACXPHA=
Date:   Fri, 4 Jun 2021 12:32:17 +0000
Message-ID: <DM6PR11MB311557D8C203529903BEFB2F993B9@DM6PR11MB3115.namprd11.prod.outlook.com>
References: <20210604023453.905512-1-yi.sun@intel.com>
 <20210604023453.905512-2-yi.sun@intel.com>
 <30FA4AAE-DBC9-4DB7-8742-079F2B3067C3@gmail.com>
In-Reply-To: <30FA4AAE-DBC9-4DB7-8742-079F2B3067C3@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8edaa2a1-ce49-4125-a8c6-08d92754caa2
x-ms-traffictypediagnostic: DM6PR11MB3850:
x-microsoft-antispam-prvs: <DM6PR11MB3850BD52E380FBAB43502155993B9@DM6PR11MB3850.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nDZ7sIBFgi7KEvbmcai2lw+IqJC3hF4HvPvVI+OPFYY0lzQBPe2smzM1Z9OKdZBqDQ53uTUMdCc7hIN34+oWpx8b/snbjon1IyqO8jtUD7Xu0xbAarCzc5HuuNjRpfkUa+vy8DZ4tfn+xuhFePTr9IK3V2P9r81F3D+ENsrdIc7dZr4VV1f975/ZJdBzvVfmYuyEW9XC9tiV5NGhIMA7KdEGnT5NPKYWJ2ODyD/vQmr+tpWKGbeJzuI2LjzcPQpm/tZJXFjOkBE7F7pLRzdGjhfqa2klmR42iJrSOt0Mr7bCjJ7siBKkv/ZTj6XYsE9dhCNUQ+rOCVE3BQXa6AOZ6MT8ebv5ATsNmNbvj2SB0gMQSRXa32mnf62IP4MwYgj9y9+AaQs5yHaN3aNHO/J4jKzyOvbo0b7eqSTB5YwgJD2s+9n21C1GQ8wVLsEz5ug++zsGMX2znEYlVcvJbJjY9wlRLGovZal7QlH7MbkxOP9N/qfo8dr60S7z0+t84ZS1fDd8GfSejGOYUz7MwMCMieeNoq4FYEP8ySZjLK/WmnrJrjLo+Vr5L9uI3iUTWkP3Lxzb7qNsH7pDG9xoB2ovn4ednvBkbscsgdxmhXQXR5Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3115.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39860400002)(396003)(53546011)(6506007)(7696005)(26005)(186003)(38100700002)(122000001)(71200400001)(316002)(52536014)(86362001)(64756008)(76116006)(66446008)(66476007)(66946007)(55016002)(66556008)(5660300002)(2906002)(6916009)(8936002)(9686003)(8676002)(4326008)(83380400001)(478600001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?a1VGc2FWZ1hPTlNkaElPbU81MjIyTnR2UUdRKy9aSGZNeC9ZVk9HUitYSTA1?=
 =?utf-8?B?OFZ3bks5dE1hKzRWME5KUVFldWlrQVFKS1NScVQ4VWRoMWJMUDh3dWpnbnQ2?=
 =?utf-8?B?NE96dTlZQlpTOHliZzlRaTQrNTJBV1o5dGVTK1hkTWgvQTJXc21kU0xrcEc3?=
 =?utf-8?B?TVlMZW9IQjAvWVc5Y3JpdnNxcktxQm40Y1R5bWxVUTBhUVU3c2pQSEtqMExl?=
 =?utf-8?B?RVhBa1g4Si81N3RhaGFNTkVmcGx3bmVsK3d0Q2pnVStEYnpNR1QyNVV5RlQ0?=
 =?utf-8?B?VHF4emxuN3RoOWlQcWZHSzBERjBiYzNkekoxWkhoWGo3MkF5OFBlR2twSDds?=
 =?utf-8?B?RTgwbUo0cE1vdTdLSjA3N3V2RDY0NXJFTWJrT1R3QitRRlB2N2ZpMklYQ2th?=
 =?utf-8?B?Zm41MjM0clhrSGJ3N3g0MU1VN0RqeTBsK1MzK2VuSWhRRzhhK3RhZnUyNmlC?=
 =?utf-8?B?a0RneC9HWDNjRXlzU1lua3RsRzBmNjNlTlZYcTVWVnlHUUFRc1B5M1JNSVM1?=
 =?utf-8?B?VUJmaEF3MkJZSE1SMnZpZmdsVEk0VkpkOWdkTXJVcFZ5SURkZlFMZlpBbkdS?=
 =?utf-8?B?cWNrU2MvaGxEUXk0emRZSUpZNXVmRGw5SllsY2c0eDdIZUlGMjBkS2xNRC9o?=
 =?utf-8?B?SzA2VG9PZ3htUndqZnJ0U21ndExQcFpqcWY4VDNBMkZ3K0dHS3NZNHlteVdO?=
 =?utf-8?B?TFlvVk9YU3JpRXIzQ3NwOTRUUnp4L3RoK2NhVnNKWHdybVRTc0YzellYd2pt?=
 =?utf-8?B?SXNleDhiNnpQZDBhOGFoYmRwckRCZElYZmk4V2dKQnFYRDloc1U5bTJCSjhX?=
 =?utf-8?B?VkVNYXROLzdBV1l5MHNmZ21JaW5rZnNzZVQyaUV3WWFubCtLOEt1SGRTK0Qr?=
 =?utf-8?B?SGZzTTRaQUt4a0FIbHdEano1eEZEWFBpcE9FdlBxNnpVUW9ueVZXY3NnT1FS?=
 =?utf-8?B?SnRSZ0JzQmMvd1JzcDlqNUdlY0o4M2h1OFIydFJ1dEZsblRKYWpXbDZNRkVk?=
 =?utf-8?B?RlFwRjM2bEFkNlZhQ2xlVnI3NFBvRlZYMWRGWlJCSW54ZkxzNndsNzVLeEJj?=
 =?utf-8?B?dWxDdlhOVnpCU1N6SlBhK3pQYWdzU1ZFUTFwNkJmOTZsUHh1RmRaeStGY3Ri?=
 =?utf-8?B?YzBnYTdyVWNJQzVxbmZFbjlaZTE5OUpDRHpIWW02SjRSVHM1VzdKK0tqQ2do?=
 =?utf-8?B?cWlVbVhIV3NYQzlOQi9IWTgvTzVSTXM2bEJPalhZallRdU43SjFzWFhVQk1k?=
 =?utf-8?B?L2ZJaWFxeU1hMVg0UHpNZThCd1VQd2tuNUo1NDdzZTBaeXZWTnV3Qndrb2ZI?=
 =?utf-8?B?MEJBdWpHWjlHeGpiNnJ3ZVlVOGEwM1JUWDFjd0xEYTFpdDNTOTVzRkNTNkZQ?=
 =?utf-8?B?ZHZUcUpVY3FUZG5uSzZkRnVNZWVOSm5JQnNKdXk1Yi9kM0QybzI1eEhWcVV4?=
 =?utf-8?B?S0tyeEdFN2hZcUZhZ0V4czliQXhoSzdwbDVyRTNjYjlpL2N5TGwraEYxOU4w?=
 =?utf-8?B?SmYrdCtubHFBUjZQUGsva3NuTDh5OStOU2ZvVktEbUtaeU50V2RmNFFBOFQw?=
 =?utf-8?B?WHFub1ZNYklBalk2bDh1MkhReXlBcngxT3BVYVRwRDc4b1JHV2lvaUxGWGNE?=
 =?utf-8?B?VkE2Y1dDcXdPWnF0L3VtQWhLcXVTTm53TGg1UmF1ckFoNVozRzNvRmRqVTBX?=
 =?utf-8?B?QjY2SjhaT0VYRnRac2thdEZWVzNyS1FZdWRrLzluNGY2VU5kNjNPTytTRmtu?=
 =?utf-8?Q?TP9V99xLU3pk5AdabnN9SalJxx/inoq7uIOAzBN?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3115.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8edaa2a1-ce49-4125-a8c6-08d92754caa2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 12:32:17.9020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ql3rlKVK2TAjLQiZV6P3bpoXXwNxnA4HyVPzHalVAhW5T/kbuE/pEwwsDe/vYOl7lQ8TJYn5Uxs8+qlYODLvAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3850
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgTmFkYXYsDQoNCkxldCBtZSBjb25maXJtIGlmICBJIGdvdCB3aGF0IHlvdSBtZWFudC4gRG8g
eW91IHdhbnQgdGhlIGdydWIgZW50cnkgbG9vayBsaWtlIGZvbGxvd2luZz8gDQpUYWtlIGNhc2Ug
bWVtb3J5IGFzIGFuIGV4YW1wbGU6DQpBZGQgbW9kdWxlIGNvbW1hbmQgbGluZSB0YWtpbmcgJy9i
b290L21vZHVsZScgYXMgaXRzIHBhcmFtZXRlciwgbWVhbndoaWxlIHBhY2thZ2UgdGhlIGZpbGUg
J21vZHVsZScgaW4gdGhlIGZvbGRlcj8NCg0KbWVudWVudHJ5ICJtZW1vcnkuZWxmIiB7DQogICAg
bXVsdGlib290IC9ib290L21lbW9yeS5lbGYgIHRzY2RlYWRsaW5lX2ltbWVkDQogICAgbW9kdWxl
ICAgL2Jvb3QvbW9kdWxlICAgICMgQWRkIG9uZSBsaW5lIGxpa2UgdGhpcyA/DQp9DQoNClRoYW5r
cw0KICAgIC0tU3VuLCBZaQ0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206
IE5hZGF2IEFtaXQgPG5hZGF2LmFtaXRAZ21haWwuY29tPg0KPiBTZW50OiBGcmlkYXksIEp1bmUg
NCwgMjAyMSAxMTowNg0KPiBUbzogU3VuLCBZaSA8eWkuc3VuQGludGVsLmNvbT4NCj4gQ2M6IGt2
bUB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtrdm0tdW5pdC10ZXN0cyBQQVRDSCAy
LzJdIHg4NjogQ3JlYXRlIElTTyBpbWFnZXMgYWNjb3JkaW5nIHRvDQo+IHVuaXR0ZXN0cy5jZmcN
Cj4gDQo+IA0KPiANCj4gPiBPbiBKdW4gMywgMjAyMSwgYXQgNzozNCBQTSwgWWkgU3VuIDx5aS5z
dW5AaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IENyZWF0ZSBJU08gaW1hZ2UgYWNjb3JkaW5n
IHRvIHRoZSBjb25maWd1cmUgZmlsZSB1bml0dGVzdHMuY2ZnLCB3aGVyZQ0KPiA+IGRlc2NyaWJl
cyB0aGUgcGFyYW1ldGVycyBvZiBlYWNoIHRlc3QgY2FzZS4NCj4gPg0KPiANCj4gTG9va3MgY29v
bCENCj4gDQo+ID4gZGlmZiAtLWdpdCBhL3g4Ni9jcmVhdGVfaXNvLnNoIGIveDg2L2NyZWF0ZV9p
c28uc2ggbmV3IGZpbGUgbW9kZQ0KPiA+IDEwMDc1NSBpbmRleCAwMDAwMDAwLi44NDg2YmU3DQo+
ID4gLS0tIC9kZXYvbnVsbA0KPiA+ICsrKyBiL3g4Ni9jcmVhdGVfaXNvLnNoDQo+ID4gQEAgLTAs
MCArMSw3MSBAQA0KPiA+ICsjIS9iaW4vYmFzaA0KPiA+ICtzZXQgLWUNCj4gPiArY29uZmlnX2Zp
bGU9JDENCj4gPiArDQo+ID4gK29wdHM9DQo+ID4gK2V4dHJhX3BhcmFtcz0NCj4gPiAra2VybmVs
PQ0KPiA+ICtzbXA9DQo+ID4gK3Rlc3RuYW1lPQ0KPiA+ICsNCj4gPiArDQo+ID4gK2dydWJfY2Zn
KCkgew0KPiA+ICsNCj4gPiArCWtlcm5lbF9lbGY9JDENCj4gPiArCWtlcm5lbF9wYXJhPSQyDQo+
ID4gKw0KPiA+ICsJY2F0IDw8IEVPRg0KPiA+ICtzZXQgdGltZW91dD0wDQo+ID4gK3NldCBkZWZh
dWx0PTANCj4gPiArDQo+ID4gKw0KPiA+ICttZW51ZW50cnkgIiR7a2VybmVsX2VsZn0iIHsNCj4g
PiArICAgIG11bHRpYm9vdCAvYm9vdC8ke2tlcm5lbF9lbGZ9ICR7a2VybmVsX3BhcmF9DQo+IA0K
PiBBbnkgY2hhbmNlIHlvdSBjYW4gYWRkIGFuIG9wdGlvbmFsIOKAnG1vZHVsZeKAnSBjb21tYW5k
IGhlcmUsIHRoYXQgd291bGQgYmUNCj4gY29uZmlndXJhYmxlIGFzIGEgcGFyYW1ldGVyIHRvIGNy
ZWF0ZV9pc28uc2g/DQo+IA0KPiBJIHVzZSBzdWNoIGEgY29tbWFuZCB0byBwcm92aWRlIHBhcmFt
ZXRlcnMgdGhhdCBrdm0tdW5pdC10ZXN0cyB1c3VhbGx5IGdldHMNCj4gZnJvbSB0aGUg4oCcZmly
bXdhcmUiIChhbmQgdGhlcmVmb3JlIGFyZSBub3QgYXZhaWxhYmxlIGluIGNlcnRhaW4NCj4gZW52
aXJvbm1lbnRzKS4NCj4gDQo+IFRoZSDigJxtb2R1bGXigJ0gY2FuIGxvb2sgc29tZXRoaW5nIGxp
a2U6DQo+IAlOUl9DUFVTPTU2DQo+IAlNRU1TSVpFPTQwOTYNCj4gCVRFU1RfREVWSUNFPTANCj4g
CUJPT1RMT0FERVI9MQ0KPiANCj4gKGt2bS11bml0LXRlc3RzIGFscmVhZHkga25vd3MgdG8gdXNl
IHRoZXNlIHZhbHVlcykNCj4gDQo+IFRoaXMg4oCcbW9kdWxlIiB3b3VsZCBuZWVkIHRvIGJlIGNv
cGllZCBpbnRvIGJ1aWxkL2lzb2ZpbGVzL2Jvb3QgYXMgd2VsbC4NCg0K
