Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1AF11CC3F
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 17:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbfENPt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 11:49:56 -0400
Received: from mail-eopbgr820082.outbound.protection.outlook.com ([40.107.82.82]:21024
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725901AbfENPtz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 11:49:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+cV5nQUritTdFUknDzJVWAoOeLLVGz2oThSdTDm2qs=;
 b=r7sCywDH63mRwEyDQwt2dY88KngGkXPlQvcOFtwDtsVEUEpu+IHSlbD5RZPdNIYVcbyycH6Ty6ewpUSuD/2GhyGwYVwV3rAb6YLZygu02D/kHFmoMGcysT6M9zclM3uehoDBGlEmGDs2EHNLCp/1nqDegaTlf5bLtDceYBxxlEw=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3004.namprd12.prod.outlook.com (20.178.29.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.25; Tue, 14 May 2019 15:49:52 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::edb0:d696:3077:51bc]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::edb0:d696:3077:51bc%2]) with mapi id 15.20.1878.024; Tue, 14 May 2019
 15:49:52 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "graf@amazon.com" <graf@amazon.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v2] svm/avic: Allow avic_vcpu_load logic to support host APIC
 ID 255
Thread-Topic: [PATCH v2] svm/avic: Allow avic_vcpu_load logic to support host
 APIC ID 255
