Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C9A260252
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 19:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbgIGRXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 13:23:13 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:19770 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729514AbgIGNnS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 09:43:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599486198; x=1631022198;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=6VQbLOy77M7fAKsGR2G82WO7fDDbNA8p2pbqM8zfSyk=;
  b=TtAf3lFuBU4twdxeJ4WUdiF5hITcEfoTPjkkl9dXcauTowW9w5iJxNH+
   qXUOkrY+TRDAZOnSi4L5qZ15LQ7qJuQLzzrHvf8VqmvHHKlWVRer3WdE0
   AeX5rOtfBkuW3LLYxvvA6fSpkZ/MdmAq5TiSB/BhhtPTzvVyz2QGIF8XK
   E=;
X-IronPort-AV: E=Sophos;i="5.76,401,1592870400"; 
   d="scan'208";a="74201643"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 07 Sep 2020 13:35:42 +0000
Received: from EX13D16EUB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id 8709E1A067C;
        Mon,  7 Sep 2020 13:35:39 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.38) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Sep 2020 13:35:28 +0000
Subject: Re: [PATCH v8 15/18] nitro_enclaves: Add Makefile for the Nitro
 Enclaves driver
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
References: <20200904173718.64857-1-andraprs@amazon.com>
 <20200904173718.64857-16-andraprs@amazon.com>
 <20200907090011.GC1101646@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <f5c0f79c-f581-fab5-9a3b-97380ef7fc2a@amazon.com>
