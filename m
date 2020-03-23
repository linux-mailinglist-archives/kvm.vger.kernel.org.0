Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECEFE18F1A1
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 10:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgCWJUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 05:20:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:51869 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727650AbgCWJUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 05:20:15 -0400
IronPort-SDR: BMI2jGWvrg7wszD5Eqv5IVTmjk+hEtUrh1VDn2nEyHIVkl7N4rnofNwESQWtae29gyQM4tnm/O
 jP9nbZFcn5aQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 02:20:11 -0700
IronPort-SDR: LKQNZLB1BZUqh/ypIKhHHHsV6NuYtcEoozkqRUqIjaIUiOjfbaUXJDu/s6ZPZeShBB6uy2EtzA
 TfaLrMQLhbcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,295,1580803200"; 
   d="scan'208";a="249556906"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga006.jf.intel.com with ESMTP; 23 Mar 2020 02:20:10 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 23 Mar 2020 02:20:10 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 23 Mar 2020 02:20:04 -0700
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 23 Mar 2020 02:20:03 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.86]) with mapi id 14.03.0439.000;
 Mon, 23 Mar 2020 17:20:02 +0800
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
Thread-Index: AQHV/Nh9FI7fbfgIUkqDZ3DrcNQ1xKhN+YUAgAfwusA=
Date:   Mon, 23 Mar 2020 09:20:01 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E1738A9724@SHSMSX104.ccr.corp.intel.com>
References: <1584503298-18731-1-git-send-email-luwei.kang@intel.com>
 <20200318154826.GC24357@linux.intel.com>
In-Reply-To: <20200318154826.GC24357@linux.intel.com>
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

