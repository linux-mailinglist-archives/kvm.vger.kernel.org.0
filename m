Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF2C195403
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 10:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgC0Jbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 05:31:45 -0400
Received: from mga04.intel.com ([192.55.52.120]:7300 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgC0Jbp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Mar 2020 05:31:45 -0400
IronPort-SDR: PngEAh6/yiYZHwnIAdqc4I05c+bGXWkDSvbt1XKi+Q+83+g9vlOrprtEpqy5GkRQH1mQboZl3m
 CLPSFhFUchHQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 02:31:41 -0700
IronPort-SDR: +JnlIPZ27gPEXG7U99ML/TBH534/qa0mhzss5+NvEB866bsW3sK02Ts7bJwBZdH9ofoKfq7o2L
 VGqAD7Jo32Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,311,1580803200"; 
   d="scan'208";a="247835315"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga003.jf.intel.com with ESMTP; 27 Mar 2020 02:31:40 -0700
Received: from fmsmsx124.amr.corp.intel.com (10.18.125.39) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 27 Mar 2020 02:31:39 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 fmsmsx124.amr.corp.intel.com (10.18.125.39) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 27 Mar 2020 02:31:40 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.50]) with mapi id 14.03.0439.000;
 Fri, 27 Mar 2020 17:31:36 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Subject: RE: [PATCH v2 2/2] drm/i915/gvt: mdev aggregation type
Thread-Topic: [PATCH v2 2/2] drm/i915/gvt: mdev aggregation type
Thread-Index: AQHWAzE8uZfRrqms+UGN02f5QAMK/6hah5QggAEKxoCAAI40QP//frKAgACOdNA=
Date:   Fri, 27 Mar 2020 09:31:35 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D7ED44B@SHSMSX104.ccr.corp.intel.com>
References: <20200326054136.2543-1-zhenyuw@linux.intel.com>
 <20200326054136.2543-3-zhenyuw@linux.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D7ED10B@SHSMSX104.ccr.corp.intel.com>
 <20200327081215.GJ8880@zhen-hp.sh.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D7ED38D@SHSMSX104.ccr.corp.intel.com>
 <20200327085825.GK8880@zhen-hp.sh.intel.com>
In-Reply-To: <20200327085825.GK8880@zhen-hp.sh.intel.com>
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

