Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 825F6CEB91
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 20:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbfJGSOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 14:14:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:17856 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbfJGSOn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 14:14:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 11:14:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="192354361"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga008.fm.intel.com with ESMTP; 07 Oct 2019 11:14:41 -0700
Received: from orsmsx152.amr.corp.intel.com (10.22.226.39) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 7 Oct 2019 11:14:41 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.161]) by
 ORSMSX152.amr.corp.intel.com ([169.254.8.128]) with mapi id 14.03.0439.000;
 Mon, 7 Oct 2019 11:14:41 -0700
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "luto@kernel.org" <luto@kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "Dock, Deneen T" <deneen.t.dock@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kristen@linux.intel.com" <kristen@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
Subject: Re: [RFC PATCH 00/13] XOM for KVM guest userspace
Thread-Topic: [RFC PATCH 00/13] XOM for KVM guest userspace
Thread-Index: AQHVejL3BY31w2dp/kGOlEfaBbHp/adLCOMAgABXcoCAAFpLgIAEPH4A
Date:   Mon, 7 Oct 2019 18:14:40 +0000
Message-ID: <50df3c452b25ff4823fba223dd56216bc2f33644.camel@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
         <CALCETrW9MEvNt+kB_65cbX9VJiLxktAFagkzSGR0VQfd4VHOiQ@mail.gmail.com>
         <d5be8611158108a05fbb67c23b10357f2fb19816.camel@intel.com>
         <CALCETrWDFYO4LZu_OM24FAcnphm4jwvbz4j31q8w7eeHUR_4EA@mail.gmail.com>
