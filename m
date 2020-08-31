Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6951625752D
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 10:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgHaIUQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 04:20:16 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:14254 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbgHaIUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 04:20:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598862012; x=1630398012;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=gIp40GZRIp5bDIplQZHJziZqG8BXm2ncfbGmikCQsZ4=;
  b=ik75uIMPCfLDTuK5q6FgTgVFp43mNNkban/MCXZfOV3k07qYuSnCPW/S
   O5TPPxBVQOw3MCqn9c1bKczlzJaU1JlrOLxm1CSsnQBgHaEz9y0WsybkO
   ZMZqs0lo0exD3ULwJdEi7vJDY1mei7CM8aXsiqg+0yBNyCVNcB8VPqYK3
   Y=;
X-IronPort-AV: E=Sophos;i="5.76,375,1592870400"; 
   d="scan'208";a="64111302"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 31 Aug 2020 08:19:42 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id 0259AA2029;
        Mon, 31 Aug 2020 08:19:39 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.215) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 31 Aug 2020 08:19:29 +0000
Subject: Re: [PATCH v7 00/18] Add support for Nitro Enclaves
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Karen Noel <knoel@redhat.com>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        Alexander Graf <graf@amazon.de>
References: <20200817131003.56650-1-andraprs@amazon.com>
 <14477cc7-926e-383d-527b-b53d088ca13d@amazon.de>
 <20200819112657.GA475121@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <7727faf5-1c13-f7f1-ede3-64cf131c7dc7@amazon.com>
