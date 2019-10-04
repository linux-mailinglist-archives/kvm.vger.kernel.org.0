Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C910FCC371
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 21:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730699AbfJDTMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 15:12:41 -0400
Received: from mga04.intel.com ([192.55.52.120]:41347 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728360AbfJDTMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 15:12:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 12:12:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,257,1566889200"; 
   d="scan'208";a="392407462"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by fmsmga005.fm.intel.com with ESMTP; 04 Oct 2019 12:12:40 -0700
Received: from orsmsx122.amr.corp.intel.com (10.22.225.227) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 4 Oct 2019 12:12:40 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.161]) by
 ORSMSX122.amr.corp.intel.com ([169.254.11.236]) with mapi id 14.03.0439.000;
 Fri, 4 Oct 2019 12:12:40 -0700
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
Subject: Re: [RFC PATCH 12/13] mmap: Add XO support for KVM XO
Thread-Topic: [RFC PATCH 12/13] mmap: Add XO support for KVM XO
Thread-Index: AQHVejL810qxbL99z0uaNll5uKFEJqdKjTaAgADDGoA=
Date:   Fri, 4 Oct 2019 19:12:39 +0000
Message-ID: <a52a8d1058ab6752c3d0402076f831b52c7844d7.camel@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
         <20191003212400.31130-13-rick.p.edgecombe@intel.com>
         <a0ea3b34-2131-3fd5-3842-ae3f98edf8d8@redhat.com>
In-Reply-To: <a0ea3b34-2131-3fd5-3842-ae3f98edf8d8@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.54.75.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F411B2DEF13E8948A71F00EC5EAB3314@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDE5LTEwLTA0IGF0IDA5OjM0ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAwMy8xMC8xOSAyMzoyMywgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+ID4gKw0KPiA+ICsJ
cHJvdGVjdGlvbl9tYXBbNF0gPSBQQUdFX0VYRUNPTkxZOw0KPiA+ICsJcHJvdGVjdGlvbl9tYXBb
MTJdID0gUEFHRV9FWEVDT05MWTsNCj4gDQo+IENhbiB5b3UgYWRkICNkZWZpbmVzIGZvciB0aGUg
Yml0cyBpbiBwcm90ZWN0aW9uX21hcD8gIEFsc28gcGVyaGFwcyB5b3UNCj4gY2FuIHJlcGxhY2Ug
dGhlIHBfeG8vcF94ci9zX3hvL3NfeHIgY2hlY2tzIHdpdGgganVzdCB3aXRoICJpZg0KPiAocGd0
YWJsZV9rdm14b19lbmFibGVkKCkiLg0KPiANCj4gUGFvbG8NCg0KUEFHRV9FWEVDT05MWSBpcyBu
b3Qga25vd24gYXQgY29tcGlsZSB0aW1lIHNpbmNlIHRoZSBOUiBiaXQgcG9zaXRpb24gZGVwZW5k
cw0Kb24gdGhlIG51bWJlciBvZiBwaHlzaWNhbCBhZGRyZXNzIGJpdHMuIFNvIGl0IGNhbid0IGJl
IHNldCB0aGUgd2F5IHRoZSBvdGhlcg0Kb25lcyBhcmUgaW4gcHJvdGVjdGlvbl9tYXBbXSwgaWYg
dGhhdHMgd2hhdCB5b3UgYXJlIHNheWluZy4NCg0KSSBkaWRuJ3QgbG92ZSB0aGUgcF94by9wX3hy
L3NfeG8vc194ciBjaGVja3MsIGJ1dCBzaW5jZSBtbS9tbWFwLmMgaXMgY3Jvc3MgYXJjaA0KaXQg
c2VlbWVkIHRoZSBiZXN0IG9wdGlvbi4gTWF5YmUgYSBjcm9zcyBhcmNoIGhlbHBlciBsaWtlDQpu
b25fcGtleV94b19zdXBwb3J0ZWQoKSBpbnN0ZWFkPw0K
