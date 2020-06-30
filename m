Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2686120F12D
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 11:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731865AbgF3JIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 05:08:45 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:26080 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731666AbgF3JIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jun 2020 05:08:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593508124; x=1625044124;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=5n5MJugzhcrSeTK9NLulOvMBQ+MVsMc5zw8tneUXurM=;
  b=mzDNPm+nPege7qlvXC27kifyiGTp4XTnYrz4I/f0gvQwvr8ZzBcRPJJX
   6LJ7n34kO3hvo+6dykN83wiKqtG/7ylBj1bQu5feTIBX1qrzj6qQ/SO/h
   PjhDs3MkhkR+11aKZ5aM4l2+4eH50/KlVXLMCO8yWuxmnipQ6xw7VhrMp
   M=;
IronPort-SDR: 1FuC4n/N1heBbR2UfmJjtI/St0Aok87VCumCXcOdEPUYCUotoC7Ewk1KHAarkIB3Vthtv9l+nq
 RfVwVNI5g/pA==
X-IronPort-AV: E=Sophos;i="5.75,296,1589241600"; 
   d="scan'208";a="54946739"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 30 Jun 2020 09:08:41 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 4AAA8A185A;
        Tue, 30 Jun 2020 09:08:39 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 30 Jun 2020 09:08:38 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.248) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 30 Jun 2020 09:08:31 +0000
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
 <b87e2eeb-39cf-8de5-0f5f-1db04b3e2794@amazon.com>
 <20200630080535.GD619174@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <7166a6aa-2e8f-fed9-6b95-f53b823e5bb7@amazon.com>
