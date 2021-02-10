Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC873317230
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 22:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhBJVU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 16:20:59 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:63340 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhBJVU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 16:20:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1612992059; x=1644528059;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=Gw/p55C3EcrZRIb+r10UNE2J4XRblc54MM0mWDxYHNM=;
  b=v1JuEZEeTWfjcquzii8qHt/2ruKVgU+igOJugURX/gX0N5mfxAt0wsf7
   JT5jW199HnkAZTnxZ2IRLzAkUoxyTMjKK6fR3cfpJpXEGRIVUux/EjPjo
   Ar/P/SqmbrLFkxekN1t7CiHVKIAYhSAh+tCtzdnnqhIERY7UxyJHSQoHK
   8=;
X-IronPort-AV: E=Sophos;i="5.81,169,1610409600"; 
   d="scan'208";a="81802886"
Subject: Re: [PATCH 5/5] KVM: x86/xen: Explicitly pad struct compat_vcpu_info to 64
 bytes
Thread-Topic: [PATCH 5/5] KVM: x86/xen: Explicitly pad struct compat_vcpu_info to 64 bytes
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 10 Feb 2021 21:20:12 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 2EBC7A20C6;
        Wed, 10 Feb 2021 21:20:08 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 10 Feb 2021 21:20:08 +0000
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 10 Feb 2021 21:20:08 +0000
Received: from EX13D08UEB001.ant.amazon.com ([10.43.60.245]) by
 EX13D08UEB001.ant.amazon.com ([10.43.60.245]) with mapi id 15.00.1497.010;
 Wed, 10 Feb 2021 21:20:08 +0000
From:   "Woodhouse, David" <dwmw@amazon.co.uk>
To:     "seanjc@google.com" <seanjc@google.com>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Index: AQHW/9pOzhEdoEl9PkGnB5lokEkwtKpR3VyAgAAF/YCAAAH0gA==
Date:   Wed, 10 Feb 2021 21:20:08 +0000
Message-ID: <9dbfbc342899895a13effb7ed745001549b51798.camel@amazon.co.uk>
References: <20210210182609.435200-1-seanjc@google.com>
         <20210210182609.435200-6-seanjc@google.com>
         <8752a59b694671d25308d644cba661c4ec128094.camel@amazon.co.uk>
         <YCRMY17WEdpJYd3C@google.com>
In-Reply-To: <YCRMY17WEdpJYd3C@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.161.87]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E53F7ACE5AF36E448C20592C01D82242@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIxLTAyLTEwIGF0IDEzOjEzIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEZlYiAxMCwgMjAyMSwgV29vZGhvdXNlLCBEYXZpZCB3cm90ZToNCj4g
PiBPbiBXZWQsIDIwMjEtMDItMTAgYXQgMTA6MjYgLTA4MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6DQo+ID4gU28gaXQgaXNuJ3QgY2xlYXIgdGhlIGFkZGl0aW9uYWxseSBwYWRkaW5nIHJl
YWxseSBidXlzIHVzIGFueXRoaW5nOyBpZg0KPiA+IHdlIHBsYXkgdGhpcyBnYW1lIHdpdGhvdXQg
a25vd2luZyB0aGUgQUJJIHdlJ2QgYmUgc2NyZXdlZCBhbnl3YXkuIEJ1dA0KPiA+IGl0IGRvZXNu
J3QgaHVydC4NCj4gDQo+IFlhLCB0aGlzIGlzIHB1cmVseSBmb3IgZm9sa3MgcmVhZGluZyB0aGUg
Y29kZSBhbmQgd29uZGVyaW5nIGhvdyA2Mj09NjQuDQoNCkZhaXIgZW5vdWdoLiBUaGF0IGtpbmQg
b2YgdGhpbmcgaXMgd2h5IEkgbGl0dGVyZWQgdGhlIGNvZGUgd2l0aA0KYXNzZXJ0aW9ucyBiYXNl
ZCBvbiBzaXplb2YoKSBhbmQgb2Zmc2V0b2YoKSA6KQ0KCgoKQW1hem9uIERldmVsb3BtZW50IENl
bnRyZSAoTG9uZG9uKSBMdGQuIFJlZ2lzdGVyZWQgaW4gRW5nbGFuZCBhbmQgV2FsZXMgd2l0aCBy
ZWdpc3RyYXRpb24gbnVtYmVyIDA0NTQzMjMyIHdpdGggaXRzIHJlZ2lzdGVyZWQgb2ZmaWNlIGF0
IDEgUHJpbmNpcGFsIFBsYWNlLCBXb3JzaGlwIFN0cmVldCwgTG9uZG9uIEVDMkEgMkZBLCBVbml0
ZWQgS2luZ2RvbS4KCgo=

