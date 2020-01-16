Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF5A13D29D
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 04:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgAPDQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 22:16:04 -0500
Received: from mail-vi1eur05on2064.outbound.protection.outlook.com ([40.107.21.64]:6032
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726552AbgAPDQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 22:16:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJbRTf6fyJuyDu1/xSzRwDkW72FH4W7BXVb2KQUeIa4yFZaQloNYy+ZyJScrepKZ9fWNN3SY3Z8KJXKSlP2djn5Gl2dqlO6CojtINR1J1q2tsY5KQ0qt4Jlfem9xqhWW2AiniP7f7UlQnObwpl0Odqq3tev1RGb/DLE6KwFPPXnC3FXuNtGkQMozuP/cEFfqFTPTm2FAMd2Qxhd6qCphYmsthXpj6GTDHcBADKueItuMoQ/yM6FLpjZX/yubp5hupapz2Lp3ps0QYEJ+jQzM720okepBkdJXY4Be3mDhRf4vgOAL+I5mxz6QFVMrJSMok9dMhia/RFZc7RZDxuMWSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RxgUBl5mzUPv8Yi9HbjdAKi6aBnXQEgojceDyofwMZs=;
 b=b5x18LSV3u2m7v8CyU5NEcTVtDM4zBAyGFmDw7CrHozPlFGDGgey8gkxfK50pj+uqEdzkmR9amlamnchtzs262DlbE10FD/hva7NwMyIU+bqNzkwxFYxXCR9mnpMM/FW0b2bqqUcDBRPqZsHPu9/I1wqFr3xB+4MeBwLJuiBlEclySpkRHSDkV1TwUkNF5TQdnh7dCkEYrCZ3wYO0ZgfYQqihPJZzhsAv0d2i0R7klq3i2o7ZGch2NqDY6Ce8dCMbq4VZ/+K63DLOnmagU43sng2MPMVcfYRTbVxU6Hgf47W00zpLJeY2pCiAw29LpqhGNx2Zy85Jc8g3xBbQL81Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nextfour.com; dmarc=pass action=none header.from=nextfour.com;
 dkim=pass header.d=nextfour.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NextfourGroupOy.onmicrosoft.com;
 s=selector2-NextfourGroupOy-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RxgUBl5mzUPv8Yi9HbjdAKi6aBnXQEgojceDyofwMZs=;
 b=iNqt18pP4ldIDrx0xw4wi3sVpEE8CzQ3ji9FsKo876DjINl4HfEOr3INqnqTQbSsHXi1D0a8ePNM80uB8l6oSWSRZSYkQCE9Lu3ZncJiEU9YcoGHH+mtH29mPQUxK9fpKUQRA9+CEFqe7KC4NupvlkRrsBd2fHrXteuTZ2i5J/8=
Received: from VI1PR03MB3775.eurprd03.prod.outlook.com (52.134.21.155) by
 VI1PR03MB4799.eurprd03.prod.outlook.com (20.178.13.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Thu, 16 Jan 2020 03:15:58 +0000
Received: from VI1PR03MB3775.eurprd03.prod.outlook.com
 ([fe80::fdfe:b987:16ad:9de9]) by VI1PR03MB3775.eurprd03.prod.outlook.com
 ([fe80::fdfe:b987:16ad:9de9%5]) with mapi id 15.20.2623.018; Thu, 16 Jan 2020
 03:15:58 +0000
Received: from [192.168.1.121] (91.145.109.188) by HE1PR07CA0046.eurprd07.prod.outlook.com (2603:10a6:7:66::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.10 via Frontend Transport; Thu, 16 Jan 2020 03:15:57 +0000
From:   =?utf-8?B?TWlrYSBQZW50dGlsw6Q=?= <mika.penttila@nextfour.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Yan Zhao <yan.y.zhao@intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: Re: [PATCH v2 1/2] vfio: introduce vfio_dma_rw to read/write a range
 of IOVAs
Thread-Topic: [PATCH v2 1/2] vfio: introduce vfio_dma_rw to read/write a range
 of IOVAs
Thread-Index: AQHVy1izPc+ONnk2aUegZV3QDrVrz6fsJ+UAgACM3wD//+aegIAABHUA
Date:   Thu, 16 Jan 2020 03:15:58 +0000
Message-ID: <7528cfff-2512-538e-4e44-85f0a0b0130a@nextfour.com>
References: <20200115034132.2753-1-yan.y.zhao@intel.com>
 <20200115035303.12362-1-yan.y.zhao@intel.com>
 <20200115130638.6926dd08@w520.home>
 <80cf3888-2e51-3fd7-a064-213e7ded188e@nextfour.com>
 <20200115195959.28f33078@x1.home>
In-Reply-To: <20200115195959.28f33078@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR07CA0046.eurprd07.prod.outlook.com
 (2603:10a6:7:66::32) To VI1PR03MB3775.eurprd03.prod.outlook.com
 (2603:10a6:803:2b::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mika.penttila@nextfour.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [91.145.109.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9b6101b-7c90-45d9-c6ea-08d79a32684b
x-ms-traffictypediagnostic: VI1PR03MB4799:
x-microsoft-antispam-prvs: <VI1PR03MB4799A0033756A86A3ED8506E83360@VI1PR03MB4799.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(376002)(39830400003)(346002)(136003)(189003)(199004)(66446008)(31696002)(956004)(66946007)(86362001)(5660300002)(2616005)(85182001)(66476007)(64756008)(31686004)(508600001)(6916009)(36756003)(26005)(6486002)(2906002)(71200400001)(4326008)(16576012)(316002)(186003)(16526019)(54906003)(81156014)(52116002)(8676002)(81166006)(8936002)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR03MB4799;H:VI1PR03MB3775.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nextfour.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UjEhWoQqkxzT/vvsU2JSZ6NJdqHWZVp28WFLEWuXmhGt91RlBTENI1dLD1NLqjh+1rKcXaGwN2u0UJpQBJfnUCvNo7IXmG6wxQljAlSZiw5140rAIhSXG2cZB0J2K+Y04tobEaMms7KdaeSeVeuZsgFnLlRBdr0zv5Q7zk4xz70Um1ekyKvPQb3f5d4VuP62YoxKthI+cd7cWE94gah8ZdzYZzrDcRa+KBCGQCHPI5KDdrfQyHEH1GY/MXTErwKWAPUS9hNry9yiP8761IDMiKl7MiEJPnpjoQMS7vDBjSEL4Cke7F2YgykeCO0bbB6Db/6SRf0YESrs4UiX8IfjHomvKg7Vz34Xc1qRM7HmlrjT2OYmEBvhYqIeB4MKxUxLcDJd7AbXyG3V8Hx6yMinxzXHg3zDRMty7I5BDAFRmL7daojFeBgVDsPuVm8rr+V8
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7673813CB012A949B8A7EA6C0DAE93DA@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nextfour.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b6101b-7c90-45d9-c6ea-08d79a32684b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 03:15:58.6952
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 972e95c2-9290-4a02-8705-4014700ea294
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NfLWCPlPecdvWYIQt7lG96z7U3vegE+Uj19weEXwKzs7HZ9HiQpA4RbEUYxdHPqZyCCoVtHndJr8IFPI7xDiQJN/6rc//76QLDZTdHLKCkw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB4799
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDE2LjEuMjAyMCA0LjU5LCBBbGV4IFdpbGxpYW1zb24gd3JvdGU6DQo+IE9uIFRodSwg
MTYgSmFuIDIwMjAgMDI6MzA6NTIgKzAwMDANCj4gTWlrYSBQZW50dGlsw6QgPG1pa2EucGVudHRp
bGFAbmV4dGZvdXIuY29tPiB3cm90ZToNCj4NCj4+IE9uIDE1LjEuMjAyMCAyMi4wNiwgQWxleCBX
aWxsaWFtc29uIHdyb3RlOg0KPj4+IE9uIFR1ZSwgMTQgSmFuIDIwMjAgMjI6NTM6MDMgLTA1MDAN
Cj4+PiBZYW4gWmhhbyA8eWFuLnkuemhhb0BpbnRlbC5jb20+IHdyb3RlOg0KPj4+ICAgDQo+Pj4+
IHZmaW9fZG1hX3J3IHdpbGwgcmVhZC93cml0ZSBhIHJhbmdlIG9mIHVzZXIgc3BhY2UgbWVtb3J5
IHBvaW50ZWQgdG8gYnkNCj4+Pj4gSU9WQSBpbnRvL2Zyb20gYSBrZXJuZWwgYnVmZmVyIHdpdGhv
dXQgcGlubmluZyB0aGUgdXNlciBzcGFjZSBtZW1vcnkuDQo+Pj4+DQo+Pj4+IFRPRE86IG1hcmsg
dGhlIElPVkFzIHRvIHVzZXIgc3BhY2UgbWVtb3J5IGRpcnR5IGlmIHRoZXkgYXJlIHdyaXR0ZW4g
aW4NCj4+Pj4gdmZpb19kbWFfcncoKS4NCj4+Pj4NCj4+Pj4gQ2M6IEtldmluIFRpYW4gPGtldmlu
LnRpYW5AaW50ZWwuY29tPg0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBZYW4gWmhhbyA8eWFuLnkuemhh
b0BpbnRlbC5jb20+DQo+Pj4+IC0tLQ0KPj4+PiAgICBkcml2ZXJzL3ZmaW8vdmZpby5jICAgICAg
ICAgICAgIHwgNDUgKysrKysrKysrKysrKysrKysrKw0KPj4+PiAgICBkcml2ZXJzL3ZmaW8vdmZp
b19pb21tdV90eXBlMS5jIHwgNzYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+
Pj4+ICAgIGluY2x1ZGUvbGludXgvdmZpby5oICAgICAgICAgICAgfCAgNSArKysNCj4+Pj4gICAg
MyBmaWxlcyBjaGFuZ2VkLCAxMjYgaW5zZXJ0aW9ucygrKQ0KPj4+Pg0KPj4+PiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy92ZmlvL3ZmaW8uYyBiL2RyaXZlcnMvdmZpby92ZmlvLmMNCj4+Pj4gaW5kZXgg
Yzg0ODI2MjRjYTM0Li44YmQ1MmJjODQxY2YgMTAwNjQ0DQo+Pj4+IC0tLSBhL2RyaXZlcnMvdmZp
by92ZmlvLmMNCj4+Pj4gKysrIGIvZHJpdmVycy92ZmlvL3ZmaW8uYw0KPj4+PiBAQCAtMTk2MSw2
ICsxOTYxLDUxIEBAIGludCB2ZmlvX3VucGluX3BhZ2VzKHN0cnVjdCBkZXZpY2UgKmRldiwgdW5z
aWduZWQgbG9uZyAqdXNlcl9wZm4sIGludCBucGFnZSkNCj4+Pj4gICAgfQ0KPj4+PiAgICBFWFBP
UlRfU1lNQk9MKHZmaW9fdW5waW5fcGFnZXMpOw0KPj4+PiAgICANCj4+Pj4gKy8qDQo+Pj4+ICsg
KiBSZWFkL1dyaXRlIGEgcmFuZ2Ugb2YgSU9WQXMgcG9pbnRpbmcgdG8gdXNlciBzcGFjZSBtZW1v
cnkgaW50by9mcm9tIGEga2VybmVsDQo+Pj4+ICsgKiBidWZmZXIgd2l0aG91dCBwaW5uaW5nIHRo
ZSB1c2VyIHNwYWNlIG1lbW9yeQ0KPj4+PiArICogQGRldiBbaW5dICA6IGRldmljZQ0KPj4+PiAr
ICogQGlvdmEgW2luXSA6IGJhc2UgSU9WQSBvZiBhIHVzZXIgc3BhY2UgYnVmZmVyDQo+Pj4+ICsg
KiBAZGF0YSBbaW5dIDogcG9pbnRlciB0byBrZXJuZWwgYnVmZmVyDQo+Pj4+ICsgKiBAbGVuIFtp
bl0gIDoga2VybmVsIGJ1ZmZlciBsZW5ndGgNCj4+Pj4gKyAqIEB3cml0ZSAgICAgOiBpbmRpY2F0
ZSByZWFkIG9yIHdyaXRlDQo+Pj4+ICsgKiBSZXR1cm4gZXJyb3IgY29kZSBvbiBmYWlsdXJlIG9y
IDAgb24gc3VjY2Vzcy4NCj4+Pj4gKyAqLw0KPj4+PiAraW50IHZmaW9fZG1hX3J3KHN0cnVjdCBk
ZXZpY2UgKmRldiwgZG1hX2FkZHJfdCBpb3ZhLCB2b2lkICpkYXRhLA0KPj4+PiArCQkgICBzaXpl
X3QgbGVuLCBib29sIHdyaXRlKQ0KPj4+PiArew0KPj4+PiArCXN0cnVjdCB2ZmlvX2NvbnRhaW5l
ciAqY29udGFpbmVyOw0KPj4+PiArCXN0cnVjdCB2ZmlvX2dyb3VwICpncm91cDsNCj4+Pj4gKwlz
dHJ1Y3QgdmZpb19pb21tdV9kcml2ZXIgKmRyaXZlcjsNCj4+Pj4gKwlpbnQgcmV0ID0gMDsNCj4+
IERvIHlvdSBrbm93IHRoZSBpb3ZhIGdpdmVuIHRvIHZmaW9fZG1hX3J3KCkgaXMgaW5kZWVkIGEg
Z3BhIGFuZCBub3QgaW92YQ0KPj4gZnJvbSBhIGlvbW11IG1hcHBpbmc/IFNvIGlzbid0IGl0IHlv
dSBhY3R1YWxseSBhc3N1bWUgYWxsIHRoZSBndWVzdCBpcw0KPj4gcGlubmVkLA0KPj4gbGlrZSBm
cm9tIGRldmljZSBhc3NpZ25tZW50Pw0KPj4NCj4+IE9yIHdobyBhbmQgaG93IGlzIHRoZSB2Zmlv
IG1hcHBpbmcgYWRkZWQgYmVmb3JlIHRoZSB2ZmlvX2RtYV9ydygpID8NCj4gdmZpbyBvbmx5IGtu
b3dzIGFib3V0IElPVkFzLCBub3QgR1BBcy4gIEl0J3MgcG9zc2libGUgdGhhdCBJT1ZBcyBhcmUN
Cj4gaWRlbnRpdHkgbWFwcGVkIHRvIHRoZSBHUEEgc3BhY2UsIGJ1dCBhIFZNIHdpdGggYSB2SU9N
TVUgd291bGQgcXVpY2tseQ0KPiBicmVhayBhbnkgc3VjaCBhc3N1bXB0aW9uLiAgUGlubmluZyBp
cyBhbHNvIG5vdCByZXF1aXJlZC4gIFRoaXMgYWNjZXNzDQo+IGlzIHZpYSB0aGUgQ1BVLCBub3Qg
dGhlIEkvTyBkZXZpY2UsIHNvIHdlIGRvbid0IHJlcXVpcmUgdGhlIG1lbW9yeSB0bw0KPiBiZSBw
aW5uaW5nIGFuZCBpdCBwb3RlbnRpYWxseSB3b24ndCBiZSBmb3IgYSBub24tSU9NTVUgYmFja2Vk
IG1lZGlhdGVkDQo+IGRldmljZS4gIFRoZSBpbnRlbnRpb24gaGVyZSBpcyB0aGF0IHZpYSB0aGUg
bWVkaWF0aW9uIG9mIGFuIG1kZXYNCj4gZGV2aWNlLCBhIHZlbmRvciBkcml2ZXIgd291bGQgYWxy
ZWFkeSBrbm93IElPVkEgcmFuZ2VzIGZvciB0aGUgZGV2aWNlDQo+IHRvIGFjY2VzcyB2aWEgdGhl
IGd1ZXN0IGRyaXZlciBwcm9ncmFtbWluZyBvZiB0aGUgZGV2aWNlLiAgVGhhbmtzLA0KPg0KPiBB
bGV4DQoNClRoYW5rcyBBbGV4Li4uIHlvdSBtZWFuIElPVkEgaXMgaW4gdGhlIGNhc2Ugb2YgaW9t
bXUgYWxyZWFkeSBhIA0KaW9tbXUtdHJhbnNsYXRlZCBhZGRyZXNzIHRvIGEgdXNlciBzcGFjZSBW
QSBpbiBWTSBob3N0IHNwYWNlPw0KSG93IGRvZXMgaXQgZ2V0IHRvIGhvbGQgb24gdGhhdD8gV2hh
dCBwaWVjZSBvZiBtZWRpdGF0aW9uIGlzIHJlc3BvbnNpYmxlIA0KZm9yIHRoaXM/DQoNCi0tTWlr
YQ0KDQo=
