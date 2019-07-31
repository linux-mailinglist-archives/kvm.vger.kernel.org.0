Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF8F7C46C
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 16:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbfGaOK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 10:10:56 -0400
Received: from mail-eopbgr20139.outbound.protection.outlook.com ([40.107.2.139]:14212
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728483AbfGaOK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 10:10:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFOTP4UKmMzcZ+GwvWTqhzCaFGaERkRT69DAOV8ZhVfWxDqyxqbyEs2apNFkLQjH2m02BEZVMzlVVaOq4z/3ZaQL2KGcHkt6QnsgnbiJBbZ9u298GEh3BsO/kItt0llD7Vey+Qb3Sak/hATPQzkDEz9vgy9oI8FLEuAcPTy+2gdxadH7qQ0VlLyschOD0oUt8skkekag8UYKhXQK0BzE77LsQzwN0Fm+o3m86OaGNqQsSMdXevZ0PGYT9o+d+SLQWRN1o/6nKfh3/0bI+/OM8rQGn+TYdbsAoR+G6urkC5Fs/OWx8BPxfWNVyVblgOBOsEmdFWXtB0eLx9f8HMjK7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PObjmhYmW8tiCTOm+Of/l2FN3xQw3W1CKoKitXBt0dg=;
 b=ZDoZ02v9sohIkvudFGsFegDa1zfZo13PcGyavzEmmr13oK5D2zTHNFlmw91L7D49Qa2DNwGghwayju0bGEBWF09t6z9UnPgitcbUEm0kvK8eB4Vl1bGnaOOoE2IAbD79We9yWEDyeHhoQoSuep6KLNqgGbSELgw9flybfV0FDlnT8vwivNwURDlAfMOMtGVJVMQlSiavWrB4pRzQxUM+RkhaJHHjuD4Pe+CF++D9W2xSlA/s2x125sfcqYSVod6WaAS41ebZrKxs9VJ2NXrhtB5Dy0eH/Grxx/ZRMOJAh91EcdGjFvh98utu9MyoUEmqouOU9ew1vOh9aWAJVm5yTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=virtuozzo.com;dmarc=pass action=none
 header.from=virtuozzo.com;dkim=pass header.d=virtuozzo.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PObjmhYmW8tiCTOm+Of/l2FN3xQw3W1CKoKitXBt0dg=;
 b=aMKmrpisIE9GwVbgSIFXUc395VN3iYh2PF8Dno0j2YkZ+wYNRV+BzZPuGup739IR6gEIgaFQsgQwJkKzHli4eXDdlt5gVNOrwENx3QGJmmP2swjUrR6QmVg2zJSgBLR56q6oOCwuHcInrK/PogRJhAaVPNaSFVB8/GkLcfx56MI=
Received: from VI1PR08MB4399.eurprd08.prod.outlook.com (20.179.28.141) by
 VI1PR08MB2925.eurprd08.prod.outlook.com (10.170.239.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Wed, 31 Jul 2019 14:10:50 +0000
Received: from VI1PR08MB4399.eurprd08.prod.outlook.com
 ([fe80::303d:1bb9:76b2:99d7]) by VI1PR08MB4399.eurprd08.prod.outlook.com
 ([fe80::303d:1bb9:76b2:99d7%6]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 14:10:50 +0000
From:   Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>,
        "qemu-block@nongnu.org" <qemu-block@nongnu.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        "berto@igalia.com" <berto@igalia.com>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "mdroth@linux.vnet.ibm.com" <mdroth@linux.vnet.ibm.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        Denis Lunev <den@virtuozzo.com>,
        "rth@twiddle.net" <rth@twiddle.net>
Subject: Re: [Qemu-devel] [PATCH 3/3] i386/kvm: initialize struct at full
 before ioctl call
Thread-Topic: [Qemu-devel] [PATCH 3/3] i386/kvm: initialize struct at full
 before ioctl call
Thread-Index: AQHVRvAnLLtzNA+T0EeBbI/1wGIp+qbjXlwAgAAFsoCAAQw4gIAAOciAgAAbkYA=
Date:   Wed, 31 Jul 2019 14:10:50 +0000
Message-ID: <cb3960b5-2ebe-ddeb-b4e6-4e085ecb5020@virtuozzo.com>
References: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
 <1564502498-805893-4-git-send-email-andrey.shinkevich@virtuozzo.com>
 <7a78ef04-4120-20d9-d5f4-6572c5676344@redhat.com>
 <dc9c2e70-c2a6-838e-f191-1c2787e244f5@de.ibm.com> <m136imo9ps.fsf@redhat.com>
 <038487b3-0b39-0695-7ef7-ede1b3143ad1@redhat.com>
In-Reply-To: <038487b3-0b39-0695-7ef7-ede1b3143ad1@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0402CA0032.eurprd04.prod.outlook.com
 (2603:10a6:7:7c::21) To VI1PR08MB4399.eurprd08.prod.outlook.com
 (2603:10a6:803:102::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=andrey.shinkevich@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [185.231.240.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cbf5ad90-1be7-4eed-1a44-08d715c0e405
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR08MB2925;
x-ms-traffictypediagnostic: VI1PR08MB2925:
x-microsoft-antispam-prvs: <VI1PR08MB29255B349B71B2458F9CFB46F4DF0@VI1PR08MB2925.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(39850400004)(396003)(366004)(346002)(199004)(189003)(44832011)(36756003)(26005)(31686004)(316002)(2906002)(486006)(186003)(25786009)(446003)(8936002)(7416002)(6486002)(6506007)(53546011)(4326008)(386003)(11346002)(102836004)(476003)(2616005)(6246003)(229853002)(3846002)(6116002)(52116002)(8676002)(76176011)(5660300002)(256004)(31696002)(66066001)(81156014)(110136005)(54906003)(81166006)(14454004)(478600001)(2501003)(68736007)(7736002)(6436002)(305945005)(71190400001)(71200400001)(64756008)(66446008)(86362001)(66476007)(66556008)(99286004)(66946007)(6512007)(53936002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB2925;H:VI1PR08MB4399.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yok5djC2Yv/vJABCWi7GJzTI9ZyCTbE3fDbty5goo8Mgd8EvZbagi75Dz1Is1RAGBPNCd9Y3rdnSuXzkqKdYJeBd7DjFfQFFPXE7iJCTcF8vdGCTXz4aQ8mj8lNuK60GpmKaBrExL/+VkFwErzIrMudomy9izOh6Zi2qmx+br/345lLOZ2TgDE0wj8PANcfEpaH6K8yrKh4AAXq22u33Y7gNnaAzNv/ijY4t6eYxr64XK0Dx9BPgj8ROpvBjEJCkdyUMo2e0PTkwADRXfZRgOccnRmIoD9F/npC+1WI2H+jo1gML3VPOSfWEramsAK9cayltaD9wHxFjD3c7RXpBEgMv3wfJPfcR2icb+uViGXuc67ZTfsPpuspfDNp3cXvhv83ynfJGx2Gs0GVgMKxyoFu85m0MRztpwe6wGfOt3vA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <40D9F4DD4A99BB448E609F78E24C4F4C@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbf5ad90-1be7-4eed-1a44-08d715c0e405
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 14:10:50.2236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: andrey.shinkevich@virtuozzo.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB2925
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDMxLzA3LzIwMTkgMTU6MzIsIFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+IE9uIDMxLzA3
LzE5IDExOjA1LCBDaHJpc3RvcGhlIGRlIERpbmVjaGluIHdyb3RlOg0KPj4NCj4+IENocmlzdGlh
biBCb3JudHJhZWdlciB3cml0ZXM6DQo+Pg0KPj4+IE9uIDMwLjA3LjE5IDE4OjQ0LCBQaGlsaXBw
ZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4+Pj4gT24gNy8zMC8xOSA2OjAxIFBNLCBBbmRyZXkg
U2hpbmtldmljaCB3cm90ZToNCj4+Pj4+IE5vdCB0aGUgd2hvbGUgc3RydWN0dXJlIGlzIGluaXRp
YWxpemVkIGJlZm9yZSBwYXNzaW5nIGl0IHRvIHRoZSBLVk0uDQo+Pj4+PiBSZWR1Y2UgdGhlIG51
bWJlciBvZiBWYWxncmluZCByZXBvcnRzLg0KPj4+Pj4NCj4+Pj4+IFNpZ25lZC1vZmYtYnk6IEFu
ZHJleSBTaGlua2V2aWNoIDxhbmRyZXkuc2hpbmtldmljaEB2aXJ0dW96em8uY29tPg0KPj4+Pj4g
LS0tDQo+Pj4+PiAgIHRhcmdldC9pMzg2L2t2bS5jIHwgMyArKysNCj4+Pj4+ICAgMSBmaWxlIGNo
YW5nZWQsIDMgaW5zZXJ0aW9ucygrKQ0KPj4+Pj4NCj4+Pj4+IGRpZmYgLS1naXQgYS90YXJnZXQv
aTM4Ni9rdm0uYyBiL3RhcmdldC9pMzg2L2t2bS5jDQo+Pj4+PiBpbmRleCBkYmJiMTM3Li5lZDU3
ZTMxIDEwMDY0NA0KPj4+Pj4gLS0tIGEvdGFyZ2V0L2kzODYva3ZtLmMNCj4+Pj4+ICsrKyBiL3Rh
cmdldC9pMzg2L2t2bS5jDQo+Pj4+PiBAQCAtMTkwLDYgKzE5MCw3IEBAIHN0YXRpYyBpbnQga3Zt
X2dldF90c2MoQ1BVU3RhdGUgKmNzKQ0KPj4+Pj4gICAgICAgICAgIHJldHVybiAwOw0KPj4+Pj4g
ICAgICAgfQ0KPj4+Pj4NCj4+Pj4+ICsgICAgbWVtc2V0KCZtc3JfZGF0YSwgMCwgc2l6ZW9mKG1z
cl9kYXRhKSk7DQo+Pj4+DQo+Pj4+IEkgd29uZGVyIHRoZSBvdmVyaGVhZCBvZiB0aGlzIG9uZS4u
Lg0KPj4+DQo+Pj4gQ2FudCB3ZSB1c2UgZGVzaWduYXRlZCBpbml0aWFsaXplcnMgbGlrZSBpbg0K
Pj4+DQo+Pj4gY29tbWl0IGJkZmM4NDgwYzUwYTUzZDkxYWE5YTUxM2QyM2E4NGRlMGQ1ZmJjODYN
Cj4+PiBBdXRob3I6ICAgICBDaHJpc3RpYW4gQm9ybnRyYWVnZXIgPGJvcm50cmFlZ2VyQGRlLmli
bS5jb20+DQo+Pj4gQXV0aG9yRGF0ZTogVGh1IE9jdCAzMCAwOToyMzo0MSAyMDE0ICswMTAwDQo+
Pj4gQ29tbWl0OiAgICAgUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4+PiBD
b21taXREYXRlOiBNb24gRGVjIDE1IDEyOjIxOjAxIDIwMTQgKzAxMDANCj4+Pg0KPj4+ICAgICAg
dmFsZ3JpbmQvaTM4NjogYXZvaWQgZmFsc2UgcG9zaXRpdmVzIG9uIEtWTV9TRVRfWENSUyBpb2N0
bA0KPj4+DQo+Pj4gYW5kIG90aGVycz8NCj4+Pg0KPj4+IFRoaXMgc2hvdWxkIG1pbmltaXplIHRo
ZSBpbXBhY3QuDQo+Pg0KPj4gT2gsIHdoZW4geW91IHRhbGtlZCBhYm91dCB1c2luZyBkZXNpZ25h
dGVkIGluaXRpYWxpemVycywgSSB0aG91Z2h0IHlvdQ0KPj4gd2VyZSB0YWxraW5nIGFib3V0IGZ1
bGx5IGluaXRpYWxpemluZyB0aGUgc3RydWN0LCBsaWtlIHNvOg0KPiANCj4gWWVhaCwgdGhhdCB3
b3VsZCBiZSBnb29kIHRvby4gIEZvciBub3cgSSdtIGFwcGx5aW5nIEFuZHJleSdzIHNlcmllcyB0
aG91Z2guDQo+IA0KPiBQYW9sbw0KPiANCg0KVGhhbmsgeW91Lg0KQXMgUGhpbGlwcGUgd3JvdGUs
ICdkYmdyZWdzLmZsYWdzID0gMDsnIGlzIHVubmVjZXNzYXJ5IHdpdGggJ21lbXNldCgwKScuDQoN
CkFuZHJleQ0KDQo+PiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L2kzODYva3ZtLmMgYi90YXJnZXQvaTM4
Ni9rdm0uYw0KPj4gaW5kZXggZGJiYjEzNzcyYS4uMzUzMzg3MGM0MyAxMDA2NDQNCj4+IC0tLSBh
L3RhcmdldC9pMzg2L2t2bS5jDQo+PiArKysgYi90YXJnZXQvaTM4Ni9rdm0uYw0KPj4gQEAgLTE4
MCwxOSArMTgwLDIwIEBAIHN0YXRpYyBpbnQga3ZtX2dldF90c2MoQ1BVU3RhdGUgKmNzKQ0KPj4g
ICB7DQo+PiAgICAgICBYODZDUFUgKmNwdSA9IFg4Nl9DUFUoY3MpOw0KPj4gICAgICAgQ1BVWDg2
U3RhdGUgKmVudiA9ICZjcHUtPmVudjsNCj4+IC0gICAgc3RydWN0IHsNCj4+IC0gICAgICAgIHN0
cnVjdCBrdm1fbXNycyBpbmZvOw0KPj4gLSAgICAgICAgc3RydWN0IGt2bV9tc3JfZW50cnkgZW50
cmllc1sxXTsNCj4+IC0gICAgfSBtc3JfZGF0YTsNCj4+ICAgICAgIGludCByZXQ7DQo+Pg0KPj4g
ICAgICAgaWYgKGVudi0+dHNjX3ZhbGlkKSB7DQo+PiAgICAgICAgICAgcmV0dXJuIDA7DQo+PiAg
ICAgICB9DQo+Pg0KPj4gLSAgICBtc3JfZGF0YS5pbmZvLm5tc3JzID0gMTsNCj4+IC0gICAgbXNy
X2RhdGEuZW50cmllc1swXS5pbmRleCA9IE1TUl9JQTMyX1RTQzsNCj4+IC0gICAgZW52LT50c2Nf
dmFsaWQgPSAhcnVuc3RhdGVfaXNfcnVubmluZygpOw0KPj4gKyAgICBzdHJ1Y3Qgew0KPj4gKyAg
ICAgICAgc3RydWN0IGt2bV9tc3JzIGluZm87DQo+PiArICAgICAgICBzdHJ1Y3Qga3ZtX21zcl9l
bnRyeSBlbnRyaWVzWzFdOw0KPj4gKyAgICB9IG1zcl9kYXRhID0gew0KPj4gKyAgICAgICAgLmlu
Zm8gPSB7IC5ubXNycyA9ICAxIH0sDQo+PiArICAgICAgICAuZW50cmllcyA9IHsgWzBdID0geyAu
aW5kZXggPSBNU1JfSUEzMl9UU0MgfSB9DQo+PiArICAgIH07DQo+PiArICAgICBlbnYtPnRzY192
YWxpZCA9ICFydW5zdGF0ZV9pc19ydW5uaW5nKCk7DQo+Pg0KPj4gICAgICAgcmV0ID0ga3ZtX3Zj
cHVfaW9jdGwoQ1BVKGNwdSksIEtWTV9HRVRfTVNSUywgJm1zcl9kYXRhKTsNCj4+ICAgICAgIGlm
IChyZXQgPCAwKSB7DQo+Pg0KPj4NCj4+IFRoaXMgZ2l2ZXMgdGhlIGNvbXBpbGVyIG1heGltdW0g
b3Bwb3J0dW5pdGllcyB0byBmbGFnIG1pc3Rha2VzIGxpa2UNCj4+IGluaXRpYWxpemluZyB0aGUg
c2FtZSB0aGluZyB0d2ljZSwgYW5kIG1ha2UgaXQgZWFzaWVyIChyZWFkIG5vIHNtYXJ0DQo+PiBv
cHRpbWl6YXRpb25zKSB0byBpbml0aWFsaXplIGluIG9uZSBnby4gTW92aW5nIHRoZSBkZWNsYXJh
dGlvbiBwYXN0IHRoZQ0KPj4gJ2lmJyBhbHNvIGFkZHJlc3NlcyBQaGlsaXBwZSdzIGNvbmNlcm4u
DQo+Pg0KPj4+Pg0KPj4+Pj4gICAgICAgbXNyX2RhdGEuaW5mby5ubXNycyA9IDE7DQo+Pj4+PiAg
ICAgICBtc3JfZGF0YS5lbnRyaWVzWzBdLmluZGV4ID0gTVNSX0lBMzJfVFNDOw0KPj4+Pj4gICAg
ICAgZW52LT50c2NfdmFsaWQgPSAhcnVuc3RhdGVfaXNfcnVubmluZygpOw0KPj4+Pj4gQEAgLTE3
MDYsNiArMTcwNyw3IEBAIGludCBrdm1fYXJjaF9pbml0X3ZjcHUoQ1BVU3RhdGUgKmNzKQ0KPj4+
Pj4NCj4+Pj4+ICAgICAgIGlmIChoYXNfeHNhdmUpIHsNCj4+Pj4+ICAgICAgICAgICBlbnYtPnhz
YXZlX2J1ZiA9IHFlbXVfbWVtYWxpZ24oNDA5Niwgc2l6ZW9mKHN0cnVjdCBrdm1feHNhdmUpKTsN
Cj4+Pj4+ICsgICAgICAgIG1lbXNldChlbnYtPnhzYXZlX2J1ZiwgMCwgc2l6ZW9mKHN0cnVjdCBr
dm1feHNhdmUpKTsNCj4+Pj4NCj4+Pj4gT0sNCj4+Pj4NCj4+Pj4+ICAgICAgIH0NCj4+Pj4+DQo+
Pj4+PiAgICAgICBtYXhfbmVzdGVkX3N0YXRlX2xlbiA9IGt2bV9tYXhfbmVzdGVkX3N0YXRlX2xl
bmd0aCgpOw0KPj4+Pj4gQEAgLTM0NzcsNiArMzQ3OSw3IEBAIHN0YXRpYyBpbnQga3ZtX3B1dF9k
ZWJ1Z3JlZ3MoWDg2Q1BVICpjcHUpDQo+Pj4+PiAgICAgICAgICAgcmV0dXJuIDA7DQo+Pj4+PiAg
ICAgICB9DQo+Pj4+Pg0KPj4+Pj4gKyAgICBtZW1zZXQoJmRiZ3JlZ3MsIDAsIHNpemVvZihkYmdy
ZWdzKSk7DQo+Pj4+DQo+Pj4+IE9LDQo+Pj4+DQo+Pj4+PiAgICAgICBmb3IgKGkgPSAwOyBpIDwg
NDsgaSsrKSB7DQo+Pj4+PiAgICAgICAgICAgZGJncmVncy5kYltpXSA9IGVudi0+ZHJbaV07DQo+
Pj4+PiAgICAgICB9DQo+Pj4+DQo+Pj4+IFdlIGNvdWxkIHJlbW92ZSAnZGJncmVncy5mbGFncyA9
IDA7Jw0KPj4+Pg0KPj4+PiBSZXZpZXdlZC1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBo
aWxtZEByZWRoYXQuY29tPg0KPj4+Pg0KPj4NCj4+DQo+PiAtLQ0KPj4gQ2hlZXJzLA0KPj4gQ2hy
aXN0b3BoZSBkZSBEaW5lY2hpbiAoSVJDIGMzZCkNCj4+DQo+IA0KDQotLSANCldpdGggdGhlIGJl
c3QgcmVnYXJkcywNCkFuZHJleSBTaGlua2V2aWNoDQoNCg==
