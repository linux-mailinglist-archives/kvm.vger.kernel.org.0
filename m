Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A3171B55
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 17:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbfGWPQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 11:16:54 -0400
Received: from mail-eopbgr820053.outbound.protection.outlook.com ([40.107.82.53]:50592
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726491AbfGWPQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jul 2019 11:16:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tq4lsUMz890bGhhOI29oChJjFMAR/wHz8SZoXzJteA9PaHhwfgc5jpMeO1NTbi1HhHYfVZ6VCkmmRYxM+bERyTU5KmqEIJP7zyjmx7nPJYeHAc1IXa1JLP/VKkV+S+pzYZRCgXv12SmiqhzYrRhGB9seVx9JVeJnJoXZgmbmCWTVHWOFKjAgVYYtG0wCK6Jca6kmbt8SRm0CoFJgRWqtyLiG0P7P5PWuddlm0A2r9R7gnrXsA9jDyhnKIbgYOHLmiWDJgpWDztRGHOVQH1VlIEYe2P0sgv7CWL8yVmsNgMFE8T9jN5bpo93LXIwEpTq708voMUs8jo83I+9d0H4qOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTsBGY/u8GFJyU0Sx+pune5btNrUmE+TYsUZg4pUhmQ=;
 b=hvoybE242CPRmqpOtTsJdJhUR7yLcLBiMRL2fPjK8/L1WKeXvvjPfr1iGCtKatUabDQ1bwgL2ml7qTYgRbAZB0Yh5qwRPEwqIDXjkSflB0ZNpqawbi2W9pDIoFkaP73zM6T4yeOSXO6s8XYEVB6kVMQiSis9TFdHK6feilUXZq6/VpNizRUAHPsEiJi7E0i3AXSQ+kkEauGTR5N0aNRY2JZLKjhTlVftH5Cm9olGJ5KxN0I9653YX44ynn5+Dz0G12LZH6qZUoCj5Z8HuEsnE/WSflgM7DKtWjbGBBXxNOhe/5e77pE0HaMk7uRqY5gmAqseRXWO9Z35uEFqUdjH/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTsBGY/u8GFJyU0Sx+pune5btNrUmE+TYsUZg4pUhmQ=;
 b=JR38mFd7RLqeBeWF6IyTRjZgxsYmSNS4y1LDeDXp2LtU70ePttIQw/SAJrBKllMWS696lODUgRfBlLqz1gquE+UVt7W7bFwL53jzcxDAwrJKjWtA1OHDvMnWAqub0Am5HhGA9gjD03oF9hGk0oSpiEPbT+2KkDg+SYUig5sa4go=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB4252.namprd12.prod.outlook.com (10.141.184.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Tue, 23 Jul 2019 15:16:50 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::7439:ea87:cc5d:71%7]) with mapi id 15.20.2094.017; Tue, 23 Jul 2019
 15:16:50 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     David Rientjes <rientjes@google.com>
