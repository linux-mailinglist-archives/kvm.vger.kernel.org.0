Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC5D4436E8
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 21:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhKBUFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 16:05:21 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:34207 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhKBUFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 16:05:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1635883367; x=1667419367;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=T8LBLtsFEwmy6zb7QwWHHt7X8rl/w6GkvA3NJPrl0OQ=;
  b=WxmK9DEzqO7ianicR7+8Jp2J16IoCbezfbCyqKXrGEFKzdfV1+wnyv+Q
   wNaHHJbcS/aVSUM7UCSfo4AgN5q38U1b1+L4JNZMLfws1f7mxEiHnQJx+
   dgdAUEKZIa80aPRsto0yF8YbFsIy9XejlCSP8tOdgSdrGPcEZaCK7JJpb
   E=;
X-IronPort-AV: E=Sophos;i="5.87,203,1631577600"; 
   d="scan'208";a="38681449"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-b27d4a00.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 02 Nov 2021 20:02:30 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-b27d4a00.us-east-1.amazon.com (Postfix) with ESMTPS id 73ABE81605;
        Tue,  2 Nov 2021 20:02:27 +0000 (UTC)
Received: from [192.168.4.199] (10.43.162.89) by EX13D16EUB003.ant.amazon.com
 (10.43.166.99) with Microsoft SMTP Server (TLS) id 15.0.1497.24; Tue, 2 Nov
 2021 20:02:21 +0000
Message-ID: <65d5d6b8-03bc-772c-8d06-63989302e45c@amazon.com>
Date:   Tue, 2 Nov 2021 22:02:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v2] nitro_enclaves: Fix implicit type conversion
Content-Language: en-US
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
CC:     <linux-kernel@vger.kernel.org>, <lexnv@amazon.com>,
        <alcioa@amazon.com>, Greg KH <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "ne-devel-upstream@amazon.com" <ne-devel-upstream@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <1635472126-1822073-1-git-send-email-jiasheng@iscas.ac.cn>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
