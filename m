Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE3A159655
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 10:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfF1IpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 04:45:04 -0400
Received: from mga06.intel.com ([134.134.136.31]:34722 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbfF1IpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 04:45:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 01:45:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,427,1557212400"; 
   d="scan'208";a="314072069"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga004.jf.intel.com with ESMTP; 28 Jun 2019 01:45:02 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 28 Jun 2019 01:45:02 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 28 Jun 2019 01:45:01 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 28 Jun 2019 01:45:01 -0700
Received: from shsmsx101.ccr.corp.intel.com ([169.254.1.87]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.33]) with mapi id 14.03.0439.000;
 Fri, 28 Jun 2019 16:44:59 +0800
From:   "Zhang, Tina" <tina.zhang@intel.com>
To:     Gerd Hoffmann <kraxel@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
Subject: RE: [RFC PATCH v3 0/4] Deliver vGPU display vblank event to
 userspace
Thread-Topic: [RFC PATCH v3 0/4] Deliver vGPU display vblank event to
 userspace
Thread-Index: AQHVLJqUUSM/9sKZ/UyimYY5z7yeLaaughWAgACsmuD//5j6gIABGkSAgAAnqQCAALSSsA==
Date:   Fri, 28 Jun 2019 08:44:59 +0000
Message-ID: <237F54289DF84E4997F34151298ABEBC8768544F@SHSMSX101.ccr.corp.intel.com>
References: <20190627033802.1663-1-tina.zhang@intel.com>
 <20190627062231.57tywityo6uyhmyd@sirius.home.kraxel.org>
 <237F54289DF84E4997F34151298ABEBC876835E5@SHSMSX101.ccr.corp.intel.com>
 <20190627103133.6ekdwazggi5j5lcl@sirius.home.kraxel.org>
 <20190628032149.GD9684@zhen-hp.sh.intel.com>
 <20190628054346.3uc3k4c4cffrqcy3@sirius.home.kraxel.org>
