Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E09084D608
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 20:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfFTSDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 14:03:40 -0400
Received: from mail-eopbgr720085.outbound.protection.outlook.com ([40.107.72.85]:31712
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727315AbfFTSDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 14:03:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2yaW5b4zxJ8SbYaNWmSsPSjOVNESijemaqL82b30758=;
 b=eIM4l3FCIDRAIo6GdlIxu88tzRoLuW18G3A2J375wXQwf/JdJY95xqoMK2Eyk0HZYOdIQOyyIMQZjgNxElqm1GoU9MN4ej8yPjlguYVCwheMMU8RniqpTToMmH6PSWEj98Yc/qwgbCvmSfZqhIsc6L83EAIoJ+p+azo6XjT+xZI=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3260.namprd12.prod.outlook.com (20.179.105.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Thu, 20 Jun 2019 18:03:24 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2%6]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 18:03:24 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: [RFC PATCH v1 12/12] target/i386: sev: remove migration blocker
Thread-Topic: [RFC PATCH v1 12/12] target/i386: sev: remove migration blocker
Thread-Index: AQHVJ5Jzb+1ffDZU30OB/jyG/TiftA==
Date:   Thu, 20 Jun 2019 18:03:23 +0000
Message-ID: <20190620180247.8825-13-brijesh.singh@amd.com>
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
x-ms-office365-filtering-correlation-id: 9a6f0ba3-44a4-49b0-98bf-08d6f5a99591
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR12MB3260;
x-ms-traffictypediagnostic: DM6PR12MB3260:
x-microsoft-antispam-prvs: <DM6PR12MB326075431AC57E6E2C9DB3F8E5E40@DM6PR12MB3260.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:124;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(376002)(136003)(39860400002)(346002)(199004)(189003)(2351001)(53936002)(486006)(2616005)(11346002)(81156014)(8676002)(6436002)(446003)(5640700003)(50226002)(6512007)(476003)(102836004)(6916009)(99286004)(2501003)(6486002)(76176011)(8936002)(52116002)(81166006)(316002)(186003)(6506007)(26005)(478600001)(256004)(3846002)(2906002)(386003)(66066001)(14454004)(54906003)(6116002)(305945005)(25786009)(1076003)(66946007)(66556008)(73956011)(64756008)(66446008)(71190400001)(71200400001)(4744005)(68736007)(36756003)(66476007)(5660300002)(7736002)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3260;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +oOETgPc7nqEwSYa2vNeVUTCNrQ8TpILwGI0Qz9ibuZjG43VPZzwLOqmc+MKnIxcumgDaoGy6a5sLaOthxCkytTVbHzcKA7ymLKZsfejdYroiAuVwV+YqlRqmaPSX2F7M2n69iPIeV05To5ex6vw/e2rrKh6DOuYqNek0jS/YARObLoM2GJ2lYSnsYAJCxJcACZTapK8u3iaNQUmv/6iUiMfPjwg55vhgtU6q8u4ufsiyBwh3ejKP4p/qF514JwAhjNqtp4ItpFVjbrpvMJy20Pyadr2UdYSUuitHCIT6qmoxhW+1Zha39h29tLiKqwZOE25d+y6y7tsrcAR5265vaes1DsRQwtVKw1CXrm6mCzqkFMh12/sahjc4e0jQnI3v9Z+C2XEm5nURppw1R2i8J9mAWenqiWt/mmglPvwZ3g=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a6f0ba3-44a4-49b0-98bf-08d6f5a99591
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 18:03:23.1196
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
DQogdGFyZ2V0L2kzODYvc2V2LmMgfCAxMiAtLS0tLS0tLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwg
MTIgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS90YXJnZXQvaTM4Ni9zZXYuYyBiL3Rhcmdl
dC9pMzg2L3Nldi5jDQppbmRleCBkYzFlOTc0ZDkzLi4wOTVlZjRjNzI5IDEwMDY0NA0KLS0tIGEv
dGFyZ2V0L2kzODYvc2V2LmMNCisrKyBiL3RhcmdldC9pMzg2L3Nldi5jDQpAQCAtMzQsNyArMzQs
NiBAQA0KICNkZWZpbmUgREVGQVVMVF9TRVZfREVWSUNFICAgICAgIi9kZXYvc2V2Ig0KIA0KIHN0
YXRpYyBTRVZTdGF0ZSAqc2V2X3N0YXRlOw0KLXN0YXRpYyBFcnJvciAqc2V2X21pZ19ibG9ja2Vy
Ow0KIA0KIHN0YXRpYyBjb25zdCBjaGFyICpjb25zdCBzZXZfZndfZXJybGlzdFtdID0gew0KICAg
ICAiIiwNCkBAIC02ODUsNyArNjg0LDYgQEAgc3RhdGljIHZvaWQNCiBzZXZfbGF1bmNoX2Zpbmlz
aChTRVZTdGF0ZSAqcykNCiB7DQogICAgIGludCByZXQsIGVycm9yOw0KLSAgICBFcnJvciAqbG9j
YWxfZXJyID0gTlVMTDsNCiANCiAgICAgdHJhY2Vfa3ZtX3Nldl9sYXVuY2hfZmluaXNoKCk7DQog
ICAgIHJldCA9IHNldl9pb2N0bChzZXZfc3RhdGUtPnNldl9mZCwgS1ZNX1NFVl9MQVVOQ0hfRklO
SVNILCAwLCAmZXJyb3IpOw0KQEAgLTY5NiwxNiArNjk0LDYgQEAgc2V2X2xhdW5jaF9maW5pc2go
U0VWU3RhdGUgKnMpDQogICAgIH0NCiANCiAgICAgc2V2X3NldF9ndWVzdF9zdGF0ZShTRVZfU1RB
VEVfUlVOTklORyk7DQotDQotICAgIC8qIGFkZCBtaWdyYXRpb24gYmxvY2tlciAqLw0KLSAgICBl
cnJvcl9zZXRnKCZzZXZfbWlnX2Jsb2NrZXIsDQotICAgICAgICAgICAgICAgIlNFVjogTWlncmF0
aW9uIGlzIG5vdCBpbXBsZW1lbnRlZCIpOw0KLSAgICByZXQgPSBtaWdyYXRlX2FkZF9ibG9ja2Vy
KHNldl9taWdfYmxvY2tlciwgJmxvY2FsX2Vycik7DQotICAgIGlmIChsb2NhbF9lcnIpIHsNCi0g
ICAgICAgIGVycm9yX3JlcG9ydF9lcnIobG9jYWxfZXJyKTsNCi0gICAgICAgIGVycm9yX2ZyZWUo
c2V2X21pZ19ibG9ja2VyKTsNCi0gICAgICAgIGV4aXQoMSk7DQotICAgIH0NCiB9DQogDQogc3Rh
dGljIGludA0KLS0gDQoyLjE3LjENCg0K
