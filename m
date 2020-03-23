Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7348918FDE0
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 20:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgCWTmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 15:42:42 -0400
Received: from mail-dm6nam10on2063.outbound.protection.outlook.com ([40.107.93.63]:8229
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726177AbgCWTml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 15:42:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUvrd4V0/HYoCAH2exdhlsxwGB+ebA0NY3b+rf7J2Auf58jVHUbjgGtierIkakP8Au+jvSjzkyJ1VgS4+Eo+3kmpv4xHunVfXfJjme1g0lXDuq+2YD4alPeEjvv1AP53SJI0LCAgxfwGJEa1YkCwZsmCIHK3PH4tEOcfUc8+CQBCYOSeJQxN7nFLJBuJ6FUoTfPplLbTbwj6Cmjxu9436ROrxbajJkK7o5wRrlayk4obHioBuK2h4vHgrCflmTqIPhXHEY/f6JI/QzEr+2uJDxdrtb/qlPZ0vdksHPDr8CSFC+x6DMrP2avR9UXw5PJUdFQCAynKnLYV+vzzw2hcHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RjrBR/59FJF3qhN+z8azWgxEMmFc09vz7esDTwjbtec=;
 b=aksYcRSjoFmVYvLZPybgczpaSSNQZfxis6+Nq//UgQ/AHDIwjsDRSnRO8yi84athlGwQmKPOQrJgN0tgT99gOShI84hYuH5ZKCduDVbrtRynT2zvRsx6NFpPr8+4AlvuLyvJ+EgY4EbMZdT+/QKgLlikJKRDS0DXN+Dcj2EdT0DXn/+HahpHzE3T3BILO/gegn8V52JiekE059jMHHiELuEFOf/kfC9OJkaxITZGPOOUl/R8nb5//9KqzQZYrL+9hezsZLrKLPh0eerKU50CJKwfkQzsV4fohhby9de6UibtW+lKvQUKaSkvFdNqlMtu5tOmHGcwWGgOnJFagx6isA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RjrBR/59FJF3qhN+z8azWgxEMmFc09vz7esDTwjbtec=;
 b=j4wsyfgn0Kv0X7gnfQdOl89uPJO8hXS2OgC7TJwLcOwXADndD4yQkJvSfjWeKpaEtLQR/9+Ehq39uFvzysGqA7KeQRuX1uR8RdlK7oiSh2CQaYJqgGIUcdwRLp3p5VYABThWNmGU6Cry+mW7kSNx9w1gdVJ2XWXgY6zgIW+pkBI=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (2603:10b6:a03:4a::18)
 by BYAPR05MB5366.namprd05.prod.outlook.com (2603:10b6:a03:1e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.9; Mon, 23 Mar
 2020 19:42:38 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::7c65:25af:faf7:5331]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::7c65:25af:faf7:5331%2]) with mapi id 15.20.2835.017; Mon, 23 Mar 2020
 19:42:38 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86: vmx: Fix "EPT violation - paging structure" test
