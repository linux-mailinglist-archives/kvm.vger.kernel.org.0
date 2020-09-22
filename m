Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB762743E1
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 16:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgIVONr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 10:13:47 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:3748 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbgIVONq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Sep 2020 10:13:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600784026; x=1632320026;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=pAEmWYUrYsp8ZVXMmaKubbkOjwluAbcABE2/aAmFiRw=;
  b=ZQN0BTbfr3dEtDjFYXS0bH5mDGSDgu8GziaoLzbpOZrz1Vd+qerccagJ
   hcjufSIyMGfUj21zOwvbbP++//URQbxG3wweewWCVKjhXYa244smUCUu5
   8R6yfG12qvNtemclNzyz4GZJZg2K+5lKxFRpUt5nErNCOlkVeSt6sPYdP
   0=;
X-IronPort-AV: E=Sophos;i="5.77,291,1596499200"; 
   d="scan'208";a="55593369"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 22 Sep 2020 14:13:24 +0000
Received: from EX13D16EUB003.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id 8E858A1E02;
        Tue, 22 Sep 2020 14:13:22 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.237) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 22 Sep 2020 14:13:11 +0000
Subject: Re: [PATCH v9 14/18] nitro_enclaves: Add Kconfig for the Nitro
 Enclaves driver
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        "Karen Noel" <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20200911141141.33296-1-andraprs@amazon.com>
 <20200911141141.33296-15-andraprs@amazon.com>
 <20200914155913.GB3525000@kroah.com>
 <c3a33dcf-794c-31ef-ced5-4f87ba21dd28@amazon.com>
 <d7eaac0d-8855-ca83-6b10-ab4f983805a2@amazon.com>
Message-ID: <358e7470-b841-52fe-0532-e1154ef0e93b@amazon.com>
Date:   Tue, 22 Sep 2020 17:13:02 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <d7eaac0d-8855-ca83-6b10-ab4f983805a2@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.237]
X-ClientProxiedBy: EX13D43UWA002.ant.amazon.com (10.43.160.109) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMS8wOS8yMDIwIDE1OjM0LCBQYXJhc2NoaXYsIEFuZHJhLUlyaW5hIHdyb3RlOgo+Cj4K
PiBPbiAxNC8wOS8yMDIwIDIwOjIzLCBQYXJhc2NoaXYsIEFuZHJhLUlyaW5hIHdyb3RlOgo+Pgo+
Pgo+PiBPbiAxNC8wOS8yMDIwIDE4OjU5LCBHcmVnIEtIIHdyb3RlOgo+Pj4gT24gRnJpLCBTZXAg
MTEsIDIwMjAgYXQgMDU6MTE6MzdQTSArMDMwMCwgQW5kcmEgUGFyYXNjaGl2IHdyb3RlOgo+Pj4+
IFNpZ25lZC1vZmYtYnk6IEFuZHJhIFBhcmFzY2hpdiA8YW5kcmFwcnNAYW1hem9uLmNvbT4KPj4+
PiBSZXZpZXdlZC1ieTogQWxleGFuZGVyIEdyYWYgPGdyYWZAYW1hem9uLmNvbT4KPj4+IEkgY2Fu
J3QgdGFrZSBwYXRjaGVzIHdpdGhvdXQgYW55IGNoYW5nZWxvZyB0ZXh0IGF0IGFsbCwgc29ycnku
Cj4+Pgo+Pj4gU2FtZSBmb3IgYSBmZXcgb3RoZXIgcGF0Y2hlcyBpbiB0aGlzIHNlcmllcyA6KAo+
Pj4KPj4KPj4gSSBjYW4gbW92ZSB0aGUgY2hhbmdlbG9nIHRleHQgYmVmb3JlIHRoZSBTb2IgdGFn
KHMpIGZvciBhbGwgdGhlIAo+PiBwYXRjaGVzLiBJIGFsc28gY2FuIGFkZCBhIHN1bW1hcnkgcGhy
YXNlIGluIHRoZSBjb21taXQgbWVzc2FnZSBmb3IgCj4+IHRoZSBjb21taXRzIGxpa2UgdGhpcyBv
bmUgdGhhdCBoYXZlIG9ubHkgdGhlIGNvbW1pdCB0aXRsZSBhbmQgU29iICYgCj4+IFJiIHRhZ3Mu
Cj4+Cj4+IFdvdWxkIHRoZXNlIHVwZGF0ZXMgdG8gdGhlIGNvbW1pdCBtZXNzYWdlcyBtYXRjaCB0
aGUgZXhwZWN0YXRpb25zPwo+Pgo+PiBMZXQgbWUga25vdyBpZiByZW1haW5pbmcgZmVlZGJhY2sg
dG8gZGlzY3VzcyBhbmQgSSBzaG91bGQgaW5jbHVkZSBhcyAKPj4gdXBkYXRlcyBpbiB2MTAuIE90
aGVyd2lzZSwgSSBjYW4gc2VuZCB0aGUgbmV3IHJldmlzaW9uIHdpdGggdGhlIAo+PiB1cGRhdGVk
IGNvbW1pdCBtZXNzYWdlcy4KPj4KPj4gVGhhbmtzIGZvciByZXZpZXcuCj4KPiBIZXJlIHdlIGdv
LCBJIHB1Ymxpc2hlZCB2MTAsIGluY2x1ZGluZyB0aGUgdXBkYXRlZCBjb21taXQgbWVzc2FnZXMg
YW5kIAo+IHJlYmFzZWQgb24gdG9wIG9mIHY1LjktcmM2Lgo+Cj4gaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvbGttbC8yMDIwMDkyMTEyMTczMi40NDI5MS0xLWFuZHJhcHJzQGFtYXpvbi5jb20vCj4K
PiBBbnkgYWRkaXRpb25hbCBmZWVkYmFjaywgb3BlbiB0byBkaXNjdXNzLgo+Cj4gSWYgYWxsIGxv
b2tzIGdvb2QsIHdlIGNhbiBtb3ZlIGZvcndhcmQgYXMgd2UndmUgdGFsa2VkIGJlZm9yZSwgdG8g
aGF2ZSAKPiB0aGUgcGF0Y2ggc2VyaWVzIG9uIHRoZSBjaGFyLW1pc2MgYnJhbmNoIGFuZCB0YXJn
ZXQgdjUuMTAtcmMxLgoKVGhhbmtzIGZvciBtZXJnaW5nIHRoZSBwYXRjaCBzZXJpZXMgb24gdGhl
IGNoYXItbWlzYy10ZXN0aW5nIGJyYW5jaCBhbmQgCmZvciB0aGUgcmV2aWV3IHNlc3Npb25zIHdl
J3ZlIGhhZC4KCkxldCdzIHNlZSBob3cgYWxsIGdvZXMgbmV4dDsgaWYgYW55dGhpbmcgaW4gdGhl
IG1lYW50aW1lIHRvIGJlIGRvbmUgCihlLmcuIGFuZCBub3QgY29taW5nIHZpYSBhdXRvLWdlbmVy
YXRlZCBtYWlscyksIGp1c3QgbGV0IG1lIGtub3cuCgpBbmRyYQoKCgpBbWF6b24gRGV2ZWxvcG1l
bnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6
YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21h
bmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEv
MjAwNS4K

