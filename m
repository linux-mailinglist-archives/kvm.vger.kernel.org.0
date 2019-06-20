Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D880F4D8B8
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 20:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbfFTS2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 14:28:43 -0400
Received: from mail-eopbgr720085.outbound.protection.outlook.com ([40.107.72.85]:31712
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727176AbfFTSDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 14:03:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KSi7hQglvoZVySPEEvFwVR+JzBOSqhwpat13WRAjbqo=;
 b=w5iLOfHQhQN/cWq57iegrRbYKeO6hu10K+A5JgPrbb+zlVeOIPMQpYkhERqImiPH9J8v14MVLfqexiDJk5n/syqkubDdGdq7y19QSoJq9Ls0SAbVW657Lpp8yVdSz/q1jkYsymND3lTW/dsL4uPtReIynLHs2j6AwwUbgpj7RLc=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3260.namprd12.prod.outlook.com (20.179.105.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Thu, 20 Jun 2019 18:03:21 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2%6]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 18:03:21 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: [RFC PATCH v1 08/12] target.json: add migrate-set-sev-info command
Thread-Topic: [RFC PATCH v1 08/12] target.json: add migrate-set-sev-info
 command
Thread-Index: AQHVJ5JxxSpSr3fdPkCv1Ymp5YKU2g==
Date:   Thu, 20 Jun 2019 18:03:20 +0000
Message-ID: <20190620180247.8825-9-brijesh.singh@amd.com>
References: <20190620180247.8825-1-brijesh.singh@amd.com>
In-Reply-To: <20190620180247.8825-1-brijesh.singh@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DM5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:4:15::11) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:4a::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c04821ad-32fd-4621-6f03-08d6f5a99341
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3260;
x-ms-traffictypediagnostic: DM6PR12MB3260:
x-microsoft-antispam-prvs: <DM6PR12MB3260E5B19DA38D9B5AFD1F64E5E40@DM6PR12MB3260.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(376002)(136003)(39860400002)(346002)(199004)(189003)(2351001)(53936002)(486006)(2616005)(11346002)(81156014)(8676002)(14444005)(6436002)(446003)(5640700003)(50226002)(6512007)(476003)(102836004)(6916009)(99286004)(2501003)(6486002)(76176011)(8936002)(52116002)(81166006)(316002)(186003)(6506007)(26005)(478600001)(256004)(3846002)(2906002)(386003)(66066001)(14454004)(54906003)(6116002)(305945005)(25786009)(1076003)(66946007)(66556008)(73956011)(64756008)(66446008)(71190400001)(71200400001)(68736007)(36756003)(66476007)(5660300002)(7736002)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3260;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Xw22ZYDTj6WDpjgEaHv39+zWiCzpHrZyeGHmRz58YQhzQHQS1Hjgp7llwgT3W7LTQfRSr/qUP54g82Kh+xstNMnyAMWtz89Rf/8ET8dUAz//9x/ppGmd2pdIRZn6iMvX3FnOeLYIyqP50QGVLcF51DfYYj7iN8J5/3q8/B7RKUgwM0MmtOEZXSPTf5/+mRkOmYCrceMKrpgJK5N5j6mLY1ri3ajyVyYbtJhBW8i9Kga7HzT7024NafFmBLPKajHH7GsNfZJW6KFMO3LGp++ZpCnDxfQGM12SLGisVbYDAgcBhxjRSYG8+OnJ57g5tSTHgK2r9+tac1vTE+4NN2IUUtU0YNnLeII/469PAXnrwkG3FcXrtzfInd49fmYijUcbWOr40qrJv1YEfnCCiP9SbPOvg8ybzjiuEbVGrT/K2Lk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c04821ad-32fd-4621-6f03-08d6f5a99341
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 18:03:20.4132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3260
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhlIGNvbW1hbmQgY2FuIGJlIHVzZWQgYnkgdGhlIGh5cGVydmlzb3IgdG8gc3BlY2lmeSB0aGUg
dGFyZ2V0IFBsYXRmb3JtDQpEaWZmaWUtSGVsbG1hbiBrZXkgKFBESCkgYW5kIGNlcnRpZmljYXRl
IGNoYWluIGJlZm9yZSBzdGFydGluZyB0aGUgU0VWDQpndWVzdCBtaWdyYXRpb24uIFRoZSB2YWx1
ZXMgcGFzc2VkIHRocm91Z2ggdGhlIGNvbW1hbmQgd2lsbCBiZSB1c2VkIHdoaWxlDQpjcmVhdGlu
ZyB0aGUgb3V0Z29pbmcgZW5jcnlwdGlvbiBjb250ZXh0Lg0KDQpTaWduZWQtb2ZmLWJ5OiBCcmlq
ZXNoIFNpbmdoIDxicmlqZXNoLnNpbmdoQGFtZC5jb20+DQotLS0NCiBxYXBpL3RhcmdldC5qc29u
ICAgICAgIHwgMTggKysrKysrKysrKysrKysrKysrDQogdGFyZ2V0L2kzODYvbW9uaXRvci5jICB8
IDEwICsrKysrKysrKysNCiB0YXJnZXQvaTM4Ni9zZXYtc3R1Yi5jIHwgIDUgKysrKysNCiB0YXJn
ZXQvaTM4Ni9zZXYuYyAgICAgIHwgMTEgKysrKysrKysrKysNCiB0YXJnZXQvaTM4Ni9zZXZfaTM4
Ni5oIHwgIDkgKysrKysrKystDQogNSBmaWxlcyBjaGFuZ2VkLCA1MiBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9xYXBpL3RhcmdldC5qc29uIGIvcWFwaS90YXJn
ZXQuanNvbg0KaW5kZXggMWQ0ZDU0YjYwMC4uNDEwOTc3MjI5OCAxMDA2NDQNCi0tLSBhL3FhcGkv
dGFyZ2V0Lmpzb24NCisrKyBiL3FhcGkvdGFyZ2V0Lmpzb24NCkBAIC01MTIsMyArNTEyLDIxIEBA
DQogIyMNCiB7ICdjb21tYW5kJzogJ3F1ZXJ5LWNwdS1kZWZpbml0aW9ucycsICdyZXR1cm5zJzog
WydDcHVEZWZpbml0aW9uSW5mbyddLA0KICAgJ2lmJzogJ2RlZmluZWQoVEFSR0VUX1BQQykgfHwg
ZGVmaW5lZChUQVJHRVRfQVJNKSB8fCBkZWZpbmVkKFRBUkdFVF9JMzg2KSB8fCBkZWZpbmVkKFRB
UkdFVF9TMzkwWCkgfHwgZGVmaW5lZChUQVJHRVRfTUlQUyknIH0NCisNCisjIw0KKyMgQG1pZ3Jh
dGUtc2V0LXNldi1pbmZvOg0KKyMNCisjIFRoZSBjb21tYW5kIGlzIHVzZWQgdG8gcHJvdmlkZSB0
aGUgdGFyZ2V0IGhvc3QgaW5mb3JtYXRpb24gdXNlZCBkdXJpbmcgdGhlDQorIyBTRVYgZ3Vlc3Qu
DQorIw0KKyMgQHBkaCB0aGUgdGFyZ2V0IGhvc3QgcGxhdGZvcm0gZGlmZmllLWhlbGxtYW4ga2V5
IGVuY29kZWQgaW4gYmFzZTY0DQorIw0KKyMgQHBsYXQtY2VydCB0aGUgdGFyZ2V0IGhvc3QgcGxh
dGZvcm0gY2VydGlmaWNhdGUgY2hhaW4gZW5jb2RlZCBpbiBiYXNlNjQNCisjDQorIyBAYW1kLWNl
cnQgQU1EIGNlcnRpZmljYXRlIGNoYWluIHdoaWNoIGluY2x1ZGUgQVNLIGFuZCBPQ0EgZW5jb2Rl
ZCBpbiBiYXNlNjQNCisjDQorIyBTaW5jZSA0LjMNCisjDQorIyMNCit7ICdjb21tYW5kJzogJ21p
Z3JhdGUtc2V0LXNldi1pbmZvJywNCisgICdkYXRhJzogeyAncGRoJzogJ3N0cicsICdwbGF0LWNl
cnQnOiAnc3RyJywgJ2FtZC1jZXJ0JyA6ICdzdHInIH19DQpkaWZmIC0tZ2l0IGEvdGFyZ2V0L2kz
ODYvbW9uaXRvci5jIGIvdGFyZ2V0L2kzODYvbW9uaXRvci5jDQppbmRleCA1NmUyZGJlY2U3Li42
OGUyZTJiOGVjIDEwMDY0NA0KLS0tIGEvdGFyZ2V0L2kzODYvbW9uaXRvci5jDQorKysgYi90YXJn
ZXQvaTM4Ni9tb25pdG9yLmMNCkBAIC03MzYsMyArNzM2LDEzIEBAIFNldkNhcGFiaWxpdHkgKnFt
cF9xdWVyeV9zZXZfY2FwYWJpbGl0aWVzKEVycm9yICoqZXJycCkNCiANCiAgICAgcmV0dXJuIGRh
dGE7DQogfQ0KKw0KK3ZvaWQgcW1wX21pZ3JhdGVfc2V0X3Nldl9pbmZvKGNvbnN0IGNoYXIgKnBk
aCwgY29uc3QgY2hhciAqcGxhdF9jZXJ0LA0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGNvbnN0IGNoYXIgKmFtZF9jZXJ0LCBFcnJvciAqKmVycnApDQorew0KKyAgICBpZiAoc2V2X2Vu
YWJsZWQoKSkgew0KKyAgICAgICAgc2V2X3NldF9taWdyYXRlX2luZm8ocGRoLCBwbGF0X2NlcnQs
IGFtZF9jZXJ0KTsNCisgICAgfSBlbHNlIHsNCisgICAgICAgIGVycm9yX3NldGcoZXJycCwgIlNF
ViBpcyBub3QgZW5hYmxlZCIpOw0KKyAgICB9DQorfQ0KZGlmZiAtLWdpdCBhL3RhcmdldC9pMzg2
L3Nldi1zdHViLmMgYi90YXJnZXQvaTM4Ni9zZXYtc3R1Yi5jDQppbmRleCBlNWVlMTMzMDljLi4x
NzNiZmE2Mzc0IDEwMDY0NA0KLS0tIGEvdGFyZ2V0L2kzODYvc2V2LXN0dWIuYw0KKysrIGIvdGFy
Z2V0L2kzODYvc2V2LXN0dWIuYw0KQEAgLTQ4LDMgKzQ4LDggQEAgU2V2Q2FwYWJpbGl0eSAqc2V2
X2dldF9jYXBhYmlsaXRpZXModm9pZCkNCiB7DQogICAgIHJldHVybiBOVUxMOw0KIH0NCisNCit2
b2lkIHNldl9zZXRfbWlncmF0ZV9pbmZvKGNvbnN0IGNoYXIgKnBkaCwgY29uc3QgY2hhciAqcGxh
dF9jZXJ0LA0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc3QgY2hhciAqYW1kX2NlcnQp
DQorew0KK30NCmRpZmYgLS1naXQgYS90YXJnZXQvaTM4Ni9zZXYuYyBiL3RhcmdldC9pMzg2L3Nl
di5jDQppbmRleCAxYjA1ZmNmOWE5Li4yYzdjNDk2NTkzIDEwMDY0NA0KLS0tIGEvdGFyZ2V0L2kz
ODYvc2V2LmMNCisrKyBiL3RhcmdldC9pMzg2L3Nldi5jDQpAQCAtODUyLDYgKzg1MiwxNyBAQCBp
bnQgc2V2X3N5bmNfcGFnZV9lbmNfYml0bWFwKHZvaWQgKmhhbmRsZSwgdWludDhfdCAqaG9zdCwg
dWludDY0X3Qgc2l6ZSwNCiAgICAgcmV0dXJuIDA7DQogfQ0KIA0KK3ZvaWQgc2V2X3NldF9taWdy
YXRlX2luZm8oY29uc3QgY2hhciAqcGRoLCBjb25zdCBjaGFyICpwbGF0X2NlcnQsDQorICAgICAg
ICAgICAgICAgICAgICAgICAgICBjb25zdCBjaGFyICphbWRfY2VydCkNCit7DQorICAgIFNFVlN0
YXRlICpzID0gc2V2X3N0YXRlOw0KKw0KKyAgICBzLT5yZW1vdGVfcGRoID0gZ19iYXNlNjRfZGVj
b2RlKHBkaCwgJnMtPnJlbW90ZV9wZGhfbGVuKTsNCisgICAgcy0+cmVtb3RlX3BsYXRfY2VydCA9
IGdfYmFzZTY0X2RlY29kZShwbGF0X2NlcnQsDQorICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgJnMtPnJlbW90ZV9wbGF0X2NlcnRfbGVuKTsNCisgICAgcy0+YW1kX2Nl
cnQgPSBnX2Jhc2U2NF9kZWNvZGUoYW1kX2NlcnQsICZzLT5hbWRfY2VydF9sZW4pOw0KK30NCisN
CiBzdGF0aWMgdm9pZA0KIHNldl9yZWdpc3Rlcl90eXBlcyh2b2lkKQ0KIHsNCmRpZmYgLS1naXQg
YS90YXJnZXQvaTM4Ni9zZXZfaTM4Ni5oIGIvdGFyZ2V0L2kzODYvc2V2X2kzODYuaA0KaW5kZXgg
YzBmOTM3M2JlYi4uMjU4MDQ3YWIyYyAxMDA2NDQNCi0tLSBhL3RhcmdldC9pMzg2L3Nldl9pMzg2
LmgNCisrKyBiL3RhcmdldC9pMzg2L3Nldl9pMzg2LmgNCkBAIC0zOSw3ICszOSw4IEBAIGV4dGVy
biB1aW50MzJfdCBzZXZfZ2V0X2NiaXRfcG9zaXRpb24odm9pZCk7DQogZXh0ZXJuIHVpbnQzMl90
IHNldl9nZXRfcmVkdWNlZF9waHlzX2JpdHModm9pZCk7DQogZXh0ZXJuIGNoYXIgKnNldl9nZXRf
bGF1bmNoX21lYXN1cmVtZW50KHZvaWQpOw0KIGV4dGVybiBTZXZDYXBhYmlsaXR5ICpzZXZfZ2V0
X2NhcGFiaWxpdGllcyh2b2lkKTsNCi0NCitleHRlcm4gdm9pZCBzZXZfc2V0X21pZ3JhdGVfaW5m
byhjb25zdCBjaGFyICpwZGgsIGNvbnN0IGNoYXIgKnBsYXRfY2VydCwNCisgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBjb25zdCBjaGFyICphbWRfY2VydCk7DQogdHlwZWRlZiBzdHJ1
Y3QgUVNldkd1ZXN0SW5mbyBRU2V2R3Vlc3RJbmZvOw0KIHR5cGVkZWYgc3RydWN0IFFTZXZHdWVz
dEluZm9DbGFzcyBRU2V2R3Vlc3RJbmZvQ2xhc3M7DQogDQpAQCAtODEsNiArODIsMTIgQEAgc3Ry
dWN0IFNFVlN0YXRlIHsNCiAgICAgaW50IHNldl9mZDsNCiAgICAgU2V2U3RhdGUgc3RhdGU7DQog
ICAgIGdjaGFyICptZWFzdXJlbWVudDsNCisgICAgZ3VjaGFyICpyZW1vdGVfcGRoOw0KKyAgICBz
aXplX3QgcmVtb3RlX3BkaF9sZW47DQorICAgIGd1Y2hhciAqcmVtb3RlX3BsYXRfY2VydDsNCisg
ICAgc2l6ZV90IHJlbW90ZV9wbGF0X2NlcnRfbGVuOw0KKyAgICBndWNoYXIgKmFtZF9jZXJ0Ow0K
KyAgICBzaXplX3QgYW1kX2NlcnRfbGVuOw0KIH07DQogDQogdHlwZWRlZiBzdHJ1Y3QgU0VWU3Rh
dGUgU0VWU3RhdGU7DQotLSANCjIuMTcuMQ0KDQo=
