Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A53218ACA6
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 07:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgCSGNR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 02:13:17 -0400
Received: from mga04.intel.com ([192.55.52.120]:62892 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgCSGNQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 02:13:16 -0400
IronPort-SDR: +BHVM9Ee+l4dg2OfdYk2TT/x7akb4dod2o4/934llKl9bMdlvP476vZwBIxWU2kG8LKeO4r7NU
 HkT06CK5GzTg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 23:13:16 -0700
IronPort-SDR: tCGZPbLdaeDR2b3+pyNi2ayHDMczwriRIZZYMGnHOfV8Sd3ukDD1KpOxz7CHjFCYuzmMLAyOWf
 Tw/xugilGiIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,570,1574150400"; 
   d="scan'208";a="418229706"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga005.jf.intel.com with ESMTP; 18 Mar 2020 23:13:15 -0700
Received: from fmsmsx123.amr.corp.intel.com (10.18.125.38) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 18 Mar 2020 23:13:15 -0700
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 fmsmsx123.amr.corp.intel.com (10.18.125.38) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 18 Mar 2020 23:13:15 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.96]) with mapi id 14.03.0439.000;
 Thu, 19 Mar 2020 14:13:12 +0800
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
Thread-Index: AQHV/Nh9FI7fbfgIUkqDZ3DrcNQ1xKhN+YUAgAFLryA=
Date:   Thu, 19 Mar 2020 06:13:11 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E1738A8E20@SHSMSX104.ccr.corp.intel.com>
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

