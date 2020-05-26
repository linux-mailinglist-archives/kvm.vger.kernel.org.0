Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9CA1E1D14
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 10:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731228AbgEZIR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 04:17:58 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:6767 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgEZIR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 04:17:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590481076; x=1622017076;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=YuHwdN8HqSyt2rwlrNv4QewZD9qbjngQahz+l0HDz1U=;
  b=pzWZOeYx0tFeZO+kfYlaWI6UJNrhBfUb34vzIDXxWt1QwTuh5MWKrZSv
   cuNL8v68TtO/TpyTEASMYQzqvOjtPFcNVId+z3c8vUz1RMzA5GrLtyfvX
   kxONLvfgdlmHTOHHYwC7hzY13eos5cC4EPco4iHs/11fVVvkrNSuXDoa7
   4=;
IronPort-SDR: YEJC/bEhVyt+dqxhDujvHJzh0YafG1QvIz3nMyXnoKJvII3+YlbO87+LK9KEyaPG5MC3ywvXay
 69bTv0HtyLSg==
X-IronPort-AV: E=Sophos;i="5.73,436,1583193600"; 
   d="scan'208";a="37619369"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 26 May 2020 08:17:54 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 283CBA18BE;
        Tue, 26 May 2020 08:17:53 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 26 May 2020 08:17:52 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 26 May 2020 08:17:43 +0000
Subject: Re: [PATCH v2 07/18] nitro_enclaves: Init misc device providing the
 ioctl interface
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        "Alexander Graf" <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
 <20200522062946.28973-8-andraprs@amazon.com>
 <20200522070708.GC771317@kroah.com>
 <fa3a72ef-ba0a-ada9-48bf-bd7cef0a8174@amazon.com>
 <20200526064243.GB2580410@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <e4d48349-ff54-77e3-8a87-8f320d702d7f@amazon.com>
Date:   Tue, 26 May 2020 11:17:38 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526064243.GB2580410@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D37UWC001.ant.amazon.com (10.43.162.33) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNi8wNS8yMDIwIDA5OjQyLCBHcmVnIEtIIHdyb3RlOgo+IE9uIE1vbiwgTWF5IDI1LCAy
MDIwIGF0IDExOjQ5OjUwUE0gKzAzMDAsIFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEgd3JvdGU6Cj4+
Cj4+IE9uIDIyLzA1LzIwMjAgMTA6MDcsIEdyZWcgS0ggd3JvdGU6Cj4+PiBPbiBGcmksIE1heSAy
MiwgMjAyMCBhdCAwOToyOTozNUFNICswMzAwLCBBbmRyYSBQYXJhc2NoaXYgd3JvdGU6Cj4+Pj4g
K3N0YXRpYyBjaGFyICpuZV9jcHVzOwo+Pj4+ICttb2R1bGVfcGFyYW0obmVfY3B1cywgY2hhcnAs
IDA2NDQpOwo+Pj4+ICtNT0RVTEVfUEFSTV9ERVNDKG5lX2NwdXMsICI8Y3B1LWxpc3Q+IC0gQ1BV
IHBvb2wgdXNlZCBmb3IgTml0cm8gRW5jbGF2ZXMiKTsKPj4+IFRoaXMgaXMgbm90IHRoZSAxOTkw
J3MsIGRvbid0IHVzZSBtb2R1bGUgcGFyYW1ldGVycyBpZiB5b3UgY2FuIGhlbHAgaXQuCj4+PiBX
aHkgaXMgdGhpcyBuZWVkZWQsIGFuZCB3aGVyZSBpcyBpdCBkb2N1bWVudGVkPwo+PiBUaGlzIGlz
IGEgQ1BVIHBvb2wgdGhhdCBjYW4gYmUgc2V0IGJ5IHRoZSByb290IHVzZXIgYW5kIHRoYXQgaW5j
bHVkZXMgQ1BVcwo+PiBzZXQgYXNpZGUgdG8gYmUgdXNlZCBmb3IgdGhlIGVuY2xhdmUocykgc2V0
dXA7IHRoZXNlIENQVXMgYXJlIG9mZmxpbmVkLiBGcm9tCj4+IHRoaXMgQ1BVIHBvb2wsIHRoZSBr
ZXJuZWwgbG9naWMgY2hvb3NlcyB0aGUgQ1BVcyB0aGF0IGFyZSBzZXQgZm9yIHRoZQo+PiBjcmVh
dGVkIGVuY2xhdmUocykuCj4+Cj4+IFRoZSBjcHUtbGlzdCBmb3JtYXQgaXMgbWF0Y2hpbmcgdGhl
IHNhbWUgdGhhdCBpcyBkb2N1bWVudGVkIGhlcmU6Cj4+Cj4+IGh0dHBzOi8vd3d3Lmtlcm5lbC5v
cmcvZG9jL2h0bWwvbGF0ZXN0L2FkbWluLWd1aWRlL2tlcm5lbC1wYXJhbWV0ZXJzLmh0bWwKPj4K
Pj4gSSd2ZSBhbHNvIHRob3VnaHQgb2YgaGF2aW5nIGEgc3lzZnMgZW50cnkgZm9yIHRoZSBzZXR1
cCBvZiB0aGlzIGVuY2xhdmUgQ1BVCj4+IHBvb2wuCj4gT2ssIGJ1dCBhZ2FpbiwgZG8gbm90IHVz
ZSBhIG1vZHVsZSBwYXJhbWV0ZXIsIHRoZXkgYXJlIGhhcmQgdG8gdXNlLAo+IHRvdWdoIHRvIGRv
Y3VtZW50LCBhbmQgZ2xvYmFsLiAgQWxsIHRoaW5ncyB3ZSBtb3ZlZCBhd2F5IGZyb20gYSBsb25n
Cj4gdGltZSBhZ28uICBQbGVhc2UgdXNlIHNvbWV0aGluZyBlbHNlIGZvciB0aGlzIChzeXNmcywg
Y29uZmlnZnMsIGV0Yy4pCj4gaW5zdGVhZC4KCkFscmlnaHQsIGdvdCBpdCwgd2lsbCBtb3ZlIG9u
IHRoZW4gd2l0aCB0aGUgb3RoZXIgb3B0aW9uIGZvciB2NC4KClRoYW5rIHlvdS4KCkFuZHJhCgoK
CgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBv
ZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENv
dW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlv
biBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

