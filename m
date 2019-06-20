Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B40B4D3FD
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 18:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732350AbfFTQjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 12:39:46 -0400
Received: from mail-eopbgr770088.outbound.protection.outlook.com ([40.107.77.88]:38590
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732237AbfFTQjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 12:39:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J8lvkGX2ykNEVOFWNFs2TGHjPAVnovaCJ2xplC3hKJc=;
 b=h1Y1MfDMkdpku5p6ECJMWcs1SUH/rc+r2/8YlCDuasCRmfJwGxbhPdXQq8CPI9Epxko16ngDOOaIZHGpO8gbVnTRySStTck7GhN8hcqGhq09vEnDD3rIuk6TUDu/j8suK2vfBX/P9lDxlcVNaS5WHgeAuoxVRhZD/xYZSK8RHbw=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3914.namprd12.prod.outlook.com (10.255.174.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Thu, 20 Jun 2019 16:38:55 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::b9c1:b235:fff3:dba2%6]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 16:38:55 +0000
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
Subject: [RFC PATCH v2 06/11] KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
Thread-Topic: [RFC PATCH v2 06/11] KVM: SVM: Add KVM_SEV_RECEIVE_FINISH
 command
Thread-Index: AQHVJ4amTQKfLpY4dEetwxxvxhTsgQ==
Date:   Thu, 20 Jun 2019 16:38:55 +0000
Message-ID: <20190620163832.5451-7-brijesh.singh@amd.com>
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
x-ms-office365-filtering-correlation-id: c1e59c87-d28b-4e39-c730-08d6f59dc8db
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3914;
x-ms-traffictypediagnostic: DM6PR12MB3914:
x-microsoft-antispam-prvs: <DM6PR12MB3914151EAF957CC1E55799E0E5E40@DM6PR12MB3914.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(52116002)(54906003)(86362001)(305945005)(256004)(6916009)(71190400001)(2501003)(71200400001)(6116002)(2906002)(25786009)(6512007)(53936002)(66446008)(6506007)(5640700003)(386003)(7416002)(14444005)(2351001)(66476007)(66556008)(7736002)(486006)(5660300002)(11346002)(476003)(99286004)(446003)(73956011)(68736007)(8936002)(6436002)(66946007)(478600001)(64756008)(4326008)(6486002)(3846002)(36756003)(66066001)(1730700003)(14454004)(81166006)(1076003)(102836004)(66574012)(81156014)(50226002)(186003)(8676002)(26005)(316002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3914;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7vCgQL2IpV3NX7bCqUuTL3bnflD+C0Llg+gFzc5q3cwpLTnGHmAKmpz7QkAjnUoKCM/FG9xPrTONliefvnx3AKTmvd04Y5kT9VN5mTx0kFQI7Ef32JSQDKHj9cRCpfx/t54QsrlAlTCZs02+FDwzyYCBS/0ntB9KVweAaOg/Wn7YjHIn1poxDjA0J7arC0OGkKVNFGOpKqdS+ng6w95WYFXo3Svv5h8c8y9K1V8spl20EH6W0s7nC+yijSBt8qIFDTP+IGiXvO36zPoB+gq/WhX+gqhyPmZxg2Q/8YdkU+IvDh970nU7QQUmkX73dv7UG4vGuegK0xPLKR77XSW8Lrm3/sgPj+59UozOJHbpW2dUpG10UUBQqzjzzEjsWUrFWXsSYM4zOqbHybo7TXhCkMi6Ah8nPQ8VFLh9zuNIXwk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A112BB25AD332D41B2A2443648B569C7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1e59c87-d28b-4e39-c730-08d6f59dc8db
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 16:38:55.0809
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

VGhlIGNvbW1hbmQgZmluYWxpemUgdGhlIGd1ZXN0IHJlY2VpdmluZyBwcm9jZXNzIGFuZCBtYWtl
IHRoZSBTRVYgZ3Vlc3QNCnJlYWR5IGZvciB0aGUgZXhlY3V0aW9uLg0KDQpDYzogVGhvbWFzIEds
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
ZW50YXRpb24vdmlydHVhbC9rdm0vYW1kLW1lbW9yeS1lbmNyeXB0aW9uLnJzdA0KaW5kZXggNmNl
NGNlZGI4NGU0Li4wNGUxM2FlZmZkMmIgMTAwNjQ0DQotLS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnR1
YWwva3ZtL2FtZC1tZW1vcnktZW5jcnlwdGlvbi5yc3QNCisrKyBiL0RvY3VtZW50YXRpb24vdmly
dHVhbC9rdm0vYW1kLW1lbW9yeS1lbmNyeXB0aW9uLnJzdA0KQEAgLTM1MCw2ICszNTAsMTQgQEAg
UmV0dXJuczogMCBvbiBzdWNjZXNzLCAtbmVnYXRpdmUgb24gZXJyb3INCiAgICAgICAgICAgICAg
ICAgX191MzIgdHJhbnNfbGVuOw0KICAgICAgICAgfTsNCiANCisxNS4gS1ZNX1NFVl9SRUNFSVZF
X0ZJTklTSA0KKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKw0KK0FmdGVyIGNvbXBsZXRpb24g
b2YgdGhlIG1pZ3JhdGlvbiBmbG93LCB0aGUgS1ZNX1NFVl9SRUNFSVZFX0ZJTklTSCBjb21tYW5k
IGNhbiBiZQ0KK2lzc3VlZCBieSB0aGUgaHlwZXJ2aXNvciB0byBtYWtlIHRoZSBndWVzdCByZWFk
eSBmb3IgZXhlY3V0aW9uLg0KKw0KK1JldHVybnM6IDAgb24gc3VjY2VzcywgLW5lZ2F0aXZlIG9u
IGVycm9yDQorDQogUmVmZXJlbmNlcw0KID09PT09PT09PT0NCiANCmRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9rdm0vc3ZtLmMgYi9hcmNoL3g4Ni9rdm0vc3ZtLmMNCmluZGV4IDUxZThjMmJmMjhkYi4u
OTBlMzJlM2YyYThiIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva3ZtL3N2bS5jDQorKysgYi9hcmNo
L3g4Ni9rdm0vc3ZtLmMNCkBAIC03MzQwLDYgKzczNDAsMjYgQEAgc3RhdGljIGludCBzZXZfcmVj
ZWl2ZV91cGRhdGVfZGF0YShzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fc2V2X2NtZCAqYXJn
cCkNCiAJcmV0dXJuIHJldDsNCiB9DQogDQorc3RhdGljIGludCBzZXZfcmVjZWl2ZV9maW5pc2go
c3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX3Nldl9jbWQgKmFyZ3ApDQorew0KKwlzdHJ1Y3Qg
a3ZtX3Nldl9pbmZvICpzZXYgPSAmdG9fa3ZtX3N2bShrdm0pLT5zZXZfaW5mbzsNCisJc3RydWN0
IHNldl9kYXRhX3JlY2VpdmVfZmluaXNoICpkYXRhOw0KKwlpbnQgcmV0Ow0KKw0KKwlpZiAoIXNl
dl9ndWVzdChrdm0pKQ0KKwkJcmV0dXJuIC1FTk9UVFk7DQorDQorCWRhdGEgPSBremFsbG9jKHNp
emVvZigqZGF0YSksIEdGUF9LRVJORUwpOw0KKwlpZiAoIWRhdGEpDQorCQlyZXR1cm4gLUVOT01F
TTsNCisNCisJZGF0YS0+aGFuZGxlID0gc2V2LT5oYW5kbGU7DQorCXJldCA9IHNldl9pc3N1ZV9j
bWQoa3ZtLCBTRVZfQ01EX1JFQ0VJVkVfRklOSVNILCBkYXRhLCAmYXJncC0+ZXJyb3IpOw0KKw0K
KwlrZnJlZShkYXRhKTsNCisJcmV0dXJuIHJldDsNCit9DQorDQogc3RhdGljIGludCBzdm1fbWVt
X2VuY19vcChzdHJ1Y3Qga3ZtICprdm0sIHZvaWQgX191c2VyICphcmdwKQ0KIHsNCiAJc3RydWN0
IGt2bV9zZXZfY21kIHNldl9jbWQ7DQpAQCAtNzM5Niw2ICs3NDE2LDkgQEAgc3RhdGljIGludCBz
dm1fbWVtX2VuY19vcChzdHJ1Y3Qga3ZtICprdm0sIHZvaWQgX191c2VyICphcmdwKQ0KIAljYXNl
IEtWTV9TRVZfUkVDRUlWRV9VUERBVEVfREFUQToNCiAJCXIgPSBzZXZfcmVjZWl2ZV91cGRhdGVf
ZGF0YShrdm0sICZzZXZfY21kKTsNCiAJCWJyZWFrOw0KKwljYXNlIEtWTV9TRVZfUkVDRUlWRV9G
SU5JU0g6DQorCQlyID0gc2V2X3JlY2VpdmVfZmluaXNoKGt2bSwgJnNldl9jbWQpOw0KKwkJYnJl
YWs7DQogCWRlZmF1bHQ6DQogCQlyID0gLUVJTlZBTDsNCiAJCWdvdG8gb3V0Ow0KLS0gDQoyLjE3
LjENCg0K
