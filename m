Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC81DCC341
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 21:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbfJDTEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 15:04:00 -0400
Received: from mga04.intel.com ([192.55.52.120]:40786 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfJDTEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 15:04:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 12:03:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,257,1566889200"; 
   d="scan'208";a="204406165"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga002.jf.intel.com with ESMTP; 04 Oct 2019 12:03:59 -0700
Received: from orsmsx162.amr.corp.intel.com (10.22.240.85) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 4 Oct 2019 12:03:59 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.161]) by
 ORSMSX162.amr.corp.intel.com ([169.254.3.170]) with mapi id 14.03.0439.000;
 Fri, 4 Oct 2019 12:03:59 -0700
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
Subject: Re: [RFC PATCH 00/13] XOM for KVM guest userspace
Thread-Topic: [RFC PATCH 00/13] XOM for KVM guest userspace
Thread-Index: AQHVejL3BY31w2dp/kGOlEfaBbHp/adKifcAgADD7AA=
Date:   Fri, 4 Oct 2019 19:03:58 +0000
Message-ID: <8a03afd35240c180c3bea8d613acd85f8dee86cc.camel@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
         <bc025a4f-2128-24ed-e5b7-76802f22cd53@redhat.com>
In-Reply-To: <bc025a4f-2128-24ed-e5b7-76802f22cd53@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.54.75.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7ACE2019637B784299509B87C8DEE1B5@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDE5LTEwLTA0IGF0IDA5OjIyICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAwMy8xMC8xOSAyMzoyMywgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+ID4gU2luY2Ugc29m
dHdhcmUgd291bGQgaGF2ZSBwcmV2aW91c2x5IHJlY2VpdmVkIGEgI1BGIHdpdGggdGhlIFJTVkQg
ZXJyb3IgY29kZQ0KPiA+IHNldCwgd2hlbiB0aGUgSFcgZW5jb3VudGVyZWQgYW55IHNldCBiaXRz
IGluIHRoZSByZWdpb24gNTEgdG8gTSwgdGhlcmUgd2FzDQo+ID4gc29tZQ0KPiA+IGludGVybmFs
IGRpc2N1c3Npb24gb24gd2hldGhlciB0aGlzIHNob3VsZCBoYXZlIGEgdmlydHVhbCBNU1IgZm9y
IHRoZSBPUyB0bw0KPiA+IHR1cm4NCj4gPiBpdCBvbiBvbmx5IGlmIHRoZSBPUyBrbm93cyBpdCBp
c24ndCByZWx5aW5nIG9uIHRoaXMgYmVoYXZpb3IgZm9yIGJpdCBNLiBUaGUNCj4gPiBhcmd1bWVu
dCBhZ2FpbnN0IG5lZWRpbmcgYW4gTVNSIGlzIHRoaXMgYmx1cmIgZnJvbSB0aGUgSW50ZWwgU0RN
IGFib3V0DQo+ID4gcmVzZXJ2ZWQNCj4gPiBiaXRzOg0KPiA+ICJCaXRzIHJlc2VydmVkIGluIHRo
ZSBwYWdpbmctc3RydWN0dXJlIGVudHJpZXMgYXJlIHJlc2VydmVkIGZvciBmdXR1cmUNCj4gPiBm
dW5jdGlvbmFsaXR5LiBTb2Z0d2FyZSBkZXZlbG9wZXJzIHNob3VsZCBiZSBhd2FyZSB0aGF0IHN1
Y2ggYml0cyBtYXkgYmUNCj4gPiB1c2VkIGluDQo+ID4gdGhlIGZ1dHVyZSBhbmQgdGhhdCBhIHBh
Z2luZy1zdHJ1Y3R1cmUgZW50cnkgdGhhdCBjYXVzZXMgYSBwYWdlLWZhdWx0DQo+ID4gZXhjZXB0
aW9uDQo+ID4gb24gb25lIHByb2Nlc3NvciBtaWdodCBub3QgZG8gc28gaW4gdGhlIGZ1dHVyZS4i
DQo+ID4gDQo+ID4gU28gaW4gdGhlIGN1cnJlbnQgcGF0Y2hzZXQgdGhlcmUgaXMgbm8gTVNSIHdy
aXRlIHJlcXVpcmVkIGZvciB0aGUgZ3Vlc3QgdG8NCj4gPiB0dXJuDQo+ID4gb24gdGhpcyBmZWF0
dXJlLiBJdCB3aWxsIGhhdmUgdGhpcyBiZWhhdmlvciB3aGVuZXZlciBxZW11IGlzIHJ1biB3aXRo
DQo+ID4gIi1jcHUgK3hvIi4NCj4gDQo+IEkgdGhpbmsgdGhlIHBhcnQgb2YgdGhlIG1hbnVhbCB0
aGF0IHlvdSBxdW90ZSBpcyBvdXQgb2YgZGF0ZS4gIFdoZW5ldmVyDQo+IEludGVsIGhhcyAidW5y
ZXNlcnZlZCIgYml0cyBpbiB0aGUgcGFnZSB0YWJsZXMgdGhleSBoYXZlIGRvbmUgdGhhdCBvbmx5
DQo+IGlmIHNwZWNpZmljIGJpdHMgaW4gQ1I0IG9yIEVGRVIgb3IgVk1DUyBleGVjdXRpb24gY29u
dHJvbHMgYXJlIHNldDsgdGhpcw0KPiBpcyBhIGdvb2QgdGhpbmcsIGFuZCBJJ2QgcmVhbGx5IGxp
a2UgaXQgdG8gYmUgY29kaWZpZWQgaW4gdGhlIFNETS4NCj4gDQo+IFRoZSBvbmx5IGJpdHMgZm9y
IHdoaWNoIHRoaXMgZG9lcyBub3QgKGFuZCBzaG91bGQgbm90KSBhcHBseSBhcmUgaW5kZWVkDQo+
IGJpdHMgNTE6TUFYUEhZQUREUi4gIEJ1dCB0aGUgU0RNIG1ha2VzIGl0IGNsZWFyIHRoYXQgYml0
cyA1MTpNQVhQSFlBRERSDQo+IGFyZSByZXNlcnZlZCwgaGVuY2UgInVucmVzZXJ2aW5nIiBiaXRz
IGJhc2VkIG9uIGp1c3QgYSBRRU1VIGNvbW1hbmQgbGluZQ0KPiBvcHRpb24gd291bGQgYmUgYWdh
aW5zdCB0aGUgc3BlY2lmaWNhdGlvbi4gIFNvLCBwbGVhc2UgZG9uJ3QgZG8gdGhpcyBhbmQNCj4g
aW50cm9kdWNlIGFuIE1TUiB0aGF0IGVuYWJsZXMgdGhlIGZlYXR1cmUuDQo+IA0KPiBQYW9sbw0K
PiANCkhpIFBhb2xvLA0KDQpUaGFua3MgZm9yIHRha2luZyBhIGxvb2shDQoNCkZhaXIgZW5vdWdo
LCBNU1IgaXQgaXMuDQoNClJpY2sNCg==
