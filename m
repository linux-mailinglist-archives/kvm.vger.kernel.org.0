Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBAA2981DE
	for <lists+kvm@lfdr.de>; Sun, 25 Oct 2020 14:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416218AbgJYNUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Oct 2020 09:20:22 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:39026 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1416219AbgJYNUV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 25 Oct 2020 09:20:21 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-80-BcNCCdBLNpq04JWj022ymg-1; Sun, 25 Oct 2020 13:20:17 +0000
X-MC-Unique: BcNCCdBLNpq04JWj022ymg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sun, 25 Oct 2020 13:20:16 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sun, 25 Oct 2020 13:20:16 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Woodhouse' <dwmw2@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     kvm <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "maz@misterjones.org" <maz@misterjones.org>,
        Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH v3 17/35] x86/pci/xen: Use msi_msg shadow structs
Thread-Topic: [PATCH v3 17/35] x86/pci/xen: Use msi_msg shadow structs
Thread-Index: AQHWqk3aux8nicxw2kqi6TJIJCakiamoEtJwgAALGgCAAC2AAA==
Date:   Sun, 25 Oct 2020 13:20:16 +0000
Message-ID: <340eeca1a7e547bebef694eab505550d@AcuMS.aculab.com>
References: <e6601ff691afb3266e365a91e8b221179daf22c2.camel@infradead.org>
         <20201024213535.443185-1-dwmw2@infradead.org>
         <20201024213535.443185-18-dwmw2@infradead.org>
         <3e69326016524d97bcdea35d0765cc68@AcuMS.aculab.com>
 <a7ed5e550628083199e2747b8267c550689a368c.camel@infradead.org>
In-Reply-To: <a7ed5e550628083199e2747b8267c550689a368c.camel@infradead.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogRGF2aWQgV29vZGhvdXNlDQo+IFNlbnQ6IDI1IE9jdG9iZXIgMjAyMCAxMDoyNg0KPiBU
bzogRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWlnaHRAQUNVTEFCLkNPTT47IHg4NkBrZXJuZWwub3Jn
DQo+IA0KPiBPbiBTdW4sIDIwMjAtMTAtMjUgYXQgMDk6NDkgKzAwMDAsIERhdmlkIExhaWdodCB3
cm90ZToNCj4gPiBKdXN0IGxvb2tpbmcgYXQgYSByYW5kb20gb25lIG9mIHRoZXNlIHBhdGNoZXMu
Li4NCj4gPg0KPiA+IERvZXMgdGhlIGNvbXBpbGVyIG1hbmFnZSB0byBvcHRpbWlzZSB0aGF0IHJl
YXNvbmFibHk/DQo+ID4gT3IgZG9lcyBpdCBnZW5lcmF0ZSBhIGxvdCBvZiBzaGlmdHMgYW5kIG1h
c2tzIGFzIGVhY2gNCj4gPiBiaXRmaWVsZCBpcyBzZXQ/DQo+ID4NCj4gPiBUaGUgY29kZSBnZW5l
cmF0aW9uIGZvciBiaXRmaWVsZHMgaXMgb2Z0ZW4gYSBsb3Qgd29yc2UNCj4gPiB0aGF0IHRoYXQg
Zm9yIHw9IHNldHRpbmcgYml0cyBpbiBhIHdvcmQuDQo+IA0KPiBJbmRlZWQsIGl0IGFwcGVhcnMg
dG8gYmUgdXR0ZXJseSBhcHBhbGxpbmcuIFRoYXQgd2FzIG9uZSBvZiBteQ0KPiBtb3RpdmF0aW9u
cyBmb3IgZG9pbmcgaXQgd2l0aCBtYXNrcyBhbmQgc2hpZnRzIGluIHRoZSBmaXJzdCBwbGFjZS4N
Cg0KSSB0aG91Z2h0IGl0IHdvdWxkIGJlLg0KDQpJJ20gbm90IGV2ZW4gc3VyZSB1c2luZyBiaXRm
aWVsZHMgdG8gbWFwIGhhcmR3YXJlIHJlZ2lzdGVycw0KbWFrZXMgdGhlIGNvZGUgYW55IG1vcmUg
cmVhZGFibGUgKG9yIGZvb2wgcHJvb2YpLg0KDQpJIHN1c3BlY3QgdXNpbmcgI2RlZmluZSBjb25z
dGFudHMgYW5kIGV4cGxpY2l0IHw9IGFuZCAmPSB+DQppcyBhY3R1YWxseSBiZXN0IC0gcHJvdmlk
ZWQgdGhlIG5hbWVzIGFyZSBkZXNjcmlwdGl2ZSBlbm91Z2guDQoNCklmIHlvdSBzZXQgYWxsIHRo
ZSBmaWVsZHMgdGhlIGNvbXBpbGVyIHdpbGwgbWVyZ2UgdGhlIHZhbHVlcw0KYW5kIGRvIGEgc2lu
Z2xlIHdyaXRlIC0gcHJvdmlkZWQgbm90aGluZyB5b3UgcmVhZCBtaWdodA0KYWxpYXMgdGhlIHRh
cmdldC4NCg0KVGhlIG9ubHkgd2F5IHRvIGdldCBzdHJvbmdseSB0eXBlZCBpbnRlZ2VycyBpcyB0
byBjYXN0IHRoZW0NCnRvIGEgc3RydWN0dXJlIHBvaW50ZXIgdHlwZS4NClRvZ2V0aGVyIHdpdGgg
YSBzdGF0aWMgaW5saW5lIGZ1bmN0aW9uIHRvIHJlbW92ZSB0aGUgY2FzdHMNCmFuZCB8IHRoZSB2
YWx1ZXMgdG9nZXRoZXIgaXQgbWlnaHQgbWFrZSB0aGluZ3MgZm9vbCBwcm9vZi4NCkJ1dCBJJ3Zl
IG5ldmVyIHRyaWVkIGl0Lg0KDQpJU1RSIG9uY2UgZG9pbmcgc29tZXRoaW5nIGxpa2UgdGhhdCB3
aXRoIGVycm9yIGNvZGVzLCBidXQNCml0IGRpZG4ndCBldmVyIG1ha2Ugc291cmNlIGNvbnRyb2wu
DQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9h
ZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBO
bzogMTM5NzM4NiAoV2FsZXMpDQo=

