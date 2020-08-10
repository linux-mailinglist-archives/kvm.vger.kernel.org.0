Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAFF2413FE
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 01:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgHJX7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 19:59:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:39826 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726733AbgHJX7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 19:59:41 -0400
IronPort-SDR: XHjkaWJ5V3ozachA1cc+Mk8+eeOghNMqetBNLqC0n2y1kCs1Itynyw9MOIIMX9Q3HHx8SqNd4b
 i7lpkLI+MrRg==
X-IronPort-AV: E=McAfee;i="6000,8403,9709"; a="171681869"
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="171681869"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 16:59:40 -0700
IronPort-SDR: j6qfilfWKcMBSz80saShPthqaHk5ZMBZ6pwgI/ybMrOKKjdSlpauJUy0Z923kJeokIazBr/r3e
 +iKzJaR+ptpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="277422117"
Received: from fmsmsx603-2.cps.intel.com (HELO fmsmsx603.amr.corp.intel.com) ([10.18.84.213])
  by fmsmga008.fm.intel.com with ESMTP; 10 Aug 2020 16:59:40 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 10 Aug 2020 16:59:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 10 Aug 2020 16:59:37 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.1713.004;
 Mon, 10 Aug 2020 16:59:37 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     "Zhang, Cathy" <cathy.zhang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Park, Kyung Min" <kyung.min.park@intel.com>,
        "ricardo.neri-calderon@linux.intel.com" 
        <ricardo.neri-calderon@linux.intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v3 2/2] x86/kvm: Expose new features for supported cpuid
Thread-Topic: [PATCH v3 2/2] x86/kvm: Expose new features for supported cpuid
Thread-Index: AQHWbiIk6jsMa0EDDEqEYS82MIz4b6kwehaAgAIBE4D//4uGAA==
Date:   Mon, 10 Aug 2020 23:59:37 +0000
Message-ID: <e92df7bb267c478f8dfa28a31fc59d95@intel.com>
References: <1596959242-2372-1-git-send-email-cathy.zhang@intel.com>
 <1596959242-2372-3-git-send-email-cathy.zhang@intel.com>
 <d7e9fb9a-e392-73b1-5fc8-3876cb30665c@redhat.com>
 <27965021-2ec7-aa30-5526-5a6b293b2066@intel.com>
In-Reply-To: <27965021-2ec7-aa30-5526-5a6b293b2066@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBBcyB5b3Ugc3VnZ2VzdCwgSSB3aWxsIHNwbGl0IHRoZSBrdm0gcGF0Y2ggaW50byB0d28gcGFy
dHMsIFNFUklBTElaRSBhbmQgDQo+IFRTWExEVFJLLCBhbmQgdGhpcyBzZXJpZXMgd2lsbCBpbmNs
dWRlIHRocmVlIHBhdGNoZXMgdGhlbiwgMiBrdm0gcGF0Y2hlcyANCj4gYW5kIDEga2VybmVsIHBh
dGNoLiBTRVJJQUxJWkUgY291bGQgZ2V0IG1lcmdlZCBpbnRvIDUuOSwgYnV0IFRTWExEVFJLIA0K
PiBzaG91bGQgd2FpdCBmb3IgdGhlIG5leHQgcmVsZWFzZS4gSSBqdXN0IHdhbnQgdG8gZG91Ymxl
IGNvbmZpcm0gd2l0aCANCj4geW91LCBwbGVhc2UgaGVscCBjb3JyZWN0IG1lIGlmIEknbSB3cm9u
Zy4NCg0KUGFvbG8gaXMgc2F5aW5nIHRoYXQgaGUgaGFzIGFwcGxpZWQgdGhlIFNFUklBTElaRSBw
YXJ0IHRvIGhpcyBLVk0gdHJlZS4NCg0KaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL3Zp
cnQva3ZtL2t2bS5naXQvY29tbWl0Lz9oPXF1ZXVlJmlkPTQzYmQ5ZWY0MmIzYjg2MmM5N2YxZjRl
ODZiZjNhY2U4OTBiZWY5MjQNCg0KTmV4dCBzdGVwIGZvciB5b3UgaXMgYSB0d28gcGFydCBzZXJp
ZXMuDQoNClBhcnQgMTogQWRkIFRTWExEVFJLIHRvIGNwdWZlYXR1cmVzLmgNClBhcnQgMjogQWRk
IFRTWExEVFJLIHRvIGFyY2gveDg2L2t2bS9jcHVpZC5jIChvbiB0b3Agb2YgdGhlIHZlcnNpb24g
dGhhdCBQYW9sbyBjb21taXR0ZWQgd2l0aCBTRVJJQUxJWkUpDQoNClBhb2xvOiBUaGUgNS45IG1l
cmdlIHdpbmRvdyBpcyBzdGlsbCBvcGVuIHRoaXMgd2Vlay4gV2lsbCB5b3Ugc2VuZCB0aGUgS1ZN
IHNlcmlhbGl6ZSBwYXRjaCB0byBMaW51cw0KYmVmb3JlIHRoaXMgbWVyZ2Ugd2luZG93IGNsb3Nl
cz8gIE9yIGRvIHlvdSBoYXZlIGl0IHF1ZXVlZCBmb3IgdjUuMTA/DQoNCi1Ub255DQo=
