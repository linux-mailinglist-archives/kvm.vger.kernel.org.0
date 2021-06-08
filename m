Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F4039F164
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 10:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhFHIxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 04:53:10 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:20144 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhFHIxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 04:53:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623142279; x=1654678279;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=N6RBoKNrZR6ObKEhbHq6cgmdt67tFWWbtGGJjfNP2VI=;
  b=Dgezlv15nw453W99vbBUUUWmvqFzPoEAcL4MC+lNolMUxVeK+5oyGECY
   A1PLu4zTr3nCtYEjcqQtiCeOjFraF4Z6xgUh2IpGGNwsRIypM+oMV+3N+
   I2idKjt+sTfaWQ0tjdyhOCahwAFION7YwCJ+fb8auIzQKG/v/VBRllYGb
   0=;
X-IronPort-AV: E=Sophos;i="5.83,257,1616457600"; 
   d="scan'208";a="129763419"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 08 Jun 2021 08:51:18 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com (Postfix) with ESMTPS id 94A68A1EE8;
        Tue,  8 Jun 2021 08:51:17 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 08:51:17 +0000
Received: from [192.168.19.4] (10.43.161.153) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Jun
 2021 08:51:15 +0000
Message-ID: <2c6375b0-e7e0-a19e-8cc9-a8b81a64dfc1@amazon.com>
Date:   Tue, 8 Jun 2021 10:48:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:90.0)
 Gecko/20100101 Thunderbird/90.0
Subject: Re: [PATCH 5/6] kvm/i386: Add support for user space MSR filtering
Content-Language: en-US
To:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>
References: <cover.1621885749.git.sidcha@amazon.de>
 <4c7ecaab0295e8420ee03baf37c7722e01bb81ce.1621885749.git.sidcha@amazon.de>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <4c7ecaab0295e8420ee03baf37c7722e01bb81ce.1621885749.git.sidcha@amazon.de>
