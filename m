Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E159EC79D
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 18:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbfKAReG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 13:34:06 -0400
Received: from mail-eopbgr820042.outbound.protection.outlook.com ([40.107.82.42]:34496
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729138AbfKAReF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 13:34:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N14tV5hKaVRPsDzR6dtkZ+a3ghr3542h1dxWpewTPPSOxHbGlSiyEW+iQLi7yn/IpejZJLgu1CWeqUYx3WEmyDkPDRrJK0GyD+LydpXUy2F8b0lprq6gSRkDkTbo2Aq/TOSu2EqHxhFG0cyT0dpF7JnYDTlYiyMwI4HsAChldwSxDyHwIXsZ25FC/tZhJdtFuOS6vETDStLEE0ewVlxd3NGLZ+h+v40BW2uh3bb00qrK0jmaUkekoJUiHzWadsVcW1dXO7ggF5McGWCcQIBZwK/Nr2Q8HIfarnl4M+HOIcO9mOq4g+OKjO+mXgY6ifNfSiVfXQxqN5PL3eeTgcnk5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukvZmZHoEw0wxITAiKHm0gtuQ6hWeOC+/X77rDtK+xM=;
 b=Z0/8+l/TcAqpzedTLXaFnuOpQI1wsB+u4lPzjm66sai30Ae9QBi0vT1xW+Gt0dDJpOhGnpx/aK+s7B+wLvtGSEYVpVlg1m1kPxjV2GqEBjCU48YV23q5W+N9rIbsyNXS/YX7AS3J5R9bws6cmbzFUNNBSlEixnLsPlingzlKSu6JKm23huwuW55EE09haUt3ECuVhZy0RfI3IuoZQdhLCpHtmkK8glhb4Dj8KvRDBdFwMdZGfvMmoO5AXP5njzd3v1PBb5CZzHFkvWKV7D7g3HGgJ4KJpukUHz5371w+hmvNoX9IBKY9uI4zKMejYxno4sfoPi03L/95euSK40s/2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukvZmZHoEw0wxITAiKHm0gtuQ6hWeOC+/X77rDtK+xM=;
 b=3p9p1xUy9qHyjoFVNMU6tufOUHMdWGfEQxsvH2mY7/kjHvYwehVVk3NhAuGrCOcFuYHAF1Sax2/XX8zK32yKHw9DZcy63hCA5WyFDUI+jc1SYLcjyN05rdrLKQt7oZJNTyDfq56ipM302tardWOw1AkWBYxfbyxGzgt/pXJc8ts=
Received: from BL0PR12MB2468.namprd12.prod.outlook.com (52.132.30.157) by
 BL0PR12MB2451.namprd12.prod.outlook.com (52.132.11.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 17:34:01 +0000
Received: from BL0PR12MB2468.namprd12.prod.outlook.com
 ([fe80::748c:1f32:1a4d:acca]) by BL0PR12MB2468.namprd12.prod.outlook.com
 ([fe80::748c:1f32:1a4d:acca%7]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 17:34:00 +0000
From:   "Moger, Babu" <Babu.Moger@amd.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Moger, Babu" <Babu.Moger@amd.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH 4/4] x86/Kconfig: Rename UMIP config parameter
Thread-Topic: [PATCH 4/4] x86/Kconfig: Rename UMIP config parameter
Thread-Index: AQHVkNqMYpA3/AJr/06gaFyuP7Wa9g==
Date:   Fri, 1 Nov 2019 17:34:00 +0000
Message-ID: <157262963852.2838.14488338442051597577.stgit@naples-babu.amd.com>
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
In-Reply-To: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0002.namprd05.prod.outlook.com
 (2603:10b6:803:40::15) To BL0PR12MB2468.namprd12.prod.outlook.com
 (2603:10b6:207:44::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8dab568a-25a6-4fe0-ee76-08d75ef1aea3
x-ms-traffictypediagnostic: BL0PR12MB2451:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR12MB24510010A98A84659156EBC695620@BL0PR12MB2451.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(189003)(199004)(8936002)(4326008)(54906003)(186003)(478600001)(64756008)(11346002)(66066001)(14454004)(7416002)(476003)(86362001)(316002)(486006)(71190400001)(99286004)(256004)(2906002)(14444005)(76176011)(81156014)(71200400001)(110136005)(8676002)(66556008)(66446008)(52116002)(102836004)(3846002)(386003)(2501003)(81166006)(5660300002)(6506007)(66476007)(66946007)(6436002)(6512007)(6486002)(6116002)(26005)(446003)(103116003)(2201001)(305945005)(25786009)(7736002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR12MB2451;H:BL0PR12MB2468.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dkNn2meK8hqMQ4HzHK+ivvauecgozFJE/Hznr6Dbj/Q0hdTXz9rD86mzV2fRnDiRfl+U5y7/cjHa8G4+gCoG54fyw2RJP4PN/3dwLdVUtanCmuTQK4NjJuTRPj6e+H9CS1of1nK9sp+r7xIMdJcFm+fRPc0JrhUPRrP7lJIYHSK0ksDlGJQZgnPGKOoeL7fOYJOTKOOkYU5GVCaUQia8GdWJuPmSICOu+RLhd9eejIZ3Wz527kqxnK38U17G/PF0xDNHhJJ3Sv9eLrm8IdZk2tfjnS81C42ijWDUqYLC+7/CLQUej9D5ODPAyFTqW7x5TT3adoRKxkaaaem5qZeGSeHgbnP7r0neaB67kj5daR2Dprx9iUFo69YTDG/Lh8qmkqOlBnpK/mMCLbADa5rkR1NkBIRWwN+9CyZKHR5H1964SyqmEXNqN06DuaOi71VB
Content-Type: text/plain; charset="utf-8"
Content-ID: <682AA788FAC95F4EBD8959531CF1B4AE@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dab568a-25a6-4fe0-ee76-08d75ef1aea3
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 17:34:00.8051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I354mym5Nu81hx9+jy50o0B4eKQrj9Yg2JNaq74tGz7UEmMqTOvE8mQE/xzxAO8m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2451
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QU1EIDJuZCBnZW5lcmF0aW9uIEVQWUMgcHJvY2Vzc29ycyBzdXBwb3J0IHRoZSBVTUlQIChVc2Vy
LU1vZGUNCkluc3RydWN0aW9uIFByZXZlbnRpb24pIGZlYXR1cmUuIFNvLCByZW5hbWUgWDg2X0lO
VEVMX1VNSVAgdG8NCmdlbmVyaWMgWDg2X1VNSVAgYW5kIG1vZGlmeSB0aGUgdGV4dCB0byBjb3Zl
ciBib3RoIEludGVsIGFuZCBBTUQuDQoNClNpZ25lZC1vZmYtYnk6IEJhYnUgTW9nZXIgPGJhYnUu
bW9nZXJAYW1kLmNvbT4NCi0tLQ0KIGFyY2gveDg2L0tjb25maWcgICAgICAgICAgICAgICAgICAg
ICAgICAgfCAgICA4ICsrKystLS0tDQogYXJjaC94ODYvaW5jbHVkZS9hc20vZGlzYWJsZWQtZmVh
dHVyZXMuaCB8ICAgIDIgKy0NCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS91bWlwLmggICAgICAgICAg
ICAgIHwgICAgNCArKy0tDQogYXJjaC94ODYva2VybmVsL01ha2VmaWxlICAgICAgICAgICAgICAg
ICB8ICAgIDIgKy0NCiA0IGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlv
bnMoLSkNCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L0tjb25maWcgYi9hcmNoL3g4Ni9LY29uZmln
DQppbmRleCBkNmUxZmFhMjhjNTguLjgyMWI3Y2ViZmYzMSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2
L0tjb25maWcNCisrKyBiL2FyY2gveDg2L0tjb25maWcNCkBAIC0xODgwLDEzICsxODgwLDEzIEBA
IGNvbmZpZyBYODZfU01BUA0KIA0KIAkgIElmIHVuc3VyZSwgc2F5IFkuDQogDQotY29uZmlnIFg4
Nl9JTlRFTF9VTUlQDQorY29uZmlnIFg4Nl9VTUlQDQogCWRlZl9ib29sIHkNCi0JZGVwZW5kcyBv
biBDUFVfU1VQX0lOVEVMDQotCXByb21wdCAiSW50ZWwgVXNlciBNb2RlIEluc3RydWN0aW9uIFBy
ZXZlbnRpb24iIGlmIEVYUEVSVA0KKwlkZXBlbmRzIG9uIFg4NiAmJiAoQ1BVX1NVUF9JTlRFTCB8
fCBDUFVfU1VQX0FNRCkNCisJcHJvbXB0ICJVc2VyIE1vZGUgSW5zdHJ1Y3Rpb24gUHJldmVudGlv
biIgaWYgRVhQRVJUDQogCS0tLWhlbHAtLS0NCiAJICBUaGUgVXNlciBNb2RlIEluc3RydWN0aW9u
IFByZXZlbnRpb24gKFVNSVApIGlzIGEgc2VjdXJpdHkNCi0JICBmZWF0dXJlIGluIG5ld2VyIElu
dGVsIHByb2Nlc3NvcnMuIElmIGVuYWJsZWQsIGEgZ2VuZXJhbA0KKwkgIGZlYXR1cmUgaW4gbmV3
ZXIgeDg2IHByb2Nlc3NvcnMuIElmIGVuYWJsZWQsIGEgZ2VuZXJhbA0KIAkgIHByb3RlY3Rpb24g
ZmF1bHQgaXMgaXNzdWVkIGlmIHRoZSBTR0RULCBTTERULCBTSURULCBTTVNXDQogCSAgb3IgU1RS
IGluc3RydWN0aW9ucyBhcmUgZXhlY3V0ZWQgaW4gdXNlciBtb2RlLiBUaGVzZSBpbnN0cnVjdGlv
bnMNCiAJICB1bm5lY2Vzc2FyaWx5IGV4cG9zZSBpbmZvcm1hdGlvbiBhYm91dCB0aGUgaGFyZHdh
cmUgc3RhdGUuDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vZGlzYWJsZWQtZmVh
dHVyZXMuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2Rpc2FibGVkLWZlYXR1cmVzLmgNCmluZGV4
IGE1ZWE4NDFjYzZkMi4uOGUxZDBiYjQ2MzYxIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYvaW5jbHVk
ZS9hc20vZGlzYWJsZWQtZmVhdHVyZXMuaA0KKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vZGlz
YWJsZWQtZmVhdHVyZXMuaA0KQEAgLTIyLDcgKzIyLDcgQEANCiAjIGRlZmluZSBESVNBQkxFX1NN
QVAJKDE8PChYODZfRkVBVFVSRV9TTUFQICYgMzEpKQ0KICNlbmRpZg0KIA0KLSNpZmRlZiBDT05G
SUdfWDg2X0lOVEVMX1VNSVANCisjaWZkZWYgQ09ORklHX1g4Nl9VTUlQDQogIyBkZWZpbmUgRElT
QUJMRV9VTUlQCTANCiAjZWxzZQ0KICMgZGVmaW5lIERJU0FCTEVfVU1JUAkoMTw8KFg4Nl9GRUFU
VVJFX1VNSVAgJiAzMSkpDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdW1pcC5o
IGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdW1pcC5oDQppbmRleCBkYjQzZjJhMGQ5MmMuLmFlZWQ5
OGMzYzllMSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3VtaXAuaA0KKysrIGIv
YXJjaC94ODYvaW5jbHVkZS9hc20vdW1pcC5oDQpAQCAtNCw5ICs0LDkgQEANCiAjaW5jbHVkZSA8
bGludXgvdHlwZXMuaD4NCiAjaW5jbHVkZSA8YXNtL3B0cmFjZS5oPg0KIA0KLSNpZmRlZiBDT05G
SUdfWDg2X0lOVEVMX1VNSVANCisjaWZkZWYgQ09ORklHX1g4Nl9VTUlQDQogYm9vbCBmaXh1cF91
bWlwX2V4Y2VwdGlvbihzdHJ1Y3QgcHRfcmVncyAqcmVncyk7DQogI2Vsc2UNCiBzdGF0aWMgaW5s
aW5lIGJvb2wgZml4dXBfdW1pcF9leGNlcHRpb24oc3RydWN0IHB0X3JlZ3MgKnJlZ3MpIHsgcmV0
dXJuIGZhbHNlOyB9DQotI2VuZGlmICAvKiBDT05GSUdfWDg2X0lOVEVMX1VNSVAgKi8NCisjZW5k
aWYgIC8qIENPTkZJR19YODZfVU1JUCAqLw0KICNlbmRpZiAgLyogX0FTTV9YODZfVU1JUF9IICov
DQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL01ha2VmaWxlIGIvYXJjaC94ODYva2VybmVs
L01ha2VmaWxlDQppbmRleCAzNTc4YWQyNDhiYzkuLjUyY2UxZTIzOTUyNSAxMDA2NDQNCi0tLSBh
L2FyY2gveDg2L2tlcm5lbC9NYWtlZmlsZQ0KKysrIGIvYXJjaC94ODYva2VybmVsL01ha2VmaWxl
DQpAQCAtMTM0LDcgKzEzNCw3IEBAIG9iai0kKENPTkZJR19FRkkpCQkJKz0gc3lzZmJfZWZpLm8N
CiBvYmotJChDT05GSUdfUEVSRl9FVkVOVFMpCQkrPSBwZXJmX3JlZ3Mubw0KIG9iai0kKENPTkZJ
R19UUkFDSU5HKQkJCSs9IHRyYWNlcG9pbnQubw0KIG9iai0kKENPTkZJR19TQ0hFRF9NQ19QUklP
KQkJKz0gaXRtdC5vDQotb2JqLSQoQ09ORklHX1g4Nl9JTlRFTF9VTUlQKQkJKz0gdW1pcC5vDQor
b2JqLSQoQ09ORklHX1g4Nl9VTUlQKQkJCSs9IHVtaXAubw0KIA0KIG9iai0kKENPTkZJR19VTldJ
TkRFUl9PUkMpCQkrPSB1bndpbmRfb3JjLm8NCiBvYmotJChDT05GSUdfVU5XSU5ERVJfRlJBTUVf
UE9JTlRFUikJKz0gdW53aW5kX2ZyYW1lLm8NCg0K
