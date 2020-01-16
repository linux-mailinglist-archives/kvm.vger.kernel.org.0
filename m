Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75CC413D236
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 03:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbgAPCbj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 21:31:39 -0500
Received: from mail-eopbgr70041.outbound.protection.outlook.com ([40.107.7.41]:2222
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726513AbgAPCbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 21:31:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HR0gpZAIDLir9/xnlKZJf+A8OzMAHnA2Dj880bsokDpgvgrFelesM6ZHZDjA6Sa7KYa+BBdB0m6JyWQvr2ckupuWZ9ciu11+gXnnH2m5riGyUmnLFpIy60zf6Xs6ntltvXo8UGxD6bm3CHwhg8QY6V+CBT4s8GdzaJFY1cEiPd5ZK7f2LjSarb7M2BJPZQjvgZQrWkgmlRz6dmUUBcs/fGpHxozaFSWq6/SUbmjIwAGj6ysb+YKq1HkUAyOsj0zOFtgGTaZe9mb/t+GcCh/VKc+OKzKJOh18xuQrnYREgcg7QMylkiEh2OwfZ0oHb5ldJwglydJMw6685AHEdg+Epw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNf7NOzBlVEVnItBVhSPKv5ExYYinWHj6hAshwgZxGY=;
 b=JFJLXxEbReL0u3qdc01Tv5PGks2RD6brXp+9ANnFCQ9lL9k+taQpf3fnz8b3veiMi7DkEKoEWTuUFFjhoIIKVBhLCnY6gOp4NA6eCs3ToW8UfN6s4wWUGNNAs1Ur1mvF7lANOFTOR/e3J1o0B9craC7/PMCecaiNFkq4UO1acP9uo00pDTIf3UIjmHf3T+VCo0AlrwckKVOGpvQ5gSmJ+Nbl01hYNNLqmmMF45YZOmtqXYDSji3KTdCAt4lC3JR3Oux8puJYlGgpkAp11noIa6HBSRoP2w+mrWJX1OxY5QqkAqhVYfkzBf7A0SDHd3aYWVOUoG7kw8x8iggGSZ8E6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nextfour.com; dmarc=pass action=none header.from=nextfour.com;
 dkim=pass header.d=nextfour.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NextfourGroupOy.onmicrosoft.com;
 s=selector2-NextfourGroupOy-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNf7NOzBlVEVnItBVhSPKv5ExYYinWHj6hAshwgZxGY=;
 b=p5hVayL77QYeNipp7UoRP3EN0wgyAnNc/4gq4T9n/gXbycYhDjxAsHbUlDGOY2M/Q9cBueqTcpQBM1epENx0DEJDDuJzSgvRgbIc1dPg8y4hyUX9JQiV1x0KDgf40ymEHu5rbOn4ef0OS8G6tNWe4R/vSJJyvnCzgBFqR8kk+TQ=
Received: from VI1PR03MB3775.eurprd03.prod.outlook.com (52.134.21.155) by
 VI1PR03MB3582.eurprd03.prod.outlook.com (52.134.26.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Thu, 16 Jan 2020 02:30:53 +0000
Received: from VI1PR03MB3775.eurprd03.prod.outlook.com
 ([fe80::fdfe:b987:16ad:9de9]) by VI1PR03MB3775.eurprd03.prod.outlook.com
 ([fe80::fdfe:b987:16ad:9de9%5]) with mapi id 15.20.2623.018; Thu, 16 Jan 2020
 02:30:53 +0000
Received: from [192.168.1.121] (91.145.109.188) by HE1PR0701CA0071.eurprd07.prod.outlook.com (2603:10a6:3:64::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.10 via Frontend Transport; Thu, 16 Jan 2020 02:30:52 +0000
From:   =?utf-8?B?TWlrYSBQZW50dGlsw6Q=?= <mika.penttila@nextfour.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>
CC:     "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
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
Thread-Index: AQHVy1izPc+ONnk2aUegZV3QDrVrz6fsJ+UAgABrWAA=
Date:   Thu, 16 Jan 2020 02:30:52 +0000
Message-ID: <80cf3888-2e51-3fd7-a064-213e7ded188e@nextfour.com>
References: <20200115034132.2753-1-yan.y.zhao@intel.com>
 <20200115035303.12362-1-yan.y.zhao@intel.com>
 <20200115130638.6926dd08@w520.home>
In-Reply-To: <20200115130638.6926dd08@w520.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0701CA0071.eurprd07.prod.outlook.com
 (2603:10a6:3:64::15) To VI1PR03MB3775.eurprd03.prod.outlook.com
 (2603:10a6:803:2b::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mika.penttila@nextfour.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [91.145.109.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f6a1b21-5f78-45ed-b90b-08d79a2c1b8c
x-ms-traffictypediagnostic: VI1PR03MB3582:
x-microsoft-antispam-prvs: <VI1PR03MB3582FF5E399CF22B870C91B283360@VI1PR03MB3582.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(136003)(346002)(396003)(39830400003)(189003)(199004)(31686004)(8676002)(16526019)(54906003)(31696002)(81156014)(16576012)(36756003)(2616005)(8936002)(86362001)(186003)(81166006)(26005)(110136005)(71200400001)(66556008)(4326008)(6486002)(64756008)(66446008)(85182001)(2906002)(66476007)(5660300002)(66946007)(508600001)(956004)(316002)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR03MB3582;H:VI1PR03MB3775.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nextfour.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F3V3raZja/DAqhbbXS8M316jYGjGnITssmOz30ysl1jhbtcspatnHpD26lNCb4c7OHKNQqWTgBc61V5N0MxgxuEC/WF5juDkRy01TBdmHnbSzExpGWrTC3ILPAnNPWN5O6gCV+xufMoZTJQ/MaF9TODCdFcZV9s5PVsM9B7JEC0jhWKL7oqTAtPH9uhB+e3gvfeTxnH+U5fMA5gGUUvYCtDZ1pD4RPjM7iWh6RU9Xs6V5n4R/WCwSl48sodwSv8si1IBuL6LpwjebZ860qPTwMVMU+IBgBObekpflB0Pb9LetehExf9GLfxqSmldjos9jKurQ3ZJMbGP/WyZOWoWC7fJfdiw2aS14fvYbVWye26YVpnJHdV7VRnRX3XAR8wuwQ+ZQARXhKOIlrNKpiqCYU03irV+ULAg4D49NyL9xF+yy9rZOOvvayUsATbSKiCV
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A03A68253609840BF1CFE9C065D25C4@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nextfour.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f6a1b21-5f78-45ed-b90b-08d79a2c1b8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 02:30:52.9889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 972e95c2-9290-4a02-8705-4014700ea294
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OVR7qSQOJHtwD6pO4lLw9poKhRCpCCrKlWYBCk/OBFyuxpqlFselY0lLaCGr82gZHozhYRKtmjaiUg3ElwuHL+DuTp92ZnWBhoRPKYcpq1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB3582
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDE1LjEuMjAyMCAyMi4wNiwgQWxleCBXaWxsaWFtc29uIHdyb3RlOg0KPiBPbiBUdWUs
IDE0IEphbiAyMDIwIDIyOjUzOjAzIC0wNTAwDQo+IFlhbiBaaGFvIDx5YW4ueS56aGFvQGludGVs
LmNvbT4gd3JvdGU6DQo+DQo+PiB2ZmlvX2RtYV9ydyB3aWxsIHJlYWQvd3JpdGUgYSByYW5nZSBv
ZiB1c2VyIHNwYWNlIG1lbW9yeSBwb2ludGVkIHRvIGJ5DQo+PiBJT1ZBIGludG8vZnJvbSBhIGtl
cm5lbCBidWZmZXIgd2l0aG91dCBwaW5uaW5nIHRoZSB1c2VyIHNwYWNlIG1lbW9yeS4NCj4+DQo+
PiBUT0RPOiBtYXJrIHRoZSBJT1ZBcyB0byB1c2VyIHNwYWNlIG1lbW9yeSBkaXJ0eSBpZiB0aGV5
IGFyZSB3cml0dGVuIGluDQo+PiB2ZmlvX2RtYV9ydygpLg0KPj4NCj4+IENjOiBLZXZpbiBUaWFu
IDxrZXZpbi50aWFuQGludGVsLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IFlhbiBaaGFvIDx5YW4u
eS56aGFvQGludGVsLmNvbT4NCj4+IC0tLQ0KPj4gICBkcml2ZXJzL3ZmaW8vdmZpby5jICAgICAg
ICAgICAgIHwgNDUgKysrKysrKysrKysrKysrKysrKw0KPj4gICBkcml2ZXJzL3ZmaW8vdmZpb19p
b21tdV90eXBlMS5jIHwgNzYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+PiAg
IGluY2x1ZGUvbGludXgvdmZpby5oICAgICAgICAgICAgfCAgNSArKysNCj4+ICAgMyBmaWxlcyBj
aGFuZ2VkLCAxMjYgaW5zZXJ0aW9ucygrKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Zm
aW8vdmZpby5jIGIvZHJpdmVycy92ZmlvL3ZmaW8uYw0KPj4gaW5kZXggYzg0ODI2MjRjYTM0Li44
YmQ1MmJjODQxY2YgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL3ZmaW8vdmZpby5jDQo+PiArKysg
Yi9kcml2ZXJzL3ZmaW8vdmZpby5jDQo+PiBAQCAtMTk2MSw2ICsxOTYxLDUxIEBAIGludCB2Zmlv
X3VucGluX3BhZ2VzKHN0cnVjdCBkZXZpY2UgKmRldiwgdW5zaWduZWQgbG9uZyAqdXNlcl9wZm4s
IGludCBucGFnZSkNCj4+ICAgfQ0KPj4gICBFWFBPUlRfU1lNQk9MKHZmaW9fdW5waW5fcGFnZXMp
Ow0KPj4gICANCj4+ICsvKg0KPj4gKyAqIFJlYWQvV3JpdGUgYSByYW5nZSBvZiBJT1ZBcyBwb2lu
dGluZyB0byB1c2VyIHNwYWNlIG1lbW9yeSBpbnRvL2Zyb20gYSBrZXJuZWwNCj4+ICsgKiBidWZm
ZXIgd2l0aG91dCBwaW5uaW5nIHRoZSB1c2VyIHNwYWNlIG1lbW9yeQ0KPj4gKyAqIEBkZXYgW2lu
XSAgOiBkZXZpY2UNCj4+ICsgKiBAaW92YSBbaW5dIDogYmFzZSBJT1ZBIG9mIGEgdXNlciBzcGFj
ZSBidWZmZXINCj4+ICsgKiBAZGF0YSBbaW5dIDogcG9pbnRlciB0byBrZXJuZWwgYnVmZmVyDQo+
PiArICogQGxlbiBbaW5dICA6IGtlcm5lbCBidWZmZXIgbGVuZ3RoDQo+PiArICogQHdyaXRlICAg
ICA6IGluZGljYXRlIHJlYWQgb3Igd3JpdGUNCj4+ICsgKiBSZXR1cm4gZXJyb3IgY29kZSBvbiBm
YWlsdXJlIG9yIDAgb24gc3VjY2Vzcy4NCj4+ICsgKi8NCj4+ICtpbnQgdmZpb19kbWFfcncoc3Ry
dWN0IGRldmljZSAqZGV2LCBkbWFfYWRkcl90IGlvdmEsIHZvaWQgKmRhdGEsDQo+PiArCQkgICBz
aXplX3QgbGVuLCBib29sIHdyaXRlKQ0KPj4gK3sNCj4+ICsJc3RydWN0IHZmaW9fY29udGFpbmVy
ICpjb250YWluZXI7DQo+PiArCXN0cnVjdCB2ZmlvX2dyb3VwICpncm91cDsNCj4+ICsJc3RydWN0
IHZmaW9faW9tbXVfZHJpdmVyICpkcml2ZXI7DQo+PiArCWludCByZXQgPSAwOw0KDQpEbyB5b3Ug
a25vdyB0aGUgaW92YSBnaXZlbiB0byB2ZmlvX2RtYV9ydygpIGlzIGluZGVlZCBhIGdwYSBhbmQg
bm90IGlvdmEgDQpmcm9tIGEgaW9tbXUgbWFwcGluZz8gU28gaXNuJ3QgaXQgeW91IGFjdHVhbGx5
IGFzc3VtZSBhbGwgdGhlIGd1ZXN0IGlzIA0KcGlubmVkLA0KbGlrZSBmcm9tIGRldmljZSBhc3Np
Z25tZW50Pw0KDQpPciB3aG8gYW5kIGhvdyBpcyB0aGUgdmZpbyBtYXBwaW5nIGFkZGVkIGJlZm9y
ZSB0aGUgdmZpb19kbWFfcncoKSA/DQoNClRoYW5rcywNCk1pa2ENCg0K
