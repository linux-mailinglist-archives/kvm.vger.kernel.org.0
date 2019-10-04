Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A61FCC3F7
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 22:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731356AbfJDUKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 16:10:01 -0400
Received: from mga07.intel.com ([134.134.136.100]:24597 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730746AbfJDUKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 16:10:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 13:09:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,257,1566889200"; 
   d="scan'208";a="191686034"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by fmsmga008.fm.intel.com with ESMTP; 04 Oct 2019 13:09:59 -0700
Received: from orsmsx122.amr.corp.intel.com (10.22.225.227) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 4 Oct 2019 13:09:58 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.161]) by
 ORSMSX122.amr.corp.intel.com ([169.254.11.236]) with mapi id 14.03.0439.000;
 Fri, 4 Oct 2019 13:09:58 -0700
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
Thread-Index: AQHVejL3BY31w2dp/kGOlEfaBbHp/adLCOMAgABXcoA=
Date:   Fri, 4 Oct 2019 20:09:58 +0000
Message-ID: <d5be8611158108a05fbb67c23b10357f2fb19816.camel@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
         <CALCETrW9MEvNt+kB_65cbX9VJiLxktAFagkzSGR0VQfd4VHOiQ@mail.gmail.com>
In-Reply-To: <CALCETrW9MEvNt+kB_65cbX9VJiLxktAFagkzSGR0VQfd4VHOiQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.54.75.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <93BA229D5988F3498EF10A6AF30F2BF1@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDE5LTEwLTA0IGF0IDA3OjU2IC0wNzAwLCBBbmR5IEx1dG9taXJza2kgd3JvdGU6
DQo+IE9uIFRodSwgT2N0IDMsIDIwMTkgYXQgMjozOCBQTSBSaWNrIEVkZ2Vjb21iZQ0KPiA8cmlj
ay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IFRoaXMgcGF0Y2hzZXQg
ZW5hYmxlcyB0aGUgYWJpbGl0eSBmb3IgS1ZNIGd1ZXN0cyB0byBjcmVhdGUgZXhlY3V0ZS1vbmx5
IChYTykNCj4gPiBtZW1vcnkgYnkgdXRpbGl6aW5nIEVQVCBiYXNlZCBYTyBwZXJtaXNzaW9ucy4g
WE8gbWVtb3J5IGlzIGN1cnJlbnRseQ0KPiA+IHN1cHBvcnRlZA0KPiA+IG9uIEludGVsIGhhcmR3
YXJlIG5hdGl2ZWx5IGZvciBDUFUncyB3aXRoIFBLVSwgYnV0IHRoaXMgZW5hYmxlcyBpdCBvbiBv
bGRlcg0KPiA+IHBsYXRmb3JtcywgYW5kIGNhbiBzdXBwb3J0IFhPIGZvciBrZXJuZWwgbWVtb3J5
IGFzIHdlbGwuDQo+IA0KPiBUaGUgcGF0Y2hzZXQgc2VlbXMgdG8gc29tZXRpbWVzIGNhbGwgdGhp
cyBmZWF0dXJlICJYTyIgYW5kIHNvbWV0aW1lcw0KPiBjYWxsIGl0ICJOUiIuICBUbyBtZSwgWE8g
aW1wbGllcyBuby1yZWFkIGFuZCBuby13cml0ZSwgd2hlcmVhcyBOUg0KPiBpbXBsaWVzIGp1c3Qg
bm8tcmVhZC4gIENhbiB5b3UgcGxlYXNlIGNsYXJpZnkgKmV4YWN0bHkqIHdoYXQgdGhlIG5ldw0K
PiBiaXQgZG9lcyBhbmQgYmUgY29uc2lzdGVudD8NCj4gDQo+IEkgc3VnZ2VzdCB0aGF0IHlvdSBt
YWtlIGl0IE5SLCB3aGljaCBhbGxvd3MgZm9yIFBST1RfRVhFQyBhbmQNCj4gUFJPVF9FWEVDfFBS
T1RfV1JJVEUgYW5kIHBsYWluIFBST1RfV1JJVEUuICBXWCBpcyBvZiBkdWJpb3VzIHZhbHVlLA0K
PiBidXQgSSBjYW4gaW1hZ2luZSBwbGFpbiBXIGJlaW5nIGdlbnVpbmVseSB1c2VmdWwgZm9yIGxv
Z2dpbmcgYW5kIGZvcg0KPiBKSVRzIHRoYXQgY291bGQgbWFpbnRhaW4gYSBXIGFuZCBhIHNlcGFy
YXRlIFggbWFwcGluZyBvZiBzb21lIGNvZGUuDQo+IEluIG90aGVyIHdvcmRzLCB3aXRoIGFuIE5S
IGJpdCwgYWxsIDggbG9naWNhbCBhY2Nlc3MgbW9kZXMgYXJlDQo+IHBvc3NpYmxlLiAgQWxzbywg
a2VlcGluZyB0aGUgcGFnaW5nIGJpdHMgbW9yZSBvcnRob2dvbmFsIHNlZW1zIG5pY2UgLS0NCj4g
d2UgYWxyZWFkeSBoYXZlIGEgYml0IHRoYXQgY29udHJvbHMgd3JpdGUgYWNjZXNzLg0KDQpTb3Jy
eSwgeWVzIHRoZSBiZWhhdmlvciBvZiB0aGlzIGJpdCBuZWVkcyB0byBiZSBkb2N1bWVudGVkIGEg
bG90IGJldHRlci4gSSB3aWxsDQpkZWZpbml0ZWx5IGRvIHRoaXMgZm9yIHRoZSBuZXh0IHZlcnNp
b24uDQoNClRvIGNsYXJpZnksIHNpbmNlIHRoZSBFUFQgcGVybWlzc2lvbnMgaW4gdGhlIFhPL05S
IHJhbmdlIGFyZSBleGVjdXRhYmxlLCBhbmQgbm90DQpyZWFkYWJsZSBvciB3cml0ZWFibGUgdGhl
IG5ldyBiaXQgcmVhbGx5IG1lYW5zIFhPLCBidXQgb25seSB3aGVuIE5YIGlzIDAgc2luY2UNCnRo
ZSBndWVzdCBwYWdlIHRhYmxlcyBhcmUgYmVpbmcgY2hlY2tlZCBhcyB3ZWxsLiBXaGVuIE5SPTEs
IFc9MSwgYW5kIE5YPTAsIHRoZQ0KbWVtb3J5IGlzIHN0aWxsIFhPLg0KDQpOUiB3YXMgcGlja2Vk
IG92ZXIgWE8gYmVjYXVzZSBhcyB5b3Ugc2F5LiBUaGUgaWRlYSBpcyB0aGF0IGl0IGNhbiBiZSBk
ZWZpbmVkDQp0aGF0IGluIHRoZSBjYXNlIG9mIEtWTSBYTywgTlIgYW5kIHdyaXRhYmxlIGlzIG5v
dCBhIHZhbGlkIGNvbWJpbmF0aW9uLCBsaWtlDQp3cml0ZWFibGUgYnV0IG5vdCByZWFkYWJsZSBp
cyBkZWZpbmVkIGFzIG5vdCB2YWxpZCBmb3IgdGhlIEVQVC4NCg0KSSAqdGhpbmsqIHdoZW5ldmVy
IE5YPTEsIE5SPTEgaXQgc2hvdWxkIGJlIHNpbWlsYXIgdG8gbm90IHByZXNlbnQgaW4gdGhhdCBp
dA0KY2FuJ3QgYmUgdXNlZCBmb3IgYW55dGhpbmcgb3IgaGF2ZSBpdHMgdHJhbnNsYXRpb24gY2Fj
aGVkLiBJIGFtIG5vdCAxMDAlIHN1cmUgb24NCnRoZSBjYWNoZWQgcGFydCBhbmQgd2FzIHRoaW5r
aW5nIG9mIGp1c3QgbWFraW5nIHRoZSAic3BlYyIgdGhhdCB0aGUgdHJhbnNsYXRpb24NCmNhY2hp
bmcgYmVoYXZpb3IgaXMgdW5kZWZpbmVkLiBJIGNhbiBsb29rIGludG8gdGhpcyBpZiBhbnlvbmUg
dGhpbmtzIHdlIG5lZWQgdG8NCmtub3cuIEluIHRoZSBjdXJyZW50IHBhdGNoc2V0IGl0IHNob3Vs
ZG4ndCBiZSBwb3NzaWJsZSB0byBjcmVhdGUgdGhpcw0KY29tYmluYXRpb24uDQoNClNpbmNlIHdy
aXRlLW9ubHkgbWVtb3J5IGlzbid0IHN1cHBvcnRlZCBpbiBFUFQgd2UgY2FuJ3QgZG8gdGhlIHNh
bWUgdHJpY2sgdG8NCmNyZWF0ZSBhIG5ldyBIVyBwZXJtaXNzaW9uLiBCdXQgSSBndWVzcyBpZiB3
ZSBlbXVsYXRlIGl0LCB3ZSBjb3VsZCBtYWtlIHRoZSBuZXcNCmJpdCBtZWFuIGp1c3QgTlIsIGFu
ZCBzdXBwb3J0IHdyaXRlLW9ubHkgYnkgYWxsb3dpbmcgZW11bGF0aW9uIHdoZW4gS1ZNIGdldHMg
YQ0Kd3JpdGUgRVBUIHZpb2xhdGlvbnMgdG8gTlIgbWVtb3J5LiBJdCBtaWdodCBzdGlsbCBiZSB1
c2VmdWwgZm9yIHRoZSBKSVQgY2FzZSB5b3UNCm1lbnRpb25lZCwgb3IgYSBzaGFyZWQgbWVtb3J5
IG1haWxib3guIE9uIHRoZSBvdGhlciBoYW5kLCB1c2Vyc3BhY2UgbWlnaHQgYmUNCnN1cnByaXNl
ZCB0byBlbmNvdW50ZXIgdGhhdCBtZW1vcnkgaXMgZGlmZmVyZW50IHNwZWVkcyBkZXBlbmRpbmcg
b24gdGhlDQpwZXJtaXNzaW9uLiBJIGFsc28gd29uZGVyIGlmIGFueSB1c2Vyc3BhY2UgYXBwcyBh
cmUgYXNraW5nIGZvciBqdXN0IFBST1RfV1JJVEUNCmFuZCBleHBlY3RpbmcgcmVhZGFibGUgbWVt
b3J5Lg0KDQpUaGFua3MsDQoNClJpY2sNCg0K
