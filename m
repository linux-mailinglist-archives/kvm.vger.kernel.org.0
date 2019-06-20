Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6C44D604
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 20:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfFTSDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 14:03:25 -0400
Received: from mail-eopbgr720085.outbound.protection.outlook.com ([40.107.72.85]:31712
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727581AbfFTSDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 14:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtbcS6taWunpw+xfzVL8rz20+Hkl3yki0Z83fCyA7YA=;
 b=0NK7WofqT7iIMqf88sNQm1c0eL+qN+VDeMz7CeUMovgKyguTPulHf6ewzWZl4KZajTh+75/zjuV93Thr8YbkmQDxdVoKa0UgTq734ga7KNB85vVLMu0n5bloxcNya2WdQzYhAX/WeraWN4CGrtMtJ+f0jsTyWh39ScJudBGTlPA=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3260.namprd12.prod.outlook.com (20.179.105.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Thu, 20 Jun 2019 18:03:20 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2%6]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 18:03:20 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: [RFC PATCH v1 06/12] doc: update AMD SEV to include Live migration
 flow
Thread-Topic: [RFC PATCH v1 06/12] doc: update AMD SEV to include Live
 migration flow
Thread-Index: AQHVJ5Jwlsa+LcCsr0a3jwBl/wUS8g==
Date:   Thu, 20 Jun 2019 18:03:18 +0000
Message-ID: <20190620180247.8825-7-brijesh.singh@amd.com>
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
x-ms-office365-filtering-correlation-id: 67d5d913-5fc8-477e-c3be-08d6f5a992a1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3260;
x-ms-traffictypediagnostic: DM6PR12MB3260:
x-microsoft-antispam-prvs: <DM6PR12MB3260079BA20ED7F34BDEC6A5E5E40@DM6PR12MB3260.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(376002)(136003)(39860400002)(346002)(199004)(189003)(2351001)(53936002)(486006)(2616005)(11346002)(81156014)(8676002)(14444005)(6436002)(446003)(5640700003)(50226002)(6512007)(476003)(102836004)(6916009)(99286004)(2501003)(6486002)(76176011)(8936002)(52116002)(81166006)(316002)(186003)(6506007)(26005)(478600001)(256004)(3846002)(2906002)(386003)(66066001)(14454004)(54906003)(6116002)(305945005)(25786009)(1076003)(66946007)(66556008)(73956011)(64756008)(66446008)(71190400001)(71200400001)(68736007)(36756003)(66476007)(5660300002)(15650500001)(7736002)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3260;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rhVm4gAuizhHs883mO6qAT9PjpfaxRtI52CJ0K6PPJbFuwlBh6GbTuT0CRIJI4bMfRiAOB0aybKZb6S2jQ/a+W+E6BKUXj2C8eAR9JDIxEdT+VKYunFZTGi3dRte0Oj4G7EG/gMKa6q+erA075KkEfNjnQNDqSyHcJuS4+uJ5ZlzgbzVnW/hKUnDFqWO4dBOQWUieyHnEGdfeGGTGQvOnljimU6h5AUHFbogKvm5nhE2/SXBVA6xrimWodkltEiVgnolnJ/KmKPmOEar+hEd6NG3YE77Aje1qsIsiajykl2oOFicHyUAHKlB51JHaF+WTrCHS4J8HCbqJH4xUr7oH/hh1F+fkxWNLAHOCq5IY5WBi+QaYk1xxyIt09a+PpBB72weMk2K52Dr/ey+GoOCpN14Qa/FpZyMaK7Eb3aTMgQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d5d913-5fc8-477e-c3be-08d6f5a992a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 18:03:18.0545
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

U2lnbmVkLW9mZi1ieTogQnJpamVzaCBTaW5naCA8YnJpamVzaC5zaW5naEBhbWQuY29tPg0KLS0t
DQogZG9jcy9hbWQtbWVtb3J5LWVuY3J5cHRpb24udHh0IHwgNDQgKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrLQ0KIDEgZmlsZSBjaGFuZ2VkLCA0MyBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kb2NzL2FtZC1tZW1vcnktZW5jcnlwdGlvbi50eHQg
Yi9kb2NzL2FtZC1tZW1vcnktZW5jcnlwdGlvbi50eHQNCmluZGV4IGFiYjlhOTc2ZjUuLjc1N2Uw
ZDkzMWEgMTAwNjQ0DQotLS0gYS9kb2NzL2FtZC1tZW1vcnktZW5jcnlwdGlvbi50eHQNCisrKyBi
L2RvY3MvYW1kLW1lbW9yeS1lbmNyeXB0aW9uLnR4dA0KQEAgLTg5LDcgKzg5LDQ5IEBAIFRPRE8N
CiANCiBMaXZlIE1pZ3JhdGlvbg0KIC0tLS0tLS0tLS0tLS0tLS0NCi1UT0RPDQorQU1EIFNFViBl
bmNyeXB0cyB0aGUgbWVtb3J5IG9mIFZNcyBhbmQgYmVjYXVzZSBvZiB0aGlzIGVuY3J5cHRpb24g
aXMgZG9uZQ0KK3VzaW5nIGFuIGFkZHJlc3MgdHdlYWssIHRoZSBoeXBlcnZpc29yIHdpbGwgbm90
IGJlIGFibGUgdG8gc2ltcGx5IGNvcHkgdGhlDQorY2lwaGVydGV4dCBiZXR3ZWVuIG1hY2hpbmVz
IHRvIG1pZ3JhdGUgYSBWTS4gSW5zdGVhZCB0aGUgQU1EIFNFViBLZXkNCitNYW5hZ2VtZW50IEFQ
SSBwcm92aWRlcyBhIHNldCBvZiBmdW5jdGlvbiB3aGljaCB0aGUgaHlwZXJ2aXNvciBjYW4gdXNl
DQordG8gcGFja2FnZSBhIGd1ZXN0IHBhZ2UgZm9yIG1pZ3JhdGlvbiwgd2hpbGUgbWFpbnRhaW5p
bmcgdGhlIGNvbmZpZGVudGlhbGl0eQ0KK3Byb3ZpZGVkIGJ5IHRoZSBBTUQgU0VWLg0KKw0KK1NF
ViBndWVzdCBWTXMgaGF2ZSB0aGUgY29uY2VwdCBvZiBwcml2YXRlIGFuZCBzaGFyZWQgbWVtb3J5
LiBUaGUgcHJpdmF0ZQ0KK21lbW9yeSBpcyBlbmNyeXB0ZWQgd2l0aCB0aGUgZ3Vlc3Qtc3BlY2lm
aWMga2V5LCB3aGlsZSBzaGFyZWQgbWVtb3J5IG1heQ0KK2JlIGVuY3J5cHRlZCB3aXRoIHRoZSBo
eXBlcnZpc29yIGtleS4gVGhlIG1pZ3JhdGlvbiBBUElzIHByb3ZpZGVkIGJ5IHRoZQ0KK1NFViBB
UEkgc3BlYyBzaG91bGQgYmUgdXNlZCBtaWdyYXRpbmcgdGhlIHByaXZhdGUgcGFnZXMuIFRoZQ0K
K0tWTV9HRVRfUEFHRV9FTkNfQklUTUFQIGlvY3RsIGNhbiBiZSB1c2VkIHRvIGdldCB0aGUgZ3Vl
c3QgcGFnZSBzdGF0ZQ0KK2JpdG1hcC4gVGhlIGJpdG1hcCBjYW4gYmUgdXNlZCB0byBjaGVjayBp
ZiB0aGUgZ2l2ZW4gZ3Vlc3QgcGFnZSBpcw0KK3ByaXZhdGUgb3Igc2hhcmVkLg0KKw0KK0JlZm9y
ZSBpbml0aWF0aW5nIHRoZSBtaWdyYXRpb24sIHdlIG5lZWQgdG8ga25vdyB0aGUgdGFyZ2V0cyBw
dWJsaWMNCitEaWZmaWUtSGVsbG1hbiBrZXkgKFBESCkgYW5kIGNlcnRpZmljYXRlIGNoYWluLiBJ
dCBjYW4gcmV0cmlldmVkDQord2l0aCAncXVlcnktc2V2LWNhcGFiaWxpdGllcycgUU1QIG9yIHVz
aW5nIHRoZSBzZXYtdG9vbC4gVGhlDQorbWlncmF0ZS1zZXQtc2V2LWluZm8gb2JqZWN0IGNhbiBi
ZSB1c2VkIHRvIHBhc3MgdGhlIHRhcmdldHMgUERIIGFuZA0KK2NlcnRpZmljYXRlIGNoYWluLg0K
Kw0KK2UuZw0KKyhRTVApIG1pZ3JhdGUtc2V2LXNldC1pbmZvIHBkaD08dGFyZ2V0X3BkaD4gcGxh
dC1jZXJ0PTx0YXJnZXRfY2VydF9jaGFpbj4gXA0KKyAgICAgICBhbWQtY2VydD08YW1kX2NlcnQ+
DQorKFFNUCkgbWlncmF0ZSB0Y3A6MDo0NDQ0DQorDQorTm90ZTogQU1EIGNlcnQgY29udGFpbiBi
ZSBvYnRhaW5lZCBmcm9tIGRldmVsb3Blci5hbWQuY29tL3Nldi4NCisNCitEdXJpbmcgdGhlIG1p
Z3JhdGlvbiBmbG93LCBvbiBzb3VyY2UgaHlwZXJ2aXNvciBTRU5EX1NUQVJUIGlzIGNhbGxlZCBm
aXJzdA0KK3RvIGNyZWF0ZSBvdXRnb2luZyBlbmNyeXB0aW9uIGNvbnRleHQuIEJhc2VkIG9uIHRo
ZSBTRVYgZ3Vlc3QgcG9saWN5LCB0aGUNCitjZXJ0aWZpY2F0ZWQgcGFzc2VkIHRocm91Z2ggdGhl
IG1pZ3JhdGUtc2V2LXNldC1pbmZvIHdpbGwgYmUgdmFsaWRhdGVkDQorYmVmb3JlIGNyZWF0aW5n
IHRoZSBlbmNyeXB0aW9uIGNvbnRleHQuIFRoZSBTRU5EX1VQREFURV9EQVRBIGlzIGNhbGxlZA0K
K3RvIGVuY3J5cHQgdGhlIGd1ZXN0IHByaXZhdGUgcGFnZXMuIEFmdGVyIHRoZSBtaWdyYXRpb24g
aXMgY29tcGxldGVkIHRoZQ0KK1NFTkRfRklOSVNIIGlzIGNhbGxlZCB0byBkZXN0cm95IHRoZSBl
bmNyeXB0aW9uIGNvbnRleHQgYW5kIG1ha2UgdGhlIFZNDQorbm9uIHJ1bm5hYmxlIHRvIHByb3Rl
Y3QgaXQgYWdhaW5zdCB0aGUgY2xvbmluZy4NCisNCitPbiB0YXJnZXQgaHlwZXZpc29yLCB0aGUg
UkVDRUlWRV9TVEFSVCBpcyBjYWxsZWQgZmlyc3QgdG8gY3JlYXRlIGFuDQoraW5jb21pbmcgZW5j
cnlwdGlvbiBjb250ZXh0LiBUaGUgUkVDRUlWRV9VUERBVEVfREFUQSBpcyBjYWxsZWQgdG8gY29w
eQ0KK3RoZSByZWNlaXZlZCBlbmNyeXB0ZWQgcGFnZSBpbnRvIGd1ZXN0IG1lbW9yeS4gQWZ0ZXIg
bWlncmF0aW9uIG9mDQorcGFnZXMgaXMgY29tcGxldGVkLCBSRUNFSVZFX0ZJTklTSCBpcyBjYWxs
ZWQgdG8gbWFrZSB0aGUgVk0gcnVubmFibGUuDQorDQorRm9yIG1vcmUgaW5mb3JtYXRpb24gYWJv
dXQgdGhlIG1pZ3JhdGlvbiBzZWUgU0VWIEFQSSBBcHBlbmRpeCBBDQorVXNhZ2UgZmxvdyAoTGl2
ZSBtaWdyYXRpb24gc2VjdGlvbikuDQogDQogUmVmZXJlbmNlcw0KIC0tLS0tLS0tLS0tLS0tLS0t
DQotLSANCjIuMTcuMQ0KDQo=
