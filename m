Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEB7EC798
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 18:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbfKARdu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 13:33:50 -0400
Received: from mail-eopbgr730084.outbound.protection.outlook.com ([40.107.73.84]:41494
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729146AbfKARdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 13:33:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jShUnzUZ2W1yw8Z25LNDq3qGAufwK8GTT/yEVEW456SjSWGwKNgUjQ2Ti8oGtpKq5JQbVgWBQ0Rd1VlihysX5feIT4AGxqavpu3HFduE5F0Rna1k0RUfcEymv2cYjzYaA0uuyHQ4WhO8lDqeg15trQZUBCHCo+bIYwLh1QhGNKTQhGsHwiwKB2lQ97VHIG1Hndkiq1N6buZnpFbvRIXFMMono+eFoJxIWPf8KdQgFT9UxccqzccGebT+buPjEzl2vsuAtxcAUdtSWxejK8bSaCpvYvoszZ6rhIjFttGUc7IJnQrCGYOclQhfD71hoJHnWuHQdnAfJ+ooq7E+ypUmtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tCmomhi/PfVh9rUgfnfPxKe5a6xYRN7rs1aZWH9Doo=;
 b=h1SWCCMLG4m8r+P6sFiLiVdyfeM7KZJb8rf+ZlZUKd7LsWuSD1ePs87HCHvOAoNLp3d6PAz0i3kxHqGKmi3XPt18sAgWkxslbLoH79LRUBqbS/jNBv7fC7EIaF5jCnj3dIIDq4Dlig4e7MRxCPZyF7G44wrkdHptN09YcIuVJeA070h8b41X/bD7K5SGvdnYrgmLXqFND3iRgdn2ktzMZR/JgZaflPm4MUtIW+z/K8MIrTTsAqOMBsRN4m9apYTMLCKV42LSnVrPyAAPcGg+AjZt9Ndz/K6gN9d31+kUyoBjmjKdyq1lcCyaaiSUogVUM02U8R/YtlNpATDG9C+LQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tCmomhi/PfVh9rUgfnfPxKe5a6xYRN7rs1aZWH9Doo=;
 b=ih5k7aoSULQ4IvKqXg1nUuQLXFFnGQ9fUDua7tA/oLm+L4ZrLMubyaIIUU2Yep2sElOuDVZlvQQfdSrRszTMk+w2ldiOqcXO6DadsPfmUabPkh64cgNxWJZxyYG8xOLCWXZPPURsFIpDs4S4m2RRJ3ZaH9hTvi3dasLlH5WcSiY=
Received: from BL0PR12MB2468.namprd12.prod.outlook.com (52.132.30.157) by
 BL0PR12MB2516.namprd12.prod.outlook.com (52.132.11.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 17:33:45 +0000
Received: from BL0PR12MB2468.namprd12.prod.outlook.com
 ([fe80::748c:1f32:1a4d:acca]) by BL0PR12MB2468.namprd12.prod.outlook.com
 ([fe80::748c:1f32:1a4d:acca%7]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 17:33:45 +0000
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
Subject: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
Thread-Topic: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
Thread-Index: AQHVkNqD+3M/4HqTrkKsDppH5BsZ1g==
Date:   Fri, 1 Nov 2019 17:33:45 +0000
Message-ID: <157262962352.2838.15656190309312238595.stgit@naples-babu.amd.com>
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
In-Reply-To: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0009.namprd05.prod.outlook.com
 (2603:10b6:803:40::22) To BL0PR12MB2468.namprd12.prod.outlook.com
 (2603:10b6:207:44::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1fd3ca34-0d30-40b2-ebfa-08d75ef1a595
x-ms-traffictypediagnostic: BL0PR12MB2516:
x-ms-exchange-purlcount: 2
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR12MB25166FB0BA0BAAB9E02EF96295620@BL0PR12MB2516.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(39860400002)(396003)(346002)(189003)(199004)(7736002)(66066001)(6512007)(66446008)(71190400001)(2906002)(305945005)(2501003)(71200400001)(186003)(6116002)(11346002)(103116003)(3846002)(476003)(446003)(14444005)(256004)(2201001)(86362001)(486006)(5660300002)(7416002)(64756008)(14454004)(6486002)(25786009)(81156014)(8676002)(81166006)(6436002)(478600001)(966005)(110136005)(316002)(76176011)(386003)(6506007)(102836004)(52116002)(6306002)(8936002)(54906003)(26005)(4326008)(66946007)(66556008)(66476007)(99286004)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR12MB2516;H:BL0PR12MB2468.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JJq9BnV2F1sHY/YsN1ca67eXk1f1FnnXA0LgqPGzcMPGCfxitg4QE/hPajNtmG5semgHVatQWkNUJ+tAyHkvFsz329jSYMPM1utMkBB+9mJ/+rDofaC4KyYMdGxmV2jTU4qVAymvS9qFDMVC0e4FXvr0jyF2r0sebfjiSucCZrG8gzQxz0f67n2JQigs4Eo3k8emqcLKboVxbNgtCX2CIhHNy44UJXNSQ0Z1Uk6BK2rNrRP6VKQJB1ImlKxr7TkZ4gnPEihiv8cxHSqNSB/Q+BT63r8fL0PliQmrEIH4iXIIBFur1vNZpfBzlAstTl+bxyyf9tE0xJrG0ZXKeQwOqUT9G4htZ3NVzTV77ZYeMzttzAzWWu7Ibigc3VdcDRQp2dGUfVlKN1JHwTvaw9XVPQ4lTD7d2nFHhHXojCdJaUY9NjSSHtMxBQUSosIsG01TAHWM/pgzGXIKwWjFNt9lqX9dIP6vPz8y6IOeIfg4daA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <16B93B0400287747B4AF348D01BEB568@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fd3ca34-0d30-40b2-ebfa-08d75ef1a595
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 17:33:45.6198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /2FFKJDmW0A66Riy35j+l0qRJZg2HzXrB8+pxQbviKlTfYb200RsF0fdCDVF9qxO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2516
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QU1EIDJuZCBnZW5lcmF0aW9uIEVQWUMgcHJvY2Vzc29ycyBzdXBwb3J0IFVNSVAgKFVzZXItTW9k
ZSBJbnN0cnVjdGlvbg0KUHJldmVudGlvbikgZmVhdHVyZS4gVGhlIFVNSVAgZmVhdHVyZSBwcmV2
ZW50cyB0aGUgZXhlY3V0aW9uIG9mIGNlcnRhaW4NCmluc3RydWN0aW9ucyBpZiB0aGUgQ3VycmVu
dCBQcml2aWxlZ2UgTGV2ZWwgKENQTCkgaXMgZ3JlYXRlciB0aGFuIDAuDQpJZiBhbnkgb2YgdGhl
c2UgaW5zdHJ1Y3Rpb25zIGFyZSBleGVjdXRlZCB3aXRoIENQTCA+IDAgYW5kIFVNSVANCmlzIGVu
YWJsZWQsIHRoZW4ga2VybmVsIHJlcG9ydHMgYSAjR1AgZXhjZXB0aW9uLg0KDQpUaGUgaWRlYSBp
cyB0YWtlbiBmcm9tIGFydGljbGVzOg0KaHR0cHM6Ly9sd24ubmV0L0FydGljbGVzLzczODIwOS8N
Cmh0dHBzOi8vbHduLm5ldC9BcnRpY2xlcy82OTQzODUvDQoNCkVuYWJsZSB0aGUgZmVhdHVyZSBp
ZiBzdXBwb3J0ZWQgb24gYmFyZSBtZXRhbCBhbmQgZW11bGF0ZSBpbnN0cnVjdGlvbnMNCnRvIHJl
dHVybiBkdW1teSB2YWx1ZXMgZm9yIGNlcnRhaW4gY2FzZXMuDQoNClNpZ25lZC1vZmYtYnk6IEJh
YnUgTW9nZXIgPGJhYnUubW9nZXJAYW1kLmNvbT4NCi0tLQ0KIGFyY2gveDg2L2t2bS9zdm0uYyB8
ICAgMjEgKysrKysrKysrKysrKysrKy0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDE2IGluc2VydGlv
bnMoKyksIDUgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vc3ZtLmMg
Yi9hcmNoL3g4Ni9rdm0vc3ZtLmMNCmluZGV4IDQxNTNjYThjZGRiNy4uNzlhYmJkZWNhMTQ4IDEw
MDY0NA0KLS0tIGEvYXJjaC94ODYva3ZtL3N2bS5jDQorKysgYi9hcmNoL3g4Ni9rdm0vc3ZtLmMN
CkBAIC0yNTMzLDYgKzI1MzMsMTEgQEAgc3RhdGljIHZvaWQgc3ZtX2RlY2FjaGVfY3I0X2d1ZXN0
X2JpdHMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KIHsNCiB9DQogDQorc3RhdGljIGJvb2wgc3Zt
X3VtaXBfZW11bGF0ZWQodm9pZCkNCit7DQorCXJldHVybiBib290X2NwdV9oYXMoWDg2X0ZFQVRV
UkVfVU1JUCk7DQorfQ0KKw0KIHN0YXRpYyB2b2lkIHVwZGF0ZV9jcjBfaW50ZXJjZXB0KHN0cnVj
dCB2Y3B1X3N2bSAqc3ZtKQ0KIHsNCiAJdWxvbmcgZ2NyMCA9IHN2bS0+dmNwdS5hcmNoLmNyMDsN
CkBAIC00NDM4LDYgKzQ0NDMsMTMgQEAgc3RhdGljIGludCBpbnRlcnJ1cHRfd2luZG93X2ludGVy
Y2VwdGlvbihzdHJ1Y3QgdmNwdV9zdm0gKnN2bSkNCiAJcmV0dXJuIDE7DQogfQ0KIA0KK3N0YXRp
YyBpbnQgdW1pcF9pbnRlcmNlcHRpb24oc3RydWN0IHZjcHVfc3ZtICpzdm0pDQorew0KKwlzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUgPSAmc3ZtLT52Y3B1Ow0KKw0KKwlyZXR1cm4ga3ZtX2VtdWxhdGVf
aW5zdHJ1Y3Rpb24odmNwdSwgMCk7DQorfQ0KKw0KIHN0YXRpYyBpbnQgcGF1c2VfaW50ZXJjZXB0
aW9uKHN0cnVjdCB2Y3B1X3N2bSAqc3ZtKQ0KIHsNCiAJc3RydWN0IGt2bV92Y3B1ICp2Y3B1ID0g
JnN2bS0+dmNwdTsNCkBAIC00Nzc1LDYgKzQ3ODcsMTAgQEAgc3RhdGljIGludCAoKmNvbnN0IHN2
bV9leGl0X2hhbmRsZXJzW10pKHN0cnVjdCB2Y3B1X3N2bSAqc3ZtKSA9IHsNCiAJW1NWTV9FWElU
X1NNSV0JCQkJPSBub3Bfb25faW50ZXJjZXB0aW9uLA0KIAlbU1ZNX0VYSVRfSU5JVF0JCQkJPSBu
b3Bfb25faW50ZXJjZXB0aW9uLA0KIAlbU1ZNX0VYSVRfVklOVFJdCQkJPSBpbnRlcnJ1cHRfd2lu
ZG93X2ludGVyY2VwdGlvbiwNCisJW1NWTV9FWElUX0lEVFJfUkVBRF0JCQk9IHVtaXBfaW50ZXJj
ZXB0aW9uLA0KKwlbU1ZNX0VYSVRfR0RUUl9SRUFEXQkJCT0gdW1pcF9pbnRlcmNlcHRpb24sDQor
CVtTVk1fRVhJVF9MRFRSX1JFQURdCQkJPSB1bWlwX2ludGVyY2VwdGlvbiwNCisJW1NWTV9FWElU
X1RSX1JFQURdCQkJPSB1bWlwX2ludGVyY2VwdGlvbiwNCiAJW1NWTV9FWElUX1JEUE1DXQkJCT0g
cmRwbWNfaW50ZXJjZXB0aW9uLA0KIAlbU1ZNX0VYSVRfQ1BVSURdCQkJPSBjcHVpZF9pbnRlcmNl
cHRpb24sDQogCVtTVk1fRVhJVF9JUkVUXSAgICAgICAgICAgICAgICAgICAgICAgICA9IGlyZXRf
aW50ZXJjZXB0aW9uLA0KQEAgLTU5NzYsMTEgKzU5OTIsNiBAQCBzdGF0aWMgYm9vbCBzdm1feHNh
dmVzX3N1cHBvcnRlZCh2b2lkKQ0KIAlyZXR1cm4gYm9vdF9jcHVfaGFzKFg4Nl9GRUFUVVJFX1hT
QVZFUyk7DQogfQ0KIA0KLXN0YXRpYyBib29sIHN2bV91bWlwX2VtdWxhdGVkKHZvaWQpDQotew0K
LQlyZXR1cm4gZmFsc2U7DQotfQ0KLQ0KIHN0YXRpYyBib29sIHN2bV9wdF9zdXBwb3J0ZWQodm9p
ZCkNCiB7DQogCXJldHVybiBmYWxzZTsNCg0K