PiA+IElmIHRoZSBsb2dpY2FsIHByb2Nlc3NvciBpcyBvcGVyYXRpbmcgd2l0aCBJbnRlbCBQVCBl
bmFibGVkICgNCj4gPiBJQTMyX1JUSVRfQ1RMLlRyYWNlRW4gPSAxKSBhdCB0aGUgdGltZSBvZiBW
TSBlbnRyeSwgdGhlIOKAnGxvYWQNCj4gPiBJQTMyX1JUSVRfQ1RM4oCdIFZNLWVudHJ5IGNvbnRy
b2wgbXVzdCBiZSAwKFNETSAyNi4yLjEuMSkuDQo+ID4NCj4gPiBUaGUgZmlyc3QgZGlzYWJsZWQg
dGhlIGhvc3QgSW50ZWwgUFQoQ2xlYXIgVHJhY2VFbikgd2lsbCBtYWtlIGFsbCB0aGUNCj4gPiBi
dWZmZXJlZCBwYWNrZXRzIGFyZSBmbHVzaGVkIG91dCBvZiB0aGUgcHJvY2Vzc29yIGFuZCBpdCBt
YXkgY2F1c2UgYW4NCj4gPiBJbnRlbCBQVCBQTUkuIFRoZSBob3N0IEludGVsIFBUIHdpbGwgYmUg
cmUtZW5hYmxlZCBpbiB0aGUgaG9zdCBJbnRlbA0KPiA+IFBUIFBNSSBoYW5kbGVyLg0KPiA+DQo+
ID4gaGFuZGxlX3BtaV9jb21tb24oKQ0KPiA+ICAgICAtPiBpbnRlbF9wdF9pbnRlcnJ1cHQoKQ0K
PiA+ICAgICAgICAgICAgIC0+IHB0X2NvbmZpZ19zdGFydCgpDQo+IA0KPiBJSVVDLCB0aGlzIGlz
IG9ubHkgcG9zc2libGUgd2hlbiBQVCAicGxheXMgbmljZSIgd2l0aCBWTVgsIGNvcnJlY3Q/DQo+
IE90aGVyd2lzZSBwdC0+dm14X29uIHdpbGwgYmUgdHJ1ZSBhbmQgcHRfY29uZmlnX3N0YXJ0KCkg
d291bGQgc2tpcCB0aGUNCj4gV1JNU1IuDQoNClllcy4gVGhlIHB0X2NvbmZpZ19zdGFydCgpIHdv
dWxkIHNraXAgdGhlIFdSTVNSIGlmIHRoZSBIVyBkb2Vzbid0IHN1cHBvcnQgZW5hYmxlIFBUIGFj
cm9zcyB0aGUgVk1YLg0KDQo+IA0KPiBBbmQgSVBUIFBNSSBtdXN0IGJlIGRlbGl2ZXJlZCB2aWEg
Tk1JICh0aG91Z2ggbWF5YmUgdGhleSdyZSBhbHdheXMNCj4gZGVsaXZlcmVkIHZpYSBOTUk/KS4N
Cg0KWWVzLCBJUFQgUE1JIGlzIGFuIE5NSSBpbiB0aGUgaG9zdC4NCg0KPiANCj4gSW4gYW55IGNh
c2UsIHJlZG9pbmcgV1JNU1IgZG9lc24ndCBzZWVtIHNhZmUsIGFuZCBpdCBjZXJ0YWlubHkgaXNu
J3QNCj4gcGVyZm9ybWFudCwgZS5nLiB3aGF0IHByZXZlbnRzIHRoZSBzZWNvbmQgV1JNU1IgZnJv
bSB0cmlnZ2VyaW5nIGEgc2Vjb25kDQo+IElQVCBQTUk/DQoNClR3aWNlIGlzIGVub3VnaC4gVGhl
cmUgaXMgcHJvYmFibHkgYSBsb3Qgb2YgUFQgdHJhY2Ugbm90IGZsdXNoIG91dCBhbmQgYSBQTUkg
d2lsbCBoYXBwZW4gYWZ0ZXIgdGhlIGZpcnN0IFdSTVNSLiBUaGVyZSBhcmUgbm90IHNvIG11Y2gg
ZGF0YSBiZXR3ZWVuIHRoZSBlbmQgb2YgdGhlIFBNSSBoYW5kbGVyIGFuZCB0aGUgc2Vjb25kIFdS
TVNSLg0KDQo+IA0KPiBwdF9ndWVzdF9lbnRlcigpIGlzIGNhbGxlZCBhZnRlciB0aGUgc3dpdGNo
IHRvIHRoZSB2Q1BVIGhhcyBhbHJlYWR5IGJlZW4NCj4gcmVjb3JkZWQsIGNhbid0IHRoaXMgYmUg
aGFuZGxlZCBpbiB0aGUgSVBUIGNvZGUsIGUuZy4gc29tZXRoaW5nIGxpa2UgdGhpcz8NCj4gDQo+
IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9ldmVudHMvaW50ZWwvcHQuYyBiL2FyY2gveDg2L2V2ZW50
cy9pbnRlbC9wdC5jIGluZGV4DQo+IDFkYjdhNTFkOTc5Mi4uZTM4ZGRhZTlmMGQxIDEwMDY0NA0K
PiAtLS0gYS9hcmNoL3g4Ni9ldmVudHMvaW50ZWwvcHQuYw0KPiArKysgYi9hcmNoL3g4Ni9ldmVu
dHMvaW50ZWwvcHQuYw0KPiBAQCAtNDA1LDcgKzQwNSw3IEBAIHN0YXRpYyB2b2lkIHB0X2NvbmZp
Z19zdGFydChzdHJ1Y3QgcGVyZl9ldmVudCAqZXZlbnQpDQo+ICAgICAgICAgY3RsIHw9IFJUSVRf
Q1RMX1RSQUNFRU47DQo+ICAgICAgICAgaWYgKFJFQURfT05DRShwdC0+dm14X29uKSkNCj4gICAg
ICAgICAgICAgICAgIHBlcmZfYXV4X291dHB1dF9mbGFnKCZwdC0+aGFuZGxlLCBQRVJGX0FVWF9G
TEFHX1BBUlRJQUwpOw0KPiAtICAgICAgIGVsc2UNCj4gKyAgICAgICBlbHNlICghKGN1cnJlbnQt
PmZsYWdzICYgUEZfVkNQVSkpDQo+ICAgICAgICAgICAgICAgICB3cm1zcmwoTVNSX0lBMzJfUlRJ
VF9DVEwsIGN0bCk7DQo+IA0KPiAgICAgICAgIFdSSVRFX09OQ0UoZXZlbnQtPmh3LmNvbmZpZywg
Y3RsKTsNCg0KVGhhbmtzLiBCdXQgSSBhbSBhZnJhaWQgdGhlIGhvc3QgcGVyZiBkb27igJl0IGxp
a2UgYW55IHZpcnR1YWxpemF0aW9uIHNwZWNpZmljIGNoYW5nZXMuIEkgd2lsbCB0cnkgdGhpcy4N
Cg0KTHV3ZWkgS2FuZw0KDQo+IA0KPiA+IFRoaXMgcGF0Y2ggd2lsbCBkaXNhYmxlIHRoZSBJbnRl
bCBQVCB0d2ljZSB0byBtYWtlIHN1cmUgdGhlIEludGVsIFBUDQo+ID4gaXMgZGlzYWJsZWQgYmVm
b3JlIFZNLUVudHJ5Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogTHV3ZWkgS2FuZyA8bHV3ZWku
a2FuZ0BpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGFyY2gveDg2L2t2bS92bXgvdm14LmMgfCAx
MCArKysrKysrKystDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDEgZGVs
ZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jIGIv
YXJjaC94ODYva3ZtL3ZteC92bXguYyBpbmRleA0KPiA+IDI2ZjhmMzEuLmQ5MzZhOTEgMTAwNjQ0
DQo+ID4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiA+ICsrKyBiL2FyY2gveDg2L2t2
bS92bXgvdm14LmMNCj4gPiBAQCAtMTA5NSw2ICsxMDk1LDggQEAgc3RhdGljIGlubGluZSB2b2lk
IHB0X3NhdmVfbXNyKHN0cnVjdCBwdF9jdHgNCj4gPiAqY3R4LCB1MzIgYWRkcl9yYW5nZSkNCj4g
Pg0KPiA+ICBzdGF0aWMgdm9pZCBwdF9ndWVzdF9lbnRlcihzdHJ1Y3QgdmNwdV92bXggKnZteCkg
IHsNCj4gPiArCXU2NCBydGl0X2N0bDsNCj4gPiArDQo+ID4gIAlpZiAocHRfbW9kZSA9PSBQVF9N
T0RFX1NZU1RFTSkNCj4gPiAgCQlyZXR1cm47DQo+ID4NCj4gPiBAQCAtMTEwMyw4ICsxMTA1LDE0
IEBAIHN0YXRpYyB2b2lkIHB0X2d1ZXN0X2VudGVyKHN0cnVjdCB2Y3B1X3ZteCAqdm14KQ0KPiA+
ICAJICogU2F2ZSBob3N0IHN0YXRlIGJlZm9yZSBWTSBlbnRyeS4NCj4gPiAgCSAqLw0KPiA+ICAJ
cmRtc3JsKE1TUl9JQTMyX1JUSVRfQ1RMLCB2bXgtPnB0X2Rlc2MuaG9zdC5jdGwpOw0KPiA+IC0J
aWYgKHZteC0+cHRfZGVzYy5ndWVzdC5jdGwgJiBSVElUX0NUTF9UUkFDRUVOKSB7DQo+ID4gKwlp
ZiAodm14LT5wdF9kZXNjLmhvc3QuY3RsICYgUlRJVF9DVExfVFJBQ0VFTikgew0KPiA+ICAJCXdy
bXNybChNU1JfSUEzMl9SVElUX0NUTCwgMCk7DQo+ID4gKwkJcmRtc3JsKE1TUl9JQTMyX1JUSVRf
Q1RMLCBydGl0X2N0bCk7DQo+ID4gKwkJaWYgKHJ0aXRfY3RsKQ0KPiA+ICsJCQl3cm1zcmwoTVNS
X0lBMzJfUlRJVF9DVEwsIDApOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCWlmICh2bXgtPnB0X2Rl
c2MuZ3Vlc3QuY3RsICYgUlRJVF9DVExfVFJBQ0VFTikgew0KPiA+ICAJCXB0X3NhdmVfbXNyKCZ2
bXgtPnB0X2Rlc2MuaG9zdCwgdm14LQ0KPiA+cHRfZGVzYy5hZGRyX3JhbmdlKTsNCj4gPiAgCQlw
dF9sb2FkX21zcigmdm14LT5wdF9kZXNjLmd1ZXN0LCB2bXgtDQo+ID5wdF9kZXNjLmFkZHJfcmFu
Z2UpOw0KPiA+ICAJfQ0KPiA+IC0tDQo+ID4gMS44LjMuMQ0KPiA+DQo=
