Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEAC1B54B5
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 08:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgDWG2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 02:28:54 -0400
Received: from mga03.intel.com ([134.134.136.65]:23861 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbgDWG2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 02:28:53 -0400
IronPort-SDR: IDcuKJ2C8zdmKrZKNtkx8AxCcmJ1uGKrtCgpV38EqJQDIlipXWqjrvyKv/Quk6YLRW8FqQqy4W
 lubTVFVPwvkw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 23:28:52 -0700
IronPort-SDR: SY78pOo1svn/PX0ZEooVsZvF+mX7S2LHQX0evT4auhv8F3sB70BZmBnksVhk92q+JR3XCJjyql
 wVlLQ0vxfPoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,305,1583222400"; 
   d="scan'208";a="247670967"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga008.fm.intel.com with ESMTP; 22 Apr 2020 23:28:52 -0700
Received: from fmsmsx161.amr.corp.intel.com (10.18.125.9) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 22 Apr 2020 23:28:47 -0700
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 FMSMSX161.amr.corp.intel.com (10.18.125.9) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 22 Apr 2020 23:28:47 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.191]) with mapi id 14.03.0439.000;
 Thu, 23 Apr 2020 14:28:44 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Peter Xu <peterx@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Christophe de Dinechin" <dinechin@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: RE: [PATCH v8 00/14] KVM: Dirty ring interface
Thread-Topic: [PATCH v8 00/14] KVM: Dirty ring interface
Thread-Index: AQHWB46fdukYwiMLhk2Q+RCi75MUMqiFGPaAgAFC4vA=
Date:   Thu, 23 Apr 2020 06:28:43 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D877A3B@SHSMSX104.ccr.corp.intel.com>
References: <20200331190000.659614-1-peterx@redhat.com>
 <20200422185155.GA3596@xz-x1>
