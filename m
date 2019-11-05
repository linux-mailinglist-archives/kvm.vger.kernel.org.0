Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F237EF5E7
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 08:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387667AbfKEHGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 02:06:08 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:41119 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387517AbfKEHGH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 02:06:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1572937566; x=1604473566;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=Ax1km2jTcb5+fvaj9QNskJ2PDAq4TW+HvuZWm4vh7fE=;
  b=ECjSGEPaHIgFdTycnVyqBFXKLKSE4uGMkEBc9eCwaGKohXVoigr6biJa
   JTN7RgC6JW3caXHOfCRhIwFQ/CYFtAjj0KS9qrStfYOWHBWeQm4+vZDDy
   J0PjHZ3llFaQIeuRh2siTahAWkjrTXXWnHdJjkKTjbYT5ETrmZpqBUYXl
   g=;
IronPort-SDR: vA7qQ8UlcbsPfGnPPStkd/Vajk/naxmu8vq8Sd+wkIwIvvIV1O02NtQEEcR9i1OoTufPPQV8Pj
 vHCIMzGA3Fbg==
X-IronPort-AV: E=Sophos;i="5.68,270,1569283200"; 
   d="scan'208";a="4200633"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 05 Nov 2019 07:06:04 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 6B216A2379;
        Tue,  5 Nov 2019 07:06:01 +0000 (UTC)
Received: from EX13D24EUC004.ant.amazon.com (10.43.164.79) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 5 Nov 2019 07:06:00 +0000
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13D24EUC004.ant.amazon.com (10.43.164.79) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 5 Nov 2019 07:05:58 +0000
Received: from EX13D20UWC001.ant.amazon.com ([10.43.162.244]) by
 EX13D20UWC001.ant.amazon.com ([10.43.162.244]) with mapi id 15.00.1367.000;
 Tue, 5 Nov 2019 07:05:57 +0000
From:   "Graf (AWS), Alexander" <graf@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,
        "Schoenherr, Jan H." <jschoenh@amazon.de>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Lukaszewicz, Rimas" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
Subject: Re: [PATCH v4 13/17] kvm: i8254: Deactivate APICv when using
 in-kernel PIT re-injection mode.
Thread-Topic: [PATCH v4 13/17] kvm: i8254: Deactivate APICv when using
 in-kernel PIT re-injection mode.
Thread-Index: AQHVkQWZiK56Wp7AO0m6btmzLjwET6d3peqAgAO6voCAADC+AIAAm34A
Date:   Tue, 5 Nov 2019 07:05:57 +0000
Message-ID: <7060AA92-0ACD-40F6-868A-5A7234F46C55@amazon.de>
References: <4e4bd2c3-50c4-b23e-2924-728a37a5f157@redhat.com>
In-Reply-To: <4e4bd2c3-50c4-b23e-2924-728a37a5f157@redhat.com>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="utf-8"
Content-ID: <88A7136E45DA4148B7F761429346A5A2@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gQW0gMDQuMTEuMjAxOSB1bSAyMjo1MCBzY2hyaWViIFBhb2xvIEJvbnppbmkgPHBib256
aW5pQHJlZGhhdC5jb20+Og0KPiANCj4g77u/T24gMDQvMTEvMTkgMTk6NTQsIFN1dGhpa3VscGFu
aXQsIFN1cmF2ZWUgd3JvdGU6DQo+PiBJIHNlZSB5b3UgcG9pbnQuDQo+PiANCj4+PiBXZSBjYW4g
d29yayBhcm91bmQgaXQgYnkgYWRkaW5nIGEgZ2xvYmFsIG1hc2sgb2YgaW5oaWJpdCByZWFzb25z
IHRoYXQNCj4+PiBhcHBseSB0byB0aGUgdmVuZG9yLCBhbmQgaW5pdGlhbGl6aW5nIGl0IGFzIHNv
b24gYXMgcG9zc2libGUgaW4gdm14LmMvc3ZtLmMuDQo+Pj4gDQo+Pj4gVGhlbiBrdm1fcmVxdWVz
dF9hcGljdl91cGRhdGUgY2FuIGlnbm9yZSByZWFzb25zIHRoYXQgdGhlIHZlbmRvciBkb2Vzbid0
DQo+Pj4gY2FyZSBhYm91dC4NCj4+IA0KPj4gV2hhdCBhYm91dCB3ZSBlbmhhbmNlIHRoZSBwcmVf
dXBkYXRlX2FwaXZjX2V4ZWNfY3RybCgpIHRvIGFsc28gcmV0dXJuIA0KPj4gc3VjY2Vzcy9mYWls
LiBJbiBoZXJlLCB0aGUgdmVuZG9yIHNwZWNpZmljIGNvZGUgY2FuIGRlY2lkZSB0byB1cGRhdGUg
DQo+PiBBUElDdiBzdGF0ZSBvciBub3QuDQo+IA0KPiBUaGF0IHdvcmtzIGZvciBtZSwgdG9vLiAg
U29tZXRoaW5nIGxpa2UgcmV0dXJuIGZhbHNlIGZvciBkZWFjdGl2YXRlIGFuZA0KPiB0cnVlIGZv
ciBhY3RpdmF0ZS4NCg0KSSdtIHRyeWluZyB0byB3cmFwIG15IGhlYWQgYXJvdW5kIGhvdyB0aGF0
IHdpbGwgd29yayB3aXRoIGxpdmUgbWlncmF0aW9uLiBEbyB3ZSBhbHNvIG5lZWQgdG8gc2F2ZS9y
ZXN0b3JlIHRoZSBkZWFjdGl2YXRlIHJlYXNvbnM/DQoNCkFsZXgNCg0KPiANCj4gUGFvbG8NCgoK
CkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEw
MTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIFJhbGYg
SGVyYnJpY2gKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIg
SFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