X-Originating-IP: [10.43.161.153]
X-ClientProxiedBy: EX13D47UWC003.ant.amazon.com (10.43.162.70) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNC4wNS4yMSAyMjowMSwgU2lkZGhhcnRoIENoYW5kcmFzZWthcmFuIHdyb3RlOgo+IENo
ZWNrIGFuZCBlbmFibGUgdXNlciBzcGFjZSBNU1IgZmlsdGVyaW5nIGNhcGFiaWxpdHkgYW5kIGhh
bmRsZSBuZXcgZXhpdAo+IHJlYXNvbiBLVk1fRVhJVF9YODZfV1JNU1IuIFRoaXMgd2lsbCBiZSB1
c2VkIGluIGEgZm9sbG93IHVwIHBhdGNoIHRvCj4gaW1wbGVtZW50IGh5cGVyLXYgb3ZlcmxheSBw
YWdlcy4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBTaWRkaGFydGggQ2hhbmRyYXNla2FyYW4gPHNpZGNo
YUBhbWF6b24uZGU+CgpUaGlzIHBhdGNoIHdpbGwgYnJlYWsgYmlzZWN0aW9uLCBiZWNhdXNlIHdl
J3JlIG5vIGxvbmdlciBoYW5kbGluZyB0aGUgCndyaXRlcyBpbiBrZXJuZWwgc3BhY2UgYWZ0ZXIg
dGhpcywgYnV0IHdlIGFsc28gZG9uJ3QgaGF2ZSB1c2VyIHNwYWNlIApoYW5kbGluZyBhdmFpbGFi
bGUgeWV0LCByaWdodD8gSXQgbWlnaHQgYmUgYmV0dGVyIHRvIG1vdmUgYWxsIGxvZ2ljIGluIAp0
aGlzIHBhdGNoIHRoYXQgc2V0cyB1cCB0aGUgZmlsdGVyIGZvciBIeXBlci1WIE1TUnMgaW50byB0
aGUgbmV4dCBvbmUuCgo+IC0tLQo+ICAgdGFyZ2V0L2kzODYva3ZtL2t2bS5jIHwgNzIgKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwo+ICAgMSBmaWxlIGNoYW5nZWQs
IDcyIGluc2VydGlvbnMoKykKPiAKPiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L2kzODYva3ZtL2t2bS5j
IGIvdGFyZ2V0L2kzODYva3ZtL2t2bS5jCj4gaW5kZXggMzYyZjA0YWIzZi4uMzU5MWY4Y2VjYyAx
MDA2NDQKPiAtLS0gYS90YXJnZXQvaTM4Ni9rdm0va3ZtLmMKPiArKysgYi90YXJnZXQvaTM4Ni9r
dm0va3ZtLmMKPiBAQCAtMTE3LDYgKzExNyw4IEBAIHN0YXRpYyBib29sIGhhc19tc3JfdWNvZGVf
cmV2Owo+ICAgc3RhdGljIGJvb2wgaGFzX21zcl92bXhfcHJvY2Jhc2VkX2N0bHMyOwo+ICAgc3Rh
dGljIGJvb2wgaGFzX21zcl9wZXJmX2NhcGFiczsKPiAgIHN0YXRpYyBib29sIGhhc19tc3JfcGty
czsKPiArc3RhdGljIGJvb2wgaGFzX21zcl9maWx0ZXJpbmc7Cj4gK3N0YXRpYyBib29sIG1zcl9m
aWx0ZXJzX2FjdGl2ZTsKPiAgIAo+ICAgc3RhdGljIHVpbnQzMl90IGhhc19hcmNoaXRlY3R1cmFs
X3BtdV92ZXJzaW9uOwo+ICAgc3RhdGljIHVpbnQzMl90IG51bV9hcmNoaXRlY3R1cmFsX3BtdV9n
cF9jb3VudGVyczsKPiBAQCAtMjEzOCw2ICsyMTQwLDU3IEBAIHN0YXRpYyB2b2lkIHJlZ2lzdGVy
X3NtcmFtX2xpc3RlbmVyKE5vdGlmaWVyICpuLCB2b2lkICp1bnVzZWQpCj4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAmc21yYW1fYWRkcmVzc19zcGFjZSwgMSk7Cj4gICB9Cj4g
ICAKPiArc3RhdGljIHZvaWQga3ZtX3NldF9tc3JfZmlsdGVyX3JhbmdlKHN0cnVjdCBrdm1fbXNy
X2ZpbHRlcl9yYW5nZSAqcmFuZ2UsIHVpbnQzMl90IGZsYWdzLAo+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgdWludDMyX3QgYmFzZSwgdWludDMyX3Qgbm1zcnMsIC4uLikK
PiArewo+ICsgICAgaW50IGksIGZpbHRlcl90b191c2Vyc3BhY2U7Cj4gKyAgICB2YV9saXN0IGFw
Owo+ICsKPiArICAgIHJhbmdlLT5mbGFncyA9IGZsYWdzOwo+ICsgICAgcmFuZ2UtPm5tc3JzID0g
bm1zcnM7Cj4gKyAgICByYW5nZS0+YmFzZSA9IGJhc2U7Cj4gKwo+ICsgICAgdmFfc3RhcnQoYXAs
IG5tc3JzKTsKPiArICAgIGZvciAoaSA9IDA7IGkgPCBubXNyczsgaSsrKSB7Cj4gKyAgICAgICAg
ZmlsdGVyX3RvX3VzZXJzcGFjZSA9IHZhX2FyZyhhcCwgaW50KTsKPiArICAgICAgICBpZiAoIWZp
bHRlcl90b191c2Vyc3BhY2UpIHsKPiArICAgICAgICAgICAgcmFuZ2UtPmJpdG1hcFtpIC8gOF0g
PSAxIDw8IChpICUgOCk7Cj4gKyAgICAgICAgfQo+ICsgICAgfQo+ICsgICAgdmFfZW5kKGFwKTsK
PiArfQo+ICsKPiArc3RhdGljIGludCBrdm1fc2V0X21zcl9maWx0ZXJzKEtWTVN0YXRlICpzKQo+
ICt7Cj4gKyAgICBpbnQgciwgbm1zcnMsIG5maWx0ID0gMCwgYml0bWFwX3BvcyA9IDA7Cj4gKyAg
ICBzdHJ1Y3Qga3ZtX21zcl9maWx0ZXIgZmlsdGVyID0geyB9Owo+ICsgICAgc3RydWN0IGt2bV9t
c3JfZmlsdGVyX3JhbmdlICpyYW5nZTsKPiArICAgIHVpbnQ4X3QgYml0bWFwX2J1ZltLVk1fTVNS
X0ZJTFRFUl9NQVhfUkFOR0VTICogOF0gPSB7MH07Cj4gKwo+ICsgICAgZmlsdGVyLmZsYWdzID0g
S1ZNX01TUl9GSUxURVJfREVGQVVMVF9BTExPVzsKPiArCj4gKyAgICBpZiAoaGFzX2h5cGVydikg
ewo+ICsgICAgICAgIC8qIEh5cGVyLVYgb3ZlcmxheSBwYWdlIE1TUnMgKi8KCkkgdGhpbmsgeW91
IHdhbnQgdG8gZXh0ZW5kIHRoaXMgY29tbWVudCBhbmQgaW5kaWNhdGUgaW4gYSBodW1hbiByZWFk
YWJsZSAKZm9ybSB0aGF0IHlvdSBzZXQgdGhlIGZpbHRlciBvbiBXUk1TUiB0byB0cmFwIEhWX1g2
NF9NU1JfR1VFU1RfT1NfSUQgYW5kIApIVl9YNjRfTVNSX0hZUEVSQ0FMTCBpbnRvIHVzZXIgc3Bh
Y2UgaGVyZS4KCj4gKyAgICAgICAgbm1zcnMgPSAyOwo+ICsgICAgICAgIHJhbmdlID0gJmZpbHRl
ci5yYW5nZXNbbmZpbHQrK107Cj4gKyAgICAgICAgcmFuZ2UtPmJpdG1hcCA9ICZiaXRtYXBfYnVm
W2JpdG1hcF9wb3NdOwo+ICsgICAgICAgIGt2bV9zZXRfbXNyX2ZpbHRlcl9yYW5nZShyYW5nZSwg
S1ZNX01TUl9GSUxURVJfV1JJVEUsCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IEhWX1g2NF9NU1JfR1VFU1RfT1NfSUQsIG5tc3JzLAo+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB0cnVlLCAvKiBIVl9YNjRfTVNSX0dVRVNUX09TX0lEICovCj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHRydWUgIC8qIEhWX1g2NF9NU1JfSFlQRVJDQUxMICov
KTsKPiArICAgICAgICBiaXRtYXBfcG9zICs9IFJPVU5EX1VQKG5tc3JzLCA4KSAvIDg7Cj4gKyAg
ICAgICAgYXNzZXJ0KGJpdG1hcF9wb3MgPCBzaXplb2YoYml0bWFwX2J1ZikpOwo+ICsgICAgfQo+
ICsKPiArICAgIHIgPSBrdm1fdm1faW9jdGwocywgS1ZNX1g4Nl9TRVRfTVNSX0ZJTFRFUiwgJmZp
bHRlcik7Cj4gKyAgICBpZiAociAhPSAwKSB7Cj4gKyAgICAgICAgZXJyb3JfcmVwb3J0KCJrdm06
IGZhaWxlZCB0byBzZXQgTVNSIGZpbHRlcnMiKTsKPiArICAgICAgICByZXR1cm4gLTE7Cj4gKyAg
ICB9Cj4gKwo+ICsgICAgcmV0dXJuIDA7Cj4gK30KPiArCj4gICBpbnQga3ZtX2FyY2hfaW5pdChN
YWNoaW5lU3RhdGUgKm1zLCBLVk1TdGF0ZSAqcykKPiAgIHsKPiAgICAgICB1aW50NjRfdCBpZGVu
dGl0eV9iYXNlID0gMHhmZmZiYzAwMDsKPiBAQCAtMjI2OSw2ICsyMzIyLDE3IEBAIGludCBrdm1f
YXJjaF9pbml0KE1hY2hpbmVTdGF0ZSAqbXMsIEtWTVN0YXRlICpzKQo+ICAgICAgICAgICB9Cj4g
ICAgICAgfQo+ICAgCj4gKyAgICBoYXNfbXNyX2ZpbHRlcmluZyA9IGt2bV9jaGVja19leHRlbnNp
b24ocywgS1ZNX0NBUF9YODZfVVNFUl9TUEFDRV9NU1IpICYmCj4gKyAgICAgICAgICAgICAgICAg
ICAgICAgIGt2bV9jaGVja19leHRlbnNpb24ocywgS1ZNX0NBUF9YODZfTVNSX0ZJTFRFUik7Cj4g
KyAgICBpZiAoaGFzX21zcl9maWx0ZXJpbmcpIHsKPiArICAgICAgICByZXQgPSBrdm1fdm1fZW5h
YmxlX2NhcChzLCBLVk1fQ0FQX1g4Nl9VU0VSX1NQQUNFX01TUiwgMCwKPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBLVk1fTVNSX0VYSVRfUkVBU09OX0ZJTFRFUik7Cj4gKyAgICAg
ICAgaWYgKHJldCA9PSAwKSB7Cj4gKyAgICAgICAgICAgIHJldCA9IGt2bV9zZXRfbXNyX2ZpbHRl
cnMocyk7Cj4gKyAgICAgICAgICAgIG1zcl9maWx0ZXJzX2FjdGl2ZSA9IChyZXQgPT0gMCk7Cj4g
KyAgICAgICAgfQo+ICsgICAgfQo+ICsKPiAgICAgICByZXR1cm4gMDsKPiAgIH0KPiAgIAo+IEBA
IC00NTQyLDYgKzQ2MDYsMTEgQEAgc3RhdGljIGJvb2wgaG9zdF9zdXBwb3J0c192bXgodm9pZCkK
PiAgICAgICByZXR1cm4gZWN4ICYgQ1BVSURfRVhUX1ZNWDsKPiAgIH0KPiAgIAo+ICtzdGF0aWMg
aW50IGt2bV9oYW5kbGVfd3Jtc3IoWDg2Q1BVICpjcHUsIHN0cnVjdCBrdm1fcnVuICpydW4pCj4g
K3sKPiArICAgIHJldHVybiAwOwoKVGhlIGRlZmF1bHQgaGFuZGxlciBzaG91bGQgYWx3YXlzIHNl
dCBydW4tPm1zci5lcnJvciA9IDEgdG8gbWltaWMgdGhlIApleGlzdGluZyBiZWhhdmlvci4KCj4g
K30KPiArCj4gICAjZGVmaW5lIFZNWF9JTlZBTElEX0dVRVNUX1NUQVRFIDB4ODAwMDAwMjEKPiAg
IAo+ICAgaW50IGt2bV9hcmNoX2hhbmRsZV9leGl0KENQVVN0YXRlICpjcywgc3RydWN0IGt2bV9y
dW4gKnJ1bikKPiBAQCAtNDYwMCw2ICs0NjY5LDkgQEAgaW50IGt2bV9hcmNoX2hhbmRsZV9leGl0
KENQVVN0YXRlICpjcywgc3RydWN0IGt2bV9ydW4gKnJ1bikKPiAgICAgICAgICAgaW9hcGljX2Vv
aV9icm9hZGNhc3QocnVuLT5lb2kudmVjdG9yKTsKPiAgICAgICAgICAgcmV0ID0gMDsKPiAgICAg
ICAgICAgYnJlYWs7Cj4gKyAgICBjYXNlIEtWTV9FWElUX1g4Nl9XUk1TUjoKPiArICAgICAgICBy
ZXQgPSBrdm1faGFuZGxlX3dybXNyKGNwdSwgcnVuKTsKClBsZWFzZSBwcm92aWRlIGEgZGVmYXVs
dCBSRE1TUiBoYW5kbGVyIGFzIHdlbGwgaGVyZS4KCgpBbGV4Cgo+ICsgICAgICAgIGJyZWFrOwo+
ICAgICAgIGRlZmF1bHQ6Cj4gICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiS1ZNOiB1bmtub3du
IGV4aXQgcmVhc29uICVkXG4iLCBydW4tPmV4aXRfcmVhc29uKTsKPiAgICAgICAgICAgcmV0ID0g
LTE7Cj4gCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5z
dHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVn
ZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5i
dXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3
OQoKCg==

