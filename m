Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454BD20D80A
	for <lists+kvm@lfdr.de>; Mon, 29 Jun 2020 22:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733217AbgF2TfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 15:35:15 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:24916 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732761AbgF2TbR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 15:31:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593459077; x=1624995077;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=CVcq2zndXVsddYQ8O6xnjIwELA++4s2vt+dBW25RPxw=;
  b=b9otqqiVz5IzO+TpgIpIl5x1fTTmOSQG3OMqvKf/mqzDz7ttXDj9cy26
   wjH+Yz5v/7wnS0xjesx81aJ/isv60akcXmXlfsnBUQNTHbwvQbgb2vfQh
   Jdy7RDAj9Iez+cpJouBD4vlDLPkIyE6m2cb3C98As0xr/wUV4lhcX5wE8
   g=;
IronPort-SDR: IqI4/h1k6y6GKcc3DjPyyObPuwfrJpzrWV6Wad85FwQ4Pbpf/ah8+z9QegclRz+AL7FxXn7PPI
 qJ++tEW4Qo/Q==
X-IronPort-AV: E=Sophos;i="5.75,295,1589241600"; 
   d="scan'208";a="54762156"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 29 Jun 2020 17:45:46 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id 586D0A24B4;
        Mon, 29 Jun 2020 17:45:46 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 29 Jun 2020 17:45:44 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.145) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 29 Jun 2020 17:45:36 +0000
Subject: Re: [PATCH v4 07/18] nitro_enclaves: Init misc device providing the
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
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-8-andraprs@amazon.com>
 <20200629162013.GA718066@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <b87e2eeb-39cf-8de5-0f5f-1db04b3e2794@amazon.com>
Date:   Mon, 29 Jun 2020 20:45:25 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200629162013.GA718066@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D39UWB004.ant.amazon.com (10.43.161.148) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyOS8wNi8yMDIwIDE5OjIwLCBHcmVnIEtIIHdyb3RlOgo+Cj4gT24gTW9uLCBKdW4gMjIs
IDIwMjAgYXQgMTE6MDM6MThQTSArMDMwMCwgQW5kcmEgUGFyYXNjaGl2IHdyb3RlOgo+PiArc3Rh
dGljIGludCBfX2luaXQgbmVfaW5pdCh2b2lkKQo+PiArewo+PiArICAgICBzdHJ1Y3QgcGNpX2Rl
diAqcGRldiA9IHBjaV9nZXRfZGV2aWNlKFBDSV9WRU5ET1JfSURfQU1BWk9OLAo+PiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFBDSV9ERVZJQ0VfSURfTkUsIE5V
TEwpOwo+PiArICAgICBpbnQgcmMgPSAtRUlOVkFMOwo+PiArCj4+ICsgICAgIGlmICghcGRldikK
Pj4gKyAgICAgICAgICAgICByZXR1cm4gLUVOT0RFVjsKPiBJY2ssIHRoYXQncyBhIF92ZXJ5XyBv
bGQtc2Nob29sIHdheSBvZiBiaW5kaW5nIHRvIGEgcGNpIGRldmljZS4gIFBsZWFzZQo+IGp1c3Qg
YmUgYSAicmVhbCIgcGNpIGRyaXZlciBhbmQgeW91ciBwcm9iZSBmdW5jdGlvbiB3aWxsIGJlIGNh
bGxlZCBpZgo+IHlvdXIgaGFyZHdhcmUgaXMgcHJlc2VudCAob3Igd2hlbiBpdCBzaG93cyB1cC4p
ICBUbyBkbyBpdCB0aGlzIHdheQo+IHByZXZlbnRzIHlvdXIgZHJpdmVyIGZyb20gYmVpbmcgYXV0
by1sb2FkZWQgZm9yIHdoZW4geW91ciBoYXJkd2FyZSBpcwo+IHNlZW4gaW4gdGhlIHN5c3RlbSwg
YXMgd2VsbCBhcyBsb3RzIG9mIG90aGVyIHRoaW5ncy4KClRoaXMgY2hlY2sgaXMgbWFpbmx5IGhl
cmUgaW4gdGhlIGNhc2UgYW55IGNvZGViYXNlIGlzIGFkZGVkIGJlZm9yZSB0aGUgCnBjaSBkcml2
ZXIgcmVnaXN0ZXIgY2FsbCBiZWxvdy4KCkFuZCBpZiB3ZSBsb2cgYW55IGVycm9yIHdpdGggZGV2
X2VycigpIGluc3RlYWQgb2YgcHJfZXJyKCkgYmVmb3JlIHRoZSAKZHJpdmVyIHJlZ2lzdGVyLgoK
VGhhdCBjaGVjayB3YXMgb25seSBmb3IgbG9nZ2luZyBwdXJwb3NlcywgaWYgZG9uZSB3aXRoIGRl
dl9lcnIoKS4gSSAKcmVtb3ZlZCB0aGUgY2hlY2sgaW4gdjUuCgo+PiArCj4+ICsgICAgIGlmICgh
emFsbG9jX2NwdW1hc2tfdmFyKCZuZV9jcHVfcG9vbC5hdmFpbCwgR0ZQX0tFUk5FTCkpCj4+ICsg
ICAgICAgICAgICAgcmV0dXJuIC1FTk9NRU07Cj4+ICsKPj4gKyAgICAgbXV0ZXhfaW5pdCgmbmVf
Y3B1X3Bvb2wubXV0ZXgpOwo+PiArCj4+ICsgICAgIHJjID0gcGNpX3JlZ2lzdGVyX2RyaXZlcigm
bmVfcGNpX2RyaXZlcik7Cj4gTmljZSwgeW91IGRpZCBpdCByaWdodCBoZXJlLCBidXQgd2h5IHRo
ZSBhYm92ZSBjcmF6eSB0ZXN0Pwo+Cj4+ICsgICAgIGlmIChyYyA8IDApIHsKPj4gKyAgICAgICAg
ICAgICBkZXZfZXJyKCZwZGV2LT5kZXYsCj4+ICsgICAgICAgICAgICAgICAgICAgICAiRXJyb3Ig
aW4gcGNpIHJlZ2lzdGVyIGRyaXZlciBbcmM9JWRdXG4iLCByYyk7Cj4+ICsKPj4gKyAgICAgICAg
ICAgICBnb3RvIGZyZWVfY3B1bWFzazsKPj4gKyAgICAgfQo+PiArCj4+ICsgICAgIHJldHVybiAw
Owo+IFlvdSBsZWFrZWQgYSByZWZlcmVuY2Ugb24gdGhhdCBwY2kgZGV2aWNlLCBkaWRuJ3QgeW91
PyAgTm90IGdvb2QgOigKClllcywgdGhlIHBjaSBnZXQgZGV2aWNlIGNhbGwgbmVlZHMgaXRzIHBh
aXIgLSBwY2lfZGV2X3B1dCgpLiBJIGFkZGVkIGl0IApoZXJlIGFuZCBmb3IgdGhlIG90aGVyIG9j
Y3VycmVuY2VzIHdoZXJlIGl0IHdhcyBtaXNzaW5nLgoKVGhhbmtzIGZvciByZXZpZXcuCgpBbmRy
YQoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJl
ZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNp
IENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJh
dGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

