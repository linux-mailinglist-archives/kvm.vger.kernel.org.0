Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F14024804E
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 13:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfFQLNT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 07:13:19 -0400
Received: from mga04.intel.com ([192.55.52.120]:11707 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726622AbfFQLNS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 07:13:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 04:13:18 -0700
X-ExtLoop1: 1
Received: from pgsmsx101.gar.corp.intel.com ([10.221.44.78])
  by orsmga003.jf.intel.com with ESMTP; 17 Jun 2019 04:13:13 -0700
Received: from pgsmsx109.gar.corp.intel.com (10.221.44.109) by
 PGSMSX101.gar.corp.intel.com (10.221.44.78) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 17 Jun 2019 19:13:12 +0800
Received: from pgsmsx112.gar.corp.intel.com ([169.254.3.172]) by
 PGSMSX109.gar.corp.intel.com ([169.254.14.14]) with mapi id 14.03.0439.000;
 Mon, 17 Jun 2019 19:13:12 +0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill@shutemov.name" <kirill@shutemov.name>,
        "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "Schofield, Alison" <alison.schofield@intel.com>
Subject: Re: [PATCH, RFC 20/62] mm/page_ext: Export lookup_page_ext() symbol
Thread-Topic: [PATCH, RFC 20/62] mm/page_ext: Export lookup_page_ext() symbol
Thread-Index: AQHVBa0N2X60Ah6/l0yBtZ+vNYh62KaassmAgADBRICAA9k1AIAAGVkAgAADNwA=
Date:   Mon, 17 Jun 2019 11:13:11 +0000
Message-ID: <1560769988.5187.20.camel@intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
         <20190508144422.13171-21-kirill.shutemov@linux.intel.com>
         <20190614111259.GA3436@hirez.programming.kicks-ass.net>
         <20190614224443.qmqolaigu5wnf75p@box>
         <20190617093054.GB3419@hirez.programming.kicks-ass.net>
         <1560769298.5187.16.camel@linux.intel.com>
In-Reply-To: <1560769298.5187.16.camel@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.91.82]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D614CA96D4DFB74A978CBD3CA2D29412@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDE5LTA2LTE3IGF0IDIzOjAxICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IE9u
IE1vbiwgMjAxOS0wNi0xNyBhdCAxMTozMCArMDIwMCwgUGV0ZXIgWmlqbHN0cmEgd3JvdGU6DQo+
ID4gT24gU2F0LCBKdW4gMTUsIDIwMTkgYXQgMDE6NDQ6NDNBTSArMDMwMCwgS2lyaWxsIEEuIFNo
dXRlbW92IHdyb3RlOg0KPiA+ID4gT24gRnJpLCBKdW4gMTQsIDIwMTkgYXQgMDE6MTI6NTlQTSAr
MDIwMCwgUGV0ZXIgWmlqbHN0cmEgd3JvdGU6DQo+ID4gPiA+IE9uIFdlZCwgTWF5IDA4LCAyMDE5
IGF0IDA1OjQzOjQwUE0gKzAzMDAsIEtpcmlsbCBBLiBTaHV0ZW1vdiB3cm90ZToNCj4gPiA+ID4g
PiBwYWdlX2tleWlkKCkgaXMgaW5saW5lIGZ1bmNhdGlvbiB0aGF0IHVzZXMgbG9va3VwX3BhZ2Vf
ZXh0KCkuIEtWTSBpcw0KPiA+ID4gPiA+IGdvaW5nIHRvIHVzZSBwYWdlX2tleWlkKCkgYW5kIHNp
bmNlIEtWTSBjYW4gYmUgYnVpbHQgYXMgYSBtb2R1bGUNCj4gPiA+ID4gPiBsb29rdXBfcGFnZV9l
eHQoKSBoYXMgdG8gYmUgZXhwb3J0ZWQuDQo+ID4gPiA+IA0KPiA+ID4gPiBJIF9yZWFsbHlfIGhh
dGUgaGF2aW5nIHRvIGV4cG9ydCB3b3JsZCtkb2cgZm9yIEtWTS4gVGhpcyBvbmUgbWlnaHQgbm90
DQo+ID4gPiA+IGJlIGEgcmVhbCBpc3N1ZSwgYnV0IEkgaXRjaCBldmVyeSB0aW1lIEkgc2VlIGFu
IGV4cG9ydCBmb3IgS1ZNIHRoZXNlDQo+ID4gPiA+IGRheXMuDQo+ID4gPiANCj4gPiA+IElzIHRo
ZXJlIGFueSBiZXR0ZXIgd2F5PyBEbyB3ZSBuZWVkIHRvIGludmVudCBFWFBPUlRfU1lNQk9MX0tW
TSgpPyA6UA0KPiA+IA0KPiA+IE9yIGRpc2FsbG93IEtWTSAob3IgcGFydHMgdGhlcmVvZikgZnJv
bSBiZWluZyBhIG1vZHVsZSBhbnltb3JlLg0KPiANCj4gRm9yIHRoaXMgcGFydGljdWxhciBzeW1i
b2wgZXhwb3NlLCBJIGRvbid0IHRoaW5rIGl0cyBmYWlyIHRvIGJsYW1lIEtWTSBzaW5jZSB0aGUg
ZnVuZGFtZW50YWwNCj4gcmVhc29uDQo+IGlzIGJlY2F1c2UgcGFnZV9rZXlpZCgpICh3aGljaCBj
YWxscyBsb29rdXBfcGFnZV9leHQoKSkgYmVpbmcgaW1wbGVtZW50ZWQgYXMgc3RhdGljIGlubGlu
ZQ0KPiBmdW5jdGlvbg0KPiBpbiBoZWFkZXIgZmlsZSwgc28gZXNzZW50aWFsbHkgaGF2aW5nIGFu
eSBvdGhlciBtb2R1bGUgd2hvIGNhbGxzIHBhZ2Vfa2V5aWQoKSB3aWxsIHRyaWdnZXIgdGhpcw0K
PiBwcm9ibGVtIC0tIGluIGZhY3QgSU9NTVUgZHJpdmVyIGNhbGxzIHBhZ2Vfa2V5aWQoKSB0b28g
c28gZXZlbiB3L28gS1ZNIGxvb2t1cF9wYWdlX2V4dCgpIG5lZWRzIHRvDQo+IGJlDQo+IGV4cG9z
ZWQuDQoNCk9vcHMgaXQgc2VlbXMgSW50ZWwgSU9NTVUgZHJpdmVyIGlzIG5vdCBhIG1vZHVsZSBi
dXQgYnVpbGRpbiBzbyB5ZXMgS1ZNIGlzIHRoZSBvbmx5IG1vZHVsZSB3aG8gY2FsbHMNCnBhZ2Vf
a2V5aWQoKSBub3cuIFNvcnJ5IG15IGJhZC4gQnV0IGlmIHRoZXJlJ3MgYW55IG90aGVyIG1vZHVs
ZSBjYWxscyBwYWdlX2tleWlkKCksIHRoaXMgcGF0Y2ggaXMNCnJlcXVpcmVkLg0KDQpUaGFua3Ms
DQotS2FpDQo+IA0KPiBUaGFua3MsDQo+IC1LYWkNCj4g
