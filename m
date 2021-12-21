Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B8447BC77
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 10:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhLUJGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 04:06:30 -0500
Received: from mga18.intel.com ([134.134.136.126]:59830 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234454AbhLUJG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 04:06:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640077589; x=1671613589;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c8yHioLgX+giyIh16+OiSjIl4N67UmUFHNBIbnU3k6k=;
  b=jGq/LFSAlSit5gvb3Tvgi9iT6lYqN8yuMxKBufUsG6kdIS7/0OhJiit9
   Tm6xQO+Ghs25rLMFf/7cKn3JgkRUkenbjycUwPBjyrjwBQJeoS6anXH2P
   /FQMQfqXQrgUTt8RVx22a/yggo7XV2QOusiWGB+rxsi4XVH8dIUlwmORl
   sVyZueMoJJEys843XkC3SS0RhzDJekzQ6IgZggyrA/Y+ZcB696bpiFq0q
   ug6sAt9p1nHGqiqmCtynXYPz4oD6hN6WuuPLB3fb7UeaOoTLiiTw3JFGQ
   ZlMeSYcqPb++Ni7iDpILcqbtnga5O2zJCAwcespRZTzrgtF3e2IWNNrrj
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="227208769"
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="227208769"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 01:06:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="684598517"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 21 Dec 2021 01:06:29 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 01:06:28 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX601.ccr.corp.intel.com (10.109.6.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 17:06:26 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2308.020;
 Tue, 21 Dec 2021 17:06:26 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "seanjc@google.com" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: RE: [PATCH v2 18/23] kvm: x86: Get/set expanded xstate buffer
Thread-Topic: [PATCH v2 18/23] kvm: x86: Get/set expanded xstate buffer
Thread-Index: AQHX81r8L73y8adYV0a4DFLIQjWYRqw6lEwAgAGYYhD///SwAIAAiGog
Date:   Tue, 21 Dec 2021 09:06:26 +0000
Message-ID: <c06fdc4f3b4d4346ae80801a6c3a6ff2@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
 <20211217153003.1719189-19-jing2.liu@intel.com>
 <3ffa47eb-3555-5925-1c55-f89a07ceb4bc@redhat.com>
 <e0fd378de64f44fd8becfe67b02cb635@intel.com>
 <219a751e-ac2d-9ce1-9db7-7d5b1edd6bdd@redhat.com>
In-Reply-To: <219a751e-ac2d-9ce1-9db7-7d5b1edd6bdd@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlc2RheSwgRGVjZW1iZXIgMjEsIDIwMjEgNDo0NSBQTSwgUGFvbG8gQm9uemluaSB3cm90
ZToNCj4gT24gMTIvMjEvMjEgMDM6NDUsIFdhbmcsIFdlaSBXIHdyb3RlOg0KPiA+PiBLVk1fR0VU
X1hTQVZFMiBhbmQgS1ZNX1NFVF9YU0FWRSByZXNwZWN0aXZlbHkgd3JpdGUgYW5kIHJlYWQgYXMN
Cj4gbWFueQ0KPiA+PiBieXRlcyBhcyBhcmUgcmV0dXJuZWQgYnkgS1ZNX0NIRUNLX0VYVEVOU0lP
TihLVk1fQ0FQX1hTQVZFMiksDQo+IHdoZW4NCj4gPj4gaW52b2tlZCBvbiB0aGUgdm0gZmlsZSBk
ZXNjcmlwdG9yLiAgQ3VycmVudGx5LA0KPiA+PiBLVk1fQ0hFQ0tfRVhURU5TSU9OKEtWTV9DQVBf
WFNBVkUyKSB3aWxsIG9ubHkgcmV0dXJuIGEgdmFsdWUgdGhhdCBpcw0KPiA+PiBncmVhdGVyIHRo
YW4gNDA5NiBieXRlcyBpZiBhbnkgZHluYW1pYyBmZWF0dXJlcyBoYXZlIGJlZW4gZW5hYmxlZA0K
PiA+PiB3aXRoIGBgYXJjaF9wcmN0bCgpYGA7IHRoaXMgaG93ZXZlciBtYXkgY2hhbmdlIGluIHRo
ZSBmdXR1cmUuDQo+ID4gV291bGQgdGhpcyBtYWtlIHBlb3BsZSB0aGluayB0aGF0DQo+IEtWTV9D
SEVDS19FWFRFTlNJT04oS1ZNX0NBUF9YU0FWRTIpDQo+ID4gZG9lc27igJl0IHJldHVybiB0aGUg
dmFsdWUgKGkuZS4gcmV0dXJuIDApIGlmIGl0IGlzIHNtYWxsZXIgdGhhbiA0MDk2Pw0KPiA+IChp
LmUuIEtWTV9HRVRfWFNBVkUyIGRvZXNuJ3Qgd29yayB3aXRoIHNpemUgPCA0MDk2LCB3aGljaCBp
c27igJl0IHRydWUpDQo+ID4NCj4gPiBJIHBsYW4gdG8ganVzdCByZXdvcmQgYSBiaXQ6DQo+ID4g
Q3VycmVudGx5LCBLVk1fQ0hFQ0tfRVhURU5TSU9OKEtWTV9DQVBfWFNBVkUyKSB3aWxsIG9ubHkg
cmV0dXJuIGENCj4gc2l6ZQ0KPiA+IHZhbHVlLCBhbmQgdGhlIHZhbHVlIGlzIGdyZWF0ZXIgdGhh
biA0MDk2IGJ5dGVzIGlmIGFueSBkeW5hbWljDQo+ID4gZmVhdHVyZXMgaGF2ZSBiZWVuIGVuYWJs
ZWQgd2l0aCBgYGFyY2hfcHJjdGwoKWBgLiBNb3JlIHR5cGVzIG9mIHZhbHVlcyBjb3VsZA0KPiBi
ZSByZXR1cm5lZCBpbiB0aGUgZnV0dXJlLg0KPiANCj4gTmV4dCByZWZpbmVtZW50Og0KPiANCj4g
VGhlIHNpemUgdmFsdWUgcmV0dXJuZWQgYnkgS1ZNX0NIRUNLX0VYVEVOU0lPTihLVk1fQ0FQX1hT
QVZFMikgd2lsbA0KPiBhbHdheXMgYmUgYXQgbGVhc3QgNDA5Ni4gIEN1cnJlbnRseSwgaXQgaXMg
b25seSBncmVhdGVyIHRoYW4gNDA5NiBpZiBhIGR5bmFtaWMNCj4gZmVhdHVyZSBoYXMgYmVlbiBl
bmFibGVkIHdpdGggYGBhcmNoX3ByY3RsKClgYCwgYnV0IHRoaXMgbWF5IGNoYW5nZSBpbiB0aGUN
Cj4gZnV0dXJlLg0KDQo+IChJJ20gbm90IHN1cmUgaWYgdGhlIGZpcnN0IHNlbnRlbmNlIGlzIHRy
dWUgaW4gdGhlIGNvZGUsIGJ1dCBpZiBub3QgaXQgaXMgYSBidWcgdGhhdA0KPiBoYXMgdG8gYmUg
Zml4ZWQgOikpLg0KDQpGb3IgdGhlIGltcGxlbWVudGF0aW9uLCBLVk1fQ0hFQ0tfRVhURU5TSU9O
KEtWTV9DQVBfWFNBVkUyKSBhbHdheXMgcmV0dXJuIGt2bS0+dmNwdXNbMF0tPmFyY2guZ3Vlc3Rf
ZnB1LnVhYmlfc2l6ZS4NCkRvIHlvdSB3YW50IHRvIGNoYW5nZSBpdCB0byBiZWxvdz8NCg0KSWYg
KGt2bS0+dmNwdXNbMF0tPmFyY2guZ3Vlc3RfZnB1LnVhYmlfc2l6ZSA8IDQwOTYpDQoJcmV0dXJu
IDA7DQplbHNlDQoJcmV0dXJuIGt2bS0+dmNwdXNbMF0tPmFyY2guZ3Vlc3RfZnB1LnVhYmlfc2l6
ZTsNCg0KSWYgdGhlIHNpemUgaXMgbGVzcyB0aGFuIDQwOTYgKGUuZy4gbm8gZHluYW1pYyB4ZmVh
dHVyZXMgZW5hYmxlZCksDQp1c2Vyc3BhY2Ugc2hvdWxkIHVzZSB0aGUgb2xkIEtWTV9HRVRfWFNB
VkUgKGluc3RlYWQgb2YgS1ZNX0dFVF9YU0FWRTIpPw0KKEtWTV9HRVRfWFNBVkUyIHN1cHBvcnRz
IHRvIHdvcmsgd2l0aCBzaXplIGxlc3MgdGhhbiA0MDk2LCBzbyBJIHRoaW5rIHRoaXMgaXNuJ3Qg
bmVjZXNzYXJ5KQ0KDQpUaGFua3MsDQpXZWkNCg==
