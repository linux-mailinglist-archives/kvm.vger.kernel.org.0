Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9CA0EC894
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 19:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfKASim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 14:38:42 -0400
Received: from mail-eopbgr740049.outbound.protection.outlook.com ([40.107.74.49]:7820
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726498AbfKASim (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 14:38:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7dhIflZJURROTSFgmx4FHo8UMkWyJgs0Pw1RuB0bZik6UNVQaHEHdGKWRcOq/mktjrEMabdKVjDnYYPNqtoXhq8JsTwTvWvoFxW2N+OWFKpfpXMseodZ6VjuJ4WR99b8g0H4aGsJJstMN/cb4WYB6sIgVOX9MnDxn7eH6MYdq0Up89l8pV8APFcJFxlt6V+a/a6vbv2oa1VhuNaWk13KTdrVuXkMVI3VjHBbA9TT7tbqx+pZOU63HQ0GiQDoYNhgFKtp3h+2f+MOelorPJiEsCG9VdIzDXpoT2XenfuG5zs7/uFKrMkyaopIudmX+j48gWRzq9tlQlJTCnR+4wUgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDhhv964bW6iZ/aiUY/rhHDYBPuiCjFOEVv7fgYHZUM=;
 b=QARtd3Ms/1sNVD697zC9etqJDVOgqGY4LWbcTOhr+9zaGoKHNdNd6lz/s1C8uGwAslnKajBksWy86lH4hBGGG86p8IXgKDPeDcddcCDYZbp6Q6v/dKYd0ZDXGbR05jVJIKnaPOyA4hrNYx3b/8n/e0GgUykhqx+gJgAh56GGMT3Cilmg3d7Z7oPUofnnM9/D5avh9CInRhj0587xPQOV/0gzfAgtngom73kXXP9fmRR+bSZGt3Dz2HZZYaTcO1s7eV4KcLcQVuLzB5dR920WJ78BYvtr+tiQHoqBFBZJk2TOl5j9BKC5hvkaAKoOeALrwpYqq4MmaqbYuKB2y35O8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDhhv964bW6iZ/aiUY/rhHDYBPuiCjFOEVv7fgYHZUM=;
 b=a8e5cbY7DpiCZSRlrBQj2Kb4Scl1Mcsfn5YfRSTv7MwLwkdNuZqkAQ7ax9wg3vCu7Xebw27rdSNWN/mCXdrtEopzoZrKJ5aZBPu2WvKu+4QKiCxpxQoDV1TcbG5oXLMZI+e6ykpSnK7d5yaYKtOXFWQSMUsH1qxg4jLVS7kJ1CA=
Received: from BL0PR12MB2468.namprd12.prod.outlook.com (52.132.30.157) by
 BL0PR12MB2820.namprd12.prod.outlook.com (20.177.240.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 18:38:36 +0000
Received: from BL0PR12MB2468.namprd12.prod.outlook.com
 ([fe80::748c:1f32:1a4d:acca]) by BL0PR12MB2468.namprd12.prod.outlook.com
 ([fe80::748c:1f32:1a4d:acca%7]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 18:38:36 +0000
From:   "Moger, Babu" <Babu.Moger@amd.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
Thread-Topic: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
Thread-Index: AQHVkNqD+3M/4HqTrkKsDppH5BsZ1qd2oWCAgAAEC4A=
Date:   Fri, 1 Nov 2019 18:38:36 +0000
Message-ID: <288d481f-43c7-ffbb-8aed-c3c4bc19846b@amd.com>
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
 <157262962352.2838.15656190309312238595.stgit@naples-babu.amd.com>
 <CALCETrUSjbjt=U6OpTFXEZsEJQ6zjcqCeqi6nSFOi=rN91zWmg@mail.gmail.com>
In-Reply-To: <CALCETrUSjbjt=U6OpTFXEZsEJQ6zjcqCeqi6nSFOi=rN91zWmg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR04CA0098.namprd04.prod.outlook.com
 (2603:10b6:805:f2::39) To BL0PR12MB2468.namprd12.prod.outlook.com
 (2603:10b6:207:44::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 727086fc-a21e-449b-f4ab-08d75efab47b
x-ms-traffictypediagnostic: BL0PR12MB2820:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <BL0PR12MB2820429E92698E7EC393538595620@BL0PR12MB2820.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(136003)(376002)(39860400002)(199004)(189003)(316002)(476003)(81166006)(2616005)(256004)(102836004)(66556008)(99286004)(8936002)(54906003)(3846002)(5660300002)(52116002)(186003)(76176011)(71190400001)(66946007)(11346002)(64756008)(26005)(81156014)(486006)(446003)(6506007)(71200400001)(66446008)(66476007)(53546011)(229853002)(478600001)(31696002)(14454004)(6512007)(86362001)(25786009)(7416002)(8676002)(36756003)(6116002)(386003)(6246003)(4326008)(6486002)(6436002)(66066001)(966005)(2906002)(7736002)(31686004)(45080400002)(6306002)(305945005)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR12MB2820;H:BL0PR12MB2468.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dkvovrxi/LjZkiI383G4BAMgKi6PfItnJmDXlhh7b9cl3soUc2vX8ulQ42ropCcK7EhbtdxDkpPm6CckzwbE4PmfH5DimvMY31ZBxCD4oNSseiNyJbpTdXrvUvvsNQiHLvY311bV71BrwOtAalFnQ24mwWwWrTL1KYtOb1W0v94daHv7lnsdInKiFoyKmuftNjiIY24p1LrvqUM7sU0IdQCK7cq5k2qnWDTqaI6o6MN6St5mx1Ygbaw6qnOm9D2+JoCOoGh8EAxcR7mJDwEpKfhudYKMGFf/sdCS85NPyYDKurg3uDk+DXIO7OOHeir2W9LhlnWp247PfA3F4xeMTCuPEJEWZUD8oTDYIQPE4jHHqM/slTK8eCOXkLNhHjhnw/PXARFr97qSGJzZFLN8X96wyQt+ML6b2fvZtfBo1iaqOCyWxFfTG7PsbPoiSgs8s8Kb/tOTOvnNuaYMtwgttYrnYc1jMF7n9Q1aNaIibaY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6B1B085C48686348BB9E8FB745A73F12@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 727086fc-a21e-449b-f4ab-08d75efab47b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 18:38:36.1140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iMVx7QADjmVx9FCUuo9evM4z0jMbNR6gXznt42xx1zedOmX8G8c11X8YgCnlvmIY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2820
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDExLzEvMTkgMToyNCBQTSwgQW5keSBMdXRvbWlyc2tpIHdyb3RlOg0KPiBPbiBGcmks
IE5vdiAxLCAyMDE5IGF0IDEwOjMzIEFNIE1vZ2VyLCBCYWJ1IDxCYWJ1Lk1vZ2VyQGFtZC5jb20+
IHdyb3RlOg0KPj4NCj4+IEFNRCAybmQgZ2VuZXJhdGlvbiBFUFlDIHByb2Nlc3NvcnMgc3VwcG9y
dCBVTUlQIChVc2VyLU1vZGUgSW5zdHJ1Y3Rpb24NCj4+IFByZXZlbnRpb24pIGZlYXR1cmUuIFRo
ZSBVTUlQIGZlYXR1cmUgcHJldmVudHMgdGhlIGV4ZWN1dGlvbiBvZiBjZXJ0YWluDQo+PiBpbnN0
cnVjdGlvbnMgaWYgdGhlIEN1cnJlbnQgUHJpdmlsZWdlIExldmVsIChDUEwpIGlzIGdyZWF0ZXIg
dGhhbiAwLg0KPj4gSWYgYW55IG9mIHRoZXNlIGluc3RydWN0aW9ucyBhcmUgZXhlY3V0ZWQgd2l0
aCBDUEwgPiAwIGFuZCBVTUlQDQo+PiBpcyBlbmFibGVkLCB0aGVuIGtlcm5lbCByZXBvcnRzIGEg
I0dQIGV4Y2VwdGlvbi4NCj4+DQo+PiBUaGUgaWRlYSBpcyB0YWtlbiBmcm9tIGFydGljbGVzOg0K
Pj4gaHR0cHM6Ly9sd24ubmV0L0FydGljbGVzLzczODIwOS8NCj4+IGh0dHBzOi8vbHduLm5ldC9B
cnRpY2xlcy82OTQzODUvDQo+Pg0KPj4gRW5hYmxlIHRoZSBmZWF0dXJlIGlmIHN1cHBvcnRlZCBv
biBiYXJlIG1ldGFsIGFuZCBlbXVsYXRlIGluc3RydWN0aW9ucw0KPj4gdG8gcmV0dXJuIGR1bW15
IHZhbHVlcyBmb3IgY2VydGFpbiBjYXNlcy4NCj4gDQo+IFdoYXQgYXJlIHRoZXNlIGNhc2VzPw0K
DQpJdCBpcyBtZW50aW9uZWQgaW4gdGhlIGFydGljbGUgaHR0cHM6Ly9sd24ubmV0L0FydGljbGVz
LzczODIwOS8NCg0KPT09IEhvdyBkb2VzIGl0IGltcGFjdCBhcHBsaWNhdGlvbnM/DQoNCldoZW4g
ZW5hYmxlZCwgaG93ZXZlciwgVU1JUCB3aWxsIGNoYW5nZSB0aGUgYmVoYXZpb3IgdGhhdCBjZXJ0
YWluDQphcHBsaWNhdGlvbnMgZXhwZWN0IGZyb20gdGhlIG9wZXJhdGluZyBzeXN0ZW0uIEZvciBp
bnN0YW5jZSwgcHJvZ3JhbXMNCnJ1bm5pbmcgb24gV2luZUhRIGFuZCBET1NFTVUyIHJlbHkgb24g
c29tZSBvZiB0aGVzZSBpbnN0cnVjdGlvbnMgdG8NCmZ1bmN0aW9uLiBTdGFzIFNlcmdlZXYgZm91
bmQgdGhhdCBNaWNyb3NvZnQgV2luZG93cyAzLjEgYW5kIGRvczRndyB1c2UgdGhlDQppbnN0cnVj
dGlvbiBTTVNXIHdoZW4gcnVubmluZyBpbiB2aXJ0dWFsLTgwODYgbW9kZSBbNF0uIFNHRFQgYW5k
IFNJRFQgY2FuDQphbHNvIGJlIHVzZWQgb24gdmlydHVhbC04MDg2IG1vZGUuDQoNCkkgaGF2ZSBu
b3QgdGVzdGVkIHRoZXNlIGNhc2VzLiBJIGp1c3QgZm9sbG93ZWQgdGhlIHNhbWUgY29kZSB0aGF0
IHdhcyBkb25lDQpmb3IgSW50ZWwgVU1JUC4NCg0K
