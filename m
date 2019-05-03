Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56B7312F53
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 15:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbfECNhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 09:37:31 -0400
Received: from mail-eopbgr760074.outbound.protection.outlook.com ([40.107.76.74]:33601
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726377AbfECNhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 09:37:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5c8hWceaDcibDPAXCrTKB0OMZEq7b6N268RW0RHpjFY=;
 b=hEkSDOdpCT8XvAeY/iGDEyAooUhdCVp9I+KLjN9GvFXyzAc49Ig3FlBHRgRgc+/wNkPx2dmN41XTbPAat+ZrE9OnPZgmL4YD0JtIb/v4JueYOeMUMAKmma9GHHJRaYBRV04jFxnUzVBcgZIursTcvBiPSFsxDSRkRLM9vUY4qoo=
Received: from DM6PR12MB2844.namprd12.prod.outlook.com (20.176.117.96) by
 DM6PR12MB3212.namprd12.prod.outlook.com (20.179.105.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Fri, 3 May 2019 13:37:27 +0000
Received: from DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::d119:23e5:be33:4ac6]) by DM6PR12MB2844.namprd12.prod.outlook.com
 ([fe80::d119:23e5:be33:4ac6%2]) with mapi id 15.20.1856.008; Fri, 3 May 2019
 13:37:27 +0000
From:   "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH] svm/avic: Allow avic_vcpu_load logic to support host APIC ID
 255
Thread-Topic: [PATCH] svm/avic: Allow avic_vcpu_load logic to support host
 APIC ID 255
Thread-Index: AQHVAbVYshI13bVJeUaA1Du2DOEuSw==
Date:   Fri, 3 May 2019 13:37:27 +0000
Message-ID: <1556890631-9561-1-git-send-email-suravee.suthikulpanit@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [165.204.78.1]
x-clientproxiedby: SN2PR01CA0038.prod.exchangelabs.com (2603:10b6:804:2::48)
 To DM6PR12MB2844.namprd12.prod.outlook.com (2603:10b6:5:45::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83a348eb-59db-4362-798a-08d6cfcc7b3c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3212;
x-ms-traffictypediagnostic: DM6PR12MB3212:
x-microsoft-antispam-prvs: <DM6PR12MB3212427936D539899F37B034F3350@DM6PR12MB3212.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0026334A56
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(136003)(376002)(346002)(396003)(189003)(199004)(8936002)(386003)(4720700003)(3846002)(6116002)(66066001)(6512007)(14454004)(25786009)(66556008)(68736007)(71200400001)(71190400001)(64756008)(6506007)(316002)(52116002)(66476007)(2501003)(36756003)(8676002)(50226002)(4744005)(7736002)(54906003)(81156014)(81166006)(99286004)(305945005)(66946007)(73956011)(256004)(66446008)(4326008)(486006)(5660300002)(478600001)(186003)(110136005)(2906002)(72206003)(6436002)(26005)(53936002)(476003)(6486002)(2616005)(102836004)(86362001)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3212;H:DM6PR12MB2844.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jvW7uBW8VvlcRXMqdV2oKiPIq3wBSOcEFm0jYeZO0UVyBJEVMHdmv79/nqLbDY36SJ2CDAhoFpZ1/Xf3ZqG3F2Ry/2+7ZU1fIercHkEQaMI+pjPeYRktsOoiDsXCP0nwhg64/sNrwdySzc5I+jyh17rMWcOTyrGegcPARaVzvUdv41nfh4KiNpzEMnoIfDd1mXptTuLE0LLIa+v2cmpWlm4fjo0gHhNAUb6jL2AvFEbjrCAO7Ge7O6PvsQI8uk+/FZi9TgcO7MBiuoAptTTW+LY36WZYipaxQnHFmUDW3VRQ3Ick9+rQsTAbs1eZlvjXSD28LAk94EOOtqDzJIzGV/kJNLccsoL3a//xTTzwaDugDA1asfrBRLIARKtXBUt/qNryFIavGc67zwYYREGt69WfjZjkA1G7yXmjivb7IxM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83a348eb-59db-4362-798a-08d6cfcc7b3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2019 13:37:27.1445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3212
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Q3VycmVudCBsb2dpYyBkb2VzIG5vdCBhbGxvdyBWQ1BVIHRvIGJlIGxvYWRlZCBvbnRvIENQVSB3
aXRoDQpBUElDIElEIDI1NS4gVGhpcyBzaG91bGQgYmUgYWxsb3dlZCBzaW5jZSB0aGUgaG9zdCBw
aHlzaWNhbCBBUElDIElEDQpmaWVsZCBpbiB0aGUgQVZJQyBQaHlzaWNhbCBBUElDIHRhYmxlIGVu
dHJ5IGlzIGFuIDgtYml0IHZhbHVlLA0KYW5kIEFQSUMgSUQgMjU1IGlzIHZhbGlkIGluIHN5c3Rl
bSB3aXRoIHgyQVBJQyBlbmFibGVkLg0KDQpJbnN0ZWFkLCBkbyBub3QgYWxsb3cgVkNQVSBsb2Fk
IGlmIHRoZSBob3N0IEFQSUMgSUQgY2Fubm90IGJlDQpyZXByZXNlbnRlZCBieSBhbiA4LWJpdCB2
YWx1ZS4NCg0KU2lnbmVkLW9mZi1ieTogU3VyYXZlZSBTdXRoaWt1bHBhbml0IDxzdXJhdmVlLnN1
dGhpa3VscGFuaXRAYW1kLmNvbT4NCi0tLQ0KIGFyY2gveDg2L2t2bS9zdm0uYyB8IDYgKysrKyst
DQogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZm
IC0tZ2l0IGEvYXJjaC94ODYva3ZtL3N2bS5jIGIvYXJjaC94ODYva3ZtL3N2bS5jDQppbmRleCAy
OTQ0NDhlLi4xMjI3ODhmIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva3ZtL3N2bS5jDQorKysgYi9h
cmNoL3g4Ni9rdm0vc3ZtLmMNCkBAIC0yMDcxLDcgKzIwNzEsMTEgQEAgc3RhdGljIHZvaWQgYXZp
Y192Y3B1X2xvYWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBpbnQgY3B1KQ0KIAlpZiAoIWt2bV92
Y3B1X2FwaWN2X2FjdGl2ZSh2Y3B1KSkNCiAJCXJldHVybjsNCiANCi0JaWYgKFdBUk5fT04oaF9w
aHlzaWNhbF9pZCA+PSBBVklDX01BWF9QSFlTSUNBTF9JRF9DT1VOVCkpDQorCS8qDQorCSAqIFNp
bmNlIHRoZSBob3N0IHBoeXNpY2FsIEFQSUMgaWQgaXMgOCBiaXRzLA0KKwkgKiB3ZSBjYW4gc3Vw
cG9ydCBob3N0IEFQSUMgSUQgdXB0byAyNTUuDQorCSAqLw0KKwlpZiAoV0FSTl9PTihoX3BoeXNp
Y2FsX2lkID4gQVZJQ19NQVhfUEhZU0lDQUxfSURfQ09VTlQpKQ0KIAkJcmV0dXJuOw0KIA0KIAll
bnRyeSA9IFJFQURfT05DRSgqKHN2bS0+YXZpY19waHlzaWNhbF9pZF9jYWNoZSkpOw0KLS0gDQox
LjguMy4xDQoNCg==
