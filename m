Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 318434C4860
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241357AbiBYPMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241014AbiBYPMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:12:43 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE25566AE0;
        Fri, 25 Feb 2022 07:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1645801931; x=1677337931;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WYYeEdy3fDIESQeCBUqRGoMnf0dz653qSX0d2zXrlBE=;
  b=i9YnsMLZx6bAY5IGDEMiVBBs5ZeQ9hlYj7KRFqPjWG/RPD9PnzLnLVAh
   kHmr4ywQGQ1ZM8tBvlU6x8wjebtYCwMynVHIrhw3tSUv9oZsml8/LpqvU
   JUIlu3H6OFpCdBrHtBEsybZ6vEgl7gKAPsE/a9BeY5urkzSHoJ+4+NdHd
   E=;
X-IronPort-AV: E=Sophos;i="5.90,136,1643673600"; 
   d="scan'208";a="66223167"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-fc41acad.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 25 Feb 2022 15:11:53 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-fc41acad.us-east-1.amazon.com (Postfix) with ESMTPS id 06BB4C0911;
        Fri, 25 Feb 2022 15:11:45 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Fri, 25 Feb 2022 15:11:43 +0000
Received: from [0.0.0.0] (10.43.161.126) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.28; Fri, 25 Feb
 2022 15:11:36 +0000
Message-ID: <9ac68552-c1fc-22c8-13e6-4f344f85a4fb@amazon.com>
Date:   Fri, 25 Feb 2022 16:11:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v4] virt: vmgenid: introduce driver for reinitializing RNG
 on VM fork
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     <kvm@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <adrian@parity.io>, <ardb@kernel.org>, <ben@skyportsystems.com>,
        <berrange@redhat.com>, <colmmacc@amazon.com>,
        <decui@microsoft.com>, <dwmw@amazon.co.uk>, <ebiggers@kernel.org>,
        <ehabkost@redhat.com>, <gregkh@linuxfoundation.org>,
        <haiyangz@microsoft.com>, <imammedo@redhat.com>,
        <jannh@google.com>, <kys@microsoft.com>, <lersek@redhat.com>,
        <linux@dominikbrodowski.net>, <mst@redhat.com>,
        <qemu-devel@nongnu.org>, <raduweis@amazon.com>,
        <sthemmin@microsoft.com>, <tytso@mit.edu>, <wei.liu@kernel.org>
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com>
 <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
 <YhjjuMOeV7+T7thS@zx2c4.com>
 <88ebdc32-2e94-ef28-37ed-1c927c12af43@amazon.com>
 <YhjoyIUv2+18BwiR@zx2c4.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <YhjoyIUv2+18BwiR@zx2c4.com>
