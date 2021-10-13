Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153E842B970
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 09:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238637AbhJMHs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 03:48:58 -0400
Received: from mga07.intel.com ([134.134.136.100]:42289 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238509AbhJMHs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 03:48:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="290864825"
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="290864825"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 00:46:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="460686260"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga002.jf.intel.com with ESMTP; 13 Oct 2021 00:46:53 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 13 Oct 2021 00:46:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 13 Oct 2021 00:46:52 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 13 Oct 2021 00:46:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2iIPgtiN/pnkzfcmAR+MV/wBXVA2n7zgd4qQe4GfeGZFueYB1AU3//rsq8oqz5KiXhJLPEWuBLR9Lz0AmIYqCwW5lZ6oKPp5BBoR+t97r8z6/VnqlP9Qh9yy8v6fxy158cCu8GVkwGvxp8L/LWD4WMVQZKYLPQ9Q/1aM3U66m5u5niD/hpkk85Xz761bRxCh741xY9xdtfWLYzkDUjND2PSUd2ZFscsYQvHDz1oFegISFqv+lsoN1y2f97Gg+aigqhEPAyvLmeKLWsdVTGp2rFuKrgbSvtrMAFt2cEHG+SltQNtWJUzttj3GzELj2bY34PDS0yg6Y56DFXx3L+FmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9av8vxyAE76ERZ1kznxDtKiLnetsoECh3PFaW4zwVQQ=;
 b=IUwyCpthkyq7ht57lP1gSHhUhpk0HVQiFF+TPp8E9nhY2Go5CKyhAr+/7iIxQt+rEzUIPaDEijTwOoAAstZ3/EYrrXLUNJlo4v3zDm6jIRFu4Qy0xRVXUpOyZIlXl/rAYgeaSyOmTauYrvD0hLSdK5w7npVyWHcM1sjFsPhtr4u7q7J5poq1VYklXoSHyp7oPvt2GcZz8VTdzN1lzZdiu0FovDxWlJ7/VqNKkpM/RFChJeIQyP7jzUi0tIgVAzYUoiUUhh8gXF5qCN1M82shNjEuqMVFQrH/sMOGfwh4hKw/y4UU6OKKn5zGCLXjdz/kfatKPBzIi4uP43GVMQxflA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9av8vxyAE76ERZ1kznxDtKiLnetsoECh3PFaW4zwVQQ=;
 b=Eb8U+JynEhVv3t4KlsKDqiDzM57793J4cwHSDBbXgEIR4qxbcdgJ72ksuCyoV1wZvvhD8ay+EsBlzPCvxEy0S/vlRqDPmWNca921h2V74y3tCt0px6XEs44yrRvfFHDpb8uOsRurRjtSGsbPTyPm/OL8PGyWDEEXAA8IusKlGWg=
Received: from BYAPR11MB3256.namprd11.prod.outlook.com (2603:10b6:a03:76::19)
 by BYAPR11MB2677.namprd11.prod.outlook.com (2603:10b6:a02:cd::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Wed, 13 Oct
 2021 07:46:51 +0000
Received: from BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::d9e1:ed97:d0d9:d571]) by BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::d9e1:ed97:d0d9:d571%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 07:46:51 +0000
From:   "Liu, Jing2" <jing2.liu@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>
Subject: RE: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Topic: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Index: AQHXv42x8Iw8v1bdT0WqN+QXiZLaIqvQcYTggAAF7ACAAAOKwA==
Date:   Wed, 13 Oct 2021 07:46:50 +0000
Message-ID: <BYAPR11MB325676AAA8A0785AF992A2B9A9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.069324121@linutronix.de>
 <8a5762ab-18d5-56f8-78a6-c722a2f387c5@redhat.com>
 <BYAPR11MB3256B39E2A34A09FF64ECC5BA9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
 <0962c143-2ff9-f157-d258-d16659818e80@redhat.com>
