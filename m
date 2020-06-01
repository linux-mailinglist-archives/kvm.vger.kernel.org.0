Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD88F1E9EDD
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 09:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgFAHHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 03:07:32 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:23392 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgFAHHa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 03:07:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590995249; x=1622531249;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Pse7FjT1oSM7k6+12m27jATLc53uuNLdEozAkVeDTn0=;
  b=mJdtsJ1rnhFIp68TI3RZpZx3G+funKyFaVjfq6Kd99St2+MURUUn92WC
   NrPHlqw3TqPGdbXWsATfVwc0JLm+jlMX93292+XVkk0yi6feCKrklS1cr
   46iQOi2A2SclbhC/IGHFJM2uTuRqntcSJFNE97qcCAL8LHmB2Xu0H0ak/
   w=;
IronPort-SDR: a2WV03LKoD4vqdEmaIJRDRVZLOgNnbMLs0A7Da1b7yWqMRSHvwswB8nDGlrpkRI9IWGorfUkOP
 bNukS5fZ9czA==
X-IronPort-AV: E=Sophos;i="5.73,459,1583193600"; 
   d="scan'208";a="48575926"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 01 Jun 2020 07:07:26 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id 3D6ACA1E65;
        Mon,  1 Jun 2020 07:07:25 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Jun 2020 07:07:24 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.53) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Jun 2020 07:07:16 +0000
Subject: Re: [PATCH v3 02/18] nitro_enclaves: Define the PCI device interface
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-3-andraprs@amazon.com>
 <20200526064455.GA2580530@kroah.com>
 <bd25183c-3b2d-7671-f699-78988a39a633@amazon.com>
 <20200526222109.GB179549@kroah.com>
 <ea25810cbd43974b75934f9cfb6ca3f007339dce.camel@kernel.crashing.org>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <1fbdc33c-8819-40b6-b0d3-5d64833c9932@amazon.com>
