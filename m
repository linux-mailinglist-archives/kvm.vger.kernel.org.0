Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CED2C6A82
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 18:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732158AbgK0RSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 12:18:34 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:59137 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731485AbgK0RSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Nov 2020 12:18:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606497510; x=1638033510;
  h=to:cc:references:from:subject:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=ZDsRW21yvSMTemLZASbYFkblDZ5o8TFcQuYu06fdz2U=;
  b=jONVFjC8PrNrQVTmAOgsi0SV826IyO77j5nzQe3D5ov5dD0hXcNtzfoZ
   EHv0yL+4QLwZU58aJDsueedQqK2QCGje3wRav1XW7WLVbFZohA1KHypVA
   Lnwg4gB5yBvN/3E/F4Yi+TSYOH2qgBZDd6FXPQQdaL+1eGBonBVi+3E2S
   s=;
X-IronPort-AV: E=Sophos;i="5.78,375,1599523200"; 
   d="scan'208";a="98530105"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 27 Nov 2020 17:18:21 +0000
Received: from EX13D08EUB004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 77698A176E;
        Fri, 27 Nov 2020 17:18:11 +0000 (UTC)
Received: from 4c32759f87cf.ant.amazon.com (10.43.160.21) by
 EX13D08EUB004.ant.amazon.com (10.43.166.158) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 27 Nov 2020 17:17:57 +0000
To:     Alexander Graf <graf@amazon.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jann Horn <jannh@google.com>
CC:     Willy Tarreau <w@1wt.eu>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
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
        Qemu Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        linux-s390 <linux-s390@vger.kernel.org>,
        "areber@redhat.com" <areber@redhat.com>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Andrey Vagin <avagin@gmail.com>,
        Mike Rapoport <rppt@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>
References: <3E05451B-A9CD-4719-99D0-72750A304044@amazon.com>
 <f78a0a2f-d26a-6b50-c252-b4610e5f8273@amazon.de>
