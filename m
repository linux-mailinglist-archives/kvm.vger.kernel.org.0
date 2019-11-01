Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF37EC79B
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 18:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbfKARd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 13:33:59 -0400
Received: from mail-eopbgr820045.outbound.protection.outlook.com ([40.107.82.45]:11776
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729204AbfKARd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 13:33:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YrEaf62mR5StyskqYrt+nNkP6FEd2l4AWVTgEWyP91wzKY8DE/pcyuSUDRfso8jzhgaHe7lQU81q6uMjJhUPlZHfbPJtCeXwWfHza4Pbs+YGbkR+eFgjyosF7XhYF5qWgg3/wKLLRxX/VTj/XulVcfPoLRM/wAyMJNVxIFPRWxdfuBWxEWIeSfN2f/+NqQS9nGbmWuXLOVn9c5z/m6rFIyh/VtGjD3pJyNOa99Bngm1J59ac01t4E3e5fKpUlc3mVtIApWkpqqZzyK2VJ4A2dvcVnEQKtVbCfwwjukT+NlTOhoWrVOQC5KzMytOHNJ1QwB1GR2zrn9dYjYW0REqLJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ba0TFN6zCMbtcFRbOKP9AF9v3wJMmz4dqOHcotfWzAQ=;
 b=oS0W4b33Wb9LpB33WSk8/h5N4DSE4U67Ss2Sr3frNJj44GiOlpF4faBSklg49EVnPTeY5Q/XNUlTzUh4DjplE/s/17hILJjqqQOjejpR/ZBYrCukkp57y5RmOrXFcID3TIr+OEn1V7Ysh6sfcy1adxThc1ZFmjBwM5W3UTcZy0Z11XQO/Dz58kqaDKPKkcYIRx6ejTIca+r2iSdOtPYy8bBwavJvCcfYHChe8hB/+TJZohBew2FcmMA5ljH0p5e46SM4vCErjiREzAGMa5YE0DLjBsIs1rM4xaSFGkXtuW2lgneGGDerAnk0GTP+8zk3zPuex1Mqux92naW32cOExw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ba0TFN6zCMbtcFRbOKP9AF9v3wJMmz4dqOHcotfWzAQ=;
 b=ReFiIMMIASHerUto1L1KKGUG77snl59OQRq0JYCzKN60C6E7/MMBNjq1dz25YG7JHFLe/3YGzI7He+j9YeXfsQNZKwKG6dqRIczkzNjJH4t+4rvqpSA3n6RKSf+CeU8mDLe3j1yQ5TyokXGCgVUVBf5qjFvDMPp2YPpn3TEP6+0=
Received: from BL0PR12MB2468.namprd12.prod.outlook.com (52.132.30.157) by
 BL0PR12MB2451.namprd12.prod.outlook.com (52.132.11.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 17:33:53 +0000
Received: from BL0PR12MB2468.namprd12.prod.outlook.com
 ([fe80::748c:1f32:1a4d:acca]) by BL0PR12MB2468.namprd12.prod.outlook.com
 ([fe80::748c:1f32:1a4d:acca%7]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 17:33:53 +0000
From:   "Moger, Babu" <Babu.Moger@amd.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Moger, Babu" <Babu.Moger@amd.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH 3/4] kvm: svm: Emulate UMIP instructions on non SEV guest
Thread-Topic: [PATCH 3/4] kvm: svm: Emulate UMIP instructions on non SEV guest
Thread-Index: AQHVkNqHNWOug2PnfE283OzKzR6Cjw==
Date:   Fri, 1 Nov 2019 17:33:53 +0000
Message-ID: <157262963095.2838.4880629527800792709.stgit@naples-babu.amd.com>
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
In-Reply-To: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR0102CA0016.prod.exchangelabs.com (2603:10b6:805:1::29)
 To BL0PR12MB2468.namprd12.prod.outlook.com (2603:10b6:207:44::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4358d073-f27a-49a6-fe85-08d75ef1aa1d
x-ms-traffictypediagnostic: BL0PR12MB2451:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR12MB24513448A329055F513D88EF95620@BL0PR12MB2451.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(189003)(199004)(8936002)(4326008)(54906003)(186003)(478600001)(64756008)(11346002)(66066001)(14454004)(7416002)(476003)(86362001)(316002)(486006)(71190400001)(99286004)(256004)(2906002)(76176011)(81156014)(71200400001)(110136005)(8676002)(66556008)(66446008)(52116002)(102836004)(3846002)(386003)(2501003)(81166006)(5660300002)(6506007)(66476007)(66946007)(6436002)(6512007)(6486002)(6116002)(26005)(446003)(103116003)(2201001)(305945005)(25786009)(7736002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR12MB2451;H:BL0PR12MB2468.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qEmk+OmcPc+W4wJdQ3JSpdxzogMcNY9R4S5kZRusoaZUCkHRJrY1T4UfVVmZtZJjrGJq6e2fNjdLTPzWLlj9BmrqojCdQ4wLOUjuOIsPGLJ4g2bSiamjGW0MNDSUFT1MNPn/yjawxJsGgsatynopjwZgqGphSgyXnQcerw39vU903ZLPJEEAUE7alz+lqZ4ErF0vHmvLg5KyMS5x3rxW+EVxw1Tu1pQ6tns+w9nQL6qWBxsQl6o44Xbmdxz+NtefQA65GZZvfjmFKAFY2i5yBOC0am/BQO60ZZbzylEGPV6kx8ZDbD/hdI2XOhM/z4IUWuZg3Mocl1J7EfeA3Z7/041TuWf/tEuPVvfRK1trBTKn4PUbMgGQc+RptrhkjzanSyFsulpPm+wgyNHKVD1bn08mgUJM/ltLDanGyiT1XzGapKrBGJ2OAEiqKaKWzvNP
Content-Type: text/plain; charset="utf-8"
Content-ID: <C70B5612BC19FC468CF70BC490E57E59@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4358d073-f27a-49a6-fe85-08d75ef1aa1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 17:33:53.2175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 26m8VAe5+ZRNbDZKx90TBkw1rSTKxmwCPFMJiDApm0GQYFmt01g+EenJYFzNIIRT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2451
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RW11bGF0aW9uIG9mIFVNSVAgaW5zdHJ1Y3Rpb25zIChzZ2R0LCBzaWR0LCBzbGR0LCBzbXN3IGFu
ZCBzdHIpIHJlcXVpcmVzDQp0aGUgaHlwZXJ2aXNvciB0byByZWFkIGFuZCB3cml0ZSB0aGUgZ3Vl
c3QgbWVtb3J5LiBHdWVzdCBtZW1vcnkgaXMNCmVuY3J5cHRlZCBvbiBTRVYgZ3Vlc3QuIEh5cGVy
dmlzb3IgY2Fubm90IHN1Y2Nlc3NmdWxseSByZWFkIG9yIHdyaXRlIHRoZQ0KZ3Vlc3QgbWVtb3J5
LiBTbyBkaXNhYmxlIGVtdWxhdGlvbiBvbiBTRVYgZ3Vlc3QuIEVuYWJsZSB0aGUgZW11bGF0aW9u
IG9ubHkNCm9uIG5vbiBTRVYgZ3Vlc3QuDQoNClNpZ25lZC1vZmYtYnk6IEJhYnUgTW9nZXIgPGJh
YnUubW9nZXJAYW1kLmNvbT4NCi0tLQ0KIGFyY2gveDg2L2t2bS9zdm0uYyB8ICAgIDkgKysrKysr
KysrDQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvYXJj
aC94ODYva3ZtL3N2bS5jIGIvYXJjaC94ODYva3ZtL3N2bS5jDQppbmRleCA3OWFiYmRlY2ExNDgu
LjI2N2RhZTk0ZTVjYSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS9zdm0uYw0KKysrIGIvYXJj
aC94ODYva3ZtL3N2bS5jDQpAQCAtMTUzNSw2ICsxNTM1LDE1IEBAIHN0YXRpYyB2b2lkIGluaXRf
dm1jYihzdHJ1Y3QgdmNwdV9zdm0gKnN2bSkNCiAJc2V0X2ludGVyY2VwdChzdm0sIElOVEVSQ0VQ
VF9OTUkpOw0KIAlzZXRfaW50ZXJjZXB0KHN2bSwgSU5URVJDRVBUX1NNSSk7DQogCXNldF9pbnRl
cmNlcHQoc3ZtLCBJTlRFUkNFUFRfU0VMRUNUSVZFX0NSMCk7DQorDQorCS8qIEVuYWJsZSBpbnRl
cmNlcHRpb24gb25seSBvbiBub24tc2V2IGd1ZXN0ICovDQorCWlmICghc2V2X2d1ZXN0KHN2bS0+
dmNwdS5rdm0pKSB7DQorCQlzZXRfaW50ZXJjZXB0KHN2bSwgSU5URVJDRVBUX1NUT1JFX0lEVFIp
Ow0KKwkJc2V0X2ludGVyY2VwdChzdm0sIElOVEVSQ0VQVF9TVE9SRV9HRFRSKTsNCisJCXNldF9p
bnRlcmNlcHQoc3ZtLCBJTlRFUkNFUFRfU1RPUkVfTERUUik7DQorCQlzZXRfaW50ZXJjZXB0KHN2
bSwgSU5URVJDRVBUX1NUT1JFX1RSKTsNCisJfQ0KKw0KIAlzZXRfaW50ZXJjZXB0KHN2bSwgSU5U
RVJDRVBUX1JEUE1DKTsNCiAJc2V0X2ludGVyY2VwdChzdm0sIElOVEVSQ0VQVF9DUFVJRCk7DQog
CXNldF9pbnRlcmNlcHQoc3ZtLCBJTlRFUkNFUFRfSU5WRCk7DQoNCg==
