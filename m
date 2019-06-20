Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B6D4D3EA
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 18:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732190AbfFTQiw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 12:38:52 -0400
Received: from mail-eopbgr770049.outbound.protection.outlook.com ([40.107.77.49]:36184
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732143AbfFTQiw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 12:38:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3TZs3VI+qUHHfH/aANMBDcYc2qnIppUMhF4OcQXhCDE=;
 b=pzWJWpKxta7uBNAtub1nQ3QeisDSwsiCM9YJUAzWSLDi6DW7tncct2Gd5QAVzO4qoNvjWmM8oaJD2z29etLsD0HiapGNBfA16yB7ur1I7aMEiU9uuBX827sQsjmpDll0cHTdQZfrADLLiF0u0XOD2seEV8PDnqdz5sQWzVEXBNI=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3401.namprd12.prod.outlook.com (20.178.198.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 20 Jun 2019 16:38:49 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2%6]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 16:38:49 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: [RFC PATCH v2 00/11] Add AMD SEV guest live migration support
Thread-Topic: [RFC PATCH v2 00/11] Add AMD SEV guest live migration support
Thread-Index: AQHVJ4ajMp5z1g+GPEmk1ZhGsIPh4g==
Date:   Thu, 20 Jun 2019 16:38:49 +0000
Message-ID: <20190620163832.5451-1-brijesh.singh@amd.com>
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
x-ms-office365-filtering-correlation-id: 90b2c70b-260e-425e-c14f-08d6f59dc563
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3401;
x-ms-traffictypediagnostic: DM6PR12MB3401:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <DM6PR12MB34011DE936AD1430F5E8CE95E5E40@DM6PR12MB3401.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(39860400002)(396003)(136003)(199004)(189003)(305945005)(6116002)(36756003)(478600001)(25786009)(966005)(50226002)(14454004)(8936002)(4326008)(1730700003)(8676002)(86362001)(68736007)(5660300002)(316002)(81166006)(1076003)(81156014)(256004)(14444005)(66476007)(66556008)(53936002)(99286004)(2501003)(6916009)(71190400001)(7736002)(186003)(73956011)(71200400001)(66946007)(66446008)(26005)(64756008)(2906002)(2351001)(3846002)(66066001)(6436002)(102836004)(5640700003)(6486002)(476003)(2616005)(6306002)(386003)(6506007)(6512007)(52116002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3401;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: a+mfB0Tl9/RBmZYUQkZRDYiKd49GoJc8KIlt2siowJDaS4dGpvoU+m8KilWghOjupt97Ea3hWmUAidJclN2pcuzHGfG4THXYGvMdX7DHCgE9zjiInHNhBDQ1qVoHkwZYFGrc80wj3ppPMtvik676o7+Rj0PwAYywoSatFVejXRWVwr9ZodfGae0vq1+PPgI7IRgaU3DDSDOzZih4q6wStQ+NElgS8nKj1oKjUdZ5nEBPx2ow9i9pD7in0fkfnqB1U4BHnbFCWLTUGrI9eaoEZHYve3fVXVDJNDTWcNF22DKvbBVZMvX8aAwHMhj6P7OfzlzRSqwgGJcCLjXW+FUwuKcITt8fUUMPhqtY3c09c+E1XWgtg8ejvfwhkvYGpIkAiOpxqedTTfsncyo/A2pDvTfySmnLCqR+S4n84DtkT9A=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C30244496FC4834FB80C161456FCC9A2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90b2c70b-260e-425e-c14f-08d6f59dc563
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 16:38:49.5580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3401
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhlIHNlcmllcyBhZGQgc3VwcG9ydCBmb3IgQU1EIFNFViBndWVzdCBsaXZlIG1pZ3JhdGlvbiBj
b21tYW5kcy4gVG8gcHJvdGVjdCB0aGUNCmNvbmZpZGVudGlhbGl0eSBvZiBhbiBTRVYgcHJvdGVj
dGVkIGd1ZXN0IG1lbW9yeSB3aGlsZSBpbiB0cmFuc2l0IHdlIG5lZWQgdG8NCnVzZSB0aGUgU0VW
IGNvbW1hbmRzIGRlZmluZWQgaW4gU0VWIEFQSSBzcGVjIFsxXS4NCg0KU0VWIGd1ZXN0IFZNcyBo
YXZlIHRoZSBjb25jZXB0IG9mIHByaXZhdGUgYW5kIHNoYXJlZCBtZW1vcnkuIFByaXZhdGUgbWVt
b3J5DQppcyBlbmNyeXB0ZWQgd2l0aCB0aGUgZ3Vlc3Qtc3BlY2lmaWMga2V5LCB3aGlsZSBzaGFy
ZWQgbWVtb3J5IG1heSBiZSBlbmNyeXB0ZWQNCndpdGggaHlwZXJ2aXNvciBrZXkuIFRoZSBjb21t
YW5kcyBwcm92aWRlZCBieSB0aGUgU0VWIEZXIGFyZSBtZWFudCB0byBiZSB1c2VkDQpmb3IgdGhl
IHByaXZhdGUgbWVtb3J5IG9ubHkuIFRoZSBwYXRjaCBzZXJpZXMgaW50cm9kdWNlcyBhIG5ldyBo
eXBlcmNhbGwuDQpUaGUgZ3Vlc3QgT1MgY2FuIHVzZSB0aGlzIGh5cGVyY2FsbCB0byBub3RpZnkg
dGhlIHBhZ2UgZW5jcnlwdGlvbiBzdGF0dXMuDQpJZiB0aGUgcGFnZSBpcyBlbmNyeXB0ZWQgd2l0
aCBndWVzdCBzcGVjaWZpYy1rZXkgdGhlbiB3ZSB1c2UgU0VWIGNvbW1hbmQgZHVyaW5nDQp0aGUg
bWlncmF0aW9uLiBJZiBwYWdlIGlzIG5vdCBlbmNyeXB0ZWQgdGhlbiBmYWxsYmFjayB0byBkZWZh
dWx0Lg0KDQpUaGUgcGF0Y2ggYWRkcyBuZXcgaW9jdGxzIEtWTV97U0VULEdFVH1fUEFHRV9FTkNf
QklUTUFQLiBUaGUgaW9jdGwgY2FuIGJlIHVzZWQNCmJ5IHRoZSBxZW11IHRvIGdldCB0aGUgcGFn
ZSBlbmNyeXB0ZWQgYml0bWFwLiBRZW11IGNhbiBjb25zdWx0IHRoaXMgYml0bWFwDQpkdXJpbmcg
dGhlIG1pZ3JhdGlvbiB0byBrbm93IHdoZXRoZXIgdGhlIHBhZ2UgaXMgZW5jcnlwdGVkLg0KDQpb
MV0gaHR0cHM6Ly9kZXZlbG9wZXIuYW1kLmNvbS93cC1jb250ZW50L3Jlc291cmNlcy81NTc2Ni5Q
REYNCg0KV2hpbGUgaW1wbGVtZW50aW5nIHRoZSBtaWdyYXRpb24gSSBzdHVtYmxlZCBvbiB0aGUg
Zm9sbG93IHF1ZXN0aW9uOg0KDQotIFNpbmNlIHRoZXJlIGlzIGEgZ3Vlc3QgT1MgY2hhbmdlcyBy
ZXF1aXJlZCB0byBzdXBwb3J0IHRoZSBtaWdyYXRpb24sDQogIHNvIGhvdyBkbyB3ZSBrbm93IHdo
ZXRoZXIgZ3Vlc3QgT1MgaXMgdXBkYXRlZD8gU2hvdWxkIHdlIGV4dGVuZCBLVk0NCiAgY2FwYWJp
bGl0aWVzL2ZlYXR1cmUgYml0cyB0byBjaGVjayB0aGlzPw0KDQpUT0RPOg0KIC0gcmVzZXQgdGhl
IGJpdG1hcCBvbiBndWVzdCByZWJvb3QuDQoNClRoZSBjb21wbGV0ZSB0cmVlIHdpdGggcGF0Y2gg
aXMgYXZhaWxhYmxlIGF0Og0KaHR0cHM6Ly9naXRodWIuY29tL2NvZG9tYW5pYS9rdm0vdHJlZS9z
ZXYtbWlncmF0aW9uLXJmYy12Mg0KDQpDaGFuZ2VzIHNpbmNlIHYxOg0KIC0gQWRkIHN1cHBvcnQg
dG8gc2hhcmUgdGhlIHBhZ2UgZW5jcnlwdGlvbiBiZXR3ZWVuIHRoZSBzb3VyY2UgYW5kIHRhcmdl
dA0KICAgbWFjaGluZS4NCiAtIEZpeCByZXZpZXcgZmVlZGJhY2tzIGZyb20gVG9tIExlbmRhY2t5
Lg0KIC0gQWRkIGNoZWNrIHRvIGxpbWl0IHRoZSBzZXNzaW9uIGJsb2IgbGVuZ3RoLg0KIC0gVXBk
YXRlIEtWTV9HRVRfUEFHRV9FTkNfQklUTUFQIGljb3RsIHRvIHVzZSB0aGUgYmFzZV9nZm4gaW5z
dGVhZCBvZg0KICAgdGhlIG1lbW9yeSBzbG90IHdoZW4gcXVlcnlpbmcgdGhlIGJpdG1hcC4NCg0K
QnJpamVzaCBTaW5naCAoMTEpOg0KICBLVk06IFNWTTogQWRkIEtWTV9TRVYgU0VORF9TVEFSVCBj
b21tYW5kDQogIEtWTTogU1ZNOiBBZGQgS1ZNX1NFTkRfVVBEQVRFX0RBVEEgY29tbWFuZA0KICBL
Vk06IFNWTTogQWRkIEtWTV9TRVZfU0VORF9GSU5JU0ggY29tbWFuZA0KICBLVk06IFNWTTogQWRk
IHN1cHBvcnQgZm9yIEtWTV9TRVZfUkVDRUlWRV9TVEFSVCBjb21tYW5kDQogIEtWTTogU1ZNOiBB
ZGQgS1ZNX1NFVl9SRUNFSVZFX1VQREFURV9EQVRBIGNvbW1hbmQNCiAgS1ZNOiBTVk06IEFkZCBL
Vk1fU0VWX1JFQ0VJVkVfRklOSVNIIGNvbW1hbmQNCiAgS1ZNOiB4ODY6IEFkZCBBTUQgU0VWIHNw
ZWNpZmljIEh5cGVyY2FsbDMNCiAgS1ZNOiBYODY6IEludHJvZHVjZSBLVk1fSENfUEFHRV9FTkNf
U1RBVFVTIGh5cGVyY2FsbA0KICBLVk06IHg4NjogSW50cm9kdWNlIEtWTV9HRVRfUEFHRV9FTkNf
QklUTUFQIGlvY3RsDQogIG1tOiB4ODY6IEludm9rZSBoeXBlcmNhbGwgd2hlbiBwYWdlIGVuY3J5
cHRpb24gc3RhdHVzIGlzIGNoYW5nZWQNCiAgS1ZNOiB4ODY6IEludHJvZHVjZSBLVk1fU0VUX1BB
R0VfRU5DX0JJVE1BUCBpb2N0bA0KDQogLi4uL3ZpcnR1YWwva3ZtL2FtZC1tZW1vcnktZW5jcnlw
dGlvbi5yc3QgICAgIHwgMTIwICsrKysNCiBEb2N1bWVudGF0aW9uL3ZpcnR1YWwva3ZtL2h5cGVy
Y2FsbHMudHh0ICAgICAgfCAgMTQgKw0KIGFyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0Lmgg
ICAgICAgICAgICAgICB8ICAgNCArDQogYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX3BhcmEuaCAg
ICAgICAgICAgICAgIHwgIDEyICsNCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9tZW1fZW5jcnlwdC5o
ICAgICAgICAgICAgfCAgIDMgKw0KIGFyY2gveDg2L2t2bS9zdm0uYyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB8IDU3MyArKysrKysrKysrKysrKysrKy0NCiBhcmNoL3g4Ni9rdm0vdm14L3Zt
eC5jICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDEgKw0KIGFyY2gveDg2L2t2bS94ODYuYyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAyOSArDQogYXJjaC94ODYvbW0vbWVtX2VuY3J5
cHQuYyAgICAgICAgICAgICAgICAgICAgIHwgIDQ1ICstDQogYXJjaC94ODYvbW0vcGFnZWF0dHIu
YyAgICAgICAgICAgICAgICAgICAgICAgIHwgIDE1ICsNCiBpbmNsdWRlL3VhcGkvbGludXgva3Zt
LmggICAgICAgICAgICAgICAgICAgICAgfCAgNTIgKysNCiBpbmNsdWRlL3VhcGkvbGludXgva3Zt
X3BhcmEuaCAgICAgICAgICAgICAgICAgfCAgIDEgKw0KIDEyIGZpbGVzIGNoYW5nZWQsIDg2NCBp
bnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMTcuMQ0KDQo=