Date:   Tue, 30 Jun 2020 12:08:18 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200630080535.GD619174@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.248]
X-ClientProxiedBy: EX13d09UWA002.ant.amazon.com (10.43.160.186) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAzMC8wNi8yMDIwIDExOjA1LCBHcmVnIEtIIHdyb3RlOgo+Cj4gT24gTW9uLCBKdW4gMjks
IDIwMjAgYXQgMDg6NDU6MjVQTSArMDMwMCwgUGFyYXNjaGl2LCBBbmRyYS1JcmluYSB3cm90ZToK
Pj4KPj4gT24gMjkvMDYvMjAyMCAxOToyMCwgR3JlZyBLSCB3cm90ZToKPj4+IE9uIE1vbiwgSnVu
IDIyLCAyMDIwIGF0IDExOjAzOjE4UE0gKzAzMDAsIEFuZHJhIFBhcmFzY2hpdiB3cm90ZToKPj4+
PiArc3RhdGljIGludCBfX2luaXQgbmVfaW5pdCh2b2lkKQo+Pj4+ICt7Cj4+Pj4gKyAgICAgc3Ry
dWN0IHBjaV9kZXYgKnBkZXYgPSBwY2lfZ2V0X2RldmljZShQQ0lfVkVORE9SX0lEX0FNQVpPTiwK
Pj4+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFBDSV9ERVZJ
Q0VfSURfTkUsIE5VTEwpOwo+Pj4+ICsgICAgIGludCByYyA9IC1FSU5WQUw7Cj4+Pj4gKwo+Pj4+
ICsgICAgIGlmICghcGRldikKPj4+PiArICAgICAgICAgICAgIHJldHVybiAtRU5PREVWOwo+Pj4g
SWNrLCB0aGF0J3MgYSBfdmVyeV8gb2xkLXNjaG9vbCB3YXkgb2YgYmluZGluZyB0byBhIHBjaSBk
ZXZpY2UuICBQbGVhc2UKPj4+IGp1c3QgYmUgYSAicmVhbCIgcGNpIGRyaXZlciBhbmQgeW91ciBw
cm9iZSBmdW5jdGlvbiB3aWxsIGJlIGNhbGxlZCBpZgo+Pj4geW91ciBoYXJkd2FyZSBpcyBwcmVz
ZW50IChvciB3aGVuIGl0IHNob3dzIHVwLikgIFRvIGRvIGl0IHRoaXMgd2F5Cj4+PiBwcmV2ZW50
cyB5b3VyIGRyaXZlciBmcm9tIGJlaW5nIGF1dG8tbG9hZGVkIGZvciB3aGVuIHlvdXIgaGFyZHdh
cmUgaXMKPj4+IHNlZW4gaW4gdGhlIHN5c3RlbSwgYXMgd2VsbCBhcyBsb3RzIG9mIG90aGVyIHRo
aW5ncy4KPj4gVGhpcyBjaGVjayBpcyBtYWlubHkgaGVyZSBpbiB0aGUgY2FzZSBhbnkgY29kZWJh
c2UgaXMgYWRkZWQgYmVmb3JlIHRoZSBwY2kKPj4gZHJpdmVyIHJlZ2lzdGVyIGNhbGwgYmVsb3cu
Cj4gV2hhdCBkbyB5b3UgbWVhbiBieSAiY29kZWJhc2UiPyAgWW91IGNvbnRyb2wgdGhpcyBkcml2
ZXIsIGp1c3QgZG8gYWxsIG9mCj4gdGhlIGxvZ2ljIGluIHRoZSBwcm9iZSgpIGZ1bmN0aW9uLCBu
byBuZWVkIHRvIGRvIHRoaXMgaW4gdGhlIG1vZHVsZSBpbml0Cj4gY2FsbC4KPgo+PiBBbmQgaWYg
d2UgbG9nIGFueSBlcnJvciB3aXRoIGRldl9lcnIoKSBpbnN0ZWFkIG9mIHByX2VycigpIGJlZm9y
ZSB0aGUgZHJpdmVyCj4+IHJlZ2lzdGVyLgo+IERvbid0IGRvIHRoYXQuCj4KPj4gVGhhdCBjaGVj
ayB3YXMgb25seSBmb3IgbG9nZ2luZyBwdXJwb3NlcywgaWYgZG9uZSB3aXRoIGRldl9lcnIoKS4g
SSByZW1vdmVkCj4+IHRoZSBjaGVjayBpbiB2NS4KPiBBZ2FpbiwgZG9uJ3QgZG8gaXQgOikKPgo+
Pj4+ICsKPj4+PiArICAgICBpZiAoIXphbGxvY19jcHVtYXNrX3ZhcigmbmVfY3B1X3Bvb2wuYXZh
aWwsIEdGUF9LRVJORUwpKQo+Pj4+ICsgICAgICAgICAgICAgcmV0dXJuIC1FTk9NRU07Cj4+Pj4g
Kwo+Pj4+ICsgICAgIG11dGV4X2luaXQoJm5lX2NwdV9wb29sLm11dGV4KTsKPj4+PiArCj4+Pj4g
KyAgICAgcmMgPSBwY2lfcmVnaXN0ZXJfZHJpdmVyKCZuZV9wY2lfZHJpdmVyKTsKPj4+IE5pY2Us
IHlvdSBkaWQgaXQgcmlnaHQgaGVyZSwgYnV0IHdoeSB0aGUgYWJvdmUgY3JhenkgdGVzdD8KPj4+
Cj4+Pj4gKyAgICAgaWYgKHJjIDwgMCkgewo+Pj4+ICsgICAgICAgICAgICAgZGV2X2VycigmcGRl
di0+ZGV2LAo+Pj4+ICsgICAgICAgICAgICAgICAgICAgICAiRXJyb3IgaW4gcGNpIHJlZ2lzdGVy
IGRyaXZlciBbcmM9JWRdXG4iLCByYyk7Cj4+Pj4gKwo+Pj4+ICsgICAgICAgICAgICAgZ290byBm
cmVlX2NwdW1hc2s7Cj4+Pj4gKyAgICAgfQo+Pj4+ICsKPj4+PiArICAgICByZXR1cm4gMDsKPj4+
IFlvdSBsZWFrZWQgYSByZWZlcmVuY2Ugb24gdGhhdCBwY2kgZGV2aWNlLCBkaWRuJ3QgeW91PyAg
Tm90IGdvb2QgOigKPj4gWWVzLCB0aGUgcGNpIGdldCBkZXZpY2UgY2FsbCBuZWVkcyBpdHMgcGFp
ciAtIHBjaV9kZXZfcHV0KCkuIEkgYWRkZWQgaXQgaGVyZQo+PiBhbmQgZm9yIHRoZSBvdGhlciBv
Y2N1cnJlbmNlcyB3aGVyZSBpdCB3YXMgbWlzc2luZy4KPiBBZ2FpbiwganVzdCBkb24ndCBkbyBp
dCBhbmQgdGhlbiB5b3UgZG9uJ3QgaGF2ZSB0byB3b3JyeSBhYm91dCBhbnkgb2YKPiB0aGlzLgoK
WXVwLCBhbHJlYWR5IHN0YXJ0ZWQgdGhpcyBtb3JuaW5nIHRvIGNoZWNrICYgdXBkYXRlIHdoZXJl
IHdlIGNhbiBnbyAKd2l0aG91dCB0aGlzIGNhbGwgdG8gZ2V0IGEgUENJIGRldmljZSByZWZlcmVu
Y2UsIGFzIGEgZm9sbG93LXVwIHRvIHdoYXQgCndlIGRpc2N1c3NlZCB5ZXN0ZXJkYXkuCgpUaGFu
a3MsCkFuZHJhCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiBy
ZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElh
c2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4g
UmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=

