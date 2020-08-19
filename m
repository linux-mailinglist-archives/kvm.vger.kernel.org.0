Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26752498D0
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 10:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgHSI4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 04:56:03 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:31188 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgHSIxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 04:53:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597827231; x=1629363231;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Qiqi6G1Enlghvpshg3m6bdM1gK//pU2NSsB7zQgFc58=;
  b=QSf2yM18vaIxIzLDvk8bO/r+wdZaX1BSyeTvo1/OwXnAR/TE1QnRvQhY
   OEBG2pxCwVFfxnQINy6HCAlrsDWcS+GX/D7owHyv/Kj63M0IR+AGtxz3r
   wt2Bur9S+unSqW3iMfdC32CoqOMrqm6DgcYtAoxezS3YPfvMPHuBo8Ie4
   o=;
X-IronPort-AV: E=Sophos;i="5.76,330,1592870400"; 
   d="scan'208";a="50090133"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 19 Aug 2020 08:53:50 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id 42DE5A039D;
        Wed, 19 Aug 2020 08:53:49 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 08:53:48 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.156) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 08:53:46 +0000
Subject: Re: [PATCH v3 02/12] KVM: x86: Introduce allow list for MSR emulation
To:     Aaron Lewis <aaronlewis@google.com>, <jmattson@google.com>
CC:     <pshier@google.com>, <oupton@google.com>, <kvm@vger.kernel.org>,
        KarimAllah Ahmed <karahmed@amazon.de>
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-3-aaronlewis@google.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <f2b3b8c4-a1ee-843c-e94f-71a8993ea6c6@amazon.com>
Date:   Wed, 19 Aug 2020 10:53:43 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200818211533.849501-3-aaronlewis@google.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.156]
X-ClientProxiedBy: EX13D36UWA002.ant.amazon.com (10.43.160.24) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxOC4wOC4yMCAyMzoxNSwgQWFyb24gTGV3aXMgd3JvdGU6Cj4gCj4gSXQncyBub3QgZGVz
aXJlYWJsZSB0byBoYXZlIGFsbCBNU1JzIGFsd2F5cyBoYW5kbGVkIGJ5IEtWTSBrZXJuZWwgc3Bh
Y2UuIFNvbWUKPiBNU1JzIHdvdWxkIGJlIHVzZWZ1bCB0byBoYW5kbGUgaW4gdXNlciBzcGFjZSB0
byBlaXRoZXIgZW11bGF0ZSBiZWhhdmlvciAobGlrZQo+IHVDb2RlIHVwZGF0ZXMpIG9yIGRpZmZl
cmVudGlhdGUgd2hldGhlciB0aGV5IGFyZSB2YWxpZCBiYXNlZCBvbiB0aGUgQ1BVIG1vZGVsLgo+
IAo+IFRvIGFsbG93IHVzZXIgc3BhY2UgdG8gc3BlY2lmeSB3aGljaCBNU1JzIGl0IHdhbnRzIHRv
IHNlZSBoYW5kbGVkIGJ5IEtWTSwKPiB0aGlzIHBhdGNoIGludHJvZHVjZXMgYSBuZXcgaW9jdGwg
dG8gcHVzaCBhbGxvdyBsaXN0cyBvZiBiaXRtYXBzIGludG8KPiBLVk0uIEJhc2VkIG9uIHRoZXNl
IGJpdG1hcHMsIEtWTSBjYW4gdGhlbiBkZWNpZGUgd2hldGhlciB0byByZWplY3QgTVNSIGFjY2Vz
cy4KPiBXaXRoIHRoZSBhZGRpdGlvbiBvZiBLVk1fQ0FQX1g4Nl9VU0VSX1NQQUNFX01TUiBpdCBj
YW4gYWxzbyBkZWZsZWN0IHRoZQo+IGRlbmllZCBNU1IgZXZlbnRzIHRvIHVzZXIgc3BhY2UgdG8g
b3BlcmF0ZSBvbi4KPiAKPiBJZiBubyBhbGxvd2xpc3QgaXMgcG9wdWxhdGVkLCBNU1IgaGFuZGxp
bmcgc3RheXMgaWRlbnRpY2FsIHRvIGJlZm9yZS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBLYXJpbUFs
bGFoIEFobWVkIDxrYXJhaG1lZEBhbWF6b24uZGU+Cj4gU2lnbmVkLW9mZi1ieTogQWxleGFuZGVy
IEdyYWYgPGdyYWZAYW1hem9uLmNvbT4KClNhbWUgaGVyZSwgU29CIGxpbmUgaXMgbWlzc2luZy4K
CkkgYWxzbyBzZWUgdGhhdCB5b3UgZGlkbid0IGFkZHJlc3MgdGhlIG5pdHMgeW91IGhhZCBvbiB0
aGlzIHBhdGNoOgoKWy4uLl0KCiA+PiArICBGaWx0ZXIgYm9vdGggcmVhZCBhbmQgd3JpdGUgYWNj
ZXNzZXMgdG8gTVNScyB1c2luZyB0aGUgZ2l2ZW4gCmJpdG1hcC4gQSAwCiA+PiArICBpbiB0aGUg
Yml0bWFwIGluZGljYXRlcyB0aGF0IGJvdGggcmVhZHMgYW5kIHdyaXRlcyBzaG91bGQgCmltbWVk
aWF0ZWx5IGZhaWwsCiA+PiArICB3aGlsZSBhIDEgaW5kaWNhdGVzIHRoYXQgcmVhZHMgYW5kIHdy
aXRlcyBzaG91bGQgYmUgaGFuZGxlZCBieSAKdGhlIG5vcm1hbAogPj4gKyAgS1ZNIE1TUiBlbXVs
YXRpb24gbG9naWMuCiA+CiA+IG5pdDogRmlsdGVyIGJvdGgKClsuLi5dCgogPj4gKy8qIE1heGlt
dW0gc2l6ZSBvZiB0aGUgb2YgdGhlIGJpdG1hcCBpbiBieXRlcyAqLwogPgogPiBuaXQ6ICJvZiB0
aGUiIGlzIHJlcGVhdGVkIHR3aWNlCgoKCkZlZWwgZnJlZSB0byBjaGFuZ2UgdGhlbSBpbiB5b3Vy
IHBhdGNoIHNldGFuZCBhZGQgYSBub3RlIGJldHdlZW4gdGhlIFNvQiAKbGluZXM6CgpTaWduZWQt
b2ZmLWJ5OiBLYXJpbUFsbGFoIEFobWVkIDxrYXJhaG1lZEBhbWF6b24uZGUKU2lnbmVkLW9mZi1i
eTogQWxleGFuZGVyIEdyYWYgPGdyYWZAYW1hem9uLmNvbT4KW2Fhcm9ubGV3aXM6IHMvb2YgdGhl
IG9mIHRoZS9vZiB0aGUvLCBzL2Jvb3RoL2JvdGgvXQpTaWduZWQtb2ZmLWJ5OiBBYXJvbiBMZXdp
cyA8YWFyb25sZXdpc0Bnb29nbGUuY29tPgoKCkFsZXgKCgoKQW1hem9uIERldmVsb3BtZW50IENl
bnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNm
dWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4g
YW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJl
cmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

