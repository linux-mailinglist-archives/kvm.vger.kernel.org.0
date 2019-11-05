Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D75F0844
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 22:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729985AbfKEVZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 16:25:37 -0500
Received: from mail-eopbgr680076.outbound.protection.outlook.com ([40.107.68.76]:15246
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729976AbfKEVZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 16:25:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDOLt9GGp4T0AU9m9ux0B4sIyMha04S7zuHk50o8vZL9/N6NwAGtgN+lfBIv5Exp+xhbnP5QeY/MlkOgvpS6VqlOqrEqvxNUO1RNNzkerUJEPLoltnXo+1UQ9vz1o+//c9U0MQ4hvmTuRPVM58wONz5OPW3n+Tn8gWCiPn4Rx52GdNXpM27y218zAzgp56HiPTNO5D87JS0ds5E18oeXDPPNx0PgmshMlNEWzTCimJPDLZizi1yBTTcslBXUoFv+HdSXx0yjfEy8pNqonsK4mvl75rUsXBWBk8l1Q9c6TlqPP9/ibxA6odDISpg8VYyiRdztEA6+BN4CyttC/8Yz/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UHaVTCAPAa2PXuzAYcJxBwSPmQecCgZXVdVUs4LVvF0=;
 b=kcnCd1ajDKo9gVHRE/Sy90anVKf6fZifKrvgKWPgoX4WIZWk0BK+8FUsoRr6BIYsjDOaBL3SWOLkn0WIwsnYiYywM8wVtzmHpiRXYn7aEXvmRoQ9vdIWxi3HR0RfmTu6MeC8OF8wbFvxCpNjtcFgYVbasFcfv52Nc67lyVdURXZ/faX7PIpVFg4ei1u77rfXecLS+ounty4vFR5Iu/kGEQQfT5OVfl1JlWgKef/23NAIKYxu93mfksxn3iXp9wpU34/AKKTbCPkfNiXY5HgEe5whPmIqiSK6y4/zWKssqiRvj6a/9MaAB6CamMdfyyB4aoV8hagPmMrzseMMKA4taw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UHaVTCAPAa2PXuzAYcJxBwSPmQecCgZXVdVUs4LVvF0=;
 b=qsHpgIcG6lMqZSQ4C3gfoHyORO1w0UNB7y96WH3dg2i84qemj4kuxuFUoG4jS4sz1mmcg04V7cfuIlIUJFC7YYCT0G7vaFTzRCh4KAqZdigymynININPZq7e9I2XbLKJZj2Lri+vgQJXRa7ppaNkpyn7IaW53mi5Z0RgHMhzTXE=
Received: from DM5PR12MB2471.namprd12.prod.outlook.com (52.132.141.138) by
 DM5PR12MB1195.namprd12.prod.outlook.com (10.168.240.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 21:25:32 +0000
Received: from DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::c5a3:6a2e:8699:1999]) by DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::c5a3:6a2e:8699:1999%6]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 21:25:32 +0000
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "ricardo.neri-calderon@linux.intel.com" 
        <ricardo.neri-calderon@linux.intel.com>,
        "bshanks@codeweavers.com" <bshanks@codeweavers.com>
