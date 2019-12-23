Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD134129959
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 18:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfLWR2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 12:28:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:56050 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbfLWR2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 12:28:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Dec 2019 09:28:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,348,1571727600"; 
   d="scan'208";a="211622847"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by orsmga008.jf.intel.com with ESMTP; 23 Dec 2019 09:28:18 -0800
Received: from orsmsx157.amr.corp.intel.com (10.22.240.23) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 23 Dec 2019 09:28:17 -0800
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.30]) by
 ORSMSX157.amr.corp.intel.com ([169.254.9.213]) with mapi id 14.03.0439.000;
 Mon, 23 Dec 2019 09:28:17 -0800
From:   "Andersen, John S" <john.s.andersen@intel.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Subject: Re: [RESEND RFC 0/2] Paravirtualized Control Register pinning
Thread-Topic: [RESEND RFC 0/2] Paravirtualized Control Register pinning
Thread-Index: AQHVt2uK2a8jsyPFKUGPuWHWZO4ZBqfFJR4AgANfSYA=
Date:   Mon, 23 Dec 2019 17:28:17 +0000
Message-ID: <a066ebf4bbfa5c01791499d91faf4ff9cfab6c0f.camel@intel.com>
References: <20191220192701.23415-1-john.s.andersen@intel.com>
         <0f42e52a-6a16-69f4-41da-06e53d8025d2@redhat.com>