In-Reply-To: <0962c143-2ff9-f157-d258-d16659818e80@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b64a067-9a40-457e-ec9a-08d98e1d9e45
x-ms-traffictypediagnostic: BYAPR11MB2677:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB26775F1B47D5235463586DC1A9B79@BYAPR11MB2677.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dLZMypAdaeNGOefo34AMQtoii2sDPqJF2Pekm+cZDhEd+48o2pYwYWvbQdGaCiyAsBgmi8SkMWnOeH8WRNAhngasoX1Y9gWLzl572MfMah+QBb3xGd1tyXzf8n43EeoEfiVp8XqFrm1Z4Hjl/R1A+qn+s53lgO4BUedsp+Vxg5M5Tf7/QiV/+3Gdofd+knk1OMP6ojOrEAeVaW7pB4/s1h6jfA3xVL06axVTMSmjY8MqLcZvNrIcvZBIrmzCKyxSZdQyWPm/GZvu7bZo959Lfn0pKsRijYWgerLsR8V959tkza6aHTfV0knQI+1F97q/QANF55tom2O8b+aTBLKlub6RgPFbO/Vwg5YyY2yQPFscLQxkj1bQEFUzIkVZIgPOpHvq9BeOg7d5rr+7CHEH5pSh7W2B/VL80iDcYukezXACn0k46lHFx+ttehgibAn/q2Tq5dGDNjC1cE84Zxgx10kSV5XgyB5IkaiDJrbfPvbTGeTLmZtY+rXw3IlHuX0Bdc23eXq9M4etcq+8CF26PCc8M9Nv6+h8XBwmEax72OlpZMk7ABvkzw3ruiUIclDIpbw02cdBSWG4p45fwwQewb2/pLY3KDyhJ72W3bZ6SRJ/DuM+lOeCaoFIA5cISZVqy9HmDj4lMYQ3LxH/oJThQRUodYWMc69Vheq5oNHoiQBm0P9Z7/N64q7tzkUmFt0JlgTdDS+A5sABxM7+iSAg1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3256.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(52536014)(5660300002)(71200400001)(55016002)(8936002)(9686003)(54906003)(82960400001)(110136005)(316002)(38100700002)(508600001)(8676002)(7696005)(83380400001)(186003)(86362001)(33656002)(66476007)(26005)(53546011)(66946007)(66556008)(6506007)(66446008)(2906002)(64756008)(4326008)(38070700005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MmgxTmNSNG5VWGx5NDJLMURjVFNaUjQyVHV0VjFlQTBNeTNVcytiSklNVDgy?=
 =?utf-8?B?QkRNZzlqOWxTTW51cjdpOWdMWWtsVU83Tk92bFZMbUxkMlkrbWhlSVJSUk1z?=
 =?utf-8?B?Z212Z0YrUFVTSzlxWVBZUGVoNEdaTnZnSUQvRldFNGx2K2VBQ2ZITjVvYzh0?=
 =?utf-8?B?QUlEQjFaa1JnTU1LdE9mSERaSGl3dUorMUE4ZW1hc0NtNUpDOStQbG9KM1pU?=
 =?utf-8?B?enVNYlBzQUNXU0FMOENtSWt1M3piUmh3dTQzSXJ3WGlyaSttd2dHVVVKOTFW?=
 =?utf-8?B?WjZ0TW9GdWRKcklJQzM3K1R4dG5abjlVRmFjUTdHSi9ZUHovNWp0a3daeTdw?=
 =?utf-8?B?eHR5NlNFSmN2UzdwZjREZ1k5cUYycnNvcE9nZ1B0T04rcEZldysvS095Q1VJ?=
 =?utf-8?B?WFNZVmNERFhFTEwyRWQ4eTdSenhyOU5wT05CTkNpZEY2QnZINXpSdlVWRm5z?=
 =?utf-8?B?R215SWVhUUNwTHlpYU5DcFRIcFBqYlA2Y3VOTTduRGVwQ1gzU0F4eGhVaUhH?=
 =?utf-8?B?TGk3aTQwSlkyNHVmblpGVEhWNkEyNHBDSnNvTmh4VnAzd1YraVhqRG4wNVM3?=
 =?utf-8?B?Yy9HSlJlNFgvSXp6MndOMUcvUU81WXhNb0x0am1VeXhLZFhPaHhXeHFNbG04?=
 =?utf-8?B?b01OWWozNWVtNnVTOTlaRjM5cy9lblBpUWY2THB0NFlUbTJhQWErMHVnaWFY?=
 =?utf-8?B?RGlKZTJkMUxRNng1N1RmYkwxeDFzY3Z1eWNXVVVxNzlqYjVBbWs3MXVmdm16?=
 =?utf-8?B?L0NKazBmSkFLM0EyOHdTV211SGtXc3Z3ckFyUzZHeTBVRGU2Z1NKekw2VnFX?=
 =?utf-8?B?cGxiaGRuQkpSQjJZZEtEcGgvblZubXJUVmJSV0YwSVhwTU93V2lscFB3RlhC?=
 =?utf-8?B?Z1Q5WlluQ2poU3R3S05YNzdXbm9FK3ppQzJVNWp6RWx5Mm9ROTlRZ2FhR2Jl?=
 =?utf-8?B?VEtyaEhCMVJmdElNaktlU1B0bnpTcXBxOHQyUG5VTTJ1OXB0dWVMaXQ4SS9j?=
 =?utf-8?B?WkQwRkxYVzdMTTI3OC94OFVXMldDaTZSMlh2bThOMGpuR2EwS2pTczVRalJ6?=
 =?utf-8?B?YW5KWTNSOCtIUmZaZzZDbVV5bWVPU2xQNjlKWE9NcUgxMmUzWVozY0JvK1Aw?=
 =?utf-8?B?UG01SERsS2hlV0hwdDQwanhCLzBlNXA2MTZ2cGFRR1pKTDUrdFZtTHRQTVN3?=
 =?utf-8?B?cWNuK2tIRFYrVVAyaktEejlqK2xEeWZMdUpadlpHaFc5ODBrVGpzaFRQM1Jl?=
 =?utf-8?B?NnJTUTUrV00rMFB3QTBHWkhjcmhpdXVNM1k4N3lCL0hqNUtGeDYxQmNveC8z?=
 =?utf-8?B?LzJIRnVTbmp6ZThqeTFHNkh0RitsWEp1TXRJRzFvWjhidEhCWTU2czBTVElX?=
 =?utf-8?B?NXJXWWtiU2trQjNFU0FkeTJBcFZnSE4vRkZQMjZtNVZFSjE2V3diMFRjSmp4?=
 =?utf-8?B?OEUvMDlqbXBMbHdlYmJ5eVVyeTByR2I0NnNxRkZtemEzWWtLcUV0VFlPQThB?=
 =?utf-8?B?R2NKVDhyQ2c2ZlBSZ3ZPb1lFWFhyWmd3Tm5xMkEzZVpVVUI1b3daR2lwRnV4?=
 =?utf-8?B?emxaS2hwdG1vMWtrQ2xadGY0QUx0eFAxdnNRMWVBelhPZ01udFRDb2FOQmRZ?=
 =?utf-8?B?bjIvVHY2YjhPaUpjYndjdENOaXNmbXhRZThwemUxTTVhTFIyQWZSbk9NMWlz?=
 =?utf-8?B?RW9LMmhyd2gxU01RbHdyRHlHUTRQakZtL29EdWVxcmMxVzZ1OWJ6V05rOFNE?=
 =?utf-8?Q?zjNrIGDyq1G9BTelUkBnfEnn7HJbXlS8RZr3Qcf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3256.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b64a067-9a40-457e-ec9a-08d98e1d9e45
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 07:46:50.8725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +y9D2yYGcJ+BSMeVoAKi5hrhrW6EkYBpd685DXb0OTyPXxvBoL0+o0rUd3e+ORAfDAUJYGhToLqYhgRg4furqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2677
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IE9uIDEzLzEwLzIxIDA4OjE1LCBMaXUsIEppbmcyIHdyb3RlOg0KPiA+IEFmdGVyIEtWTSBw
YXNzdGhyb3VnaCBYRkQgdG8gZ3Vlc3QsIHdoZW4gdm1leGl0IG9wZW5pbmcgaXJxIHdpbmRvdyBh
bmQNCj4gPiBLVk0gaXMgaW50ZXJydXB0ZWQsIGtlcm5lbCBzb2Z0aXJxIHBhdGggY2FuIGNhbGwN
Cj4gPiBrZXJuZWxfZnB1X2JlZ2luKCkgdG8gdG91Y2ggeHNhdmUgc3RhdGUuIFRoaXMgZnVuY3Rp
b24gZG9lcyBYU0FWRVMuIElmDQo+ID4gZ3Vlc3QgWEZEWzE4XSBpcyAxLCBhbmQgd2l0aCBndWVz
dCBBTVggc3RhdGUgaW4gcmVnaXN0ZXIsIHRoZW4gZ3Vlc3QNCj4gPiBBTVggc3RhdGUgaXMgbG9z
dCBieSBYU0FWRVMuDQo+IA0KPiBZZXMsIHRoZSBob3N0IHZhbHVlIG9mIFhGRCAod2hpY2ggaXMg
emVybykgaGFzIHRvIGJlIHJlc3RvcmVkIGFmdGVyIHZtZXhpdC4NCj4gU2VlIGhvdyBLVk0gYWxy
ZWFkeSBoYW5kbGVzIFNQRUNfQ1RSTC4NCj4gDQoNCkknbSB0cnlpbmcgdG8gdW5kZXJzdGFuZCB3
aHkgcWVtdSdzIFhGRCBpcyB6ZXJvIGFmdGVyIGtlcm5lbCBzdXBwb3J0cyBBTVguDQpEbyB5b3Ug
bWVhbiBpbiBndWVzdCAjTk0gdHJhcCBLVk0gYWxzbyBhbGxvYyBleHRyYSB1c2VyX2ZwdSBidWZm
ZXIgYW5kDQpjbGVhciBxZW11J3MgWEZEPyBCdXQgd2h5IGRvIHdlIG5lZWQgZG8gdGhhdD8NCg0K
SSB0aGluayBvbmx5IHdoZW4gcWVtdSB1c2Vyc3BhY2UgcmVxdWVzdHMgYW4gQU1YIHBlcm1pc3Np
b24gYW5kIGV4ZWMNCkFNWCBpbnN0cnVjdGlvbiBnZW5lcmF0aW5nIGhvc3QgI05NLCBob3N0IGtl
cm5lbCBjbGVhcnMgcWVtdSdzIFhGRFsxOF0uDQpJZiBndWVzdCAjTk0gYmVpbmcgdHJhcHBlZCwg
S1ZNICpkb24ndCogbmVlZCBjbGVhciBob3N0J3MgWEZELCBidXQgb25seQ0KYWxsb2NhdGUgZ3Vl
c3RfZnB1J3MgYnVmZmVyIGFuZCBjdXJyZW50LT50aHJlYWQuZnB1ICdzIGJ1ZmZlciwgYW5kDQpj
bGVhciBndWVzdCdzIFhGRC4NCg0KIA0KPiBQYXNzdGhyb3VnaCBvZiBYRkQgaXMgb25seSBlbmFi
bGVkIGFmdGVyIHRoZSBndWVzdCBoYXMgY2F1c2VkIGFuICNOTQ0KPiB2bWV4aXQgDQoNClllcywg
cGFzc3Rocm91Z2ggaXMgZG9uZSBieSB0d28gY2FzZXM6IG9uZSBpcyBndWVzdCAjTk0gdHJhcHBl
ZDsNCmFub3RoZXIgaXMgZ3Vlc3QgY2xlYXJpbmcgWEZEIGJlZm9yZSBpdCBnZW5lcmF0ZXMgI05N
ICh0aGlzIGlzIHBvc3NpYmxlIGZvcg0KZ3Vlc3QpLCB0aGVuIHBhc3N0aHJvdWdoLg0KRm9yIHRo
ZSB0d28gY2FzZXMsIHdlIHBhc3N0aHJvdWdoIGFuZCBhbGxvY2F0ZSBidWZmZXIgZm9yIGd1ZXN0
X2ZwdSwgYW5kDQpjdXJyZW50LT50aHJlYWQuZnB1Lg0KDQpUaGFua3MsDQpKaW5nDQoNCmFuZCB0
aGUgZnVsbCBYU0FWRSBzdGF0ZSBoYXMgYmVlbiBkeW5hbWljYWxseSBhbGxvY2F0ZWQsIHRoZXJl
Zm9yZSBpdA0KPiBpcyBhbHdheXMgcG9zc2libGUgdG8gZG8gYW4gWFNBVkVTIGV2ZW4gZnJvbSBh
dG9taWMgY29udGV4dC4NCj4gDQo+IFBhb2xvDQoNCg==
