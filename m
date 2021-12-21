Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0AA247B872
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 03:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbhLUCpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 21:45:51 -0500
Received: from mga14.intel.com ([192.55.52.115]:8199 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231833AbhLUCpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 21:45:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640054750; x=1671590750;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a9EAtYjMjgBhRqx9t80MptniHLo76DppyNXKRomGOUk=;
  b=N4SUr9lUbRHoz9nt7J9U4T+LKGlh46oiD+41YBJZrAbatdmDpWgOk8co
   G1k1O0Vy+31HbI6FjALZxpPGzbSGt+PGE9J1rcot6us+0Smjh2O7JNRhT
   Ia5MIA0N/qc/87WUtidpqSzfharSNjSOLCZUX97dcvve6TOe0TQq6tFN5
   oyq8pOLWShW7sirGdh6NXOVK+cdao6s742piLogKcJOJ7/9QKf6VpsuOe
   cYRvU/tNyUKSH0nGnXbX4w8g3WVoUvddwC4ds32gHz4IanbxCHNklAPS4
   BD5rd8I8D0lkpXNtb0vHVi3YTsvn6cAzf9qZN7gX++vfgfYYj5tbjzU64
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="240533482"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="240533482"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 18:45:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="616620471"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga004.jf.intel.com with ESMTP; 20 Dec 2021 18:45:48 -0800
Received: from shsmsx606.ccr.corp.intel.com (10.109.6.216) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 18:45:47 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX606.ccr.corp.intel.com (10.109.6.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 10:45:45 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2308.020;
 Tue, 21 Dec 2021 10:45:45 +0800
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
Thread-Index: AQHX81r8L73y8adYV0a4DFLIQjWYRqw6lEwAgAGYYhA=
Date:   Tue, 21 Dec 2021 02:45:45 +0000
Message-ID: <e0fd378de64f44fd8becfe67b02cb635@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
 <20211217153003.1719189-19-jing2.liu@intel.com>
 <3ffa47eb-3555-5925-1c55-f89a07ceb4bc@redhat.com>
In-Reply-To: <3ffa47eb-3555-5925-1c55-f89a07ceb4bc@redhat.com>
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

T24gTW9uZGF5LCBEZWNlbWJlciAyMCwgMjAyMSA1OjA0IFBNLCBQYW9sbyBCb256aW5pIHdyb3Rl
Og0KPiBPbiAxMi8xNy8yMSAxNjoyOSwgSmluZyBMaXUgd3JvdGU6DQo+ID4gKy8qIGZvciBLVk1f
Q0FQX1hTQVZFIGFuZCBLVk1fQ0FQX1hTQVZFMiAqLw0KPiA+ICAgc3RydWN0IGt2bV94c2F2ZSB7
DQo+ID4gKwkvKg0KPiA+ICsJICogS1ZNX0dFVF9YU0FWRSBvbmx5IHVzZXMgdGhlIGZpcnN0IDQw
OTYgYnl0ZXMuDQo+ID4gKwkgKg0KPiA+ICsJICogS1ZNX0dFVF9YU0FWRTIgbXVzdCBoYXZlIHRo
ZSBzaXplIG1hdGNoIHdoYXQgaXMgcmV0dXJuZWQgYnkNCj4gPiArCSAqIEtWTV9DSEVDS19FWFRF
TlNJT04oS1ZNX0NBUF9YU0FWRTIpLg0KPiA+ICsJICoNCj4gPiArCSAqIEtWTV9TRVRfWFNBVkUg
dXNlcyB0aGUgZXh0cmEgZmllbGQgaWYgZ3Vlc3RfZnB1OjpmcHN0YXRlOjpzaXplDQo+ID4gKwkg
KiBleGNlZWRzIDQwOTYgYnl0ZXMuDQo+IA0KPiBLVk1fR0VUX1hTQVZFMiBhbmQgS1ZNX1NFVF9Y
U0FWRSByZXNwZWN0aXZlbHkgd3JpdGUgYW5kIHJlYWQgYXMgbWFueQ0KPiBieXRlcyBhcyBhcmUg
cmV0dXJuZWQgYnkgS1ZNX0NIRUNLX0VYVEVOU0lPTihLVk1fQ0FQX1hTQVZFMiksIHdoZW4NCj4g
aW52b2tlZCBvbiB0aGUgdm0gZmlsZSBkZXNjcmlwdG9yLiAgQ3VycmVudGx5LA0KPiBLVk1fQ0hF
Q0tfRVhURU5TSU9OKEtWTV9DQVBfWFNBVkUyKSB3aWxsIG9ubHkgcmV0dXJuIGEgdmFsdWUgdGhh
dCBpcw0KPiBncmVhdGVyIHRoYW4gNDA5NiBieXRlcyBpZiBhbnkgZHluYW1pYyBmZWF0dXJlcyBo
YXZlIGJlZW4gZW5hYmxlZCB3aXRoDQo+IGBgYXJjaF9wcmN0bCgpYGA7IHRoaXMgaG93ZXZlciBt
YXkgY2hhbmdlIGluIHRoZSBmdXR1cmUuDQoNCldvdWxkIHRoaXMgbWFrZSBwZW9wbGUgdGhpbmsg
dGhhdCBLVk1fQ0hFQ0tfRVhURU5TSU9OKEtWTV9DQVBfWFNBVkUyKSBkb2VzbuKAmXQNCnJldHVy
biB0aGUgdmFsdWUgKGkuZS4gcmV0dXJuIDApIGlmIGl0IGlzIHNtYWxsZXIgdGhhbiA0MDk2Pw0K
KGkuZS4gS1ZNX0dFVF9YU0FWRTIgZG9lc24ndCB3b3JrIHdpdGggc2l6ZSA8IDQwOTYsIHdoaWNo
IGlzbuKAmXQgdHJ1ZSkNCg0KSSBwbGFuIHRvIGp1c3QgcmV3b3JkIGEgYml0Og0KQ3VycmVudGx5
LCBLVk1fQ0hFQ0tfRVhURU5TSU9OKEtWTV9DQVBfWFNBVkUyKSB3aWxsIG9ubHkgcmV0dXJuIGEg
c2l6ZSB2YWx1ZSwNCmFuZCB0aGUgdmFsdWUgaXMgZ3JlYXRlciB0aGFuIDQwOTYgYnl0ZXMgaWYg
YW55IGR5bmFtaWMgZmVhdHVyZXMgaGF2ZSBiZWVuIGVuYWJsZWQgd2l0aA0KYGBhcmNoX3ByY3Rs
KClgYC4gTW9yZSB0eXBlcyBvZiB2YWx1ZXMgY291bGQgYmUgcmV0dXJuZWQgaW4gdGhlIGZ1dHVy
ZS4NCg0KVGhhbmtzLA0KV2VpDQo=
