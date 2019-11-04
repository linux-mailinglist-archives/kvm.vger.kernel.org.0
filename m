Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5896CEEA75
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 21:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbfKDUu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 15:50:57 -0500
Received: from mail-eopbgr730056.outbound.protection.outlook.com ([40.107.73.56]:40965
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728709AbfKDUu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 15:50:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLAhDeJq8Jm9Z8PaIiHrwlNEdl5v+l69tIZzjxyU/RYk7IYEj0B9XwgTUnQZVdVwg7V+MhmKD8wBkvkq23bsCR7TCsJPg0H6dGejzwRSSZFNjreGxH9gz27cEgf4R/z5CB5AimIJVmEzSPTHxfvTHAxTNAUAxHXPsbgvHhqhkKqAhvJ0eNlQ/0W0IcksP37id5TfJv8iQEGzWf9lEYTzDYllmlQ67tXLOp38sH3FdkaJJpC+0E3E3h4ojsGc2Yo7IlXMWdxTcrVoC15Yw3jhcIr7mr4uL7zwszKUxHkIGLMFShaHk8ZddKvs7rU/Ntg6udT8KINmdAw9FF7wmxkang==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+hIm65fFHkWsdG3pG0gTYIsbsd41pXbC++QaJQTsW2E=;
 b=Aqd1Q15dp9yXCCkTabanD6oKWifJIJzLiwQBMUYG3QAePSjAqbbqV8ozUbOfYgCyppOWfUgIG7mF5dGDhuZFu1+T8WKJitjEwTqGq0jJwLNpWvy6ZAO22DCKvyUlmk0gytxXk99pyJSzF/xt2pqMVWRli64LcQVapVJRhqg38t6z6jGhcyJSpAEaEQp7y8N5DJnFJAcJEPgriFA2JEo/HOBxRhKGG68JbOcVMm1fk6cmYm1FXTDubFYuXbWYjLuXGsSDdCEHXHljKcN14SiiKUmAcF1JKwrZGEi3Hw4IO9QGoQ/EA3oxQ0BQe98k2nG4kpASEdATeFbFgjgBeof4dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+hIm65fFHkWsdG3pG0gTYIsbsd41pXbC++QaJQTsW2E=;
 b=LeNdSKGZa8/37w23wtS4c8deSAetSreZzWc3dl3afupg5M/vTySgIUZnx//yTBIx3umnEGpEqyvwLr0YyuAsfVztpBLuqCR6uFvB4/ugn4xvLu+vy0z5VKdsiqOCDCrq0cKEN5A4DemiiqA07UaQOvKqTDy059kID4A2bL5aFKk=
Received: from DM5PR12MB2471.namprd12.prod.outlook.com (52.132.141.138) by
 DM5PR12MB1387.namprd12.prod.outlook.com (10.168.233.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.31; Mon, 4 Nov 2019 20:50:51 +0000
Received: from DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::c5a3:6a2e:8699:1999]) by DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::c5a3:6a2e:8699:1999%6]) with mapi id 15.20.2408.024; Mon, 4 Nov 2019
 20:50:51 +0000
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
Subject: [PATCH v2] x86/Kconfig: Rename UMIP config parameter
Thread-Topic: [PATCH v2] x86/Kconfig: Rename UMIP config parameter
Thread-Index: AQHVk1GLQf345nN80kenPnepADNDDg==
Date:   Mon, 4 Nov 2019 20:50:51 +0000
Message-ID: <157290058655.2477.5193340480187879024.stgit@naples-babu.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR15CA0011.namprd15.prod.outlook.com
 (2603:10b6:805:16::24) To DM5PR12MB2471.namprd12.prod.outlook.com
 (2603:10b6:4:b5::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 29a8e5a2-2388-4dc8-80fd-08d76168ada3
x-ms-traffictypediagnostic: DM5PR12MB1387:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB138727A0EDE23AEFB7E9D139957F0@DM5PR12MB1387.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(189003)(199004)(305945005)(26005)(54906003)(316002)(66066001)(66476007)(2201001)(6436002)(103116003)(14444005)(71200400001)(5660300002)(3846002)(6116002)(4326008)(256004)(2906002)(7416002)(386003)(6506007)(102836004)(14454004)(8676002)(8936002)(81156014)(81166006)(25786009)(6486002)(7736002)(66446008)(66946007)(64756008)(66556008)(86362001)(6512007)(71190400001)(110136005)(478600001)(2501003)(476003)(186003)(99286004)(52116002)(486006)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1387;H:DM5PR12MB2471.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3qcjTzdD+dE2Ay5b8StNudg/5fshAwQxWF9WPwps4P9Lc0T2Kw8ZOnPKr9KCr/V1MhkNzLTBTo6fVy5MzgcwTSuExaIbllr61PfvdUGBk6AU8gIs2AfstTy+mMUt2r6GibgUkZyliwiPacvSCmAsrWPzYVyC9Vv6mOFIJhc/AMFMeWZ8q+9PTVZz7ROdyZtrQZPrWkoKA1dfkTznxr3nkhjiKASDakEGX8s6eMy/9Npu2fFRcHqqZb8wxWtNdoN+yS409lynG7NGYFKzuKZ38ppTnncF1GvMUBa7rZMIe6/z8PRQM2e87Z7t3dnZ8rOQUeqpIJPjMfmda50OCeUqqWTcNqyiPHct4KfNWXWE82pMxpYs4bb3glmALYDMWoTDdFqz62Dxcc9GoMhHQYkI8uK6r/b6WSKe3LC3JlM1PRUKi3UtjWbxQgB+khT2Sa5R
Content-Type: text/plain; charset="utf-8"
Content-ID: <F516C8705528BB4A97430686265FF341@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a8e5a2-2388-4dc8-80fd-08d76168ada3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2019 20:50:51.6030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: smQOp3TKevWys9tbIIgK5X5kOHHxfd+AM+oXx31rDgKu1XWYTCdilJDagIDlN22p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1387
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QU1EIDJuZCBnZW5lcmF0aW9uIEVQWUMgcHJvY2Vzc29ycyBzdXBwb3J0IHRoZSBVTUlQIChVc2Vy
LU1vZGUNCkluc3RydWN0aW9uIFByZXZlbnRpb24pIGZlYXR1cmUuIFNvLCByZW5hbWUgWDg2X0lO
VEVMX1VNSVAgdG8NCmdlbmVyaWMgWDg2X1VNSVAgYW5kIG1vZGlmeSB0aGUgdGV4dCB0byBjb3Zl
ciBib3RoIEludGVsIGFuZCBBTUQuDQoNClNpZ25lZC1vZmYtYnk6IEJhYnUgTW9nZXIgPGJhYnUu
bW9nZXJAYW1kLmNvbT4NCi0tLQ0KdjI6DQogIExlYXJuZWQgdGhhdCBmb3IgdGhlIGhhcmR3YXJl
IHRoYXQgc3VwcG9ydCBVTUlQLCB3ZSBkb250IG5lZWQgdG8NCiAgZW11bGF0ZS4gUmVtb3ZlZCB0
aGUgZW11bGF0aW9uIHJlbGF0ZWQgY29kZSBhbmQganVzdCBzdWJtaXR0aW5nDQogIHRoZSBjb25m
aWcgY2hhbmdlcy4NCg0KIGFyY2gveDg2L0tjb25maWcgICAgICAgICAgICAgICAgICAgICAgICAg
fCAgICA4ICsrKystLS0tDQogYXJjaC94ODYvaW5jbHVkZS9hc20vZGlzYWJsZWQtZmVhdHVyZXMu
aCB8ICAgIDIgKy0NCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS91bWlwLmggICAgICAgICAgICAgIHwg
ICAgNCArKy0tDQogYXJjaC94ODYva2VybmVsL01ha2VmaWxlICAgICAgICAgICAgICAgICB8ICAg
IDIgKy0NCiA0IGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkN
Cg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L0tjb25maWcgYi9hcmNoL3g4Ni9LY29uZmlnDQppbmRl
eCBkNmUxZmFhMjhjNTguLjgyMWI3Y2ViZmYzMSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L0tjb25m
aWcNCisrKyBiL2FyY2gveDg2L0tjb25maWcNCkBAIC0xODgwLDEzICsxODgwLDEzIEBAIGNvbmZp
ZyBYODZfU01BUA0KIA0KIAkgIElmIHVuc3VyZSwgc2F5IFkuDQogDQotY29uZmlnIFg4Nl9JTlRF
TF9VTUlQDQorY29uZmlnIFg4Nl9VTUlQDQogCWRlZl9ib29sIHkNCi0JZGVwZW5kcyBvbiBDUFVf
U1VQX0lOVEVMDQotCXByb21wdCAiSW50ZWwgVXNlciBNb2RlIEluc3RydWN0aW9uIFByZXZlbnRp
b24iIGlmIEVYUEVSVA0KKwlkZXBlbmRzIG9uIFg4NiAmJiAoQ1BVX1NVUF9JTlRFTCB8fCBDUFVf
U1VQX0FNRCkNCisJcHJvbXB0ICJVc2VyIE1vZGUgSW5zdHJ1Y3Rpb24gUHJldmVudGlvbiIgaWYg
RVhQRVJUDQogCS0tLWhlbHAtLS0NCiAJICBUaGUgVXNlciBNb2RlIEluc3RydWN0aW9uIFByZXZl
bnRpb24gKFVNSVApIGlzIGEgc2VjdXJpdHkNCi0JICBmZWF0dXJlIGluIG5ld2VyIEludGVsIHBy
b2Nlc3NvcnMuIElmIGVuYWJsZWQsIGEgZ2VuZXJhbA0KKwkgIGZlYXR1cmUgaW4gbmV3ZXIgeDg2
IHByb2Nlc3NvcnMuIElmIGVuYWJsZWQsIGEgZ2VuZXJhbA0KIAkgIHByb3RlY3Rpb24gZmF1bHQg
aXMgaXNzdWVkIGlmIHRoZSBTR0RULCBTTERULCBTSURULCBTTVNXDQogCSAgb3IgU1RSIGluc3Ry
dWN0aW9ucyBhcmUgZXhlY3V0ZWQgaW4gdXNlciBtb2RlLiBUaGVzZSBpbnN0cnVjdGlvbnMNCiAJ
ICB1bm5lY2Vzc2FyaWx5IGV4cG9zZSBpbmZvcm1hdGlvbiBhYm91dCB0aGUgaGFyZHdhcmUgc3Rh
dGUuDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vZGlzYWJsZWQtZmVhdHVyZXMu
aCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2Rpc2FibGVkLWZlYXR1cmVzLmgNCmluZGV4IGE1ZWE4
NDFjYzZkMi4uOGUxZDBiYjQ2MzYxIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20v
ZGlzYWJsZWQtZmVhdHVyZXMuaA0KKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vZGlzYWJsZWQt
ZmVhdHVyZXMuaA0KQEAgLTIyLDcgKzIyLDcgQEANCiAjIGRlZmluZSBESVNBQkxFX1NNQVAJKDE8
PChYODZfRkVBVFVSRV9TTUFQICYgMzEpKQ0KICNlbmRpZg0KIA0KLSNpZmRlZiBDT05GSUdfWDg2
X0lOVEVMX1VNSVANCisjaWZkZWYgQ09ORklHX1g4Nl9VTUlQDQogIyBkZWZpbmUgRElTQUJMRV9V
TUlQCTANCiAjZWxzZQ0KICMgZGVmaW5lIERJU0FCTEVfVU1JUAkoMTw8KFg4Nl9GRUFUVVJFX1VN
SVAgJiAzMSkpDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdW1pcC5oIGIvYXJj
aC94ODYvaW5jbHVkZS9hc20vdW1pcC5oDQppbmRleCBkYjQzZjJhMGQ5MmMuLmFlZWQ5OGMzYzll
MSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3VtaXAuaA0KKysrIGIvYXJjaC94
ODYvaW5jbHVkZS9hc20vdW1pcC5oDQpAQCAtNCw5ICs0LDkgQEANCiAjaW5jbHVkZSA8bGludXgv
dHlwZXMuaD4NCiAjaW5jbHVkZSA8YXNtL3B0cmFjZS5oPg0KIA0KLSNpZmRlZiBDT05GSUdfWDg2
X0lOVEVMX1VNSVANCisjaWZkZWYgQ09ORklHX1g4Nl9VTUlQDQogYm9vbCBmaXh1cF91bWlwX2V4
Y2VwdGlvbihzdHJ1Y3QgcHRfcmVncyAqcmVncyk7DQogI2Vsc2UNCiBzdGF0aWMgaW5saW5lIGJv
b2wgZml4dXBfdW1pcF9leGNlcHRpb24oc3RydWN0IHB0X3JlZ3MgKnJlZ3MpIHsgcmV0dXJuIGZh
bHNlOyB9DQotI2VuZGlmICAvKiBDT05GSUdfWDg2X0lOVEVMX1VNSVAgKi8NCisjZW5kaWYgIC8q
IENPTkZJR19YODZfVU1JUCAqLw0KICNlbmRpZiAgLyogX0FTTV9YODZfVU1JUF9IICovDQpkaWZm
IC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL01ha2VmaWxlIGIvYXJjaC94ODYva2VybmVsL01ha2Vm
aWxlDQppbmRleCAzNTc4YWQyNDhiYzkuLjUyY2UxZTIzOTUyNSAxMDA2NDQNCi0tLSBhL2FyY2gv
eDg2L2tlcm5lbC9NYWtlZmlsZQ0KKysrIGIvYXJjaC94ODYva2VybmVsL01ha2VmaWxlDQpAQCAt
MTM0LDcgKzEzNCw3IEBAIG9iai0kKENPTkZJR19FRkkpCQkJKz0gc3lzZmJfZWZpLm8NCiBvYmot
JChDT05GSUdfUEVSRl9FVkVOVFMpCQkrPSBwZXJmX3JlZ3Mubw0KIG9iai0kKENPTkZJR19UUkFD
SU5HKQkJCSs9IHRyYWNlcG9pbnQubw0KIG9iai0kKENPTkZJR19TQ0hFRF9NQ19QUklPKQkJKz0g
aXRtdC5vDQotb2JqLSQoQ09ORklHX1g4Nl9JTlRFTF9VTUlQKQkJKz0gdW1pcC5vDQorb2JqLSQo
Q09ORklHX1g4Nl9VTUlQKQkJCSs9IHVtaXAubw0KIA0KIG9iai0kKENPTkZJR19VTldJTkRFUl9P
UkMpCQkrPSB1bndpbmRfb3JjLm8NCiBvYmotJChDT05GSUdfVU5XSU5ERVJfRlJBTUVfUE9JTlRF
UikJKz0gdW53aW5kX2ZyYW1lLm8NCg0K