In-Reply-To: <1635472126-1822073-1-git-send-email-jiasheng@iscas.ac.cn>
X-Originating-IP: [10.43.162.89]
X-ClientProxiedBy: EX13D35UWB004.ant.amazon.com (10.43.161.230) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyOS8xMC8yMDIxIDA0OjQ4LCBKaWFzaGVuZyBKaWFuZyB3cm90ZToKPiAKPiBUaGUgdmFy
aWFibGUgJ2NwdScgYW5kICdjcHVfc2libGluZycgYXJlIGRlZmluZWQgYXMgdW5zaWduZWQgaW50
Lgo+IEhvd2V2ZXIgaW4gdGhlIGZvcl9lYWNoX2NwdSwgdGhlaXIgdmFsdWVzIGFyZSBhc3NpZ25l
ZCB0byAtMS4KPiBUaGF0IGRvZXNuJ3QgbWFrZSBzZW5zZSBhbmQgaW4gdGhlIGNwdW1hc2tfbmV4
dCgpIHRoZXkgYXJlIGltcGxpY2l0bHkKPiB0eXBlIGNvbnZlcnNlZCB0byBpbnQuCj4gSXQgaXMg
dW5pdmVyc2FsbHkgYWNjZXB0ZWQgdGhhdCB0aGUgaW1wbGljaXQgdHlwZSBjb252ZXJzaW9uIGlz
Cj4gdGVycmlibGUuCj4gQWxzbywgaGF2aW5nIHRoZSBnb29kIHByb2dyYW1taW5nIGN1c3RvbSB3
aWxsIHNldCBhbiBleGFtcGxlIGZvcgo+IG90aGVycy4KPiBUaHVzLCBpdCBtaWdodCBiZSBiZXR0
ZXIgdG8gY2hhbmdlIHRoZSBkZWZpbml0aW9uIG9mICdjcHUnIGFuZAo+ICdjcHVfc2libGluZycg
ZnJvbSB1bnNpZ25lZCBpbnQgdG8gaW50Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IEppYXNoZW5nIEpp
YW5nIDxqaWFzaGVuZ0Bpc2Nhcy5hYy5jbj4KPiAtLS0KPiAgIGRyaXZlcnMvdmlydC9uaXRyb19l
bmNsYXZlcy9uZV9taXNjX2Rldi5jIHwgMTQgKysrKysrKy0tLS0tLS0KPiAgIDEgZmlsZSBjaGFu
Z2VkLCA3IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9uZV9taXNjX2Rldi5jIGIvZHJpdmVycy92aXJ0L25p
dHJvX2VuY2xhdmVzL25lX21pc2NfZGV2LmMKPiBpbmRleCBlMjFlMWU4Li4yZDgwODc5IDEwMDY0
NAo+IC0tLSBhL2RyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9uZV9taXNjX2Rldi5jCj4gKysr
IGIvZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL25lX21pc2NfZGV2LmMKPiBAQCAtMTY4LDkg
KzE2OCw5IEBAIHN0YXRpYyBib29sIG5lX2NoZWNrX2VuY2xhdmVzX2NyZWF0ZWQodm9pZCkKPiAg
IHN0YXRpYyBpbnQgbmVfc2V0dXBfY3B1X3Bvb2woY29uc3QgY2hhciAqbmVfY3B1X2xpc3QpCj4g
ICB7Cj4gICAgICAgICAgaW50IGNvcmVfaWQgPSAtMTsKPiAtICAgICAgIHVuc2lnbmVkIGludCBj
cHUgPSAwOwo+ICsgICAgICAgaW50IGNwdSA9IDA7Cj4gICAgICAgICAgY3B1bWFza192YXJfdCBj
cHVfcG9vbDsKPiAtICAgICAgIHVuc2lnbmVkIGludCBjcHVfc2libGluZyA9IDA7Cj4gKyAgICAg
ICBpbnQgY3B1X3NpYmxpbmcgPSAwOwo+ICAgICAgICAgIHVuc2lnbmVkIGludCBpID0gMDsKPiAg
ICAgICAgICBpbnQgbnVtYV9ub2RlID0gLTE7Cj4gICAgICAgICAgaW50IHJjID0gLUVJTlZBTDsK
PiBAQCAtMzc0LDcgKzM3NCw3IEBAIHN0YXRpYyBpbnQgbmVfc2V0dXBfY3B1X3Bvb2woY29uc3Qg
Y2hhciAqbmVfY3B1X2xpc3QpCj4gICAgKi8KPiAgIHN0YXRpYyB2b2lkIG5lX3RlYXJkb3duX2Nw
dV9wb29sKHZvaWQpCj4gICB7Cj4gLSAgICAgICB1bnNpZ25lZCBpbnQgY3B1ID0gMDsKPiArICAg
ICAgIGludCBjcHUgPSAwOwo+ICAgICAgICAgIHVuc2lnbmVkIGludCBpID0gMDsKPiAgICAgICAg
ICBpbnQgcmMgPSAtRUlOVkFMOwo+IAo+IEBAIC01MTYsNyArNTE2LDcgQEAgc3RhdGljIGludCBu
ZV9nZXRfdW51c2VkX2NvcmVfZnJvbV9jcHVfcG9vbCh2b2lkKQo+ICAgc3RhdGljIGludCBuZV9z
ZXRfZW5jbGF2ZV90aHJlYWRzX3Blcl9jb3JlKHN0cnVjdCBuZV9lbmNsYXZlICpuZV9lbmNsYXZl
LAo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaW50IGNvcmVf
aWQsIHUzMiB2Y3B1X2lkKQo+ICAgewo+IC0gICAgICAgdW5zaWduZWQgaW50IGNwdSA9IDA7Cj4g
KyAgICAgICBpbnQgY3B1ID0gMDsKPiAKPiAgICAgICAgICBpZiAoY29yZV9pZCA8IDAgJiYgdmNw
dV9pZCA9PSAwKSB7Cj4gICAgICAgICAgICAgICAgICBkZXZfZXJyX3JhdGVsaW1pdGVkKG5lX21p
c2NfZGV2LnRoaXNfZGV2aWNlLAo+IEBAIC01NjIsNyArNTYyLDcgQEAgc3RhdGljIGludCBuZV9z
ZXRfZW5jbGF2ZV90aHJlYWRzX3Blcl9jb3JlKHN0cnVjdCBuZV9lbmNsYXZlICpuZV9lbmNsYXZl
LAo+ICAgc3RhdGljIGludCBuZV9nZXRfY3B1X2Zyb21fY3B1X3Bvb2woc3RydWN0IG5lX2VuY2xh
dmUgKm5lX2VuY2xhdmUsIHUzMiAqdmNwdV9pZCkKPiAgIHsKPiAgICAgICAgICBpbnQgY29yZV9p
ZCA9IC0xOwo+IC0gICAgICAgdW5zaWduZWQgaW50IGNwdSA9IDA7Cj4gKyAgICAgICBpbnQgY3B1
ID0gMDsKPiAgICAgICAgICB1bnNpZ25lZCBpbnQgaSA9IDA7Cj4gICAgICAgICAgaW50IHJjID0g
LUVJTlZBTDsKPiAKPiBAQCAtMTAxNyw3ICsxMDE3LDcgQEAgc3RhdGljIGludCBuZV9zdGFydF9l
bmNsYXZlX2lvY3RsKHN0cnVjdCBuZV9lbmNsYXZlICpuZV9lbmNsYXZlLAo+ICAgICAgICAgIHN0
cnVjdCBuZV9lbmNsYXZlX3N0YXJ0X2luZm8gKmVuY2xhdmVfc3RhcnRfaW5mbykKPiAgIHsKPiAg
ICAgICAgICBzdHJ1Y3QgbmVfcGNpX2Rldl9jbWRfcmVwbHkgY21kX3JlcGx5ID0ge307Cj4gLSAg
ICAgICB1bnNpZ25lZCBpbnQgY3B1ID0gMDsKPiArICAgICAgIGludCBjcHUgPSAwOwo+ICAgICAg
ICAgIHN0cnVjdCBlbmNsYXZlX3N0YXJ0X3JlcSBlbmNsYXZlX3N0YXJ0X3JlcSA9IHt9Owo+ICAg
ICAgICAgIHVuc2lnbmVkIGludCBpID0gMDsKPiAgICAgICAgICBzdHJ1Y3QgcGNpX2RldiAqcGRl
diA9IG5lX2RldnMubmVfcGNpX2Rldi0+cGRldjsKPiBAQCAtMTM2MCw3ICsxMzYwLDcgQEAgc3Rh
dGljIHZvaWQgbmVfZW5jbGF2ZV9yZW1vdmVfYWxsX21lbV9yZWdpb25fZW50cmllcyhzdHJ1Y3Qg
bmVfZW5jbGF2ZSAqbmVfZW5jbGEKPiAgICAqLwo+ICAgc3RhdGljIHZvaWQgbmVfZW5jbGF2ZV9y
ZW1vdmVfYWxsX3ZjcHVfaWRfZW50cmllcyhzdHJ1Y3QgbmVfZW5jbGF2ZSAqbmVfZW5jbGF2ZSkK
PiAgIHsKPiAtICAgICAgIHVuc2lnbmVkIGludCBjcHUgPSAwOwo+ICsgICAgICAgaW50IGNwdSA9
IDA7Cj4gICAgICAgICAgdW5zaWduZWQgaW50IGkgPSAwOwo+IAo+ICAgICAgICAgIG11dGV4X2xv
Y2soJm5lX2NwdV9wb29sLm11dGV4KTsKPiAtLQo+IDIuNy40Cj4gCgpSZXZpZXdlZC1ieTogQW5k
cmEgUGFyYXNjaGl2IDxhbmRyYXByc0BhbWF6b24uY29tPgoKQXMgYSBmb2xsb3ctdXAsIGluIGdl
bmVyYWwsIHdoZW4gc2VuZGluZyBuZXcgdmVyc2lvbnMgb2YgdGhlIHBhdGNoKGVzKSAKcGxlYXNl
IGFsc28gaW5jbHVkZSB0aGUgY2hhbmdlbG9nIGFmdGVyIHRoZSAiLS0tIiBsaW5lLiBGb3IgZXhh
bXBsZToKCi0tLQpDaGFuZ2Vsb2cKCnYxIC0+IHYyCgoqIENoYW5nZSAxLgoqIENoYW5nZSAyLgou
Li4uLi4uLi4uLgoKClRoYXQgaGVscHMgd2l0aCBwYXRjaChlcykgY2hhbmdlcyB0cmFja2luZy4K
ClRoYW5rcywKQW5kcmEKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5S
LkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3Ig
MiwgSWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21h
bmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==

