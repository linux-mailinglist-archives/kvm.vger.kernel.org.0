Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27326198A7F
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 05:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbgCaD3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 23:29:30 -0400
Received: from mga17.intel.com ([192.55.52.151]:49295 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727358AbgCaD3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 23:29:30 -0400
IronPort-SDR: WKixkB4qGUoOe4Gm257fxpEShDQnvYDpPSygS5fLh5xpKAZL/TM/IbssJpLBtnsSDHZDWk56gx
 wIcO9kACe2pA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 20:29:29 -0700
IronPort-SDR: Y9CbFUs/KSal0b/RN+y3oz1G8RxDxU7qi0JkZGFrEjycdmLJpcA5BeGVMUzLjp4NPc9ePGbdwR
 3bJ4GddnFhag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,326,1580803200"; 
   d="scan'208";a="294802480"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Mar 2020 20:29:29 -0700
Received: from fmsmsx163.amr.corp.intel.com (10.18.125.72) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 20:29:29 -0700
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 fmsmsx163.amr.corp.intel.com (10.18.125.72) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Mar 2020 20:29:29 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.191]) with mapi id 14.03.0439.000;
 Tue, 31 Mar 2020 11:29:26 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: RE: [PATCH] KVM: VMX: Disable Intel PT before VM-entry
Thread-Topic: [PATCH] KVM: VMX: Disable Intel PT before VM-entry
Thread-Index: AQHV/Nh9FI7fbfgIUkqDZ3DrcNQ1xKhN+YUAgAfwusCACwVbAIABLSaw
Date:   Tue, 31 Mar 2020 03:29:26 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E1738B1A1C@SHSMSX104.ccr.corp.intel.com>
References: <1584503298-18731-1-git-send-email-luwei.kang@intel.com>
 <20200318154826.GC24357@linux.intel.com>
 <82D7661F83C1A047AF7DC287873BF1E1738A9724@SHSMSX104.ccr.corp.intel.com>
 <20200330172152.GE24988@linux.intel.com>
In-Reply-To: <20200330172152.GE24988@linux.intel.com>
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

