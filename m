Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912A164D4C
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 22:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbfGJUNG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 16:13:06 -0400
Received: from mail-eopbgr790081.outbound.protection.outlook.com ([40.107.79.81]:24128
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727546AbfGJUNG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 16:13:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+XOImXtU36aBOZ4W9A5/3y1y7JBXAmRitsFVswIbl0Y=;
 b=eyGLZJkoNJNCiirgPrgdCq7mKGiF85zTuUAW/Cv3dwJ+3lRfNU2drO5AfDz7w4AGK0V4sxCsWT84dwaZFnGvmfo/cPKA5jYB1d/L8pqT44xQikuRNiu1S9Q9SbNGS/WSmeBWtP3pmxV4ZAKv36MvxCDZSrp5caqHk5CxWR1tAek=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3756.namprd12.prod.outlook.com (10.255.172.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Wed, 10 Jul 2019 20:13:03 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::bc1a:a30d:9da2:1cdd]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::bc1a:a30d:9da2:1cdd%6]) with mapi id 15.20.2073.008; Wed, 10 Jul 2019
 20:13:03 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 03/11] KVM: SVM: Add KVM_SEV_SEND_FINISH command
Thread-Topic: [PATCH v3 03/11] KVM: SVM: Add KVM_SEV_SEND_FINISH command
Thread-Index: AQHVN1vgHlRmhKOlHkKKrac8xABuKQ==
Date:   Wed, 10 Jul 2019 20:13:03 +0000
Message-ID: <20190710201244.25195-4-brijesh.singh@amd.com>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
In-Reply-To: <20190710201244.25195-1-brijesh.singh@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0014.namprd05.prod.outlook.com
 (2603:10b6:803:40::27) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:4a::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0e92777-f898-4922-9926-08d705730349
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3756;
x-ms-traffictypediagnostic: DM6PR12MB3756:
x-microsoft-antispam-prvs: <DM6PR12MB37567CB726224FB450E5E226E5F00@DM6PR12MB3756.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(189003)(199004)(6436002)(4326008)(8676002)(71200400001)(6512007)(7736002)(6116002)(99286004)(476003)(66066001)(71190400001)(478600001)(5640700003)(1730700003)(14444005)(256004)(2351001)(53936002)(486006)(2501003)(6486002)(66574012)(50226002)(386003)(316002)(81156014)(81166006)(54906003)(76176011)(66946007)(66446008)(5660300002)(64756008)(66476007)(66556008)(6506007)(3846002)(305945005)(68736007)(102836004)(2906002)(52116002)(186003)(7416002)(1076003)(25786009)(6916009)(2616005)(26005)(8936002)(14454004)(11346002)(86362001)(446003)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3756;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vXAuNEPGyOpN9+pMhf/tXJ2SfNiqodnyTqC6PniYpBK0SBOVqGI+tiW9VVA47nRYj2v7hoNxov7aiS7ZPyYWFCsjTNQWHINC9f4UwcH+mTbSAQ3RrhVuHjcRs+q4slVAOfPxGfAPE6dmhnEilzpiGQCIWUIGeVlf0zESfm7fPWJC/88iWOCZ3QFZqGG2TEgqYGa0OMs5fatbB+SZ2w0F8v+S2qhvL/6aFqj7WX/bPDGrzdkjqMHUdyPewZ0JCn2vxkPM5zRQopzUY6CphLMuJQ9LgGwDZD9hwNSHsWKWebqVfmw6dyX+/FSnKQHuzlOSyeGZ05ex/ZJx+6sJODkFa7H+BtOZPvAERNde7NW32ZujeA1IUvyEgvfwkZ3aGeTIH2AIPBdb+vcPjWqWkJ5Gn5GBc1UxPHRJDC34WZpvaFE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7C0C291E9AF064E9A64F426DF41A313@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0e92777-f898-4922-9926-08d705730349
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 20:13:03.3455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3756
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhlIGNvbW1hbmQgaXMgdXNlZCB0byBmaW5haWxpemUgdGhlIGVuY3J5cHRpb24gY29udGV4dCBj
cmVhdGVkIHdpdGgNCktWTV9TRVZfU0VORF9TVEFSVCBjb21tYW5kLg0KDQpDYzogVGhvbWFzIEds
ZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+DQpDYzogSW5nbyBNb2xuYXIgPG1pbmdvQHJlZGhh
dC5jb20+DQpDYzogIkguIFBldGVyIEFudmluIiA8aHBhQHp5dG9yLmNvbT4NCkNjOiBQYW9sbyBC
b256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KQ2M6ICJSYWRpbSBLcsSNbcOhxZkiIDxya3Jj
bWFyQHJlZGhhdC5jb20+DQpDYzogSm9lcmcgUm9lZGVsIDxqb3JvQDhieXRlcy5vcmc+DQpDYzog
Qm9yaXNsYXYgUGV0a292IDxicEBzdXNlLmRlPg0KQ2M6IFRvbSBMZW5kYWNreSA8dGhvbWFzLmxl
bmRhY2t5QGFtZC5jb20+DQpDYzogeDg2QGtlcm5lbC5vcmcNCkNjOiBrdm1Admdlci5rZXJuZWwu
b3JnDQpDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KU2lnbmVkLW9mZi1ieTogQnJp
amVzaCBTaW5naCA8YnJpamVzaC5zaW5naEBhbWQuY29tPg0KLS0tDQogLi4uL3ZpcnR1YWwva3Zt
L2FtZC1tZW1vcnktZW5jcnlwdGlvbi5yc3QgICAgIHwgIDggKysrKysrKw0KIGFyY2gveDg2L2t2
bS9zdm0uYyAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IDIzICsrKysrKysrKysrKysrKysr
KysNCiAyIGZpbGVzIGNoYW5nZWQsIDMxIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL0Rv
Y3VtZW50YXRpb24vdmlydHVhbC9rdm0vYW1kLW1lbW9yeS1lbmNyeXB0aW9uLnJzdCBiL0RvY3Vt
ZW50YXRpb24vdmlydHVhbC9rdm0vYW1kLW1lbW9yeS1lbmNyeXB0aW9uLnJzdA0KaW5kZXggMDYw
YWMyMzE2ZDY5Li45ODY0ZjkyMTVjNDMgMTAwNjQ0DQotLS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnR1
YWwva3ZtL2FtZC1tZW1vcnktZW5jcnlwdGlvbi5yc3QNCisrKyBiL0RvY3VtZW50YXRpb24vdmly
dHVhbC9rdm0vYW1kLW1lbW9yeS1lbmNyeXB0aW9uLnJzdA0KQEAgLTI4OSw2ICsyODksMTQgQEAg
UmV0dXJuczogMCBvbiBzdWNjZXNzLCAtbmVnYXRpdmUgb24gZXJyb3INCiAgICAgICAgICAgICAg
ICAgX191MzIgdHJhbnNfbGVuOw0KICAgICAgICAgfTsNCiANCisxMi4gS1ZNX1NFVl9TRU5EX0ZJ
TklTSA0KKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKw0KK0FmdGVyIGNvbXBsZXRpb24gb2Yg
dGhlIG1pZ3JhdGlvbiBmbG93LCB0aGUgS1ZNX1NFVl9TRU5EX0ZJTklTSCBjb21tYW5kIGNhbiBi
ZQ0KK2lzc3VlZCBieSB0aGUgaHlwZXJ2aXNvciB0byBkZWxldGUgdGhlIGVuY3J5cHRpb24gY29u
dGV4dC4NCisNCitSZXR1cm5zOiAwIG9uIHN1Y2Nlc3MsIC1uZWdhdGl2ZSBvbiBlcnJvcg0KKw0K
IFJlZmVyZW5jZXMNCiA9PT09PT09PT09DQogDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3N2
bS5jIGIvYXJjaC94ODYva3ZtL3N2bS5jDQppbmRleCA4ZTgxNWE1M2M0MjAuLmJlNzNhODdhOGM0
ZiAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS9zdm0uYw0KKysrIGIvYXJjaC94ODYva3ZtL3N2
bS5jDQpAQCAtNzE2OCw2ICs3MTY4LDI2IEBAIHN0YXRpYyBpbnQgc2V2X3NlbmRfdXBkYXRlX2Rh
dGEoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX3Nldl9jbWQgKmFyZ3ApDQogCXJldHVybiBy
ZXQ7DQogfQ0KIA0KK3N0YXRpYyBpbnQgc2V2X3NlbmRfZmluaXNoKHN0cnVjdCBrdm0gKmt2bSwg
c3RydWN0IGt2bV9zZXZfY21kICphcmdwKQ0KK3sNCisJc3RydWN0IGt2bV9zZXZfaW5mbyAqc2V2
ID0gJnRvX2t2bV9zdm0oa3ZtKS0+c2V2X2luZm87DQorCXN0cnVjdCBzZXZfZGF0YV9zZW5kX2Zp
bmlzaCAqZGF0YTsNCisJaW50IHJldDsNCisNCisJaWYgKCFzZXZfZ3Vlc3Qoa3ZtKSkNCisJCXJl
dHVybiAtRU5PVFRZOw0KKw0KKwlkYXRhID0ga3phbGxvYyhzaXplb2YoKmRhdGEpLCBHRlBfS0VS
TkVMKTsNCisJaWYgKCFkYXRhKQ0KKwkJcmV0dXJuIC1FTk9NRU07DQorDQorCWRhdGEtPmhhbmRs
ZSA9IHNldi0+aGFuZGxlOw0KKwlyZXQgPSBzZXZfaXNzdWVfY21kKGt2bSwgU0VWX0NNRF9TRU5E
X0ZJTklTSCwgZGF0YSwgJmFyZ3AtPmVycm9yKTsNCisNCisJa2ZyZWUoZGF0YSk7DQorCXJldHVy
biByZXQ7DQorfQ0KKw0KIHN0YXRpYyBpbnQgc3ZtX21lbV9lbmNfb3Aoc3RydWN0IGt2bSAqa3Zt
LCB2b2lkIF9fdXNlciAqYXJncCkNCiB7DQogCXN0cnVjdCBrdm1fc2V2X2NtZCBzZXZfY21kOw0K
QEAgLTcyMTUsNiArNzIzNSw5IEBAIHN0YXRpYyBpbnQgc3ZtX21lbV9lbmNfb3Aoc3RydWN0IGt2
bSAqa3ZtLCB2b2lkIF9fdXNlciAqYXJncCkNCiAJY2FzZSBLVk1fU0VWX1NFTkRfVVBEQVRFX0RB
VEE6DQogCQlyID0gc2V2X3NlbmRfdXBkYXRlX2RhdGEoa3ZtLCAmc2V2X2NtZCk7DQogCQlicmVh
azsNCisJY2FzZSBLVk1fU0VWX1NFTkRfRklOSVNIOg0KKwkJciA9IHNldl9zZW5kX2ZpbmlzaChr
dm0sICZzZXZfY21kKTsNCisJCWJyZWFrOw0KIAlkZWZhdWx0Og0KIAkJciA9IC1FSU5WQUw7DQog
CQlnb3RvIG91dDsNCi0tIA0KMi4xNy4xDQoNCg==
