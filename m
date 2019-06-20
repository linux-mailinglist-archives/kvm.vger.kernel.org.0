Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 619614D8DE
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 20:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbfFTSDO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 14:03:14 -0400
Received: from mail-eopbgr790089.outbound.protection.outlook.com ([40.107.79.89]:5088
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727580AbfFTSDK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 14:03:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DzocP//o7699FVxoVnJofkPgyVxyN2uSjn+exm7wS2A=;
 b=Pk9fUmDO+h/gA4Y8jJXpgLA+wrWr5+BHiytY9SkmP5wkPCg5YgVE/L/eqdqE7WkWdlFGHzpgB8Yn+vkWK15GvTGSAmDCLRFn0JVz90jvnh1YP3886mUQSmq8Icjb3dbT13HimBHR9m9sJzXos0ulnAnm1rrd3obcV/nhEwera/A=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB2842.namprd12.prod.outlook.com (20.176.116.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Thu, 20 Jun 2019 18:03:06 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2%6]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 18:03:06 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: [RFC PATCH v1 01/12] linux-headers: update kernel header to include
 SEV migration commands
Thread-Topic: [RFC PATCH v1 01/12] linux-headers: update kernel header to
 include SEV migration commands
Thread-Index: AQHVJ5JpOB/UE5vg006C7ygs1/HuTQ==
Date:   Thu, 20 Jun 2019 18:03:06 +0000
Message-ID: <20190620180247.8825-2-brijesh.singh@amd.com>
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
x-ms-office365-filtering-correlation-id: 6357664e-a177-4f7c-9115-08d6f5a98b27
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2842;
x-ms-traffictypediagnostic: DM6PR12MB2842:
x-microsoft-antispam-prvs: <DM6PR12MB2842A3525EF503C77C8A4201E5E40@DM6PR12MB2842.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:21;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(396003)(366004)(346002)(39860400002)(189003)(199004)(81166006)(81156014)(386003)(86362001)(256004)(486006)(476003)(50226002)(186003)(2616005)(4326008)(8936002)(25786009)(68736007)(14454004)(5660300002)(26005)(11346002)(66066001)(64756008)(5640700003)(73956011)(3846002)(76176011)(66556008)(6512007)(66476007)(53936002)(66946007)(2351001)(446003)(6486002)(66446008)(478600001)(99286004)(71200400001)(305945005)(14444005)(7736002)(6506007)(102836004)(71190400001)(52116002)(6436002)(8676002)(36756003)(54906003)(316002)(2501003)(6916009)(2906002)(1076003)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2842;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: g6w1PGWkYOWqQqqfwPAkT5Uw6JooKiArW9yltYevWbCwdzHW4+4aCWhB69njVBsMZSnzFjRAyLsvS45rCu7d7uc1LWHcSle0QOkeEPHTuyncFhNahUoK7QnqM4Tq0TRcCqTmntI5w+WA5KA9HEBmUF6xoYQ9y5rwysEmKGpiZYCM5e7MgcW5o1Ur0vK7pwM/9Nbd27cfl6ewcqGUpCwSatJK3GDL0RvTnIx4sMrzDW6DjJxuOctTtF8EyfvR9n+LiLpD3iL/AhOnNkL+FsT+sivBoUHTJJq1XbqTb0vIoyYYlwgKD4B70K1RQdhFycDkqF2WR6MXUwCUXae82l2aSBYMEMyzcfkqtAwuWdZ0TNUIa8jKsrmLCaJbF+2LL3oeJPRU9F33KUDYOgxziuosFsAWVnyawxmPpgMDT35FUBo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6357664e-a177-4f7c-9115-08d6f5a98b27
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 18:03:06.4501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2842
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

U2lnbmVkLW9mZi1ieTogQnJpamVzaCBTaW5naCA8YnJpamVzaC5zaW5naEBhbWQuY29tPg0KLS0t
DQogbGludXgtaGVhZGVycy9saW51eC9rdm0uaCB8IDUzICsrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCA1MyBpbnNlcnRpb25zKCspDQoNCmRp
ZmYgLS1naXQgYS9saW51eC1oZWFkZXJzL2xpbnV4L2t2bS5oIGIvbGludXgtaGVhZGVycy9saW51
eC9rdm0uaA0KaW5kZXggYzg0MjNlNzYwYy4uMmJkZDZhOTA4ZSAxMDA2NDQNCi0tLSBhL2xpbnV4
LWhlYWRlcnMvbGludXgva3ZtLmgNCisrKyBiL2xpbnV4LWhlYWRlcnMvbGludXgva3ZtLmgNCkBA
IC00OTIsNiArNDkyLDE2IEBAIHN0cnVjdCBrdm1fZGlydHlfbG9nIHsNCiAJfTsNCiB9Ow0KIA0K
Ky8qIGZvciBLVk1fR0VUX1BBR0VfRU5DX0JJVE1BUCAqLw0KK3N0cnVjdCBrdm1fcGFnZV9lbmNf
Yml0bWFwIHsNCisgICAgICAgIF9fdTY0IHN0YXJ0Ow0KKyAgICAgICAgX191NjQgbnVtX3BhZ2Vz
Ow0KKwl1bmlvbiB7DQorCQl2b2lkICplbmNfYml0bWFwOyAvKiBvbmUgYml0IHBlciBwYWdlICov
DQorCQlfX3U2NCBwYWRkaW5nMjsNCisJfTsNCit9Ow0KKw0KIC8qIGZvciBLVk1fQ0xFQVJfRElS
VFlfTE9HICovDQogc3RydWN0IGt2bV9jbGVhcl9kaXJ0eV9sb2cgew0KIAlfX3UzMiBzbG90Ow0K
QEAgLTE0NTEsNiArMTQ2MSw5IEBAIHN0cnVjdCBrdm1fZW5jX3JlZ2lvbiB7DQogLyogQXZhaWxh
YmxlIHdpdGggS1ZNX0NBUF9BUk1fU1ZFICovDQogI2RlZmluZSBLVk1fQVJNX1ZDUFVfRklOQUxJ
WkUJICBfSU9XKEtWTUlPLCAgMHhjMiwgaW50KQ0KIA0KKyNkZWZpbmUgS1ZNX0dFVF9QQUdFX0VO
Q19CSVRNQVAgIAkgX0lPVyhLVk1JTywgMHhjMiwgc3RydWN0IGt2bV9wYWdlX2VuY19iaXRtYXAp
DQorI2RlZmluZSBLVk1fU0VUX1BBR0VfRU5DX0JJVE1BUCAgCSBfSU9XKEtWTUlPLCAweGMzLCBz
dHJ1Y3Qga3ZtX3BhZ2VfZW5jX2JpdG1hcCkNCisNCiAvKiBTZWN1cmUgRW5jcnlwdGVkIFZpcnR1
YWxpemF0aW9uIGNvbW1hbmQgKi8NCiBlbnVtIHNldl9jbWRfaWQgew0KIAkvKiBHdWVzdCBpbml0
aWFsaXphdGlvbiBjb21tYW5kcyAqLw0KQEAgLTE1MzEsNiArMTU0NCw0NiBAQCBzdHJ1Y3Qga3Zt
X3Nldl9kYmcgew0KIAlfX3UzMiBsZW47DQogfTsNCiANCitzdHJ1Y3Qga3ZtX3Nldl9zZW5kX3N0
YXJ0IHsNCisJX191MzIgcG9saWN5Ow0KKwlfX3U2NCBwZGhfY2VydF91YWRkcjsNCisJX191MzIg
cGRoX2NlcnRfbGVuOw0KKwlfX3U2NCBwbGF0X2NlcnRfdWFkZHI7DQorCV9fdTMyIHBsYXRfY2Vy
dF9sZW47DQorCV9fdTY0IGFtZF9jZXJ0X3VhZGRyOw0KKwlfX3UzMiBhbWRfY2VydF9sZW47DQor
CV9fdTY0IHNlc3Npb25fdWFkZHI7DQorCV9fdTMyIHNlc3Npb25fbGVuOw0KK307DQorDQorc3Ry
dWN0IGt2bV9zZXZfc2VuZF91cGRhdGVfZGF0YSB7DQorCV9fdTY0IGhkcl91YWRkcjsNCisJX191
MzIgaGRyX2xlbjsNCisJX191NjQgZ3Vlc3RfdWFkZHI7DQorCV9fdTMyIGd1ZXN0X2xlbjsNCisJ
X191NjQgdHJhbnNfdWFkZHI7DQorCV9fdTMyIHRyYW5zX2xlbjsNCit9Ow0KKw0KK3N0cnVjdCBr
dm1fc2V2X3JlY2VpdmVfc3RhcnQgew0KKwlfX3UzMiBoYW5kbGU7DQorCV9fdTMyIHBvbGljeTsN
CisJX191NjQgcGRoX3VhZGRyOw0KKwlfX3UzMiBwZGhfbGVuOw0KKwlfX3U2NCBzZXNzaW9uX3Vh
ZGRyOw0KKwlfX3UzMiBzZXNzaW9uX2xlbjsNCit9Ow0KKw0KK3N0cnVjdCBrdm1fc2V2X3JlY2Vp
dmVfdXBkYXRlX2RhdGEgew0KKwlfX3U2NCBoZHJfdWFkZHI7DQorCV9fdTMyIGhkcl9sZW47DQor
CV9fdTY0IGd1ZXN0X3VhZGRyOw0KKwlfX3UzMiBndWVzdF9sZW47DQorCV9fdTY0IHRyYW5zX3Vh
ZGRyOw0KKwlfX3UzMiB0cmFuc19sZW47DQorfTsNCisNCisNCiAjZGVmaW5lIEtWTV9ERVZfQVNT
SUdOX0VOQUJMRV9JT01NVQkoMSA8PCAwKQ0KICNkZWZpbmUgS1ZNX0RFVl9BU1NJR05fUENJXzJf
MwkJKDEgPDwgMSkNCiAjZGVmaW5lIEtWTV9ERVZfQVNTSUdOX01BU0tfSU5UWAkoMSA8PCAyKQ0K
LS0gDQoyLjE3LjENCg0K
