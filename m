Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70CB3FBC72
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 20:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238823AbhH3SbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 14:31:25 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:51066 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238785AbhH3SbX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 14:31:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630348230; x=1661884230;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=yoVrCnckET1evT2qypahB9g3i1DhhfMeA2tu5O0/urQ=;
  b=I1hhG5GfIeEL5xG8dcZKFZbdCJZFsbrJRQAZjYg2xROWrYQJFcnpL8us
   +iE5to6HAUzLzlJ8vQWchfd2SMpgJcGwQpgrLzX8IEBT+WKaUr3jeMUcn
   FPorztRWvE9Nag+LjqdPuFftsaGKVsckPU4oOxOO5SMnpsi182z6JJZ3Z
   g=;
X-IronPort-AV: E=Sophos;i="5.84,364,1620691200"; 
   d="scan'208";a="22971413"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1e-c7f73527.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 30 Aug 2021 18:30:23 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-c7f73527.us-east-1.amazon.com (Postfix) with ESMTPS id DD1E7BDAB0;
        Mon, 30 Aug 2021 18:30:21 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.186) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 30 Aug 2021 18:30:16 +0000
Subject: Re: [PATCH v3 1/7] nitro_enclaves: Enable Arm64 support
To:     George-Aurelian Popescu <popegeo@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20210827154930.40608-1-andraprs@amazon.com>
 <20210827154930.40608-2-andraprs@amazon.com>
 <20210830155907.GG10224@u90cef543d0ab5a.ant.amazon.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <f57fd0eb-271c-b8d7-ee9b-276c0f0c62ba@amazon.com>