PiBPbiBXZWQsIE1hciAxOCwgMjAyMCBhdCAxMTo0ODoxOEFNICswODAwLCBMdXdlaSBLYW5nIHdy
b3RlOg0KPiA+IElmIHRoZSBsb2dpY2FsIHByb2Nlc3NvciBpcyBvcGVyYXRpbmcgd2l0aCBJbnRl
bCBQVCBlbmFibGVkICgNCj4gPiBJQTMyX1JUSVRfQ1RMLlRyYWNlRW4gPSAxKSBhdCB0aGUgdGlt
ZSBvZiBWTSBlbnRyeSwgdGhlIOKAnGxvYWQNCj4gPiBJQTMyX1JUSVRfQ1RM4oCdIFZNLWVudHJ5
IGNvbnRyb2wgbXVzdCBiZSAwKFNETSAyNi4yLjEuMSkuDQo+ID4NCj4gPiBUaGUgZmlyc3QgZGlz
YWJsZWQgdGhlIGhvc3QgSW50ZWwgUFQoQ2xlYXIgVHJhY2VFbikgd2lsbCBtYWtlIGFsbCB0aGUN
Cj4gPiBidWZmZXJlZCBwYWNrZXRzIGFyZSBmbHVzaGVkIG91dCBvZiB0aGUgcHJvY2Vzc29yIGFu
ZCBpdCBtYXkgY2F1c2UgYW4NCj4gPiBJbnRlbCBQVCBQTUkuIFRoZSBob3N0IEludGVsIFBUIHdp
bGwgYmUgcmUtZW5hYmxlZCBpbiB0aGUgaG9zdCBJbnRlbA0KPiA+IFBUIFBNSSBoYW5kbGVyLg0K
PiA+DQo+ID4gaGFuZGxlX3BtaV9jb21tb24oKQ0KPiA+ICAgICAtPiBpbnRlbF9wdF9pbnRlcnJ1
cHQoKQ0KPiA+ICAgICAgICAgICAgIC0+IHB0X2NvbmZpZ19zdGFydCgpDQo+IA0KPiBJSVVDLCB0
aGlzIGlzIG9ubHkgcG9zc2libGUgd2hlbiBQVCAicGxheXMgbmljZSIgd2l0aCBWTVgsIGNvcnJl
Y3Q/DQo+IE90aGVyd2lzZSBwdC0+dm14X29uIHdpbGwgYmUgdHJ1ZSBhbmQgcHRfY29uZmlnX3N0
YXJ0KCkgd291bGQgc2tpcCB0aGUNCj4gV1JNU1IuDQo+IA0KPiBBbmQgSVBUIFBNSSBtdXN0IGJl
IGRlbGl2ZXJlZCB2aWEgTk1JICh0aG91Z2ggbWF5YmUgdGhleSdyZSBhbHdheXMNCj4gZGVsaXZl
cmVkIHZpYSBOTUk/KS4NCj4gDQo+IEluIGFueSBjYXNlLCByZWRvaW5nIFdSTVNSIGRvZXNuJ3Qg
c2VlbSBzYWZlLCBhbmQgaXQgY2VydGFpbmx5IGlzbid0DQo+IHBlcmZvcm1hbnQsIGUuZy4gd2hh
dCBwcmV2ZW50cyB0aGUgc2Vjb25kIFdSTVNSIGZyb20gdHJpZ2dlcmluZyBhIHNlY29uZA0KPiBJ
UFQgUE1JPw0KPiANCj4gcHRfZ3Vlc3RfZW50ZXIoKSBpcyBjYWxsZWQgYWZ0ZXIgdGhlIHN3aXRj
aCB0byB0aGUgdkNQVSBoYXMgYWxyZWFkeSBiZWVuDQo+IHJlY29yZGVkLCBjYW4ndCB0aGlzIGJl
IGhhbmRsZWQgaW4gdGhlIElQVCBjb2RlLCBlLmcuIHNvbWV0aGluZyBsaWtlIHRoaXM/DQo+IA0K
PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvZXZlbnRzL2ludGVsL3B0LmMgYi9hcmNoL3g4Ni9ldmVu
dHMvaW50ZWwvcHQuYyBpbmRleA0KPiAxZGI3YTUxZDk3OTIuLmUzOGRkYWU5ZjBkMSAxMDA2NDQN
Cj4gLS0tIGEvYXJjaC94ODYvZXZlbnRzL2ludGVsL3B0LmMNCj4gKysrIGIvYXJjaC94ODYvZXZl
bnRzL2ludGVsL3B0LmMNCj4gQEAgLTQwNSw3ICs0MDUsNyBAQCBzdGF0aWMgdm9pZCBwdF9jb25m
aWdfc3RhcnQoc3RydWN0IHBlcmZfZXZlbnQgKmV2ZW50KQ0KPiAgICAgICAgIGN0bCB8PSBSVElU
X0NUTF9UUkFDRUVOOw0KPiAgICAgICAgIGlmIChSRUFEX09OQ0UocHQtPnZteF9vbikpDQo+ICAg
ICAgICAgICAgICAgICBwZXJmX2F1eF9vdXRwdXRfZmxhZygmcHQtPmhhbmRsZSwgUEVSRl9BVVhf
RkxBR19QQVJUSUFMKTsNCj4gLSAgICAgICBlbHNlDQo+ICsgICAgICAgZWxzZSAoIShjdXJyZW50
LT5mbGFncyAmIFBGX1ZDUFUpKQ0KPiAgICAgICAgICAgICAgICAgd3Jtc3JsKE1TUl9JQTMyX1JU
SVRfQ1RMLCBjdGwpOw0KDQpJbnRlbCBQVCBjYW4gd29yayBpbiBTWVNURU0gYW5kIEhPU1RfR1VF
U1QgbW9kZSBieSBzZXR0aW5nIHRoZSBrdm0taW50ZWwua28gcGFyYW1ldGVyICJwdF9tb2RlIi4N
CkluIFNZU1RFTSBtb2RlLCB0aGUgaG9zdCBhbmQgZ3Vlc3QgUFQgdHJhY2Ugd2lsbCBiZSBzYXZl
ZCBpbiB0aGUgaG9zdCBidWZmZXIuIFRoZSBLVk0gZG8gbm90aGluZyBkdXJpbmcgVk0tZW50cnkv
ZXhpdCBpbiBTWVNURU0gbW9kZSBhbmQgSW50ZWwgUFQgUE1JIG1heSBoYXBwZW5lZCBvbiBhbnkg
cGxhY2UuIFRoZSBQVCB0cmFjZSBtYXkgYmUgZGlzYWJsZWQgd2hlbiBydW5uaW5nIGluIEtWTShQ
VCBvbmx5IG5lZWRzIHRvIGJlIGRpc2FibGVkIGJlZm9yZSBWTS1lbnRyeSBpbiBIT1NUX0dVRVNU
IG1vZGUpLg0KDQpUaGFua3MsDQpMdXdlaSBLYW5nDQoNCj4gDQo+ICAgICAgICAgV1JJVEVfT05D
RShldmVudC0+aHcuY29uZmlnLCBjdGwpOw0KPiANCj4gPiBUaGlzIHBhdGNoIHdpbGwgZGlzYWJs
ZSB0aGUgSW50ZWwgUFQgdHdpY2UgdG8gbWFrZSBzdXJlIHRoZSBJbnRlbCBQVA0KPiA+IGlzIGRp
c2FibGVkIGJlZm9yZSBWTS1FbnRyeS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEx1d2VpIEth
bmcgPGx1d2VpLmthbmdAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBhcmNoL3g4Ni9rdm0vdm14
L3ZteC5jIHwgMTAgKysrKysrKysrLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3Zt
eC92bXguYyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMgaW5kZXgNCj4gPiAyNmY4ZjMxLi5kOTM2
YTkxIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gPiArKysgYi9h
cmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+ID4gQEAgLTEwOTUsNiArMTA5NSw4IEBAIHN0YXRpYyBp
bmxpbmUgdm9pZCBwdF9zYXZlX21zcihzdHJ1Y3QgcHRfY3R4DQo+ID4gKmN0eCwgdTMyIGFkZHJf
cmFuZ2UpDQo+ID4NCj4gPiAgc3RhdGljIHZvaWQgcHRfZ3Vlc3RfZW50ZXIoc3RydWN0IHZjcHVf
dm14ICp2bXgpICB7DQo+ID4gKwl1NjQgcnRpdF9jdGw7DQo+ID4gKw0KPiA+ICAJaWYgKHB0X21v
ZGUgPT0gUFRfTU9ERV9TWVNURU0pDQo+ID4gIAkJcmV0dXJuOw0KPiA+DQo+ID4gQEAgLTExMDMs
OCArMTEwNSwxNCBAQCBzdGF0aWMgdm9pZCBwdF9ndWVzdF9lbnRlcihzdHJ1Y3QgdmNwdV92bXgg
KnZteCkNCj4gPiAgCSAqIFNhdmUgaG9zdCBzdGF0ZSBiZWZvcmUgVk0gZW50cnkuDQo+ID4gIAkg
Ki8NCj4gPiAgCXJkbXNybChNU1JfSUEzMl9SVElUX0NUTCwgdm14LT5wdF9kZXNjLmhvc3QuY3Rs
KTsNCj4gPiAtCWlmICh2bXgtPnB0X2Rlc2MuZ3Vlc3QuY3RsICYgUlRJVF9DVExfVFJBQ0VFTikg
ew0KPiA+ICsJaWYgKHZteC0+cHRfZGVzYy5ob3N0LmN0bCAmIFJUSVRfQ1RMX1RSQUNFRU4pIHsN
Cj4gPiAgCQl3cm1zcmwoTVNSX0lBMzJfUlRJVF9DVEwsIDApOw0KPiA+ICsJCXJkbXNybChNU1Jf
SUEzMl9SVElUX0NUTCwgcnRpdF9jdGwpOw0KPiA+ICsJCWlmIChydGl0X2N0bCkNCj4gPiArCQkJ
d3Jtc3JsKE1TUl9JQTMyX1JUSVRfQ1RMLCAwKTsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwlpZiAo
dm14LT5wdF9kZXNjLmd1ZXN0LmN0bCAmIFJUSVRfQ1RMX1RSQUNFRU4pIHsNCj4gPiAgCQlwdF9z
YXZlX21zcigmdm14LT5wdF9kZXNjLmhvc3QsIHZteC0NCj4gPnB0X2Rlc2MuYWRkcl9yYW5nZSk7
DQo+ID4gIAkJcHRfbG9hZF9tc3IoJnZteC0+cHRfZGVzYy5ndWVzdCwgdm14LQ0KPiA+cHRfZGVz
Yy5hZGRyX3JhbmdlKTsNCj4gPiAgCX0NCj4gPiAtLQ0KPiA+IDEuOC4zLjENCj4gPg0K
