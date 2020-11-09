Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD9F2AC8F1
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730571AbgKIW5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:57:42 -0500
Received: from mga05.intel.com ([192.55.52.43]:8918 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729247AbgKIW5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:57:37 -0500
IronPort-SDR: h2ELOHooYsYfyihalgoncIL16c9ZQQfE09sFw5Ni8BIIK1yhLfRIZn+f7C7uMYOuhxaFHCxu99
 GrMhM+LYczFA==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="254591931"
X-IronPort-AV: E=Sophos;i="5.77,464,1596524400"; 
   d="scan'208";a="254591931"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 14:57:36 -0800
IronPort-SDR: VqKSGBCFWX0LguVXoPh7MdLfU9redKRdqt2OyM6aoeCXjafD/HR2GMHCaXaAwEwslszZohU5xt
 L+Dcc9Tv/FAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,464,1596524400"; 
   d="scan'208";a="398447206"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga001.jf.intel.com with ESMTP; 09 Nov 2020 14:57:36 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Nov 2020 14:57:36 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Nov 2020 14:57:35 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.1713.004;
 Mon, 9 Nov 2020 14:57:35 -0800
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Jim Mattson <jmattson@google.com>
CC:     Qian Cai <cai@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>, Boris Petkov <bp@alien8.de>,
        "Borislav Petkov" <bp@suse.de>, x86 <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [tip: ras/core] x86/mce: Enable additional error logging on
 certain Intel CPUs
Thread-Topic: [tip: ras/core] x86/mce: Enable additional error logging on
 certain Intel CPUs
Thread-Index: AQHWsQncdZGZz6bl20aw0A24zT9Gy6nA6f4A//98jeCAAI8FgP//fTQA
Date:   Mon, 9 Nov 2020 22:57:35 +0000
Message-ID: <a22b5468e1c94906b72c4d8bc83c0f64@intel.com>
References: <20201030190807.GA13884@agluck-desk2.amr.corp.intel.com>
 <160431588828.397.16468104725047768957.tip-bot2@tip-bot2>
 <3f863634cd75824907e8ccf8164548c2ef036f20.camel@redhat.com>
 <bfc274fc27724ea39ecac1e7ac834ed8@intel.com>
 <CALMp9eTFaiYkTnVe8xKzg40E4nZ3rAOii0O06bTy0+oLNjyKhA@mail.gmail.com>
In-Reply-To: <CALMp9eTFaiYkTnVe8xKzg40E4nZ3rAOii0O06bTy0+oLNjyKhA@mail.gmail.com>
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

PiBJIHRob3VnaHQgTGludXggaGFkIGxvbmcgYWdvIGdvbmUgdGhlIHJvdXRlIG9mIHR1cm5pbmcg
cmRtc3Ivd3Jtc3INCj4gaW50byByZG1zcl9zYWZlL3dybXNyX3NhZmUsIHNvIHRoYXQgdGhlIGd1
ZXN0IHdvdWxkIGlnbm9yZSB0aGUgI0dQcyBvbg0KPiB3cml0ZXMgYW5kIHJldHVybiB6ZXJvIHRv
IHRoZSBjYWxsZXIgZm9yICNHUHMgb24gcmVhZHMuDQoNCkxpbnV4IGp1c3Qgc3dpdGNoZWQgdGhh
dCBhcm91bmQgZm9yIHRoZSBtYWNoaW5lIGNoZWNrIGJhbmtzIC4uLiBpZiB0aGV5ICNHUA0KZmF1
bHQsIHRoZW4gc29tZXRoaW5nIGlzIHNlcmlvdXNseSB3cm9uZy4NCg0KTWF5YmUgdGhhdCBpc24n
dCBhIGdlbmVyYWwgY2hhbmdlIG9mIGRpcmVjdGlvbiB0aG91Z2guIFBlcmhhcHMgSQ0Kc2hvdWxk
IGVpdGhlciB1c2UgcmRtc3JsX3NhZmUoKSBpbiB0aGlzIGNvZGUuIE9yIChiZXR0ZXI/KSBhZGQN
Cg0KCWlmIChib290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfSFlQRVJWSVNPUikpDQoJCXJldHVybjsN
Cg0KdG8gdGhlIHN0YXJ0IG9mIGludGVsX2ltY19pbml0KCkuDQoNCi1Ub255DQo=
