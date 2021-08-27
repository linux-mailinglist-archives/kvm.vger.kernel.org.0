Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9B93F9720
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 11:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244766AbhH0JhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 05:37:03 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:5321 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233097AbhH0JhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 05:37:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630056974; x=1661592974;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=4bQ82WTNjLDBROEdy/Ty/n4e7ze0HXf4YIVAFHA3jOs=;
  b=JO3LBtSRIiFbfYIoZsBVSQlTaCek54IPafWByOy11YW15f35SwqbXGkZ
   atCQZhdcPgcbdyoP9uIB7Epymc7Zj38t9Ldnza3Ipe+PRfTjkH7p3Lb1z
   1/Kh9hMYXfqPuY1xOIg/gwO5RrkXeVs062RRFXzQ9RD2zxj5UsEuEJpni
   M=;
X-IronPort-AV: E=Sophos;i="5.84,356,1620691200"; 
   d="scan'208";a="135711902"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-4c9419d1.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 27 Aug 2021 09:36:06 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-4c9419d1.us-east-1.amazon.com (Postfix) with ESMTPS id D1003A2431;
        Fri, 27 Aug 2021 09:36:03 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.186) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 27 Aug 2021 09:35:58 +0000
Subject: Re: [PATCH v1 2/3] nitro_enclaves: Update documentation for Arm
 support
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20210826173451.93165-1-andraprs@amazon.com>
 <20210826173451.93165-3-andraprs@amazon.com>
 <20210827072144.gqncsq42vfpzmoxl@steredhat>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <7828f0fc-cc99-aa80-ff95-8d24a73ca4a3@amazon.com>