Date:   Mon, 30 Aug 2021 21:30:04 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210830155907.GG10224@u90cef543d0ab5a.ant.amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.186]
X-ClientProxiedBy: EX13D07UWA003.ant.amazon.com (10.43.160.35) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAzMC8wOC8yMDIxIDE4OjU5LCBHZW9yZ2UtQXVyZWxpYW4gUG9wZXNjdSB3cm90ZToKPiBP
biBGcmksIEF1ZyAyNywgMjAyMSBhdCAwNjo0OToyNFBNICswMzAwLCBBbmRyYSBQYXJhc2NoaXYg
d3JvdGU6Cj4+IFVwZGF0ZSB0aGUga2VybmVsIGNvbmZpZyB0byBlbmFibGUgdGhlIE5pdHJvIEVu
Y2xhdmVzIGtlcm5lbCBkcml2ZXIgZm9yCj4+IEFybTY0IHN1cHBvcnQuCj4+Cj4+IFNpZ25lZC1v
ZmYtYnk6IEFuZHJhIFBhcmFzY2hpdiA8YW5kcmFwcnNAYW1hem9uLmNvbT4KPj4gQWNrZWQtYnk6
IFN0ZWZhbm8gR2FyemFyZWxsYSA8c2dhcnphcmVAcmVkaGF0LmNvbT4KPj4gLS0tCj4+IENoYW5n
ZWxvZwo+Pgo+PiB2MSAtPiB2Mgo+Pgo+PiAqIE5vIGNoYW5nZXMuCj4+Cj4+IHYyIC0+IHYzCj4+
Cj4+ICogTW92ZSBjaGFuZ2Vsb2cgYWZ0ZXIgdGhlICItLS0iIGxpbmUuCj4+IC0tLQo+PiAgIGRy
aXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9LY29uZmlnIHwgOCArKy0tLS0tLQo+PiAgIDEgZmls
ZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMvS2NvbmZpZyBiL2RyaXZlcnMvdmlydC9u
aXRyb19lbmNsYXZlcy9LY29uZmlnCj4+IGluZGV4IDhjOTM4N2EyMzJkZjguLmY1Mzc0MGI5NDFj
MGYgMTAwNjQ0Cj4+IC0tLSBhL2RyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9LY29uZmlnCj4+
ICsrKyBiL2RyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9LY29uZmlnCj4+IEBAIC0xLDE3ICsx
LDEzIEBACj4+ICAgIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMAo+PiAgICMKPj4g
LSMgQ29weXJpZ2h0IDIwMjAgQW1hem9uLmNvbSwgSW5jLiBvciBpdHMgYWZmaWxpYXRlcy4gQWxs
IFJpZ2h0cyBSZXNlcnZlZC4KPj4gKyMgQ29weXJpZ2h0IDIwMjAtMjAyMSBBbWF6b24uY29tLCBJ
bmMuIG9yIGl0cyBhZmZpbGlhdGVzLiBBbGwgUmlnaHRzIFJlc2VydmVkLgo+PiAgIAo+PiAgICMg
QW1hem9uIE5pdHJvIEVuY2xhdmVzIChORSkgc3VwcG9ydC4KPj4gICAjIE5pdHJvIGlzIGEgaHlw
ZXJ2aXNvciB0aGF0IGhhcyBiZWVuIGRldmVsb3BlZCBieSBBbWF6b24uCj4+ICAgCj4+IC0jIFRP
RE86IEFkZCBkZXBlbmRlbmN5IGZvciBBUk02NCBvbmNlIE5FIGlzIHN1cHBvcnRlZCBvbiBBcm0g
cGxhdGZvcm1zLiBGb3Igbm93LAo+PiAtIyB0aGUgTkUga2VybmVsIGRyaXZlciBjYW4gYmUgYnVp
bHQgZm9yIGFhcmNoNjQgYXJjaC4KPj4gLSMgZGVwZW5kcyBvbiAoQVJNNjQgfHwgWDg2KSAmJiBI
T1RQTFVHX0NQVSAmJiBQQ0kgJiYgU01QCj4+IC0KPj4gICBjb25maWcgTklUUk9fRU5DTEFWRVMK
Pj4gICAJdHJpc3RhdGUgIk5pdHJvIEVuY2xhdmVzIFN1cHBvcnQiCj4+IC0JZGVwZW5kcyBvbiBY
ODYgJiYgSE9UUExVR19DUFUgJiYgUENJICYmIFNNUAo+PiArCWRlcGVuZHMgb24gKEFSTTY0IHx8
IFg4NikgJiYgSE9UUExVR19DUFUgJiYgUENJICYmIFNNUAo+PiAgIAloZWxwCj4+ICAgCSAgVGhp
cyBkcml2ZXIgY29uc2lzdHMgb2Ygc3VwcG9ydCBmb3IgZW5jbGF2ZSBsaWZldGltZSBtYW5hZ2Vt
ZW50Cj4+ICAgCSAgZm9yIE5pdHJvIEVuY2xhdmVzIChORSkuCj4+IC0tIAo+PiAyLjIwLjEgKEFw
cGxlIEdpdC0xMTcpCj4+Cj4gUmV2aWV3ZWQtYnk6IEdlb3JnZS1BdXJlbGlhbiBQb3Blc2N1IDxw
b3BlZ2VvQGFtYXpvbi5jb20+Cj4KClRoYW5rcywgR2VvcmdlLCBmb3IgcmV2aWV3LgoKR3JlZywg
bGV0IG1lIGtub3cgaWYgb3RoZXIgdXBkYXRlcyBhcmUgbmVlZGVkIGZvciB0aGUgcGF0Y2ggc2Vy
aWVzLiAKT3RoZXJ3aXNlLCBwbGVhc2UgaW5jbHVkZSB0aGUgcGF0Y2hlcyBpbiB0aGUgY2hhci1t
aXNjIHRyZWUgYW5kIHdlIGNhbiAKdGFyZ2V0IHRoZSBjdXJyZW50IG1lcmdlIHdpbmRvdywgZm9y
IHY1LjE1LiBUaGFuayB5b3UuCgpBbmRyYQoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChS
b21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBV
QkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3Rl
cmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

