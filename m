Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301F9293F4E
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 17:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408553AbgJTPJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 11:09:17 -0400
Received: from mga04.intel.com ([192.55.52.120]:2679 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408550AbgJTPJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 11:09:17 -0400
IronPort-SDR: WdghAlV4JWM6Xcf00eQNmLnvwYnHc7j7UENcuxPFU976UvZ7Exd2/pHgAH73ARLYOpDZsG5aUV
 C8yWJJCdCQSA==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="164613071"
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="164613071"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 08:05:55 -0700
IronPort-SDR: lIQs17F8ubsXHSc5SZSJSWmOrQyQZTCIm2WkaOOFPEBfrnjWB/gcyGdrZVBlipdktQGcFHWWvn
 IRMaKSNCqXDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="522406138"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga006.fm.intel.com with ESMTP; 20 Oct 2020 08:05:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Oct 2020 08:05:54 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Oct 2020 08:05:54 -0700
Received: from orsmsx611.amr.corp.intel.com ([10.22.229.24]) by
 ORSMSX611.amr.corp.intel.com ([10.22.229.24]) with mapi id 15.01.1713.004;
 Tue, 20 Oct 2020 08:05:54 -0700
From:   "Christopherson, Sean J" <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [kvm-unit-tests PATCHv2] unittests.cfg: Increase timeout for apic
 test
Thread-Topic: [kvm-unit-tests PATCHv2] unittests.cfg: Increase timeout for
 apic test
Thread-Index: AQHWoUFdByb/PYMQ3Eu+JgdRCcLx/amZS0UA//+UpoCABmnVAP//3/eQgAB5toCAAQrzAP//9AuQ
Date:   Tue, 20 Oct 2020 15:05:51 +0000
Message-ID: <686175c1a45d4b438c9585d835bdd0dc@intel.com>
References: <20201013091237.67132-1-po-hsu.lin@canonical.com>
 <87d01j5vk7.fsf@vitty.brq.redhat.com>
 <20201015163539.GA27813@linux.intel.com>
 <87o8ky4fkf.fsf@vitty.brq.redhat.com>
 <a6e33cd7d0084d6389a02786225db0e8@intel.com>
 <C67F3473-32FE-4099-BBB1-8BB31B1ED95D@gmail.com>
 <d1277875-6b7a-f7fe-8a58-78ba5ae0ba1d@redhat.com>
In-Reply-To: <d1277875-6b7a-f7fe-8a58-78ba5ae0ba1d@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCBPY3QgMjAsIDIwMjAgYXQgMTA6NDg6MjRBTSArMDIwMCwgUGFvbG8gQm9uemluaSB3
cm90ZToNCj4gT24gMTkvMTAvMjAgMTg6NTIsIE5hZGF2IEFtaXQgd3JvdGU6DQo+ID4gSUlSQywg
dGhpcyB0ZXN0IGZhaWxlZCBvbiBWTXdhcmUsIGFuZCBhY2NvcmRpbmcgdG8gb3VyIHByZXZpb3Vz
IGRpc2N1c3Npb25zLA0KPiA+IGRvZXMgbm90IGZvbGxvdyB0aGUgU0RNIGFzIE5NSXMgbWlnaHQg
YmUgY29sbGFwc2VkIFsxXS4NCj4gPg0KPiA+IFsxXSBodHRwczovL21hcmMuaW5mby8/bD1rdm0m
bT0xNDU4NzY5OTQwMzE1MDImdz0yDQo+DQo+IFNvIHNob3VsZCBLVk0gYmUgY2hhbmdlZCB0byBh
bHdheXMgY29sbGFwc2UgTk1JcywgbGlrZSB0aGlzPw0KDQpObywgTmFkYXYncyBmYWlsdXJlIGlz
IG5vdCBvbiBiYXJlIG1ldGFsLiAgVGhlIHRlc3QgcGFzc2VzIG9uIGJhcmUgbWV0YWwuDQoNClF1
b3RpbmcgbXlzZWxmOg0KDQogIEFyY2hpdGVjdHVyYWxseSBJIGRvbid0IHRoaW5rIHRoZXJlIGFy
ZSBhbnkgZ3VhcmFudGVlcyByZWdhcmRpbmcNCiAgc2ltdWx0YW5lb3VzIE5NSXMsIGJ1dCBwcmFj
dGljYWxseSBzcGVha2luZyB0aGUgcHJvYmFiaWxpdHkgb2YgTk1Jcw0KICBiZWluZyBjb2xsYXBz
ZWQgKG9uIGhhcmR3YXJlKSB3aGVuIE5NSXMgYXJlbid0IGJsb2NrZWQgaXMgbmlsLiAgU28gd2hp
bGUNCiAgaXQgbWF5IGJlIGFyY2hpdGVjdHVyYWxseSBsZWdhbCBmb3IgYSBWTU0gdG8gZHJvcCBh
biBOTUkgaW4gdGhpcyBjYXNlLA0KICBpdCdzIHJlYXNvbmFibGUgZm9yIHNvZnR3YXJlIHRvIGV4
cGVjdCB0d28gTk1JcyB0byBiZSByZWNlaXZlZC4NCg0KDQpbKl0gaHR0cHM6Ly9sa21sLmtlcm5l
bC5vcmcvci9BNzQ1MzgyOC1CRDhFLTQzRjgtQjE0MC02RDY2MDUzNUI3RjJAZ21haWwuY29tDQoN
Cj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94ODYuYw0K
PiBpbmRleCAxMDUyNjE0MDI5MjEuLjQwMzIzMzZlY2JhMyAxMDA2NDQNCj4gLS0tIGEvYXJjaC94
ODYva3ZtL3g4Ni5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS94ODYuYw0KPiBAQCAtNjY4LDcgKzY2
OCw3IEBAIEVYUE9SVF9TWU1CT0xfR1BMKGt2bV9pbmplY3RfZW11bGF0ZWRfcGFnZV9mYXVsdCk7
DQo+DQo+ICB2b2lkIGt2bV9pbmplY3Rfbm1pKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gIHsN
Cj4gLSAgICAgYXRvbWljX2luYygmdmNwdS0+YXJjaC5ubWlfcXVldWVkKTsNCj4gKyAgICAgYXRv
bWljX3NldCgmdmNwdS0+YXJjaC5ubWlfcXVldWVkLCAxKTsNCj4gICAgICAga3ZtX21ha2VfcmVx
dWVzdChLVk1fUkVRX05NSSwgdmNwdSk7DQo+ICB9DQo+ICBFWFBPUlRfU1lNQk9MX0dQTChrdm1f
aW5qZWN0X25taSk7DQo+IEBAIC04MzA0LDE4ICs4MzA0LDcgQEAgc3RhdGljIHZvaWQgaW5qZWN0
X3BlbmRpbmdfZXZlbnQoc3RydWN0IGt2bV92Y3B1DQo+ICp2Y3B1LCBib29sICpyZXFfaW1tZWRp
YXRlX2V4aXQNCj4NCj4gIHN0YXRpYyB2b2lkIHByb2Nlc3Nfbm1pKHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSkNCj4gIHsNCj4gLSAgICAgdW5zaWduZWQgbGltaXQgPSAyOw0KPiAtDQo+IC0gICAgIC8q
DQo+IC0gICAgICAqIHg4NiBpcyBsaW1pdGVkIHRvIG9uZSBOTUkgcnVubmluZywgYW5kIG9uZSBO
TUkgcGVuZGluZyBhZnRlciBpdC4NCj4gLSAgICAgICogSWYgYW4gTk1JIGlzIGFscmVhZHkgaW4g
cHJvZ3Jlc3MsIGxpbWl0IGZ1cnRoZXIgTk1JcyB0byBqdXN0IG9uZS4NCj4gLSAgICAgICogT3Ro
ZXJ3aXNlLCBhbGxvdyB0d28gKGFuZCB3ZSdsbCBpbmplY3QgdGhlIGZpcnN0IG9uZSBpbW1lZGlh
dGVseSkuDQo+IC0gICAgICAqLw0KPiAtICAgICBpZiAoa3ZtX3g4Nl9vcHMuZ2V0X25taV9tYXNr
KHZjcHUpIHx8IHZjcHUtPmFyY2gubm1pX2luamVjdGVkKQ0KPiAtICAgICAgICAgICAgIGxpbWl0
ID0gMTsNCj4gLQ0KPiAtICAgICB2Y3B1LT5hcmNoLm5taV9wZW5kaW5nICs9IGF0b21pY194Y2hn
KCZ2Y3B1LT5hcmNoLm5taV9xdWV1ZWQsIDApOw0KPiAtICAgICB2Y3B1LT5hcmNoLm5taV9wZW5k
aW5nID0gbWluKHZjcHUtPmFyY2gubm1pX3BlbmRpbmcsIGxpbWl0KTsNCj4gKyAgICAgdmNwdS0+
YXJjaC5ubWlfcGVuZGluZyB8PSBhdG9taWNfeGNoZygmdmNwdS0+YXJjaC5ubWlfcXVldWVkLCAw
KTsNCj4gICAgICAga3ZtX21ha2VfcmVxdWVzdChLVk1fUkVRX0VWRU5ULCB2Y3B1KTsNCj4gIH0N
Cg==