From:   "Catangiu, Adrian Costin" <acatan@amazon.com>
Subject: Re: [PATCH v2] drivers/virt: vmgenid: add vm generation id driver
Message-ID: <ded94f0f-9c60-38b3-6217-03d3c0edd613@amazon.com>
Date:   Fri, 27 Nov 2020 19:17:53 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <f78a0a2f-d26a-6b50-c252-b4610e5f8273@amazon.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
X-Originating-IP: [10.43.160.21]
X-ClientProxiedBy: EX13D14UWB001.ant.amazon.com (10.43.161.158) To
 EX13D08EUB004.ant.amazon.com (10.43.166.158)
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDE4LzExLzIwMjAgMTI6MzAsIEFsZXhhbmRlciBHcmFmIHdyb3RlOgo+Cj4KPiBPbiAxNi4x
MS4yMCAxNjozNCwgQ2F0YW5naXUsIEFkcmlhbiBDb3N0aW4gd3JvdGU6Cj4+IC0gRnV0dXJlIGlt
cHJvdmVtZW50cwo+Pgo+PiBJZGVhbGx5IHdlIHdvdWxkIHdhbnQgdGhlIGRyaXZlciB0byByZWdp
c3RlciBpdHNlbGYgYmFzZWQgb24gZGV2aWNlcycKPj4gX0NJRCBhbmQgbm90IF9ISUQsIGJ1dCB1
bmZvcnR1bmF0ZWx5IEkgY291bGRuJ3QgZmluZCBhIHdheSB0byBkbyB0aGF0Lgo+PiBUaGUgcHJv
YmxlbSBpcyB0aGF0IEFDUEkgZGV2aWNlIG1hdGNoaW5nIGlzIGRvbmUgYnkKPj4gJ19fYWNwaV9t
YXRjaF9kZXZpY2UoKScgd2hpY2ggZXhjbHVzaXZlbHkgbG9va3MgYXQKPj4gJ2FjcGlfaGFyZHdh
cmVfaWQgKmh3aWQnLgo+Pgo+PiBUaGVyZSBpcyBhIHBhdGggZm9yIHBsYXRmb3JtIGRldmljZXMg
dG8gbWF0Y2ggb24gX0NJRCB3aGVuIF9ISUQgaXMKPj4gJ1BSUDAwMDEnIC0gYnV0IHRoaXMgaXMg
bm90IHRoZSBjYXNlIGZvciB0aGUgUWVtdSB2bWdlbmlkIGRldmljZS4KPj4KPj4gR3VpZGFuY2Ug
YW5kIGhlbHAgaGVyZSB3b3VsZCBiZSBncmVhdGx5IGFwcHJlY2lhdGVkLgo+Cj4gVGhhdCBvbmUg
aXMgcHJldHR5IGltcG9ydGFudCBJTUhPLiBIb3cgYWJvdXQgdGhlIGZvbGxvd2luZyAocHJvYmFi
bHkKPiBwcmV0dHkgbWFuZ2xlZCkgcGF0Y2g/IFRoYXQgc2VlbXMgdG8gd29yayBmb3IgbWUuIFRo
ZSBBQ1BJIGNoYW5nZQo+IHdvdWxkIG9idmlvdXNseSBuZWVkIHRvIGJlIGl0cyBvd24gc3RhbmQg
YWxvbmUgY2hhbmdlIGFuZCBuZWVkcyBwcm9wZXIKPiBhc3Nlc3NtZW50IHdoZXRoZXIgaXQgY291
bGQgcG9zc2libHkgYnJlYWsgYW55IGV4aXN0aW5nIHN5c3RlbXMuCj4KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9hY3BpL2J1cy5jIGIvZHJpdmVycy9hY3BpL2J1cy5jCj4gaW5kZXggMTY4MmY4YjQ1
NGEyLi40NTI0NDNkNzlkODcgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9hY3BpL2J1cy5jCj4gKysr
IGIvZHJpdmVycy9hY3BpL2J1cy5jCj4gQEAgLTc0OCw3ICs3NDgsNyBAQCBzdGF0aWMgYm9vbCBf
X2FjcGlfbWF0Y2hfZGV2aWNlKHN0cnVjdCBhY3BpX2RldmljZQo+ICpkZXZpY2UsCj4gwqDCoMKg
wqDCoMKgwqDCoCAvKiBGaXJzdCwgY2hlY2sgdGhlIEFDUEkvUE5QIElEcyBwcm92aWRlZCBieSB0
aGUgY2FsbGVyLiAqLwo+IMKgwqDCoMKgwqDCoMKgwqAgaWYgKGFjcGlfaWRzKSB7Cj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGZvciAoaWQgPSBhY3BpX2lkczsgaWQtPmlkWzBdIHx8IGlkLT5j
bHM7IGlkKyspIHsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChpZC0+aWRb
MF0gJiYgIXN0cmNtcCgoY2hhciAqKWlkLT5pZCwgaHdpZC0+aWQpKQo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgaWYgKGlkLT5pZFswXSAmJiAhc3RybmNtcCgoY2hhciAqKWlkLT5p
ZCwgaHdpZC0+aWQsCj4gQUNQSV9JRF9MRU4gLSAxKSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gb3V0X2FjcGlfbWF0Y2g7Cj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgaWYgKGlkLT5jbHMgJiYgX19hY3BpX21hdGNoX2RldmljZV9jbHMo
aWQsIGh3aWQpKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290
byBvdXRfYWNwaV9tYXRjaDsKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92aXJ0L3ZtZ2VuaWQuYyBi
L2RyaXZlcnMvdmlydC92bWdlbmlkLmMKPiBpbmRleCA3NWE3ODdkYThhYWQuLjBiZmE0MjJjZjA5
NCAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3ZpcnQvdm1nZW5pZC5jCj4gKysrIGIvZHJpdmVycy92
aXJ0L3ZtZ2VuaWQuYwo+IEBAIC0zNTYsNyArMzU2LDggQEAgc3RhdGljIHZvaWQgdm1nZW5pZF9h
Y3BpX25vdGlmeShzdHJ1Y3QgYWNwaV9kZXZpY2UKPiAqZGV2aWNlLCB1MzIgZXZlbnQpCj4gwqB9
Cj4KPiDCoHN0YXRpYyBjb25zdCBzdHJ1Y3QgYWNwaV9kZXZpY2VfaWQgdm1nZW5pZF9pZHNbXSA9
IHsKPiAtwqDCoMKgIHsiUUVNVVZHSUQiLCAwfSwKPiArwqDCoMKgIC8qIFRoaXMgcmVhbGx5IGlz
IFZNX0dlbl9Db3VudGVyLCBidXQgd2UgY2FuIG9ubHkgbWF0Y2ggOAo+IGNoYXJhY3RlcnMgKi8K
PiArwqDCoMKgIHsiVk1fR0VOX0MiLCAwfSwKPiDCoMKgwqDCoCB7IiIsIDB9LAo+IMKgfTsKPgoK
TG9va3MgbGVnaXQuIEkgY2FuIHByb3Bvc2UgYSBwYXRjaCB3aXRoIGl0LCBidXQgaG93IGRvIHdl
IHZhbGlkYXRlIGl0CmRvZXNuJ3QgYnJlYWsgYW55IGRldmljZXM/CgoKPj4gKzIpIEFTWU5DIHNp
bXBsaWZpZWQgZXhhbXBsZTo6Cj4+ICsKPj4gK8KgwqDCoCB2b2lkIGhhbmRsZV9pb19vbl92bWdl
bmZkKGludCB2bWdlbmZkKQo+PiArwqDCoMKgIHsKPj4gK8KgwqDCoMKgwqDCoMKgIHVuc2lnbmVk
IGdlbmlkOwo+PiArCj4+ICvCoMKgwqDCoMKgwqDCoCAvLyBiZWNhdXNlIG9mIFZNIGdlbmVyYXRp
b24gY2hhbmdlLCB3ZSBuZWVkIHRvIHJlYnVpbGQgd29ybGQKPj4gK8KgwqDCoMKgwqDCoMKgIHJl
c2VlZF9hcHBfZW52KCk7Cj4+ICsKPj4gK8KgwqDCoMKgwqDCoMKgIC8vIHJlYWQgbmV3IGdlbiBJ
RCAtIHdlIG5lZWQgaXQgdG8gY29uZmlybSB3ZSd2ZSBoYW5kbGVkIHVwZGF0ZQo+PiArwqDCoMKg
wqDCoMKgwqAgcmVhZChmZCwgJmdlbmlkLCBzaXplb2YoZ2VuaWQpKTsKPgo+IFRoaXMgaXMgcmFj
eSBpbiBjYXNlIHR3byBjb25zZWN1dGl2ZSBzbmFwc2hvdHMgaGFwcGVuLiBUaGUgcmVhZCBuZWVk
cwo+IHRvIGdvIGJlZm9yZSB0aGUgcmVzZWVkLgo+ClN3aXRjaGVkIHRoZW0gYXJvdW5kIGxpa2Ug
eW91IHN1Z2dlc3QgdG8gYXZvaWQgY29uZnVzaW9uLgoKQnV0IEkgZG9uJ3Qgc2VlIGEgcHJvYmxl
bSB3aXRoIHRoaXMgcmFjZS4gVGhlIGlkZWEgaGVyZSBpcyB0byB0cmlnZ2VyCnJlc2VlZF9hcHBf
ZW52KCkgd2hpY2ggZG9lc24ndCBkZXBlbmQgb24gdGhlIGdlbmVyYXRpb24gY291bnRlciB2YWx1
ZS4KV2hldGhlciBpdCBnZXRzIGluY3JlbWVudGVkIG9uY2Ugb3IgTiB0aW1lcyBpcyBpcnJlbGV2
YW50LCB3ZSdyZSBqdXN0CmludGVyZXN0ZWQgdGhhdCB3ZSBwYXVzZSBleGVjdXRpb24gYW5kIHJl
c2VlZCBiZWZvcmUgcmVzdW1pbmcgKGluCmJldHdlZW4gdGhlc2UsIHdoZXRoZXIgTiBvciBNIGdl
bmVyYXRpb24gY2hhbmdlcyBpcyB0aGUgc2FtZSB0aGluZykuCgo+PiArMykgTWFwcGVkIG1lbW9y
eSBwb2xsaW5nIHNpbXBsaWZpZWQgZXhhbXBsZTo6Cj4+ICsKPj4gK8KgwqDCoCAvKgo+PiArwqDC
oMKgwqAgKiBhcHAvbGlicmFyeSBmdW5jdGlvbiB0aGF0IHByb3ZpZGVzIGNhY2hlZCBzZWNyZXRz
Cj4+ICvCoMKgwqDCoCAqLwo+PiArwqDCoMKgIGNoYXIgKiBzYWZlX2NhY2hlZF9zZWNyZXQoYXBw
X2RhdGFfdCAqYXBwKQo+PiArwqDCoMKgIHsKPj4gK8KgwqDCoMKgwqDCoMKgIGNoYXIgKnNlY3Jl
dDsKPj4gK8KgwqDCoMKgwqDCoMKgIHZvbGF0aWxlIHVuc2lnbmVkICpjb25zdCBnZW5pZF9wdHIg
PSBnZXRfdm1nZW5pZF9tYXBwaW5nKGFwcCk7Cj4+ICvCoMKgwqAgYWdhaW46Cj4+ICvCoMKgwqDC
oMKgwqDCoCBzZWNyZXQgPSBfX2NhY2hlZF9zZWNyZXQoYXBwKTsKPj4gKwo+PiArwqDCoMKgwqDC
oMKgwqAgaWYgKHVubGlrZWx5KCpnZW5pZF9wdHIgIT0gYXBwLT5jYWNoZWRfZ2VuaWQpKSB7Cj4+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8vIHJlYnVpbGQgd29ybGQgdGhlbiBjb25maXJtIHRo
ZSBnZW5pZCB1cGRhdGUgKHRocnUgd3JpdGUpCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJl
YnVpbGRfY2FjaGVzKGFwcCk7Cj4+ICsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYXBwLT5j
YWNoZWRfZ2VuaWQgPSAqZ2VuaWRfcHRyOwo+Cj4gVGhpcyBpcyByYWN5IGFnYWluLiBZb3UgbmVl
ZCB0byByZWFkIHRoZSBnZW5pZCBiZWZvcmUgcmVidWlsZCBhbmQgc2V0Cj4gaXQgaGVyZS4KPgpJ
IGRvbid0IHNlZSB0aGUgcmFjZS4gR2VuIGNvdW50ZXIgaXMgcmVhZCBmcm9tIHZvbGF0aWxlIG1h
cHBlZCBtZW0sIG9uCmRldGVjdGVkIGNoYW5nZSB3ZSByZWJ1aWxkIHdvcmxkLCBjb25maXJtIHRo
ZSB1cGRhdGUgYmFjayB0byB0aGUgZHJpdmVyCnRoZW4gcmVzdGFydCB0aGUgbG9vcC4gTG9vcCB3
aWxsIGJyZWFrIHdoZW4gbm8gbW9yZSBjaGFuZ2VzIGhhcHBlbi4KCj4+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGFja192bWdlbmlkX3VwZGF0ZShhcHApOwo+PiArCj4+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGdvdG8gYWdhaW47Cj4+ICvCoMKgwqDCoMKgwqDCoCB9Cj4+ICsKPj4gK8KgwqDC
oMKgwqDCoMKgIHJldHVybiBzZWNyZXQ7Cj4+ICvCoMKgwqAgfQo+PiArCgo+PiArCj4+ICtzdGF0
aWMgaW50IHZtZ2VuaWRfY2xvc2Uoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZp
bGUpCj4+ICt7Cj4+ICvCoMKgwqAgc3RydWN0IGZpbGVfZGF0YSAqZmlsZV9kYXRhID0gZmlsZS0+
cHJpdmF0ZV9kYXRhOwo+PiArwqDCoMKgIHN0cnVjdCBkZXZfZGF0YSAqcHJpdiA9IGZpbGVfZGF0
YS0+ZGV2X2RhdGE7Cj4+ICsKPj4gK8KgwqDCoCBpZiAoZmlsZV9kYXRhLT5hY2tlZF9nZW5fY291
bnRlciAhPSBwcml2LT5nZW5lcmF0aW9uX2NvdW50ZXIpCj4+ICvCoMKgwqDCoMKgwqDCoCB2bWdl
bmlkX3B1dF9vdXRkYXRlZF93YXRjaGVycyhwcml2KTsKPgo+IElzIHRoaXMgcmFjeT8gQ291bGQg
dGhlcmUgYmUgYSBzbmFwc2hvdCBub3RpZmljYXRpb24gY29taW5nIGJldHdlZW4KPiB0aGUgYnJh
bmNoIGFuZCB0aGUgcHV0Pwo+ClRoaXMgaXMgaW5kZWVkIHJhY3ksIHdpbGwgZml4IGl0IGluIHBh
dGNoIHYzLgo+PiArwqDCoMKgIGF0b21pY19kZWMoJnByaXYtPndhdGNoZXJzKTsKPj4gK8KgwqDC
oCBrZnJlZShmaWxlX2RhdGEpOwo+PiArCj4+ICvCoMKgwqAgcmV0dXJuIDA7Cj4+ICt9Cgo+PiAr
c3RhdGljIHNzaXplX3Qgdm1nZW5pZF93cml0ZShzdHJ1Y3QgZmlsZSAqZmlsZSwgY29uc3QgY2hh
ciBfX3VzZXIKPj4gKnVidWYsCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2l6
ZV90IGNvdW50LCBsb2ZmX3QgKnBwb3MpCj4+ICt7Cj4+ICvCoMKgwqAgc3RydWN0IGZpbGVfZGF0
YSAqZmlsZV9kYXRhID0gZmlsZS0+cHJpdmF0ZV9kYXRhOwo+PiArwqDCoMKgIHN0cnVjdCBkZXZf
ZGF0YSAqcHJpdiA9IGZpbGVfZGF0YS0+ZGV2X2RhdGE7Cj4+ICvCoMKgwqAgdW5zaWduZWQgaW50
IGFja2VkX2dlbl9jb3VudDsKPj4gKwo+PiArwqDCoMKgIC8qIGRpc2FsbG93IHBhcnRpYWwgd3Jp
dGVzICovCj4+ICvCoMKgwqAgaWYgKGNvdW50ICE9IHNpemVvZihhY2tlZF9nZW5fY291bnQpKQo+
PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4+ICvCoMKgwqAgaWYgKGNvcHlfZnJv
bV91c2VyKCZhY2tlZF9nZW5fY291bnQsIHVidWYsIGNvdW50KSkKPj4gK8KgwqDCoMKgwqDCoMKg
IHJldHVybiAtRUZBVUxUOwo+PiArwqDCoMKgIC8qIHdyb25nIGdlbi1jb3VudGVyIGFja25vd2xl
ZGdlZCAqLwo+PiArwqDCoMKgIGlmIChhY2tlZF9nZW5fY291bnQgIT0gcHJpdi0+Z2VuZXJhdGlv
bl9jb3VudGVyKQo+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4+ICsKPj4gK8Kg
wqDCoCBpZiAoZmlsZV9kYXRhLT5hY2tlZF9nZW5fY291bnRlciAhPSBwcml2LT5nZW5lcmF0aW9u
X2NvdW50ZXIpIHsKPj4gK8KgwqDCoMKgwqDCoMKgIC8qIHVwZGF0ZSBsb2NhbCB2aWV3IG9mIFVV
SUQgKi8KPj4gK8KgwqDCoMKgwqDCoMKgIGZpbGVfZGF0YS0+YWNrZWRfZ2VuX2NvdW50ZXIgPSBh
Y2tlZF9nZW5fY291bnQ7Cj4+ICvCoMKgwqDCoMKgwqDCoCB2bWdlbmlkX3B1dF9vdXRkYXRlZF93
YXRjaGVycyhwcml2KTsKPgo+IFNhbWUgcXVlc3Rpb24gaGVyZTogV2hhdCBpZiB0aGVyZSBpcyBh
IG5vdGlmaWNhdGlvbiBiZXR3ZWVuIHRoZSBicmFuY2gKPiBhbmQgdGhlIHB1dD8KPgpSaWdodCwg
cmFjeSBoZXJlIGFzIHdlbGwuIFdpbGwgZml4IGluIHBhdGNoIHYzLgoKClRoYW5rcywKCkFkcmlh
bi4KCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3Rl
cmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElh
c2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0
cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=