In-Reply-To: <0f42e52a-6a16-69f4-41da-06e53d8025d2@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.19.9.42]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A0CB504C9D939549A339BB9638F0C4DF@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDE5LTEyLTIxIGF0IDE0OjU5ICswMTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAyMC8xMi8xOSAyMDoyNiwgSm9obiBBbmRlcnNlbiB3cm90ZToNCj4gPiBQYXJhdmlydHVh
bGl6ZWQgQ1IgcGlubmluZyB3aWxsIGxpa2VseSBiZSBpbmNvbXBhdGlibGUgd2l0aCBrZXhlYw0K
PiA+IGZvcg0KPiA+IHRoZSBmb3Jlc2VlYWJsZSBmdXR1cmUuIEVhcmx5IGJvb3QgY29kZSBjb3Vs
ZCBwb3NzaWJseSBiZSBjaGFuZ2VkDQo+ID4gdG8NCj4gPiBub3QgY2xlYXIgcHJvdGVjdGVkIGJp
dHMuIEhvd2V2ZXIsIGEga2VybmVsIHRoYXQgcmVxdWVzdHMgQ1IgYml0cw0KPiA+IGJlDQo+ID4g
cGlubmVkIGNhbid0IGtub3cgaWYgdGhlIGtlcm5lbCBpdCdzIGtleGVjaW5nIGhhcyBiZWVuIHVw
ZGF0ZWQgdG8NCj4gPiBub3QNCj4gPiBjbGVhciBwcm90ZWN0ZWQgYml0cy4gVGhpcyB3b3VsZCBy
ZXN1bHQgaW4gdGhlIGtlcm5lbCBiZWluZyBrZXhlYydkDQo+ID4gYWxtb3N0IGltbWVkaWF0ZWx5
IHJlY2VpdmluZyBhIGdlbmVyYWwgcHJvdGVjdGlvbiBmYXVsdC4NCj4gPiANCj4gPiBTZWN1cml0
eSBjb25zY2lvdXMga2VybmVsIGNvbmZpZ3VyYXRpb25zIGRpc2FibGUga2V4ZWMgYWxyZWFkeSwg
cGVyDQo+ID4gS1NQUA0KPiA+IGd1aWRlbGluZXMuIFByb2plY3RzIHN1Y2ggYXMgS2F0YSBDb250
YWluZXJzLCBBV1MgTGFtYmRhLCBDaHJvbWVPUw0KPiA+IFRlcm1pbmEsIGFuZCBvdGhlcnMgdXNp
bmcgS1ZNIHRvIHZpcnR1YWxpemUgTGludXggd2lsbCBiZW5lZml0IGZyb20NCj4gPiB0aGlzIHBy
b3RlY3Rpb24uDQo+ID4gDQo+ID4gVGhlIHVzYWdlIG9mIFNNTSBpbiBTZWFCSU9TIHdhcyBleHBs
b3JlZCBhcyBhIHdheSB0byBjb21tdW5pY2F0ZSB0bw0KPiA+IEtWTQ0KPiA+IHRoYXQgYSByZWJv
b3QgaGFzIG9jY3VycmVkIGFuZCBpdCBzaG91bGQgemVybyB0aGUgcGlubmVkIGJpdHMuIFdoZW4N
Cj4gPiB1c2luZyBRRU1VIGFuZCBTZWFCSU9TLCBTTU0gaW5pdGlhbGl6YXRpb24gb2NjdXJzIG9u
IHJlYm9vdC4NCj4gPiBIb3dldmVyLA0KPiA+IHByaW9yIHRvIFNNTSBpbml0aWFsaXphdGlvbiwg
QklPUyB3cml0ZXMgemVybyB2YWx1ZXMgdG8gQ1IwLA0KPiA+IGNhdXNpbmcgYQ0KPiA+IGdlbmVy
YWwgcHJvdGVjdGlvbiBmYXVsdCB0byBiZSBzZW50IHRvIHRoZSBndWVzdCBiZWZvcmUgU01NIGNh
bg0KPiA+IHNpZ25hbA0KPiA+IHRoYXQgdGhlIG1hY2hpbmUgaGFzIGJvb3RlZC4NCj4gDQo+IFNN
TSBpcyBvcHRpb25hbDsgSSB0aGluayBpdCBtYWtlcyBzZW5zZSB0byBsZWF2ZSBpdCB0byB1c2Vy
c3BhY2UgdG8NCj4gcmVzZXQgcGlubmluZyAoaW5jbHVkaW5nIGZvciB0aGUgY2FzZSBvZiB0cmlw
bGUgZmF1bHRzKSwgd2hpbGUgSU5JVA0KPiB3aGljaCBpcyBoYW5kbGVkIHdpdGhpbiBLVk0gd291
bGQga2VlcCBpdCBhY3RpdmUuDQo+IA0KPiA+IFBpbm5pbmcgb2Ygc2Vuc2l0aXZlIENSIGJpdHMg
aGFzIGFscmVhZHkgYmVlbiBpbXBsZW1lbnRlZCB0bw0KPiA+IHByb3RlY3QNCj4gPiBhZ2FpbnN0
IGV4cGxvaXRzIGRpcmVjdGx5IGNhbGxpbmcgbmF0aXZlX3dyaXRlX2NyKigpLiBUaGUgY3VycmVu
dA0KPiA+IHByb3RlY3Rpb24gY2Fubm90IHN0b3AgUk9QIGF0dGFja3Mgd2hpY2gganVtcCBkaXJl
Y3RseSB0byBhIE1PViBDUg0KPiA+IGluc3RydWN0aW9uLiBHdWVzdHMgcnVubmluZyB3aXRoIHBh
cmF2aXJ0dWFsaXplZCBDUiBwaW5uaW5nIGFyZSBub3cNCj4gPiBwcm90ZWN0ZWQgYWdhaW5zdCB0
aGUgdXNlIG9mIFJPUCB0byBkaXNhYmxlIENSIGJpdHMuIFRoZSBzYW1lIGJpdHMNCj4gPiB0aGF0
DQo+ID4gYXJlIGJlaW5nIHBpbm5lZCBuYXRpdmVseSBtYXkgYmUgcGlubmVkIHZpYSB0aGUgQ1Ig
cGlubmVkIE1TUnMuDQo+ID4gVGhlc2UNCj4gPiBiaXRzIGFyZSBXUCBpbiBDUjAsIGFuZCBTTUVQ
LCBTTUFQLCBhbmQgVU1JUCBpbiBDUjQuDQo+ID4gDQo+ID4gRnV0dXJlIHBhdGNoZXMgY291bGQg
cHJvdGVjdCBiaXRzIGluIE1TUnMgaW4gYSBzaW1pbGFyIGZhc2hpb24uIFRoZQ0KPiA+IE5YRQ0K
PiA+IGJpdCBvZiB0aGUgRUZFUiBNU1IgaXMgYSBwcmltZSBjYW5kaWRhdGUuDQo+IA0KPiBQbGVh
c2UgaW5jbHVkZSBwYXRjaGVzIGZvciBlaXRoZXIga3ZtLXVuaXQtdGVzdHMgb3INCj4gdG9vbHMv
dGVzdGluZy9zZWxmdGVzdHMva3ZtIHRoYXQgdGVzdCB0aGUgZnVuY3Rpb25hbGl0eS4NCj4gDQoN
CldpbGwgZG8NCg==
