Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9BC1300B
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 16:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbfECOZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 10:25:11 -0400
Received: from mail-eopbgr790083.outbound.protection.outlook.com ([40.107.79.83]:27639
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727018AbfECOZK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 10:25:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4drUt1VxrgnzYb+GAwCOyHv7//ZJxO2Rp3FfZlCtCg=;
 b=DkFvteB+aWmCTNmyllLhkZnow2Lr0xFLr5CBw127etknlaSBrv3ndEDH2aalvJZtZNxvkccEMMFx7ToNI2i0m9KP9JErJI1CIXJsAvIyr3pc+VRnMP2AoxTSTk5qxOgxodh+JcLGswZeyT18+IYEGmK/mn0gjVMHAzeDaBgSzT4=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB2777.namprd12.prod.outlook.com (20.176.114.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Fri, 3 May 2019 14:25:06 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::9183:846f:a93e:9a43]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::9183:846f:a93e:9a43%5]) with mapi id 15.20.1835.016; Fri, 3 May 2019
 14:25:06 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 08/10] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Thread-Topic: [RFC PATCH v1 08/10] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Thread-Index: AQHU+rgwAA7BoThJdki7pfNbyU+1kKZO+6UAgAqG2wA=
Date:   Fri, 3 May 2019 14:25:04 +0000
Message-ID: <0f120899-c4fb-724a-00f9-997c362efd37@amd.com>
References: <20190424160942.13567-1-brijesh.singh@amd.com>
 <20190424160942.13567-9-brijesh.singh@amd.com>
 <d31531fe-f01c-817b-06e5-f06b5968b266@amd.com>
