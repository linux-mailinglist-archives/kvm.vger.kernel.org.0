Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2212D11D1
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 14:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgLGNYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 08:24:21 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:35985 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgLGNYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 08:24:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1607347460; x=1638883460;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=AKThYDO30aCQlFxaLvsXPFC2329sFZnRjeS+VWSf47s=;
  b=YFO37trx+2Mbon+u3YAz0REi/WJ89qZywDRItBTBKkva2VFxlivzt+7t
   2DPk2k20FOWQ07cYDtN80tGP1WFTROFrZXUMk2tl1Y1LQSzPdFDGLd7Mt
   K5/CzRJUVfHZOqDjBow5YAEdNEci4e1L/rZlpqHFkaZQQR0ehWMYH/zWs
   w=;
X-IronPort-AV: E=Sophos;i="5.78,399,1599523200"; 
   d="scan'208";a="94007336"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 07 Dec 2020 13:23:30 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id D9B6AA06B8;
        Mon,  7 Dec 2020 13:23:20 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:23:20 +0000
Received: from freeip.amazon.com (10.43.162.252) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:23:09 +0000
Subject: Re: [PATCH v2] drivers/virt: vmgenid: add vm generation id driver
To:     "Catangiu, Adrian Costin" <acatan@amazon.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jann Horn <jannh@google.com>
CC:     Willy Tarreau <w@1wt.eu>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        "Eric Biggers" <ebiggers@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "oridgar@gmail.com" <oridgar@gmail.com>,
        "ghammer@redhat.com" <ghammer@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Qemu Developers" <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        "Michal Hocko" <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Pavel Machek" <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        linux-s390 <linux-s390@vger.kernel.org>,
        "areber@redhat.com" <areber@redhat.com>,
        "Pavel Emelyanov" <ovzxemul@gmail.com>,
        Andrey Vagin <avagin@gmail.com>,
        "Mike Rapoport" <rppt@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Pavel Tikhomirov" <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>
References: <3E05451B-A9CD-4719-99D0-72750A304044@amazon.com>
 <f78a0a2f-d26a-6b50-c252-b4610e5f8273@amazon.de>
 <ded94f0f-9c60-38b3-6217-03d3c0edd613@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <ee2ccb9f-c689-710d-0297-63d8fc2c98dd@amazon.de>