PiBGcm9tOiBaaGVueXUgV2FuZyA8emhlbnl1d0BsaW51eC5pbnRlbC5jb20+DQo+IFNlbnQ6IEZy
aWRheSwgTWFyY2ggMjcsIDIwMjAgNDo1OCBQTQ0KPiANCj4gT24gMjAyMC4wMy4yNyAwODo0NDo1
OSArMDAwMCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4gPiBGcm9tOiBaaGVueXUgV2FuZyA8emhl
bnl1d0BsaW51eC5pbnRlbC5jb20+DQo+ID4gPiBTZW50OiBGcmlkYXksIE1hcmNoIDI3LCAyMDIw
IDQ6MTIgUE0NCj4gPiA+DQo+ID4gWy4uLl0NCj4gPiA+ID4gPiAraW50IGludGVsX3ZncHVfYWRq
dXN0X3Jlc291cmNlX2NvdW50KHN0cnVjdCBpbnRlbF92Z3B1ICp2Z3B1KQ0KPiA+ID4gPiA+ICt7
DQo+ID4gPiA+ID4gKwlpZiAoKHZncHVfYXBlcnR1cmVfc3oodmdwdSkgIT0gdmdwdS0+cGFyYW0u
bG93X2dtX3N6ICoNCj4gPiA+ID4gPiArCSAgICAgdmdwdS0+cGFyYW0uYWdncmVnYXRpb24pIHx8
DQo+ID4gPiA+ID4gKwkgICAgKHZncHVfaGlkZGVuX3N6KHZncHUpICE9IHZncHUtPnBhcmFtLmhp
Z2hfZ21fc3ogKg0KPiA+ID4gPiA+ICsJICAgICB2Z3B1LT5wYXJhbS5hZ2dyZWdhdGlvbikpIHsN
Cj4gPiA+ID4gPiArCQkvKiBoYW5kbGUgYWdncmVnYXRpb24gY2hhbmdlICovDQo+ID4gPiA+ID4g
KwkJaW50ZWxfdmdwdV9mcmVlX3Jlc291cmNlX2NvdW50KHZncHUpOw0KPiA+ID4gPiA+ICsJCWlu
dGVsX3ZncHVfYWxsb2NfcmVzb3VyY2VfY291bnQodmdwdSk7DQo+ID4gPiA+DQo+ID4gPiA+IHRo
aXMgbG9naWMgc291bmRzIGxpa2UgZGlmZmVyZW50IGZyb20gdGhlIGNvbW1pdCBtc2cuIEVhcmxp
ZXIgeW91DQo+ID4gPiA+IHNhaWQgdGhlIHJlc291cmNlIGlzIG5vdCBhbGxvY2F0ZWQgdW50aWwg
bWRldiBvcGVuLCB3aGlsZSB0aGUNCj4gPiA+ID4gYWdncmVnYXRlZF9pbnRlcmZhY2VzIGlzIG9u
bHkgYWxsb3dlZCB0byBiZSB3cml0dGVuIGJlZm9yZQ0KPiA+ID4gPiBtZGV2IG9wZW4uIEluIHN1
Y2ggY2FzZSwgd2h5IHdvdWxkIGl0IHJlcXVpcmVkIHRvIGhhbmRsZSB0aGUNCj4gPiA+ID4gY2Fz
ZSB3aGVyZSBhIHZncHUgYWxyZWFkeSBoYXMgcmVzb3VyY2UgYWxsb2NhdGVkIHRoZW4gY29taW5n
DQo+ID4gPiA+IGEgbmV3IHJlcXVlc3QgdG8gYWRqdXN0IHRoZSBudW1iZXIgb2YgaW5zdGFuY2Vz
Pw0KPiA+ID4NCj4gPiA+IFRoaXMgaXMgdG8gaGFuZGxlIHJlc291cmNlIGFjY291bnRpbmcgYmVm
b3JlIG1kZXYgb3BlbiBieSBhZ2dyZWdhdGlvbg0KPiA+ID4gc2V0dGluZyBjaGFuZ2UuIFdoZW4g
dmdwdSBjcmVhdGUgZnJvbSBtZGV2IHR5cGUsIGRlZmF1bHQgcmVzb3VyY2UNCj4gPiA+IGNvdW50
IGFjY29yZGluZyB0byB0eXBlIGlzIHNldCBmb3IgdmdwdS4gU28gdGhpcyBmdW5jdGlvbiBpcyBq
dXN0IHRvDQo+ID4gPiBjaGFuZ2UgcmVzb3VyY2UgY291bnQgYnkgYWdncmVnYXRpb24uDQo+ID4N
Cj4gPiB0aGVuIGJldHRlciBjaGFuZ2UgdGhlIG5hbWUsIGUuZy4gLnh4eF9hZGp1c3RfcmVzb3Vy
Y2VfYWNjb3VudGluZywNCj4gPiBvdGhlcndpc2UgaXQncyBlYXN5IHRvIGJlIGNvbmZ1c2VkLg0K
PiA+DQo+IA0KPiBvaw0KPiANCj4gPiBbLi4uXQ0KPiA+ID4gPiA+ICAJaWYgKHJldCkNCj4gPiA+
ID4gPiAgCQlnb3RvIG91dF9jbGVhbl92Z3B1X21taW87DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiAt
CXBvcHVsYXRlX3B2aW5mb19wYWdlKHZncHUpOw0KPiA+ID4gPiA+ICsJaWYgKCFkZWxheV9yZXNf
YWxsb2MpIHsNCj4gPiA+ID4gPiArCQlyZXQgPSBpbnRlbF92Z3B1X3Jlc19hbGxvYyh2Z3B1KTsN
Cj4gPiA+ID4gPiArCQlpZiAocmV0KQ0KPiA+ID4gPiA+ICsJCQlnb3RvIG91dF9jbGVhbl92Z3B1
X21taW87DQo+ID4gPiA+ID4gKwl9DQo+ID4gPiA+DQo+ID4gPiA+IElmIGRlbGF5ZWQgcmVzb3Vy
Y2UgYWxsb2NhdGlvbiB3b3JrcyBjb3JyZWN0bHksIHdoeSBkbyB3ZSBzdGlsbA0KPiA+ID4gPiBu
ZWVkIHN1cHBvcnQgbm9uLWRlbGF5ZWQgZmxhdm9yPyBFdmVuIGEgdHlwZSBkb2Vzbid0IHN1cHBv
cnQNCj4gPiA+ID4gYWdncmVnYXRpb24sIGl0IGRvZXNuJ3QgaHVydCB0byBkbyBhbGxvY2F0aW9u
IHVudGlsIG1kZXYgb3Blbi4uLg0KPiA+ID4gPg0KPiA+ID4NCj4gPiA+IFRoZSBkaWZmZXJlbmNl
IGlzIHVzZXIgZXhwZWN0YXRpb24gSSB0aGluaywgaWYgdGhlcmUncyByZWFsbHkNCj4gPiA+IGF3
YXJlbmVzcyBvZiB0aGlzLiBBcyBvcmlnaW5hbCB3YXkgaXMgdG8gYWxsb2NhdGUgYXQgY3JlYXQg
dGltZSwgc28NCj4gPiA+IG9uY2UgY3JlYXRlZCBzdWNjZXNzLCByZXNvdXJjZSBpcyBndWFyYW50
ZWVkLiBCdXQgZm9yIGFnZ3JlZ2F0aW9uIHR5cGUNCj4gPiA+IHdoaWNoIGNvdWxkIGJlIGNoYW5n
ZWQgYmVmb3JlIG9wZW4sIGFsbG9jIGhhcHBlbnMgYXQgdGhhdCB0aW1lIHdoaWNoDQo+ID4gPiBt
YXkgaGF2ZSBkaWZmZXJlbnQgc2NlbmFyaW8sIGUuZyBtaWdodCBmYWlsIGNhdXNlZCBieSBvdGhl
ciBpbnN0YW5jZQ0KPiA+ID4gb3IgaG9zdC4gU28gb3JpZ2luYWwgaWRlYSBpcyB0byBrZWVwIG9s
ZCBiZWhhdmlvciBidXQgb25seSBjaGFuZ2UgZm9yDQo+ID4gPiBhZ2dyZWdhdGlvbiB0eXBlLg0K
PiA+DQo+ID4gYnV0IGhvdyBjb3VsZCBvbmUgZXhwZWN0IGFueSBkaWZmZXJlbmNlIGJldHdlZW4g
aW5zdGFudCBhbGxvY2F0aW9uDQo+ID4gYW5kIGRlbGF5ZWQgYWxsb2NhdGlvbj8gWW91IGFscmVh
ZHkgdXBkYXRlIHJlc291cmNlIGFjY291bnRpbmcgc28NCj4gPiB0aGUgcmVtYWluaW5nIGluc3Rh
bmNlcyBhcmUgYWNjdXJhdGUgYW55d2F5LiBUaGVuIHRoZSB1c2VyIG9ubHkga25vd3MNCj4gPiBo
b3cgdGhlIHZncHUgbG9va3MgbGlrZSB3aGVuIGl0IGlzIG9wZW5lZC4uLg0KPiA+DQo+ID4gPg0K
PiA+ID4gSWYgd2UgdGhpbmsgdGhpcyB1c2VyIGV4cGVjdGF0aW9uIGlzIG5vdCBpbXBvcnRhbnQs
IGRlbGF5ZWQgYWxsb2MNCj4gPiA+IGNvdWxkIGhlbHAgdG8gY3JlYXRlIHZncHUgcXVpY2tseSBi
dXQgbWF5IGhhdmUgbW9yZSBjaGFuY2UgdG8gZmFpbA0KPiA+ID4gbGF0ZXIuLg0KPiA+ID4NCj4g
Pg0KPiA+IHdoeT8gSWYgZGVsYXllZCBhbGxvY2F0aW9uIGhhcyBtb3JlIGNoYW5jZSB0byBmYWls
LCBpdCBtZWFucyBvdXINCj4gPiByZXNvdXJjZSBhY2NvdW50aW5nIGhhcyBwcm9ibGVtLiBFdmVu
IGZvciB0eXBlIHcvbyBhZ2dyZWdhdGlvbg0KPiA+IGNhcGFiaWxpdHksIHdlIHNob3VsZCByZXNl
cnZlIG9uZSBpbnN0YW5jZSByZXNvdXJjZSBieSBkZWZhdWx0IGFueXdheQ0KPiA+DQo+IA0KPiBJ
ZiB1bmRlciByZWFsbHkgaGVhdnkgbG9hZCBvZiBob3N0IGFuZCBtYW55IG90aGVyIHZncHUgcnVu
bmluZywgd2UNCj4gbWlnaHQgbm90IGhhdmUgbGVmdCBjb250aW51YWwgZ2Z4IG1lbSBzcGFjZS4u
VGhpcyBpcyBub3QgbmV3IHByb2JsZW0sDQo+IGp1c3QgdGhhdCBub3cgd2UgaGFuZGxlIGl0IGF0
IHZncHUgY3JlYXRlIHRpbWUgdG8gcmVzZXJ2ZSB0aGUNCj4gcmVzb3VyY2UuIE9uY2UgaG9zdCBz
aWRlIGNvdWxkIHByb21pc2Ugc29tZSBsaW1pdCwgdGhlbiBvdXIgdXNhZ2UNCj4gd2lsbCBiZSBn
dWFyYW50ZWVkLg0KPiANCg0KaGVhdnkgbG9hZCBkb2Vzbid0IG1lYW4gdGhhdCB5b3UgbWF5IGhh
dmUgaGlnaGVyIHBvc3NpYmlsaXR5IG9mDQpzZWN1cmluZyByZXNvdXJjZSBhdCBhIGVhcmxpZXIg
cG9pbnQuIEl0J3MgY29tcGxldGVseSBub25kZXRlcm1pbmlzdGljDQp3aGVuIHRoZSBzaXR1YXRp
b24gaXMgd29yc2Ugb3IgYmV0dGVyLiBJbiBzdWNoIGNhc2UgSSBkb24ndCB0aGluayANCnRoZXJl
IGlzIHN1YnRsZSBkaWZmZXJlbmNlIGJldHdlZW4gaW5zdGFudCBhbmQgZGVsYXllZCBhbGxvY2F0
aW9uLA0Kd2hpbGUgdW5pZnlpbmcgb24gZGVsYXllZCBhbGxvY2F0aW9uIGNvdWxkIHNpbXBsaWZ5
IG91ciBjb2RlLiDwn5iKDQoNClRoYW5rcw0KS2V2aW4NCg==