In-Reply-To: <d31531fe-f01c-817b-06e5-f06b5968b266@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:805:de::45) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:4a::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c592c6d1-381d-4b49-a489-08d6cfd32267
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB2777;
x-ms-traffictypediagnostic: DM6PR12MB2777:
x-microsoft-antispam-prvs: <DM6PR12MB27777013C2F0934414392017E5350@DM6PR12MB2777.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 0026334A56
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(396003)(136003)(39860400002)(376002)(199004)(189003)(99286004)(229853002)(53936002)(6506007)(2616005)(31686004)(486006)(4326008)(36756003)(66476007)(386003)(256004)(26005)(446003)(186003)(66946007)(64756008)(66446008)(316002)(6486002)(66556008)(73956011)(2501003)(14454004)(476003)(102836004)(53546011)(6436002)(6246003)(52116002)(11346002)(68736007)(14444005)(5660300002)(478600001)(66574012)(76176011)(25786009)(86362001)(110136005)(66066001)(71190400001)(6116002)(8676002)(81156014)(6512007)(8936002)(2906002)(7416002)(3846002)(71200400001)(81166006)(31696002)(54906003)(7736002)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2777;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3YMN5xoWKc5TcyYPQNYRHK49k2lurs9lhFpGqHxvWY1S2V8A5Tz9uWW/ZC+WOscBMwYGO5BXKNphZTBOWiT2fwIzyG5VlqRcwym5VlyrIeJbb7GAwv1kkoQnXUIdeiCG6urcyTQWZShI4A3997FNIt1hZM+kN+As/euJ/NxeIh91mWEPEOWqvX979gVTsNMdPsCSJP11JMswdgBOnyHaT7EsnIgc/KXL5nR8srNsrAvGn4Qf+hr1TC/xabKNlNPwCoG5REs4i1CgA9NI42tQvsI25ZMxXJXT8AXrOoBugIFx7uibumfzVAutjwVIPpzYApu/QGqRjg12abfJvVMHf9K82tVuk4uaruoR93BxXD2cfbkX2jUTEq/9ZQVOs0l/sILilL+O0h25eVgPPwwyNjCL+uT0+E1tTv7AUX7yX6c=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A2799A19F203348B517F04FC0A240B8@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c592c6d1-381d-4b49-a489-08d6cfd32267
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2019 14:25:06.0323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2777
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDQvMjYvMTkgNDozOSBQTSwgTGVuZGFja3ksIFRob21hcyB3cm90ZToNCj4gT24gNC8y
NC8xOSAxMToxMCBBTSwgU2luZ2gsIEJyaWplc2ggd3JvdGU6DQo+PiBUaGUgaHlwZXJjYWxsIGNh
biBiZSB1c2VkIGJ5IHRoZSBTRVYgZ3Vlc3QgdG8gbm90aWZ5IHRoZSBwYWdlIGVuY3J5cHRpb24N
Cj4gDQo+IFRoaXMgaHllcmNhbGwgaXMgdXNlZCBieSB0aGUgU0VWIGd1ZXN0IHRvIG5vdGlmeSBh
IGNoYW5nZSBpbiB0aGUgcGFnZS4uLg0KPiANCj4+IHN0YXR1cyB0byB0aGUgaHlwZXJ2aXNvci4g
VGhlIGh5cGVyY2FsbCBzaG91bGQgYmUgaW52b2tlZCBvbmx5IHdoZW4NCj4+IHRoZSBlbmNyeXB0
aW9uIGF0dHJpYnV0ZSBpcyBjaGFuZ2VkIGZyb20gZW5jcnlwdGVkIC0+IGRlY3J5cHRlZCBhbmQg
dmljZQ0KPj4gdmVyc2EuIEJ5IGRlZmF1bHQgYWxsIHRoZSBndWVzdCBwYWdlcyBzaG91bGQgYmUg
Y29uc2lkZXJlZCBlbmNyeXB0ZWQuDQo+IA0KPiBCeSBkZWZhdWx0IGFsbCBndWVzdCBwYWdlIGFy
ZSBjb25zaWRlcmVkDQo+IA0KPj4NCj4+IENjOiBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRy
b25peC5kZT4NCj4+IENjOiBJbmdvIE1vbG5hciA8bWluZ29AcmVkaGF0LmNvbT4NCj4+IENjOiAi
SC4gUGV0ZXIgQW52aW4iIDxocGFAenl0b3IuY29tPg0KPj4gQ2M6IFBhb2xvIEJvbnppbmkgPHBi
b256aW5pQHJlZGhhdC5jb20+DQo+PiBDYzogIlJhZGltIEtyxI1tw6HFmSIgPHJrcmNtYXJAcmVk
aGF0LmNvbT4NCj4+IENjOiBKb2VyZyBSb2VkZWwgPGpvcm9AOGJ5dGVzLm9yZz4NCj4+IENjOiBC
b3Jpc2xhdiBQZXRrb3YgPGJwQHN1c2UuZGU+DQo+PiBDYzogVG9tIExlbmRhY2t5IDx0aG9tYXMu
bGVuZGFja3lAYW1kLmNvbT4NCj4+IENjOiB4ODZAa2VybmVsLm9yZw0KPj4gQ2M6IGt2bUB2Z2Vy
Lmtlcm5lbC5vcmcNCj4+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBCcmlqZXNoIFNpbmdoIDxicmlqZXNoLnNpbmdoQGFtZC5jb20+DQo+PiAtLS0N
Cj4+ICAgRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2bS9oeXBlcmNhbGxzLnR4dCB8IDE0ICsrKysr
DQo+PiAgIGFyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggICAgICAgICAgfCAgMiArDQo+
PiAgIGFyY2gveDg2L2t2bS9zdm0uYyAgICAgICAgICAgICAgICAgICAgICAgfCA2OSArKysrKysr
KysrKysrKysrKysrKysrKysNCj4+ICAgYXJjaC94ODYva3ZtL3ZteC92bXguYyAgICAgICAgICAg
ICAgICAgICB8ICAxICsNCj4+ICAgYXJjaC94ODYva3ZtL3g4Ni5jICAgICAgICAgICAgICAgICAg
ICAgICB8ICA1ICsrDQo+PiAgIGluY2x1ZGUvdWFwaS9saW51eC9rdm1fcGFyYS5oICAgICAgICAg
ICAgfCAgMSArDQo+PiAgIDYgZmlsZXMgY2hhbmdlZCwgOTIgaW5zZXJ0aW9ucygrKQ0KPj4NCj4+
IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwva3ZtL2h5cGVyY2FsbHMudHh0IGIv
RG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2bS9oeXBlcmNhbGxzLnR4dA0KPj4gaW5kZXggZGEyNGMx
MzhjOGQxLi5lY2Q0NGU0ODg2NzkgMTAwNjQ0DQo+PiAtLS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnR1
YWwva3ZtL2h5cGVyY2FsbHMudHh0DQo+PiArKysgYi9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwva3Zt
L2h5cGVyY2FsbHMudHh0DQo+PiBAQCAtMTQxLDMgKzE0MSwxNyBAQCBhMCBjb3JyZXNwb25kcyB0
byB0aGUgQVBJQyBJRCBpbiB0aGUgdGhpcmQgYXJndW1lbnQgKGEyKSwgYml0IDENCj4+ICAgY29y
cmVzcG9uZHMgdG8gdGhlIEFQSUMgSUQgYTIrMSwgYW5kIHNvIG9uLg0KPj4gICANCj4+ICAgUmV0
dXJucyB0aGUgbnVtYmVyIG9mIENQVXMgdG8gd2hpY2ggdGhlIElQSXMgd2VyZSBkZWxpdmVyZWQg
c3VjY2Vzc2Z1bGx5Lg0KPj4gKw0KPj4gKzcuIEtWTV9IQ19QQUdFX0VOQ19TVEFUVVMNCj4+ICst
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+PiArQXJjaGl0ZWN0dXJlOiB4ODYNCj4+ICtTdGF0
dXM6IGFjdGl2ZQ0KPj4gK1B1cnBvc2U6IE5vdGlmeSB0aGUgZW5jcnlwdGlvbiBzdGF0dXMgY2hh
bmdlcyBpbiBndWVzdCBwYWdlIHRhYmxlIChTRVYgZ3Vlc3QpDQo+PiArDQo+PiArYTA6IHRoZSBn
dWVzdCBwaHlzaWNhbCBhZGRyZXNzIG9mIHRoZSBzdGFydCBwYWdlDQo+PiArYTE6IHRoZSBudW1i
ZXIgb2YgcGFnZXMNCj4+ICthMjogc2V0IG9yIGNsZWFyIHRoZSBlbmNyeXB0aW9uIGF0dHJpYnV0
ZQ0KPiANCj4gYTI6IGVuY3J5cHRpb24gYXR0cmlidXRlDQo+IA0KPj4gKw0KPj4gKyAgIFdoZXJl
Og0KPj4gKwkqIDE6IEVuY3J5cHRpb24gYXR0cmlidXRlIGlzIHNldA0KPj4gKwkqIDA6IEVuY3J5
cHRpb24gYXR0cmlidXRlIGlzIGNsZWFyZWQNCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNs
dWRlL2FzbS9rdm1faG9zdC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPj4g
aW5kZXggYTlkMDNhZjM0MDMwLi5hZGIwY2EwMzViOTcgMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+PiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9r
dm1faG9zdC5oDQo+PiBAQCAtMTE5Niw2ICsxMTk2LDggQEAgc3RydWN0IGt2bV94ODZfb3BzIHsN
Cj4+ICAgCXVpbnQxNl90ICgqbmVzdGVkX2dldF9ldm1jc192ZXJzaW9uKShzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpOw0KPj4gICANCj4+ICAgCWJvb2wgKCpuZWVkX2VtdWxhdGlvbl9vbl9wYWdlX2Zh
dWx0KShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KPj4gKwlpbnQgKCpwYWdlX2VuY19zdGF0dXNf
aGMpKHN0cnVjdCBrdm0gKmt2bSwgdW5zaWduZWQgbG9uZyBncGEsDQo+PiArCQkJCSAgdW5zaWdu
ZWQgbG9uZyBzeiwgdW5zaWduZWQgbG9uZyBtb2RlKTsNCj4+ICAgfTsNCj4+ICAgDQo+PiAgIHN0
cnVjdCBrdm1fYXJjaF9hc3luY19wZiB7DQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3N2
bS5jIGIvYXJjaC94ODYva3ZtL3N2bS5jDQo+PiBpbmRleCA3NGI1N2FiNzQyYWQuLmYwMjRmMjA4
YjA1MiAxMDA2NDQNCj4+IC0tLSBhL2FyY2gveDg2L2t2bS9zdm0uYw0KPj4gKysrIGIvYXJjaC94
ODYva3ZtL3N2bS5jDQo+PiBAQCAtMTM4LDYgKzEzOCw4IEBAIHN0cnVjdCBrdm1fc2V2X2luZm8g
ew0KPj4gICAJaW50IGZkOwkJCS8qIFNFViBkZXZpY2UgZmQgKi8NCj4+ICAgCXVuc2lnbmVkIGxv
bmcgcGFnZXNfbG9ja2VkOyAvKiBOdW1iZXIgb2YgcGFnZXMgbG9ja2VkICovDQo+PiAgIAlzdHJ1
Y3QgbGlzdF9oZWFkIHJlZ2lvbnNfbGlzdDsgIC8qIExpc3Qgb2YgcmVnaXN0ZXJlZCByZWdpb25z
ICovDQo+PiArCXVuc2lnbmVkIGxvbmcgKnBhZ2VfZW5jX2JtYXA7DQo+PiArCXVuc2lnbmVkIGxv
bmcgcGFnZV9lbmNfYm1hcF9zaXplOw0KPj4gICB9Ow0KPj4gICANCj4+ICAgc3RydWN0IGt2bV9z
dm0gew0KPj4gQEAgLTE5MTEsNiArMTkxMyw4IEBAIHN0YXRpYyB2b2lkIHNldl92bV9kZXN0cm95
KHN0cnVjdCBrdm0gKmt2bSkNCj4+ICAgDQo+PiAgIAlzZXZfdW5iaW5kX2FzaWQoa3ZtLCBzZXYt
PmhhbmRsZSk7DQo+PiAgIAlzZXZfYXNpZF9mcmVlKGt2bSk7DQo+PiArDQo+PiArCWt2ZnJlZShz
ZXYtPnBhZ2VfZW5jX2JtYXApOw0KPj4gICB9DQo+PiAgIA0KPj4gICBzdGF0aWMgdm9pZCBhdmlj
X3ZtX2Rlc3Ryb3koc3RydWN0IGt2bSAqa3ZtKQ0KPj4gQEAgLTczNzAsNiArNzM3NCw2OSBAQCBz
dGF0aWMgaW50IHNldl9yZWNlaXZlX2ZpbmlzaChzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1f
c2V2X2NtZCAqYXJncCkNCj4+ICAgCXJldHVybiByZXQ7DQo+PiAgIH0NCj4+ICAgDQo+PiArc3Rh
dGljIGludCBzZXZfcmVzaXplX3BhZ2VfZW5jX2JpdG1hcChzdHJ1Y3Qga3ZtICprdm0sIHVuc2ln
bmVkIGxvbmcgbmV3X3NpemUpDQo+PiArew0KPj4gKwlzdHJ1Y3Qga3ZtX3Nldl9pbmZvICpzZXYg
PSAmdG9fa3ZtX3N2bShrdm0pLT5zZXZfaW5mbzsNCj4+ICsJdW5zaWduZWQgbG9uZyAqbWFwOw0K
Pj4gKwl1bnNpZ25lZCBsb25nIHN6Ow0KPj4gKw0KPj4gKwlpZiAoc2V2LT5wYWdlX2VuY19ibWFw
X3NpemUgPj0gbmV3X3NpemUpDQo+PiArCQlyZXR1cm4gMDsNCj4+ICsNCj4+ICsJc3ogPSBBTElH
TihuZXdfc2l6ZSwgQklUU19QRVJfTE9ORykgLyA4Ow0KPj4gKw0KPj4gKwlpZiAoc3ogPiBQQUdF
X1NJWkUpDQo+PiArCQltYXAgPSB2bWFsbG9jKHN6KTsNCj4+ICsJZWxzZQ0KPj4gKwkJbWFwID0g
a21hbGxvYyhzeiwgR0ZQX0tFUk5FTCk7DQo+IA0KPiBBbnkgcmVhc29uIHRoaXMgY2FuJ3QgYWx3
YXlzIGJlIHZtYWxsb2MoKT8NCj4gDQoNClllcywgd2UgY2FuIHVzZSB2bWFsbG9jKCkgdW5jb25k
aXRpb25hbGx5LiBUaGUgYml0bWFwIHNpemUgd2lsbCBiZQ0KbW9zdGx5IGdyZWF0ZXIgdGhhbiBQ
QUdFX1NJWkUgaGVuY2UgdGhlIGFib3ZlIGlzIHVzZWxlc3MgYW55d2F5Lg0KDQoNCj4+ICsNCj4+
ICsJaWYgKCFtYXApIHsNCj4+ICsJCXByX2Vycl9vbmNlKCJGYWlsZWQgdG8gYWxsb2NhdGUgZGVj
cnlwdGVkIGJpdG1hcCBzaXplICVseFxuIiwgc3opOw0KPj4gKwkJcmV0dXJuIDE7DQo+IA0KPiBT
aG91bGQgdGhpcyBiZSAtRU5PTUVNPw0KPiANCj4+ICsJfQ0KPj4gKw0KPj4gKwkvKiBtYXJrIHRo
ZSBwYWdlIGVuY3J5cHRlZCAoYnkgZGVmYXVsdCkgKi8NCj4+ICsJbWVtc2V0KG1hcCwgMHhmZiwg
c3opOw0KPj4gKw0KPj4gKwliaXRtYXBfY29weShtYXAsIHNldi0+cGFnZV9lbmNfYm1hcCwgc2V2
LT5wYWdlX2VuY19ibWFwX3NpemUpOw0KPj4gKwlrdmZyZWUoc2V2LT5wYWdlX2VuY19ibWFwKTsN
Cj4+ICsNCj4+ICsJc2V2LT5wYWdlX2VuY19ibWFwID0gbWFwOw0KPj4gKwlzZXYtPnBhZ2VfZW5j
X2JtYXBfc2l6ZSA9IG5ld19zaXplOw0KPj4gKw0KPj4gKwlyZXR1cm4gMDsNCj4+ICt9DQo+PiAr
DQo+PiArc3RhdGljIGludCBzdm1fcGFnZV9lbmNfc3RhdHVzX2hjKHN0cnVjdCBrdm0gKmt2bSwg
dW5zaWduZWQgbG9uZyBncGEsDQo+PiArCQkJCSAgdW5zaWduZWQgbG9uZyBucGFnZXMsIHVuc2ln
bmVkIGxvbmcgZW5jKQ0KPj4gK3sNCj4+ICsJc3RydWN0IGt2bV9zZXZfaW5mbyAqc2V2ID0gJnRv
X2t2bV9zdm0oa3ZtKS0+c2V2X2luZm87DQo+PiArCWdmbl90IGdmbl9zdGFydCwgZ2ZuX2VuZDsN
Cj4+ICsJaW50IHI7DQo+IA0KPiBpbnQgcmV0OyA/ICAiciIgYXQgZmlyc3QgY29uZnVzZWQgbWUu
DQoNCg0KSSB3aWxsIGZpeCBpdCBpbiBuZXh0IHJldi4NCg0KDQo+IA0KPj4gKw0KPj4gKwlpZiAo
IW5wYWdlcykNCj4+ICsJCXJldHVybiAwOw0KPj4gKw0KPj4gKwlnZm5fc3RhcnQgPSBncGFfdG9f
Z2ZuKGdwYSk7DQo+PiArCWdmbl9lbmQgPSBnZm5fc3RhcnQgKyBucGFnZXM7DQo+PiArDQo+PiAr
CW11dGV4X2xvY2soJmt2bS0+bG9jayk7DQo+PiArDQo+PiArCXIgPSAxOw0KPj4gKwlpZiAoc2V2
X3Jlc2l6ZV9wYWdlX2VuY19iaXRtYXAoa3ZtLCBnZm5fZW5kKSkNCj4gDQo+IHJldCA9IHNldl9y
ZXNpemVfLi4uDQo+IGlmIChyZXQpDQo+IA0KPj4gKwkJZ290byB1bmxvY2s7DQo+PiArDQo+PiAr
CWlmIChlbmMpDQo+PiArCQlfX2JpdG1hcF9zZXQoc2V2LT5wYWdlX2VuY19ibWFwLCBnZm5fc3Rh
cnQsIGdmbl9lbmQgLSBnZm5fc3RhcnQpOw0KPj4gKwllbHNlDQo+PiArCQlfX2JpdG1hcF9jbGVh
cihzZXYtPnBhZ2VfZW5jX2JtYXAsIGdmbl9zdGFydCwgZ2ZuX2VuZCAtIGdmbl9zdGFydCk7DQo+
PiArDQo+PiArCXIgPSAwOw0KPiANCj4gSWYgeW91IGRvIHRoZSBhYm92ZSwgdGhpcyBpcyBub3Qg
bmVlZGVkLg0KPiANCg0KWWVzIGFncmVlZC4gdGhhbmtzDQo=