CC:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        Cfir Cohen <cfir@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 08/11] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Thread-Topic: [PATCH v3 08/11] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Thread-Index: AQHVN1vkr0vUgqY4y0eLnE4RKbM1dKbVnyeAgALFbAA=
Date:   Tue, 23 Jul 2019 15:16:50 +0000
Message-ID: <8c4e2f4b-0153-3721-a8b3-4842d45cb1bf@amd.com>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
 <20190710201244.25195-9-brijesh.singh@amd.com>
 <alpine.DEB.2.21.1907211354220.58367@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.21.1907211354220.58367@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0201CA0056.namprd02.prod.outlook.com
 (2603:10b6:803:20::18) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d87c455-f880-4af1-ad35-08d70f80c973
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR12MB4252;
x-ms-traffictypediagnostic: DM6PR12MB4252:
x-microsoft-antispam-prvs: <DM6PR12MB42523863AA0EA2D2311D6659E5C70@DM6PR12MB4252.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(199004)(189003)(6916009)(66066001)(186003)(229853002)(6506007)(53546011)(26005)(386003)(486006)(6116002)(3846002)(102836004)(52116002)(31686004)(478600001)(66946007)(66446008)(64756008)(66556008)(66476007)(2906002)(54906003)(76176011)(31696002)(86362001)(81156014)(8676002)(5660300002)(53936002)(25786009)(8936002)(6512007)(81166006)(305945005)(4326008)(256004)(14444005)(7416002)(316002)(6436002)(14454004)(36756003)(6486002)(99286004)(11346002)(7736002)(446003)(2616005)(476003)(6246003)(71200400001)(71190400001)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB4252;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: r/ZdSqxbDRWtJkRj7e15gxzVOafI3ptiN25MtRmIXyqcICZ9NG/tiI/XwQwUe57wcQ8pVrrx+V+OvU/uOIIXM2I4lQzM14qCojTRsf1oIujvpdkS2jbs24HXa7b+ZGJEeALmNPUkMqRE7RF7uUpnz3QqIJqJheRv/WE4S3967C7md9X0wHbU4/lrkkJ7EMUS701j5SY/McA6cQBtYoGzqB/8EpRSc2+jsKCopMwPb+YvSTett6v/FAtlDfJ/BBiV+HJKB4aIDaQ51MCyjLllqeAmWimmqxa8DrBrwklAwcsyPTUJOUONuBgKFZHqmszHrJldbsHEpgvAWjezZXP38lB8DTyOStGBKJ0mG5KNQxz1/luX1v/mZAmLj5tvHbpS1Hb1IGekOKbxmIbhFymZ2JSWVtukbMlTPgWjzOBSipE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A55B952857614E4E800939740809696E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d87c455-f880-4af1-ad35-08d70f80c973
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 15:16:50.7975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4252
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDcvMjEvMTkgMzo1NyBQTSwgRGF2aWQgUmllbnRqZXMgd3JvdGU6DQo+IE9uIFdlZCwg
MTAgSnVsIDIwMTksIFNpbmdoLCBCcmlqZXNoIHdyb3RlOg0KPiANCj4+IGRpZmYgLS1naXQgYS9E
b2N1bWVudGF0aW9uL3ZpcnR1YWwva3ZtL2h5cGVyY2FsbHMudHh0IGIvRG9jdW1lbnRhdGlvbi92
aXJ0dWFsL2t2bS9oeXBlcmNhbGxzLnR4dA0KPj4gaW5kZXggZGEyNGMxMzhjOGQxLi45NGYwNjEx
ZjRkODggMTAwNjQ0DQo+PiAtLS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwva3ZtL2h5cGVyY2Fs
bHMudHh0DQo+PiArKysgYi9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwva3ZtL2h5cGVyY2FsbHMudHh0
DQo+PiBAQCAtMTQxLDMgKzE0MSwxNyBAQCBhMCBjb3JyZXNwb25kcyB0byB0aGUgQVBJQyBJRCBp
biB0aGUgdGhpcmQgYXJndW1lbnQgKGEyKSwgYml0IDENCj4+ICAgY29ycmVzcG9uZHMgdG8gdGhl
IEFQSUMgSUQgYTIrMSwgYW5kIHNvIG9uLg0KPj4gICANCj4+ICAgUmV0dXJucyB0aGUgbnVtYmVy
IG9mIENQVXMgdG8gd2hpY2ggdGhlIElQSXMgd2VyZSBkZWxpdmVyZWQgc3VjY2Vzc2Z1bGx5Lg0K
Pj4gKw0KPj4gKzcuIEtWTV9IQ19QQUdFX0VOQ19TVEFUVVMNCj4+ICstLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tDQo+PiArQXJjaGl0ZWN0dXJlOiB4ODYNCj4+ICtTdGF0dXM6IGFjdGl2ZQ0KPj4g
K1B1cnBvc2U6IE5vdGlmeSB0aGUgZW5jcnlwdGlvbiBzdGF0dXMgY2hhbmdlcyBpbiBndWVzdCBw
YWdlIHRhYmxlIChTRVYgZ3Vlc3QpDQo+PiArDQo+PiArYTA6IHRoZSBndWVzdCBwaHlzaWNhbCBh
ZGRyZXNzIG9mIHRoZSBzdGFydCBwYWdlDQo+PiArYTE6IHRoZSBudW1iZXIgb2YgcGFnZXMNCj4+
ICthMjogZW5jcnlwdGlvbiBhdHRyaWJ1dGUNCj4+ICsNCj4+ICsgICBXaGVyZToNCj4+ICsJKiAx
OiBFbmNyeXB0aW9uIGF0dHJpYnV0ZSBpcyBzZXQNCj4+ICsJKiAwOiBFbmNyeXB0aW9uIGF0dHJp
YnV0ZSBpcyBjbGVhcmVkDQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20va3Zt
X2hvc3QuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCj4+IGluZGV4IDI2ZDFl
YjgzZjcyYS4uYjQ2M2E4MWRjMTc2IDEwMDY0NA0KPj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9h
c20va3ZtX2hvc3QuaA0KPj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0K
Pj4gQEAgLTExOTksNiArMTE5OSw4IEBAIHN0cnVjdCBrdm1feDg2X29wcyB7DQo+PiAgIAl1aW50
MTZfdCAoKm5lc3RlZF9nZXRfZXZtY3NfdmVyc2lvbikoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsN
Cj4+ICAgDQo+PiAgIAlib29sICgqbmVlZF9lbXVsYXRpb25fb25fcGFnZV9mYXVsdCkoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1KTsNCj4+ICsJaW50ICgqcGFnZV9lbmNfc3RhdHVzX2hjKShzdHJ1Y3Qg
a3ZtICprdm0sIHVuc2lnbmVkIGxvbmcgZ3BhLA0KPj4gKwkJCQkgIHVuc2lnbmVkIGxvbmcgc3os
IHVuc2lnbmVkIGxvbmcgbW9kZSk7DQo+PiAgIH07DQo+PiAgIA0KPj4gICBzdHJ1Y3Qga3ZtX2Fy
Y2hfYXN5bmNfcGYgew0KPj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9zdm0uYyBiL2FyY2gv
eDg2L2t2bS9zdm0uYw0KPj4gaW5kZXggMzA4OTk0MmY2NjMwLi40MzE3MTgzMDkzNTkgMTAwNjQ0
DQo+PiAtLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtLmMNCj4+ICsrKyBiL2FyY2gveDg2L2t2bS9zdm0u
Yw0KPj4gQEAgLTEzNSw2ICsxMzUsOCBAQCBzdHJ1Y3Qga3ZtX3Nldl9pbmZvIHsNCj4+ICAgCWlu
dCBmZDsJCQkvKiBTRVYgZGV2aWNlIGZkICovDQo+PiAgIAl1bnNpZ25lZCBsb25nIHBhZ2VzX2xv
Y2tlZDsgLyogTnVtYmVyIG9mIHBhZ2VzIGxvY2tlZCAqLw0KPj4gICAJc3RydWN0IGxpc3RfaGVh
ZCByZWdpb25zX2xpc3Q7ICAvKiBMaXN0IG9mIHJlZ2lzdGVyZWQgcmVnaW9ucyAqLw0KPj4gKwl1
bnNpZ25lZCBsb25nICpwYWdlX2VuY19ibWFwOw0KPj4gKwl1bnNpZ25lZCBsb25nIHBhZ2VfZW5j
X2JtYXBfc2l6ZTsNCj4+ICAgfTsNCj4+ICAgDQo+PiAgIHN0cnVjdCBrdm1fc3ZtIHsNCj4+IEBA
IC0xOTEwLDYgKzE5MTIsOCBAQCBzdGF0aWMgdm9pZCBzZXZfdm1fZGVzdHJveShzdHJ1Y3Qga3Zt
ICprdm0pDQo+PiAgIA0KPj4gICAJc2V2X3VuYmluZF9hc2lkKGt2bSwgc2V2LT5oYW5kbGUpOw0K
Pj4gICAJc2V2X2FzaWRfZnJlZShrdm0pOw0KPj4gKw0KPj4gKwlrdmZyZWUoc2V2LT5wYWdlX2Vu
Y19ibWFwKTsNCj4+ICAgfQ0KPj4gICANCj4+ICAgc3RhdGljIHZvaWQgYXZpY192bV9kZXN0cm95
KHN0cnVjdCBrdm0gKmt2bSkNCj4gDQo+IEFkZGluZyBDZmlyIHdobyBmbGFnZ2VkIHRoaXMga3Zm
cmVlKCkuDQo+IA0KPiBPdGhlciBmcmVlaW5nIG9mIHNldi0+cGFnZV9lbmNfYm1hcCBpbiB0aGlz
IHBhdGNoIGFsc28gc2V0DQo+IHNldi0+cGFnZV9lbmNfYm1hcF9zaXplIHRvIDAgYW5kIG5laXRo
ZXIgc2V0IHNldi0+cGFnZV9lbmNfYm1hcCB0byBOVUxMDQo+IGFmdGVyIGZyZWVpbmcgaXQuDQo+
IA0KPiBGb3IgZXh0cmEgc2FmZXR5LCBpcyBpdCBwb3NzaWJsZSB0byBzZXYtPnBhZ2VfZW5jX2Jt
YXAgPSBOVUxMIGFueXRpbWUgdGhlDQo+IGJpdG1hcCBpcyBrdmZyZWVkPw0KPiANCg0KR29vZCBj
YXRjaCwgSSdsbCBmaXggaXQgaW4gbmV4dCByZXYuDQoNCj4+IEBAIC0yMDg0LDYgKzIwODgsNyBA
QCBzdGF0aWMgdm9pZCBhdmljX3NldF9ydW5uaW5nKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgYm9v
bCBpc19ydW4pDQo+PiAgIA0KPj4gICBzdGF0aWMgdm9pZCBzdm1fdmNwdV9yZXNldChzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUsIGJvb2wgaW5pdF9ldmVudCkNCj4+ICAgew0KPj4gKwlzdHJ1Y3Qga3Zt
X3Nldl9pbmZvICpzZXYgPSAmdG9fa3ZtX3N2bSh2Y3B1LT5rdm0pLT5zZXZfaW5mbzsNCj4+ICAg
CXN0cnVjdCB2Y3B1X3N2bSAqc3ZtID0gdG9fc3ZtKHZjcHUpOw0KPj4gICAJdTMyIGR1bW15Ow0K
Pj4gICAJdTMyIGVheCA9IDE7DQo+PiBAQCAtMjEwNSw2ICsyMTEwLDEyIEBAIHN0YXRpYyB2b2lk
IHN2bV92Y3B1X3Jlc2V0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgYm9vbCBpbml0X2V2ZW50KQ0K
Pj4gICANCj4+ICAgCWlmIChrdm1fdmNwdV9hcGljdl9hY3RpdmUodmNwdSkgJiYgIWluaXRfZXZl
bnQpDQo+PiAgIAkJYXZpY191cGRhdGVfdmFwaWNfYmFyKHN2bSwgQVBJQ19ERUZBVUxUX1BIWVNf
QkFTRSk7DQo+PiArDQo+PiArCS8qIHJlc2V0IHRoZSBwYWdlIGVuY3J5cHRpb24gYml0bWFwICov
DQo+PiArCWlmIChzZXZfZ3Vlc3QodmNwdS0+a3ZtKSkgew0KPj4gKwkJa3ZmcmVlKHNldi0+cGFn
ZV9lbmNfYm1hcCk7DQo+PiArCQlzZXYtPnBhZ2VfZW5jX2JtYXBfc2l6ZSA9IDA7DQo+PiArCX0N
Cj4+ICAgfQ0KPj4gICANCj4+ICAgc3RhdGljIGludCBhdmljX2luaXRfdmNwdShzdHJ1Y3QgdmNw
dV9zdm0gKnN2bSkNCj4gDQo+IFdoYXQgaXMgcHJvdGVjdGluZyBzZXYtPnBhZ2VfZW5jX2JtYXAg
YW5kIHNldi0+cGFnZV9lbmNfYm1hcF9zaXplIGluIGNhbGxzDQo+IHRvIHN2bV92Y3B1X3Jlc2V0
KCk/DQo+IA0KDQpZZXMsIGl0IG5lZWQgdG8gYmUgcHJvdGVjdGVkIHdpdGggdm0gbG9jay4gSSB3
aWxsIGZpeCBpdCBpbiBuZXh0IHJldi4NCkFkZGl0aW9uYWxseSwgSSB0aGluayB3aGF0IEkgaGF2
ZSBoZXJlIGlzIHdyb25nLCB3ZSBuZWVkIHRvIHJlc2V0IHRoZQ0KYml0bWFwIG9ubHkgd2hlbiBi
c3AgaXMgZ2V0dGluZyByZXNldC4NCg0KLUJyaWplc2gNCg==