Date:   Mon, 31 Aug 2020 11:19:19 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200819112657.GA475121@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.215]
X-ClientProxiedBy: EX13D39UWB002.ant.amazon.com (10.43.161.116) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxOS8wOC8yMDIwIDE0OjI2LCBHcmVnIEtIIHdyb3RlOgo+Cj4gT24gV2VkLCBBdWcgMTks
IDIwMjAgYXQgMDE6MTU6NTlQTSArMDIwMCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+Cj4+IE9u
IDE3LjA4LjIwIDE1OjA5LCBBbmRyYSBQYXJhc2NoaXYgd3JvdGU6Cj4+PiBOaXRybyBFbmNsYXZl
cyAoTkUpIGlzIGEgbmV3IEFtYXpvbiBFbGFzdGljIENvbXB1dGUgQ2xvdWQgKEVDMikgY2FwYWJp
bGl0eQo+Pj4gdGhhdCBhbGxvd3MgY3VzdG9tZXJzIHRvIGNhcnZlIG91dCBpc29sYXRlZCBjb21w
dXRlIGVudmlyb25tZW50cyB3aXRoaW4gRUMyCj4+PiBpbnN0YW5jZXMgWzFdLgo+Pj4KPj4+IEZv
ciBleGFtcGxlLCBhbiBhcHBsaWNhdGlvbiB0aGF0IHByb2Nlc3NlcyBzZW5zaXRpdmUgZGF0YSBh
bmQgcnVucyBpbiBhIFZNLAo+Pj4gY2FuIGJlIHNlcGFyYXRlZCBmcm9tIG90aGVyIGFwcGxpY2F0
aW9ucyBydW5uaW5nIGluIHRoZSBzYW1lIFZNLiBUaGlzCj4+PiBhcHBsaWNhdGlvbiB0aGVuIHJ1
bnMgaW4gYSBzZXBhcmF0ZSBWTSB0aGFuIHRoZSBwcmltYXJ5IFZNLCBuYW1lbHkgYW4gZW5jbGF2
ZS4KPj4+Cj4+PiBBbiBlbmNsYXZlIHJ1bnMgYWxvbmdzaWRlIHRoZSBWTSB0aGF0IHNwYXduZWQg
aXQuIFRoaXMgc2V0dXAgbWF0Y2hlcyBsb3cgbGF0ZW5jeQo+Pj4gYXBwbGljYXRpb25zIG5lZWRz
LiBUaGUgcmVzb3VyY2VzIHRoYXQgYXJlIGFsbG9jYXRlZCBmb3IgdGhlIGVuY2xhdmUsIHN1Y2gg
YXMKPj4+IG1lbW9yeSBhbmQgQ1BVcywgYXJlIGNhcnZlZCBvdXQgb2YgdGhlIHByaW1hcnkgVk0u
IEVhY2ggZW5jbGF2ZSBpcyBtYXBwZWQgdG8gYQo+Pj4gcHJvY2VzcyBydW5uaW5nIGluIHRoZSBw
cmltYXJ5IFZNLCB0aGF0IGNvbW11bmljYXRlcyB3aXRoIHRoZSBORSBkcml2ZXIgdmlhIGFuCj4+
PiBpb2N0bCBpbnRlcmZhY2UuCj4+Pgo+Pj4gSW4gdGhpcyBzZW5zZSwgdGhlcmUgYXJlIHR3byBj
b21wb25lbnRzOgo+Pj4KPj4+IDEuIEFuIGVuY2xhdmUgYWJzdHJhY3Rpb24gcHJvY2VzcyAtIGEg
dXNlciBzcGFjZSBwcm9jZXNzIHJ1bm5pbmcgaW4gdGhlIHByaW1hcnkKPj4+IFZNIGd1ZXN0IHRo
YXQgdXNlcyB0aGUgcHJvdmlkZWQgaW9jdGwgaW50ZXJmYWNlIG9mIHRoZSBORSBkcml2ZXIgdG8g
c3Bhd24gYW4KPj4+IGVuY2xhdmUgVk0gKHRoYXQncyAyIGJlbG93KS4KPj4+Cj4+PiBUaGVyZSBp
cyBhIE5FIGVtdWxhdGVkIFBDSSBkZXZpY2UgZXhwb3NlZCB0byB0aGUgcHJpbWFyeSBWTS4gVGhl
IGRyaXZlciBmb3IgdGhpcwo+Pj4gbmV3IFBDSSBkZXZpY2UgaXMgaW5jbHVkZWQgaW4gdGhlIE5F
IGRyaXZlci4KPj4+Cj4+PiBUaGUgaW9jdGwgbG9naWMgaXMgbWFwcGVkIHRvIFBDSSBkZXZpY2Ug
Y29tbWFuZHMgZS5nLiB0aGUgTkVfU1RBUlRfRU5DTEFWRSBpb2N0bAo+Pj4gbWFwcyB0byBhbiBl
bmNsYXZlIHN0YXJ0IFBDSSBjb21tYW5kLiBUaGUgUENJIGRldmljZSBjb21tYW5kcyBhcmUgdGhl
bgo+Pj4gdHJhbnNsYXRlZCBpbnRvICBhY3Rpb25zIHRha2VuIG9uIHRoZSBoeXBlcnZpc29yIHNp
ZGU7IHRoYXQncyB0aGUgTml0cm8KPj4+IGh5cGVydmlzb3IgcnVubmluZyBvbiB0aGUgaG9zdCB3
aGVyZSB0aGUgcHJpbWFyeSBWTSBpcyBydW5uaW5nLiBUaGUgTml0cm8KPj4+IGh5cGVydmlzb3Ig
aXMgYmFzZWQgb24gY29yZSBLVk0gdGVjaG5vbG9neS4KPj4+Cj4+PiAyLiBUaGUgZW5jbGF2ZSBp
dHNlbGYgLSBhIFZNIHJ1bm5pbmcgb24gdGhlIHNhbWUgaG9zdCBhcyB0aGUgcHJpbWFyeSBWTSB0
aGF0Cj4+PiBzcGF3bmVkIGl0LiBNZW1vcnkgYW5kIENQVXMgYXJlIGNhcnZlZCBvdXQgb2YgdGhl
IHByaW1hcnkgVk0gYW5kIGFyZSBkZWRpY2F0ZWQKPj4+IGZvciB0aGUgZW5jbGF2ZSBWTS4gQW4g
ZW5jbGF2ZSBkb2VzIG5vdCBoYXZlIHBlcnNpc3RlbnQgc3RvcmFnZSBhdHRhY2hlZC4KPj4+Cj4+
PiBUaGUgbWVtb3J5IHJlZ2lvbnMgY2FydmVkIG91dCBvZiB0aGUgcHJpbWFyeSBWTSBhbmQgZ2l2
ZW4gdG8gYW4gZW5jbGF2ZSBuZWVkIHRvCj4+PiBiZSBhbGlnbmVkIDIgTWlCIC8gMSBHaUIgcGh5
c2ljYWxseSBjb250aWd1b3VzIG1lbW9yeSByZWdpb25zIChvciBtdWx0aXBsZSBvZgo+Pj4gdGhp
cyBzaXplIGUuZy4gOCBNaUIpLiBUaGUgbWVtb3J5IGNhbiBiZSBhbGxvY2F0ZWQgZS5nLiBieSB1
c2luZyBodWdldGxiZnMgZnJvbQo+Pj4gdXNlciBzcGFjZSBbMl1bM10uIFRoZSBtZW1vcnkgc2l6
ZSBmb3IgYW4gZW5jbGF2ZSBuZWVkcyB0byBiZSBhdCBsZWFzdCA2NCBNaUIuCj4+PiBUaGUgZW5j
bGF2ZSBtZW1vcnkgYW5kIENQVXMgbmVlZCB0byBiZSBmcm9tIHRoZSBzYW1lIE5VTUEgbm9kZS4K
Pj4+Cj4+PiBBbiBlbmNsYXZlIHJ1bnMgb24gZGVkaWNhdGVkIGNvcmVzLiBDUFUgMCBhbmQgaXRz
IENQVSBzaWJsaW5ncyBuZWVkIHRvIHJlbWFpbgo+Pj4gYXZhaWxhYmxlIGZvciB0aGUgcHJpbWFy
eSBWTS4gQSBDUFUgcG9vbCBoYXMgdG8gYmUgc2V0IGZvciBORSBwdXJwb3NlcyBieSBhbgo+Pj4g
dXNlciB3aXRoIGFkbWluIGNhcGFiaWxpdHkuIFNlZSB0aGUgY3B1IGxpc3Qgc2VjdGlvbiBmcm9t
IHRoZSBrZXJuZWwKPj4+IGRvY3VtZW50YXRpb24gWzRdIGZvciBob3cgYSBDUFUgcG9vbCBmb3Jt
YXQgbG9va3MuCj4+Pgo+Pj4gQW4gZW5jbGF2ZSBjb21tdW5pY2F0ZXMgd2l0aCB0aGUgcHJpbWFy
eSBWTSB2aWEgYSBsb2NhbCBjb21tdW5pY2F0aW9uIGNoYW5uZWwsCj4+PiB1c2luZyB2aXJ0aW8t
dnNvY2sgWzVdLiBUaGUgcHJpbWFyeSBWTSBoYXMgdmlydGlvLXBjaSB2c29jayBlbXVsYXRlZCBk
ZXZpY2UsCj4+PiB3aGlsZSB0aGUgZW5jbGF2ZSBWTSBoYXMgYSB2aXJ0aW8tbW1pbyB2c29jayBl
bXVsYXRlZCBkZXZpY2UuIFRoZSB2c29jayBkZXZpY2UKPj4+IHVzZXMgZXZlbnRmZCBmb3Igc2ln
bmFsaW5nLiBUaGUgZW5jbGF2ZSBWTSBzZWVzIHRoZSB1c3VhbCBpbnRlcmZhY2VzIC0gbG9jYWwK
Pj4+IEFQSUMgYW5kIElPQVBJQyAtIHRvIGdldCBpbnRlcnJ1cHRzIGZyb20gdmlydGlvLXZzb2Nr
IGRldmljZS4gVGhlIHZpcnRpby1tbWlvCj4+PiBkZXZpY2UgaXMgcGxhY2VkIGluIG1lbW9yeSBi
ZWxvdyB0aGUgdHlwaWNhbCA0IEdpQi4KPj4+Cj4+PiBUaGUgYXBwbGljYXRpb24gdGhhdCBydW5z
IGluIHRoZSBlbmNsYXZlIG5lZWRzIHRvIGJlIHBhY2thZ2VkIGluIGFuIGVuY2xhdmUKPj4+IGlt
YWdlIHRvZ2V0aGVyIHdpdGggdGhlIE9TICggZS5nLiBrZXJuZWwsIHJhbWRpc2ssIGluaXQgKSB0
aGF0IHdpbGwgcnVuIGluIHRoZQo+Pj4gZW5jbGF2ZSBWTS4gVGhlIGVuY2xhdmUgVk0gaGFzIGl0
cyBvd24ga2VybmVsIGFuZCBmb2xsb3dzIHRoZSBzdGFuZGFyZCBMaW51eAo+Pj4gYm9vdCBwcm90
b2NvbC4KPj4+Cj4+PiBUaGUga2VybmVsIGJ6SW1hZ2UsIHRoZSBrZXJuZWwgY29tbWFuZCBsaW5l
LCB0aGUgcmFtZGlzayhzKSBhcmUgcGFydCBvZiB0aGUKPj4+IEVuY2xhdmUgSW1hZ2UgRm9ybWF0
IChFSUYpOyBwbHVzIGFuIEVJRiBoZWFkZXIgaW5jbHVkaW5nIG1ldGFkYXRhIHN1Y2ggYXMgbWFn
aWMKPj4+IG51bWJlciwgZWlmIHZlcnNpb24sIGltYWdlIHNpemUgYW5kIENSQy4KPj4+Cj4+PiBI
YXNoIHZhbHVlcyBhcmUgY29tcHV0ZWQgZm9yIHRoZSBlbnRpcmUgZW5jbGF2ZSBpbWFnZSAoRUlG
KSwgdGhlIGtlcm5lbCBhbmQKPj4+IHJhbWRpc2socykuIFRoYXQncyB1c2VkLCBmb3IgZXhhbXBs
ZSwgdG8gY2hlY2sgdGhhdCB0aGUgZW5jbGF2ZSBpbWFnZSB0aGF0IGlzCj4+PiBsb2FkZWQgaW4g
dGhlIGVuY2xhdmUgVk0gaXMgdGhlIG9uZSB0aGF0IHdhcyBpbnRlbmRlZCB0byBiZSBydW4uCj4+
Pgo+Pj4gVGhlc2UgY3J5cHRvIG1lYXN1cmVtZW50cyBhcmUgaW5jbHVkZWQgaW4gYSBzaWduZWQg
YXR0ZXN0YXRpb24gZG9jdW1lbnQKPj4+IGdlbmVyYXRlZCBieSB0aGUgTml0cm8gSHlwZXJ2aXNv
ciBhbmQgZnVydGhlciB1c2VkIHRvIHByb3ZlIHRoZSBpZGVudGl0eSBvZiB0aGUKPj4+IGVuY2xh
dmU7IEtNUyBpcyBhbiBleGFtcGxlIG9mIHNlcnZpY2UgdGhhdCBORSBpcyBpbnRlZ3JhdGVkIHdp
dGggYW5kIHRoYXQgY2hlY2tzCj4+PiB0aGUgYXR0ZXN0YXRpb24gZG9jLgo+Pj4KPj4+IFRoZSBl
bmNsYXZlIGltYWdlIChFSUYpIGlzIGxvYWRlZCBpbiB0aGUgZW5jbGF2ZSBtZW1vcnkgYXQgb2Zm
c2V0IDggTWlCLiBUaGUKPj4+IGluaXQgcHJvY2VzcyBpbiB0aGUgZW5jbGF2ZSBjb25uZWN0cyB0
byB0aGUgdnNvY2sgQ0lEIG9mIHRoZSBwcmltYXJ5IFZNIGFuZCBhCj4+PiBwcmVkZWZpbmVkIHBv
cnQgLSA5MDAwIC0gdG8gc2VuZCBhIGhlYXJ0YmVhdCB2YWx1ZSAtIDB4YjcuIFRoaXMgbWVjaGFu
aXNtIGlzCj4+PiB1c2VkIHRvIGNoZWNrIGluIHRoZSBwcmltYXJ5IFZNIHRoYXQgdGhlIGVuY2xh
dmUgaGFzIGJvb3RlZC4KPj4+Cj4+PiBJZiB0aGUgZW5jbGF2ZSBWTSBjcmFzaGVzIG9yIGdyYWNl
ZnVsbHkgZXhpdHMsIGFuIGludGVycnVwdCBldmVudCBpcyByZWNlaXZlZCBieQo+Pj4gdGhlIE5F
IGRyaXZlci4gVGhpcyBldmVudCBpcyBzZW50IGZ1cnRoZXIgdG8gdGhlIHVzZXIgc3BhY2UgZW5j
bGF2ZSBwcm9jZXNzCj4+PiBydW5uaW5nIGluIHRoZSBwcmltYXJ5IFZNIHZpYSBhIHBvbGwgbm90
aWZpY2F0aW9uIG1lY2hhbmlzbS4gVGhlbiB0aGUgdXNlciBzcGFjZQo+Pj4gZW5jbGF2ZSBwcm9j
ZXNzIGNhbiBleGl0Lgo+Pj4KPj4+IFRoYW5rIHlvdS4KPj4+Cj4+IFRoaXMgdmVyc2lvbiByZWFk
cyB2ZXJ5IHdlbGwsIHRoYW5rcyBhIGxvdCBBbmRyYSEKPj4KPj4gR3JlZywgd291bGQgeW91IG1p
bmQgdG8gaGF2ZSBhbm90aGVyIGxvb2sgb3ZlciBpdD8KPiBXaWxsIGRvLCBpdCdzIGluIG15IHRv
LXJldmlldyBxdWV1ZSwgYmVoaW5kIGxvdHMgb2Ygb3RoZXIgcGF0Y2hlcy4uLgo+CgpJIGhhdmUg
YSBzZXQgb2YgdXBkYXRlcyB0aGF0IGNhbiBiZSBpbmNsdWRlZCBpbiBhIG5ldyByZXZpc2lvbiwg
djggZS5nLiAKbmV3IE5FIGN1c3RvbSBlcnJvciBjb2RlcyBmb3IgaW52YWxpZCBmbGFncyAvIGVu
Y2xhdmUgQ0lELCAic2h1dGRvd24iIApmdW5jdGlvbiBmb3IgdGhlIE5FIFBDSSBkZXZpY2UgZHJp
dmVyLCBhIGNvdXBsZSBtb3JlIGNoZWNrcyB3cnQgaW52YWxpZCAKZmxhZ3MgYW5kIGVuY2xhdmUg
dnNvY2sgQ0lELCBkb2N1bWVudGF0aW9uIGFuZCBzYW1wbGUgdXBkYXRlcy4gVGhlcmUgaXMgCmFs
c28gdGhlIG9wdGlvbiB0byBoYXZlIHRoZXNlIHVwZGF0ZXMgYXMgZm9sbG93LXVwIHBhdGNoZXMu
CgpHcmVnLCBsZXQgbWUga25vdyB3aGF0IHdvdWxkIHdvcmsgZmluZSBmb3IgeW91IHdpdGggcmVn
YXJkIHRvIHRoZSByZXZpZXcgCm9mIHRoZSBwYXRjaCBzZXJpZXMuCgpUaGFua3MsCkFuZHJhCgoK
CkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9m
ZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291
bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9u
IG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=

