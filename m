Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C718B3999F6
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 07:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhFCF2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 01:28:22 -0400
Received: from mga03.intel.com ([134.134.136.65]:1953 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229617AbhFCF2W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 01:28:22 -0400
IronPort-SDR: pDF2Qgt8VIL8r1WVzRzTAOFP689hEcAF4upUo/NNkGCrvP0yQm0skJPmfQEL/TCdQUxq2BAXiK
 EZG29ms/mTOw==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="203998012"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="203998012"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 22:26:37 -0700
IronPort-SDR: z/Jpcp96KX39tUbaWm1AyeFMJslqbLpHT6Zvc9f9OOcGcKRkXqhdCR5/c86p4Kp+yADxRfdZcw
 DFTrtcZ/JR+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="438685759"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 02 Jun 2021 22:26:37 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 22:26:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 2 Jun 2021 22:26:35 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 2 Jun 2021 22:26:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsxzXEkNxNqX+spTiXOCGLcDUHlZX5LlvurTJrfGAzlJkMTBhxqGUFixz0SJMDkfCVOUIyJdVN2kZdzu89H0SemDW0HbBYehnxxp1RL26pD1nwzNn85N+MGwL/RxvLYjtSr5+SZqyRL2hviXpM0ZLjMLdDX5tkWVEktsem+K3g4Ig58B5UiZfzFjxtfOQzbxvvnDNJ55lmMeSWvjBo1BaUZe+hqPkkvFLlupku7mFrgd6lmaHs3Keuc5GoWCWJqIc2epL3CRURyao4K4OOc9l+rPqJL+KHjs3mHdu+DFbmEgL/i1ZyrQMkrcrG79iYaZGaEIu8QaHacwVhskrQM7Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sI5gCS29aedWXbpqLnOvb8Mtgea6kntxs1PVitOzF/k=;
 b=M/8Lac3UicJnZSm89X8O38CERLFMLznj488XbDNbiimwyh4h3wC24vFHfLOYDe6KmKL9i3PxrsMwZub8P4q7I7lox/0yWeNekG3G2WCuB+ySPNtKtphLgkUzghKqpFIBGT9YNm6v7QzrL8tuuAW19xp4LFa3/ZgX9uOP/jhsdqAj1F8kYpC/SkHsxg+e4e1D6gTTUhtsaSo9msTwfWZ2CCeHFA5ECdKoDqGTDLfpPgIvGRGz+ZXpQ6eP1ZMw7E0WFR/ZIBoSYRkKsvHwnZ4WRPJi6efaPNLxShbSyP3rgpMkQoYW0LBpEGLU+CzgzE9yvHPIGnv/WVt9ZrGvoBIPrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sI5gCS29aedWXbpqLnOvb8Mtgea6kntxs1PVitOzF/k=;
 b=uTlQ0JJ+0GBg4hNRr391NVIiufpJuDEY8ZSuLGFJSpxZUHeIUX6HLEzn+Ki7AFc8vsaApJfIgEsqLxNIQqQxn6mRqNQ6uOpxvaskdsWclH6CxtvQ8BKJ62Oy8eK3F3iFFlgFVNRDAqfkdb2Em+tQsekSb2qfxz8lA+ZkSWwxNGQ=
Received: from DM8PR11MB5670.namprd11.prod.outlook.com (2603:10b6:8:37::12) by
 DM8PR11MB5670.namprd11.prod.outlook.com (2603:10b6:8:37::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.22; Thu, 3 Jun 2021 05:26:33 +0000
Received: from DM8PR11MB5670.namprd11.prod.outlook.com
 ([fe80::ccbb:37d7:aba8:2f8e]) by DM8PR11MB5670.namprd11.prod.outlook.com
 ([fe80::ccbb:37d7:aba8:2f8e%8]) with mapi id 15.20.4195.022; Thu, 3 Jun 2021
 05:26:33 +0000
From:   "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
To:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>
Subject: RE: [PATCH] selftests: kvm: fix overlapping addresses in
 memslot_perf_test
Thread-Topic: [PATCH] selftests: kvm: fix overlapping addresses in
 memslot_perf_test
Thread-Index: AQHXWAQL6SMHSFvTjkWRmgbneIuUFKsBuTfw
Date:   Thu, 3 Jun 2021 05:26:33 +0000
Message-ID: <DM8PR11MB5670B1AA392BF7502501D43B923C9@DM8PR11MB5670.namprd11.prod.outlook.com>
References: <20210528191134.3740950-1-pbonzini@redhat.com>
 <285623f6-52e4-7f8d-fab6-0476a00af68b@oracle.com>
 <fc41bfc4-949f-03c5-3b20-2c1563ad7f62@redhat.com>
 <73511f2e-7b5d-0d29-b8dc-9cb16675afb3@oracle.com>
 <68bda0ef-b58f-c335-a0c7-96186cbad535@oracle.com>
In-Reply-To: <68bda0ef-b58f-c335-a0c7-96186cbad535@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.5.1.3
dlp-reaction: no-action
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [111.205.14.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0200e69-e94b-4ab7-d346-08d9265026a0
x-ms-traffictypediagnostic: DM8PR11MB5670:
x-microsoft-antispam-prvs: <DM8PR11MB567002225C22E6C47953B57D923C9@DM8PR11MB5670.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ePB0VYSxF70VuPbToWQHheGBDcwMlym42ZEinx0oLRNy6zLBOsqE1a53HjvlbFGTwZ8dCNrlku9o51fJA2HP6M+kJBrxdNNYa4R0iRS4DxPfsZOayVvz0zpL6zKem8KZtWYG+yl4Rb5O9ft2whrL4N3GTkRCuXH3O391WyOlQ/VBMHzy/s30hBMwR36aKNwaJbTmytMRSKnwbtzvIq8XZF5A/nftnczF1CjOB2k2xRQwt8FENR8i6g1KwlhlvoGOuk9N8K+pu/o326F0X+yr2Gh6ReVOenUD8U5WNn2NQw0z25+pou8UAz8qH5eDtYSho1RgGT+/848+Askmq7MMTh3P51PcI/fLFQiLRi+NKV1PJsZIyFvphsJP/g1elRfKozD5GAHfqSOpFcZMx1jyLwXyxuNBzmtcRu8f9NolLGFqDULOBM5ozISzLsa6PTeh93s4ri5t+uSfPULtWoGT+5uMZuO1XwtmG1qSJ4jGXXDHQ/bDmMJmjeGiziou2Ea443+lB81bbUGkHq4wUsZx5dH1R1ezlcRN7IkUeBGXIVZO01mmS4sgCiiAhI1B65AIyl0dKa1IsoL6HcExHv4dJ6aq20t2mH+oeitn2E83aS4VK69yBoZqJvUD+c0YYoF6C07fzcdakoD2g7PT4yTeEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5670.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(346002)(376002)(39860400002)(52536014)(55016002)(8676002)(9686003)(8936002)(478600001)(110136005)(54906003)(83380400001)(76116006)(2906002)(66946007)(66476007)(64756008)(38100700002)(122000001)(5660300002)(66556008)(66446008)(71200400001)(6506007)(316002)(86362001)(186003)(7696005)(4326008)(26005)(53546011)(33656002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?emVnNnpkcEY2QUpBU1R2N3dVYzFqWVJ5S01QQmdtYUhmUjhvK0t6WFV0b3Fx?=
 =?utf-8?B?S01tNjc3YkN1WnVEbG1ETVlrbU0vRytGZDNuZ2s4QjBpZW9nYnlJdGNnaG1t?=
 =?utf-8?B?TklWZ3JZR24yVTJ1clBCYkJpSGdIRFBIQUhUOVFUQWx4MCtaS2orVXlUN2dQ?=
 =?utf-8?B?L3MwaWZmNG9rMGpnd20zSUNWSDVtZTBSbXAzN1M5UlcyNWlnU2c5QUkzSzRk?=
 =?utf-8?B?ZVpmMHhFMXNGdkJiNjVkejdJWTlNbjc0emZQZ0NReGlxODhQVG53YlhrM1Vw?=
 =?utf-8?B?T3h5REFvaU5kL2hUSk5EMlVIMEIzOVF3VFYra1pCV1lrT2QvNzBtUGl4Y1pE?=
 =?utf-8?B?WmxtYk5sQ1pseFExMS8vS0JwY1F1b0Z6Ky9UU2JxczVJM21WLzdKRXltbjVs?=
 =?utf-8?B?VmV3dVdYUXU4bk1vVmFTbVp1a1Fzb3NPUnZ2NUJxRDF1RFg2Ulc5TzFyMHEz?=
 =?utf-8?B?MVFaS2hCT2ZYVGtyamUvOFFnNG1heUdpRnk3R2FxR3d4QWdseEs5bVN5YTdV?=
 =?utf-8?B?Y1l0bTRIcGV3VEVyTFliTmdiekZQRkx4SDI3SURqYldTWVdjSVk3aXVUeWwv?=
 =?utf-8?B?ZlpWalFSczNqa2gwTWEzTGFubWZWSExYYjVwMDk3Mm1VSmVvV3hDMkFLSzQ3?=
 =?utf-8?B?bzVHejJLMGhXa1F3SnU3dWZiNW44UUVjTzBxRDF0MVB1bFY0N2UwTzcrRE14?=
 =?utf-8?B?Z2o5NWJQWlFIOUZtY095TCtMMm1DMnk1ekxKQmtyTUtIRDh6aVBJcFRCTEJT?=
 =?utf-8?B?SllRQUV1MStRbmVVUzhpSU5XR2wzc1UwTnphNTJtREVVUkl3RjJqWDhTTzBz?=
 =?utf-8?B?YUlZTHl2NVZxck95aVlua1BYZThxT0c2NkxxUjkraUwrbHNWOFBxQThWSXhr?=
 =?utf-8?B?K1JyN0djLzlLNmlMOVFZTVd1aW8yY3RqaXpUalkrS2oxd1hRM3VpcHFSZDZK?=
 =?utf-8?B?NWtjVFU3UEV4LzVUdi90SEJPby9NWTZxa1A2M0V3WFE3VldvbUlZVi9YUE5B?=
 =?utf-8?B?Tkp4RGNXWUIvNUZROEZjdFVWR1R4ejM3Z1AwM1hXYkk1R3NsTUFzY1NaKzg1?=
 =?utf-8?B?eWVwK0hVTDBTd2tLckNNRzZuRWhPWEZ2ZG1lRHBwZWZuMVlqc1RxbGVRZnkz?=
 =?utf-8?B?OUxHVlpNZ0dYRU96QXpGeE5ROXA5aFFGREdUdUJLT1lhODhvUEdqVXVpZmIr?=
 =?utf-8?B?VVRldzh1MEZqWXVNTnhTUHlNd29IK0Jsanpsc2JKdzI3RTlhWlZteEoxanh0?=
 =?utf-8?B?SEZQbDhjRTU2VDNrM081ZWtiU0FOWmxibkF3ZzQ1NGp1djBUQzc4Tmt6S0dI?=
 =?utf-8?B?WUNmcjhVbStlM2puSHltcDBoRWNzazE3bUZ6VmdQak5KWjhPRUJTNDFnVEhX?=
 =?utf-8?B?QW90YjBqT0Q2R2xwQ2tGcmtFdDhkWVd3bVRFU1M2MjdjNjlqTjdWVjUwQkxL?=
 =?utf-8?B?OWtEOENkT2s4VHBJWnNpTjB3SFM3a1JaQjN6K0ZJdjEvZEUvY04rQ2ZiVUJN?=
 =?utf-8?B?d3VsMGVaVXFiMkxLbUF2TGRsRXVGOWoxVGtKaGgvTEwvaHE4aWFCNG5zTmlM?=
 =?utf-8?B?RjBCMis5MHFNMTJLUlh2ZHZTODNmZkdvQ2t3OFhPa2hiZE4yeUEzZ1daWFZI?=
 =?utf-8?B?SVZGRlJaMXJueDVuNUlkN1ovV2FReFNuWCtadjJUeHd6cnp2TE5ucDgzSU5v?=
 =?utf-8?B?TXB4TEg1SVoyOTZ6cDNwWnJ3Q2NXc0poM01WWkg1K1RzUzBySi90MnEzQ050?=
 =?utf-8?Q?OCGGJLCHlyOm83EgzQ=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5670.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0200e69-e94b-4ab7-d346-08d9265026a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 05:26:33.3783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +0rpRLBp4WsnmJLKblV8mgFddiXWq5vc/9Yix0OCOvbksvjaHVayTsScNoTfYAUnMnYZQoyLqepkZ0cE6By1EDr5XXsDPqQdt8FxW001JnI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5670
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYWNpZWogUy4gU3ptaWdpZXJv
IDxtYWNpZWouc3ptaWdpZXJvQG9yYWNsZS5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBKdW5lIDMs
IDIwMjEgNzowNyBBTQ0KPiBUbzogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT47
IER1YW4sIFpoZW56aG9uZw0KPiA8emhlbnpob25nLmR1YW5AaW50ZWwuY29tPg0KPiBDYzogbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsga3ZtQHZnZXIua2VybmVsLm9yZzsgQW5kcmV3IEpv
bmVzDQo+IDxkcmpvbmVzQHJlZGhhdC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIHNlbGZ0
ZXN0czoga3ZtOiBmaXggb3ZlcmxhcHBpbmcgYWRkcmVzc2VzIGluDQo+IG1lbXNsb3RfcGVyZl90
ZXN0DQo+IA0KPiBPbiAzMC4wNS4yMDIxIDAxOjEzLCBNYWNpZWogUy4gU3ptaWdpZXJvIHdyb3Rl
Og0KPiA+IE9uIDI5LjA1LjIwMjEgMTI6MjAsIFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+ID4+IE9u
IDI4LzA1LzIxIDIxOjUxLCBNYWNpZWogUy4gU3ptaWdpZXJvIHdyb3RlOg0KPiA+Pj4gT24gMjgu
MDUuMjAyMSAyMToxMSwgUGFvbG8gQm9uemluaSB3cm90ZToNCj4gPj4+PiBUaGUgbWVtb3J5IHRo
YXQgaXMgYWxsb2NhdGVkIGluIHZtX2NyZWF0ZSBpcyBhbHJlYWR5IG1hcHBlZCBjbG9zZQ0KPiA+
Pj4+IHRvIEdQQSAwLCBiZWNhdXNlIHRlc3RfZXhlY3V0ZSBwYXNzZXMgdGhlIHJlcXVlc3RlZCBt
ZW1vcnkgdG8NCj4gPj4+PiBwcmVwYXJlX3ZtLsKgIFRoaXMgY2F1c2VzIG92ZXJsYXBwaW5nIG1l
bW9yeSByZWdpb25zIGFuZCB0aGUgdGVzdA0KPiA+Pj4+IGNyYXNoZXMuwqAgRm9yIHNpbXBsaWNp
dHkganVzdCBtb3ZlIE1FTV9HUEEgaGlnaGVyLg0KPiA+Pj4+DQo+ID4+Pj4gU2lnbmVkLW9mZi1i
eTogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gPj4+DQo+ID4+PiBJIGFt
IG5vdCBzdXJlIHRoYXQgSSB1bmRlcnN0YW5kIHRoZSBpc3N1ZSBjb3JyZWN0bHksIGlzDQo+ID4+
PiB2bV9jcmVhdGVfZGVmYXVsdCgpIGFscmVhZHkgcmVzZXJ2aW5nIGxvdyBHUEFzIChhcm91bmQg
MHgxMDAwMDAwMCkNCj4gPj4+IG9uIHNvbWUgYXJjaGVzIG9yIHJ1biBlbnZpcm9ubWVudHM/DQo+
ID4+DQo+ID4+IEl0IG1hcHMgdGhlIG51bWJlciBvZiBwYWdlcyB5b3UgcGFzcyBpbiB0aGUgc2Vj
b25kIGFyZ3VtZW50LCBzZWUNCj4gPj4gdm1fY3JlYXRlLg0KPiA+Pg0KPiA+PiDCoMKgIGlmIChw
aHlfcGFnZXMgIT0gMCkNCj4gPj4gwqDCoMKgwqAgdm1fdXNlcnNwYWNlX21lbV9yZWdpb25fYWRk
KHZtLCBWTV9NRU1fU1JDX0FOT05ZTU9VUywNCj4gPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAwLCAwLCBwaHlfcGFnZXMs
IDApOw0KPiA+Pg0KPiA+PiBJbiB0aGlzIGNhc2U6DQo+ID4+DQo+ID4+IMKgwqAgZGF0YS0+dm0g
PSB2bV9jcmVhdGVfZGVmYXVsdChWQ1BVX0lELCBtZW1wYWdlcywgZ3Vlc3RfY29kZSk7DQo+ID4+
DQo+ID4+IGNhbGxlZCBoZXJlOg0KPiA+Pg0KPiA+PiDCoMKgIGlmICghcHJlcGFyZV92bShkYXRh
LCBuc2xvdHMsIG1heHNsb3RzLCB0ZGF0YS0+Z3Vlc3RfY29kZSwNCj4gPj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG1lbV9zaXplLCBzbG90X3J1bnRpbWUpKSB7DQo+ID4+
DQo+ID4+IHdoZXJlIG1lbXBhZ2VzIGlzIG1lbV9zaXplLCB3aGljaCBpcyBkZWNsYXJlZCBhczoN
Cj4gPj4NCj4gPj4gwqDCoMKgwqDCoMKgwqDCoCB1aW50NjRfdCBtZW1fc2l6ZSA9IHRkYXRhLT5t
ZW1fc2l6ZSA/IDogTUVNX1NJWkVfUEFHRVM7DQo+ID4+DQo+ID4+IGJ1dCBhY3R1YWxseSBhIGJl
dHRlciBmaXggaXMganVzdCB0byBwYXNzIGEgc21hbGwgZml4ZWQgdmFsdWUgKGUuZy4NCj4gPj4g
MTAyNCkgdG8gdm1fY3JlYXRlX2RlZmF1bHQsIHNpbmNlIGFsbCBvdGhlciByZWdpb25zIGFyZSBh
ZGRlZCBieSBoYW5kDQo+ID4NCj4gPiBZZXMsIGJ1dCB0aGUgYXJndW1lbnQgdGhhdCBpcyBwYXNz
ZWQgdG8gdm1fY3JlYXRlX2RlZmF1bHQoKSAobWVtX3NpemUNCj4gPiBpbiB0aGUgY2FzZSBvZiB0
aGUgdGVzdCkgaXMgbm90IHBhc3NlZCBhcyBwaHlfcGFnZXMgdG8gdm1fY3JlYXRlKCkuDQo+ID4g
UmF0aGVyLCB2bV9jcmVhdGVfd2l0aF92Y3B1cygpIGNhbGN1bGF0ZXMgc29tZSB1cHBlciBib3Vu
ZCBvZiBleHRyYQ0KPiA+IG1lbW9yeSB0aGF0IGlzIG5lZWRlZCB0byBjb3ZlciB0aGF0IG11Y2gg
Z3Vlc3QgbWVtb3J5IChpbmNsdWRpbmcgZm9yDQo+ID4gaXRzIHBhZ2UgdGFibGVzKS4NCj4gPg0K
PiA+IFRoZSBiaWdnZXN0IHBvc3NpYmxlIG1lbV9zaXplIGZyb20gbWVtc2xvdF9wZXJmX3Rlc3Qg
aXMgNTEyIE1pQiArIDENCj4gPiBwYWdlLCBhY2NvcmRpbmcgdG8gbXkgY2FsY3VsYXRpb25zIHRo
aXMgcmVzdWx0cyBpbiBwaHlfcGFnZXMgb2YgMTAyOQ0KPiA+ICh+NCBNaUIpIGluIHRoZSB4ODYt
NjQgY2FzZSBhbmQgYXJvdW5kIDE1NDAgKH42IE1pQikgaW4gdGhlIHMzOTB4IGNhc2UNCj4gPiAo
aGVyZSBJIGFtIG5vdCBzdXJlIGFib3V0IHRoZSBleGFjdCBudW1iZXIsIHNpbmNlIHMzOTB4IGhh
cyBzb21lDQo+ID4gYWRkaXRpb25hbCBhbGlnbm1lbnQgcmVxdWlyZW1lbnRzKS4NCj4gPg0KPiA+
IEJvdGggdmFsdWVzIGFyZSB3ZWxsIGJlbG93IDI1NiBNaUIgKDB4MTAwMDAwMDBVTCksIHNvIEkg
d2FzIHdvbmRlcmluZw0KPiA+IHdoYXQga2luZCBvZiBjaXJjdW1zdGFuY2VzIGNhbiBtYWtlIHRo
ZXNlIGFsbG9jYXRpb25zIGNvbGxpZGUgKG1heWJlIEkNCj4gPiBhbSBtaXNzaW5nIHNvbWV0aGlu
ZyBpbiBteSBhbmFseXNpcykuDQo+IA0KPiBJIHNlZSBub3cgdGhhdCB0aGVyZSBoYXMgYmVlbiBh
IHBhdGNoIG1lcmdlZCBsYXN0IHdlZWsgY2FsbGVkDQo+ICJzZWxmdGVzdHM6IGt2bTogbWFrZSBh
bGxvY2F0aW9uIG9mIGV4dHJhIG1lbW9yeSB0YWtlIGVmZmVjdCIgYnkgWmhlbnpob25nDQo+IHRo
YXQgbm93IGFsbG9jYXRlcyBhbHNvIHRoZSB3aG9sZSBtZW1vcnkgc2l6ZSBwYXNzZWQgdG8NCj4g
dm1fY3JlYXRlX2RlZmF1bHQoKSAoaW5zdGVhZCBvZiBqdXN0IHBhZ2UgdGFibGVzIGZvciB0aGF0
IG11Y2ggbWVtb3J5KS4NCj4gDQo+IFRoZSBjb21taXQgbWVzc2FnZSBvZiB0aGlzIHBhdGNoIHNh
eXMgdGhhdCAicGVyZl90ZXN0X3V0aWwgYW5kDQo+IGt2bV9wYWdlX3RhYmxlX3Rlc3QgdXNlIGl0
IHRvIGFsbG9jIGV4dHJhIG1lbW9yeSBjdXJyZW50bHkiLCBob3dldmVyIGJvdGgNCj4ga3ZtX3Bh
Z2VfdGFibGVfdGVzdCBhbmQgbGliL3BlcmZfdGVzdF91dGlsIGZyYW1ld29yayBleHBsaWNpdGx5
IGFkZCB0aGUNCj4gcmVxdWlyZWQgbWVtb3J5IGFsbG9jYXRpb24gYnkgZG9pbmcgYSB2bV91c2Vy
c3BhY2VfbWVtX3JlZ2lvbl9hZGQoKQ0KPiBjYWxsIGZvciB0aGUgc2FtZSBtZW1vcnkgc2l6ZSB0
aGF0IHRoZXkgcGFzcyB0byB2bV9jcmVhdGVfZGVmYXVsdCgpLg0KPiANCj4gU28gbm93IHRoZXkg
YWxsb2NhdGUgdGhpcyBtZW1vcnkgdHdpY2UuDQo+IA0KPiBAWmhlbnpob25nOiBkaWQgeW91IG5v
dGljZSBpbXByb3BlciBvcGVyYXRpb24gb2YgZWl0aGVyDQo+IGt2bV9wYWdlX3RhYmxlX3Rlc3Qg
b3IgcGVyZl90ZXN0X3V0aWwtYmFzZWQgdGVzdHMgKGRlbWFuZF9wYWdpbmdfdGVzdCwNCj4gZGly
dHlfbG9nX3BlcmZfdGVzdCwNCj4gbWVtc2xvdF9tb2RpZmljYXRpb25fc3RyZXNzX3Rlc3QpIGJl
Zm9yZSB5b3VyIHBhdGNoPw0KTm8NCg0KPiANCj4gVGhleSBzZWVtIHRvIHdvcmsgZmluZSBmb3Ig
bWUgd2l0aG91dCB0aGUgcGF0Y2ggKGFuZCBJIGd1ZXNzIG90aGVyIHBlb3BsZQ0KPiB3b3VsZCBo
YXZlIG5vdGljZWQgZWFybGllciwgdG9vLCBpZiB0aGV5IHdlcmUgYnJva2VuKS4NCj4gDQo+IEFm
dGVyIHRoaXMgcGF0Y2ggbm90IG9ubHkgdGhlc2UgdGVzdHMgYWxsb2NhdGUgdGhlaXIgbWVtb3J5
IHR3aWNlIGJ1dCBpdCBpcw0KPiBoYXJkZXIgdG8gbWFrZSB2bV9jcmVhdGVfZGVmYXVsdCgpIGFs
bG9jYXRlIHRoZSByaWdodCBhbW91bnQgb2YgbWVtb3J5IGZvcg0KPiB0aGUgcGFnZSB0YWJsZXMg
aW4gY2FzZXMgd2hlcmUgdGhlIHRlc3QgbmVlZHMgdG8gZXhwbGljaXRseSB1c2UNCj4gdm1fdXNl
cnNwYWNlX21lbV9yZWdpb25fYWRkKCkgZm9yIGl0cyBhbGxvY2F0aW9ucyAoYmVjYXVzZSBpdCB3
YW50cyB0aGUNCj4gYWxsb2NhdGlvbiBwbGFjZWQgYXQgYSBzcGVjaWZpYyBHUEEgb3IgaW4gYSBz
cGVjaWZpYyBtZW1zbG90KS4NCj4gDQo+IE9uZSBoYXMgdG8gYmFzaWNhbGx5IG9wZW4tY29kZSB0
aGUgcGFnZSB0YWJsZSBzaXplIGNhbGN1bGF0aW9ucyBmcm9tDQo+IHZtX2NyZWF0ZV93aXRoX3Zj
cHVzKCkgaW4gdGhlIHBhcnRpY3VsYXIgdGVzdCB0aGVuLCB0YWtpbmcgYWxzbyBpbnRvIGFjY291
bnQNCj4gdGhhdCB2bV9jcmVhdGVfd2l0aF92Y3B1cygpIHdpbGwgbm90IG9ubHkgYWxsb2NhdGUg
dGhlIHBhc3NlZCBtZW1vcnkgc2l6ZQ0KPiAoY2FsY3VsYXRlZCBwYWdlIHRhYmxlcyBzaXplKSBi
dXQgYWxzbyBiZWhhdmUgbGlrZSBpdCB3YXMgYWxsb2NhdGluZyBzcGFjZSBmb3INCj4gcGFnZSB0
YWJsZXMgZm9yIHRoZXNlIHBhZ2UgdGFibGVzIChldmVuIHRob3VnaCB0aGUgcGFzc2VkIG1lbW9y
eSBzaXplIGl0c2VsZg0KPiBpcyBzdXBwb3NlZCB0byBjb3ZlciB0aGVtKS4NCkxvb2tzIHdlIGhh
dmUgZGlmZmVyZW50IHVuZGVyc3RhbmRpbmcgdG8gdGhlIHBhcmFtZXRlciBleHRyYV9tZW1fcGFn
ZXMgb2Ygdm1fY3JlYXRlX2RlZmF1bHQoKS4NCg0KSW4geW91ciB1c2FnZSwgZXh0cmFfbWVtX3Bh
Z2VzIGlzIG9ubHkgdXNlZCBmb3IgcGFnZSB0YWJsZSBjYWxjdWxhdGlvbnMsIHJlYWwgZXh0cmEg
bWVtb3J5IGFsbG9jYXRpb24NCmhhcHBlbnMgaW4gdGhlIGV4dHJhIGNhbGwgb2Ygdm1fdXNlcnNw
YWNlX21lbV9yZWdpb25fYWRkKCkuDQoNCkluIG15IHVuZGVyc3RhbmRpbmcsIGV4dHJhX21lbV9w
YWdlcyBpcyB1c2VkIGZvciBhIFZNIHdobyB3YW50cyBhIGN1c3RvbSBtZW1vcnkgc2l6ZSBpbiBz
bG90MCwgDQpyYXRoZXIgdGhhbiB0aGUgZGVmYXVsdCBERUZBVUxUX0dVRVNUX1BIWV9QQUdFUyBz
aXplLg0KDQpJIHVuZGVyc3Rvb2QgeW91ciBjb21tZW50cyBhbmQgZG8gYWdyZWUgdGhhdCBteSBw
YXRjaCBicmluZyBzb21lIHRyb3VibGUgdG8geW91ciBjb2RlLCBzb3JyeSBmb3IgdGhhdC4NCkkn
bSBmaW5lIHRvIHJldmVydCB0aGF0IHBhdGNoIGFuZCBJIHRoaW5rIGl0J3MgYmV0dGVyIHRvIGxl
dCB0aGUgbWFpbnRhaW5lcnMgdG8gZGVjaWRlIHdoYXQgZXh0cmFfbWVtX3BhZ2VzDQpJcyB1c2Vk
IGZvci4NCg0KVGhhbmtzDQpaaGVuemhvbmcNCj4gDQo+IER1ZSB0byB0aGUgYWJvdmUsIEkgc3Vz
cGVjdCB0aGUgcHJldmlvdXMgYmVoYXZpb3Igd2FzLCBpbiBmYWN0LCBjb3JyZWN0Lg0KPiANCj4g
VGhhbmtzLA0KPiBNYWNpZWoNCg==