In-Reply-To: <CALCETrWDFYO4LZu_OM24FAcnphm4jwvbz4j31q8w7eeHUR_4EA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.54.75.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <700DB460C502A948B445FC5846B46BD3@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDE5LTEwLTA0IGF0IDE4OjMzIC0wNzAwLCBBbmR5IEx1dG9taXJza2kgd3JvdGU6
DQo+IE9uIEZyaSwgT2N0IDQsIDIwMTkgYXQgMToxMCBQTSBFZGdlY29tYmUsIFJpY2sgUA0KPiA8
cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIEZyaSwgMjAx
OS0xMC0wNCBhdCAwNzo1NiAtMDcwMCwgQW5keSBMdXRvbWlyc2tpIHdyb3RlOg0KPiA+ID4gT24g
VGh1LCBPY3QgMywgMjAxOSBhdCAyOjM4IFBNIFJpY2sgRWRnZWNvbWJlDQo+ID4gPiA8cmljay5w
LmVkZ2Vjb21iZUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+ID4gPiANCj4gPiA+ID4gVGhpcyBwYXRj
aHNldCBlbmFibGVzIHRoZSBhYmlsaXR5IGZvciBLVk0gZ3Vlc3RzIHRvIGNyZWF0ZSBleGVjdXRl
LW9ubHkNCj4gPiA+ID4gKFhPKQ0KPiA+ID4gPiBtZW1vcnkgYnkgdXRpbGl6aW5nIEVQVCBiYXNl
ZCBYTyBwZXJtaXNzaW9ucy4gWE8gbWVtb3J5IGlzIGN1cnJlbnRseQ0KPiA+ID4gPiBzdXBwb3J0
ZWQNCj4gPiA+ID4gb24gSW50ZWwgaGFyZHdhcmUgbmF0aXZlbHkgZm9yIENQVSdzIHdpdGggUEtV
LCBidXQgdGhpcyBlbmFibGVzIGl0IG9uDQo+ID4gPiA+IG9sZGVyDQo+ID4gPiA+IHBsYXRmb3Jt
cywgYW5kIGNhbiBzdXBwb3J0IFhPIGZvciBrZXJuZWwgbWVtb3J5IGFzIHdlbGwuDQo+ID4gPiAN
Cj4gPiA+IFRoZSBwYXRjaHNldCBzZWVtcyB0byBzb21ldGltZXMgY2FsbCB0aGlzIGZlYXR1cmUg
IlhPIiBhbmQgc29tZXRpbWVzDQo+ID4gPiBjYWxsIGl0ICJOUiIuICBUbyBtZSwgWE8gaW1wbGll
cyBuby1yZWFkIGFuZCBuby13cml0ZSwgd2hlcmVhcyBOUg0KPiA+ID4gaW1wbGllcyBqdXN0IG5v
LXJlYWQuICBDYW4geW91IHBsZWFzZSBjbGFyaWZ5ICpleGFjdGx5KiB3aGF0IHRoZSBuZXcNCj4g
PiA+IGJpdCBkb2VzIGFuZCBiZSBjb25zaXN0ZW50Pw0KPiA+ID4gDQo+ID4gPiBJIHN1Z2dlc3Qg
dGhhdCB5b3UgbWFrZSBpdCBOUiwgd2hpY2ggYWxsb3dzIGZvciBQUk9UX0VYRUMgYW5kDQo+ID4g
PiBQUk9UX0VYRUN8UFJPVF9XUklURSBhbmQgcGxhaW4gUFJPVF9XUklURS4gIFdYIGlzIG9mIGR1
YmlvdXMgdmFsdWUsDQo+ID4gPiBidXQgSSBjYW4gaW1hZ2luZSBwbGFpbiBXIGJlaW5nIGdlbnVp
bmVseSB1c2VmdWwgZm9yIGxvZ2dpbmcgYW5kIGZvcg0KPiA+ID4gSklUcyB0aGF0IGNvdWxkIG1h
aW50YWluIGEgVyBhbmQgYSBzZXBhcmF0ZSBYIG1hcHBpbmcgb2Ygc29tZSBjb2RlLg0KPiA+ID4g
SW4gb3RoZXIgd29yZHMsIHdpdGggYW4gTlIgYml0LCBhbGwgOCBsb2dpY2FsIGFjY2VzcyBtb2Rl
cyBhcmUNCj4gPiA+IHBvc3NpYmxlLiAgQWxzbywga2VlcGluZyB0aGUgcGFnaW5nIGJpdHMgbW9y
ZSBvcnRob2dvbmFsIHNlZW1zIG5pY2UgLS0NCj4gPiA+IHdlIGFscmVhZHkgaGF2ZSBhIGJpdCB0
aGF0IGNvbnRyb2xzIHdyaXRlIGFjY2Vzcy4NCj4gPiANCj4gPiBTb3JyeSwgeWVzIHRoZSBiZWhh
dmlvciBvZiB0aGlzIGJpdCBuZWVkcyB0byBiZSBkb2N1bWVudGVkIGEgbG90IGJldHRlci4gSQ0K
PiA+IHdpbGwNCj4gPiBkZWZpbml0ZWx5IGRvIHRoaXMgZm9yIHRoZSBuZXh0IHZlcnNpb24uDQo+
ID4gDQo+ID4gVG8gY2xhcmlmeSwgc2luY2UgdGhlIEVQVCBwZXJtaXNzaW9ucyBpbiB0aGUgWE8v
TlIgcmFuZ2UgYXJlIGV4ZWN1dGFibGUsIGFuZA0KPiA+IG5vdA0KPiA+IHJlYWRhYmxlIG9yIHdy
aXRlYWJsZSB0aGUgbmV3IGJpdCByZWFsbHkgbWVhbnMgWE8sIGJ1dCBvbmx5IHdoZW4gTlggaXMg
MA0KPiA+IHNpbmNlDQo+ID4gdGhlIGd1ZXN0IHBhZ2UgdGFibGVzIGFyZSBiZWluZyBjaGVja2Vk
IGFzIHdlbGwuIFdoZW4gTlI9MSwgVz0xLCBhbmQgTlg9MCwNCj4gPiB0aGUNCj4gPiBtZW1vcnkg
aXMgc3RpbGwgWE8uDQo+ID4gDQo+ID4gTlIgd2FzIHBpY2tlZCBvdmVyIFhPIGJlY2F1c2UgYXMg
eW91IHNheS4gVGhlIGlkZWEgaXMgdGhhdCBpdCBjYW4gYmUgZGVmaW5lZA0KPiA+IHRoYXQgaW4g
dGhlIGNhc2Ugb2YgS1ZNIFhPLCBOUiBhbmQgd3JpdGFibGUgaXMgbm90IGEgdmFsaWQgY29tYmlu
YXRpb24sIGxpa2UNCj4gPiB3cml0ZWFibGUgYnV0IG5vdCByZWFkYWJsZSBpcyBkZWZpbmVkIGFz
IG5vdCB2YWxpZCBmb3IgdGhlIEVQVC4NCj4gPiANCj4gDQo+IFVnaCwgSSBzZWUsIHRoaXMgaXMg
YW4gIkVQVCBNaXNjb25maWd1cmF0aW9uIi4gIE9oLCB3ZWxsLiAgSSBndWVzcw0KPiBqdXN0IGtl
ZXAgdGhpbmdzIGFzIHRoZXkgYXJlIGFuZCBkb2N1bWVudCB0aGluZ3MgYmV0dGVyLCBwbGVhc2Uu
DQo+IERvbid0IHRyeSB0byBlbXVsYXRlLg0KDQpBaCwgSSBzZWUgd2hhdCB5b3Ugd2VyZSB0aGlu
a2luZy4gT2sgd2lsbCBkby4NCg0KPiBJIGRvbid0IHN1cHBvc2UgSW50ZWwgY291bGQgYmUgY29u
dmluY2VkIHRvIGdldCByaWQgb2YgdGhhdCBpbiBhDQo+IGZ1dHVyZSBDUFUgYW5kIGFsbG93IHdy
aXRlLW9ubHkgbWVtb3J5Pw0KDQpIbW0sIEknbSBub3Qgc3VyZS4gSSBjYW4gdHJ5IHRvIHBhc3Mg
aXQgYWxvbmcuDQoNCj4gQlRXLCBpcyB5b3VyIHBhdGNoIGNoZWNraW5nIGZvciBzdXBwb3J0IGlu
IElBMzJfVk1YX0VQVF9WUElEX0NBUD8gIEkNCj4gZGlkbid0IG5vdGljZSBpdCwgYnV0IEkgZGlk
bid0IGxvb2sgdGhhdCBoYXJkLg0KDQpZZXAsIHRoZXJlIHdhcyBhbHJlYWR5IGEgaGVscGVyOiBj
cHVfaGFzX3ZteF9lcHRfZXhlY3V0ZV9vbmx5KCkuDQoNCg==
