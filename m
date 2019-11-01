Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEF7EC954
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 21:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfKAUEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 16:04:20 -0400
Received: from mail-eopbgr790041.outbound.protection.outlook.com ([40.107.79.41]:36055
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726709AbfKAUEU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 16:04:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=guGQyvQwphYG7fyi1B7aeh6jM7Yp9xQZDOoja5nWqplM1ZgkcxYvz/mCQnizX/DUAUVPHSt2qKB9GVcmohEvxBlQY+5qFOluf2LYoNiwMpERqRx3wfLfNXMambCH8vIz/ViJUEcqRxtAgP+1gRLamWiObhp0UOFgk0kPvRO8+ATZSp4aRQh1zjKsgXXSQ3udrA+boIuv7WaoyZ/jSaI5pwT5fB2RtMcl3v7M3SP4fzxNraDslPS0S5XUBo8AaSUVSIpG+5WJLKigeXB6q9TbqAzmSZUkCe7dNnS8FHcm4454sm6AWdN5drJTuGt6cDnKbL1HWEqyLs/eX8Eugk5RlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8wDkdP/KDt9U856s3zw4MYP+UYCRzLgJZbrMfhF7D4=;
 b=VSfONP24rra1G310Cl6O4wns5xLVe76RN542XME1Xm0PT0fUjZhFnQabDHrUjOsJTxcowK6KdgD8zi03ll2+VdrYG18L9Y8GOkhsbtFH6KsgZXR/WNlXeMm0Xe5QTtcaMhlCFsgvYDyoQnOdQYlIV+JAbzOerup7DddfBqlv6TWAtOArpKeLn/gUslHtLVoiMluSxVis9adlWDSX6knsy8i2FeHqc6bAOdJ+/rNjmOcX4Y2LZaVkgBq1eoy70VQgs+D+v9UNJy7f5PdGElj8ViUTa83gmuLuxInRKqsRyXk15lhK5Pn+MKi0u/sqQX4fti3jP+qj9bhq0XGVTuzFow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8wDkdP/KDt9U856s3zw4MYP+UYCRzLgJZbrMfhF7D4=;
 b=Zw8AvEe/LhempXsr5Vry9ZUxxJ7MvgbvKiIMIzLDQvpp+Wq5JGmxuQ0mMjV77IOZhc/OZYmLttcUlMCJPvqXC/ihEAh8yVSEQ7xadVrp9yi8Bj2kTkiICezgNZ02xAquzAMn6KoEmpCCtr8zgQVWcwR1+EOSzhJ+fCs3TgXRzgs=
Received: from BL0PR12MB2468.namprd12.prod.outlook.com (52.132.30.157) by
 BL0PR12MB2371.namprd12.prod.outlook.com (52.132.27.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 20:04:15 +0000
Received: from BL0PR12MB2468.namprd12.prod.outlook.com
 ([fe80::748c:1f32:1a4d:acca]) by BL0PR12MB2468.namprd12.prod.outlook.com
 ([fe80::748c:1f32:1a4d:acca%7]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 20:04:15 +0000
From:   "Moger, Babu" <Babu.Moger@amd.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Jim Mattson <jmattson@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
Thread-Topic: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
Thread-Index: AQHVkNqD+3M/4HqTrkKsDppH5BsZ1qd2otoA//+6a4CAAFUPgIAACwUA
Date:   Fri, 1 Nov 2019 20:04:15 +0000
Message-ID: <91a05d64-36c0-c4c4-fe49-83a4db1ade10@amd.com>
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
 <157262962352.2838.15656190309312238595.stgit@naples-babu.amd.com>
 <CALMp9eQT=a99YhraQZ+awMKOWK=3tg=m9NppZnsvK0Q1PWxbAw@mail.gmail.com>
 <669031a1-b9a6-8a45-9a05-a6ce5fb7fa8b@amd.com>
 <CALCETrXdo2arN=s9Bt1LmYkPajcBj1NuTPC8dwuw2mMZqT0tRw@mail.gmail.com>
In-Reply-To: <CALCETrXdo2arN=s9Bt1LmYkPajcBj1NuTPC8dwuw2mMZqT0tRw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR01CA0008.prod.exchangelabs.com (2603:10b6:805:b6::21)
 To BL0PR12MB2468.namprd12.prod.outlook.com (2603:10b6:207:44::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8b9453c6-95c7-4a62-7d2a-08d75f06abb1
x-ms-traffictypediagnostic: BL0PR12MB2371:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <BL0PR12MB23716968BB2EF2CB73C4178995620@BL0PR12MB2371.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(54534003)(189003)(199004)(81166006)(81156014)(8676002)(478600001)(229853002)(6436002)(14454004)(6246003)(6486002)(64756008)(25786009)(26005)(54906003)(6306002)(8936002)(99286004)(66946007)(4326008)(66476007)(66556008)(316002)(966005)(386003)(36756003)(6506007)(53546011)(52116002)(102836004)(76176011)(31686004)(71200400001)(186003)(6512007)(66446008)(7736002)(6916009)(66066001)(305945005)(2906002)(86362001)(486006)(256004)(5660300002)(7416002)(3846002)(2616005)(476003)(6116002)(11346002)(446003)(31696002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR12MB2371;H:BL0PR12MB2468.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dPVkRepFg4Peol5Y2Y4LdWv0wbBC+x8tFQGop6aC8ZnTqtuRoeW3ATIWnIFqFJi00XTeIbIgG6VhYGh7fWPIid/fGQLD4FCM3yRO7Jn9V8WziifvBpaNlPf3YF3tSPgOkuKX+Ru2kG2XiOOA1c1BkMnmXB9CKP2JJY2Nk5HTpuCQC57nQBQj5oeet0IVUkis7MEPxjasnrx6jrwOTB/A2rnRtCLB/I43mp4lUNAYX2b5lOPT/H0cijy2uo5Tj+sQAzuGconzVm0lYxOdwGWhsIB88nJN/YNnu4jxrrV/YgMvtN5w3ZIoJLXsTH7eSJaVXc/GZoW/WS/Hv9am5jA9eld8Tq3cgXb2CW0T6YksTkp62L2cizvXELsJ75AOnwsqocnher8AiVOGu6/shpBK3GQfX6fn25AKvP3x6sWsL7cuPzlLXQikAs6dMuZe/0SyOvs0qjd44RteV5LWgYuM27bTBukkW/LQKApTgcy4CLk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D207B20A2FC497499AF29652E29CBC24@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b9453c6-95c7-4a62-7d2a-08d75f06abb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 20:04:15.4401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zoKBIFZfCm/UP3cOo7+7N1B55tZKDw1e7damYTT7+ielzdIerrriW4Ew3szLtdMu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2371
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCk9uIDExLzEvMTkgMjoyNCBQTSwgQW5keSBMdXRvbWlyc2tpIHdyb3RlOg0KPiBPbiBGcmks
IE5vdiAxLCAyMDE5IGF0IDEyOjIwIFBNIE1vZ2VyLCBCYWJ1IDxCYWJ1Lk1vZ2VyQGFtZC5jb20+
IHdyb3RlOg0KPj4NCj4+DQo+Pg0KPj4gT24gMTEvMS8xOSAxOjI5IFBNLCBKaW0gTWF0dHNvbiB3
cm90ZToNCj4+PiBPbiBGcmksIE5vdiAxLCAyMDE5IGF0IDEwOjMzIEFNIE1vZ2VyLCBCYWJ1IDxC
YWJ1Lk1vZ2VyQGFtZC5jb20+IHdyb3RlOg0KPj4+Pg0KPj4+PiBBTUQgMm5kIGdlbmVyYXRpb24g
RVBZQyBwcm9jZXNzb3JzIHN1cHBvcnQgVU1JUCAoVXNlci1Nb2RlIEluc3RydWN0aW9uDQo+Pj4+
IFByZXZlbnRpb24pIGZlYXR1cmUuIFRoZSBVTUlQIGZlYXR1cmUgcHJldmVudHMgdGhlIGV4ZWN1
dGlvbiBvZiBjZXJ0YWluDQo+Pj4+IGluc3RydWN0aW9ucyBpZiB0aGUgQ3VycmVudCBQcml2aWxl
Z2UgTGV2ZWwgKENQTCkgaXMgZ3JlYXRlciB0aGFuIDAuDQo+Pj4+IElmIGFueSBvZiB0aGVzZSBp
bnN0cnVjdGlvbnMgYXJlIGV4ZWN1dGVkIHdpdGggQ1BMID4gMCBhbmQgVU1JUA0KPj4+PiBpcyBl
bmFibGVkLCB0aGVuIGtlcm5lbCByZXBvcnRzIGEgI0dQIGV4Y2VwdGlvbi4NCj4+Pj4NCj4+Pj4g
VGhlIGlkZWEgaXMgdGFrZW4gZnJvbSBhcnRpY2xlczoNCj4+Pj4gaHR0cHM6Ly9sd24ubmV0L0Fy
dGljbGVzLzczODIwOS8NCj4+Pj4gaHR0cHM6Ly9sd24ubmV0L0FydGljbGVzLzY5NDM4NS8NCj4+
Pj4NCj4+Pj4gRW5hYmxlIHRoZSBmZWF0dXJlIGlmIHN1cHBvcnRlZCBvbiBiYXJlIG1ldGFsIGFu
ZCBlbXVsYXRlIGluc3RydWN0aW9ucw0KPj4+PiB0byByZXR1cm4gZHVtbXkgdmFsdWVzIGZvciBj
ZXJ0YWluIGNhc2VzLg0KPj4+Pg0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBCYWJ1IE1vZ2VyIDxiYWJ1
Lm1vZ2VyQGFtZC5jb20+DQo+Pj4+IC0tLQ0KPj4+PiAgYXJjaC94ODYva3ZtL3N2bS5jIHwgICAy
MSArKysrKysrKysrKysrKysrLS0tLS0NCj4+Pj4gIDEgZmlsZSBjaGFuZ2VkLCAxNiBpbnNlcnRp
b25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPj4+Pg0KPj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
a3ZtL3N2bS5jIGIvYXJjaC94ODYva3ZtL3N2bS5jDQo+Pj4+IGluZGV4IDQxNTNjYThjZGRiNy4u
NzlhYmJkZWNhMTQ4IDEwMDY0NA0KPj4+PiAtLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtLmMNCj4+Pj4g
KysrIGIvYXJjaC94ODYva3ZtL3N2bS5jDQo+Pj4+IEBAIC0yNTMzLDYgKzI1MzMsMTEgQEAgc3Rh
dGljIHZvaWQgc3ZtX2RlY2FjaGVfY3I0X2d1ZXN0X2JpdHMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
KQ0KPj4+PiAgew0KPj4+PiAgfQ0KPj4+Pg0KPj4+PiArc3RhdGljIGJvb2wgc3ZtX3VtaXBfZW11
bGF0ZWQodm9pZCkNCj4+Pj4gK3sNCj4+Pj4gKyAgICAgICByZXR1cm4gYm9vdF9jcHVfaGFzKFg4
Nl9GRUFUVVJFX1VNSVApOw0KPj4+PiArfQ0KPj4+DQo+Pj4gVGhpcyBtYWtlcyBubyBzZW5zZSB0
byBtZS4gSWYgdGhlIGhhcmR3YXJlIGFjdHVhbGx5IHN1cHBvcnRzIFVNSVAsDQo+Pj4gdGhlbiBp
dCBkb2Vzbid0IGhhdmUgdG8gYmUgZW11bGF0ZWQuDQo+PiBNeSB1bmRlcnN0YW5kaW5nLi4NCj4+
DQo+PiBJZiB0aGUgaGFyZHdhcmUgc3VwcG9ydHMgdGhlIFVNSVAsIGl0IHdpbGwgZ2VuZXJhdGUg
dGhlICNHUCBmYXVsdCB3aGVuDQo+PiB0aGVzZSBpbnN0cnVjdGlvbnMgYXJlIGV4ZWN1dGVkIGF0
IENQTCA+IDAuIFB1cnBvc2Ugb2YgdGhlIGVtdWxhdGlvbiBpcyB0bw0KPj4gdHJhcCB0aGUgR1Ag
YW5kIHJldHVybiBhIGR1bW15IHZhbHVlLiBTZWVtcyBsaWtlIHRoaXMgcmVxdWlyZWQgaW4gY2Vy
dGFpbg0KPj4gbGVnYWN5IE9TZXMgcnVubmluZyBpbiBwcm90ZWN0ZWQgYW5kIHZpcnR1YWwtODA4
NiBtb2Rlcy4gSW4gbG9uZyBtb2RlIG5vDQo+PiBuZWVkIHRvIGVtdWxhdGUuIEhlcmUgaXMgdGhl
IGJpdCBleHBsYW5hdGlvbiBodHRwczovL2x3bi5uZXQvQXJ0aWNsZXMvNzM4MjA5Lw0KPj4NCj4g
DQo+IEluZGVlZC4gIEFnYWluLCB3aGF0IGRvZXMgdGhpcyBoYXZlIHRvIGRvIHdpdGggeW91ciBw
YXRjaD8NCj4gDQo+Pg0KPj4+DQo+Pj4gVG8gdGhlIGV4dGVudCB0aGF0IGt2bSBlbXVsYXRlcyBV
TUlQIG9uIEludGVsIENQVXMgd2l0aG91dCBoYXJkd2FyZQ0KPj4+IFVNSVAgKGkuZS4gc21zdyBp
cyBzdGlsbCBhbGxvd2VkIGF0IENQTD4wKSwgd2UgY2FuIGFsd2F5cyBkbyB0aGUgc2FtZQ0KPj4+
IGVtdWxhdGlvbiBvbiBBTUQsIGJlY2F1c2UgU1ZNIGhhcyBhbHdheXMgb2ZmZXJlZCBpbnRlcmNl
cHRzIG9mIHNnZHQsDQo+Pj4gc2lkdCwgc2xkdCwgYW5kIHN0ci4gU28sIGlmIHlvdSByZWFsbHkg
d2FudCB0byBvZmZlciB0aGlzIGVtdWxhdGlvbiBvbg0KPj4+IHByZS1FUFlDIDIgQ1BVcywgdGhp
cyBmdW5jdGlvbiBzaG91bGQganVzdCByZXR1cm4gdHJ1ZS4gQnV0LCBJIGhhdmUgdG8NCj4+PiBh
c2ssICJ3aHk/Ig0KPj4NCj4+DQo+PiBUcnlpbmcgdG8gc3VwcG9ydCBVTUlQIGZlYXR1cmUgb25s
eSBvbiBFUFlDIDIgaGFyZHdhcmUuIE5vIGludGVudGlvbiB0bw0KPj4gc3VwcG9ydCBwcmUtRVBZ
QyAyLg0KPj4NCj4gDQo+IEkgdGhpbmsgeW91IG5lZWQgdG8gdG90YWxseSByZXdyaXRlIHlvdXIg
Y2hhbmdlbG9nIHRvIGV4cGxhaW4gd2hhdCB5b3UNCj4gYXJlIGRvaW5nLg0KPiANCj4gQXMgSSB1
bmRlcnN0YW5kIGl0LCB0aGVyZSBhcmUgYSBjb3VwbGUgb2YgdGhpbmdzIEtWTSBjYW4gZG86DQo+
IA0KPiAxLiBJZiB0aGUgdW5kZXJseWluZyBoYXJkd2FyZSBzdXBwb3J0cyBVTUlQLCBLVk0gY2Fu
IGV4cG9zZSBVTUlQIHRvDQo+IHRoZSBndWVzdC4gIFNFViBzaG91bGQgYmUgaXJyZWxldmFudCBo
ZXJlLg0KPiANCj4gMi4gUmVnYXJkbGVzcyBvZiB3aGV0aGVyIHRoZSB1bmRlcmx5aW5nIGhhcmR3
YXJlIHN1cHBvcnRzIFVNSVAsIEtWTQ0KPiBjYW4gdHJ5IHRvIGVtdWxhdGUgVU1JUCBpbiB0aGUg
Z3Vlc3QuICBUaGlzIG1heSBiZSBpbXBvc3NpYmxlIGlmIFNFVg0KPiBpcyBlbmFibGVkLg0KPiAN
Cj4gV2hpY2ggb2YgdGhlc2UgYXJlIHlvdSBkb2luZz8NCj4gDQpNeSBpbnRlbnRpb24gd2FzIHRv
IGRvIDEuICBMZXQgbWUgZ28gYmFjayBhbmQgdGhpbmsgYWJvdXQgdGhpcyBhZ2Fpbi4NCg==
