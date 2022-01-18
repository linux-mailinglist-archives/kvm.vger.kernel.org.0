Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF274913E7
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 03:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244244AbiARCGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 21:06:50 -0500
Received: from mga12.intel.com ([192.55.52.136]:41374 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236398AbiARCGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 21:06:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642471609; x=1674007609;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zFcz4EfRaJOhLzNoPPPBevL3oQF4dq/cHCBOUYLDbQc=;
  b=I2DrJlczcQSBRSQElGdGTPDgL8JWuuB1F6eHwwAhOElP/rzoDuG8jAr8
   rjUWgftFPw5O5oo5Ua0tOuRdPPFwl5wqu3UTs3JY4+WuL7e4c1+6PGD35
   f+Wv4wkju/F8Cy1rk94lKqR+dC3xEEAajRRgttXETDcu/9B2nax3RdTKK
   d6p4ie7h69868gkX/N386+bbKQihd95nvlZyKWISf1TbqLbp9TaQFIxRC
   AFS+sYPVPBe3FWcDDhw1+H76yRDFKdseMR1A9A998PvccJGQr27NLUTx/
   vryRQyZE53Wh2EjRHuboaCL8RxLHa+l2ljZN3mD4E4ey7PpNlc16mzmow
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="224698633"
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="224698633"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 18:06:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="517590244"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga007.jf.intel.com with ESMTP; 17 Jan 2022 18:06:48 -0800
Received: from shsmsx606.ccr.corp.intel.com (10.109.6.216) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 17 Jan 2022 18:06:47 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX606.ccr.corp.intel.com (10.109.6.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 18 Jan 2022 10:06:45 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2308.020;
 Tue, 18 Jan 2022 10:06:45 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Zeng, Guang" <guang.zeng@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: RE: [PATCH v6 19/21] kvm: selftests: Add support for KVM_CAP_XSAVE2
Thread-Topic: [PATCH v6 19/21] kvm: selftests: Add support for KVM_CAP_XSAVE2
Thread-Index: AQHYA/gqrQY7KCvJokuAQBWZoUkTxKxm9tMAgAEgdoA=
Date:   Tue, 18 Jan 2022 02:06:45 +0000
Message-ID: <6607eb58f61b44a5a9403cf275be4265@intel.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
 <20220107185512.25321-20-pbonzini@redhat.com>
 <d47dc156-405f-77c5-787a-99073053a06b@linux.ibm.com>
In-Reply-To: <d47dc156-405f-77c5-787a-99073053a06b@linux.ibm.com>
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

T24gVHVlc2RheSwgSmFudWFyeSAxOCwgMjAyMiAxMjo1MSBBTSwgSmFuaXMgU2Nob2V0dGVybC1H
bGF1c2NoIHdyb3RlOg0KPiA+ICsJLyoNCj4gPiArCSAqIFBlcm1pc3Npb24gbmVlZHMgdG8gYmUg
cmVxdWVzdGVkIGJlZm9yZSBLVk1fU0VUX0NQVUlEMi4NCj4gPiArCSAqLw0KPiA+ICsJdm1feHNh
dmVfcmVxX3Blcm0oKTsNCj4gPiArDQo+IA0KPiBTaW5jZQ0KPiANCj4gNzllMDZjNGM0OTUwIChN
ZXJnZSB0YWcgJ2Zvci1saW51cycgb2YNCj4gZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS92
aXJ0L2t2bS9rdm0pDQo+IA0KPiBvbiBzMzkweCBJJ20gZ2V0dGluZzoNCj4gDQo+IC91c3IvYmlu
L2xkOiB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vbGlia3ZtLmEoa3ZtX3V0aWwubyk6IGlu
IGZ1bmN0aW9uDQo+IGB2bV9jcmVhdGVfd2l0aF92Y3B1cyc6DQo+IHRvb2xzL3Rlc3Rpbmcvc2Vs
ZnRlc3RzL2t2bS9saWIva3ZtX3V0aWwuYzozOTk6IHVuZGVmaW5lZCByZWZlcmVuY2UgdG8NCj4g
YHZtX3hzYXZlX3JlcV9wZXJtJw0KPiBjb2xsZWN0MjogZXJyb3I6IGxkIHJldHVybmVkIDEgZXhp
dCBzdGF0dXMNCj4gbWFrZTogKioqIFsuLi9saWIubWs6MTQ2OiB0b29scy90ZXN0aW5nL3NlbGZ0
ZXN0cy9rdm0vczM5MHgvbWVtb3BdIEVycm9yIDENCj4gDQo+IExvb2tzIGxpa2UgaXQgb25seSBl
eGlzdHMgZm9yIHg4Ni4NCj4gdjIgaGFkIGEgY29tbWVudCBhYm91dCB1bmNvbmRpdGlvbmFsIGVu
YWJsZW1lbnQ6DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS9lMjBmNTkwYi1iOWQ5LTIz
N2QtM2I5Yy03N2RkODJhMjRiNDBAcmVkaA0KPiBhdC5jb20vDQo+IA0KPiBUaGFua3MgZm9yIGhh
dmluZyBhIGxvb2suDQo+IA0KDQoNCk9LLCB3ZSBtYWRlIGl0IGNvbmRpdGlvbmFsbHkgZW5hYmxl
ZCBhdCBydW50aW1lLCBidXQgdGhpcyBvbmUgcmVxdWlyZXMgY29uZGl0aW9uYWxseSBjb21waWxl
ZC4gSSdsbCBnZXQgeW91IGEgcGF0Y2ggdG8gdGVzdCBzb29uLg0KDQpUaGFua3MsDQpXZWkNCg==