In-Reply-To: <20200422185155.GA3596@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBB
cHJpbCAyMywgMjAyMCAyOjUyIEFNDQo+IA0KPiBIaSwNCj4gDQo+IFRMO0RSOiBJJ20gdGhpbmtp
bmcgd2hldGhlciB3ZSBzaG91bGQgcmVjb3JkIHB1cmUgR1BBL0dGTiBpbnN0ZWFkIG9mDQo+IChz
bG90X2lkLA0KPiBzbG90X29mZnNldCkgdHVwbGUgZm9yIGRpcnR5IHBhZ2VzIGluIGt2bSBkaXJ0
eSByaW5nIHRvIHVuYmluZCBrdm1fZGlydHlfZ2ZuDQo+IHdpdGggbWVtc2xvdHMuDQo+IA0KPiAo
QSBzbGlnaHRseSBsb25nZXIgdmVyc2lvbiBzdGFydHMuLi4pDQo+IA0KPiBUaGUgcHJvYmxlbSBp
cyB0aGF0IGJpbmRpbmcgZGlydHkgdHJhY2tpbmcgb3BlcmF0aW9ucyB0byBLVk0gbWVtc2xvdHMg
aXMgYQ0KPiByZXN0cmljdGlvbiB0aGF0IG5lZWRzIHN5bmNocm9uaXphdGlvbiB0byBtZW1zbG90
IGNoYW5nZXMsIHdoaWNoIGZ1cnRoZXINCj4gbmVlZHMNCj4gc3luY2hyb25pemF0aW9uIGFjcm9z
cyBhbGwgdGhlIHZjcHVzIGJlY2F1c2UgdGhleSdyZSB0aGUgY29uc3VtZXJzIG9mDQo+IG1lbXNs
b3RzLg0KPiBFLmcuLCB3aGVuIHdlIHJlbW92ZSBhIG1lbW9yeSBzbG90LCB3ZSBuZWVkIHRvIGZs
dXNoIGFsbCB0aGUgZGlydHkgYml0cw0KPiBjb3JyZWN0bHkgYmVmb3JlIHdlIGRvIHRoZSByZW1v
dmFsIG9mIHRoZSBtZW1zbG90LiAgVGhhdCdzIGFjdHVhbGx5IGFuDQo+IGtub3duDQo+IGRlZmVj
dCBmb3IgUUVNVS9LVk0gWzFdIChJIGJldCBpdCBjb3VsZCBiZSBhIGRlZmVjdCBmb3IgbWFueSBv
dGhlcg0KPiBoeXBlcnZpc29ycy4uLikgcmlnaHQgbm93IHdpdGggY3VycmVudCBkaXJ0eSBsb2dn
aW5nLiAgTWVhbndoaWxlLCBldmVuIGlmIHdlDQo+IGZpeCBpdCwgdGhhdCBwcm9jZWR1cmUgaXMg
bm90IHNjYWxlIGF0IGFsbCwgYW5kIGVycm9yIHByb25lIHRvIGRlYWQgbG9ja3MuDQo+IA0KPiBI
ZXJlIG1lbW9yeSByZW1vdmFsIGlzIHJlYWxseSBhbiAoc3RpbGwgY29ybmVyLWNhc2VkIGJ1dCBy
ZWxhdGl2ZWx5KSBpbXBvcnRhbnQNCj4gc2NlbmFyaW8gdG8gdGhpbmsgYWJvdXQgZm9yIGRpcnR5
IGxvZ2dpbmcgY29tcGFyaW5nIHRvIG1lbW9yeSBhZGRpdGlvbnMgJg0KPiBtb3ZpbmdzLiAgQmVj
YXVzZSBtZW1vcnkgYWRkaXRpb24gd2lsbCBhbHdheXMgaGF2ZSBubyBpbml0aWFsIGRpcnR5IHBh
Z2UsDQo+IGFuZA0KPiB3ZSBkb24ndCByZWFsbHkgbW92ZSBSQU0gYSBsb3QgKG9yIGRvIHdlIGV2
ZXI/ISkgZm9yIGEgZ2VuZXJhbCBWTSB1c2UgY2FzZS4NCj4gDQo+IFRoZW4gSSB3ZW50IGEgc3Rl
cCBiYWNrIHRvIHRoaW5rIGFib3V0IHdoeSB3ZSBuZWVkIHRoZXNlIGRpcnR5IGJpdA0KPiBpbmZv
cm1hdGlvbg0KPiBhZnRlciBhbGwgaWYgdGhlIG1lbXNsb3QgaXMgZ29pbmcgdG8gYmUgcmVtb3Zl
ZD8NCj4gDQo+IFRoZXJlJ3JlIHR3byBjYXNlczoNCj4gDQo+ICAgLSBXaGVuIHRoZSBtZW1zbG90
IGlzIGdvaW5nIHRvIGJlIHJlbW92ZWQgZm9yZXZlciwgdGhlbiB0aGUgZGlydHkNCj4gaW5mb3Jt
YXRpb24NCj4gICAgIGlzIGluZGVlZCBtZWFuaW5nbGVzcyBhbmQgY2FuIGJlIGRyb3BwZWQsIGFu
ZCwNCj4gDQo+ICAgLSBXaGVuIHRoZSBtZW1zbG90IGlzIGdvaW5nIHRvIGJlIHJlbW92ZWQgYnV0
IHF1aWNrbHkgYWRkZWQgYmFjayB3aXRoDQo+IGNoYW5nZWQNCj4gICAgIHNpemUsIHRoZW4gd2Ug
bmVlZCB0byBrZWVwIHRob3NlIGRpcnR5IGJpdHMgYmVjYXVzZSBpdCdzIGp1c3QgYSBjb21tbW9u
DQo+IHdheQ0KPiAgICAgdG8gZS5nLiBwdW5jaCBhbiBNTUlPIGhvbGUgaW4gYW4gZXhpc3Rpbmcg
UkFNIHJlZ2lvbiAoaGVyZSBJJ2QgY29uZmVzcyBJDQo+ICAgICBmZWVsIGxpa2UgdXNpbmcgInNs
b3RfaWQiIHRvIGlkZW50aWZ5IG1lbXNsb3QgaXMgcmVhbGx5IHVuZnJpZW5kbHkgc3lzY2FsbA0K
PiAgICAgZGVzaWduIGZvciB0aGluZ3MgbGlrZSAiaG9sZSBwdW5jaGluZ3MiIGluIHRoZSBSQU0g
YWRkcmVzcyBzcGFjZS4uLg0KPiAgICAgSG93ZXZlciBzdWNoICJwdW5jaCBob2xkIiBvcGVyYXRp
b24gaXMgcmVhbGx5IG5lZWRlZCBldmVuIGZvciBhIGNvbW1vbg0KPiAgICAgZ3Vlc3QgZm9yIGVp
dGhlciBzeXN0ZW0gcmVib290cyBvciBkZXZpY2UgaG90cGx1Z3MsIGV0Yy4pLg0KDQp3aHkgd291
bGQgZGV2aWNlIGhvdHBsdWcgcHVuY2ggYSBob2xlIGluIGFuIGV4aXN0aW5nIFJBTSByZWdpb24/
IA0KDQo+IA0KPiBUaGUgcmVhbCBzY2VuYXJpbyB3ZSB3YW50IHRvIGNvdmVyIGZvciBkaXJ0eSB0
cmFja2luZyBpcyB0aGUgMm5kIG9uZS4NCj4gDQo+IElmIHdlIGNhbiB0cmFjayBkaXJ0eSB1c2lu
ZyByYXcgR1BBLCB0aGUgMm5kIHNjZW5hcmlvIGlzIHNvbHZlZCBpdHNlbGYuDQo+IEJlY2F1c2Ug
d2Uga25vdyB3ZSdsbCBhZGQgdGhvc2UgbWVtc2xvdHMgYmFjayAodGhvdWdoIGl0IG1pZ2h0IGJl
IHdpdGggYQ0KPiBkaWZmZXJlbnQgc2xvdCBJRCksIHRoZW4gdGhlIEdQQSB2YWx1ZSB3aWxsIHN0
aWxsIG1ha2Ugc2Vuc2UsIHdoaWNoIG1lYW5zIHdlDQo+IHNob3VsZCBiZSBhYmxlIHRvIGF2b2lk
IGFueSBraW5kIG9mIHN5bmNocm9uaXphdGlvbiBmb3IgdGhpbmdzIGxpa2UgbWVtb3J5DQo+IHJl
bW92YWxzLCBhcyBsb25nIGFzIHRoZSB1c2Vyc3BhY2UgaXMgYXdhcmUgb2YgdGhhdC4NCg0KQSBj
dXJpb3VzIHF1ZXN0aW9uLiBXaGF0IGFib3V0IHRoZSBiYWNraW5nIHN0b3JhZ2Ugb2YgdGhlIGFm
ZmVjdGVkIEdQQSANCmlzIGNoYW5nZWQgYWZ0ZXIgYWRkaW5nIGJhY2s/IElzIHJlY29yZGVkIGRp
cnR5IGluZm8gZm9yIHByZXZpb3VzIGJhY2tpbmcgDQpzdG9yYWdlIHN0aWxsIG1ha2luZyBzZW5z
ZSBmb3IgdGhlIG5ld2VyIG9uZT8NCg0KVGhhbmtzDQpLZXZpbg0KDQo+IA0KPiBXaXRoIHRoYXQs
IHdoZW4gd2UgZmV0Y2ggdGhlIGRpcnR5IGJpdHMsIHdlIGxvb2t1cCB0aGUgbWVtc2xvdCBkeW5h
bWljYWxseSwNCj4gZHJvcCBiaXRzIGlmIHRoZSBtZW1zbG90IGRvZXMgbm90IGV4aXN0IG9uIHRo
YXQgYWRkcmVzcyAoZS5nLiwgcGVybWFuZW50DQo+IHJlbW92YWxzKSwgYW5kIHVzZSB3aGF0ZXZl
ciBtZW1zbG90IGlzIHRoZXJlIGZvciB0aGF0IGd1ZXN0IHBoeXNpY2FsDQo+IGFkZHJlc3MuDQo+
IFRob3VnaCB3ZSBmb3Igc3VyZSBzdGlsbCBuZWVkIHRvIGhhbmRsZSBtZW1vcnkgbW92ZSwgdGhh
dCB0aGUgdXNlcnNwYWNlDQo+IG5lZWRzDQo+IHRvIHN0aWxsIHRha2UgY2FyZSBvZiBkaXJ0eSBi
aXQgZmx1c2hpbmcgYW5kIHN5bmMgZm9yIGEgbWVtb3J5IG1vdmUsIGhvd2V2ZXINCj4gdGhhdCdz
IG1lcmVseSBub3QgaGFwcGVuaW5nIHNvIG5vdGhpbmcgdG8gdGFrZSBjYXJlIGFib3V0IGVpdGhl
ci4NCj4gDQo+IERvZXMgdGhpcyBtYWtlcyBzZW5zZT8gIENvbW1lbnRzIGdyZWF0bHkgd2VsY29t
ZWQuLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gWzFdIGh0dHBzOi8vbGlzdHMuZ251Lm9yZy9hcmNo
aXZlL2h0bWwvcWVtdS1kZXZlbC8yMDIwLTAzL21zZzA4MzYxLmh0bWwNCj4gDQo+IC0tDQo+IFBl
dGVyIFh1DQoNCg==