Date:   Mon, 7 Dec 2020 14:23:06 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <ded94f0f-9c60-38b3-6217-03d3c0edd613@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.252]
X-ClientProxiedBy: EX13D34UWA002.ant.amazon.com (10.43.160.245) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNy4xMS4yMCAxODoxNywgQ2F0YW5naXUsIEFkcmlhbiBDb3N0aW4gd3JvdGU6Cj4gCj4g
T24gMTgvMTEvMjAyMCAxMjozMCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+Cj4+Cj4+IE9uIDE2
LjExLjIwIDE2OjM0LCBDYXRhbmdpdSwgQWRyaWFuIENvc3RpbiB3cm90ZToKPj4+IC0gRnV0dXJl
IGltcHJvdmVtZW50cwo+Pj4KPj4+IElkZWFsbHkgd2Ugd291bGQgd2FudCB0aGUgZHJpdmVyIHRv
IHJlZ2lzdGVyIGl0c2VsZiBiYXNlZCBvbiBkZXZpY2VzJwo+Pj4gX0NJRCBhbmQgbm90IF9ISUQs
IGJ1dCB1bmZvcnR1bmF0ZWx5IEkgY291bGRuJ3QgZmluZCBhIHdheSB0byBkbyB0aGF0Lgo+Pj4g
VGhlIHByb2JsZW0gaXMgdGhhdCBBQ1BJIGRldmljZSBtYXRjaGluZyBpcyBkb25lIGJ5Cj4+PiAn
X19hY3BpX21hdGNoX2RldmljZSgpJyB3aGljaCBleGNsdXNpdmVseSBsb29rcyBhdAo+Pj4gJ2Fj
cGlfaGFyZHdhcmVfaWQgKmh3aWQnLgo+Pj4KPj4+IFRoZXJlIGlzIGEgcGF0aCBmb3IgcGxhdGZv
cm0gZGV2aWNlcyB0byBtYXRjaCBvbiBfQ0lEIHdoZW4gX0hJRCBpcwo+Pj4gJ1BSUDAwMDEnIC0g
YnV0IHRoaXMgaXMgbm90IHRoZSBjYXNlIGZvciB0aGUgUWVtdSB2bWdlbmlkIGRldmljZS4KPj4+
Cj4+PiBHdWlkYW5jZSBhbmQgaGVscCBoZXJlIHdvdWxkIGJlIGdyZWF0bHkgYXBwcmVjaWF0ZWQu
Cj4+Cj4+IFRoYXQgb25lIGlzIHByZXR0eSBpbXBvcnRhbnQgSU1ITy4gSG93IGFib3V0IHRoZSBm
b2xsb3dpbmcgKHByb2JhYmx5Cj4+IHByZXR0eSBtYW5nbGVkKSBwYXRjaD8gVGhhdCBzZWVtcyB0
byB3b3JrIGZvciBtZS4gVGhlIEFDUEkgY2hhbmdlCj4+IHdvdWxkIG9idmlvdXNseSBuZWVkIHRv
IGJlIGl0cyBvd24gc3RhbmQgYWxvbmUgY2hhbmdlIGFuZCBuZWVkcyBwcm9wZXIKPj4gYXNzZXNz
bWVudCB3aGV0aGVyIGl0IGNvdWxkIHBvc3NpYmx5IGJyZWFrIGFueSBleGlzdGluZyBzeXN0ZW1z
Lgo+Pgo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9hY3BpL2J1cy5jIGIvZHJpdmVycy9hY3BpL2J1
cy5jCj4+IGluZGV4IDE2ODJmOGI0NTRhMi4uNDUyNDQzZDc5ZDg3IDEwMDY0NAo+PiAtLS0gYS9k
cml2ZXJzL2FjcGkvYnVzLmMKPj4gKysrIGIvZHJpdmVycy9hY3BpL2J1cy5jCj4+IEBAIC03NDgs
NyArNzQ4LDcgQEAgc3RhdGljIGJvb2wgX19hY3BpX21hdGNoX2RldmljZShzdHJ1Y3QgYWNwaV9k
ZXZpY2UKPj4gKmRldmljZSwKPj4gIMKgwqDCoMKgwqDCoMKgwqAgLyogRmlyc3QsIGNoZWNrIHRo
ZSBBQ1BJL1BOUCBJRHMgcHJvdmlkZWQgYnkgdGhlIGNhbGxlci4gKi8KPj4gIMKgwqDCoMKgwqDC
oMKgwqAgaWYgKGFjcGlfaWRzKSB7Cj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZm9yIChp
ZCA9IGFjcGlfaWRzOyBpZC0+aWRbMF0gfHwgaWQtPmNsczsgaWQrKykgewo+PiAtwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChpZC0+aWRbMF0gJiYgIXN0cmNtcCgoY2hhciAqKWlk
LT5pZCwgaHdpZC0+aWQpKQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChp
ZC0+aWRbMF0gJiYgIXN0cm5jbXAoKGNoYXIgKilpZC0+aWQsIGh3aWQtPmlkLAo+PiBBQ1BJX0lE
X0xFTiAtIDEpKQo+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBn
b3RvIG91dF9hY3BpX21hdGNoOwo+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
aWYgKGlkLT5jbHMgJiYgX19hY3BpX21hdGNoX2RldmljZV9jbHMoaWQsIGh3aWQpKQo+PiAgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIG91dF9hY3BpX21hdGNo
Owo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92aXJ0L3ZtZ2VuaWQuYyBiL2RyaXZlcnMvdmlydC92
bWdlbmlkLmMKPj4gaW5kZXggNzVhNzg3ZGE4YWFkLi4wYmZhNDIyY2YwOTQgMTAwNjQ0Cj4+IC0t
LSBhL2RyaXZlcnMvdmlydC92bWdlbmlkLmMKPj4gKysrIGIvZHJpdmVycy92aXJ0L3ZtZ2VuaWQu
Ywo+PiBAQCAtMzU2LDcgKzM1Niw4IEBAIHN0YXRpYyB2b2lkIHZtZ2VuaWRfYWNwaV9ub3RpZnko
c3RydWN0IGFjcGlfZGV2aWNlCj4+ICpkZXZpY2UsIHUzMiBldmVudCkKPj4gIMKgfQo+Pgo+PiAg
wqBzdGF0aWMgY29uc3Qgc3RydWN0IGFjcGlfZGV2aWNlX2lkIHZtZ2VuaWRfaWRzW10gPSB7Cj4+
IC3CoMKgwqAgeyJRRU1VVkdJRCIsIDB9LAo+PiArwqDCoMKgIC8qIFRoaXMgcmVhbGx5IGlzIFZN
X0dlbl9Db3VudGVyLCBidXQgd2UgY2FuIG9ubHkgbWF0Y2ggOAo+PiBjaGFyYWN0ZXJzICovCj4+
ICvCoMKgwqAgeyJWTV9HRU5fQyIsIDB9LAo+PiAgwqDCoMKgwqAgeyIiLCAwfSwKPj4gIMKgfTsK
Pj4KPiAKPiBMb29rcyBsZWdpdC4gSSBjYW4gcHJvcG9zZSBhIHBhdGNoIHdpdGggaXQsIGJ1dCBo
b3cgZG8gd2UgdmFsaWRhdGUgaXQKPiBkb2Vzbid0IGJyZWFrIGFueSBkZXZpY2VzPwoKTWFpbmx5
IGJ5IHByb3Bvc2luZyBpdCBhbmQgc2VlaW5nIHdoYXQgdGhlIEFDUEkgbWFpbnRhaW5lcnMgc2F5
LiBNYXliZSAKdGhleSBoYXZlIGEgYmV0dGVyIGlkZWEgZXZlbi4gQXQgbGVhc3QgdGhpcyBleHBs
aWN0bHkgbnVkZ2VzIHRoZW0uCgo+IAo+IAo+Pj4gKzIpIEFTWU5DIHNpbXBsaWZpZWQgZXhhbXBs
ZTo6Cj4+PiArCj4+PiArwqDCoMKgIHZvaWQgaGFuZGxlX2lvX29uX3ZtZ2VuZmQoaW50IHZtZ2Vu
ZmQpCj4+PiArwqDCoMKgIHsKPj4+ICvCoMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBnZW5pZDsKPj4+
ICsKPj4+ICvCoMKgwqDCoMKgwqDCoCAvLyBiZWNhdXNlIG9mIFZNIGdlbmVyYXRpb24gY2hhbmdl
LCB3ZSBuZWVkIHRvIHJlYnVpbGQgd29ybGQKPj4+ICvCoMKgwqDCoMKgwqDCoCByZXNlZWRfYXBw
X2VudigpOwo+Pj4gKwo+Pj4gK8KgwqDCoMKgwqDCoMKgIC8vIHJlYWQgbmV3IGdlbiBJRCAtIHdl
IG5lZWQgaXQgdG8gY29uZmlybSB3ZSd2ZSBoYW5kbGVkIHVwZGF0ZQo+Pj4gK8KgwqDCoMKgwqDC
oMKgIHJlYWQoZmQsICZnZW5pZCwgc2l6ZW9mKGdlbmlkKSk7Cj4+Cj4+IFRoaXMgaXMgcmFjeSBp
biBjYXNlIHR3byBjb25zZWN1dGl2ZSBzbmFwc2hvdHMgaGFwcGVuLiBUaGUgcmVhZCBuZWVkcwo+
PiB0byBnbyBiZWZvcmUgdGhlIHJlc2VlZC4KPj4KPiBTd2l0Y2hlZCB0aGVtIGFyb3VuZCBsaWtl
IHlvdSBzdWdnZXN0IHRvIGF2b2lkIGNvbmZ1c2lvbi4KPiAKPiBCdXQgSSBkb24ndCBzZWUgYSBw
cm9ibGVtIHdpdGggdGhpcyByYWNlLiBUaGUgaWRlYSBoZXJlIGlzIHRvIHRyaWdnZXIKPiByZXNl
ZWRfYXBwX2VudigpIHdoaWNoIGRvZXNuJ3QgZGVwZW5kIG9uIHRoZSBnZW5lcmF0aW9uIGNvdW50
ZXIgdmFsdWUuCj4gV2hldGhlciBpdCBnZXRzIGluY3JlbWVudGVkIG9uY2Ugb3IgTiB0aW1lcyBp
cyBpcnJlbGV2YW50LCB3ZSdyZSBqdXN0Cj4gaW50ZXJlc3RlZCB0aGF0IHdlIHBhdXNlIGV4ZWN1
dGlvbiBhbmQgcmVzZWVkIGJlZm9yZSByZXN1bWluZyAoaW4KPiBiZXR3ZWVuIHRoZXNlLCB3aGV0
aGVyIE4gb3IgTSBnZW5lcmF0aW9uIGNoYW5nZXMgaXMgdGhlIHNhbWUgdGhpbmcpLgo+IAo+Pj4g
KzMpIE1hcHBlZCBtZW1vcnkgcG9sbGluZyBzaW1wbGlmaWVkIGV4YW1wbGU6Ogo+Pj4gKwo+Pj4g
K8KgwqDCoCAvKgo+Pj4gK8KgwqDCoMKgICogYXBwL2xpYnJhcnkgZnVuY3Rpb24gdGhhdCBwcm92
aWRlcyBjYWNoZWQgc2VjcmV0cwo+Pj4gK8KgwqDCoMKgICovCj4+PiArwqDCoMKgIGNoYXIgKiBz
YWZlX2NhY2hlZF9zZWNyZXQoYXBwX2RhdGFfdCAqYXBwKQo+Pj4gK8KgwqDCoCB7Cj4+PiArwqDC
oMKgwqDCoMKgwqAgY2hhciAqc2VjcmV0Owo+Pj4gK8KgwqDCoMKgwqDCoMKgIHZvbGF0aWxlIHVu
c2lnbmVkICpjb25zdCBnZW5pZF9wdHIgPSBnZXRfdm1nZW5pZF9tYXBwaW5nKGFwcCk7Cj4+PiAr
wqDCoMKgIGFnYWluOgo+Pj4gK8KgwqDCoMKgwqDCoMKgIHNlY3JldCA9IF9fY2FjaGVkX3NlY3Jl
dChhcHApOwo+Pj4gKwoKKmdlbmlkX3B0ciA9IDEKY2FjaGVkX2dlbmlkID0gMQoKPj4+ICvCoMKg
wqDCoMKgwqDCoCBpZiAodW5saWtlbHkoKmdlbmlkX3B0ciAhPSBhcHAtPmNhY2hlZF9nZW5pZCkp
IHsKCipnZW5pZF9wdHIgPSAyCmNhY2hlZF9nZW5pZCA9IDEKCj4+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAvLyByZWJ1aWxkIHdvcmxkIHRoZW4gY29uZmlybSB0aGUgZ2VuaWQgdXBkYXRlICh0
aHJ1IHdyaXRlKQo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmVidWlsZF9jYWNoZXMoYXBw
KTsKCmh5cGVydmlzb3IgdGFrZXMgYW5vdGhlciBzbmFwc2hvdCBkdXJpbmcgcmVidWlsZF9jYWNo
ZXMoKS4gUmVzdW1lIHBhdGggCmJ1bXBzIGdlbmlkCgo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgYXBwLT5jYWNoZWRfZ2VuaWQgPSAqZ2VuaWRfcHRyOwoKKmdlbmlkX3B0ciA9IDMKY2FjaGVk
X2dlbmlkID0gMwoKPj4KPj4gVGhpcyBpcyByYWN5IGFnYWluLiBZb3UgbmVlZCB0byByZWFkIHRo
ZSBnZW5pZCBiZWZvcmUgcmVidWlsZCBhbmQgc2V0Cj4+IGl0IGhlcmUuCj4+Cj4gSSBkb24ndCBz
ZWUgdGhlIHJhY2UuIEdlbiBjb3VudGVyIGlzIHJlYWQgZnJvbSB2b2xhdGlsZSBtYXBwZWQgbWVt
LCBvbgo+IGRldGVjdGVkIGNoYW5nZSB3ZSByZWJ1aWxkIHdvcmxkLCBjb25maXJtIHRoZSB1cGRh
dGUgYmFjayB0byB0aGUgZHJpdmVyCj4gdGhlbiByZXN0YXJ0IHRoZSBsb29wLiBMb29wIHdpbGwg
YnJlYWsgd2hlbiBubyBtb3JlIGNoYW5nZXMgaGFwcGVuLgoKU2VlIGFib3ZlLiBBZnRlciB0aGUg
b3V0bGluZWQgY291cnNlIG9mIHRoaW5ncywgdGhlIHNuYXBzaG90IHdpbGwgCmNvbnRhaW4gZGF0
YSB0aGF0IHdpbGwgYmUgaWRlbnRpY2FsIGJldHdlZW4gMiBzbmFwc2hvdHMuCgoKQWxleAoKCgpB
bWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDEx
NyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhh
biBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBI
UkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=

