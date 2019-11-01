Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50D42EC8F9
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 20:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfKATU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 15:20:27 -0400
Received: from mail-eopbgr790088.outbound.protection.outlook.com ([40.107.79.88]:5088
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727473AbfKATU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 15:20:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MhZJkwEKgy+MaFPKc2TXdMoh4yo1GlPdV5XtBujAmI5k04lZItsZR1JQx482HmC3ClUmR/E7XMXrtuwqXD/puQFmuthqlG8EujzEtxxrN/J2WNMwJZW67NwNQf3XHjntAYtGwlMFFqGb2+I9qC+sX5S5W2vtHP6DuSy6OQSC4RihBFkDJCNyCP+7NVS1pZ5TqxwXo4Orn49AJoXRPDU/HjofChxPe0CGLkBxIu7azsy3rw3hBl2Lka3WYY+gCjSKqiLgkhHD4Faf7QZjfo+r9w+vVzHl6kTx83lGUnXwaIeeb32U35/ktpju8JjK4zwe1lqr22+QjPY/I+SRxLwUaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/R5moK+DnQnVpkiCBxjLl3gSdBYV1gu5KkOxZk+JDlw=;
 b=eEftBnUuZshO8Pfw+mTzisVnep+L9ltyk2LpSB8MJXsqH1+NtS3IzaPavko/5uMJWJzBSMdZWT71n5u2BXNzV0EQd8r1qQTuhe7J0Whrv5bFQgmjJ0SYmyIyFoYallWE/kCXbiAl6dfUpUMrJpodo3UfMHirgVMUSO6sMXtSFGtTKlaKbXkK9/xjYhRXRKo8X8cvHIpV8pce2ivChK6ms0Db9hHR5UXkliWfRRK7HkVM2LHJj9KkUOxZpWf4ArsHcBshgJJwqLyY8xTbr3+7HqA2F1RfeO96fAZYKxUCV5XfHvxpVSg2aL/TsViaqkAZPtFt3pucrq1s5DXokfs7pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/R5moK+DnQnVpkiCBxjLl3gSdBYV1gu5KkOxZk+JDlw=;
 b=36FlxnRcteKIYk1UJQ3QWupvZrLnOalQXoVrRgJrU68jzDT6RhvT3ylb6RZIEA3/6QrzTGVBEWQBTMJDx3fHeKB8hClMIeErj9QQJqhz0vPhwuKL6MEppPuBb2J7MyYxef3WpeM1IFhiMXrKj7Cob4bszzAaKvcpdjWpa1tZgjY=
Received: from BL0PR12MB2468.namprd12.prod.outlook.com (52.132.30.157) by
 BL0PR12MB2417.namprd12.prod.outlook.com (52.132.31.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Fri, 1 Nov 2019 19:20:21 +0000
Received: from BL0PR12MB2468.namprd12.prod.outlook.com
 ([fe80::748c:1f32:1a4d:acca]) by BL0PR12MB2468.namprd12.prod.outlook.com
 ([fe80::748c:1f32:1a4d:acca%7]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 19:20:21 +0000
From:   "Moger, Babu" <Babu.Moger@amd.com>
To:     Jim Mattson <jmattson@google.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
Thread-Topic: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
Thread-Index: AQHVkNqD+3M/4HqTrkKsDppH5BsZ1qd2otoAgAAOPIA=
Date:   Fri, 1 Nov 2019 19:20:21 +0000
Message-ID: <669031a1-b9a6-8a45-9a05-a6ce5fb7fa8b@amd.com>
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
 <157262962352.2838.15656190309312238595.stgit@naples-babu.amd.com>
 <CALMp9eQT=a99YhraQZ+awMKOWK=3tg=m9NppZnsvK0Q1PWxbAw@mail.gmail.com>
In-Reply-To: <CALMp9eQT=a99YhraQZ+awMKOWK=3tg=m9NppZnsvK0Q1PWxbAw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR04CA0046.namprd04.prod.outlook.com
 (2603:10b6:805:2a::23) To BL0PR12MB2468.namprd12.prod.outlook.com
 (2603:10b6:207:44::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ebf33a11-c35b-42d0-b43d-08d75f0089ea
x-ms-traffictypediagnostic: BL0PR12MB2417:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <BL0PR12MB24175C0AF2734F6582C3242A95620@BL0PR12MB2417.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(376002)(346002)(199004)(189003)(6306002)(316002)(14444005)(486006)(446003)(966005)(11346002)(52116002)(386003)(2616005)(31686004)(76176011)(476003)(53546011)(478600001)(6486002)(6506007)(6512007)(36756003)(6436002)(99286004)(256004)(26005)(6116002)(31696002)(25786009)(7416002)(7736002)(86362001)(229853002)(6916009)(66066001)(54906003)(14454004)(4326008)(71190400001)(8676002)(81166006)(186003)(81156014)(3846002)(66476007)(66446008)(305945005)(64756008)(6246003)(5660300002)(2906002)(66556008)(66946007)(8936002)(102836004)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR12MB2417;H:BL0PR12MB2468.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TvDHBMSFZbSiHEB1F5QYAIFZkT487F27L4xBZvbVbfxTnaScxiGNkQa37QqEImT0LbClpxWUJ7bydzhNevXh4FnbdjRZXYrXQvG+vKZnMJqCyAnERCXdy2YQskPQqelDJ66vKkyKl8HchUdQWw/o7g5jkyWvQ4u83xvPp+YwBQRHncAQ87PcTDcgwlaj7hgqqNmrE+noMZhafxbwlYi36MgTRhFX97LsB/ll0M1ClCT3b3c+ZP7joVMq8AhatBk9F4o5kJbr30XBXszVySawwsYCzyUhGfRhOxVjUlFe6gBO6xNMeZal/PoGPJOYsBnGmyQ5M8+0P53uX9rTqytZ4kX7KSZLfNCIZ+AfR1y6jVR+Wy5MA7fcErCxKjZBYCcELyZcRsimvqKm2s2BuRtm3YlRayHostPzZLH1CWjLzPLAbPZ3nxXQeEeyIKfYlR3GYrC+PqnMrMMpgLb5zKw8DjVsmlkFjqVyq24XFYuamog=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC20B573BEC9534991B7EE959C516205@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebf33a11-c35b-42d0-b43d-08d75f0089ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 19:20:21.7171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 530wwO3AtG7QlTHcRGYsP8iEuPY2bCSpXn1eGs/mST+/hWM6vxyqsGSjPtGCMOCG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2417
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDExLzEvMTkgMToyOSBQTSwgSmltIE1hdHRzb24gd3JvdGU6DQo+IE9uIEZyaSwgTm92
IDEsIDIwMTkgYXQgMTA6MzMgQU0gTW9nZXIsIEJhYnUgPEJhYnUuTW9nZXJAYW1kLmNvbT4gd3Jv
dGU6DQo+Pg0KPj4gQU1EIDJuZCBnZW5lcmF0aW9uIEVQWUMgcHJvY2Vzc29ycyBzdXBwb3J0IFVN
SVAgKFVzZXItTW9kZSBJbnN0cnVjdGlvbg0KPj4gUHJldmVudGlvbikgZmVhdHVyZS4gVGhlIFVN
SVAgZmVhdHVyZSBwcmV2ZW50cyB0aGUgZXhlY3V0aW9uIG9mIGNlcnRhaW4NCj4+IGluc3RydWN0
aW9ucyBpZiB0aGUgQ3VycmVudCBQcml2aWxlZ2UgTGV2ZWwgKENQTCkgaXMgZ3JlYXRlciB0aGFu
IDAuDQo+PiBJZiBhbnkgb2YgdGhlc2UgaW5zdHJ1Y3Rpb25zIGFyZSBleGVjdXRlZCB3aXRoIENQ
TCA+IDAgYW5kIFVNSVANCj4+IGlzIGVuYWJsZWQsIHRoZW4ga2VybmVsIHJlcG9ydHMgYSAjR1Ag
ZXhjZXB0aW9uLg0KPj4NCj4+IFRoZSBpZGVhIGlzIHRha2VuIGZyb20gYXJ0aWNsZXM6DQo+PiBo
dHRwczovL2x3bi5uZXQvQXJ0aWNsZXMvNzM4MjA5Lw0KPj4gaHR0cHM6Ly9sd24ubmV0L0FydGlj
bGVzLzY5NDM4NS8NCj4+DQo+PiBFbmFibGUgdGhlIGZlYXR1cmUgaWYgc3VwcG9ydGVkIG9uIGJh
cmUgbWV0YWwgYW5kIGVtdWxhdGUgaW5zdHJ1Y3Rpb25zDQo+PiB0byByZXR1cm4gZHVtbXkgdmFs
dWVzIGZvciBjZXJ0YWluIGNhc2VzLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEJhYnUgTW9nZXIg
PGJhYnUubW9nZXJAYW1kLmNvbT4NCj4+IC0tLQ0KPj4gIGFyY2gveDg2L2t2bS9zdm0uYyB8ICAg
MjEgKysrKysrKysrKysrKysrKy0tLS0tDQo+PiAgMSBmaWxlIGNoYW5nZWQsIDE2IGluc2VydGlv
bnMoKyksIDUgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9z
dm0uYyBiL2FyY2gveDg2L2t2bS9zdm0uYw0KPj4gaW5kZXggNDE1M2NhOGNkZGI3Li43OWFiYmRl
Y2ExNDggMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtLmMNCj4+ICsrKyBiL2FyY2gv
eDg2L2t2bS9zdm0uYw0KPj4gQEAgLTI1MzMsNiArMjUzMywxMSBAQCBzdGF0aWMgdm9pZCBzdm1f
ZGVjYWNoZV9jcjRfZ3Vlc3RfYml0cyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+PiAgew0KPj4g
IH0NCj4+DQo+PiArc3RhdGljIGJvb2wgc3ZtX3VtaXBfZW11bGF0ZWQodm9pZCkNCj4+ICt7DQo+
PiArICAgICAgIHJldHVybiBib290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfVU1JUCk7DQo+PiArfQ0K
PiANCj4gVGhpcyBtYWtlcyBubyBzZW5zZSB0byBtZS4gSWYgdGhlIGhhcmR3YXJlIGFjdHVhbGx5
IHN1cHBvcnRzIFVNSVAsDQo+IHRoZW4gaXQgZG9lc24ndCBoYXZlIHRvIGJlIGVtdWxhdGVkLg0K
TXkgdW5kZXJzdGFuZGluZy4uDQoNCklmIHRoZSBoYXJkd2FyZSBzdXBwb3J0cyB0aGUgVU1JUCwg
aXQgd2lsbCBnZW5lcmF0ZSB0aGUgI0dQIGZhdWx0IHdoZW4NCnRoZXNlIGluc3RydWN0aW9ucyBh
cmUgZXhlY3V0ZWQgYXQgQ1BMID4gMC4gUHVycG9zZSBvZiB0aGUgZW11bGF0aW9uIGlzIHRvDQp0
cmFwIHRoZSBHUCBhbmQgcmV0dXJuIGEgZHVtbXkgdmFsdWUuIFNlZW1zIGxpa2UgdGhpcyByZXF1
aXJlZCBpbiBjZXJ0YWluDQpsZWdhY3kgT1NlcyBydW5uaW5nIGluIHByb3RlY3RlZCBhbmQgdmly
dHVhbC04MDg2IG1vZGVzLiBJbiBsb25nIG1vZGUgbm8NCm5lZWQgdG8gZW11bGF0ZS4gSGVyZSBp
cyB0aGUgYml0IGV4cGxhbmF0aW9uIGh0dHBzOi8vbHduLm5ldC9BcnRpY2xlcy83MzgyMDkvDQoN
CklmIHdlIGRvbid0IGNhcmUgYWJvdXQgdGhvc2UgbGVnYWN5IGNhc2VzIHdlIGRvbid0IG5lZWQg
dG8gZW11bGF0ZS4NCg0KPiANCj4gVG8gdGhlIGV4dGVudCB0aGF0IGt2bSBlbXVsYXRlcyBVTUlQ
IG9uIEludGVsIENQVXMgd2l0aG91dCBoYXJkd2FyZQ0KPiBVTUlQIChpLmUuIHNtc3cgaXMgc3Rp
bGwgYWxsb3dlZCBhdCBDUEw+MCksIHdlIGNhbiBhbHdheXMgZG8gdGhlIHNhbWUNCj4gZW11bGF0
aW9uIG9uIEFNRCwgYmVjYXVzZSBTVk0gaGFzIGFsd2F5cyBvZmZlcmVkIGludGVyY2VwdHMgb2Yg
c2dkdCwNCj4gc2lkdCwgc2xkdCwgYW5kIHN0ci4gU28sIGlmIHlvdSByZWFsbHkgd2FudCB0byBv
ZmZlciB0aGlzIGVtdWxhdGlvbiBvbg0KPiBwcmUtRVBZQyAyIENQVXMsIHRoaXMgZnVuY3Rpb24g
c2hvdWxkIGp1c3QgcmV0dXJuIHRydWUuIEJ1dCwgSSBoYXZlIHRvDQo+IGFzaywgIndoeT8iDQoN
Cg0KVHJ5aW5nIHRvIHN1cHBvcnQgVU1JUCBmZWF0dXJlIG9ubHkgb24gRVBZQyAyIGhhcmR3YXJl
LiBObyBpbnRlbnRpb24gdG8NCnN1cHBvcnQgcHJlLUVQWUMgMi4NCg0KPiANCj4gKlZpcnR1YWxp
emF0aW9uKiBvZiBVTUlQIG9uIEVQWUMgMiBhbHJlYWR5IHdvcmtzIHdpdGhvdXQgYW55IG9mIHRo
ZXNlIGNoYW5nZXMuDQo+IA0KPj4gIHN0YXRpYyB2b2lkIHVwZGF0ZV9jcjBfaW50ZXJjZXB0KHN0
cnVjdCB2Y3B1X3N2bSAqc3ZtKQ0KPj4gIHsNCj4+ICAgICAgICAgdWxvbmcgZ2NyMCA9IHN2bS0+
dmNwdS5hcmNoLmNyMDsNCj4+IEBAIC00NDM4LDYgKzQ0NDMsMTMgQEAgc3RhdGljIGludCBpbnRl
cnJ1cHRfd2luZG93X2ludGVyY2VwdGlvbihzdHJ1Y3QgdmNwdV9zdm0gKnN2bSkNCj4+ICAgICAg
ICAgcmV0dXJuIDE7DQo+PiAgfQ0KPj4NCj4+ICtzdGF0aWMgaW50IHVtaXBfaW50ZXJjZXB0aW9u
KHN0cnVjdCB2Y3B1X3N2bSAqc3ZtKQ0KPj4gK3sNCj4+ICsgICAgICAgc3RydWN0IGt2bV92Y3B1
ICp2Y3B1ID0gJnN2bS0+dmNwdTsNCj4+ICsNCj4+ICsgICAgICAgcmV0dXJuIGt2bV9lbXVsYXRl
X2luc3RydWN0aW9uKHZjcHUsIDApOw0KPj4gK30NCj4+ICsNCj4+ICBzdGF0aWMgaW50IHBhdXNl
X2ludGVyY2VwdGlvbihzdHJ1Y3QgdmNwdV9zdm0gKnN2bSkNCj4+ICB7DQo+PiAgICAgICAgIHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSA9ICZzdm0tPnZjcHU7DQo+PiBAQCAtNDc3NSw2ICs0Nzg3LDEw
IEBAIHN0YXRpYyBpbnQgKCpjb25zdCBzdm1fZXhpdF9oYW5kbGVyc1tdKShzdHJ1Y3QgdmNwdV9z
dm0gKnN2bSkgPSB7DQo+PiAgICAgICAgIFtTVk1fRVhJVF9TTUldICAgICAgICAgICAgICAgICAg
ICAgICAgICA9IG5vcF9vbl9pbnRlcmNlcHRpb24sDQo+PiAgICAgICAgIFtTVk1fRVhJVF9JTklU
XSAgICAgICAgICAgICAgICAgICAgICAgICA9IG5vcF9vbl9pbnRlcmNlcHRpb24sDQo+PiAgICAg
ICAgIFtTVk1fRVhJVF9WSU5UUl0gICAgICAgICAgICAgICAgICAgICAgICA9IGludGVycnVwdF93
aW5kb3dfaW50ZXJjZXB0aW9uLA0KPj4gKyAgICAgICBbU1ZNX0VYSVRfSURUUl9SRUFEXSAgICAg
ICAgICAgICAgICAgICAgPSB1bWlwX2ludGVyY2VwdGlvbiwNCj4+ICsgICAgICAgW1NWTV9FWElU
X0dEVFJfUkVBRF0gICAgICAgICAgICAgICAgICAgID0gdW1pcF9pbnRlcmNlcHRpb24sDQo+PiAr
ICAgICAgIFtTVk1fRVhJVF9MRFRSX1JFQURdICAgICAgICAgICAgICAgICAgICA9IHVtaXBfaW50
ZXJjZXB0aW9uLA0KPj4gKyAgICAgICBbU1ZNX0VYSVRfVFJfUkVBRF0gICAgICAgICAgICAgICAg
ICAgICAgPSB1bWlwX2ludGVyY2VwdGlvbiwNCj4+ICAgICAgICAgW1NWTV9FWElUX1JEUE1DXSAg
ICAgICAgICAgICAgICAgICAgICAgID0gcmRwbWNfaW50ZXJjZXB0aW9uLA0KPj4gICAgICAgICBb
U1ZNX0VYSVRfQ1BVSURdICAgICAgICAgICAgICAgICAgICAgICAgPSBjcHVpZF9pbnRlcmNlcHRp
b24sDQo+PiAgICAgICAgIFtTVk1fRVhJVF9JUkVUXSAgICAgICAgICAgICAgICAgICAgICAgICA9
IGlyZXRfaW50ZXJjZXB0aW9uLA0KPj4gQEAgLTU5NzYsMTEgKzU5OTIsNiBAQCBzdGF0aWMgYm9v
bCBzdm1feHNhdmVzX3N1cHBvcnRlZCh2b2lkKQ0KPj4gICAgICAgICByZXR1cm4gYm9vdF9jcHVf
aGFzKFg4Nl9GRUFUVVJFX1hTQVZFUyk7DQo+PiAgfQ0KPj4NCj4+IC1zdGF0aWMgYm9vbCBzdm1f
dW1pcF9lbXVsYXRlZCh2b2lkKQ0KPj4gLXsNCj4+IC0gICAgICAgcmV0dXJuIGZhbHNlOw0KPj4g
LX0NCj4+IC0NCj4+ICBzdGF0aWMgYm9vbCBzdm1fcHRfc3VwcG9ydGVkKHZvaWQpDQo+PiAgew0K
Pj4gICAgICAgICByZXR1cm4gZmFsc2U7DQo+Pg0K