Date:   Mon, 1 Jun 2020 10:07:11 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <ea25810cbd43974b75934f9cfb6ca3f007339dce.camel@kernel.crashing.org>
Content-Language: en-US
X-Originating-IP: [10.43.162.53]
X-ClientProxiedBy: EX13D20UWC002.ant.amazon.com (10.43.162.163) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwMS8wNi8yMDIwIDA1OjU5LCBCZW5qYW1pbiBIZXJyZW5zY2htaWR0IHdyb3RlOgo+IE9u
IFdlZCwgMjAyMC0wNS0yNyBhdCAwMDoyMSArMDIwMCwgR3JlZyBLSCB3cm90ZToKPj4+IFRoZXJl
IGFyZSBhIGNvdXBsZSBvZiBkYXRhIHN0cnVjdHVyZXMgd2l0aCBtb3JlIHRoYW4gb25lIG1lbWJl
ciBhbmQgbXVsdGlwbGUKPj4+IGZpZWxkIHNpemVzLiBBbmQgZm9yIHRoZSBvbmVzIHRoYXQgYXJl
IG5vdCwgZ2F0aGVyZWQgYXMgZmVlZGJhY2sgZnJvbQo+Pj4gcHJldmlvdXMgcm91bmRzIG9mIHJl
dmlldyB0aGF0IHNob3VsZCBjb25zaWRlciBhZGRpbmcgYSAiZmxhZ3MiIGZpZWxkIGluCj4+PiB0
aGVyZSBmb3IgZnVydGhlciBleHRlbnNpYmlsaXR5Lgo+PiBQbGVhc2UgZG8gbm90IGRvIHRoYXQg
aW4gaW9jdGxzLiAgSnVzdCBjcmVhdGUgbmV3IGNhbGxzIGluc3RlYWQgb2YKPj4gdHJ5aW5nIHRv
ICJleHRlbmQiIGV4aXN0aW5nIG9uZXMuICBJdCdzIGFsd2F5cyBtdWNoIGVhc2llci4KPj4KPj4+
IEkgY2FuIG1vZGlmeSB0byBoYXZlICJfX3BhY2tlZCIgaW5zdGVhZCBvZiB0aGUgYXR0cmlidXRl
IGNhbGxvdXQuCj4+IE1ha2Ugc3VyZSB5b3UgZXZlbiBuZWVkIHRoYXQsIGFzIEkgZG9uJ3QgdGhp
bmsgeW91IGRvIGZvciBzdHJ1Y3R1cmVzCj4+IGxpa2UgdGhlIGFib3ZlIG9uZSwgcmlnaHQ/Cj4g
SHJtLCBteSBpbXByZXNzaW9uIChncmFudGVkIEkgb25seSBqdXN0IHN0YXJ0ZWQgdG8gbG9vayBh
dCB0aGlzIGNvZGUpCj4gaXMgdGhhdCB0aGVzZSBhcmUgcHJvdG9jb2wgbWVzc2FnZXMgd2l0aCB0
aGUgUENJIGRldmljZXMsIG5vdCBzdHJpY3RseQo+IGp1c3QgaW9jdGwgYXJndW1lbnRzICh0aG91
Z2ggdGhleSBkbyBnZXQgY29udmV5ZWQgdmlhIHN1Y2ggaW9jdGxzKS4KPgo+IEFuZHJhLUlyaW5h
LCBkaWQgSSBnZXQgdGhhdCByaWdodCA/IDotKQoKQ29ycmVjdCwgdGhlc2UgZGF0YSBzdHJ1Y3R1
cmVzIGhhdmluZyAiX19wYWNrZWQiIGF0dHJpYnV0ZSBtYXAgdGhlIAptZXNzYWdlcyAocmVxdWVz
dHMgLyByZXBsaWVzKSBmb3IgdGhlIGNvbW11bmljYXRpb24gd2l0aCB0aGUgTkUgUENJIGRldmlj
ZS4KClRoZSBkYXRhIHN0cnVjdHVyZXMgZnJvbSB0aGUgaW9jdGwgY29tbWFuZHMgYXJlIG5vdCBk
aXJlY3RseSB1c2VkIGFzIApwYXJ0IG9mIHRoZSBjb21tdW5pY2F0aW9uIHdpdGggdGhlIE5FIFBD
SSBkZXZpY2UsIGJ1dCBzZXZlcmFsIGZpZWxkcyBvZiAKdGhlbSBlLmcuIGVuY2xhdmUgc3RhcnQg
ZmxhZ3MuIFNvbWUgb2YgdGhlIGZpZWxkcyBmcm9tIHRoZSBORSBQQ0kgZGV2aWNlIApkYXRhIHN0
cnVjdHVyZXMgZS5nLiB0aGUgcGh5c2ljYWwgYWRkcmVzcyBvZiBhIG1lbW9yeSByZWdpb24gKGdw
YSkgYXJlIApzZXQgYnkgdGhlIGludGVybmFsIGtlcm5lbCBsb2dpYy4KCj4KPiBUaGF0IHNhaWQs
IEkgc3RpbGwgdGhpbmsgdGhhdCBieSBjYXJlZnVsbHkgb3JkZXJpbmcgdGhlIGZpZWxkcyBhbmQK
PiB1c2luZyBleHBsaWNpdCBwYWRkaW5nLCB3ZSBjYW4gYXZvaWQgdGhlIG5lZWQgb2YgdGhlIHBh
Y2tlZCBhdHRyaWJ1dGVkLgoKUmVnYXJkaW5nIHlvdXIgcXVlc3Rpb24gaW4gdGhlIHByZXZpb3Vz
IG1haWwgZnJvbSB0aGlzIHRocmVhZCBhbmQgdGhlIAptZW50aW9uIGFib3ZlIG9uIHRoZSBzYW1l
IHRvcGljLCB0aGF0IHNob3VsZCBiZSBwb3NzaWJsZS4gSUlSQywgdGhlcmUgCndlcmUgMiBkYXRh
IHN0cnVjdHVyZXMgcmVtYWluaW5nIHdpdGggIl9fcGFja2VkIiBhdHRyaWJ1dGUuCgpUaGFuayB5
b3UsIEJlbi4KCkFuZHJhCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMu
Ui5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29y
IDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9t
YW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=

