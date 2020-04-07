Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AB71A0DBB
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 14:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbgDGMe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 08:34:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:49662 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728630AbgDGMe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 08:34:27 -0400
IronPort-SDR: 329U2Rbvx3P+rIUl/u04CmtCLOElzB8h+pXjbYkgbCt2iAWG9iRI9JA2Ez3wRTqi1P7cmg5q/y
 vxW1QmZQZzIw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2020 05:34:26 -0700
IronPort-SDR: vVqO4j3FlpZLEXphyoEzhbPXs8/aB4TZ+r0bbz3+CYuPmUA/BJowPj2PYim4HCeeSNEwv0isoM
 IUsMTtmXDWKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,354,1580803200"; 
   d="scan'208";a="424733196"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga005.jf.intel.com with ESMTP; 07 Apr 2020 05:34:26 -0700
Received: from fmsmsx113.amr.corp.intel.com (10.18.116.7) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Apr 2020 05:34:26 -0700
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 FMSMSX113.amr.corp.intel.com (10.18.116.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Apr 2020 05:34:25 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.22]) with mapi id 14.03.0439.000;
 Tue, 7 Apr 2020 20:34:22 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     "Liang, Kan" <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "alexander.shishkin@linux.intel.com" 
        <alexander.shishkin@linux.intel.com>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "pawan.kumar.gupta@linux.intel.com" 
        <pawan.kumar.gupta@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "like.xu@linux.intel.com" <like.xu@linux.intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>
Subject: RE: [PATCH v1 01/11] perf/x86/core: Support KVM to assign a
 dedicated counter for guest PEBS
Thread-Topic: [PATCH v1 01/11] perf/x86/core: Support KVM to assign a
 dedicated counter for guest PEBS
Thread-Index: AQHV8tS2uZDJ2Dgk6EqR/a2HW+9LbKg7EWeAgAAN1ICABGlOgIAANIUAgAAfgACAAEmBgIAaXLeAgBNIJvA=
Date:   Tue, 7 Apr 2020 12:34:22 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E1738B3097@SHSMSX104.ccr.corp.intel.com>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
 <1583431025-19802-2-git-send-email-luwei.kang@intel.com>
 <20200306135317.GD12561@hirez.programming.kicks-ass.net>
 <b72cb68e-1a0a-eeff-21b4-ce412e939cfd@linux.intel.com>
 <20200309100443.GG12561@hirez.programming.kicks-ass.net>
 <97ce1ba4-d75a-8db2-ea2f-7d334942b4e6@linux.intel.com>
 <20200309150526.GI12561@hirez.programming.kicks-ass.net>
 <45a1a575-9363-f778-b5f5-bcdf28d3e34b@linux.intel.com>
 <e4a97965-5e57-56c5-1610-b84cf349e466@linux.intel.com>
In-Reply-To: <e4a97965-5e57-56c5-1610-b84cf349e466@linux.intel.com>
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