Date:   Fri, 27 Aug 2021 12:35:45 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210827072144.gqncsq42vfpzmoxl@steredhat>
Content-Language: en-US
X-Originating-IP: [10.43.162.186]
X-ClientProxiedBy: EX13D48UWB002.ant.amazon.com (10.43.163.125) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNy8wOC8yMDIxIDEwOjIxLCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4gT24gVGh1
LCBBdWcgMjYsIDIwMjEgYXQgMDg6MzQ6NTBQTSArMDMwMCwgQW5kcmEgUGFyYXNjaGl2IHdyb3Rl
Ogo+PiBBZGQgcmVmZXJlbmNlcyBmb3IgaHVnZXBhZ2VzIGFuZCBib290aW5nIHN0ZXBzIGZvciBB
cm0uCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IEFuZHJhIFBhcmFzY2hpdiA8YW5kcmFwcnNAYW1hem9u
LmNvbT4KPj4gLS0tCj4+IERvY3VtZW50YXRpb24vdmlydC9uZV9vdmVydmlldy5yc3QgfCA4ICsr
KysrLS0tCj4+IDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0p
Cj4KPiBJZiB5b3UgbmVlZCB0byByZXNwaW4sIG1heWJlIHdlIGNhbiBhZGQgYSBsaXR0bGUgc2Vj
dGlvbiB3aXRoIAo+IHN1cHBvcnRlZCBhcmNoaXRlY3R1cmVzICh4ODYsIEFSTTY0KS4KPgoKU3Vy
ZSwgSSBjYW4gYWRkIHRoaXMgaW5mby4KClRoYW5rcywgU3RlZmFubywgZm9yIHJldmlldyBhbmQg
YWNrLgoKQW5kcmEKCj4KPj4KPj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vdmlydC9uZV9v
dmVydmlldy5yc3QgCj4+IGIvRG9jdW1lbnRhdGlvbi92aXJ0L25lX292ZXJ2aWV3LnJzdAo+PiBp
bmRleCAzOWIwYzhmZTI2NTRhLi4yNzc3ZGExZmIwYWQxIDEwMDY0NAo+PiAtLS0gYS9Eb2N1bWVu
dGF0aW9uL3ZpcnQvbmVfb3ZlcnZpZXcucnN0Cj4+ICsrKyBiL0RvY3VtZW50YXRpb24vdmlydC9u
ZV9vdmVydmlldy5yc3QKPj4gQEAgLTQzLDggKzQzLDggQEAgZm9yIHRoZSBlbmNsYXZlIFZNLiBB
biBlbmNsYXZlIGRvZXMgbm90IGhhdmUgCj4+IHBlcnNpc3RlbnQgc3RvcmFnZSBhdHRhY2hlZC4K
Pj4gVGhlIG1lbW9yeSByZWdpb25zIGNhcnZlZCBvdXQgb2YgdGhlIHByaW1hcnkgVk0gYW5kIGdp
dmVuIHRvIGFuIAo+PiBlbmNsYXZlIG5lZWQgdG8KPj4gYmUgYWxpZ25lZCAyIE1pQiAvIDEgR2lC
IHBoeXNpY2FsbHkgY29udGlndW91cyBtZW1vcnkgcmVnaW9ucyAob3IgCj4+IG11bHRpcGxlIG9m
Cj4+IHRoaXMgc2l6ZSBlLmcuIDggTWlCKS4gVGhlIG1lbW9yeSBjYW4gYmUgYWxsb2NhdGVkIGUu
Zy4gYnkgdXNpbmcgCj4+IGh1Z2V0bGJmcyBmcm9tCj4+IC11c2VyIHNwYWNlIFsyXVszXS4gVGhl
IG1lbW9yeSBzaXplIGZvciBhbiBlbmNsYXZlIG5lZWRzIHRvIGJlIGF0IAo+PiBsZWFzdCA2NCBN
aUIuCj4+IC1UaGUgZW5jbGF2ZSBtZW1vcnkgYW5kIENQVXMgbmVlZCB0byBiZSBmcm9tIHRoZSBz
YW1lIE5VTUEgbm9kZS4KPj4gK3VzZXIgc3BhY2UgWzJdWzNdWzddLiBUaGUgbWVtb3J5IHNpemUg
Zm9yIGFuIGVuY2xhdmUgbmVlZHMgdG8gYmUgYXQgCj4+IGxlYXN0Cj4+ICs2NCBNaUIuIFRoZSBl
bmNsYXZlIG1lbW9yeSBhbmQgQ1BVcyBuZWVkIHRvIGJlIGZyb20gdGhlIHNhbWUgTlVNQSBub2Rl
Lgo+Pgo+PiBBbiBlbmNsYXZlIHJ1bnMgb24gZGVkaWNhdGVkIGNvcmVzLiBDUFUgMCBhbmQgaXRz
IENQVSBzaWJsaW5ncyBuZWVkIAo+PiB0byByZW1haW4KPj4gYXZhaWxhYmxlIGZvciB0aGUgcHJp
bWFyeSBWTS4gQSBDUFUgcG9vbCBoYXMgdG8gYmUgc2V0IGZvciBORSAKPj4gcHVycG9zZXMgYnkg
YW4KPj4gQEAgLTYxLDcgKzYxLDcgQEAgZGV2aWNlIGlzIHBsYWNlZCBpbiBtZW1vcnkgYmVsb3cg
dGhlIHR5cGljYWwgNCBHaUIuCj4+IFRoZSBhcHBsaWNhdGlvbiB0aGF0IHJ1bnMgaW4gdGhlIGVu
Y2xhdmUgbmVlZHMgdG8gYmUgcGFja2FnZWQgaW4gYW4gCj4+IGVuY2xhdmUKPj4gaW1hZ2UgdG9n
ZXRoZXIgd2l0aCB0aGUgT1MgKCBlLmcuIGtlcm5lbCwgcmFtZGlzaywgaW5pdCApIHRoYXQgd2ls
bCAKPj4gcnVuIGluIHRoZQo+PiBlbmNsYXZlIFZNLiBUaGUgZW5jbGF2ZSBWTSBoYXMgaXRzIG93
biBrZXJuZWwgYW5kIGZvbGxvd3MgdGhlIAo+PiBzdGFuZGFyZCBMaW51eAo+PiAtYm9vdCBwcm90
b2NvbCBbNl0uCj4+ICtib290IHByb3RvY29sIFs2XVs4XS4KPj4KPj4gVGhlIGtlcm5lbCBieklt
YWdlLCB0aGUga2VybmVsIGNvbW1hbmQgbGluZSwgdGhlIHJhbWRpc2socykgYXJlIHBhcnQgCj4+
IG9mIHRoZQo+PiBFbmNsYXZlIEltYWdlIEZvcm1hdCAoRUlGKTsgcGx1cyBhbiBFSUYgaGVhZGVy
IGluY2x1ZGluZyBtZXRhZGF0YSAKPj4gc3VjaCBhcyBtYWdpYwo+PiBAQCAtOTMsMyArOTMsNSBA
QCBlbmNsYXZlIHByb2Nlc3MgY2FuIGV4aXQuCj4+IFs0XSAKPj4gaHR0cHM6Ly93d3cua2VybmVs
Lm9yZy9kb2MvaHRtbC9sYXRlc3QvYWRtaW4tZ3VpZGUva2VybmVsLXBhcmFtZXRlcnMuaHRtbAo+
PiBbNV0gaHR0cHM6Ly9tYW43Lm9yZy9saW51eC9tYW4tcGFnZXMvbWFuNy92c29jay43Lmh0bWwK
Pj4gWzZdIGh0dHBzOi8vd3d3Lmtlcm5lbC5vcmcvZG9jL2h0bWwvbGF0ZXN0L3g4Ni9ib290Lmh0
bWwKPj4gK1s3XSBodHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9odG1sL2xhdGVzdC9hcm02NC9o
dWdldGxicGFnZS5odG1sCj4+ICtbOF0gaHR0cHM6Ly93d3cua2VybmVsLm9yZy9kb2MvaHRtbC9s
YXRlc3QvYXJtNjQvYm9vdGluZy5odG1sCj4+IC0tIAo+PiAyLjIwLjEgKEFwcGxlIEdpdC0xMTcp
Cj4+Cj4+Cj4+Cj4+Cj4+IEFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5M
LiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiAKPj4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9v
ciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiAKPj4gUmVnaXN0ZXJlZCBp
biBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCj4+Cj4KCgoKCkFt
YXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmlj
ZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291bnR5
LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51
bWJlciBKMjIvMjYyMS8yMDA1Lgo=

