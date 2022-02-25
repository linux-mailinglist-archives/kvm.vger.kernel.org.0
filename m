Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FB24C487D
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238101AbiBYPQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbiBYPQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:16:54 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813A4190B7B;
        Fri, 25 Feb 2022 07:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1645802182; x=1677338182;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0PWWQRRW37Y5DwUGjnUw/eZVXUeKiUeIEpdoKzm1SBw=;
  b=pHd/oS/XXA1nLBhOBXcgqJ+e65HLf3EHi1e/4VYoDCVAzLQ/qyt9HnQ1
   dfTkH5LoROTF2QYHLJ1oQI3WSf+QUR/DJr8XsWPfOel9JRM2V3Yg9zT0f
   TegnbQiNuGvYTVME1Am1REpBXhf9NpVqfuGHNm3SBN0uTrCQmKSsL1iak
   E=;
X-IronPort-AV: E=Sophos;i="5.90,136,1643673600"; 
   d="scan'208";a="66224508"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 25 Feb 2022 15:16:10 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com (Postfix) with ESMTPS id 6D47CC0326;
        Fri, 25 Feb 2022 15:16:08 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Fri, 25 Feb 2022 15:16:08 +0000
Received: from [0.0.0.0] (10.43.160.150) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.28; Fri, 25 Feb
 2022 15:16:02 +0000
Message-ID: <b3b9dd9b-c42c-f057-f546-3e390b50479f@amazon.com>
Date:   Fri, 25 Feb 2022 16:15:59 +0100
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
 <YhjttNadaaJzVa5X@zx2c4.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <YhjttNadaaJzVa5X@zx2c4.com>
X-Originating-IP: [10.43.160.150]
X-ClientProxiedBy: EX13D10UWA002.ant.amazon.com (10.43.160.228) To
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

Ck9uIDI1LjAyLjIyIDE1OjU0LCBKYXNvbiBBLiBEb25lbmZlbGQgd3JvdGU6Cj4gSGkgQWxleCwK
Pgo+IE1pc3NlZCB0aGlzIHJlbWFyayBiZWZvcmU6Cj4KPiBPbiBGcmksIEZlYiAyNSwgMjAyMiBh
dCAwMjo1NzozOFBNICswMTAwLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPj4gUGxlYXNlIGV4cG9z
ZSB0aGUgdm1nZW5pZCB2aWEgL3N5c2ZzIHNvIHRoYXQgdXNlciBzcGFjZSBldmVuIHJlbW90ZWx5
Cj4+IGhhcyBhIGNoYW5jZSB0byBjaGVjayBpZiBpdCdzIGJlZW4gY2xvbmVkLgo+IE5vLiBEaWQg
eW91IHJlYWQgdGhlIDAvMiBjb3ZlciBsZXR0ZXI/IEknbGwgcXVvdGUgaXQgZm9yIHlvdSBoZXJl
Ogo+Cj4+IEFzIGEgc2lkZSBub3RlLCB0aGlzIHNlcmllcyBpbnRlbnRpb25hbGx5IGRvZXMgX25v
dF8gZm9jdXMgb24KPj4gbm90aWZpY2F0aW9uIG9mIHRoZXNlIGV2ZW50cyB0byB1c2Vyc3BhY2Ug
b3IgdG8gb3RoZXIga2VybmVsIGNvbnN1bWVycy4KPj4gU2luY2UgdGhlc2UgVk0gZm9yayBkZXRl
Y3Rpb24gZXZlbnRzIGZpcnN0IG5lZWQgdG8gaGl0IHRoZSBSTkcsIHdlIGNhbgo+PiBsYXRlciB0
YWxrIGFib3V0IHdoYXQgc29ydHMgb2Ygbm90aWZpY2F0aW9ucyBvciBtbWFwJ2QgY291bnRlcnMg
dGhlIFJORwo+PiBzaG91bGQgYmUgbWFraW5nIGFjY2Vzc2libGUgdG8gZWxzZXdoZXJlLiBCdXQg
dGhhdCdzIGEgZGlmZmVyZW50IHNvcnQgb2YKPj4gcHJvamVjdCBhbmQgdGllcyBpbnRvIGEgbG90
IG9mIG1vcmUgY29tcGxpY2F0ZWQgY29uY2VybnMgYmV5b25kIHRoaXMKPj4gbW9yZSBiYXNpYyBw
YXRjaHNldC4gU28gaG9wZWZ1bGx5IHdlIGNhbiBrZWVwIHRoZSBkaXNjdXNzaW9uIHJhdGhlcgo+
PiBmb2N1c2VkIGhlcmUgdG8gdGhpcyBBQ1BJIGJ1c2luZXNzLgo+IFdoYXQgYWJvdXQgdGhhdCB3
YXMgdW5jbGVhciB0byB5b3U/Cj4KPiBBbnl3YXksIGl0J3MgYSBkaWZmZXJlbnQgdGhpbmcgdGhh
dCB3aWxsIGhhdmUgdG8gYmUgZGVzaWduZWQgYW5kCj4gY29uc2lkZXJlZCBjYXJlZnVsbHksIGFu
ZCB0aGF0IGRlc2lnbiBkb2Vzbid0IGhhdmUgYSB3aG9sZSBsb3QgdG8gZG8KPiB3aXRoIHRoaXMg
bGl0dGxlIGRyaXZlciBoZXJlLCBleGNlcHQgaW5zb2ZhciBhcyBpdCBjb3VsZCBidWlsZCBvbiB0
b3Agb2YKPiBpdCBpbiBvbmUgd2F5IG9yIGFub3RoZXIuIFllcywgaXQncyBhbiBpbXBvcnRhbnQg
dGhpbmcgdG8gZG8uIE5vLCBJJ20KPiBub3QgZ29pbmcgdG8gZG8gaXQgaW4gdGhpcyBwYXRjaCBo
ZXJlLiBJZiB5b3Ugd2FudCB0byBoYXZlIGEgZGlzY3Vzc2lvbgo+IGFib3V0IHRoYXQsIHN0YXJ0
IGEgZGlmZmVyZW50IHRocmVhZC4KCgpJJ20gbm90IHRhbGtpbmcgYWJvdXQgYSBub3RpZmljYXRp
b24gaW50ZXJmYWNlIC0gd2UndmUgZ29uZSB0aHJvdWdoIApncmVhdCBsZW5ndGggb24gdGhhdCBv
bmUgaW4gdGhlIHByZXZpb3VzIHN1Ym1pc3Npb24uIFdoYXQgSSdtIG1vcmUgCmludGVyZXN0ZWQg
aW4gaXMgKmFueSogd2F5IGZvciB1c2VyIHNwYWNlIHRvIHJlYWQgdGhlIGN1cnJlbnQgVk0gR2Vu
IElELiAKVGhlIHNhbWUgd2F5IEknbSBpbnRlcmVzdGVkIHRvIHNlZSBvdGhlciBkZXZpY2UgYXR0
cmlidXRlcyBvZiBteSBzeXN0ZW0gCnRocm91Z2ggc3lzZnMuCgoKQWxleAoKCgoKCkFtYXpvbiBE
ZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxp
bgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNz
CkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkx
NzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