PiA+ID4gT24gV2VkLCBNYXIgMTgsIDIwMjAgYXQgMTE6NDg6MThBTSArMDgwMCwgTHV3ZWkgS2Fu
ZyB3cm90ZToNCj4gPiA+ID4gSWYgdGhlIGxvZ2ljYWwgcHJvY2Vzc29yIGlzIG9wZXJhdGluZyB3
aXRoIEludGVsIFBUIGVuYWJsZWQgKA0KPiA+ID4gPiBJQTMyX1JUSVRfQ1RMLlRyYWNlRW4gPSAx
KSBhdCB0aGUgdGltZSBvZiBWTSBlbnRyeSwgdGhlIOKAnGxvYWQNCj4gPiA+ID4gSUEzMl9SVElU
X0NUTOKAnSBWTS1lbnRyeSBjb250cm9sIG11c3QgYmUgMChTRE0gMjYuMi4xLjEpLg0KPiA+ID4g
Pg0KPiA+ID4gPiBUaGUgZmlyc3QgZGlzYWJsZWQgdGhlIGhvc3QgSW50ZWwgUFQoQ2xlYXIgVHJh
Y2VFbikgd2lsbCBtYWtlIGFsbA0KPiA+ID4gPiB0aGUgYnVmZmVyZWQgcGFja2V0cyBhcmUgZmx1
c2hlZCBvdXQgb2YgdGhlIHByb2Nlc3NvciBhbmQgaXQgbWF5DQo+ID4gPiA+IGNhdXNlIGFuIElu
dGVsIFBUIFBNSS4gVGhlIGhvc3QgSW50ZWwgUFQgd2lsbCBiZSByZS1lbmFibGVkIGluIHRoZQ0K
PiA+ID4gPiBob3N0IEludGVsIFBUIFBNSSBoYW5kbGVyLg0KPiA+ID4gPg0KPiA+ID4gPiBoYW5k
bGVfcG1pX2NvbW1vbigpDQo+ID4gPiA+ICAgICAtPiBpbnRlbF9wdF9pbnRlcnJ1cHQoKQ0KPiA+
ID4gPiAgICAgICAgICAgICAtPiBwdF9jb25maWdfc3RhcnQoKQ0KPiA+ID4NCj4gPiA+IElJVUMs
IHRoaXMgaXMgb25seSBwb3NzaWJsZSB3aGVuIFBUICJwbGF5cyBuaWNlIiB3aXRoIFZNWCwgY29y
cmVjdD8NCj4gPiA+IE90aGVyd2lzZSBwdC0+dm14X29uIHdpbGwgYmUgdHJ1ZSBhbmQgcHRfY29u
ZmlnX3N0YXJ0KCkgd291bGQgc2tpcA0KPiA+ID4gdGhlIFdSTVNSLg0KPiA+ID4NCj4gPiA+IEFu
ZCBJUFQgUE1JIG11c3QgYmUgZGVsaXZlcmVkIHZpYSBOTUkgKHRob3VnaCBtYXliZSB0aGV5J3Jl
IGFsd2F5cw0KPiA+ID4gZGVsaXZlcmVkIHZpYSBOTUk/KS4NCj4gPiA+DQo+ID4gPiBJbiBhbnkg
Y2FzZSwgcmVkb2luZyBXUk1TUiBkb2Vzbid0IHNlZW0gc2FmZSwgYW5kIGl0IGNlcnRhaW5seSBp
c24ndA0KPiA+ID4gcGVyZm9ybWFudCwgZS5nLiB3aGF0IHByZXZlbnRzIHRoZSBzZWNvbmQgV1JN
U1IgZnJvbSB0cmlnZ2VyaW5nIGENCj4gPiA+IHNlY29uZCBJUFQgUE1JPw0KPiA+ID4NCj4gPiA+
IHB0X2d1ZXN0X2VudGVyKCkgaXMgY2FsbGVkIGFmdGVyIHRoZSBzd2l0Y2ggdG8gdGhlIHZDUFUg
aGFzIGFscmVhZHkNCj4gPiA+IGJlZW4gcmVjb3JkZWQsIGNhbid0IHRoaXMgYmUgaGFuZGxlZCBp
biB0aGUgSVBUIGNvZGUsIGUuZy4gc29tZXRoaW5nIGxpa2UNCj4gdGhpcz8NCj4gPiA+DQo+ID4g
PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvZXZlbnRzL2ludGVsL3B0LmMgYi9hcmNoL3g4Ni9ldmVu
dHMvaW50ZWwvcHQuYw0KPiA+ID4gaW5kZXgNCj4gPiA+IDFkYjdhNTFkOTc5Mi4uZTM4ZGRhZTlm
MGQxIDEwMDY0NA0KPiA+ID4gLS0tIGEvYXJjaC94ODYvZXZlbnRzL2ludGVsL3B0LmMNCj4gPiA+
ICsrKyBiL2FyY2gveDg2L2V2ZW50cy9pbnRlbC9wdC5jDQo+ID4gPiBAQCAtNDA1LDcgKzQwNSw3
IEBAIHN0YXRpYyB2b2lkIHB0X2NvbmZpZ19zdGFydChzdHJ1Y3QgcGVyZl9ldmVudCAqZXZlbnQp
DQo+ID4gPiAgICAgICAgIGN0bCB8PSBSVElUX0NUTF9UUkFDRUVOOw0KPiA+ID4gICAgICAgICBp
ZiAoUkVBRF9PTkNFKHB0LT52bXhfb24pKQ0KPiA+ID4gICAgICAgICAgICAgICAgIHBlcmZfYXV4
X291dHB1dF9mbGFnKCZwdC0+aGFuZGxlLCBQRVJGX0FVWF9GTEFHX1BBUlRJQUwpOw0KPiA+ID4g
LSAgICAgICBlbHNlDQo+ID4gPiArICAgICAgIGVsc2UgKCEoY3VycmVudC0+ZmxhZ3MgJiBQRl9W
Q1BVKSkNCj4gPiA+ICAgICAgICAgICAgICAgICB3cm1zcmwoTVNSX0lBMzJfUlRJVF9DVEwsIGN0
bCk7DQo+ID4NCj4gPiBJbnRlbCBQVCBjYW4gd29yayBpbiBTWVNURU0gYW5kIEhPU1RfR1VFU1Qg
bW9kZSBieSBzZXR0aW5nIHRoZQ0KPiA+IGt2bS1pbnRlbC5rbyBwYXJhbWV0ZXIgInB0X21vZGUi
LiAgSW4gU1lTVEVNIG1vZGUsIHRoZSBob3N0IGFuZCBndWVzdA0KPiA+IFBUIHRyYWNlIHdpbGwg
YmUgc2F2ZWQgaW4gdGhlIGhvc3QgYnVmZmVyLiBUaGUgS1ZNIGRvIG5vdGhpbmcgZHVyaW5nDQo+
ID4gVk0tZW50cnkvZXhpdCBpbiBTWVNURU0gbW9kZSBhbmQgSW50ZWwgUFQgUE1JIG1heSBoYXBw
ZW5lZCBvbiBhbnkNCj4gPiBwbGFjZS4gVGhlIFBUIHRyYWNlIG1heSBiZSBkaXNhYmxlZCB3aGVu
IHJ1bm5pbmcgaW4gS1ZNKFBUIG9ubHkgbmVlZHMNCj4gPiB0byBiZSBkaXNhYmxlZCBiZWZvcmUg
Vk0tZW50cnkgaW4gSE9TVF9HVUVTVCBtb2RlKS4NCj4gDQo+IEFoLCByaWdodC4gIFdoYXQgYWJv
dXQgZW5oYW5jaW5nIGludGVsX3B0X2hhbmRsZV92bXgoKSBhbmQgJ3N0cnVjdCBwdCcgdG8NCj4g
cmVwbGFjZSB2bXhfb24gd2l0aCBhIGZpZWxkIHRoYXQgaW5jb3Jwb3JhdGVzIHRoZSBLVk0gbW9k
ZT8NCg0KU29tZSBoaXN0b3J5IGlzIHRoZSBob3N0IHBlcmYgZGlkbid0IGZ1bGx5IGFncmVlIHdp
dGggaW50cm9kdWNpbmcgSE9TVF9HVUVTVCBtb2RlIGZvciBQVCBpbiBLVk0uIEJlY2F1c2UgdGhl
IEtWTSB3aWxsIGRpc2FibGUgdGhlIGhvc3QgdHJhY2UgYmVmb3JlIFZNLWVudHJ5IGluIEhPU1Rf
R1VFU1QgbW9kZSBhbmQgS1ZNIGd1ZXN0IHdpbGwgd2luIGluIHRoaXMgY2FzZS4gZS5nLiBJbnRl
bCBQVCBoYXMgYmVlbiBlbmFibGVkIGluIEtWTSBndWVzdCBhbmQgdGhlIGhvc3Qgd2FudHMgdG8g
c3RhcnQgc3lzdGVtLXdpZGUgdHJhY2UoY29sbGVjdCBhbGwgdGhlIHRyYWNlIG9uIHRoaXMgc3lz
dGVtKSBhdCB0aGlzIHRpbWUsIHRoZSB0cmFjZSBwcm9kdWNlZCBieSB0aGUgR3Vlc3QgT1Mgd2ls
bCBiZSBzYXZlZCBpbiBndWVzdCBQVCBidWZmZXIgYW5kIGhvc3QgYnVmZmVyIGNhbid0IGdldCB0
aGlzLiBTbyBJIHByZWZlciBkb24ndCBpbnRyb2R1Y2UgdGhlIEtWTSBQVCBtb2RlIHRvIGhvc3Qg
cGVyZiBmcmFtZXdvcmsuIFRoZSBzaW1pbGFyIHByb2JsZW0gaGFwcGVucyBvbiBQRUJTIHZpcnR1
YWxpemF0aW9uIHZpYSBEUyBhcyB3ZWxsLg0KDQpUaGFua3MsDQpMdXdlaSBLYW5nDQoNCj4gIEZy
b20gYW4gb3V0c2lkZXIncyBwZXJzcGVjdGl2ZSwgdGhhdCdkIGJlIGFuIGltcHJvdm1lbnQgaXJy
ZXNwZWN0aXZlIG9mIHRoaXMgYnVnIGZpeCBhcw0KPiAndm14X29uJyBpcyBtaXNsZWFkaW5nLCBl
LmcuIGl0IGNhbiBiZSAlZmFsc2Ugd2hlbiB0aGUgQ1BVIGlzIHBvc3QtIFZNWE9OLA0KPiBhbmQg
cmVhbGx5IG1lYW5zICJwb3N0LVZNWE9OIGFuZCBJbnRlbCBQVCBjYW4ndCB0cmFjZSBpdCIuDQo=
