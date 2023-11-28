Return-Path: <kvm+bounces-2586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D9D97FB39B
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 09:06:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A75E9B2142A
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 08:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 436DB15E80;
	Tue, 28 Nov 2023 08:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n83hrtCV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7935D1A5;
	Tue, 28 Nov 2023 00:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701158774; x=1732694774;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NWhOlIblQsCBvZ6Nos2aSw/KuRYllilrmzlaxO89Gto=;
  b=n83hrtCVIiE/6w9saCF5zkHpjEFmY1QgpbDAV4KDoVRp3D8d1kXBffEo
   NahxDKdFGwBp0drL6n3ZrO/zeDxZeAA3DpWmrl3+2re2xULj4rQobxpUK
   7EEsTzSBagozalbjxfmzoG7xHOCYulykQTSudyXCakPeQj+67mYS5G2hq
   x8w8jROubVv2/STYcVW+TQIaVBo3FcWm8dxFEL3gjPmcE5uHDK8ELKToM
   0p7a5RsA0SAwvgk3/ENgZKhLfyGhXijTj27B0KfQLH9nmXXR1JWKYIzfs
   GBq6MdlCXNm6rv5Q7ZZ0aD+cj1olDG+fwQxgP32xTf4I2mzZeK8xuEodH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="459376710"