PiA+IE9uIDMvOS8yMDIwIDExOjA1IEFNLCBQZXRlciBaaWpsc3RyYSB3cm90ZToNCj4gPj4+IElu
IHRoZSBuZXcgcHJvcG9zYWwsIEtWTSB1c2VyIGlzIHRyZWF0ZWQgdGhlIHNhbWUgYXMgb3RoZXIg
aG9zdA0KPiA+Pj4gZXZlbnRzIHdpdGggZXZlbnQgY29uc3RyYWludC4gVGhlIHNjaGVkdWxlciBp
cyBmcmVlIHRvIGNob29zZQ0KPiA+Pj4gd2hldGhlciBvciBub3QgdG8gYXNzaWduIGEgY291bnRl
ciBmb3IgaXQuDQo+ID4+IFRoYXQncyB3aGF0IGl0IGRvZXMsIEkgdW5kZXJzdGFuZCB0aGF0LiBJ
J20gc2F5aW5nIHRoYXQgdGhhdCBpcw0KPiA+PiBjcmVhdGluZyBhcnRpZmljaWFsIGNvbnRlbnRp
b24uDQo+ID4+DQo+ID4+DQo+ID4+IFdoeSBpcyB0aGlzIG5lZWRlZCBhbnl3YXk/IENhbid0IHdl
IGZvcmNlIHRoZSBndWVzdCB0byBmbHVzaCBhbmQgdGhlbg0KPiA+PiBtb3ZlIGl0IG92ZXIgdG8g
YSBuZXcgY291bnRlcj8NCj4gPg0KPiANCj4gQ3VycmVudCBwZXJmIHNjaGVkdWxpbmcgaXMgcHVy
ZSBzb2Z0d2FyZSBiZWhhdmlvci4gS1ZNIG9ubHkgdHJhcHMgdGhlIE1TUg0KPiBhY2Nlc3MuIEl0
4oCZcyBpbXBvc3NpYmxlIGZvciBLVk0gdG8gaW1wYWN0IHRoZSBndWVzdOKAmXMgc2NoZWR1bGlu
ZyB3aXRoIGN1cnJlbnQNCj4gaW1wbGVtZW50YXRpb24uDQo+IA0KPiBUbyBhZGRyZXNzIHRoZSBj
b25jZXJuIHJlZ2FyZGluZyB0byAnYXJ0aWZpY2lhbCBjb250ZW50aW9uJywgd2UgaGF2ZSB0d28N
Cj4gcHJvcG9zYWxzLg0KPiBDb3VsZCB5b3UgcGxlYXNlIHRha2UgYSBsb29rLCBhbmQgc2hhcmUg
eW91ciB0aG91Z2h0cz8NCj4gDQo+IFByb3Bvc2FsIDE6DQo+IFJlamVjdCB0aGUgZ3Vlc3QgcmVx
dWVzdCwgaWYgaG9zdCBoYXMgdG8gdXNlIHRoZSBjb3VudGVyIHdoaWNoIG9jY3VwaWVkIGJ5DQo+
IGd1ZXN0LiBBdCB0aGUgbWVhbnRpbWUsIGhvc3QgcHJpbnRzIGEgd2FybmluZy4NCj4gSSBzdGls
bCB0aGluayB0aGUgY29udGVudGlvbiBzaG91bGQgcmFyZWx5IGhhcHBlbiBpbiBwcmFjdGljYWwu
DQo+IFBlcnNvbmFsbHksIEkgcHJlZmVyIHRoaXMgcHJvcG9zYWwuDQo+IA0KPiANCj4gUHJvcG9z
YWwgMjoNCj4gQWRkIEhXIGFkdmlzb3IgZm9yIHRoZSBzY2hlZHVsZXIgaW4gZ3Vlc3QuDQo+IFN0
YXJ0cyBmcm9tIEFyY2hpdGVjdHVyYWwgUGVyZm1vbiBWZXJzaW9uIDQsIElBMzJfUEVSRl9HTE9C
QUxfSU5VU0UgTVNSDQo+IGlzIGludHJvZHVjZWQuIEl0IHByb3ZpZGVzIGFuIOKAnEluVXNl4oCd
IGJpdCBmb3IgZWFjaCBwcm9ncmFtbWFibGUNCj4gcGVyZm9ybWFuY2UgY291bnRlciBhbmQgZml4
ZWQgY291bnRlciBpbiB0aGUgcHJvY2Vzc29yLg0KPiANCj4gSW4gcGVyZiwgdGhlIHNjaGVkdWxl
ciB3aWxsIHJlYWQgdGhlIE1TUiBhbmQgbWFzayB0aGUg4oCcaW4gdXNlZOKAnQ0KPiBjb3VudGVy
cy4gSSB0aGluayB3ZSBjYW4gdXNlIFg4Nl9GRUFUVVJFX0hZUEVSVklTT1IgdG8gbGltaXQgdGhl
IGNoZWNrDQo+IGluIGd1ZXN0LiBGb3Igbm9uLXZpcnR1YWxpemF0aW9uIHVzYWdlIGFuZCBob3N0
LCBub3RoaW5nIGNoYW5nZWQgZm9yDQo+IHNjaGVkdWxlci4NCj4gDQo+IEJ1dCB0aGVyZSBpcyBz
dGlsbCBhIHByb2JsZW0gZm9yIHRoaXMgcHJvcG9zYWwuIEhvc3QgbWF5IHJlcXVlc3QgYQ0KPiBj
b3VudGVyIGxhdGVyLCB3aGljaCBoYXMgYmVlbiB1c2VkIGJ5IGd1ZXN0Lg0KPiBXZSBjYW4gb25s
eSBkbyBtdWx0aXBsZXhpbmcgb3IgZ3JhYiB0aGUgY291bnRlciBqdXN0IGxpa2UgcHJvcG9zYWwg
MS4NCg0KSGkgUGV0ZXIsDQogICAgV2hhdCBpcyB5b3VyIG9waW5pb24/DQoNClRoYW5rcywNCkx1
d2VpIEthbmcNCg0K
