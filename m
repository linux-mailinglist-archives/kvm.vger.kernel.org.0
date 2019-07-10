Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30D5564D4D
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 22:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbfGJUNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 16:13:15 -0400
Received: from mail-eopbgr820080.outbound.protection.outlook.com ([40.107.82.80]:23808
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726111AbfGJUNO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 16:13:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=plL3le6tAmgV5A2FAz3cDzkWHLZs1gdvonOOpAa2x/g=;
 b=iu5aa2/PerGVqBg7U1cGzzOWkCp910iK4v8MDXfjn5wySXolPmOC6C+x85OjH4aQfzIpwkdQSlqH61M7RE1rClEwS3rpQawBB0e7T/64CsAXMuysCOEvOKQ60Ux+3x17NGluqSQ6SaQaqUPRsC+LkExfF7fJDZTrZsQYDJPSMIg=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB2988.namprd12.prod.outlook.com (20.178.29.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Wed, 10 Jul 2019 20:12:59 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::bc1a:a30d:9da2:1cdd]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::bc1a:a30d:9da2:1cdd%6]) with mapi id 15.20.2073.008; Wed, 10 Jul 2019
 20:12:59 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: [PATCH v3 00/11] Add AMD SEV guest live migration support
Thread-Topic: [PATCH v3 00/11] Add AMD SEV guest live migration support
Thread-Index: AQHVN1ve9r51ARqErUyGGRuzHzYveQ==
Date:   Wed, 10 Jul 2019 20:12:59 +0000
Message-ID: <20190710201244.25195-1-brijesh.singh@amd.com>
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
x-ms-office365-filtering-correlation-id: 2baae018-ccd7-4e4a-a154-08d705730120
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2988;
x-ms-traffictypediagnostic: DM6PR12MB2988:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <DM6PR12MB2988B78140B5E92DBB117197E5F00@DM6PR12MB2988.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(199004)(189003)(1730700003)(81156014)(81166006)(478600001)(8676002)(486006)(7736002)(6116002)(476003)(2616005)(305945005)(71190400001)(71200400001)(966005)(3846002)(26005)(64756008)(66946007)(66556008)(66476007)(66446008)(66066001)(186003)(102836004)(14454004)(386003)(6506007)(36756003)(5660300002)(2501003)(52116002)(6916009)(1076003)(99286004)(86362001)(6306002)(68736007)(6436002)(2906002)(25786009)(6486002)(50226002)(4326008)(5640700003)(316002)(256004)(6512007)(14444005)(53936002)(8936002)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2988;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: S2tVxwlQgwgZFaNBJKx/vpCHVg9UGlMPtF4ie4wof8CbncVc5QowjMBW4wcrg1OvCia+aEQXtH7+KkG8fkPaM6r7FuEmuysjAKfYRdMrZNufe8i4xd0Z16jGOGE26BU26VIiYwRM+cH3QBgcEezN9TQ5OsSu4Lm4yefrWWTrTO2I5FEIPehrLuE3B/9qKFwC1+zvU5Wm4W+6lXEeu6v8ZQhYOdrv8Ox6r2YOyZeBW8k32goARrvTYOyy+bDLWSKKT6lVOfozqB7HcX3kGRoTTzuKuR1GexGPqVZFe//XNz7BDl0jVa/pLGjJFMtUQVrFRzcArrGnWiqLqZzVtguZyY+IZ0Jmhv7wIpNhJGXIotib4VFPFiScJ2poN7Rja0Q3Cebg0CjgvrsCHpxsKab8DL2KUqTrxFvJeRaB7N8GvJg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD0AEE9B3CA35944B1519FD5B4E55592@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2baae018-ccd7-4e4a-a154-08d705730120
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 20:12:59.6087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2988
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
bGl0aWVzL2ZlYXR1cmUgYml0cyB0byBjaGVjayB0aGlzPw0KDQpUaGUgY29tcGxldGUgdHJlZSB3
aXRoIHBhdGNoIGlzIGF2YWlsYWJsZSBhdDoNCmh0dHBzOi8vZ2l0aHViLmNvbS9jb2RvbWFuaWEv
a3ZtL3RyZWUvc2V2LW1pZ3JhdGlvbi12Mw0KDQpDaGFuZ2VzIHNpbmNlIHYyOg0KIC0gcmVzZXQg
dGhlIHBhZ2UgZW5jcnlwdGlvbiBiaXRtYXAgb24gdmNwdSByZWJvb3QNCg0KQ2hhbmdlcyBzaW5j
ZSB2MToNCiAtIEFkZCBzdXBwb3J0IHRvIHNoYXJlIHRoZSBwYWdlIGVuY3J5cHRpb24gYmV0d2Vl
biB0aGUgc291cmNlIGFuZCB0YXJnZXQNCiAgIG1hY2hpbmUuDQogLSBGaXggcmV2aWV3IGZlZWRi
YWNrcyBmcm9tIFRvbSBMZW5kYWNreS4NCiAtIEFkZCBjaGVjayB0byBsaW1pdCB0aGUgc2Vzc2lv
biBibG9iIGxlbmd0aC4NCiAtIFVwZGF0ZSBLVk1fR0VUX1BBR0VfRU5DX0JJVE1BUCBpY290bCB0
byB1c2UgdGhlIGJhc2VfZ2ZuIGluc3RlYWQgb2YNCiAgIHRoZSBtZW1vcnkgc2xvdCB3aGVuIHF1
ZXJ5aW5nIHRoZSBiaXRtYXAuDQoNCkJyaWplc2ggU2luZ2ggKDExKToNCiAgS1ZNOiBTVk06IEFk
ZCBLVk1fU0VWIFNFTkRfU1RBUlQgY29tbWFuZA0KICBLVk06IFNWTTogQWRkIEtWTV9TRU5EX1VQ
REFURV9EQVRBIGNvbW1hbmQNCiAgS1ZNOiBTVk06IEFkZCBLVk1fU0VWX1NFTkRfRklOSVNIIGNv
bW1hbmQNCiAgS1ZNOiBTVk06IEFkZCBzdXBwb3J0IGZvciBLVk1fU0VWX1JFQ0VJVkVfU1RBUlQg
Y29tbWFuZA0KICBLVk06IFNWTTogQWRkIEtWTV9TRVZfUkVDRUlWRV9VUERBVEVfREFUQSBjb21t
YW5kDQogIEtWTTogU1ZNOiBBZGQgS1ZNX1NFVl9SRUNFSVZFX0ZJTklTSCBjb21tYW5kDQogIEtW
TTogeDg2OiBBZGQgQU1EIFNFViBzcGVjaWZpYyBIeXBlcmNhbGwzDQogIEtWTTogWDg2OiBJbnRy
b2R1Y2UgS1ZNX0hDX1BBR0VfRU5DX1NUQVRVUyBoeXBlcmNhbGwNCiAgS1ZNOiB4ODY6IEludHJv
ZHVjZSBLVk1fR0VUX1BBR0VfRU5DX0JJVE1BUCBpb2N0bA0KICBtbTogeDg2OiBJbnZva2UgaHlw
ZXJjYWxsIHdoZW4gcGFnZSBlbmNyeXB0aW9uIHN0YXR1cyBpcyBjaGFuZ2VkDQogIEtWTTogeDg2
OiBJbnRyb2R1Y2UgS1ZNX1NFVF9QQUdFX0VOQ19CSVRNQVAgaW9jdGwNCg0KIC4uLi92aXJ0dWFs
L2t2bS9hbWQtbWVtb3J5LWVuY3J5cHRpb24ucnN0ICAgICB8IDEyMCArKysrDQogRG9jdW1lbnRh
dGlvbi92aXJ0dWFsL2t2bS9hcGkudHh0ICAgICAgICAgICAgIHwgIDQ4ICsrDQogRG9jdW1lbnRh
dGlvbi92aXJ0dWFsL2t2bS9oeXBlcmNhbGxzLnR4dCAgICAgIHwgIDE0ICsNCiBhcmNoL3g4Ni9p
bmNsdWRlL2FzbS9rdm1faG9zdC5oICAgICAgICAgICAgICAgfCAgIDQgKw0KIGFyY2gveDg2L2lu
Y2x1ZGUvYXNtL2t2bV9wYXJhLmggICAgICAgICAgICAgICB8ICAxMiArDQogYXJjaC94ODYvaW5j
bHVkZS9hc20vbWVtX2VuY3J5cHQuaCAgICAgICAgICAgIHwgICAzICsNCiBhcmNoL3g4Ni9rdm0v
c3ZtLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCA1ODAgKysrKysrKysrKysrKysrKyst
DQogYXJjaC94ODYva3ZtL3ZteC92bXguYyAgICAgICAgICAgICAgICAgICAgICAgIHwgICAxICsN
CiBhcmNoL3g4Ni9rdm0veDg2LmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMjkgKw0K
IGFyY2gveDg2L21tL21lbV9lbmNyeXB0LmMgICAgICAgICAgICAgICAgICAgICB8ICA0NSArLQ0K
IGFyY2gveDg2L21tL3BhZ2VhdHRyLmMgICAgICAgICAgICAgICAgICAgICAgICB8ICAxNSArDQog
aW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oICAgICAgICAgICAgICAgICAgICAgIHwgIDUyICsrDQog
aW5jbHVkZS91YXBpL2xpbnV4L2t2bV9wYXJhLmggICAgICAgICAgICAgICAgIHwgICAxICsNCiAx
MyBmaWxlcyBjaGFuZ2VkLCA5MTkgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCg0KLS0g
DQoyLjE3LjENCg0K
