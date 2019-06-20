Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D71C4D400
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 18:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732373AbfFTQjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 12:39:53 -0400
Received: from mail-eopbgr770082.outbound.protection.outlook.com ([40.107.77.82]:17878
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732192AbfFTQiz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 12:38:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gEhuR7xLcxz1XvInAUK+j4c3cLrgxl4PvmZ25H5rp+s=;
 b=dr0yvH04Ppd4BqOhZXXUI+lkkBXqquWsI2/b1Ab3vofNzxvurBHGBr5iRKmW7xLcAI8uodtXBfqxdOBw3vJYqgAPqehq/0GZbtUmoN23GQDyK/NU+hFJ/H7ih4QYGtZAcERz58xup0+80a4hbK4P9h1U4h39mpz5GXBtLNoD0dg=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3914.namprd12.prod.outlook.com (10.255.174.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Thu, 20 Jun 2019 16:38:52 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2%6]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 16:38:52 +0000
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
Subject: [RFC PATCH v2 03/11] KVM: SVM: Add KVM_SEV_SEND_FINISH command
Thread-Topic: [RFC PATCH v2 03/11] KVM: SVM: Add KVM_SEV_SEND_FINISH command
Thread-Index: AQHVJ4akn6U5xGOMbkOlBkZQ6vknPA==
Date:   Thu, 20 Jun 2019 16:38:52 +0000
Message-ID: <20190620163832.5451-4-brijesh.singh@amd.com>
References: <20190620163832.5451-1-brijesh.singh@amd.com>
In-Reply-To: <20190620163832.5451-1-brijesh.singh@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR15CA0055.namprd15.prod.outlook.com
 (2603:10b6:3:ae::17) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:4a::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d2394d8-55a0-40f9-6e43-08d6f59dc734
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3914;
x-ms-traffictypediagnostic: DM6PR12MB3914:
x-microsoft-antispam-prvs: <DM6PR12MB391447B87DABFBBA95184391E5E40@DM6PR12MB3914.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(52116002)(54906003)(86362001)(305945005)(256004)(6916009)(71190400001)(2501003)(71200400001)(6116002)(2906002)(25786009)(6512007)(53936002)(66446008)(6506007)(5640700003)(386003)(7416002)(14444005)(2351001)(66476007)(66556008)(7736002)(486006)(5660300002)(11346002)(476003)(99286004)(446003)(73956011)(68736007)(8936002)(6436002)(66946007)(478600001)(64756008)(4326008)(6486002)(3846002)(36756003)(66066001)(1730700003)(14454004)(81166006)(1076003)(102836004)(66574012)(81156014)(50226002)(186003)(8676002)(26005)(316002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3914;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: x9TfNDIG0ht6ZqRMjhutULSDbOEVJoEgEIam0//ODCEWmqDQJWrkJxQM+AqjcCUX59WH9FZ8R4q9UuOoVVTBW9ZvH24KjBJFYRG+CSqYSj8dY6YyozkbegWIwSv9BHeu4uYDg4D46GMiCIhd3KgBehyMhZcxSAxNfYvWdtvkTDT2iJP4JPNlqXDIqQmafYVWwfoWwIV11i77eSSF/4dGPrnstunrtY/mhmJW6bex0y9zvUOou9fAgw1Ic4XO0vQupGgLHGk4CxB+pPGJ9zggtfwIpfgkCXZIfG1s02Ps7SvC4k41syNwu8kXjbil8JTgLESr+8bHA1M65z2RaKAb8DfXFFXSx+qvzurfE9osC9rl00wnObGnWAGclwbYsrmb+iYy5d7Viww322In0Mq0j6QV+UM+GG34IS2kGOGOBgA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <61A9524CD9E75C43873CC11E9F69E0F5@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d2394d8-55a0-40f9-6e43-08d6f59dc734
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 16:38:52.4274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3914
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
ZW50YXRpb24vdmlydHVhbC9rdm0vYW1kLW1lbW9yeS1lbmNyeXB0aW9uLnJzdA0KaW5kZXggZWE4
ODFmMjFiYzYwLi5hZmExMWE3MjcxZjEgMTAwNjQ0DQotLS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnR1
YWwva3ZtL2FtZC1tZW1vcnktZW5jcnlwdGlvbi5yc3QNCisrKyBiL0RvY3VtZW50YXRpb24vdmly
dHVhbC9rdm0vYW1kLW1lbW9yeS1lbmNyeXB0aW9uLnJzdA0KQEAgLTI4OSw2ICsyODksMTQgQEAg
UmV0dXJuczogMCBvbiBzdWNjZXNzLCAtbmVnYXRpdmUgb24gZXJyb3INCiAgICAgICAgICAgICAg
ICAgX191MzIgdHJhbnNfbGVuOw0KICAgICAgICAgfTsNCiANCisxMi4gS1ZNX1NFVl9TRU5EX0ZJ
TklTSA0KKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKw0KK0FmdGVyIGNvbXBsZXRpb24gb2Yg
dGhlIG1pZ3JhdGlvbiBmbG93LCB0aGUgS1ZNX1NFVl9TRU5EX0ZJTklTSCBjb21tYW5kIGNhbiBi
ZQ0KK2lzc3VlZCBieSB0aGUgaHlwZXJ2aXNvciB0byBkZWxldGUgdGhlIGVuY3J5cHRpb24gY29u
dGV4dC4NCisNCitSZXR1cm5zOiAwIG9uIHN1Y2Nlc3MsIC1uZWdhdGl2ZSBvbiBlcnJvcg0KKw0K
IFJlZmVyZW5jZXMNCiA9PT09PT09PT09DQogDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3N2
bS5jIGIvYXJjaC94ODYva3ZtL3N2bS5jDQppbmRleCBkZTM1MzY2NGVhMjIuLjNkZmUzZjA1MWRk
OSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS9zdm0uYw0KKysrIGIvYXJjaC94ODYva3ZtL3N2
bS5jDQpAQCAtNzE3MSw2ICs3MTcxLDI2IEBAIHN0YXRpYyBpbnQgc2V2X3NlbmRfdXBkYXRlX2Rh
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
QEAgLTcyMTgsNiArNzIzOCw5IEBAIHN0YXRpYyBpbnQgc3ZtX21lbV9lbmNfb3Aoc3RydWN0IGt2
bSAqa3ZtLCB2b2lkIF9fdXNlciAqYXJncCkNCiAJY2FzZSBLVk1fU0VWX1NFTkRfVVBEQVRFX0RB
VEE6DQogCQlyID0gc2V2X3NlbmRfdXBkYXRlX2RhdGEoa3ZtLCAmc2V2X2NtZCk7DQogCQlicmVh
azsNCisJY2FzZSBLVk1fU0VWX1NFTkRfRklOSVNIOg0KKwkJciA9IHNldl9zZW5kX2ZpbmlzaChr
dm0sICZzZXZfY21kKTsNCisJCWJyZWFrOw0KIAlkZWZhdWx0Og0KIAkJciA9IC1FSU5WQUw7DQog
CQlnb3RvIG91dDsNCi0tIA0KMi4xNy4xDQoNCg==
