Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193982ADD75
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 18:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgKJRwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 12:52:24 -0500
Received: from mga18.intel.com ([134.134.136.126]:21871 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgKJRwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 12:52:24 -0500
IronPort-SDR: Ue/eQdbIQ1NRXveYB7x4UaVxuqYNttcYFDzg318M1inBEbhghDNih39nY4/m3S8LvIkhy8uh3H
 mIx0BUQE/h6w==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="157799415"
X-IronPort-AV: E=Sophos;i="5.77,467,1596524400"; 
   d="scan'208";a="157799415"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 09:52:22 -0800
IronPort-SDR: xFIOCZZ+2axjJrpSFTctqBevBqyiPseguxlJZxQjN0koA3l8GGBNa9HF8YE+S6Mb9d2p6cSsVX
 jZsdWJC05JNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="338794703"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 10 Nov 2020 09:52:22 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 10 Nov 2020 09:52:21 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 10 Nov 2020 09:52:21 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.1713.004;
 Tue, 10 Nov 2020 09:52:21 -0800
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>
CC:     Jim Mattson <jmattson@google.com>, Qian Cai <cai@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>, x86 <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] x86/mce: Check for hypervisor before enabling additional
 error logging
Thread-Topic: [PATCH] x86/mce: Check for hypervisor before enabling additional
 error logging
Thread-Index: AQHWtu9pPtQfzpT7PkewPkEgjyUfiqnBbpaAgAAmzICAABJQgIAADGEAgABWhICAAAUdgP//lScA
Date:   Tue, 10 Nov 2020 17:52:21 +0000
Message-ID: <cacd1cd272e94213a0c82c9871086cf5@intel.com>
References: <160431588828.397.16468104725047768957.tip-bot2@tip-bot2>
 <3f863634cd75824907e8ccf8164548c2ef036f20.camel@redhat.com>
 <bfc274fc27724ea39ecac1e7ac834ed8@intel.com>
 <CALMp9eTFaiYkTnVe8xKzg40E4nZ3rAOii0O06bTy0+oLNjyKhA@mail.gmail.com>
 <a22b5468e1c94906b72c4d8bc83c0f64@intel.com>
 <20201109232402.GA25492@agluck-desk2.amr.corp.intel.com>
 <20201110063151.GB7290@nazgul.tnic>
 <094c2395-b1b3-d908-657c-9bd4144e40ac@redhat.com>
 <20201110095615.GB9450@nazgul.tnic>
 <b8de7f7b-7aa1-d98b-74be-62d7c055542b@redhat.com>
 <20201110155013.GE9857@nazgul.tnic>
 <1b587b45-a5a8-2147-ae53-06d1b284ea11@redhat.com>
In-Reply-To: <1b587b45-a5a8-2147-ae53-06d1b284ea11@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SSBzdGlsbCB0aGluayB0aGVyZSBpcyBhIHJlYXNvbmFibGUgY2FzZSB0byBjbGFpbSB0aGF0IHRo
aXMgdXNhZ2UgaXMgcmlnaHQgdG8gY2hlY2sNCndoZXRoZXIgaXQgaXMgcnVubmluZyBhcyBhIGd1
ZXN0Lg0KDQpMb29rIGF0IHdoYXQgaXQgaXMgdHJ5aW5nIHRvIGRvIC4uLiBjaGFuZ2UgdGhlIGJl
aGF2aW9yIG9mIHRoZSBwbGF0Zm9ybSB3LnIudC4gbG9nZ2luZw0Kb2YgbWVtb3J5IGVycm9ycy4g
IEhvdyBkb2VzIHRoYXQgbWFrZSBhbnkgc2Vuc2UgZm9yIGEgZ3Vlc3QgLi4uIHRoYXQgZG9lc24n
dCBldmVuDQprbm93IHdoYXQgbWVtb3J5IGlzIHByZXNlbnQgb24gdGhlIHBsYXRmb3JtLiBPciBo
YXZlIGd1YXJhbnRlZXMgdGhhdCB3aGF0IGl0IHNlZXMNCmFzIG1lbW9yeSBhZGRyZXNzIDB4MTIz
NDU2NzggbWFwcyB0byB0aGUgc2FtZSBzZXQgb2YgY2VsbHMgaW4gYSBEUkFNIGZyb20gb25lDQpz
ZWNvbmQgdG8gdGhlIG5leHQ/DQoNCi1Ub255DQo=