X-IronPort-AV: E=Sophos;i="6.04,233,1695711600"; 
   d="scan'208";a="459376710"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 00:06:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,233,1695711600"; 
   d="scan'208";a="16541579"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Nov 2023 00:06:08 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 00:06:07 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 28 Nov 2023 00:06:07 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 28 Nov 2023 00:06:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DD8aKbLclsXVp+q1hn3nI8yO8eWHliOu2CAofWaNv47JptPXzSB9K8T40wX5tS4ZabZlUitS6tJC9RbJzSMyrj3bl1Q1kZ9bLVVq0VhOJYJjCZozJhVEddfUdr1GAiRhuMn061OErtTWAzgrgG8zq653Wpfdjtatcyv7hsoKinKgrhryQOZLGh8gT4LQ4yfMJSz4JMRTZDJN3Qb4mBG1pfX6AdpNJxOWdnmVkkGA8KjNlxWUiQhcd4ZW7wygwxxvSAEa/ruvwO8Csu9SeQfi8n8t9CY7gJOUMyGZpajvrnRKel64Vn4MzJKxtjuw5IsLJdhqDvVaJs4O7wnfUgklHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NWhOlIblQsCBvZ6Nos2aSw/KuRYllilrmzlaxO89Gto=;
 b=HCr5qyfGanFr8eJS5f/qCYE2fHVeu3SE0VhmBsLerFNSGvsvInl9GbAoVJ3/N+iNlDMjPRfLmjNHSfHtYkyi28j4UUDtEJ5drmkEaNU24UhoMUgSqPs8fMnJQjJxXo+7sOQ3zC7nwjg7QHyhS13IARctOQLqbABYkiQTVyzvv2Jd9Icwp0AmhJrzxHES+zptghZFjhShkwON3YMWo7xm8kEV1kOfnsOsE5hsRWbKvGLIb1kBlhR4aZi9D8IwKf06FYFP0CedUQaDRSsg7MmlSRF97qycIkBjCsSXESd2tAAPZZtEVl12+wSB3mSGnWH5K0RX3sOZGqSGnIU+Yjc/Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB8122.namprd11.prod.outlook.com (2603:10b6:510:235::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Tue, 28 Nov
 2023 08:05:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 08:05:57 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
CC: Brett Creeley <brett.creeley@amd.com>, "yishaih@nvidia.com"
	<yishaih@nvidia.com>, liulongfang <liulongfang@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "shannon.nelson@amd.com"
	<shannon.nelson@amd.com>
Subject: RE: [PATCH vfio 1/2] hisi_acc_vfio_pci: Change reset_lock to
 mutex_lock
Thread-Topic: [PATCH vfio 1/2] hisi_acc_vfio_pci: Change reset_lock to
 mutex_lock
Thread-Index: AQHaHXtVphq+hnbfB0OILClfS0oyzbCJKpoAgAXDAACAAHpKEA==
Date: Tue, 28 Nov 2023 08:05:57 +0000
Message-ID: <BN9PR11MB5276D3527421A07C5A9E4BD28CBCA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231122193634.27250-1-brett.creeley@amd.com>
 <20231122193634.27250-2-brett.creeley@amd.com>
 <eb2172d1e24044059e65d15b10391f65@huawei.com>
 <20231128004612.GE432016@ziepe.ca>
In-Reply-To: <20231128004612.GE432016@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB8122:EE_
x-ms-office365-filtering-correlation-id: 65ef6315-2ed3-4c73-f749-08dbefe8da65
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NR4NvDLSiI6s7sNv+tuFs2Dfn2HOl6hMkV3+2awCpQYA/bH8llY0PzPy/CdRNmhKkxcWTaLB3stoygpHRHP0JjwSxtwlvsNfham8A2tUQE73IaHDRYRCCY2YtHZJpdfDuj97M1dawY3djVcTRdVqV0ouOUYO8DlY98vYNEWTnItr4i4VjOkKYJThhjpon+Ie03wLsTy7CxHyIzehXQyVLH0AwtvSKSpdMGBN1bkQnwodzbgmxJDQGeR3/jKbBUjOLCRdmUiT/+eO2lK87DWoHXLOjRs1+VFXUUBdP4BFqVFevGUqhfV75sgViCBfKXWDisnJmc2dvOaixQFIiqBZ9KORYtNT6upfuoV9oj5X/BAfdCnLIpZ65WxIxDm3kyaNIxibyRPfmL4OQ+1WdSkDxGXsPZPGaBca6iwWb7VeRxOt5c1dy3N6Hr9DjEN7QVPPwLR+pd+NVyjGpvQf3d4kA9ISRbHNsqfgwPgumSly7mDsnmEBGuDbGUb7QNjgbkqv/xTEyuc9wNn+a5UqeY1GkkeLA8n/sujGfSu1PYjIIYSWANjNZdlBe866K+YCLT/sthi6qER+Tqo11OdUt3ZIocSJ/G9WEppAEy//qr8eam79/dblF58+p8hsPldyfynQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(366004)(396003)(346002)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(38070700009)(82960400001)(83380400001)(33656002)(2906002)(52536014)(122000001)(55016003)(9686003)(26005)(5660300002)(41300700001)(6506007)(7696005)(71200400001)(478600001)(38100700002)(8676002)(86362001)(8936002)(4326008)(54906003)(316002)(66556008)(110136005)(66476007)(64756008)(66946007)(76116006)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFJxcmVyb3MrR3hWL0VOdnlZTWhYSWx4Tm8zSm9MSmtvcUJXaC9vQTZKUXVq?=
 =?utf-8?B?enlaRmlHZ0xOblZHYkV0ZnNQWEpSVVZyZ3hBOGRMc2cyVkxpZGVLSjhGaGZF?=
 =?utf-8?B?anJtTE9wcW5ja3NoZUp1Qkhnb0NmUXNIOTlaczVKTVFmQ2hHYmx5aVRrcElp?=
 =?utf-8?B?RjY0b25PRTNIamJCYXJsN0txUXdnVWIvTlRiaXp6T2hJdno5MExDa0l6R2U4?=
 =?utf-8?B?eGdsVGJJQm9GL1ZPTVErejBSRFE2SlNyVUd6N0JYSVJYM1hoa2dSbis3eTBK?=
 =?utf-8?B?bGtOeG9VekNXZUtvTCtaWUtKcG1RU1hvbEZjSTFaMnVqYzgyNGZLSGwzWjdS?=
 =?utf-8?B?eWJiSTBUWEx0NGN2K1lJU3E2U2JhMlI4d0J5eGd1dm1SYVBwMkxWYmxwcENs?=
 =?utf-8?B?aXN3d2lENHJRUzBpc1F2aHAzUmdISkp4UXROK2FOWVR3NjBWNjNkZmZ3U2RW?=
 =?utf-8?B?ci9pSnVnWGFTby8wMXY4ejdUVFpwcnE3azh4Zys4MzBMNlhCVGI2TVdORVp0?=
 =?utf-8?B?UnNNRHB0S2pjVk9zK1pERVYzQXdQdDhsQVlqaTVhTHVURUdSQk1wSVF1UGJu?=
 =?utf-8?B?enM0djMvdXlMaHpIczMxK3hlV09XdG9FbGt3Z3Z0dFBBdHdQejB6VS9saFRW?=
 =?utf-8?B?dnZUMks0b014Y2ZJR3V6S2pUOEQzc2pYQ3RNNXc3VlQ2QWtiOU83Wms1c1dv?=
 =?utf-8?B?MEZ2TjhkSVBUT2ZnK3NEMGVOeVh1SUdnUFNCaGMzOE1kMm9kWGZ6aVJRRkcv?=
 =?utf-8?B?ZHMrUHZkNW5FcWhFOVlUNjZhQlIzOUh5ZUZQVUZBaGhmcFBXSXR0SlZMMDRh?=
 =?utf-8?B?TEhndWFXQzhabUhLUm5XYkxkR2NLZnhwTCt0QXlqK29hQ3JlVkhVdksrTGow?=
 =?utf-8?B?YmFHQkd5clNWM2N2ZUhSb0lDODR4VGUzUG9qS3hUYWQxaEhacVB5S05pUnly?=
 =?utf-8?B?TFh6U2tSd0ozdi8yR0s4WHkyMWpnT2lSV1RmNUVCS1dnNWV0eDNYRXRkbzFo?=
 =?utf-8?B?MTloTDNJMHBxVjVRNlNWaW5KRnN1L3diODYwdW90UFJ4c2Nvb1Vhd2prMWUv?=
 =?utf-8?B?Q0RtM3UyZjkzTzNZQnBaV2UzNFJRNWk5c1pyMGxXVkhsWGxaSmE3OUxOUlFy?=
 =?utf-8?B?SjRUbzIzai9HYUp2bWRUZWlQaWZxK0EyM21UcjlPWEdEMGJ0MlYrK2tGUGZX?=
 =?utf-8?B?K21tSzVRVmxJbytTck5QTjZVaVpybUZ0UDF0eExyOHppNWRnam1FNkI0bmlK?=
 =?utf-8?B?cFJVek8xWXgwWFphWThkUEI0ZGNSYkNWNFVpY1Qrc0RtNW1GdEg0dHMxVVgz?=
 =?utf-8?B?aml0UHlIZHFIKzFUNkhKQXhaMUtZN2IySW95VlRnaUxBSWc1ZElwQjM1WUJC?=
 =?utf-8?B?MWJHOERmbDdOelJ4cXB4WjNnb2pSSzBYRjkyYnpPcUk4SEFEVDh6TnQwNDdG?=
 =?utf-8?B?dEc1WitMUVc0YjBBWkZ2V2FzRlh6RGhpT0JUUDAvQTlEWnUwYkhuSnJNOG1W?=
 =?utf-8?B?S0RXU1VNTWxBTkVaTkNvNUJDV3cxaHFsZDV4MWptYWMrbU9aK0wzR1pGZUd5?=
 =?utf-8?B?R1JEZWZHb2RQa203cXNMUEhSWnhBL0YzOSt5TkRDQlpTM1Q3L0tqZUxTNmlj?=
 =?utf-8?B?YkNXSjM1blVRSmRYR1RhdmovbEF5Vno5eFNLZFFjMXFNOGVQQVEyeC9jR0t0?=
 =?utf-8?B?ZURIT0F4WWRxWUl6TXJUTS9yZ0FsQWFGcWJRb29jNTIyUVpzOE9QVTk0aUYw?=
 =?utf-8?B?SkkyKzg3M09kMjZGb0UrYXdFNEpRdmZBN3NIY1R1M0JGM2NWMlZnckh4S2Yx?=
 =?utf-8?B?SVRHTW5HUTNBeE5XY1JzTW9VbVR6WWprVXlYanZVa0dySHhTeGhMTlM1enR2?=
 =?utf-8?B?SjhNeDJ5UEQ0V1ZFd1Zac2xjeXBIakIwZlZhMTNSdVRHR1FvL3pWeEFsMXZm?=
 =?utf-8?B?dmRjSyswVlk0ZmUwSWlKWVE0M1VCNVhEMGY0S0RPZWk4VUlVQVhtM2FMa3RX?=
 =?utf-8?B?cDdwNlY4QWMwTnFwQmYranBEdEhpTnN3UzJXdnlqZEdjWk1lWm5UWno0MnhN?=
 =?utf-8?B?N3FQbDNQWlFUNDB4aTVzOVNWSEhpQjlGekVuUmNybWFYV3pWMWlpdktxR3d1?=
 =?utf-8?Q?ChMxCMnGG9SdN7GIb4mw4ZinR?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ef6315-2ed3-4c73-f749-08dbefe8da65
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2023 08:05:57.8484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UtKI8lvYFzXwru/+75iT8uQ3k/bLREupZiNBf0pYfIPWaKijWluQrutLrP/j4+QGhxTjyvvRXzyJYtit5dzeRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8122
X-OriginatorOrg: intel.com

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0B6aWVwZS5jYT4NCj4gU2VudDogVHVlc2RheSwg
Tm92ZW1iZXIgMjgsIDIwMjMgODo0NiBBTQ0KPiANCj4gT24gRnJpLCBOb3YgMjQsIDIwMjMgYXQg
MDg6NDY6NThBTSArMDAwMCwgU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9kaSB3cm90ZToNCj4gPiA+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vcGNpL2hpc2lsaWNvbi9oaXNpX2FjY192ZmlvX3Bj
aS5jDQo+ID4gPiBiL2RyaXZlcnMvdmZpby9wY2kvaGlzaWxpY29uL2hpc2lfYWNjX3ZmaW9fcGNp
LmMNCj4gPiA+IGluZGV4IGIyZjk3NzhjODM2Ni4uMmMwNDliOGRlNGI0IDEwMDY0NA0KPiA+ID4g
LS0tIGEvZHJpdmVycy92ZmlvL3BjaS9oaXNpbGljb24vaGlzaV9hY2NfdmZpb19wY2kuYw0KPiA+
ID4gKysrIGIvZHJpdmVycy92ZmlvL3BjaS9oaXNpbGljb24vaGlzaV9hY2NfdmZpb19wY2kuYw0K
PiA+ID4gQEAgLTYzOCwxNyArNjM4LDE3IEBAIHN0YXRpYyB2b2lkDQo+ID4gPiAgaGlzaV9hY2Nf
dmZfc3RhdGVfbXV0ZXhfdW5sb2NrKHN0cnVjdCBoaXNpX2FjY192Zl9jb3JlX2RldmljZQ0KPiA+
ID4gKmhpc2lfYWNjX3ZkZXYpDQo+ID4gPiAgew0KPiA+ID4gIGFnYWluOg0KPiA+ID4gLQlzcGlu
X2xvY2soJmhpc2lfYWNjX3ZkZXYtPnJlc2V0X2xvY2spOw0KPiA+ID4gKwltdXRleF9sb2NrKCZo
aXNpX2FjY192ZGV2LT5yZXNldF9tdXRleCk7DQo+ID4gPiAgCWlmIChoaXNpX2FjY192ZGV2LT5k
ZWZlcnJlZF9yZXNldCkgew0KPiA+ID4gIAkJaGlzaV9hY2NfdmRldi0+ZGVmZXJyZWRfcmVzZXQg
PSBmYWxzZTsNCj4gPiA+IC0JCXNwaW5fdW5sb2NrKCZoaXNpX2FjY192ZGV2LT5yZXNldF9sb2Nr
KTsNCj4gPiA+ICsJCW11dGV4X3VubG9jaygmaGlzaV9hY2NfdmRldi0+cmVzZXRfbXV0ZXgpOw0K
PiA+DQo+ID4gRG9uJ3QgdGhpbmsgd2UgaGF2ZSB0aGF0IHNsZWVwaW5nIHdoaWxlIGF0b21pYyBj
YXNlIGZvciB0aGlzIGhlcmUuDQo+ID4gU2FtZSBmb3IgbWx4NSBhcyB3ZWxsLiBCdXQgaWYgdGhl
IGlkZWEgaXMgdG8gaGF2ZSBhIGNvbW1vbiBsb2NraW5nDQo+ID4gYWNyb3NzIHZlbmRvciBkcml2
ZXJzLCBpdCBpcyBmaW5lLg0KPiANCj4gWWVhaCwgSSdtIG5vdCBzdXJlIGFib3V0IGNoYW5naW5n
IHNwaW5sb2NrcyB0byBtdXRleCdzIGZvciBubyByZWFzb24uLg0KPiBJZiB3ZSBkb24ndCBzbGVl
cCBhbmQgZG9uJ3QgaG9sZCBpdCBmb3IgdmVyeSBsb25nIHRoZW4gdGhlIHNwaW5sb2NrIGlzDQo+
IGFwcHJvcHJpYXRlDQo+IA0KDQpJdCdzIG1lIHN1Z2dlc3RpbmcgQnJldHQgdG8gZml4IG90aGVy
IHR3byBkcml2ZXJzLCBleHBlY3RpbmcgYSBjb21tb24NCmxvY2tpbmcgcGF0dGVybiB3b3VsZCBj
YXVzZSBsZXNzIGNvbmZ1c2lvbiB0byBmdXR1cmUgbmV3IHZhcmlhbnQgZHJpdmVycy4NCklmIGJv
dGggb2YgeW91IGRvbid0IHRoaW5rIGl0IG5lY2Vzc2FyeSB0aGVuIGxldCdzIGRyb3AgaXQuIPCf
mIoNCg==

