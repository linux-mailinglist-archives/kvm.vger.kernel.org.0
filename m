Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC76D445A33
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 20:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbhKDTGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 15:06:49 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:52974 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232376AbhKDTGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 15:06:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1636052651; x=1667588651;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=7bk/9wdh7+XoY6GwLet0GTcruYboDNkjOVFdn2g0NZM=;
  b=YC7/rbWzyPtSrvzNw2XHfCZhOZzhWxpOF7zcfAUKNnycZ9T4wDa8eo4o
   P1NFSBAQVHp6Hg66iFZiCtNBAwN05Ym3d0t5Kk1VCYpeqbREEsB8upbkX
   otX4vHOqt8ncBMPSPFyjV5D6BlyfpJf2I17359OGoYu0JGFlGIUfUZZdi
   Q=;
X-IronPort-AV: E=Sophos;i="5.87,209,1631577600"; 
   d="scan'208";a="157412626"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-90d70b14.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 04 Nov 2021 19:03:56 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-90d70b14.us-east-1.amazon.com (Postfix) with ESMTPS id 58A1CC0BC8;
        Thu,  4 Nov 2021 19:03:53 +0000 (UTC)
Received: from [192.168.11.85] (10.43.160.7) by EX13D16EUB003.ant.amazon.com
 (10.43.166.99) with Microsoft SMTP Server (TLS) id 15.0.1497.24; Thu, 4 Nov
 2021 19:03:47 +0000
Message-ID: <552d505f-eb45-3c91-bcb2-eb8c6b25352c@amazon.com>
Date:   Thu, 4 Nov 2021 21:03:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v3 1/7] nitro_enclaves: Enable Arm64 support
Content-Language: en-US
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     George-Aurelian Popescu <popegeo@amazon.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
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
 <f57fd0eb-271c-b8d7-ee9b-276c0f0c62ba@amazon.com>
 <YS3Peu/ax4gAVb6P@kroah.com>
 <2320e152-e2bf-14dd-e427-d26b936b6a83@amazon.com>
