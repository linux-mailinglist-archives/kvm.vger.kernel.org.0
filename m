Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A18E2EC795
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 18:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbfKARdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 13:33:36 -0400
Received: from mail-eopbgr700086.outbound.protection.outlook.com ([40.107.70.86]:2017
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726554AbfKARdg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 13:33:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSkd1gtA7I14yHHWIg1gN3Ei756f4M9rvbNf40/UKVodmjv//JwVN2mG9sD9K/ODbrK/wSPvmPPtC5w1V86v7z/GwI7rTr9w6w7U2U2I7UMHUbXfpJ7d7QX1UnpKkN5DmzxAo0mBlR3HyWczkR95smZ75OMYjtPukahjYjhGuRlLa/1l2Aey2BC8gQYOlKCUD5owKC4T1o0r5xsDW9qxZqVXnt6Pr/G5PN7cdaKdkzC+37V6bOVdA+BmBC9dzE94ZO7wcnykrkPmiti0wucTWGIS1yfKzLlsC2Nf53xylVxj5M14hG1JV0ULr3AOgrHsPPO9HV7Biwyrx3ydb2x/DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/dGH5xrTnpEDELMuBijtP5Xkd6krd5g9D3YNTiBfdk=;
 b=FYudDhtiHSOhJb1sZe0LDDN+69fAWrjDkY4lhzOvhSiSSKQcu6EW0e67KBmIRMl4Zpl2j+T3GuLHwy93fcf77800fXNpEj2GSgucsKvPo9qGJoUHSDwYtOM/VBawhiEmEFD5aOJ8ZrOyyNFX3O6f0wmYn0hx5+bIRrScY1neKxRed1OsO1yVFa3uz+v6//Vz7f8b+K+lde2kIa5YNEWvIJhpcCmMwSoJeakqaDqaoUdwnJikZJror9j1MfBAWPcjTVx5pBoOlhbPe7kR55cP+1siAtpKIAZ/dcQynd60SpAb1GeIMk3VOO7q4gwgNx1zkMC30uueV4zkAQFAbYmJUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/dGH5xrTnpEDELMuBijtP5Xkd6krd5g9D3YNTiBfdk=;
 b=v5dwu2XlOmtDDDa5b3G8rnoLZjjN7owoGHEqAaeTXgA5Oz3ezQYSBRkcD679HbQjafBgfa8kFoZR8aaUDoXa4fYahXOIf8Q9Xb7GWm/HZNL7e2k3hU7MmNn/fmKlcTusFSTHVV4GKJsUuejdiwmODxvBXUQAnz5OUZG0AqKsUfY=
Received: from BL0PR12MB2468.namprd12.prod.outlook.com (52.132.30.157) by
 BL0PR12MB2548.namprd12.prod.outlook.com (52.132.29.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 17:33:30 +0000
Received: from BL0PR12MB2468.namprd12.prod.outlook.com
 ([fe80::748c:1f32:1a4d:acca]) by BL0PR12MB2468.namprd12.prod.outlook.com
 ([fe80::748c:1f32:1a4d:acca%7]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 17:33:30 +0000
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
Subject: [PATCH 0/4] Emulate and enable UMIP feature on AMD
Thread-Topic: [PATCH 0/4] Emulate and enable UMIP feature on AMD
Thread-Index: AQHVkNp6yHzbr4SWxUqB/ZBcMwNDtg==
Date:   Fri, 1 Nov 2019 17:33:30 +0000
Message-ID: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR08CA0014.namprd08.prod.outlook.com
 (2603:10b6:805:66::27) To BL0PR12MB2468.namprd12.prod.outlook.com
 (2603:10b6:207:44::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f572f14a-8a9c-43ec-d5af-08d75ef19caa
x-ms-traffictypediagnostic: BL0PR12MB2548:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR12MB2548A0B54B7F58DAD0BA888995620@BL0PR12MB2548.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(189003)(199004)(66946007)(71190400001)(2501003)(2906002)(71200400001)(25786009)(14454004)(476003)(478600001)(2201001)(6116002)(3846002)(316002)(5660300002)(54906003)(86362001)(110136005)(4326008)(81156014)(64756008)(26005)(102836004)(66066001)(66446008)(7736002)(99286004)(305945005)(7416002)(8676002)(8936002)(186003)(66476007)(486006)(6486002)(6512007)(6506007)(386003)(66556008)(256004)(14444005)(6436002)(52116002)(103116003)(81166006)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR12MB2548;H:BL0PR12MB2468.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: exGF2hbicJtOq3iGoqpHa0Z3kqNkBTcYWjIa5QrfK22Tb+7MUvIYDDXICOuJJfYuUC35u8hYBBEayUPjk1vuWB79xXzonNfM60uG6lTAqp/YK/M1pvhKBDbsvbpesXD8jhIV/NdYWq4DuG7jUEvBOSTB0plOMEYLgLh//BNjx0F/V3B50cgPGpEwUY0mpUnuouCBfqyEJXVEFJ4FKHULvtM3GB1JxI8lJPAno/pEXJSiofn6rPOH2vIwoAXWehcsTfhpKqrBJf2Gi0fC9ngB0XeJ3373LnGWNQn5er81vN+gpLP8xVQrsRola6zHSEEugQUBCZjW9jXXZAKJJTkRq3ZX6WCyA8rZ0GevqsOOw2qpRl72dMxY/iwmPmNfbRxF/oe0RnGSoTeoV29Ok9zYB5NmLIZGJysRirvHdMH+jKCu6AVxu4IkW/n6zBl2I/oZ
Content-Type: text/plain; charset="utf-8"
Content-ID: <490770091B2FFE4EBC0CB805FDA3B229@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f572f14a-8a9c-43ec-d5af-08d75ef19caa
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 17:33:30.6604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r07VneNFfItYXPv4qMi24Gx0i8AWgS+kKWEwypBuEV9jmcY8CEOkf2rxbXF66D/6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2548
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QU1EIDJuZCBnZW5lcmF0aW9uIEVQWUMgcHJvY2Vzc29ycyBzdXBwb3J0IFVNSVAgKFVzZXItTW9k
ZSBJbnN0cnVjdGlvbg0KUHJldmVudGlvbikgZmVhdHVyZS4gRW11bGF0ZSBhbmQgZW5hYmxlIHRo
ZSBVTUlQIGZlYXR1cmUgaWYgYmFyZSBtZXRhbA0Kc3VwcG9ydHMgaXQuIEVtdWxhdGlvbiBvZiBV
TUlQIGluc3RydWN0aW9ucyAoc2dkdCwgc2lkdCwgc2xkdCwgc21zdyBhbmQNCnN0cikgcmVxdWly
ZXMgdGhlIGh5cGVydmlzb3IgdG8gcmVhZCBhbmQgd3JpdGUgdGhlIGd1ZXN0IG1lbW9yeS4gR3Vl
c3QNCm1lbW9yeSBpcyBlbmNyeXB0ZWQgb24gU0VWIGd1ZXN0LiBIeXBlcnZpc29yIGNhbm5vdCBz
dWNjZXNzZnVsbHkgcmVhZCBvcg0Kd3JpdGUgdGhlIGd1ZXN0IG1lbW9yeS4gU28gZGlzYWJsZSBl
bXVsYXRpb24gb24gU0VWIGd1ZXN0LiBFbmFibGUgdGhlDQplbXVsYXRpb24gb25seSBvbiBub24g
U0VWIGd1ZXN0Lg0KDQpUZXN0ZWQgb24gRVBZQy9FUFlDLVJvbWUgVk1zIGFuZCB3b3JrcyBhcyBl
eHBlY3RlZC4gUGxlYXNlIHJldmlldy4NCg0KQmFidSBNb2dlciAoNCk6DQogIGt2bTogeDg2OiBE
b250IHNldCBVTUlQIGZlYXR1cmUgYml0IHVuY29uZGl0aW9uYWxseQ0KICBrdm06IHN2bTogRW5h
YmxlIFVNSVAgZmVhdHVyZSBvbiBBTUQNCiAga3ZtOiBzdm06IEVtdWxhdGUgVU1JUCBpbnN0cnVj
dGlvbnMgb24gbm9uIFNFViBndWVzdA0KICB4ODYvS2NvbmZpZzogUmVuYW1lIFVNSVAgY29uZmln
IHBhcmFtZXRlcg0KDQogYXJjaC94ODYvS2NvbmZpZyAgICAgICAgICAgICAgICAgICAgICAgICB8
ICA4ICsrKy0tLS0NCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9kaXNhYmxlZC1mZWF0dXJlcy5oIHwg
IDIgKy0NCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS91bWlwLmggICAgICAgICAgICAgIHwgIDQgKyst
LQ0KIGFyY2gveDg2L2tlcm5lbC9NYWtlZmlsZSAgICAgICAgICAgICAgICAgfCAgMiArLQ0KIGFy
Y2gveDg2L2t2bS9jcHVpZC5jICAgICAgICAgICAgICAgICAgICAgfCAgMiArLQ0KIGFyY2gveDg2
L2t2bS9zdm0uYyAgICAgICAgICAgICAgICAgICAgICAgfCAzMCArKysrKysrKysrKysrKysrKysr
Ky0tLS0NCiA2IGZpbGVzIGNoYW5nZWQsIDM0IGluc2VydGlvbnMoKyksIDE0IGRlbGV0aW9ucygt
KQ0KDQotLSANCjIuMjAuMQ0KDQo=