In-Reply-To: <20190628054346.3uc3k4c4cffrqcy3@sirius.home.kraxel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZDM1MmJmNzYtNDAzNy00ZjdhLWJkZjgtM2RjZGZjZDI4YjExIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiODQrZjRmeVNpSUdJUTlPTFVNdDFCWGt1SUl3Y3k2OHRSdHgyOHZSMVlPQ3Y2aSsyOENSVExmVk43S3MxakZHVCJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogaW50ZWwtZ3Z0LWRldiBb
bWFpbHRvOmludGVsLWd2dC1kZXYtYm91bmNlc0BsaXN0cy5mcmVlZGVza3RvcC5vcmddIE9uDQo+
IEJlaGFsZiBPZiBHZXJkIEhvZmZtYW5uDQo+IFNlbnQ6IEZyaWRheSwgSnVuZSAyOCwgMjAxOSAx
OjQ0IFBNDQo+IFRvOiBaaGVueXUgV2FuZyA8emhlbnl1d0BsaW51eC5pbnRlbC5jb20+DQo+IENj
OiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+OyBrdm1Admdlci5rZXJuZWwub3Jn
OyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZzsgWmhhbmcsIFRpbmEgPHRpbmEuemhh
bmdAaW50ZWwuY29tPjsNCj4gYWxleC53aWxsaWFtc29uQHJlZGhhdC5jb207IEx2LCBaaGl5dWFu
IDx6aGl5dWFuLmx2QGludGVsLmNvbT47IFl1YW4sDQo+IEhhbmcgPGhhbmcueXVhbkBpbnRlbC5j
b20+OyBpbnRlbC1ndnQtZGV2QGxpc3RzLmZyZWVkZXNrdG9wLm9yZzsgV2FuZywNCj4gWmhpIEEg
PHpoaS5hLndhbmdAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1JGQyBQQVRDSCB2MyAwLzRd
IERlbGl2ZXIgdkdQVSBkaXNwbGF5IHZibGFuayBldmVudCB0bw0KPiB1c2Vyc3BhY2UNCj4gDQo+
IE9uIEZyaSwgSnVuIDI4LCAyMDE5IGF0IDExOjIxOjQ5QU0gKzA4MDAsIFpoZW55dSBXYW5nIHdy
b3RlOg0KPiA+IE9uIDIwMTkuMDYuMjcgMTI6MzE6MzMgKzAyMDAsIEdlcmQgSG9mZm1hbm4gd3Jv
dGU6DQo+ID4gPiA+ID4gICBIaSwNCj4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gSW5zdGVhZCBvZiBk
ZWxpdmVyaW5nIHBhZ2UgZmxpcCBldmVudHMsIHdlIGNob29zZSB0byBwb3N0DQo+ID4gPiA+ID4g
PiBkaXNwbGF5IHZibGFuayBldmVudC4gSGFuZGxpbmcgcGFnZSBmbGlwIGV2ZW50cyBmb3IgYm90
aA0KPiA+ID4gPiA+ID4gcHJpbWFyeSBwbGFuZSBhbmQgY3Vyc29yIHBsYW5lIG1heSBtYWtlIHVz
ZXIgc3BhY2UgcXVpdGUgYnVzeSwNCj4gPiA+ID4gPiA+IGFsdGhvdWdoIHdlIGhhdmUgdGhlIG1h
c2svdW5tYXNrIG1lY2hhbnNpbSBmb3IgbWl0aWdhdGlvbi4NCj4gPiA+ID4gPiA+IEJlc2lkZXMs
IHRoZXJlIGFyZSBzb21lIGNhc2VzIHRoYXQgZ3Vlc3QgYXBwIG9ubHkgdXNlcyBvbmUNCj4gZnJh
bWVidWZmZXIgZm9yIGJvdGggZHJhd2luZyBhbmQgZGlzcGxheS4NCj4gPiA+ID4gPiA+IEluIHN1
Y2ggY2FzZSwgZ3Vlc3QgT1Mgd29uJ3QgZG8gdGhlIHBsYW5lIHBhZ2UgZmxpcCB3aGVuIHRoZQ0K
PiA+ID4gPiA+ID4gZnJhbWVidWZmZXIgaXMgdXBkYXRlZCwgdGh1cyB0aGUgdXNlciBsYW5kIHdv
bid0IGJlIG5vdGlmaWVkDQo+ID4gPiA+ID4gPiBhYm91dCB0aGUNCj4gPiA+ID4gPiB1cGRhdGVk
IGZyYW1lYnVmZmVyLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gV2hhdCBoYXBwZW5zIHdoZW4gdGhl
IGd1ZXN0IGlzIGlkbGUgYW5kIGRvZXNuJ3QgZHJhdyBhbnl0aGluZyB0bw0KPiA+ID4gPiA+IHRo
ZSBmcmFtZWJ1ZmZlcj8NCj4gPiA+ID4gVGhlIHZibGFuayBldmVudCB3aWxsIGJlIGRlbGl2ZXJl
ZCB0byB1c2Vyc3BhY2UgYXMgd2VsbCwgdW5sZXNzIGd1ZXN0IE9TDQo+IGRpc2FibGUgdGhlIHBp
cGUuDQo+ID4gPiA+IERvZXMgaXQgbWFrZSBzZW5zZSB0byB2ZmlvL2Rpc3BsYXk/DQo+ID4gPg0K
PiA+ID4gR2V0dGluZyBub3RpZmllZCBvbmx5IGluIGNhc2UgdGhlcmUgYXJlIGFjdHVhbCBkaXNw
bGF5IHVwZGF0ZXMgd291bGQNCj4gPiA+IGJlIGEgbmljZSBvcHRpbWl6YXRpb24sIGFzc3VtaW5n
IHRoZSBoYXJkd2FyZSBpcyBhYmxlIHRvIGRvIHRoYXQuDQo+ID4gPiBJZiB0aGUgZ3Vlc3QgcGFn
ZWZsaXBzIHRoaXMgaXMgb2J2aW91c2x5IHRyaXZpYWwuICBOb3Qgc3VyZSB0aGlzIGlzDQo+ID4g
PiBwb3NzaWJsZSBpbiBjYXNlIHRoZSBndWVzdCByZW5kZXJzIGRpcmVjdGx5IHRvIHRoZSBmcm9u
dGJ1ZmZlci4NCj4gPiA+DQo+ID4gPiBXaGF0IGV4YWN0bHkgaGFwcGVucyB3aGVuIHRoZSBndWVz
dCBPUyBkaXNhYmxlcyB0aGUgcGlwZT8gIElzIGENCj4gPiA+IHZibGFuayBldmVudCBkZWxpdmVy
ZWQgYXQgbGVhc3Qgb25jZT8gIFRoYXQgd291bGQgYmUgdmVyeSB1c2VmdWwNCj4gPiA+IGJlY2F1
c2UgaXQgd2lsbCBiZSBwb3NzaWJsZSBmb3IgdXNlcnNwYWNlIHRvIHN0b3AgcG9sbGluZyBhbHRv
Z2V0aGVyDQo+ID4gPiB3aXRob3V0IG1pc3NpbmcgdGhlICJndWVzdCBkaXNhYmxlZCBwaXBlIiBl
dmVudC4NCj4gPiA+DQo+ID4NCj4gPiBJdCBsb29rcyBsaWtlIHB1cnBvc2UgdG8gdXNlIHZibGFu
ayBoZXJlIGlzIHRvIHJlcGxhY2UgdXNlciBzcGFjZQ0KPiA+IHBvbGxpbmcgdG90YWxseSBieSBr
ZXJuZWwgZXZlbnQ/IFdoaWNoIGp1c3QgYWN0IGFzIGRpc3BsYXkgdXBkYXRlDQo+ID4gZXZlbnQg
dG8gcmVwbGFjZSB1c2VyIHNwYWNlIHRpbWVyIHRvIG1ha2UgaXQgcXVlcnkgYW5kIHVwZGF0ZSBw
bGFuZXM/DQo+IA0KPiBJIHRoaW5rIGl0IG1ha2VzIHNlbnNlIHRvIGRlc2lnbiBpdCB0aGF0IHdh
eSwgc28gdXNlcnNwYWNlIHdpbGwgZWl0aGVyIHVzZSB0aGUNCj4gZXZlbnRzICh3aGVuIHN1cHBv
cnRlZCBieSB0aGUgZHJpdmVyKSBvciBhIHRpbWVyIChmYWxsYmFjayBpZg0KPiBub3QpIGJ1dCBu
b3QgYm90aC4NCj4gDQo+ID4gQWx0aG91Z2ggaW4gdGhlb3J5IHZibGFuayBpcyBub3QgYXBwcm9w
cmlhdGUgZm9yIHRoaXMgd2hpY2ggZG9lc24ndA0KPiA+IGFsaWduIHdpdGggcGxhbmUgdXBkYXRl
IG9yIHBvc3NpYmxlIGZyb250IGJ1ZmZlciByZW5kZXJpbmcgYXQgYWxsLCBidXQNCj4gPiBsb29r
cyBpdCdzIGp1c3QgYSBjb21wcm9taXNlIGUuZyBub3Qgc2VuZGluZyBldmVudCBmb3IgZXZlcnkg
Y3Vyc29yDQo+ID4gcG9zaXRpb24gY2hhbmdlLCBldGMuDQo+ID4NCj4gPiBJIHRoaW5rIHdlIG5l
ZWQgdG8gZGVmaW5lIHNlbWFudGljcyBmb3IgdGhpcyBldmVudCBwcm9wZXJseSwgZS5nIHVzZXIN
Cj4gPiBzcGFjZSBwdXJlbHkgZGVwZW5kcyBvbiB0aGlzIGV2ZW50IGZvciBkaXNwbGF5IHVwZGF0
ZSwgdGhlIG9wcG9ydHVuaXR5DQo+ID4gZm9yIGlzc3VpbmcgdGhpcyBldmVudCBpcyBjb250cm9s
bGVkIGJ5IGRyaXZlciB3aGVuIGl0J3MgbmVjZXNzYXJ5IGZvcg0KPiA+IHVwZGF0ZSwgZXRjLiBE
ZWZpbml0ZWx5IG5vdCBuYW1lZCBhcyB2YmxhbmsgZXZlbnQgb3Igb25seSBpc3N1ZSBhdA0KPiA+
IHZibGFuaywgdGhhdCBuZWVkIHRvIGhhcHBlbiBmb3Igb3RoZXIgcGxhbmUgY2hhbmdlIHRvby4N
Cj4gDQo+IEkgdGhpbmsgaXQgc2hvdWxkIGJlICJkaXNwbGF5IHVwZGF0ZSBub3RpZmljYXRpb24i
LCBpLmUuIHVzZXJzcGFjZSBzaG91bGQgY2hlY2sNCj4gZm9yIHBsYW5lIGNoYW5nZXMgYW5kIHVw
ZGF0ZSB0aGUgZGlzcGxheS4NCj4gDQo+IE1vc3QgZXZlbnRzIHdpbGwgcHJvYmFibHkgY29tZSBm
cm9tIHZibGFuayAodHlwaWNhbGx5IHBsYW5lIHVwZGF0ZSBhcmUNCj4gYWN0dWFsbHkgY29tbWl0
dGVkIGF0IHZibGFuayB0aW1lIHRvIGF2b2lkIHRlYXJpbmcsIHJpZ2h0PykuICBUaGF0IGlzIGFu
DQpZZXMuDQo+IGltcGxlbWVudGF0aW9uIGRldGFpbCB0aG91Z2guDQoNCldlIGhhdmUgdHdvIFdJ
UCBicmFuY2hlczogb25lIGlzIGZvciB2YmxhbmsgZXZlbnQgZGVsaXZlcnkgYW5kIHRoZSBvdGhl
ciBvbmUgaXMgZm9yIHBhZ2UgZmxpcCBldmVudCBkZWxpdmVyeS4gDQpSZXBvOg0KLSBRRU1VOiBo
dHRwczovL2dpdGh1Yi5jb20vaW50ZWwvSWd2dGctcWVtdS5naXQNCi0gS2VybmVsOiBodHRwczov
L2dpdGh1Yi5jb20vaW50ZWwvZ3Z0LWxpbnV4LmdpdA0KVHdvIGJyYW5jaGVzOiB0b3BpYy91c2Vy
c3BhY2VfZGlyZWN0X2ZsaXBfcGFnZV9ldmVudCBhbmQgdG9waWMvdXNlcnNwYWNlX2RpcmVjdF9m
bGlwX3ZibGFua19ldmVudA0KDQpXaXRoIEdUSyBVSSwgdGhlIHVzZXIgZXhwZXJpZW5jZSBpcyBi
YWQgb24gYnJhbmNoIHRvcGljL3VzZXJzcGFjZV9kaXJlY3RfZmxpcF9wYWdlX2V2ZW50LCBhcyBt
b3N0IG9mIHRoZSBDUFUgZWZmb3J0cyBhcmUgc3BlbnQgb24gZXZlbnQgaGFuZGxpbmcgaW4gdXNl
ciBzcGFjZS4NCkhvd2V2ZXIsIHdpdGggdGhlIERSTSBVSSBib3RoIG9mIHRoZSB0d28gYnJhbmNo
ZXMgaGF2ZSBnb29kIHVzZXIgZXhwZXJpZW5jZSwgYXMgdGhlIGV2ZW50IGhhbmRsaW5nIGluIERS
TSBVSSBpcyBwcmV0dHkgc2ltcGxlLg0KDQpUaGFua3MuDQoNCkJSLA0KVGluYQ0KDQo+IA0KPiBj
aGVlcnMsDQo+ICAgR2VyZA0KPiANCj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18NCj4gaW50ZWwtZ3Z0LWRldiBtYWlsaW5nIGxpc3QNCj4gaW50ZWwtZ3Z0
LWRldkBsaXN0cy5mcmVlZGVza3RvcC5vcmcNCj4gaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5v
cmcvbWFpbG1hbi9saXN0aW5mby9pbnRlbC1ndnQtZGV2DQo=