In-Reply-To: <2320e152-e2bf-14dd-e427-d26b936b6a83@amazon.com>
X-Originating-IP: [10.43.160.7]
X-ClientProxiedBy: EX13D30UWC004.ant.amazon.com (10.43.162.4) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAzMS8wOC8yMDIxIDEwOjUxLCBQYXJhc2NoaXYsIEFuZHJhLUlyaW5hIHdyb3RlOgo+IAo+
IAo+IE9uIDMxLzA4LzIwMjEgMDk6NDMsIEdyZWcgS0ggd3JvdGU6Cj4+IE9uIE1vbiwgQXVnIDMw
LCAyMDIxIGF0IDA5OjMwOjA0UE0gKzAzMDAsIFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEgd3JvdGU6
Cj4+Pgo+Pj4gT24gMzAvMDgvMjAyMSAxODo1OSwgR2VvcmdlLUF1cmVsaWFuIFBvcGVzY3Ugd3Jv
dGU6Cj4+Pj4gT24gRnJpLCBBdWcgMjcsIDIwMjEgYXQgMDY6NDk6MjRQTSArMDMwMCwgQW5kcmEg
UGFyYXNjaGl2IHdyb3RlOgo+Pj4+PiBVcGRhdGUgdGhlIGtlcm5lbCBjb25maWcgdG8gZW5hYmxl
IHRoZSBOaXRybyBFbmNsYXZlcyBrZXJuZWwgZHJpdmVyIAo+Pj4+PiBmb3IKPj4+Pj4gQXJtNjQg
c3VwcG9ydC4KPj4+Pj4KPj4+Pj4gU2lnbmVkLW9mZi1ieTogQW5kcmEgUGFyYXNjaGl2IDxhbmRy
YXByc0BhbWF6b24uY29tPgo+Pj4+PiBBY2tlZC1ieTogU3RlZmFubyBHYXJ6YXJlbGxhIDxzZ2Fy
emFyZUByZWRoYXQuY29tPgo+Pj4+PiAtLS0KPj4+Pj4gQ2hhbmdlbG9nCj4+Pj4+Cj4+Pj4+IHYx
IC0+IHYyCj4+Pj4+Cj4+Pj4+ICogTm8gY2hhbmdlcy4KPj4+Pj4KPj4+Pj4gdjIgLT4gdjMKPj4+
Pj4KPj4+Pj4gKiBNb3ZlIGNoYW5nZWxvZyBhZnRlciB0aGUgIi0tLSIgbGluZS4KPj4+Pj4gLS0t
Cj4+Pj4+IMKgwqAgZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL0tjb25maWcgfCA4ICsrLS0t
LS0tCj4+Pj4+IMKgwqAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlv
bnMoLSkKPj4+Pj4KPj4+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZl
cy9LY29uZmlnIAo+Pj4+PiBiL2RyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9LY29uZmlnCj4+
Pj4+IGluZGV4IDhjOTM4N2EyMzJkZjguLmY1Mzc0MGI5NDFjMGYgMTAwNjQ0Cj4+Pj4+IC0tLSBh
L2RyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9LY29uZmlnCj4+Pj4+ICsrKyBiL2RyaXZlcnMv
dmlydC9uaXRyb19lbmNsYXZlcy9LY29uZmlnCj4+Pj4+IEBAIC0xLDE3ICsxLDEzIEBACj4+Pj4+
IMKgwqAgIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMAo+Pj4+PiDCoMKgICMKPj4+
Pj4gLSMgQ29weXJpZ2h0IDIwMjAgQW1hem9uLmNvbSwgSW5jLiBvciBpdHMgYWZmaWxpYXRlcy4g
QWxsIFJpZ2h0cyAKPj4+Pj4gUmVzZXJ2ZWQuCj4+Pj4+ICsjIENvcHlyaWdodCAyMDIwLTIwMjEg
QW1hem9uLmNvbSwgSW5jLiBvciBpdHMgYWZmaWxpYXRlcy4gQWxsIAo+Pj4+PiBSaWdodHMgUmVz
ZXJ2ZWQuCj4+Pj4+IMKgwqAgIyBBbWF6b24gTml0cm8gRW5jbGF2ZXMgKE5FKSBzdXBwb3J0Lgo+
Pj4+PiDCoMKgICMgTml0cm8gaXMgYSBoeXBlcnZpc29yIHRoYXQgaGFzIGJlZW4gZGV2ZWxvcGVk
IGJ5IEFtYXpvbi4KPj4+Pj4gLSMgVE9ETzogQWRkIGRlcGVuZGVuY3kgZm9yIEFSTTY0IG9uY2Ug
TkUgaXMgc3VwcG9ydGVkIG9uIEFybSAKPj4+Pj4gcGxhdGZvcm1zLiBGb3Igbm93LAo+Pj4+PiAt
IyB0aGUgTkUga2VybmVsIGRyaXZlciBjYW4gYmUgYnVpbHQgZm9yIGFhcmNoNjQgYXJjaC4KPj4+
Pj4gLSMgZGVwZW5kcyBvbiAoQVJNNjQgfHwgWDg2KSAmJiBIT1RQTFVHX0NQVSAmJiBQQ0kgJiYg
U01QCj4+Pj4+IC0KPj4+Pj4gwqDCoCBjb25maWcgTklUUk9fRU5DTEFWRVMKPj4+Pj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqAgdHJpc3RhdGUgIk5pdHJvIEVuY2xhdmVzIFN1cHBvcnQiCj4+Pj4+IC0g
ZGVwZW5kcyBvbiBYODYgJiYgSE9UUExVR19DUFUgJiYgUENJICYmIFNNUAo+Pj4+PiArIGRlcGVu
ZHMgb24gKEFSTTY0IHx8IFg4NikgJiYgSE9UUExVR19DUFUgJiYgUENJICYmIFNNUAo+Pj4+PiDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBoZWxwCj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBU
aGlzIGRyaXZlciBjb25zaXN0cyBvZiBzdXBwb3J0IGZvciBlbmNsYXZlIGxpZmV0aW1lIAo+Pj4+
PiBtYW5hZ2VtZW50Cj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBmb3IgTml0cm8gRW5j
bGF2ZXMgKE5FKS4KPj4+Pj4gLS0gCj4+Pj4+IDIuMjAuMSAoQXBwbGUgR2l0LTExNykKPj4+Pj4K
Pj4+PiBSZXZpZXdlZC1ieTogR2VvcmdlLUF1cmVsaWFuIFBvcGVzY3UgPHBvcGVnZW9AYW1hem9u
LmNvbT4KPj4+Pgo+Pj4gVGhhbmtzLCBHZW9yZ2UsIGZvciByZXZpZXcuCj4+Pgo+Pj4gR3JlZywg
bGV0IG1lIGtub3cgaWYgb3RoZXIgdXBkYXRlcyBhcmUgbmVlZGVkIGZvciB0aGUgcGF0Y2ggc2Vy
aWVzLgo+Pj4gT3RoZXJ3aXNlLCBwbGVhc2UgaW5jbHVkZSB0aGUgcGF0Y2hlcyBpbiB0aGUgY2hh
ci1taXNjIHRyZWUgYW5kIHdlIGNhbgo+Pj4gdGFyZ2V0IHRoZSBjdXJyZW50IG1lcmdlIHdpbmRv
dywgZm9yIHY1LjE1LiBUaGFuayB5b3UuCj4+IEl0J3MgdG9vIGxhdGUgZm9yIDUuMTUtcmMxLCBJ
IHdpbGwgcXVldWUgdGhlbSB1cCBhZnRlciA1LjE1LXJjMSBpcyBvdXQsCj4+IHRoYW5rcy4KPiAK
PiBBY2ssIHRoYW5rcyBmb3IgaW5mby4gVGhlbiB3b3VsZCBiZSB0aGUgbmV4dCByYywgbm8gZnVu
Y3Rpb25hbCBjb2RlYmFzZSAKPiBjaGFuZ2VzIGJlaW5nIGluY2x1ZGVkLiBPciBqdXN0IGxldCBt
ZSBrbm93IGlmIG90aGVyIHJlbGVhc2UgcGhhc2Ugd291bGQgCj4gYmUgdGFyZ2V0ZWQuCgpJIHNl
ZSB0aGUgcGF0Y2ggc2VyaWVzIGhhcyBiZWVuIG1lcmdlZCBpbnRvIHRoZSBtYWlubGluZS4gVGhh
bmtzLCBHcmVnLgoKQW5kcmEKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkg
Uy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxv
b3IgMiwgSWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBS
b21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==

