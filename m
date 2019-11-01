Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAA40EC797
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 18:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbfKARdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 13:33:44 -0400
Received: from mail-eopbgr740087.outbound.protection.outlook.com ([40.107.74.87]:15264
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728304AbfKARdn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 13:33:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MkazRn1AaAkq9spHjNif3yuUNUpYELu0w5PTkI8bjB09+LR0Ana0TxeGmKYOnZ89y8eyhmjzZJa50Os/138nVk0uYo5lhxuU6OmiYrURN7RFCMU6PcQSejpL3dUIOpEIFcCydZf5GWTQtC8nkZnZ0qLDU8BYhIY25GZPlQklBpza7D47id3IJPkdJ9ZVmmIKevR/1zi/uqThwOBiypwcgexvPOuVZUfTSeFbTxkq2+t/WbgqP5yVAZsC4zkGc7f0BxoK933lldiOC2Df2rzIhzS1BFBubipyNMZjFt67ra4MQ+JupTATPkEDy1subEnRgUAoG9owVU5VRIE0Ag6HDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIo0YTKPq3g4HuGAX3ABUR5y6Om49Ib/5xmdievqoM8=;
 b=PMy5hAcTKHwl/RuPrZbq3kLtQJcCNQbhYX/U9uPHNuH61UFKb14V5spgfbdvVlufaGHQXsNQ1cKa5c8PlCYRBhtVF5aCDf7qG05b/azCR6udp/RKlrMsj0h1R6qhMY9CsGA9lYrT2XtKrChNCLprKe9tUgvPYNH/ikKne91CL1Wx3vXjmdvaUwV7jkg2NM6jI34bFlQIKWoV8wXZ9g13bnZfRmiYq8REsghtdW8VNqnuWLpp7KkTMj1jORkzkZdKQ2NvP1mFMqoXIESpJpjbVNSnBV8J9GPl9mArcYCDSX+zZYy7dymRbM+kM3vj93yaLnWsop7kXGxOGKZg6t0Gkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIo0YTKPq3g4HuGAX3ABUR5y6Om49Ib/5xmdievqoM8=;
 b=ggRqusdQgOdl56LqdiK4nEyRn3IfgWPwcV3Ml4VW/4oIhWsXENIRGgWOh6tiBwgkodgjnqgBt2TsCcf08QHZBSz/ntz9Epk8rxZvFb6MgqGwCPeO/28uOktB8IKlfpU3L2t5bYsxDdpHhHMMUqDibd/VmgH6eUyr4YoPGwlw2xw=
Received: from BL0PR12MB2468.namprd12.prod.outlook.com (52.132.30.157) by
 BL0PR12MB2548.namprd12.prod.outlook.com (52.132.29.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 17:33:38 +0000
Received: from BL0PR12MB2468.namprd12.prod.outlook.com
 ([fe80::748c:1f32:1a4d:acca]) by BL0PR12MB2468.namprd12.prod.outlook.com
 ([fe80::748c:1f32:1a4d:acca%7]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 17:33:38 +0000
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
Subject: [PATCH 1/4] kvm: x86: Dont set UMIP feature bit unconditionally
Thread-Topic: [PATCH 1/4] kvm: x86: Dont set UMIP feature bit unconditionally
Thread-Index: AQHVkNp+SVH8W6w/AkiSMfw9AT2GlQ==
Date:   Fri, 1 Nov 2019 17:33:38 +0000
Message-ID: <157262961597.2838.16953618909905259198.stgit@naples-babu.amd.com>
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
In-Reply-To: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR08CA0035.namprd08.prod.outlook.com
 (2603:10b6:805:66::48) To BL0PR12MB2468.namprd12.prod.outlook.com
 (2603:10b6:207:44::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e02a30c8-bbf2-49b2-8087-08d75ef1a12c
x-ms-traffictypediagnostic: BL0PR12MB2548:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR12MB254841D70B9058D588F166D295620@BL0PR12MB2548.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(189003)(199004)(66946007)(71190400001)(2501003)(2906002)(71200400001)(11346002)(25786009)(14454004)(476003)(478600001)(2201001)(4744005)(6116002)(3846002)(316002)(5660300002)(54906003)(86362001)(110136005)(4326008)(81156014)(64756008)(76176011)(26005)(102836004)(66066001)(446003)(66446008)(7736002)(99286004)(305945005)(7416002)(8676002)(8936002)(186003)(66476007)(486006)(6486002)(6512007)(6506007)(386003)(66556008)(256004)(14444005)(6436002)(52116002)(103116003)(81166006)(921003)(192303002)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR12MB2548;H:BL0PR12MB2468.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KYBpK5FsAooHoXbk7vnsQJ/4gRul8PyOZ/I60i+AiS1CbpKEwf1ipFk0zTJYROdT8FEjzFIKVBWB+fzhmwU17ccvBmu8vFjkMz2mKecKB6RQJtyaT+JpAMgnqdtWyg1abmKJ+JjIjYKnDo5CHZx5E/b2mNBbyF8shFFAZZ78KqyAp4KOuctvS2XzoF0a7PsrUCsnlYxgUVbAxPBQg6Bj+vnwMZMP8PfLm1pzDgpcFj61fqUVZQ+c9ExAWGI3tdLpqU7fcrzpRFpjbUKROmvThtKVq6r6TV2o/wsiIX/ySYHDFZrfu1WLf+I+9oQnx/uxQKUNsWF+iv0TUgYskN331zN7sUSV2n2kLvZR3qKxxov5L2jR00lwAMpxsvnaOPD3e5EzX9STOHySyrN6sy18Sd9aWDQh+KKTUmcRVhlsPBjktbtU2apNvA6tkCtZgeAw
Content-Type: text/plain; charset="utf-8"
Content-ID: <3CF0EF04BD1C06498BD1643D01E1912C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e02a30c8-bbf2-49b2-8087-08d75ef1a12c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 17:33:38.2191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /Ap3bMeIoOEMdKg+Imjtpu+nhLCirujy51GuWEO8Ub2TJroOStReU9YUuok3fkC8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2548
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhlIFVNSVAgKFVzZXItTW9kZSBJbnN0cnVjdGlvbiBQcmV2ZW50aW9uKSBmZWF0dXJlIGJpdCBz
aG91bGQgYmUNCnNldCBpZiB0aGUgZW11bGF0aW9uIChrdm1feDg2X29wcy0+dW1pcF9lbXVsYXRl
ZCkgaXMgc3VwcG9ydGVkDQp3aGljaCBpcyBkb25lIGFscmVhZHkuDQoNClJlbW92ZSB0aGUgdW5j
b25kaXRpb25hbCBzZXR0aW5nIG9mIHRoaXMgYml0Lg0KDQpGaXhlczogYWUzZTYxZTFjMjgzMzhk
MCAoIktWTTogeDg2OiBhZGQgc3VwcG9ydCBmb3IgVU1JUCIpDQoNClNpZ25lZC1vZmYtYnk6IEJh
YnUgTW9nZXIgPGJhYnUubW9nZXJAYW1kLmNvbT4NCi0tLQ0KIGFyY2gveDg2L2t2bS9jcHVpZC5j
IHwgICAgMiArLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigt
KQ0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2NwdWlkLmMgYi9hcmNoL3g4Ni9rdm0vY3B1
aWQuYw0KaW5kZXggZjY4YzBjNzUzYzM4Li41YjgxYmE1YWQ0MjggMTAwNjQ0DQotLS0gYS9hcmNo
L3g4Ni9rdm0vY3B1aWQuYw0KKysrIGIvYXJjaC94ODYva3ZtL2NwdWlkLmMNCkBAIC0zNjQsNyAr
MzY0LDcgQEAgc3RhdGljIGlubGluZSB2b2lkIGRvX2NwdWlkXzdfbWFzayhzdHJ1Y3Qga3ZtX2Nw
dWlkX2VudHJ5MiAqZW50cnksIGludCBpbmRleCkNCiAJLyogY3B1aWQgNy4wLmVjeCovDQogCWNv
bnN0IHUzMiBrdm1fY3B1aWRfN18wX2VjeF94ODZfZmVhdHVyZXMgPQ0KIAkJRihBVlg1MTJWQk1J
KSB8IEYoTEE1NykgfCBGKFBLVSkgfCAwIC8qT1NQS0UqLyB8IEYoUkRQSUQpIHwNCi0JCUYoQVZY
NTEyX1ZQT1BDTlREUSkgfCBGKFVNSVApIHwgRihBVlg1MTJfVkJNSTIpIHwgRihHRk5JKSB8DQor
CQlGKEFWWDUxMl9WUE9QQ05URFEpIHwgRihBVlg1MTJfVkJNSTIpIHwgRihHRk5JKSB8DQogCQlG
KFZBRVMpIHwgRihWUENMTVVMUURRKSB8IEYoQVZYNTEyX1ZOTkkpIHwgRihBVlg1MTJfQklUQUxH
KSB8DQogCQlGKENMREVNT1RFKSB8IEYoTU9WRElSSSkgfCBGKE1PVkRJUjY0QikgfCAwIC8qV0FJ
VFBLRyovOw0KIA0KDQo=
