Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB27FF0847
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 22:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbfKEV0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 16:26:24 -0500
Received: from mail-eopbgr680062.outbound.protection.outlook.com ([40.107.68.62]:50242
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730043AbfKEV0X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 16:26:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I9VPUSTXqT5SSZAdrG4Xv6H7wq5wwCgWhgQX+V7jUg2y9WAKMBu7ZW6cnnWi4+TXYoYaHBTeJ61OT2KAuMsbGAPtOiiHisxwY1gAct4KIDK5HNDllkw33cJAfTJH8reVTMzQPt3X5sMzAJYcUWtw8i/0EZPUG/MHNWcQ/Ras3bottNSogRCrChf8KWTB+sxBSvxcmoiqki44guIId8gLVnvZw6n5lYcnYQ6GXuHMoQKPpKgl/ZFJ0dJ6PFkqkKM2LO2Lic3aADVzZQRT8i7YO26VgvZaIOOl0F1V4mUwzUMnuE6xOloom6kaFdeugUT/FrKPNt8u6wmJ5JiKw9ZYfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCF7XV2nMLJby4hgGhIpf8CSZOgeFjSmWD8Y3Du8mQo=;
 b=k7SJxh+CcetEEnerA8fkCTJ08d9ti0LCxRqbbaSD1CzQ40K+a1E6ljGdLplc18mJTC6k1WbMqAC+DcLzPQY+vzx9pxIl4z9cf+HaeKb6Vu0aRj+1+Ky4S/RjX70p7b4C0pQbJNhVjvAuWlDuA98SwqVH3Eg7fnJjWPMQrTLK+SWXN8zBwGxt2nLrOVtE/WFzqXGr0SqHmhd9U0Y6NGwVfAipW8oOb3D8MauExn1g3MeOLl16cjUL0PWdQdUZ6Op9Pjt8BSEaToM6EoB6afZin+U6Bo1Utkit9R7xm7qcXKbbRUhsoh53ip5wG9u05y95yzarAyaUaAzYU4DmaNF3zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCF7XV2nMLJby4hgGhIpf8CSZOgeFjSmWD8Y3Du8mQo=;
 b=PYifDBxBTnaYf8UYOSq4a+I6xwlOsgBjhgkSMYx87Iam9jjAnHNOOLv4LVOhbPykR4ToeoVTCNCeObjOwQpLW6SR72nZbk79cCmY3DY7scXtpIBuZv6COCQbc0ghPe5Rqm07WB52e4vE7YacUWIUr4m2druk/+3rXPmnWVYXdJk=
Received: from DM5PR12MB2471.namprd12.prod.outlook.com (52.132.141.138) by
 DM5PR12MB1195.namprd12.prod.outlook.com (10.168.240.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 21:25:40 +0000
Received: from DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::c5a3:6a2e:8699:1999]) by DM5PR12MB2471.namprd12.prod.outlook.com
 ([fe80::c5a3:6a2e:8699:1999%6]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 21:25:40 +0000
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
Subject: [PATCH v3 2/2] x86/umip: Update the comments to cover generic x86
 processors
Thread-Topic: [PATCH v3 2/2] x86/umip: Update the comments to cover generic
 x86 processors
Thread-Index: AQHVlB+SCjh4NAufykaxQBgEbCDhKg==
Date:   Tue, 5 Nov 2019 21:25:40 +0000
Message-ID: <157298913784.17462.12654728938970637305.stgit@naples-babu.amd.com>
References: <157298900783.17462.2778215498449243912.stgit@naples-babu.amd.com>
In-Reply-To: <157298900783.17462.2778215498449243912.stgit@naples-babu.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0401CA0011.namprd04.prod.outlook.com
 (2603:10b6:803:21::21) To DM5PR12MB2471.namprd12.prod.outlook.com
 (2603:10b6:4:b5::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 509a3f88-56e2-475c-3961-08d76236b4db
x-ms-traffictypediagnostic: DM5PR12MB1195:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB11953E29104009FECC1C3F3A957E0@DM5PR12MB1195.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(199004)(189003)(2201001)(54906003)(110136005)(8676002)(7416002)(103116003)(305945005)(81156014)(81166006)(66946007)(478600001)(25786009)(66556008)(64756008)(99286004)(66476007)(7736002)(316002)(26005)(2501003)(3846002)(102836004)(52116002)(6116002)(6436002)(6506007)(386003)(86362001)(66446008)(8936002)(15650500001)(2906002)(76176011)(14454004)(71200400001)(71190400001)(446003)(256004)(6512007)(476003)(486006)(186003)(4326008)(11346002)(14444005)(5660300002)(6486002)(66066001)(41533002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1195;H:DM5PR12MB2471.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I+u+d79jUFisN2RQFOBONPb3+T9DF/HJGCU0KUkn84+UGiI8j6nbJLT3LjsCda522JFnIggrELevJYXig61WV3vSWf7oAR6GqLr35OLoxZMzmwtrHwOcKcFOQJQBajeHaDvp+iMfqy2OC4/nzMr1eh8x8/qNDqpbcpF8leE/2O3A218gRXgnCfNTxy0XKC9RGJ+pJiozuEGFvM5o8SqAUWe7oPq2eDupLKPZIE3uvbhkImKTEKlobJom8ZC7B9+q1zzBJeSnHC624FanQg8fs/5z4lqbPFyEmfd5Xcxs3NmKOxzps/6LFLlkarPjmB5Ogaf3jcXSRGV0YHYu56NZZDT8blQu8Xbyf+OZ7+n9lbFiOvc4A1AV4GaVq01iLsaYaWBaK1WHJDBBwPRpK7VbbXJ/AUGSbn8u5eR6RUUd21k+eWJeodYdKFH98Fah76JL
Content-Type: text/plain; charset="utf-8"
Content-ID: <BEE9486905102C459E82A6FA5DDBC107@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 509a3f88-56e2-475c-3961-08d76236b4db
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 21:25:40.0295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oo9pSPkhWyfKskTEFYlzYIpRvIPQqtAv+9AcKVJPEktNKSMRdG+y/v70S3S35o9F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1195
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QU1EIDJuZCBnZW5lcmF0aW9uIEVQWUMgcHJvY2Vzc29ycyBhbHNvIHN1cHBvcnQgVU1JUCBmZWF0
dXJlLg0KVXBkYXRlIHRoZSBjb21tZW50cyB0byBjb3ZlciBnZW5lcmljIHg4NiBwcm9jZXNzb3Jz
Lg0KDQpTaWduZWQtb2ZmLWJ5OiBCYWJ1IE1vZ2VyIDxiYWJ1Lm1vZ2VyQGFtZC5jb20+DQotLS0N
CiBhcmNoL3g4Ni9rZXJuZWwvdW1pcC5jIHwgICAxMiArKysrKystLS0tLS0NCiAxIGZpbGUgY2hh
bmdlZCwgNiBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvYXJj
aC94ODYva2VybmVsL3VtaXAuYyBiL2FyY2gveDg2L2tlcm5lbC91bWlwLmMNCmluZGV4IDU0OGZl
ZmVkNzFlZS4uOGNjZWY2YzQ5NWRjIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva2VybmVsL3VtaXAu
Yw0KKysrIGIvYXJjaC94ODYva2VybmVsL3VtaXAuYw0KQEAgLTEsNiArMSw2IEBADQogLyoNCi0g
KiB1bWlwLmMgRW11bGF0aW9uIGZvciBpbnN0cnVjdGlvbiBwcm90ZWN0ZWQgYnkgdGhlIEludGVs
IFVzZXItTW9kZQ0KLSAqIEluc3RydWN0aW9uIFByZXZlbnRpb24gZmVhdHVyZQ0KKyAqIHVtaXAu
YyBFbXVsYXRpb24gZm9yIGluc3RydWN0aW9uIHByb3RlY3RlZCBieSB0aGUgVXNlci1Nb2RlIElu
c3RydWN0aW9uDQorICogUHJldmVudGlvbiBmZWF0dXJlDQogICoNCiAgKiBDb3B5cmlnaHQgKGMp
IDIwMTcsIEludGVsIENvcnBvcmF0aW9uLg0KICAqIFJpY2FyZG8gTmVyaSA8cmljYXJkby5uZXJp
LWNhbGRlcm9uQGxpbnV4LmludGVsLmNvbT4NCkBAIC0xOCwxMCArMTgsMTAgQEANCiANCiAvKiog
RE9DOiBFbXVsYXRpb24gZm9yIFVzZXItTW9kZSBJbnN0cnVjdGlvbiBQcmV2ZW50aW9uIChVTUlQ
KQ0KICAqDQotICogVGhlIGZlYXR1cmUgVXNlci1Nb2RlIEluc3RydWN0aW9uIFByZXZlbnRpb24g
cHJlc2VudCBpbiByZWNlbnQgSW50ZWwNCi0gKiBwcm9jZXNzb3IgcHJldmVudHMgYSBncm91cCBv
ZiBpbnN0cnVjdGlvbnMgKFNHRFQsIFNJRFQsIFNMRFQsIFNNU1cgYW5kIFNUUikNCi0gKiBmcm9t
IGJlaW5nIGV4ZWN1dGVkIHdpdGggQ1BMID4gMC4gT3RoZXJ3aXNlLCBhIGdlbmVyYWwgcHJvdGVj
dGlvbiBmYXVsdCBpcw0KLSAqIGlzc3VlZC4NCisgKiBVc2VyLU1vZGUgSW5zdHJ1Y3Rpb24gUHJl
dmVudGlvbiBpcyBhIHNlY3VyaXR5IGZlYXR1cmUgcHJlc2VudCBpbiByZWNlbnQNCisgKiB4ODYg
cHJvY2Vzc29ycyB0aGF0LCB3aGVuIGVuYWJsZWQsIHByZXZlbnRzIGEgZ3JvdXAgb2YgaW5zdHJ1
Y3Rpb25zIChTR0RULA0KKyAqIFNJRFQsIFNMRFQsIFNNU1cgYW5kIFNUUikgZnJvbSBiZWluZyBy
dW4gaW4gdXNlciBtb2RlIGJ5IGlzc3VpbmcgYSBnZW5lcmFsDQorICogcHJvdGVjdGlvbiBmYXVs
dCBpZiB0aGUgaW5zdHJ1Y3Rpb24gaXMgZXhlY3V0ZWQgd2l0aCBDUEwgPiAwLg0KICAqDQogICog
UmF0aGVyIHRoYW4gcmVsYXlpbmcgdG8gdGhlIHVzZXIgc3BhY2UgdGhlIGdlbmVyYWwgcHJvdGVj
dGlvbiBmYXVsdCBjYXVzZWQgYnkNCiAgKiB0aGUgVU1JUC1wcm90ZWN0ZWQgaW5zdHJ1Y3Rpb25z
IChpbiB0aGUgZm9ybSBvZiBhIFNJR1NFR1Ygc2lnbmFsKSwgaXQgY2FuIGJlDQoNCg==
