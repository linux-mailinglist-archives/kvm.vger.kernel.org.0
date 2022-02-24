Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9DE4C26C8
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 10:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbiBXIyt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 03:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbiBXIys (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 03:54:48 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBB7162020;
        Thu, 24 Feb 2022 00:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1645692858; x=1677228858;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=12QSyjliW/2N5g2pN9oNa13hL2d3UZLmxKY0dS2g+TU=;
  b=YJAmvEtDQPl32GD3t/WiXmXJa+powVBNiHIwcdegAd2CrBFgH2RxVpDM
   mgdcf0UM9ISctIaaU5+lvNMLU7u76DlmKK5nyrnJ8NcLzOybnRPpcqX0j
   ACs5iLKxOZGIuXUE09kebvSEvSKr7xXThQUbcB6pXRSRQjav1CVjjnKLB
   E=;
X-IronPort-AV: E=Sophos;i="5.88,393,1635206400"; 
   d="scan'208";a="176212703"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 24 Feb 2022 08:54:06 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com (Postfix) with ESMTPS id AF91E41634;
        Thu, 24 Feb 2022 08:54:05 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Thu, 24 Feb 2022 08:54:05 +0000
Received: from [0.0.0.0] (10.43.161.89) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.28; Thu, 24 Feb
 2022 08:54:01 +0000
Message-ID: <234d7952-0379-e3d9-5e02-5eba171024a0@amazon.com>
Date:   Thu, 24 Feb 2022 09:53:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH RFC v1 0/2] VM fork detection for RNG
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <adrian@parity.io>
CC:     <dwmw@amazon.co.uk>, <acatan@amazon.com>, <colmmacc@amazon.com>,
        <sblbir@amazon.com>, <raduweis@amazon.com>, <jannh@google.com>,
        <gregkh@linuxfoundation.org>, <tytso@mit.edu>