Subject: [PATCH v3 1/2] x86/Kconfig: Rename UMIP config parameter
Thread-Topic: [PATCH v3 1/2] x86/Kconfig: Rename UMIP config parameter
Thread-Index: AQHVlB+O3ASEuWoCTkuU8z7yyrBiRA==
Date:   Tue, 5 Nov 2019 21:25:32 +0000
Message-ID: <157298912544.17462.2018334793891409521.stgit@naples-babu.amd.com>
References: <157298900783.17462.2778215498449243912.stgit@naples-babu.amd.com>
In-Reply-To: <157298900783.17462.2778215498449243912.stgit@naples-babu.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR04CA0059.namprd04.prod.outlook.com
 (2603:10b6:805:2a::36) To DM5PR12MB2471.namprd12.prod.outlook.com
 (2603:10b6:4:b5::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f1b24793-9b72-4653-0924-08d76236b06a
x-ms-traffictypediagnostic: DM5PR12MB1195:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB1195DD36483FF76316E65DE1957E0@DM5PR12MB1195.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(199004)(189003)(2201001)(54906003)(110136005)(8676002)(7416002)(103116003)(305945005)(81156014)(81166006)(66946007)(478600001)(25786009)(66556008)(64756008)(99286004)(66476007)(7736002)(316002)(26005)(2501003)(3846002)(102836004)(52116002)(6116002)(6436002)(6506007)(386003)(86362001)(66446008)(8936002)(2906002)(76176011)(14454004)(71200400001)(71190400001)(446003)(256004)(6512007)(476003)(486006)(186003)(4326008)(11346002)(14444005)(5660300002)(6486002)(66066001)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1195;H:DM5PR12MB2471.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ClSbpkyoYOR8wv0hOslz+teUZvAaJ0bhbL1mAd/teMgxh4jPhn+muqf7IvBt/MB8AVjhZx/7rzk3wNBVTnvJcx8bnXzUSeoHRYB8kEMsMMWKEaFlLFv1ucYDavJZpBzcBxlzcYF4YrX6kSmAdCFWZo4P7laEebnnx4w5qwpB8rGQEI5zfJfbVRHAfZLxPWCVKDD/FybvamVJpoZMOuWgYnMWJU2W0ztnEy32wlQsm2ioMW0XexLak2Fq2g5L4He4YbQwvtNSntSkB5hUu2Yti+NlZuRecHm5ZSKIdoyRFWufqR5N+F1YQZmkh5lUNQgezlrofL/kOdiV4LwY0c/PHUOeCeOBkScZjlLo/2xaKovHR4FWL4B4+iS64xBRx8h0lLN9FckzjKypD6P4hhVEDtqnLNLuytDIWHlqgKjNC20yhrSrTvSaHLUV6CA2yhCO
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB5CA5287769514C809EE01D42582920@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1b24793-9b72-4653-0924-08d76236b06a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 21:25:32.6178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e0feHaupNd+ZncqL/7giuXPSjEoF7LB9RTQgGcVk3ySvPm9S+mfW/oEfmg125hyN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1195
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QU1EIDJuZCBnZW5lcmF0aW9uIEVQWUMgcHJvY2Vzc29ycyBzdXBwb3J0IHRoZSBVTUlQIChVc2Vy
LU1vZGUNCkluc3RydWN0aW9uIFByZXZlbnRpb24pIGZlYXR1cmUuIFNvLCByZW5hbWUgWDg2X0lO
VEVMX1VNSVAgdG8NCmdlbmVyaWMgWDg2X1VNSVAgYW5kIG1vZGlmeSB0aGUgdGV4dCB0byBjb3Zl
ciBib3RoIEludGVsIGFuZCBBTUQuDQoNClNpZ25lZC1vZmYtYnk6IEJhYnUgTW9nZXIgPGJhYnUu
bW9nZXJAYW1kLmNvbT4NCi0tLQ0KIGFyY2gveDg2L0tjb25maWcgICAgICAgICAgICAgICAgICAg
ICAgICAgfCAgIDEwICsrKysrLS0tLS0NCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9kaXNhYmxlZC1m
ZWF0dXJlcy5oIHwgICAgMiArLQ0KIGFyY2gveDg2L2luY2x1ZGUvYXNtL3VtaXAuaCAgICAgICAg
ICAgICAgfCAgICA0ICsrLS0NCiBhcmNoL3g4Ni9rZXJuZWwvTWFrZWZpbGUgICAgICAgICAgICAg
ICAgIHwgICAgMiArLQ0KIDQgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCA5IGRlbGV0
aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvS2NvbmZpZyBiL2FyY2gveDg2L0tjb25m
aWcNCmluZGV4IGQ2ZTFmYWEyOGM1OC4uYjdmYjI4NWQ3YzBmIDEwMDY0NA0KLS0tIGEvYXJjaC94
ODYvS2NvbmZpZw0KKysrIGIvYXJjaC94ODYvS2NvbmZpZw0KQEAgLTE4ODAsMTMgKzE4ODAsMTMg
QEAgY29uZmlnIFg4Nl9TTUFQDQogDQogCSAgSWYgdW5zdXJlLCBzYXkgWS4NCiANCi1jb25maWcg
WDg2X0lOVEVMX1VNSVANCitjb25maWcgWDg2X1VNSVANCiAJZGVmX2Jvb2wgeQ0KLQlkZXBlbmRz
IG9uIENQVV9TVVBfSU5URUwNCi0JcHJvbXB0ICJJbnRlbCBVc2VyIE1vZGUgSW5zdHJ1Y3Rpb24g
UHJldmVudGlvbiIgaWYgRVhQRVJUDQorCWRlcGVuZHMgb24gQ1BVX1NVUF9JTlRFTCB8fCBDUFVf
U1VQX0FNRA0KKwlwcm9tcHQgIlVzZXIgTW9kZSBJbnN0cnVjdGlvbiBQcmV2ZW50aW9uIiBpZiBF
WFBFUlQNCiAJLS0taGVscC0tLQ0KLQkgIFRoZSBVc2VyIE1vZGUgSW5zdHJ1Y3Rpb24gUHJldmVu
dGlvbiAoVU1JUCkgaXMgYSBzZWN1cml0eQ0KLQkgIGZlYXR1cmUgaW4gbmV3ZXIgSW50ZWwgcHJv
Y2Vzc29ycy4gSWYgZW5hYmxlZCwgYSBnZW5lcmFsDQorCSAgVXNlciBNb2RlIEluc3RydWN0aW9u
IFByZXZlbnRpb24gKFVNSVApIGlzIGEgc2VjdXJpdHkNCisJICBmZWF0dXJlIGluIG5ld2VyIHg4
NiBwcm9jZXNzb3JzLiBJZiBlbmFibGVkLCBhIGdlbmVyYWwNCiAJICBwcm90ZWN0aW9uIGZhdWx0
IGlzIGlzc3VlZCBpZiB0aGUgU0dEVCwgU0xEVCwgU0lEVCwgU01TVw0KIAkgIG9yIFNUUiBpbnN0
cnVjdGlvbnMgYXJlIGV4ZWN1dGVkIGluIHVzZXIgbW9kZS4gVGhlc2UgaW5zdHJ1Y3Rpb25zDQog
CSAgdW5uZWNlc3NhcmlseSBleHBvc2UgaW5mb3JtYXRpb24gYWJvdXQgdGhlIGhhcmR3YXJlIHN0
YXRlLg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2Rpc2FibGVkLWZlYXR1cmVz
LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9kaXNhYmxlZC1mZWF0dXJlcy5oDQppbmRleCBhNWVh
ODQxY2M2ZDIuLjhlMWQwYmI0NjM2MSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNt
L2Rpc2FibGVkLWZlYXR1cmVzLmgNCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2Rpc2FibGVk
LWZlYXR1cmVzLmgNCkBAIC0yMiw3ICsyMiw3IEBADQogIyBkZWZpbmUgRElTQUJMRV9TTUFQCSgx
PDwoWDg2X0ZFQVRVUkVfU01BUCAmIDMxKSkNCiAjZW5kaWYNCiANCi0jaWZkZWYgQ09ORklHX1g4
Nl9JTlRFTF9VTUlQDQorI2lmZGVmIENPTkZJR19YODZfVU1JUA0KICMgZGVmaW5lIERJU0FCTEVf
VU1JUAkwDQogI2Vsc2UNCiAjIGRlZmluZSBESVNBQkxFX1VNSVAJKDE8PChYODZfRkVBVFVSRV9V
TUlQICYgMzEpKQ0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3VtaXAuaCBiL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL3VtaXAuaA0KaW5kZXggZGI0M2YyYTBkOTJjLi5hZWVkOThjM2M5
ZTEgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS91bWlwLmgNCisrKyBiL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL3VtaXAuaA0KQEAgLTQsOSArNCw5IEBADQogI2luY2x1ZGUgPGxpbnV4
L3R5cGVzLmg+DQogI2luY2x1ZGUgPGFzbS9wdHJhY2UuaD4NCiANCi0jaWZkZWYgQ09ORklHX1g4
Nl9JTlRFTF9VTUlQDQorI2lmZGVmIENPTkZJR19YODZfVU1JUA0KIGJvb2wgZml4dXBfdW1pcF9l
eGNlcHRpb24oc3RydWN0IHB0X3JlZ3MgKnJlZ3MpOw0KICNlbHNlDQogc3RhdGljIGlubGluZSBi
b29sIGZpeHVwX3VtaXBfZXhjZXB0aW9uKHN0cnVjdCBwdF9yZWdzICpyZWdzKSB7IHJldHVybiBm
YWxzZTsgfQ0KLSNlbmRpZiAgLyogQ09ORklHX1g4Nl9JTlRFTF9VTUlQICovDQorI2VuZGlmICAv
KiBDT05GSUdfWDg2X1VNSVAgKi8NCiAjZW5kaWYgIC8qIF9BU01fWDg2X1VNSVBfSCAqLw0KZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9NYWtlZmlsZSBiL2FyY2gveDg2L2tlcm5lbC9NYWtl
ZmlsZQ0KaW5kZXggMzU3OGFkMjQ4YmM5Li41MmNlMWUyMzk1MjUgMTAwNjQ0DQotLS0gYS9hcmNo
L3g4Ni9rZXJuZWwvTWFrZWZpbGUNCisrKyBiL2FyY2gveDg2L2tlcm5lbC9NYWtlZmlsZQ0KQEAg
LTEzNCw3ICsxMzQsNyBAQCBvYmotJChDT05GSUdfRUZJKQkJCSs9IHN5c2ZiX2VmaS5vDQogb2Jq
LSQoQ09ORklHX1BFUkZfRVZFTlRTKQkJKz0gcGVyZl9yZWdzLm8NCiBvYmotJChDT05GSUdfVFJB
Q0lORykJCQkrPSB0cmFjZXBvaW50Lm8NCiBvYmotJChDT05GSUdfU0NIRURfTUNfUFJJTykJCSs9
IGl0bXQubw0KLW9iai0kKENPTkZJR19YODZfSU5URUxfVU1JUCkJCSs9IHVtaXAubw0KK29iai0k
KENPTkZJR19YODZfVU1JUCkJCQkrPSB1bWlwLm8NCiANCiBvYmotJChDT05GSUdfVU5XSU5ERVJf
T1JDKQkJKz0gdW53aW5kX29yYy5vDQogb2JqLSQoQ09ORklHX1VOV0lOREVSX0ZSQU1FX1BPSU5U
RVIpCSs9IHVud2luZF9mcmFtZS5vDQoNCg==