Thread-Topic: [PATCH] x86: vmx: Fix "EPT violation - paging structure" test
Thread-Index: AQHV/z6s28XcZ0CORU+qkOHE+yGr/qhWl+wA
Date:   Mon, 23 Mar 2020 19:42:38 +0000
Message-ID: <64D198E0-C022-407D-BC1C-C4C8E77F8D31@vmware.com>
References: <20200321050555.4212-1-namit@vmware.com>
In-Reply-To: <20200321050555.4212-1-namit@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [2601:647:4700:9b2:891d:581c:617:a1a1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38844162-4a77-4741-cd80-08d7cf625834
x-ms-traffictypediagnostic: BYAPR05MB5366:
x-microsoft-antispam-prvs: <BYAPR05MB5366877E67A938854CA119BFD0F00@BYAPR05MB5366.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0351D213B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(76116006)(4326008)(6916009)(71200400001)(186003)(2906002)(6506007)(8676002)(6512007)(478600001)(53546011)(81166006)(81156014)(8936002)(6486002)(5660300002)(316002)(2616005)(66476007)(64756008)(66446008)(66556008)(66946007)(36756003)(86362001)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5366;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PFbNdLMD9rQMbS+YyH8ccKwpt70H7sGd55ZHyp3ppdc0NN28VfQvhD+Ckg6YtLzilnhslE/6LAo4Qm6f97DhjPJOm3W2sanDRzRPjeK/udVn1YgspaKbcL4ytOcX/zsMszIfRwGyoN1JZ8kAe5SMxAGFt2Xicr/M92eLy9wZk2SRI/+eBLTzR9f7RJ03yB1n/I0WReGrGSv8PEBAUuN/GJanVmaVwnUvJ2cw3rAnuhFOx3I03JeNdCiYk90X8nw0inaC5yJY+Rap1oHJfYQ+w/bdA7kF2fKMybHrQT/M0D6Pz6qJSwH896+cEffGuoQkZPW7XwaBVwhBkibgOXTZ/Ocppgostssv7s+bdAj2ujzXrOdJLM/znPMiGmXk1ssbzq1mAYS3j7nw9kBqBpoeP9kOqDp98R1TjJLfMr15Ec/wZHczRNZZbpLu0TzqvOTH
x-ms-exchange-antispam-messagedata: 7rQTJwE4RHLVFZjrr+f+gLBHehE0yPZyPYYJHCyh8NCMoMcOfzIgvH6jteH1gP4mCqQFX69ns5lpa84fIjgYOdzFzp1acrPAAvST7M//E1AvNkwTY3itR8NDF0dxkER8B2ez3uCDy3dI88tbK/kBD5zPZvxtRa+pnGaUHfXhh7mBAZ2bDLAN/sEPFW7BwvssOjEseIvA2B/4bUlWikAgiQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD6F72D649AE914A8D4704882460470F@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38844162-4a77-4741-cd80-08d7cf625834
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2020 19:42:38.8345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: koLOu5r7PneIBsKjIaGMvErUY9twHSTF5srTWhE4+jyn7rs4B+7zaLOfQwiTcdNEbTVt8Xho1qBu7/xoQQAsiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5366
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SSBtaXN0YWtlbmx5IGZvcmdvdCB0aGUga3ZtLXVuaXQtdGVzdHMgaW4gdGhlIHBhdGNoIHN1Ympl
Y3QuIFNvcnJ5IGZvciB0aGF0Lg0KDQoNCj4gT24gTWFyIDIwLCAyMDIwLCBhdCAxMDowNSBQTSwg
TmFkYXYgQW1pdCA8bmFtaXRAdm13YXJlLmNvbT4gd3JvdGU6DQo+IA0KPiBSdW5uaW5nIHRoZSB0
ZXN0cyB3aXRoIG1vcmUgdGhhbiA0R0Igb2YgbWVtb3J5IHJlc3VsdHMgaW4gdGhlIGZvbGxvd2lu
Zw0KPiBmYWlsdXJlOg0KPiANCj4gIEZBSUw6IEVQVCB2aW9sYXRpb24gLSBwYWdpbmcgc3RydWN0
dXJlDQo+IA0KPiBJdCBhcHBlYXJzIHRoYXQgdGhlIHRlc3QgbWlzdGFrZW5seSB1c2VkIGdldF9l
cHRfcHRlKCkgdG8gcmV0cmlldmUgdGhlDQo+IGd1ZXN0IFBURSwgYnV0IHRoaXMgZnVuY3Rpb24g
aXMgaW50ZW5kZWQgZm9yIGFjY2Vzc2luZyBFUFQgYW5kIG5vdCB0aGUNCj4gZ3Vlc3QgcGFnZSB0
YWJsZXMuIFVzZSBnZXRfcHRlX2xldmVsKCkgaW5zdGVhZCBvZiBnZXRfZXB0X3B0ZSgpLg0KPiAN
Cj4gVGVzdGVkIG9uIGJhcmUtbWV0YWwgb25seS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE5hZGF2
IEFtaXQgPG5hbWl0QHZtd2FyZS5jb20+DQo+IC0tLQ0KPiB4ODYvdm14X3Rlc3RzLmMgfCAxNyAr
KysrKysrKystLS0tLS0tLQ0KPiAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCA4IGRl
bGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3g4Ni92bXhfdGVzdHMuYyBiL3g4Ni92bXhf
dGVzdHMuYw0KPiBpbmRleCBiZTVjOTUyLi4xZjk3ZmUzIDEwMDY0NA0KPiAtLS0gYS94ODYvdm14
X3Rlc3RzLmMNCj4gKysrIGIveDg2L3ZteF90ZXN0cy5jDQo+IEBAIC0xMzEyLDEyICsxMzEyLDE0
IEBAIHN0YXRpYyBpbnQgZXB0X2V4aXRfaGFuZGxlcl9jb21tb24odW5pb24gZXhpdF9yZWFzb24g
ZXhpdF9yZWFzb24sIGJvb2wgaGF2ZV9hZCkNCj4gCXU2NCBndWVzdF9jcjM7DQo+IAl1MzIgaW5z
bl9sZW47DQo+IAl1MzIgZXhpdF9xdWFsOw0KPiAtCXN0YXRpYyB1bnNpZ25lZCBsb25nIGRhdGFf
cGFnZTFfcHRlLCBkYXRhX3BhZ2UxX3B0ZV9wdGUsIG1lbWFkZHJfcHRlOw0KPiArCXN0YXRpYyB1
bnNpZ25lZCBsb25nIGRhdGFfcGFnZTFfcHRlLCBkYXRhX3BhZ2UxX3B0ZV9wdGUsIG1lbWFkZHJf
cHRlLA0KPiArCQkJICAgICBndWVzdF9wdGVfYWRkcjsNCj4gDQo+IAlndWVzdF9yaXAgPSB2bWNz
X3JlYWQoR1VFU1RfUklQKTsNCj4gCWd1ZXN0X2NyMyA9IHZtY3NfcmVhZChHVUVTVF9DUjMpOw0K
PiAJaW5zbl9sZW4gPSB2bWNzX3JlYWQoRVhJX0lOU1RfTEVOKTsNCj4gCWV4aXRfcXVhbCA9IHZt
Y3NfcmVhZChFWElfUVVBTElGSUNBVElPTik7DQo+ICsJcHRldmFsX3QgKnB0ZXA7DQo+IAlzd2l0
Y2ggKGV4aXRfcmVhc29uLmJhc2ljKSB7DQo+IAljYXNlIFZNWF9WTUNBTEw6DQo+IAkJc3dpdGNo
ICh2bXhfZ2V0X3Rlc3Rfc3RhZ2UoKSkgew0KPiBAQCAtMTM2NCwxMiArMTM2NiwxMSBAQCBzdGF0
aWMgaW50IGVwdF9leGl0X2hhbmRsZXJfY29tbW9uKHVuaW9uIGV4aXRfcmVhc29uIGV4aXRfcmVh
c29uLCBib29sIGhhdmVfYWQpDQo+IAkJCWVwdF9zeW5jKElOVkVQVF9TSU5HTEUsIGVwdHApOw0K
PiAJCQlicmVhazsNCj4gCQljYXNlIDQ6DQo+IC0JCQlURVNUX0FTU0VSVChnZXRfZXB0X3B0ZShw
bWw0LCAodW5zaWduZWQgbG9uZylkYXRhX3BhZ2UxLA0KPiAtCQkJCQkJMiwgJmRhdGFfcGFnZTFf
cHRlKSk7DQo+IC0JCQlkYXRhX3BhZ2UxX3B0ZSAmPSBQQUdFX01BU0s7DQo+IC0JCQlURVNUX0FT
U0VSVChnZXRfZXB0X3B0ZShwbWw0LCBkYXRhX3BhZ2UxX3B0ZSwNCj4gLQkJCQkJCTIsICZkYXRh
X3BhZ2UxX3B0ZV9wdGUpKTsNCj4gLQkJCXNldF9lcHRfcHRlKHBtbDQsIGRhdGFfcGFnZTFfcHRl
LCAyLA0KPiArCQkJcHRlcCA9IGdldF9wdGVfbGV2ZWwoKHBnZF90ICopZ3Vlc3RfY3IzLCBkYXRh
X3BhZ2UxLCAvKmxldmVsPSovMik7DQo+ICsJCQlndWVzdF9wdGVfYWRkciA9IHZpcnRfdG9fcGh5
cyhwdGVwKSAmIFBBR0VfTUFTSzsNCj4gKw0KPiArCQkJVEVTVF9BU1NFUlQoZ2V0X2VwdF9wdGUo
cG1sNCwgZ3Vlc3RfcHRlX2FkZHIsIDIsICZkYXRhX3BhZ2UxX3B0ZV9wdGUpKTsNCj4gKwkJCXNl
dF9lcHRfcHRlKHBtbDQsIGd1ZXN0X3B0ZV9hZGRyLCAyLA0KPiAJCQkJZGF0YV9wYWdlMV9wdGVf
cHRlICYgfkVQVF9QUkVTRU5UKTsNCj4gCQkJZXB0X3N5bmMoSU5WRVBUX1NJTkdMRSwgZXB0cCk7
DQo+IAkJCWJyZWFrOw0KPiBAQCAtMTQzNyw3ICsxNDM4LDcgQEAgc3RhdGljIGludCBlcHRfZXhp
dF9oYW5kbGVyX2NvbW1vbih1bmlvbiBleGl0X3JlYXNvbiBleGl0X3JlYXNvbiwgYm9vbCBoYXZl
X2FkKQ0KPiAJCQkJCSAgKGhhdmVfYWQgPyBFUFRfVkxUX1dSIDogMCkgfA0KPiAJCQkJCSAgRVBU
X1ZMVF9MQUREUl9WTEQpKQ0KPiAJCQkJdm14X2luY190ZXN0X3N0YWdlKCk7DQo+IC0JCQlzZXRf
ZXB0X3B0ZShwbWw0LCBkYXRhX3BhZ2UxX3B0ZSwgMiwNCj4gKwkJCXNldF9lcHRfcHRlKHBtbDQs
IGd1ZXN0X3B0ZV9hZGRyLCAyLA0KPiAJCQkJZGF0YV9wYWdlMV9wdGVfcHRlIHwgKEVQVF9QUkVT
RU5UKSk7DQo+IAkJCWVwdF9zeW5jKElOVkVQVF9TSU5HTEUsIGVwdHApOw0KPiAJCQlicmVhazsN
Cj4g4oCUIA0KPiAyLjE3LjENCg0KDQo=