References: <20220223131231.403386-1-Jason@zx2c4.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <20220223131231.403386-1-Jason@zx2c4.com>
X-Originating-IP: [10.43.161.89]
X-ClientProxiedBy: EX13D47UWA001.ant.amazon.com (10.43.163.6) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGV5IEphc29uLAoKT24gMjMuMDIuMjIgMTQ6MTIsIEphc29uIEEuIERvbmVuZmVsZCB3cm90ZToK
PiBUaGlzIHNtYWxsIHNlcmllcyBwaWNrcyB1cCB3b3JrIGZyb20gQW1hem9uIHRoYXQgc2VlbXMg
dG8gaGF2ZSBzdGFsbGVkCj4gb3V0IGxhdGVyIHllYXIgYXJvdW5kIHRoaXMgdGltZTogbGlzdGVu
aW5nIGZvciB0aGUgdm1nZW5pZCBBQ1BJCj4gbm90aWZpY2F0aW9uLCBhbmQgdXNpbmcgaXQgdG8g
ImRvIHNvbWV0aGluZy4iIExhc3QgeWVhciwgdGhhdCBzb21ldGhpbmcKPiBpbnZvbHZlZCBhIGNv
bXBsaWNhdGVkIHVzZXJzcGFjZSBtbWFwIGNoYXJkZXYsIHdoaWNoIHNlZW1zIGZyb3VnaHQgd2l0
aAo+IGRpZmZpY3VsdHkuIFRoaXMgeWVhciwgSSBoYXZlIHNvbWV0aGluZyBtdWNoIHNpbXBsZXIg
aW4gbWluZDogc2ltcGx5Cj4gdXNpbmcgdGhvc2UgQUNQSSBub3RpZmljYXRpb25zIHRvIHRlbGwg
dGhlIFJORyB0byByZWluaXRpYWxpemUgc2FmZWx5LAo+IHNvIHdlIGRvbid0IHJlcGVhdCByYW5k
b20gbnVtYmVycyBpbiBjbG9uZWQsIGZvcmtlZCwgb3Igcm9sbGVkLWJhY2sgVk0KPiBpbnN0YW5j
ZXMuCj4KPiBUaGlzIHNlcmllcyBjb25zaXN0cyBvZiB0d28gcGF0Y2hlcy4gVGhlIGZpcnN0IGlz
IGEgcmF0aGVyCj4gc3RyYWlnaHRmb3J3YXJkIGFkZGl0aW9uIHRvIHJhbmRvbS5jLCB3aGljaCBJ
IGZlZWwgZmluZSBhYm91dC4gVGhlCj4gc2Vjb25kIHBhdGNoIGlzIHRoZSByZWFzb24gdGhpcyBp
cyBqdXN0IGFuIFJGQzogaXQncyBhIGNsZWFudXAgb2YgdGhlCj4gQUNQSSBkcml2ZXIgZnJvbSBs
YXN0IHllYXIsIGFuZCBJIGRvbid0IHJlYWxseSBoYXZlIG11Y2ggZXhwZXJpZW5jZQo+IHdyaXRp
bmcsIHRlc3RpbmcsIGRlYnVnZ2luZywgb3IgbWFpbnRhaW5pbmcgdGhlc2UgdHlwZXMgb2YgZHJp
dmVycy4KPiBJZGVhbGx5IHRoaXMgdGhyZWFkIHdvdWxkIHlpZWxkIHNvbWVib2R5IHNheWluZywg
Ikkgc2VlIHRoZSBpbnRlbnQgb2YKPiB0aGlzOyBJJ20gaGFwcHkgdG8gdGFrZSBvdmVyIG93bmVy
c2hpcCBvZiB0aGlzIHBhcnQuIiBUaGF0IHdheSwgSSBjYW4KPiBmb2N1cyBvbiB0aGUgUk5HIHBh
cnQsIGFuZCB3aG9ldmVyIHN0ZXBzIHVwIGZvciB0aGUgcGFyYXZpcnQgQUNQSSBwYXJ0Cj4gY2Fu
IGZvY3VzIG9uIHRoYXQuCj4KPiBBcyBhIGZpbmFsIG5vdGUsIHRoaXMgc2VyaWVzIGludGVudGlv
bmFsbHkgZG9lcyBfbm90XyBmb2N1cyBvbgo+IG5vdGlmaWNhdGlvbiBvZiB0aGVzZSBldmVudHMg
dG8gdXNlcnNwYWNlIG9yIHRvIG90aGVyIGtlcm5lbCBjb25zdW1lcnMuCj4gU2luY2UgdGhlc2Ug
Vk0gZm9yayBkZXRlY3Rpb24gZXZlbnRzIGZpcnN0IG5lZWQgdG8gaGl0IHRoZSBSTkcsIHdlIGNh
bgo+IGxhdGVyIHRhbGsgYWJvdXQgd2hhdCBzb3J0cyBvZiBub3RpZmljYXRpb25zIG9yIG1tYXAn
ZCBjb3VudGVycyB0aGUgUk5HCj4gc2hvdWxkIGJlIG1ha2luZyBhY2Nlc3NpYmxlIHRvIGVsc2V3
aGVyZS4gQnV0IHRoYXQncyBhIGRpZmZlcmVudCBzb3J0IG9mCj4gcHJvamVjdCBhbmQgdGllcyBp
bnRvIGEgbG90IG9mIG1vcmUgY29tcGxpY2F0ZWQgY29uY2VybnMgYmV5b25kIHRoaXMKPiBtb3Jl
IGJhc2ljIHBhdGNoc2V0LiBTbyBob3BlZnVsbHkgd2UgY2FuIGtlZXAgdGhlIGRpc2N1c3Npb24g
cmF0aGVyCj4gZm9jdXNlZCBoZXJlIHRvIHRoaXMgQUNQSSBidXNpbmVzcy4KCgpUaGUgbWFpbiBw
cm9ibGVtIHdpdGggVk1HZW5JRCBpcyB0aGF0IGl0IGlzIGluaGVyZW50bHkgcmFjeS4gVGhlcmUg
d2lsbCAKYWx3YXlzIGJlIGEgKHNob3J0KSBhbW91bnQgb2YgdGltZSB3aGVyZSB0aGUgQUNQSSBu
b3RpZmljYXRpb24gaXMgbm90IApwcm9jZXNzZWQsIGJ1dCB0aGUgVk0gY291bGQgdXNlIGl0cyBS
TkcgdG8gZm9yIGV4YW1wbGUgZXN0YWJsaXNoIFRMUyAKY29ubmVjdGlvbnMuCgpIZW5jZSB3ZSBh
cyB0aGUgbmV4dCBzdGVwIHByb3Bvc2VkIGEgbXVsdGktc3RhZ2UgcXVpZXNjZS9yZXN1bWUgCm1l
Y2hhbmlzbSB3aGVyZSB0aGUgc3lzdGVtIGlzIGF3YXJlIHRoYXQgaXQgaXMgZ29pbmcgaW50byBz
dXNwZW5kIC0gY2FuIApibG9jayBuZXR3b3JrIGNvbm5lY3Rpb25zIGZvciBleGFtcGxlIC0gYW5k
IG9ubHkgcmV0dXJucyB0byBhIGZ1bGx5IApmdW5jdGlvbmFsIHN0YXRlIGFmdGVyIGFuIHVucXVp
ZXNjZSBwaGFzZToKCiDCoCBodHRwczovL2dpdGh1Yi5jb20vc3lzdGVtZC9zeXN0ZW1kL2lzc3Vl
cy8yMDIyMgoKTG9va2luZyBhdCB0aGUgaXNzdWUgYWdhaW4sIGl0IHNlZW1zIGxpa2Ugd2UgY29t
cGxldGVseSBtaXNzZWQgdG8gZm9sbG93IAp1cCB3aXRoIGEgUFIgdG8gaW1wbGVtZW50IHRoYXQg
ZnVuY3Rpb25hbGl0eSA6KC4KCldoYXQgZXhhY3QgdXNlIGNhc2UgZG8geW91IGhhdmUgaW4gbWlu
ZCBmb3IgdGhlIFJORy9WTUdlbklEIHVwZGF0ZT8gQ2FuIAp5b3UgdGhpbmsgb2Ygc2l0dWF0aW9u
cyB3aGVyZSB0aGUgcmFjZSBpcyBub3QgYW4gYWN0dWFsIGNvbmNlcm4/CgoKQWxleAoKCj4KPiBD
YzogZHdtd0BhbWF6b24uY28udWsKPiBDYzogYWNhdGFuQGFtYXpvbi5jb20KPiBDYzogZ3JhZkBh
bWF6b24uY29tCj4gQ2M6IGNvbG1tYWNjQGFtYXpvbi5jb20KPiBDYzogc2JsYmlyQGFtYXpvbi5j
b20KPiBDYzogcmFkdXdlaXNAYW1hem9uLmNvbQo+IENjOiBqYW5uaEBnb29nbGUuY29tCj4gQ2M6
IGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnCj4gQ2M6IHR5dHNvQG1pdC5lZHUKPgo+IEphc29u
IEEuIERvbmVuZmVsZCAoMik6Cj4gICAgcmFuZG9tOiBhZGQgbWVjaGFuaXNtIGZvciBWTSBmb3Jr
cyB0byByZWluaXRpYWxpemUgY3JuZwo+ICAgIGRyaXZlcnMvdmlydDogYWRkIHZtZ2VuaWQgZHJp
dmVyIGZvciByZWluaXRpYWxpemluZyBSTkcKPgo+ICAgZHJpdmVycy9jaGFyL3JhbmRvbS5jICB8
ICA1OCArKysrKysrKysrKysrKysrKysKPiAgIGRyaXZlcnMvdmlydC9LY29uZmlnICAgfCAgIDgg
KysrCj4gICBkcml2ZXJzL3ZpcnQvTWFrZWZpbGUgIHwgICAxICsKPiAgIGRyaXZlcnMvdmlydC92
bWdlbmlkLmMgfCAxMzMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysK
PiAgIGluY2x1ZGUvbGludXgvcmFuZG9tLmggfCAgIDEgKwo+ICAgNSBmaWxlcyBjaGFuZ2VkLCAy
MDEgaW5zZXJ0aW9ucygrKQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvdmlydC92bWdl
bmlkLmMKPgo+IC0tCj4gMi4zNS4xCj4KCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJt
YW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzog
Q2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dl
cmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3Qt
SUQ6IERFIDI4OSAyMzcgODc5CgoK

