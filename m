Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B2B29F788
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 23:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgJ2WNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 18:13:05 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:47602 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725769AbgJ2WNE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Oct 2020 18:13:04 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-27-qEwyl-1dPLWnmCDyyUncBw-1; Thu, 29 Oct 2020 22:13:00 +0000
X-MC-Unique: qEwyl-1dPLWnmCDyyUncBw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 29 Oct 2020 22:12:59 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 29 Oct 2020 22:12:59 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arvind Sankar' <nivedita@alum.mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        'Arnd Bergmann' <arnd@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH] [v2] x86: apic: avoid -Wshadow warning in header
Thread-Topic: [PATCH] [v2] x86: apic: avoid -Wshadow warning in header
Thread-Index: AQHWrZenJpzBwTRfbE+Uihb7XQWTqKmurjkggABtZPaAAAkikA==
Date:   Thu, 29 Oct 2020 22:12:59 +0000
Message-ID: <ad73f56e79d249b1b3614bccc85e2ca5@AcuMS.aculab.com>
References: <20201028212417.3715575-1-arnd@kernel.org>
 <38b11ed3fec64ebd82d6a92834a4bebe@AcuMS.aculab.com>
 <20201029165611.GA2557691@rani.riverdale.lan>
 <93180c2d-268c-3c33-7c54-4221dfe0d7ad@redhat.com>
 <87v9esojdi.fsf@nanos.tec.linutronix.de>
 <20201029213512.GA34524@rani.riverdale.lan>
In-Reply-To: <20201029213512.GA34524@rani.riverdale.lan>
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

RnJvbTogQXJ2aW5kIFNhbmthcg0KPiBTZW50OiAyOSBPY3RvYmVyIDIwMjAgMjE6MzUNCj4gDQo+
IE9uIFRodSwgT2N0IDI5LCAyMDIwIGF0IDA5OjQxOjEzUE0gKzAxMDAsIFRob21hcyBHbGVpeG5l
ciB3cm90ZToNCj4gPiBPbiBUaHUsIE9jdCAyOSAyMDIwIGF0IDE3OjU5LCBQYW9sbyBCb256aW5p
IHdyb3RlOg0KPiA+ID4gT24gMjkvMTAvMjAgMTc6NTYsIEFydmluZCBTYW5rYXIgd3JvdGU6DQo+
ID4gPj4+IEZvciB0aG9zZSB0d28ganVzdCBhZGQ6DQo+ID4gPj4+IAlzdHJ1Y3QgYXBpYyAqYXBp
YyA9IHg4Nl9zeXN0ZW1fYXBpYzsNCj4gPiA+Pj4gYmVmb3JlIGFsbCB0aGUgYXNzaWdubWVudHMu
DQo+ID4gPj4+IExlc3MgY2h1cm4gYW5kIG11Y2ggYmV0dGVyIGNvZGUuDQo+ID4gPj4+DQo+ID4g
Pj4gV2h5IHdvdWxkIGl0IGJlIGJldHRlciBjb2RlPw0KPiA+ID4+DQo+ID4gPg0KPiA+ID4gSSB0
aGluayBoZSBtZWFucyB0aGUgY29tcGlsZXIgcHJvZHVjZXMgYmV0dGVyIGNvZGUsIGJlY2F1c2Ug
aXQgd29uJ3QNCj4gPiA+IHJlYWQgdGhlIGdsb2JhbCB2YXJpYWJsZSByZXBlYXRlZGx5LiAgTm90
IHN1cmUgaWYgdGhhdCdzIHRydWUsKCopIGJ1dCBJDQo+ID4gPiB0aGluayBJIGRvIHByZWZlciB0
aGF0IHZlcnNpb24gaWYgQXJuZCB3YW50cyB0byBkbyB0aGF0IHR3ZWFrLg0KPiA+DQo+ID4gSXQn
cyBub3QgdHJ1ZS4NCj4gPg0KPiA+ICAgICAgZm9vICpwID0gYmFyOw0KPiA+DQo+ID4gICAgICBw
LT5hID0gMTsNCj4gPiAgICAgIHAtPmIgPSAyOw0KPiA+DQo+ID4gVGhlIGNvbXBpbGVyIGlzIGZy
ZWUgdG8gcmVsb2FkIGJhciBhZnRlciBhY2Nlc3NpbmcgcC0+YSBhbmQgd2l0aA0KPiA+DQo+ID4g
ICAgIGJhci0+YSA9IDE7DQo+ID4gICAgIGJhci0+YiA9IDE7DQo+ID4NCj4gPiBpdCBjYW4gZWl0
aGVyIGNhY2hlIGJhciBpbiBhIHJlZ2lzdGVyIG9yIHJlcmVhZCBpdCBhZnRlciBiYXItPmENCj4g
Pg0KPiA+IFRoZSBnZW5lcmF0ZWQgY29kZSBpcyB0aGUgc2FtZSBhcyBsb25nIGFzIHRoZXJlIGlz
IG5vIHJlYXNvbiB0byByZWxvYWQsDQo+ID4gZS5nLiByZWdpc3RlciBwcmVzc3VyZS4NCj4gPg0K
PiA+IFRoYW5rcywNCj4gPg0KPiA+ICAgICAgICAgdGdseA0KPiANCj4gSXQncyBub3QgcXVpdGUg
dGhlIHNhbWUuDQo+IA0KPiBodHRwczovL2dvZGJvbHQub3JnL3ovNGR6UGJNDQo+IA0KPiBXaXRo
IC1mbm8tc3RyaWN0LWFsaWFzaW5nLCB0aGUgY29tcGlsZXIgcmVsb2FkcyB0aGUgcG9pbnRlciBp
ZiB5b3Ugd3JpdGUNCj4gdG8gdGhlIHN0YXJ0IG9mIHdoYXQgaXQgcG9pbnRzIHRvLCBidXQgbm90
IGlmIHlvdSB3cml0ZSB0byBsYXRlcg0KPiBlbGVtZW50cy4NCg0KSSBndWVzcyBpdCBhc3N1bWVz
IHRoYXQgZ2xvYmFsIGRhdGEgZG9lc24ndCBvdmVybGFwLg0KDQpCdXQgaW4gZ2VuZXJhbCB0aGV5
IGFyZSBzb3J0IG9mIG9wcG9zaXRlczoNCg0KV2l0aCB0aGUgbG9jYWwgdmFyaWFibGUgaXQgY2Fu
IHJlbG9hZCBpZiBpdCBrbm93cyB0aGUgd3JpdGUNCmNhbm5vdCBoYXZlIGFmZmVjdGVkIHRoZSBn
bG9iYWwgLSBidXQgaXMgdW5saWtlbHkgdG8gZG8gc28uDQoNClVzaW5nIHRoZSBnbG9iYWwgaXQg
bXVzdCByZWxvYWQgaWYgaXQgaXMgcG9zc2libGUgdGhlIHdyaXRlDQptaWdodCBoYXZlIGFmZmVj
dGVkIHRoZSBnbG9iYWwuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNp
ZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsN
ClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

