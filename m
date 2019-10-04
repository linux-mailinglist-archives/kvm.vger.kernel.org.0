Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372D5CC34E
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 21:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbfJDTGv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 15:06:51 -0400
Received: from mga04.intel.com ([192.55.52.120]:40977 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730018AbfJDTGu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 15:06:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 12:06:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,257,1566889200"; 
   d="scan'208";a="367474761"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by orsmga005.jf.intel.com with ESMTP; 04 Oct 2019 12:06:49 -0700
Received: from orsmsx111.amr.corp.intel.com (10.22.240.12) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 4 Oct 2019 12:06:49 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.161]) by
 ORSMSX111.amr.corp.intel.com ([169.254.12.70]) with mapi id 14.03.0439.000;
 Fri, 4 Oct 2019 12:06:49 -0700
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
        "Dock, Deneen T" <deneen.t.dock@intel.com>,
        "yu.c.zhang@linux.intel.com" <yu.c.zhang@linux.intel.com>
Subject: Re: [RFC PATCH 03/13] kvm: Add XO memslot type
Thread-Topic: [RFC PATCH 03/13] kvm: Add XO memslot type
Thread-Index: AQHVejL5N5jO3Ib8wEKh4Roo4WuQGadKizWAgADDeoA=
Date:   Fri, 4 Oct 2019 19:06:49 +0000
Message-ID: <9b885e65c3ec0ab8b4de0d38f2f20686a7afe0d0.camel@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
         <20191003212400.31130-4-rick.p.edgecombe@intel.com>
         <5201724e-bded-1af1-7f46-0f3e1763c797@redhat.com>
In-Reply-To: <5201724e-bded-1af1-7f46-0f3e1763c797@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.54.75.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A851DFD33B8F24CADA4E2173004C47F@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDE5LTEwLTA0IGF0IDA5OjI3ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAwMy8xMC8xOSAyMzoyMywgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+ID4gQWRkIFhPIG1l
bXNsb3QgdHlwZSB0byBjcmVhdGUgZXhlY3V0ZS1vbmx5IGd1ZXN0IHBoeXNpY2FsIG1lbW9yeSBi
YXNlZCBvbg0KPiA+IHRoZSBSTyBtZW1zbG90LiBMaWtlIHRoZSBSTyBtZW1zbG90LCBkaXNhbGxv
dyBjaGFuZ2luZyB0aGUgbWVtc2xvdCB0eXBlDQo+ID4gdG8vZnJvbSBYTy4NCj4gPiANCj4gPiBJ
biB0aGUgRVBUIGNhc2UgQUNDX1VTRVJfTUFTSyByZXByZXNlbnRzIHRoZSByZWFkYWJsZSBiaXQs
IHNvIGFkZCB0aGUNCj4gPiBhYmlsaXR5IGZvciBzZXRfc3B0ZSgpIHRvIHVuc2V0IHRoaXMuDQo+
ID4gDQo+ID4gVGhpcyBpcyBiYXNlZCBpbiBwYXJ0IG9uIGEgcGF0Y2ggYnkgWXUgWmhhbmcuDQo+
ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogWXUgWmhhbmcgPHl1LmMuemhhbmdAbGludXguaW50ZWwu
Y29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJl
QGludGVsLmNvbT4NCj4gDQo+IEluc3RlYWQgb2YgdGhpcywgd2h5IG5vdCBjaGVjayB0aGUgZXhp
dCBxdWFsaWZpY2F0aW9uIGdwYSBhbmQsIGlmIGl0IGhhcw0KPiB0aGUgWE8gYml0IHNldCwgbWFz
ayBhd2F5IGJvdGggdGhlIFhPIGJpdCBhbmQgdGhlIFIgYml0PyAgSXQgY2FuIGJlIGRvbmUNCj4g
dW5jb25kaXRpb25hbGx5IGZvciBhbGwgbWVtc2xvdHMuICBUaGlzIHNob3VsZCByZXF1aXJlIG5v
IGNoYW5nZSB0bw0KPiB1c2Vyc3BhY2UuDQo+IA0KPiBQYW9sbw0KPiANClRoZSByZWFzb25pbmcg
d2FzIHRoYXQgaXQgc2VlbXMgbGlrZSBLVk0gbGVhdmVzIGl0IHRvIHVzZXJzcGFjZSB0byBjb250
cm9sIHRoZQ0KcGh5c2ljYWwgYWRkcmVzcyBzcGFjZSBsYXlvdXQgc2luY2UgdXNlcnNwYWNlIGRl
Y2lkZXMgdGhlIHN1cHBvcnRlZCBwaHlzaWNhbA0KYWRkcmVzcyBiaXRzIGFuZCBsYXlzIG91dCBt
ZW1vcnkgaW4gdGhlIHBoeXNpY2FsIGFkZHJlc3Mgc3BhY2UuIFNvIGR1cGxpY2F0aW9uDQp3aXRo
IFhPIG1lbXNsb3RzIHdhcyBhbiBhdHRlbXB0IHdhcyB0byBrZWVwIHRoZSBsb2dpYyBhcm91bmQg
dGhhdCB0b2dldGhlci4NCg0KSSdsbCB0YWtlIGFub3RoZXIgbG9vayBhdCBkb2luZyBpdCB0aGlz
IHdheSB0aG91Z2guIEkgdGhpbmsgdXNlcnNwYWNlIG1heSBzdGlsbA0KbmVlZCB0byBhZGp1c3Qg
dGhlIE1BWFBIWUFERFIgYW5kIGJlIGF3YXJlIGl0IGNhbid0IGxheW91dCBtZW1vcnkgaW4gdGhl
IFhPDQpyYW5nZS4NCg0KVGhhbmtzLA0KDQpSaWNrDQo=