Thread-Index: AQHVCmyrLU0LS+h5g0aXaHB58uDCjQ==
Date:   Tue, 14 May 2019 15:49:52 +0000
Message-ID: <1557848977-146396-1-git-send-email-suravee.suthikulpanit@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN1PR12CA0088.namprd12.prod.outlook.com
 (2603:10b6:802:21::23) To DM6PR12MB2844.namprd12.prod.outlook.com
 (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a77cce1-4128-4606-d0ae-08d6d883cd9d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3004;
x-ms-traffictypediagnostic: DM6PR12MB3004:
x-microsoft-antispam-prvs: <DM6PR12MB3004764E972200A5B163AC8AF3080@DM6PR12MB3004.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0037FD6480
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(39860400002)(396003)(366004)(189003)(199004)(52116002)(14454004)(6512007)(86362001)(2906002)(25786009)(7736002)(305945005)(4326008)(3846002)(53936002)(66066001)(6116002)(186003)(476003)(2616005)(54906003)(99286004)(316002)(6436002)(486006)(6486002)(26005)(2501003)(102836004)(386003)(6506007)(110136005)(68736007)(72206003)(4720700003)(66946007)(73956011)(36756003)(66476007)(5660300002)(66446008)(64756008)(66556008)(256004)(8676002)(50226002)(81156014)(8936002)(81166006)(14444005)(71200400001)(71190400001)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3004;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IN8PellT1cf2RCayNETNCP/u16GLGM7Xfr28lADyRosRwHG5SAD2uUavl0LYTD7/I3Fl0kiBlN1d5ytYFM/10CVHrmmUg0MTSBfHSjjL2RcLfLmfGRnWEP7zXYhAguAKAc+nyFSfSYPOGy5QX+5wMzRjiO3pmYBNq9ubJKN5B0OsyWumdOzAUfqK4W/9ob8/yrv/HbE+tYeFs90dacPpKTqIczHTv0Suf7Jc3LrtRr0s5qfQHRBbyVhFtAspV8bDlYCxIJZV7cSoI9YHXLM9vpwmnL08IEYLyBKKfcs7cpERliN8jYbSn3GyxyvVEKDP7bFf5OY6D5JNArgAxD0ZGyJsrwECmQL4zeMgQ4W/ONau2sFd7YtViV8smxtUxTjQT9skrAFokpaRLGgTyidaDCDy6lj2RB7tIuZ9aPea7Yk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a77cce1-4128-4606-d0ae-08d6d883cd9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2019 15:49:52.7085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3004
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Q3VycmVudCBsb2dpYyBkb2VzIG5vdCBhbGxvdyBWQ1BVIHRvIGJlIGxvYWRlZCBvbnRvIENQVSB3
aXRoDQpBUElDIElEIDI1NS4gVGhpcyBzaG91bGQgYmUgYWxsb3dlZCBzaW5jZSB0aGUgaG9zdCBw
aHlzaWNhbCBBUElDIElEDQpmaWVsZCBpbiB0aGUgQVZJQyBQaHlzaWNhbCBBUElDIHRhYmxlIGVu
dHJ5IGlzIGFuIDgtYml0IHZhbHVlLA0KYW5kIEFQSUMgSUQgMjU1IGlzIHZhbGlkIGluIHN5c3Rl
bSB3aXRoIHgyQVBJQyBlbmFibGVkLg0KSW5zdGVhZCwgZG8gbm90IGFsbG93IFZDUFUgbG9hZCBp
ZiB0aGUgaG9zdCBBUElDIElEIGNhbm5vdCBiZQ0KcmVwcmVzZW50ZWQgYnkgYW4gOC1iaXQgdmFs
dWUuDQoNCkFsc28sIHVzZSB0aGUgbW9yZSBhcHByb3ByaWF0ZSBBVklDX1BIWVNJQ0FMX0lEX0VO
VFJZX0hPU1RfUEhZU0lDQUxfSURfTUFTSw0KaW5zdGVhZCBvZiBBVklDX01BWF9QSFlTSUNBTF9J
RF9DT1VOVC4gDQoNClNpZ25lZC1vZmYtYnk6IFN1cmF2ZWUgU3V0aGlrdWxwYW5pdCA8c3VyYXZl
ZS5zdXRoaWt1bHBhbml0QGFtZC5jb20+DQotLS0NCg0KQ2hhbmdlIGluIFYyOg0KICAqIFVzZSBB
VklDX1BIWVNJQ0FMX0lEX0VOVFJZX0hPU1RfUEhZU0lDQUxfSURfTUFTSyBpbnN0ZWFkIG9mDQog
ICAgQVZJQ19NQVhfUEhZU0lDQUxfSURfQ09VTlQuIA0KDQogYXJjaC94ODYva3ZtL3N2bS5jIHwg
NiArKysrKy0NCiAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
DQoNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vc3ZtLmMgYi9hcmNoL3g4Ni9rdm0vc3ZtLmMN
CmluZGV4IDY4Nzc2N2YuLjM0NWZlOWUgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtLmMN
CisrKyBiL2FyY2gveDg2L2t2bS9zdm0uYw0KQEAgLTIwNzEsNyArMjA3MSwxMSBAQCBzdGF0aWMg
dm9pZCBhdmljX3ZjcHVfbG9hZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGludCBjcHUpDQogCWlm
ICgha3ZtX3ZjcHVfYXBpY3ZfYWN0aXZlKHZjcHUpKQ0KIAkJcmV0dXJuOw0KIA0KLQlpZiAoV0FS
Tl9PTihoX3BoeXNpY2FsX2lkID49IEFWSUNfTUFYX1BIWVNJQ0FMX0lEX0NPVU5UKSkNCisJLyoN
CisJICogU2luY2UgdGhlIGhvc3QgcGh5c2ljYWwgQVBJQyBpZCBpcyA4IGJpdHMsDQorCSAqIHdl
IGNhbiBzdXBwb3J0IGhvc3QgQVBJQyBJRCB1cHRvIDI1NS4NCisJICovDQorCWlmIChXQVJOX09O
KGhfcGh5c2ljYWxfaWQgPiBBVklDX1BIWVNJQ0FMX0lEX0VOVFJZX0hPU1RfUEhZU0lDQUxfSURf
TUFTSykpDQogCQlyZXR1cm47DQogDQogCWVudHJ5ID0gUkVBRF9PTkNFKCooc3ZtLT5hdmljX3Bo
eXNpY2FsX2lkX2NhY2hlKSk7DQotLSANCjEuOC4zLjENCg0K
