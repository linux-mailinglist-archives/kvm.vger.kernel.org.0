Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFCCCC366
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 21:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbfJDTLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 15:11:30 -0400
Received: from mga03.intel.com ([134.134.136.65]:46817 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730323AbfJDTLa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 15:11:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 12:11:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,257,1566889200"; 
   d="scan'208";a="198945366"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Oct 2019 12:11:28 -0700
Received: from orsmsx113.amr.corp.intel.com (10.22.240.9) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 4 Oct 2019 12:11:28 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.161]) by
 ORSMSX113.amr.corp.intel.com ([169.254.9.232]) with mapi id 14.03.0439.000;
 Fri, 4 Oct 2019 12:11:28 -0700
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kristen@linux.intel.com" <kristen@linux.intel.com>,
        "Dock, Deneen T" <deneen.t.dock@intel.com>
Subject: Re: [RFC PATCH 06/13] kvm: Add KVM_CAP_EXECONLY_MEM
Thread-Topic: [RFC PATCH 06/13] kvm: Add KVM_CAP_EXECONLY_MEM
Thread-Index: AQHVejL6mafQlEjiE0aRKU+NPxwieadKimoAgADFkYA=
Date:   Fri, 4 Oct 2019 19:11:28 +0000
Message-ID: <f8df6b875e032b782faa839b31a1daf1d5575c6b.camel@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
         <20191003212400.31130-7-rick.p.edgecombe@intel.com>
         <0f2307a5-314d-d3df-0bc9-4c1fbbf93f72@redhat.com>
