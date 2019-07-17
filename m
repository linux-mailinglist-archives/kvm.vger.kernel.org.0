Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBEAB6C245
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 22:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfGQUoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 16:44:44 -0400
Received: from mail-eopbgr810071.outbound.protection.outlook.com ([40.107.81.71]:47293
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725993AbfGQUoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 16:44:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKVm5+n6Er2PTlqUFssjKEkRkToc5SS+o54tx1JlQxAo83NE3cc+Zh5WiPdpNwEsQamWcAJatW9pnbkifBfRe7CdeiRAqC21GH+cdddU9znX6w84gvQkFu/oyJ80ETVXh54UZ/asgb+g0wxLo+VyB4PerbVLQJJfkhY61HNJXsI0jn4jjqAoZ9Z0t+iPcmYD6uMjbJlwWjfjx9itJXGv4xOFu3AN0+KrG1s9YTq1ZayrW5Msaau/EEWEVnXU5agD+6RncJeE2Df2AMb22trXIKwhtqdwNfUwossGdbpE57SImwAfK2JDVXWC+d8bfKdRom4g9C+JNJRIvzVysWz2hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qaz8lVEuUB8VDbKRFibGh+TEL2+Dzf8bTV1EycoO64g=;
 b=dnOEJ0MorI6hWrsNyrrGZBo/vMm7ueSvSPuYWRPY3NzynKFIJEpWKXxXmWuIL7PjPc3QMBLXecnQdncQn9GXSVUM/ShymLZEGxdvlwxsq9qxN4W7/kehe1O799VPgPx1AB5atOqJcaBGf4oqVN9X1d8GjUguWPRZCz0edJvmmvtnePDj1ZEntH6r7+bghUHFiSKY2Wx7TqdYsYzYN0ZPHIEs3d6fqGyWcRDx0FCIkoshUryUT38Qcpuc+oi/XCf3mYCCVzeCKL6DCe0tpg325hCTttM8V4nSoCe2CMinYHlkPcRkfURmlLO3tXCG9UsycqMYAeg1e79wB43nckiMEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qaz8lVEuUB8VDbKRFibGh+TEL2+Dzf8bTV1EycoO64g=;
 b=rovNBzhtJom/P4M6M5KtUOiTM9CU670Ubuj6RC1xhCXSU4MWWsufH7PRGdNOkRnrYowxbeYYnFeNk9Z7H3q9kKlFzcasfWBsKhCfOFlOITFUkVBb8A5o+QTrSalhNtbCaRimzo0b+Z80EywlsKi1iszgQAY6xZswqU1MpF9AsjY=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB3947.namprd12.prod.outlook.com (10.255.174.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Wed, 17 Jul 2019 20:44:41 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71%7]) with mapi id 15.20.2073.012; Wed, 17 Jul 2019
 20:44:41 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     Liran Alon <liran.alon@oracle.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v2] KVM: SVM: Fix detection of AMD Errata 1096
