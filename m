Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24611DE1B7
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 10:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbgEVIVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 04:21:02 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:29413 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728976AbgEVIVB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 04:21:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590135661; x=1621671661;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=LWu6AqypUnxnEO7+yo7F6s9apxZuEsZjVsJR8ns2boc=;
  b=N0ytCQTlcVTHflQOtvMzmqs3mCoO3ndirLHWcWipIFCebMoiXG70l/2m
   jAu+r45XQ7WrpntgD5PPtSmFRVWxNFNpFXqrbEXtZIRr1ntZW+KGe8znI
   zYvt+PhIyvnoeZMJr8mgcEEczcMQ+Q6FYf7BvNHiHYnSXrEsZIJrQRs/Z
   g=;
IronPort-SDR: d+GIndiAjtTYBqBbiFIYH6KqsOmMn/3NmsdYWLx39MLy7UEpIKRzK4YGhWoCo7TcdUmqF21o6a
 4EXKGWGETOGg==
X-IronPort-AV: E=Sophos;i="5.73,420,1583193600"; 
   d="scan'208";a="31787155"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 22 May 2020 08:21:00 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id B0E1CA17B7;
        Fri, 22 May 2020 08:20:58 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 08:20:58 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.175) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 08:20:49 +0000
Subject: Re: [PATCH v2 18/18] MAINTAINERS: Add entry for the Nitro Enclaves
 driver
To:     Joe Perches <joe@perches.com>, <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
 <20200522062946.28973-19-andraprs@amazon.com>
 <e4847d1f25a1fd29ea3f8f8930ba5ae5ccc41f30.camel@perches.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <52fcc55d-4007-03e1-2af0-c4d8dd210b22@amazon.com>
Date:   Fri, 22 May 2020 11:20:45 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <e4847d1f25a1fd29ea3f8f8930ba5ae5ccc41f30.camel@perches.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.175]
X-ClientProxiedBy: EX13D03UWC002.ant.amazon.com (10.43.162.160) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMi8wNS8yMDIwIDEwOjAzLCBKb2UgUGVyY2hlcyB3cm90ZToKPiBPbiBGcmksIDIwMjAt
MDUtMjIgYXQgMDk6MjkgKzAzMDAsIEFuZHJhIFBhcmFzY2hpdiB3cm90ZToKPgo+IHRyaXZpYToK
Pgo+PiBkaWZmIC0tZ2l0IGEvTUFJTlRBSU5FUlMgYi9NQUlOVEFJTkVSUwo+IFtdCj4+IEBAIC0x
MTk1Niw2ICsxMTk1NiwxOSBAQCBTOglNYWludGFpbmVkCj4+ICAgVDoJZ2l0IGdpdDovL2dpdC5r
ZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9sZnRhbi9uaW9zMi5naXQKPj4gICBG
OglhcmNoL25pb3MyLwo+PiAgIAo+PiArTklUUk8gRU5DTEFWRVMgKE5FKQo+PiArTToJQW5kcmEg
UGFyYXNjaGl2IDxhbmRyYXByc0BhbWF6b24uY29tPgo+PiArTToJQWxleGFuZHJ1IFZhc2lsZSA8
bGV4bnZAYW1hem9uLmNvbT4KPj4gK006CUFsZXhhbmRydSBDaW9ib3RhcnUgPGFsY2lvYUBhbWF6
b24uY29tPgo+PiArTDoJbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZwo+PiArUzoJU3VwcG9y
dGVkCj4+ICtXOglodHRwczovL2F3cy5hbWF6b24uY29tL2VjMi9uaXRyby9uaXRyby1lbmNsYXZl
cy8KPj4gK0Y6CWluY2x1ZGUvbGludXgvbml0cm9fZW5jbGF2ZXMuaAo+PiArRjoJaW5jbHVkZS91
YXBpL2xpbnV4L25pdHJvX2VuY2xhdmVzLmgKPj4gK0Y6CWRyaXZlcnMvdmlydC9uaXRyb19lbmNs
YXZlcy8KPj4gK0Y6CXNhbXBsZXMvbml0cm9fZW5jbGF2ZXMvCj4+ICtGOglEb2N1bWVudGF0aW9u
L25pdHJvX2VuY2xhdmVzLwo+IFBsZWFzZSBrZWVwIHRoZSBGOiBlbnRyaWVzIGluIGNhc2Ugc2Vu
c2l0aXZlIGFscGhhYmV0aWMgb3JkZXIKPgo+IEY6CURvY3VtZW50YXRpb24vbml0cm9fZW5jbGF2
ZXMvCj4gRjoJZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzLwo+IEY6CWluY2x1ZGUvbGludXgv
bml0cm9fZW5jbGF2ZXMuaAo+IEY6CWluY2x1ZGUvdWFwaS9saW51eC9uaXRyb19lbmNsYXZlcy5o
Cj4gRjoJc2FtcGxlcy9uaXRyb19lbmNsYXZlcy8KCkRvbmUsIEkgdXBkYXRlZCB0aGUgZW50cnkg
aW4gdjMuCgpUaGFuayB5b3UsIEpvZS4KCkFuZHJhCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50
ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBTdHJl
ZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJl
Z2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=