X-Originating-IP: [10.43.161.126]
X-ClientProxiedBy: EX13D15UWA002.ant.amazon.com (10.43.160.218) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDI1LjAyLjIyIDE1OjMzLCBKYXNvbiBBLiBEb25lbmZlbGQgd3JvdGU6Cj4gT24gRnJpLCBG
ZWIgMjUsIDIwMjIgYXQgMDM6MTg6NDNQTSArMDEwMCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+
PiBJIHJlY2FsbCB0aGlzIHBhcnQgb2YgdGhlIG9sZCB0aHJlYWQuIEZyb20gd2hhdCBJIHVuZGVy
c3Rvb2QsIHVzaW5nCj4+PiAiVk1HRU5JRCIgKyAiUUVNVVZHSUQiIHdvcmtlZCAvd2VsbCBlbm91
Z2gvLCBldmVuIGlmIHRoYXQgd2Fzbid0Cj4+PiB0ZWNobmljYWxseSBpbi1zcGVjLiBBcmQgbm90
ZWQgdGhhdCByZWx5aW5nIG9uIF9DSUQgbGlrZSB0aGF0IGlzCj4+PiB0ZWNobmljYWxseSBhbiBB
Q1BJIHNwZWMgbm90aWZpY2F0aW9uLiBTbyB3ZSdyZSBiZXR3ZWVuIG9uZSBzcGVjIGFuZAo+Pj4g
YW5vdGhlciwgYmFzaWNhbGx5LCBhbmQgZG9pbmcgIlZNR0VOSUQiICsgIlFFTVVWR0lEIiByZXF1
aXJlcyBmZXdlcgo+Pj4gY2hhbmdlcywgYXMgbWVudGlvbmVkLCBhcHBlYXJzIHRvIHdvcmsgZmlu
ZSBpbiBteSB0ZXN0aW5nLgo+Pj4KPj4+IEhvd2V2ZXIsIHdpdGggdGhhdCBzYWlkLCBJIHRoaW5r
IHN1cHBvcnRpbmcgdGhpcyB2aWEgIlZNX0dlbl9Db3VudGVyIgo+Pj4gd291bGQgYmUgYSBiZXR0
ZXIgZXZlbnR1YWwgdGhpbmcgdG8gZG8sIGJ1dCB3aWxsIHJlcXVpcmUgYWNrcyBhbmQKPj4+IGNo
YW5nZXMgZnJvbSB0aGUgQUNQSSBtYWludGFpbmVycy4gRG8geW91IHRoaW5rIHlvdSBjb3VsZCBw
cmVwYXJlIHlvdXIKPj4+IHBhdGNoIHByb3Bvc2FsIGFib3ZlIGFzIHNvbWV0aGluZyBvbi10b3Ag
b2YgbXkgdHJlZSBbMV0/IEFuZCBpZiB5b3UgY2FuCj4+PiBjb252aW5jZSB0aGUgQUNQSSBtYWlu
dGFpbmVycyB0aGF0IHRoYXQncyBva2F5LCB0aGVuIEknbGwgaGFwcGlseSB0YWtlCj4+PiB0aGUg
cGF0Y2guCj4+Cj4+IFN1cmUsIGxldCBtZSBzZW5kIHRoZSBBQ1BJIHBhdGNoIHN0YW5kIGFsb25l
LiBObyBuZWVkIHRvIGluY2x1ZGUgdGhlCj4+IFZNR2VuSUQgY2hhbmdlIGluIHRoZXJlLgo+IFRo
YXQncyBmaW5lLiBJZiB0aGUgQUNQSSBwZW9wbGUgdGFrZSBpdCBmb3IgNS4xOCwgdGhlbiB3ZSBj
YW4gY291bnQgb24KPiBpdCBiZWluZyB0aGVyZSBhbmQgYWRqdXN0IHRoZSB2bWdlbmlkIGRyaXZl
ciBhY2NvcmRpbmdseSBhbHNvIGZvciA1LjE4Lgo+Cj4gSSBqdXN0IGJvb3RlZCB1cCBhIFdpbmRv
d3MgVk0sIGFuZCBpdCBsb29rcyBsaWtlIEh5cGVyLVYgdXNlcwo+ICJIeXBlcl9WX0dlbl9Db3Vu
dGVyX1YxIiwgd2hpY2ggaXMgYWxzbyBxdWl0ZSBsb25nLCBzbyB3ZSBjYW4ndCByZWFsbHkKPiBI
SUQgbWF0Y2ggb24gdGhhdCBlaXRoZXIuCgoKWWVzLCBkdWUgdG8gdGhlIHNhbWUgcHJvYmxlbS4g
SSdkIHJlYWxseSBwcmVmZXIgd2Ugc29ydCBvdXQgdGhlIEFDUEkgCm1hdGNoaW5nIGJlZm9yZSB0
aGlzIGdvZXMgbWFpbmxpbmUuIE1hdGNoaW5nIG9uIF9ISUQgaXMgZXhwbGljaXRseSAKZGlzY291
cmFnZWQgaW4gdGhlIFZNR2VuSUQgc3BlYy4KCgpBbGV4CgoKCgoKQW1hem9uIERldmVsb3BtZW50
IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVm
dHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFn
ZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6
IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