In-Reply-To: <0f2307a5-314d-d3df-0bc9-4c1fbbf93f72@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.54.75.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <65232FE7E5FB5C4F9EC9E3C5B9633569@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDE5LTEwLTA0IGF0IDA5OjI0ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAwMy8xMC8xOSAyMzoyMywgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+ID4gQWRkIGEgS1ZN
IGNhcGFiaWxpdHkgZm9yIHRoZSBLVk1fTUVNX0VYRUNPTkxZIG1lbXNsb3QgdHlwZS4gVGhpcyBt
ZW1zbG90DQo+ID4gdHlwZSBpcyBzdXBwb3J0ZWQgaWYgdGhlIEhXIHN1cHBvcnRzIGV4ZWN1dGUt
b25seSBURFAuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogUmljayBFZGdlY29tYmUgPHJpY2su
cC5lZGdlY29tYmVAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBhcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9rdm1faG9zdC5oIHwgMSArDQo+ID4gIGFyY2gveDg2L2t2bS9zdm0uYyAgICAgICAgICAgICAg
fCA2ICsrKysrKw0KPiA+ICBhcmNoL3g4Ni9rdm0vdm14L3ZteC5jICAgICAgICAgIHwgMSArDQo+
ID4gIGFyY2gveDg2L2t2bS94ODYuYyAgICAgICAgICAgICAgfCAzICsrKw0KPiA+ICBpbmNsdWRl
L3VhcGkvbGludXgva3ZtLmggICAgICAgIHwgMSArDQo+ID4gIDUgZmlsZXMgY2hhbmdlZCwgMTIg
aW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9rdm1faG9zdC5oDQo+ID4gYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+ID4g
aW5kZXggNmQwNmM3OTRkNzIwLi5iZTNmZjcxZTYyMjcgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94
ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPiA+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNt
L2t2bV9ob3N0LmgNCj4gPiBAQCAtMTEzMiw2ICsxMTMyLDcgQEAgc3RydWN0IGt2bV94ODZfb3Bz
IHsNCj4gPiAgCWJvb2wgKCp4c2F2ZXNfc3VwcG9ydGVkKSh2b2lkKTsNCj4gPiAgCWJvb2wgKCp1
bWlwX2VtdWxhdGVkKSh2b2lkKTsNCj4gPiAgCWJvb2wgKCpwdF9zdXBwb3J0ZWQpKHZvaWQpOw0K
PiA+ICsJYm9vbCAoKnRkcF94b19zdXBwb3J0ZWQpKHZvaWQpOw0KPiA+ICANCj4gPiAgCWludCAo
KmNoZWNrX25lc3RlZF9ldmVudHMpKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgYm9vbCBleHRlcm5h
bF9pbnRyKTsNCj4gPiAgCXZvaWQgKCpyZXF1ZXN0X2ltbWVkaWF0ZV9leGl0KShzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUpOw0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vc3ZtLmMgYi9hcmNo
L3g4Ni9rdm0vc3ZtLmMNCj4gPiBpbmRleCBlMDM2ODA3NmExZWYuLmY5ZjI1ZjMyZTk0NiAxMDA2
NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtLmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rdm0v
c3ZtLmMNCj4gPiBAQCAtNjAwNSw2ICs2MDA1LDExIEBAIHN0YXRpYyBib29sIHN2bV9wdF9zdXBw
b3J0ZWQodm9pZCkNCj4gPiAgCXJldHVybiBmYWxzZTsNCj4gPiAgfQ0KPiA+ICANCj4gPiArc3Rh
dGljIGJvb2wgc3ZtX3hvX3N1cHBvcnRlZCh2b2lkKQ0KPiA+ICt7DQo+ID4gKwlyZXR1cm4gZmFs
c2U7DQo+ID4gK30NCj4gPiArDQo+ID4gIHN0YXRpYyBib29sIHN2bV9oYXNfd2JpbnZkX2V4aXQo
dm9pZCkNCj4gPiAgew0KPiA+ICAJcmV0dXJuIHRydWU7DQo+ID4gQEAgLTcyOTMsNiArNzI5OCw3
IEBAIHN0YXRpYyBzdHJ1Y3Qga3ZtX3g4Nl9vcHMgc3ZtX3g4Nl9vcHMgX19yb19hZnRlcl9pbml0
DQo+ID4gPSB7DQo+ID4gIAkueHNhdmVzX3N1cHBvcnRlZCA9IHN2bV94c2F2ZXNfc3VwcG9ydGVk
LA0KPiA+ICAJLnVtaXBfZW11bGF0ZWQgPSBzdm1fdW1pcF9lbXVsYXRlZCwNCj4gPiAgCS5wdF9z
dXBwb3J0ZWQgPSBzdm1fcHRfc3VwcG9ydGVkLA0KPiA+ICsJLnRkcF94b19zdXBwb3J0ZWQgPSBz
dm1feG9fc3VwcG9ydGVkLA0KPiA+ICANCj4gPiAgCS5zZXRfc3VwcG9ydGVkX2NwdWlkID0gc3Zt
X3NldF9zdXBwb3J0ZWRfY3B1aWQsDQo+ID4gIA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9r
dm0vdm14L3ZteC5jIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiA+IGluZGV4IGEzMGRiYWI4
YTJkNC4uN2U3MjYwYzcxNWYyIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdm14
LmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+ID4gQEAgLTc3NjcsNiArNzc2
Nyw3IEBAIHN0YXRpYyBzdHJ1Y3Qga3ZtX3g4Nl9vcHMgdm14X3g4Nl9vcHMgX19yb19hZnRlcl9p
bml0DQo+ID4gPSB7DQo+ID4gIAkueHNhdmVzX3N1cHBvcnRlZCA9IHZteF94c2F2ZXNfc3VwcG9y
dGVkLA0KPiA+ICAJLnVtaXBfZW11bGF0ZWQgPSB2bXhfdW1pcF9lbXVsYXRlZCwNCj4gPiAgCS5w
dF9zdXBwb3J0ZWQgPSB2bXhfcHRfc3VwcG9ydGVkLA0KPiA+ICsJLnRkcF94b19zdXBwb3J0ZWQg
PSBjcHVfaGFzX3ZteF9lcHRfZXhlY3V0ZV9vbmx5LA0KPiA+ICANCj4gPiAgCS5yZXF1ZXN0X2lt
bWVkaWF0ZV9leGl0ID0gdm14X3JlcXVlc3RfaW1tZWRpYXRlX2V4aXQsDQo+ID4gIA0KPiA+IGRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiBp
bmRleCAyZTMyMWQ3ODg2NzIuLjgxMGNmZGIxYTMxNSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4
Ni9rdm0veDg2LmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiBAQCAtMzE4Myw2
ICszMTgzLDkgQEAgaW50IGt2bV92bV9pb2N0bF9jaGVja19leHRlbnNpb24oc3RydWN0IGt2bSAq
a3ZtLCBsb25nDQo+ID4gZXh0KQ0KPiA+ICAJCXIgPSBrdm1feDg2X29wcy0+Z2V0X25lc3RlZF9z
dGF0ZSA/DQo+ID4gIAkJCWt2bV94ODZfb3BzLT5nZXRfbmVzdGVkX3N0YXRlKE5VTEwsIE5VTEws
IDApIDogMDsNCj4gPiAgCQlicmVhazsNCj4gPiArCWNhc2UgS1ZNX0NBUF9FWEVDT05MWV9NRU06
DQo+ID4gKwkJciA9IGt2bV94ODZfb3BzLT50ZHBfeG9fc3VwcG9ydGVkKCk7DQo+ID4gKwkJYnJl
YWs7DQo+ID4gIAlkZWZhdWx0Og0KPiA+ICAJCWJyZWFrOw0KPiA+ICAJfQ0KPiA+IGRpZmYgLS1n
aXQgYS9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmggYi9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgN
Cj4gPiBpbmRleCBlZGU0ODdiN2IyMTYuLjc3NzhhMWYwM2I3OCAxMDA2NDQNCj4gPiAtLS0gYS9p
bmNsdWRlL3VhcGkvbGludXgva3ZtLmgNCj4gPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgva3Zt
LmgNCj4gPiBAQCAtOTk3LDYgKzk5Nyw3IEBAIHN0cnVjdCBrdm1fcHBjX3Jlc2l6ZV9ocHQgew0K
PiA+ICAjZGVmaW5lIEtWTV9DQVBfQVJNX1BUUkFVVEhfQUREUkVTUyAxNzENCj4gPiAgI2RlZmlu
ZSBLVk1fQ0FQX0FSTV9QVFJBVVRIX0dFTkVSSUMgMTcyDQo+ID4gICNkZWZpbmUgS1ZNX0NBUF9Q
TVVfRVZFTlRfRklMVEVSIDE3Mw0KPiA+ICsjZGVmaW5lIEtWTV9DQVBfRVhFQ09OTFlfTUVNIDE3
NA0KPiA+ICANCj4gPiAgI2lmZGVmIEtWTV9DQVBfSVJRX1JPVVRJTkcNCj4gPiAgDQo+ID4gDQo+
IA0KPiBUaGlzIGlzIG5vdCBuZWVkZWQsIGV4ZWN1dGlvbiBvbmx5IGNhbiBiZSBhIENQVUlEIGJp
dCBpbiB0aGUgaHlwZXJ2aXNvcg0KPiByYW5nZSAoc2VlIERvY3VtZW50YXRpb24vdmlydC9rdm0v
Y3B1aWQudHh0KS4gIFVzZXJzcGFjZSBjYW4gdXNlDQo+IEtWTV9HRVRfU1VQUE9SVEVEX0NQVUlE
IHRvIGNoZWNrIHdoZXRoZXIgdGhlIGhvc3Qgc3VwcG9ydHMgaXQuDQo+IA0KT2ggeWVhLiBJIGRp
ZG4ndCBzZWUgdGhpcy4gRGVmaW5pdGVseSBzZWVtcyBiZXR0ZXIuDQoNClRoYW5rcywNCg0KUmlj
aw0KDQo=