Date:   Mon, 7 Sep 2020 16:35:23 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200907090011.GC1101646@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.38]
X-ClientProxiedBy: EX13D20UWA001.ant.amazon.com (10.43.160.34) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNy8wOS8yMDIwIDEyOjAwLCBHcmVnIEtIIHdyb3RlOgo+Cj4KPiBPbiBGcmksIFNlcCAw
NCwgMjAyMCBhdCAwODozNzoxNVBNICswMzAwLCBBbmRyYSBQYXJhc2NoaXYgd3JvdGU6Cj4+IFNp
Z25lZC1vZmYtYnk6IEFuZHJhIFBhcmFzY2hpdiA8YW5kcmFwcnNAYW1hem9uLmNvbT4KPj4gUmV2
aWV3ZWQtYnk6IEFsZXhhbmRlciBHcmFmIDxncmFmQGFtYXpvbi5jb20+Cj4+IC0tLQo+PiBDaGFu
Z2Vsb2cKPj4KPj4gdjcgLT4gdjgKPj4KPj4gKiBObyBjaGFuZ2VzLgo+Pgo+PiB2NiAtPiB2Nwo+
Pgo+PiAqIE5vIGNoYW5nZXMuCj4+Cj4+IHY1IC0+IHY2Cj4+Cj4+ICogTm8gY2hhbmdlcy4KPj4K
Pj4gdjQgLT4gdjUKPj4KPj4gKiBObyBjaGFuZ2VzLgo+Pgo+PiB2MyAtPiB2NAo+Pgo+PiAqIE5v
IGNoYW5nZXMuCj4+Cj4+IHYyIC0+IHYzCj4+Cj4+ICogUmVtb3ZlIHRoZSBHUEwgYWRkaXRpb25h
bCB3b3JkaW5nIGFzIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyIGlzCj4+ICAgIGFscmVhZHkgaW4g
cGxhY2UuCj4+Cj4+IHYxIC0+IHYyCj4+Cj4+ICogVXBkYXRlIHBhdGggdG8gTWFrZWZpbGUgdG8g
bWF0Y2ggdGhlIGRyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcwo+PiAgICBkaXJlY3RvcnkuCj4+
IC0tLQo+PiAgIGRyaXZlcnMvdmlydC9NYWtlZmlsZSAgICAgICAgICAgICAgICB8ICAyICsrCj4+
ICAgZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL01ha2VmaWxlIHwgMTEgKysrKysrKysrKysK
Pj4gICAyIGZpbGVzIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKykKPj4gICBjcmVhdGUgbW9kZSAx
MDA2NDQgZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL01ha2VmaWxlCj4+Cj4+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL3ZpcnQvTWFrZWZpbGUgYi9kcml2ZXJzL3ZpcnQvTWFrZWZpbGUKPj4gaW5k
ZXggZmQzMzEyNDdjMjdhLi5mMjg0MjVjZTRiMzkgMTAwNjQ0Cj4+IC0tLSBhL2RyaXZlcnMvdmly
dC9NYWtlZmlsZQo+PiArKysgYi9kcml2ZXJzL3ZpcnQvTWFrZWZpbGUKPj4gQEAgLTUsMyArNSw1
IEBACj4+Cj4+ICAgb2JqLSQoQ09ORklHX0ZTTF9IVl9NQU5BR0VSKSArPSBmc2xfaHlwZXJ2aXNv
ci5vCj4+ICAgb2JqLXkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs9IHZib3hndWVz
dC8KPj4gKwo+PiArb2JqLSQoQ09ORklHX05JVFJPX0VOQ0xBVkVTKSArPSBuaXRyb19lbmNsYXZl
cy8KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9NYWtlZmlsZSBi
L2RyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9NYWtlZmlsZQo+PiBuZXcgZmlsZSBtb2RlIDEw
MDY0NAo+PiBpbmRleCAwMDAwMDAwMDAwMDAuLmU5ZjRmY2QxNTkxZQo+PiAtLS0gL2Rldi9udWxs
Cj4+ICsrKyBiL2RyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9NYWtlZmlsZQo+PiBAQCAtMCww
ICsxLDExIEBACj4+ICsjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wCj4+ICsjCj4+
ICsjIENvcHlyaWdodCAyMDIwIEFtYXpvbi5jb20sIEluYy4gb3IgaXRzIGFmZmlsaWF0ZXMuIEFs
bCBSaWdodHMgUmVzZXJ2ZWQuCj4+ICsKPj4gKyMgRW5jbGF2ZSBsaWZldGltZSBtYW5hZ2VtZW50
IHN1cHBvcnQgZm9yIE5pdHJvIEVuY2xhdmVzIChORSkuCj4+ICsKPj4gK29iai0kKENPTkZJR19O
SVRST19FTkNMQVZFUykgKz0gbml0cm9fZW5jbGF2ZXMubwo+PiArCj4+ICtuaXRyb19lbmNsYXZl
cy15IDo9IG5lX3BjaV9kZXYubyBuZV9taXNjX2Rldi5vCj4+ICsKPj4gK2NjZmxhZ3MteSArPSAt
V2FsbAo+IFRoYXQgZmxhZyBpcyBfcmVhbGx5XyByaXNreSBvdmVyIHRpbWUsIGFyZSB5b3UgX1NV
UkVfIHRoYXQgYWxsIG5ldwo+IHZlcnNpb25zIG9mIGNsYW5nIGFuZCBnY2Mgd2lsbCBuZXZlciBw
cm9kdWNlIGFueSB3YXJuaW5ncz8gIFBlb3BsZSB3b3JrCj4gdG8gZml4IHVwIGJ1aWxkIHdhcm5p
bmdzIHF1aXRlIHF1aWNrbHkgZm9yIG5ldyBjb21waWxlcnMsIHlvdSBzaG91bGRuJ3QKPiBwcmV2
ZW50IHRoZSBjb2RlIGZyb20gYmVpbmcgYnVpbHQgYXQgYWxsIGp1c3QgZm9yIHRoYXQsIHJpZ2h0
Pwo+CgpUaGF0IHdvdWxkIGFsc28gbmVlZCBXZXJyb3IsIHRvIGhhdmUgd2FybmluZ3MgdHJlYXRl
ZCBhcyBlcnJvcnMgYW5kIApwcmV2ZW50IGJ1aWxkaW5nIHRoZSBjb2RlYmFzZS4gSWYgaXQncyBh
Ym91dCBzb21ldGhpbmcgbW9yZSwganVzdCBsZXQgbWUgCmtub3cuCgpXb3VsZCB0aGlzIGFwcGx5
IHRvIHRoZSBzYW1wbGVzIGRpcmVjdG9yeSBhcyB3ZWxsLCBubz8KCkkgY291bGQgcmVtb3ZlIHRo
ZSBXYWxsIGZsYWdzIGFuZCBrZWVwIGl0IGZvciBkZXZlbG9wbWVudCB2YWxpZGF0aW9uIApwdXJw
b3NlcyBvbiBteSBzaWRlIHRvIHNvbHZlIGF0IGxlYXN0IHRoZSB3YXJuaW5ncyB0aGF0IHdvdWxk
IGZ1cnRoZXIgc2VlLgoKVGhhbmtzLApBbmRyYQoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVy
IChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0
LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdp
c3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

