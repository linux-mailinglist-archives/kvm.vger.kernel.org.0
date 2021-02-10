Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF793171C3
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 21:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhBJUzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 15:55:54 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:39539 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233250AbhBJUzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 15:55:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1612990541; x=1644526541;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=i0HtIP/qbjGaP102XGawz/m1d/lEN9tlex3K4OxTdiY=;
  b=VO71o7AT13fglcrLujB1vLZJQQjumW/QFTJgZEPnbuKgqt+xyCILscYf
   mw5okPKoa/rnOAgGQAeKMHZ2WzK+UhJplnzPiZVjBtYdq+/2M7TD2Z6dN
   cv3PIsAXmjY9Ig5wvCMleCBKjg7lSQTmSTiPEfgs+aCnDCIyGrAie9PJd
   c=;
X-IronPort-AV: E=Sophos;i="5.81,169,1610409600"; 
   d="scan'208";a="81585673"
Subject: Re: [PATCH 3/5] KVM: selftests: Fix hex vs. decimal snafu in Xen test
Thread-Topic: [PATCH 3/5] KVM: selftests: Fix hex vs. decimal snafu in Xen test
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 10 Feb 2021 20:54:59 +0000
Received: from EX13MTAUEE001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com (Postfix) with ESMTPS id 9FC0DB58F9;
        Wed, 10 Feb 2021 20:54:58 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 10 Feb 2021 20:54:57 +0000
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 10 Feb 2021 20:54:57 +0000
Received: from EX13D08UEB001.ant.amazon.com ([10.43.60.245]) by
 EX13D08UEB001.ant.amazon.com ([10.43.60.245]) with mapi id 15.00.1497.010;
 Wed, 10 Feb 2021 20:54:57 +0000
From:   "Woodhouse, David" <dwmw@amazon.co.uk>
To:     "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Thread-Index: AQHW/9peovAMIjtkIU+hjKs5M3Og/qpR3kQA
Date:   Wed, 10 Feb 2021 20:54:57 +0000
Message-ID: <f8999fded9ab51e0d8b383c4e7a300905a6bf5ed.camel@amazon.co.uk>
References: <20210210182609.435200-1-seanjc@google.com>
         <20210210182609.435200-4-seanjc@google.com>
In-Reply-To: <20210210182609.435200-4-seanjc@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.161.244]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9A801057162CED4D848843345B96AF89@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIxLTAyLTEwIGF0IDEwOjI2IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBUaGUgWGVuIHNoaW5mbyBzZWxmdGVzdCB1c2VzICc0MCcgd2hlbiBzZXR0aW5nIHRo
ZSBHUEEgb2YgdGhlIHZDUFUgaW5mbw0KPiBzdHJ1Y3QsIGJ1dCBjaGVja3MgZm9yIHRoZSByZXN1
bHQgYXQgJzB4NDAnLiAgQXJiaXRyYXJpbHkgdXNlIHRoZSBoZXgNCj4gdmVyc2lvbiB0byByZXNv
bHZlIHRoZSBidWcuDQo+IA0KPiBGaXhlczogOGQ0ZTdlODA4MzhmICgiS1ZNOiB4ODY6IGRlY2xh
cmUgWGVuIEhWTSBzaGFyZWQgaW5mbyBjYXBhYmlsaXR5IGFuZCBhZGQgdGVzdCBjYXNlIikNCj4g
Q2M6IERhdmlkIFdvb2Rob3VzZSA8ZHdtd0BhbWF6b24uY28udWs+DQo+IFNpZ25lZC1vZmYtYnk6
IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KDQpPb3BzLCBzb3JyeSBh
Ym91dCB0aGF0LiBJJ20gYWN0dWFsbHkga2luZCBvZiBpbXByZXNzZWQgdGhhdCB0aGF0IG5vdA0K
b25seSB3b3JrZWQgZm9yIG1lIGV2ZXJ5IHRpbWUgSSB0ZXN0ZWQgaXQsIGJ1dCBhbHNvIElJUkMg
aXQgYWN0dWFsbHkNCipmYWlsZWQqIGZvciBtZSBvbiBhbGwgdGhlIG9jY2FzaW9ucyBJIGV4cGVj
dGVkIGl0IHRvIGZhaWwuDQoNClJldmlld2VkLWJ5OiBEYXZpZCBXb29kaG91c2UgPGR3bXdAYW1h
em9uLmNvLnVrPg0KDQoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudHJlIChMb25kb24pIEx0ZC4g
UmVnaXN0ZXJlZCBpbiBFbmdsYW5kIGFuZCBXYWxlcyB3aXRoIHJlZ2lzdHJhdGlvbiBudW1iZXIg
MDQ1NDMyMzIgd2l0aCBpdHMgcmVnaXN0ZXJlZCBvZmZpY2UgYXQgMSBQcmluY2lwYWwgUGxhY2Us
IFdvcnNoaXAgU3RyZWV0LCBMb25kb24gRUMyQSAyRkEsIFVuaXRlZCBLaW5nZG9tLgoKCg==