Thread-Topic: [PATCH v2] KVM: SVM: Fix detection of AMD Errata 1096
Thread-Index: AQHVPDI1g6HCMGM2X0WzQ9tuOo86XqbPSIEA
Date:   Wed, 17 Jul 2019 20:44:40 +0000
Message-ID: <462d7b68-94c9-2e9b-23f8-bc2567fa62af@amd.com>
References: <20190716235658.18185-1-liran.alon@oracle.com>
In-Reply-To: <20190716235658.18185-1-liran.alon@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0017.namprd05.prod.outlook.com
 (2603:10b6:803:40::30) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f383a7a-1d95-4ebd-28b9-08d70af79741
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB3947;
x-ms-traffictypediagnostic: DM6PR12MB3947:
x-microsoft-antispam-prvs: <DM6PR12MB3947D3B0B52763FB99CA1F6BE5C90@DM6PR12MB3947.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01018CB5B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(199004)(189003)(53936002)(64756008)(66476007)(2201001)(102836004)(316002)(6506007)(386003)(66446008)(66556008)(476003)(7736002)(2616005)(478600001)(31686004)(81166006)(14454004)(4326008)(6486002)(6116002)(31696002)(26005)(99286004)(186003)(86362001)(54906003)(110136005)(66946007)(25786009)(6246003)(76176011)(486006)(52116002)(229853002)(446003)(11346002)(8936002)(6436002)(3846002)(53546011)(36756003)(256004)(14444005)(66066001)(2501003)(68736007)(2906002)(305945005)(71200400001)(6512007)(81156014)(8676002)(5660300002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3947;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5is5XhDXGkx3gKv9VG6cK4eZm1Bvo6Tagt1jtKCqHPqG1K9c/ESNA8EZsM3aaOYEPSupBQ1G/1h+0MS92K7wQj0aaISFofzoSfmM0rssiOJRTqirTupaQyxqM7uim8e4ORDILpIkqqaBOsXcfQDVxCGze4ROICGcZCZHoeW2tPoGF76awSGQn41SD3AeZNm5LYJgKHJlHy7WxWc3S/uLfbIuy2ulWVFK/8HU6En7GiuUukJ1GBJjzSuhbr9AlFUxmdy6DDJfwN7VVbt/9ZQXLscA1AY0Rg44m1oQF5o/BUMkAuJzoGZLyHylzrPA050PewUl9rrTeWZyPn/rSHZ4kDf3NhPlKsNzQznwYCtF6h24DY2u97mAWw7OmtJxT3ADWP3oP3dEB/fkUqLABvR0is4c9EFCTvJcpuuO7rTZV/Y=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D19536ECD0F0694A9951DF26CC73DC61@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f383a7a-1d95-4ebd-28b9-08d70af79741
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2019 20:44:41.1321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3947
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDcvMTYvMTkgNjo1NiBQTSwgTGlyYW4gQWxvbiB3cm90ZToNCj4gQU1EIEVycmF0YSAx
MDk2Og0KPiBXaGVuIENQVSByYWlzZSAjTlBGIG9uIGd1ZXN0IGRhdGEgYWNjZXNzIGFuZCB2Q1BV
IENSNC5TTUFQPTEsIGl0IGlzDQo+IHBvc3NpYmxlIHRoYXQgQ1BVIG1pY3JvY29kZSBpbXBsZW1l
bnRpbmcgRGVjb2RlQXNzaXN0IHdpbGwgZmFpbA0KPiB0byByZWFkIGJ5dGVzIG9mIGluc3RydWN0
aW9uIHdoaWNoIGNhdXNlZCAjTlBGLiBJbiB0aGlzIGNhc2UsDQo+IEd1ZXN0SW50ckJ5dGVzIGZp
ZWxkIG9mIHRoZSBWTUNCIG9uIGEgVk1FWElUIHdpbGwgaW5jb3JyZWN0bHkNCj4gcmV0dXJuIDAg
aW5zdGVhZCBvZiB0aGUgY29ycmVjdCBndWVzdCBpbnN0cnVjdGlvbiBieXRlcy4NCj4gVGhpcyBo
YXBwZW5zIGJlY2F1c2UgQ1BVIG1pY3JvY29kZSByZWFkaW5nIGluc3RydWN0aW9uIGJ5dGVzDQo+
IHVzZXMgYSBzcGVjaWFsIG9wY29kZSB3aGljaCBhdHRlbXB0cyB0byByZWFkIGRhdGEgdXNpbmcg
Q1BMPTANCj4gcHJpdmlsZWRnZXMuIFRoZSBtaWNyb2NvZGUgcmVhZHMgQ1M6UklQIGFuZCBpZiBp
dCBoaXRzIGEgU01BUA0KPiBmYXVsdCwgaXQgZ2l2ZXMgdXAgYW5kIHJldHVybnMgbm8gaW5zdHJ1
Y3Rpb24gYnl0ZXMuDQo+IA0KPiBDdXJyZW50IEtWTSBjb2RlIHdoaWNoIGF0dGVtcHMgdG8gZGV0
ZWN0IGFuZCB3b3JrYXJvdW5kIHRoaXMgZXJyYXRhIGhhdmUNCj4gbXVsdGlwbGUgaXNzdWVzOg0K
PiANCj4gMSkgQ29kZSBtaXN0YWtlbmx5IGNoZWNrcyBpZiB2Q1BVIENSNC5TTUFQPTAgaW5zdGVh
ZCBvZiB2Q1BVIENSNC5TTUFQPTEgd2hpY2gNCj4gaXMgcmVxdWlyZWQgZm9yIGVuY291bnRlcmlu
ZyBhIFNNQVAgZmF1bHQuDQo+IA0KPiAyKSBDb2RlIGFzc3VtZXMgU01BUCBmYXVsdCBjYW4gb25s
eSBvY2N1ciB3aGVuIHZDUFUgQ1BMPT0zLg0KPiBIb3dldmVyLCB0aGUgY29uZGl0aW9uIGZvciBh
IFNNQVAgZmF1bHQgaXMgYSBkYXRhIGFjY2VzcyB3aXRoIENQTDwzDQo+IHRvIGEgcGFnZSBtYXBw
ZWQgaW4gcGFnZS10YWJsZXMgYXMgdXNlci1hY2Nlc3NpYmxlIChpLmUuIFBURSB3aXRoIFUvUw0K
PiBiaXQgc2V0IHRvIDEpLg0KPiBUaGVyZWZvcmUsIGluIGNhc2UgdkNQVSBDUjQuU01FUD0wLCBn
dWVzdCBjYW4gZXhlY3V0ZSBhbiBpbnN0cnVjdGlvbg0KPiB3aGljaCByZXNpZGUgaW4gYSB1c2Vy
LWFjY2Vzc2libGUgcGFnZSB3aXRoIENQTDwzIHByaXZpbGVkZ2UuIElmIHRoaXMNCj4gaW5zdHJ1
Y3Rpb24gcmFpc2UgYSAjTlBGIG9uIGl0J3MgZGF0YSBhY2Nlc3MsIHRoZW4gQ1BVIERlY29kZUFz
c2lzdA0KPiBtaWNyb2NvZGUgd2lsbCBzdGlsbCBlbmNvdW50ZXIgYSBTTUFQIHZpb2xhdGlvbi4N
Cj4gRXZlbiB0aG91Z2ggbm8gc2FuZSBPUyB3aWxsIGRvIHNvIChhcyBpdCdzIGFuIG9idmlvdXMg
cHJpdmlsZWRnZQ0KPiBlc2NhbGF0aW9uIHZ1bG5lcmFiaWxpdHkpLCB3ZSBzdGlsbCBuZWVkIHRv
IGhhbmRsZSB0aGlzIHNlbWFudGljbHkNCj4gY29ycmVjdCBpbiBLVk0gc2lkZS4NCj4gDQo+IEFz
IENSNC5TTUFQPTEgaXMgYW4gZWFzeSB0cmlnZ2VyYWJsZSBjb25kaXRpb24sIGF0dGVtcHQgdG8g
YXZvaWQNCj4gZmFsc2UtcG9zaXRpdmUgb2YgZGV0ZWN0aW5nIGVycmF0YSBieSB0YWtpbmcgbm90
ZSB0aGF0IGluIGNhc2UgdkNQVQ0KPiBDUjQuU01FUD0xLCBlcnJhdGEgY291bGQgb25seSBiZSBl
bmNvdW50ZXJlZCBpbiBjYXNlIENQTD09MyAoQXMNCj4gb3RoZXJ3aXNlLCBDUFUgd291bGQgcmFp
c2UgU01FUCBmYXVsdCB0byBndWVzdCBpbnN0ZWFkIG9mICNOUEYpLg0KPiBUaGlzIGNhbiBiZSBh
IHVzZWZ1bCBjb25kaXRpb24gdG8gYXZvaWQgZmFsc2UtcG9zaXRpdmUgYmVjYXVzZSBndWVzdHMN
Cj4gdXN1YWxseSBlbmFibGUgU01BUCBpZiB0aGV5IGhhdmUgYWxzbyBlbmFibGVkIFNNRVAuDQo+
IA0KPiBJbiBhZGRpdGlvbiwgdG8gYXZvaWQgZnV0dXJlIGNvbmZ1c2lvbiBhbmQgaW1wcm92ZSBj
b2RlIHJlYWRiaWxpdHksDQo+IGNvbW1lbnQgZXJyYXRhIGRldGFpbHMgaW4gY29kZSBhbmQgbm90
IGp1c3QgaW4gY29tbWl0IG1lc3NhZ2UuDQo+IA0KPiBGaXhlczogMDVkNWE0ODYzNTI1ICgiS1ZN
OiBTVk06IFdvcmthcm91bmQgZXJyYXRhIzEwOTYgKGluc25fbGVuIG1heWJlIHplcm8gb24gU01B
UCB2aW9sYXRpb24pIikNCj4gQ2M6IFNpbmdoIEJyaWplc2ggPGJyaWplc2guc2luZ2hAYW1kLmNv
bT4NCj4gQ2M6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4uai5jaHJpc3RvcGhlcnNvbkBpbnRl
bC5jb20+DQo+IENjOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiBSZXZp
ZXdlZC1ieTogQm9yaXMgT3N0cm92c2t5IDxib3Jpcy5vc3Ryb3Zza3lAb3JhY2xlLmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogTGlyYW4gQWxvbiA8bGlyYW4uYWxvbkBvcmFjbGUuY29tPg0KPiAtLS0N
Cj4gICBhcmNoL3g4Ni9rdm0vc3ZtLmMgfCA0MiArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKy0tLS0tLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMzUgaW5zZXJ0aW9ucygrKSwgNyBk
ZWxldGlvbnMoLSkNCj4gDQoNClJldmlld2VkLWJ5OiBCcmlqZXNoIFNpbmdoIDxicmlqZXNoLnNp
bmdoQGFtZC5jb20+DQoNCnRoYW5rcw0K
