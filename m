Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E9525E12F
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 19:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgIDRxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 13:53:07 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:39820 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbgIDRxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 13:53:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599241984; x=1630777984;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Eda7WgdcK57R7jkn9MWSwn0W44Zp2g0Wm59WWXAdE0o=;
  b=GygV/S6ZmQGkkKlN758x1iU43YsuET8TiD8jKPECVFhk+CJAOA/RMwVH
   Px5Wo9hbSt2vBpdTb5Nn1MabIQXXwzwKdJYtFxl54VMaGSLkCnGKra4oh
   chzjYhjWuPorJJOwMEZP7/OiRHnDu9D/ZC2YqGwsFQP6Cf2xSACS4EOJw
   M=;
X-IronPort-AV: E=Sophos;i="5.76,390,1592870400"; 
   d="scan'208";a="51941672"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 04 Sep 2020 17:53:03 +0000
Received: from EX13D16EUB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 5F05FA0712;
        Fri,  4 Sep 2020 17:53:00 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.192) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Sep 2020 17:52:49 +0000
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
 <7727faf5-1c13-f7f1-ede3-64cf131c7dc7@amazon.com>
 <20200904161339.GA3824396@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <5d3ef140-2999-0474-a208-a3fee9d27dfc@amazon.com>
Date:   Fri, 4 Sep 2020 20:52:38 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200904161339.GA3824396@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.192]
X-ClientProxiedBy: EX13d09UWC004.ant.amazon.com (10.43.162.114) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNC8wOS8yMDIwIDE5OjEzLCBHcmVnIEtIIHdyb3RlOgo+IE9uIE1vbiwgQXVnIDMxLCAy
MDIwIGF0IDExOjE5OjE5QU0gKzAzMDAsIFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEgd3JvdGU6Cj4+
Cj4+IE9uIDE5LzA4LzIwMjAgMTQ6MjYsIEdyZWcgS0ggd3JvdGU6Cj4+PiBPbiBXZWQsIEF1ZyAx
OSwgMjAyMCBhdCAwMToxNTo1OVBNICswMjAwLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPj4+PiBP
biAxNy4wOC4yMCAxNTowOSwgQW5kcmEgUGFyYXNjaGl2IHdyb3RlOgo+Pj4+PiBOaXRybyBFbmNs
YXZlcyAoTkUpIGlzIGEgbmV3IEFtYXpvbiBFbGFzdGljIENvbXB1dGUgQ2xvdWQgKEVDMikgY2Fw
YWJpbGl0eQo+Pj4+PiB0aGF0IGFsbG93cyBjdXN0b21lcnMgdG8gY2FydmUgb3V0IGlzb2xhdGVk
IGNvbXB1dGUgZW52aXJvbm1lbnRzIHdpdGhpbiBFQzIKPj4+Pj4gaW5zdGFuY2VzIFsxXS4KPj4+
Pj4KPj4+Pj4gRm9yIGV4YW1wbGUsIGFuIGFwcGxpY2F0aW9uIHRoYXQgcHJvY2Vzc2VzIHNlbnNp
dGl2ZSBkYXRhIGFuZCBydW5zIGluIGEgVk0sCj4+Pj4+IGNhbiBiZSBzZXBhcmF0ZWQgZnJvbSBv
dGhlciBhcHBsaWNhdGlvbnMgcnVubmluZyBpbiB0aGUgc2FtZSBWTS4gVGhpcwo+Pj4+PiBhcHBs
aWNhdGlvbiB0aGVuIHJ1bnMgaW4gYSBzZXBhcmF0ZSBWTSB0aGFuIHRoZSBwcmltYXJ5IFZNLCBu
YW1lbHkgYW4gZW5jbGF2ZS4KPj4+Pj4KPj4+Pj4gQW4gZW5jbGF2ZSBydW5zIGFsb25nc2lkZSB0
aGUgVk0gdGhhdCBzcGF3bmVkIGl0LiBUaGlzIHNldHVwIG1hdGNoZXMgbG93IGxhdGVuY3kKPj4+
Pj4gYXBwbGljYXRpb25zIG5lZWRzLiBUaGUgcmVzb3VyY2VzIHRoYXQgYXJlIGFsbG9jYXRlZCBm
b3IgdGhlIGVuY2xhdmUsIHN1Y2ggYXMKPj4+Pj4gbWVtb3J5IGFuZCBDUFVzLCBhcmUgY2FydmVk
IG91dCBvZiB0aGUgcHJpbWFyeSBWTS4gRWFjaCBlbmNsYXZlIGlzIG1hcHBlZCB0byBhCj4+Pj4+
IHByb2Nlc3MgcnVubmluZyBpbiB0aGUgcHJpbWFyeSBWTSwgdGhhdCBjb21tdW5pY2F0ZXMgd2l0
aCB0aGUgTkUgZHJpdmVyIHZpYSBhbgo+Pj4+PiBpb2N0bCBpbnRlcmZhY2UuCj4+Pj4+Cj4+Pj4+
IEluIHRoaXMgc2Vuc2UsIHRoZXJlIGFyZSB0d28gY29tcG9uZW50czoKPj4+Pj4KPj4+Pj4gMS4g
QW4gZW5jbGF2ZSBhYnN0cmFjdGlvbiBwcm9jZXNzIC0gYSB1c2VyIHNwYWNlIHByb2Nlc3MgcnVu
bmluZyBpbiB0aGUgcHJpbWFyeQo+Pj4+PiBWTSBndWVzdCB0aGF0IHVzZXMgdGhlIHByb3ZpZGVk
IGlvY3RsIGludGVyZmFjZSBvZiB0aGUgTkUgZHJpdmVyIHRvIHNwYXduIGFuCj4+Pj4+IGVuY2xh
dmUgVk0gKHRoYXQncyAyIGJlbG93KS4KPj4+Pj4KPj4+Pj4gVGhlcmUgaXMgYSBORSBlbXVsYXRl
ZCBQQ0kgZGV2aWNlIGV4cG9zZWQgdG8gdGhlIHByaW1hcnkgVk0uIFRoZSBkcml2ZXIgZm9yIHRo
aXMKPj4+Pj4gbmV3IFBDSSBkZXZpY2UgaXMgaW5jbHVkZWQgaW4gdGhlIE5FIGRyaXZlci4KPj4+
Pj4KPj4+Pj4gVGhlIGlvY3RsIGxvZ2ljIGlzIG1hcHBlZCB0byBQQ0kgZGV2aWNlIGNvbW1hbmRz
IGUuZy4gdGhlIE5FX1NUQVJUX0VOQ0xBVkUgaW9jdGwKPj4+Pj4gbWFwcyB0byBhbiBlbmNsYXZl
IHN0YXJ0IFBDSSBjb21tYW5kLiBUaGUgUENJIGRldmljZSBjb21tYW5kcyBhcmUgdGhlbgo+Pj4+
PiB0cmFuc2xhdGVkIGludG8gIGFjdGlvbnMgdGFrZW4gb24gdGhlIGh5cGVydmlzb3Igc2lkZTsg
dGhhdCdzIHRoZSBOaXRybwo+Pj4+PiBoeXBlcnZpc29yIHJ1bm5pbmcgb24gdGhlIGhvc3Qgd2hl
cmUgdGhlIHByaW1hcnkgVk0gaXMgcnVubmluZy4gVGhlIE5pdHJvCj4+Pj4+IGh5cGVydmlzb3Ig
aXMgYmFzZWQgb24gY29yZSBLVk0gdGVjaG5vbG9neS4KPj4+Pj4KPj4+Pj4gMi4gVGhlIGVuY2xh
dmUgaXRzZWxmIC0gYSBWTSBydW5uaW5nIG9uIHRoZSBzYW1lIGhvc3QgYXMgdGhlIHByaW1hcnkg
Vk0gdGhhdAo+Pj4+PiBzcGF3bmVkIGl0LiBNZW1vcnkgYW5kIENQVXMgYXJlIGNhcnZlZCBvdXQg
b2YgdGhlIHByaW1hcnkgVk0gYW5kIGFyZSBkZWRpY2F0ZWQKPj4+Pj4gZm9yIHRoZSBlbmNsYXZl
IFZNLiBBbiBlbmNsYXZlIGRvZXMgbm90IGhhdmUgcGVyc2lzdGVudCBzdG9yYWdlIGF0dGFjaGVk
Lgo+Pj4+Pgo+Pj4+PiBUaGUgbWVtb3J5IHJlZ2lvbnMgY2FydmVkIG91dCBvZiB0aGUgcHJpbWFy
eSBWTSBhbmQgZ2l2ZW4gdG8gYW4gZW5jbGF2ZSBuZWVkIHRvCj4+Pj4+IGJlIGFsaWduZWQgMiBN
aUIgLyAxIEdpQiBwaHlzaWNhbGx5IGNvbnRpZ3VvdXMgbWVtb3J5IHJlZ2lvbnMgKG9yIG11bHRp
cGxlIG9mCj4+Pj4+IHRoaXMgc2l6ZSBlLmcuIDggTWlCKS4gVGhlIG1lbW9yeSBjYW4gYmUgYWxs
b2NhdGVkIGUuZy4gYnkgdXNpbmcgaHVnZXRsYmZzIGZyb20KPj4+Pj4gdXNlciBzcGFjZSBbMl1b
M10uIFRoZSBtZW1vcnkgc2l6ZSBmb3IgYW4gZW5jbGF2ZSBuZWVkcyB0byBiZSBhdCBsZWFzdCA2
NCBNaUIuCj4+Pj4+IFRoZSBlbmNsYXZlIG1lbW9yeSBhbmQgQ1BVcyBuZWVkIHRvIGJlIGZyb20g
dGhlIHNhbWUgTlVNQSBub2RlLgo+Pj4+Pgo+Pj4+PiBBbiBlbmNsYXZlIHJ1bnMgb24gZGVkaWNh
dGVkIGNvcmVzLiBDUFUgMCBhbmQgaXRzIENQVSBzaWJsaW5ncyBuZWVkIHRvIHJlbWFpbgo+Pj4+
PiBhdmFpbGFibGUgZm9yIHRoZSBwcmltYXJ5IFZNLiBBIENQVSBwb29sIGhhcyB0byBiZSBzZXQg
Zm9yIE5FIHB1cnBvc2VzIGJ5IGFuCj4+Pj4+IHVzZXIgd2l0aCBhZG1pbiBjYXBhYmlsaXR5LiBT
ZWUgdGhlIGNwdSBsaXN0IHNlY3Rpb24gZnJvbSB0aGUga2VybmVsCj4+Pj4+IGRvY3VtZW50YXRp
b24gWzRdIGZvciBob3cgYSBDUFUgcG9vbCBmb3JtYXQgbG9va3MuCj4+Pj4+Cj4+Pj4+IEFuIGVu
Y2xhdmUgY29tbXVuaWNhdGVzIHdpdGggdGhlIHByaW1hcnkgVk0gdmlhIGEgbG9jYWwgY29tbXVu
aWNhdGlvbiBjaGFubmVsLAo+Pj4+PiB1c2luZyB2aXJ0aW8tdnNvY2sgWzVdLiBUaGUgcHJpbWFy
eSBWTSBoYXMgdmlydGlvLXBjaSB2c29jayBlbXVsYXRlZCBkZXZpY2UsCj4+Pj4+IHdoaWxlIHRo
ZSBlbmNsYXZlIFZNIGhhcyBhIHZpcnRpby1tbWlvIHZzb2NrIGVtdWxhdGVkIGRldmljZS4gVGhl
IHZzb2NrIGRldmljZQo+Pj4+PiB1c2VzIGV2ZW50ZmQgZm9yIHNpZ25hbGluZy4gVGhlIGVuY2xh
dmUgVk0gc2VlcyB0aGUgdXN1YWwgaW50ZXJmYWNlcyAtIGxvY2FsCj4+Pj4+IEFQSUMgYW5kIElP
QVBJQyAtIHRvIGdldCBpbnRlcnJ1cHRzIGZyb20gdmlydGlvLXZzb2NrIGRldmljZS4gVGhlIHZp
cnRpby1tbWlvCj4+Pj4+IGRldmljZSBpcyBwbGFjZWQgaW4gbWVtb3J5IGJlbG93IHRoZSB0eXBp
Y2FsIDQgR2lCLgo+Pj4+Pgo+Pj4+PiBUaGUgYXBwbGljYXRpb24gdGhhdCBydW5zIGluIHRoZSBl
bmNsYXZlIG5lZWRzIHRvIGJlIHBhY2thZ2VkIGluIGFuIGVuY2xhdmUKPj4+Pj4gaW1hZ2UgdG9n
ZXRoZXIgd2l0aCB0aGUgT1MgKCBlLmcuIGtlcm5lbCwgcmFtZGlzaywgaW5pdCApIHRoYXQgd2ls
bCBydW4gaW4gdGhlCj4+Pj4+IGVuY2xhdmUgVk0uIFRoZSBlbmNsYXZlIFZNIGhhcyBpdHMgb3du
IGtlcm5lbCBhbmQgZm9sbG93cyB0aGUgc3RhbmRhcmQgTGludXgKPj4+Pj4gYm9vdCBwcm90b2Nv
bC4KPj4+Pj4KPj4+Pj4gVGhlIGtlcm5lbCBiekltYWdlLCB0aGUga2VybmVsIGNvbW1hbmQgbGlu
ZSwgdGhlIHJhbWRpc2socykgYXJlIHBhcnQgb2YgdGhlCj4+Pj4+IEVuY2xhdmUgSW1hZ2UgRm9y
bWF0IChFSUYpOyBwbHVzIGFuIEVJRiBoZWFkZXIgaW5jbHVkaW5nIG1ldGFkYXRhIHN1Y2ggYXMg
bWFnaWMKPj4+Pj4gbnVtYmVyLCBlaWYgdmVyc2lvbiwgaW1hZ2Ugc2l6ZSBhbmQgQ1JDLgo+Pj4+
Pgo+Pj4+PiBIYXNoIHZhbHVlcyBhcmUgY29tcHV0ZWQgZm9yIHRoZSBlbnRpcmUgZW5jbGF2ZSBp
bWFnZSAoRUlGKSwgdGhlIGtlcm5lbCBhbmQKPj4+Pj4gcmFtZGlzayhzKS4gVGhhdCdzIHVzZWQs
IGZvciBleGFtcGxlLCB0byBjaGVjayB0aGF0IHRoZSBlbmNsYXZlIGltYWdlIHRoYXQgaXMKPj4+
Pj4gbG9hZGVkIGluIHRoZSBlbmNsYXZlIFZNIGlzIHRoZSBvbmUgdGhhdCB3YXMgaW50ZW5kZWQg
dG8gYmUgcnVuLgo+Pj4+Pgo+Pj4+PiBUaGVzZSBjcnlwdG8gbWVhc3VyZW1lbnRzIGFyZSBpbmNs
dWRlZCBpbiBhIHNpZ25lZCBhdHRlc3RhdGlvbiBkb2N1bWVudAo+Pj4+PiBnZW5lcmF0ZWQgYnkg
dGhlIE5pdHJvIEh5cGVydmlzb3IgYW5kIGZ1cnRoZXIgdXNlZCB0byBwcm92ZSB0aGUgaWRlbnRp
dHkgb2YgdGhlCj4+Pj4+IGVuY2xhdmU7IEtNUyBpcyBhbiBleGFtcGxlIG9mIHNlcnZpY2UgdGhh
dCBORSBpcyBpbnRlZ3JhdGVkIHdpdGggYW5kIHRoYXQgY2hlY2tzCj4+Pj4+IHRoZSBhdHRlc3Rh
dGlvbiBkb2MuCj4+Pj4+Cj4+Pj4+IFRoZSBlbmNsYXZlIGltYWdlIChFSUYpIGlzIGxvYWRlZCBp
biB0aGUgZW5jbGF2ZSBtZW1vcnkgYXQgb2Zmc2V0IDggTWlCLiBUaGUKPj4+Pj4gaW5pdCBwcm9j
ZXNzIGluIHRoZSBlbmNsYXZlIGNvbm5lY3RzIHRvIHRoZSB2c29jayBDSUQgb2YgdGhlIHByaW1h
cnkgVk0gYW5kIGEKPj4+Pj4gcHJlZGVmaW5lZCBwb3J0IC0gOTAwMCAtIHRvIHNlbmQgYSBoZWFy
dGJlYXQgdmFsdWUgLSAweGI3LiBUaGlzIG1lY2hhbmlzbSBpcwo+Pj4+PiB1c2VkIHRvIGNoZWNr
IGluIHRoZSBwcmltYXJ5IFZNIHRoYXQgdGhlIGVuY2xhdmUgaGFzIGJvb3RlZC4KPj4+Pj4KPj4+
Pj4gSWYgdGhlIGVuY2xhdmUgVk0gY3Jhc2hlcyBvciBncmFjZWZ1bGx5IGV4aXRzLCBhbiBpbnRl
cnJ1cHQgZXZlbnQgaXMgcmVjZWl2ZWQgYnkKPj4+Pj4gdGhlIE5FIGRyaXZlci4gVGhpcyBldmVu
dCBpcyBzZW50IGZ1cnRoZXIgdG8gdGhlIHVzZXIgc3BhY2UgZW5jbGF2ZSBwcm9jZXNzCj4+Pj4+
IHJ1bm5pbmcgaW4gdGhlIHByaW1hcnkgVk0gdmlhIGEgcG9sbCBub3RpZmljYXRpb24gbWVjaGFu
aXNtLiBUaGVuIHRoZSB1c2VyIHNwYWNlCj4+Pj4+IGVuY2xhdmUgcHJvY2VzcyBjYW4gZXhpdC4K
Pj4+Pj4KPj4+Pj4gVGhhbmsgeW91Lgo+Pj4+Pgo+Pj4+IFRoaXMgdmVyc2lvbiByZWFkcyB2ZXJ5
IHdlbGwsIHRoYW5rcyBhIGxvdCBBbmRyYSEKPj4+Pgo+Pj4+IEdyZWcsIHdvdWxkIHlvdSBtaW5k
IHRvIGhhdmUgYW5vdGhlciBsb29rIG92ZXIgaXQ/Cj4+PiBXaWxsIGRvLCBpdCdzIGluIG15IHRv
LXJldmlldyBxdWV1ZSwgYmVoaW5kIGxvdHMgb2Ygb3RoZXIgcGF0Y2hlcy4uLgo+Pj4KPj4gSSBo
YXZlIGEgc2V0IG9mIHVwZGF0ZXMgdGhhdCBjYW4gYmUgaW5jbHVkZWQgaW4gYSBuZXcgcmV2aXNp
b24sIHY4IGUuZy4gbmV3Cj4+IE5FIGN1c3RvbSBlcnJvciBjb2RlcyBmb3IgaW52YWxpZCBmbGFn
cyAvIGVuY2xhdmUgQ0lELCAic2h1dGRvd24iIGZ1bmN0aW9uCj4+IGZvciB0aGUgTkUgUENJIGRl
dmljZSBkcml2ZXIsIGEgY291cGxlIG1vcmUgY2hlY2tzIHdydCBpbnZhbGlkIGZsYWdzIGFuZAo+
PiBlbmNsYXZlIHZzb2NrIENJRCwgZG9jdW1lbnRhdGlvbiBhbmQgc2FtcGxlIHVwZGF0ZXMuIFRo
ZXJlIGlzIGFsc28gdGhlCj4+IG9wdGlvbiB0byBoYXZlIHRoZXNlIHVwZGF0ZXMgYXMgZm9sbG93
LXVwIHBhdGNoZXMuCj4+Cj4+IEdyZWcsIGxldCBtZSBrbm93IHdoYXQgd291bGQgd29yayBmaW5l
IGZvciB5b3Ugd2l0aCByZWdhcmQgdG8gdGhlIHJldmlldyBvZgo+PiB0aGUgcGF0Y2ggc2VyaWVz
Lgo+IEEgbmV3IHNlcmllcyBpcyBhbHdheXMgZmluZSB3aXRoIG1lLi4uCj4KCkFscmlnaHQsIHRo
YW5rIHlvdS4gSSBzZW50IG91dCB0aGUgbmV3IHJldmlzaW9uLgoKQW5kcmEKCgoKQW1hem9uIERl
dmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0Eg
U2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHksIDcwMDA0
NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoy
Mi8yNjIxLzIwMDUuCg==

