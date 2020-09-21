Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E072723F5
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 14:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgIUMfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 08:35:05 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:56257 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbgIUMfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 08:35:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600691705; x=1632227705;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=gHfYWT1W0eJsNXh4Wew1VUBI0Xi0QLDn7U0CWOl1tkw=;
  b=T62XZGcAZ8BJzV3gZXGnSWm+YwTt/qDCzQWN5hFB7EI/eW223JKctKch
   VAeIBY6K3Sf7fa/LSAltPOtIBDBf1UlRU6t/GAt9c9HvfU3bMPpvH+uk1
   VhH9f31D2vVY7zu7IWMlU/OEwPMD6Yw2kHA+qufJ2kUexKCt5sMAJX2gB
   Q=;
X-IronPort-AV: E=Sophos;i="5.77,286,1596499200"; 
   d="scan'208";a="55278324"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 21 Sep 2020 12:34:31 +0000
Received: from EX13D16EUB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id E0D32A06AF;
        Mon, 21 Sep 2020 12:34:29 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.145) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 21 Sep 2020 12:34:18 +0000
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
Message-ID: <d7eaac0d-8855-ca83-6b10-ab4f983805a2@amazon.com>
Date:   Mon, 21 Sep 2020 15:34:09 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <c3a33dcf-794c-31ef-ced5-4f87ba21dd28@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D25UWC001.ant.amazon.com (10.43.162.44) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxNC8wOS8yMDIwIDIwOjIzLCBQYXJhc2NoaXYsIEFuZHJhLUlyaW5hIHdyb3RlOgo+Cj4K
PiBPbiAxNC8wOS8yMDIwIDE4OjU5LCBHcmVnIEtIIHdyb3RlOgo+PiBPbiBGcmksIFNlcCAxMSwg
MjAyMCBhdCAwNToxMTozN1BNICswMzAwLCBBbmRyYSBQYXJhc2NoaXYgd3JvdGU6Cj4+PiBTaWdu
ZWQtb2ZmLWJ5OiBBbmRyYSBQYXJhc2NoaXYgPGFuZHJhcHJzQGFtYXpvbi5jb20+Cj4+PiBSZXZp
ZXdlZC1ieTogQWxleGFuZGVyIEdyYWYgPGdyYWZAYW1hem9uLmNvbT4KPj4gSSBjYW4ndCB0YWtl
IHBhdGNoZXMgd2l0aG91dCBhbnkgY2hhbmdlbG9nIHRleHQgYXQgYWxsLCBzb3JyeS4KPj4KPj4g
U2FtZSBmb3IgYSBmZXcgb3RoZXIgcGF0Y2hlcyBpbiB0aGlzIHNlcmllcyA6KAo+Pgo+Cj4gSSBj
YW4gbW92ZSB0aGUgY2hhbmdlbG9nIHRleHQgYmVmb3JlIHRoZSBTb2IgdGFnKHMpIGZvciBhbGwg
dGhlIAo+IHBhdGNoZXMuIEkgYWxzbyBjYW4gYWRkIGEgc3VtbWFyeSBwaHJhc2UgaW4gdGhlIGNv
bW1pdCBtZXNzYWdlIGZvciB0aGUgCj4gY29tbWl0cyBsaWtlIHRoaXMgb25lIHRoYXQgaGF2ZSBv
bmx5IHRoZSBjb21taXQgdGl0bGUgYW5kIFNvYiAmIFJiIHRhZ3MuCj4KPiBXb3VsZCB0aGVzZSB1
cGRhdGVzIHRvIHRoZSBjb21taXQgbWVzc2FnZXMgbWF0Y2ggdGhlIGV4cGVjdGF0aW9ucz8KPgo+
IExldCBtZSBrbm93IGlmIHJlbWFpbmluZyBmZWVkYmFjayB0byBkaXNjdXNzIGFuZCBJIHNob3Vs
ZCBpbmNsdWRlIGFzIAo+IHVwZGF0ZXMgaW4gdjEwLiBPdGhlcndpc2UsIEkgY2FuIHNlbmQgdGhl
IG5ldyByZXZpc2lvbiB3aXRoIHRoZSAKPiB1cGRhdGVkIGNvbW1pdCBtZXNzYWdlcy4KPgo+IFRo
YW5rcyBmb3IgcmV2aWV3LgoKSGVyZSB3ZSBnbywgSSBwdWJsaXNoZWQgdjEwLCBpbmNsdWRpbmcg
dGhlIHVwZGF0ZWQgY29tbWl0IG1lc3NhZ2VzIGFuZCAKcmViYXNlZCBvbiB0b3Agb2YgdjUuOS1y
YzYuCgpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzIwMjAwOTIxMTIxNzMyLjQ0MjkxLTEt
YW5kcmFwcnNAYW1hem9uLmNvbS8KCkFueSBhZGRpdGlvbmFsIGZlZWRiYWNrLCBvcGVuIHRvIGRp
c2N1c3MuCgpJZiBhbGwgbG9va3MgZ29vZCwgd2UgY2FuIG1vdmUgZm9yd2FyZCBhcyB3ZSd2ZSB0
YWxrZWQgYmVmb3JlLCB0byBoYXZlIAp0aGUgcGF0Y2ggc2VyaWVzIG9uIHRoZSBjaGFyLW1pc2Mg
YnJhbmNoIGFuZCB0YXJnZXQgdjUuMTAtcmMxLgoKVGhhbmtzLApBbmRyYQoKCgpBbWF6b24gRGV2
ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBT
Zi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1
LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIy
LzI2MjEvMjAwNS4K

