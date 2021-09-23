Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10992415AA1
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 11:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240067AbhIWJNm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 05:13:42 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:60083 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240022AbhIWJNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 05:13:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1632388331; x=1663924331;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=v4X1BIGL/DqHhTXBvwLBdIPfkx8V3Gd+NTzjIy3vOyk=;
  b=LT1TZ2P1eFeVn5npbO9U2QnhUBjH2x3cVGjGOZNeqcASkMScFhl4lfLB
   UWC3kPaCaiDsT+PNvk/Ff5TQCpvAPcnb2bNvd2g1Ctz7mdagzDuXYEd6j
   hZrtSQKUnKaSf3/EV1a4P/yUu0eK0AOhS9oOh1+A8Wu3lIBgHb1IOejld
   Q=;
X-IronPort-AV: E=Sophos;i="5.85,316,1624320000"; 
   d="scan'208";a="162038528"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 23 Sep 2021 09:12:03 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com (Postfix) with ESMTPS id C5D0941AB3;
        Thu, 23 Sep 2021 09:12:01 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 23 Sep 2021 09:12:01 +0000
Received: from [0.0.0.0] (10.43.162.36) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.23; Thu, 23 Sep
 2021 09:11:59 +0000
Message-ID: <08d356da-17ce-d380-1fc9-18ba7ec67020@amazon.com>
Date:   Thu, 23 Sep 2021 11:11:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:93.0)
 Gecko/20100101 Thunderbird/93.0
Subject: Re: [kvm-unit-tests PATCH] x86/msr.c generalize to any input msr
Content-Language: en-US
To:     yqwfh <amdeniulari@protonmail.com>, <kvm@vger.kernel.org>
CC:     Daniele Ahmed <ahmeddan@amazon.com>,
        Thomas Huth <thuth@redhat.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210810143029.2522-1-amdeniulari@protonmail.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <20210810143029.2522-1-amdeniulari@protonmail.com>
X-Originating-IP: [10.43.162.36]
X-ClientProxiedBy: EX13D20UWA003.ant.amazon.com (10.43.160.97) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRGFuaWVsZSEKCk9uIDEwLjA4LjIxIDE2OjMxLCB5cXdmaCB3cm90ZToKPiBJZiBhbiBNU1Ig
ZGVzY3JpcHRpb24gaXMgcHJvdmlkZWQgYXMgaW5wdXQgYnkgdGhlIHVzZXIsCj4gcnVuIHRoZSB0
ZXN0IGFnYWluc3QgdGhhdCBNU1IuIFRoaXMgYWxsb3dzIHRoZSB1c2VyIHRvCj4gcnVuIHRlc3Rz
IG9uIGN1c3RvbSBNU1Incy4KPiAKPiBPdGhlcndpc2UgcnVuIGFsbCBkZWZhdWx0IHRlc3RzLgoK
VGhpcyBwYXRjaCBkZXNjcmlwdGlvbiBpcyBtaXNzaW5nIHRoZSByYXRpb25hbGUuIEl0IGNvbWVz
IHRocm91Z2ggCmxpZ2h0bHkgd2hlcmUgeW91IHNheSAiVGhpcyBhbGxvd3MgdGhlIHVzZXIgdG8g
cnVuIHRlc3RzIG9uIGN1c3RvbSAKTVNScyIsIGJ1dCB0aGF0IHN0aWxsIGRvZXNuJ3QgZXhwbGFp
biB3aHkgeW91IHdvdWxkIG5lZWQgdGhhdCBmdW5jdGlvbmFsaXR5LgoKVGhlIG1vc3QgaW1wb3J0
YW50IHBpZWNlIHRvIHRyYW5zbWl0IGluIHRoZSBwYXRjaCBkZXNjcmlwdGlvbiBpcyBhbHdheXMg
CnRoZSAiV2h5Ii4gT25seSBhZnRlciB0aGF0IGl0IHNvcnRlZCwgeW91IG1vdmUgb24gdG8gYSBx
dWljayAiSG93Ii4KCj4gCj4gU2lnbmVkLW9mZi1ieTogRGFuaWVsZSBBaG1lZCA8YWhtZWRkYW5A
YW1hem9uLmNvbT4KClBsZWFzZSBzZW5kIHRoZSBlbWFpbCBmcm9tIHRoZSBzYW1lIGFjY291bnQg
dGhhdCB5b3VyIFNvQiBsaW5lIHF1b3RlcyA6KQoKSXQgdXN1YWxseSBhbHNvIGhlbHBzIHRvIEND
IHBlb3BsZSB0aGF0IHdvcmtlZCBvbiB0aGUgc2FtZSBmaWxlIGJlZm9yZS4gClVzdWFsbHksIGdl
dF9tYWludGFpbmVycy5wbCBzaG91bGQgZXh0cmFjdCB0aGF0IGxpc3QgYXV0b21hdGljYWxseSBm
b3IgCnlvdSBidXQgSSByZWFsaXplZCB0aGF0IHRoZXJlIGlzIG5vIHN1Y2ggZmlsZSBpbiB0aGUg
a3ZtLXVuaXQtdGVzdHMgdHJlZSAKZXZlbiB0aG91Z2ggd2UgaGF2ZSBhIE1BSU5UQUlORVJTIG9u
ZS4KClBhb2xvLCB3aGF0IGlzIHRoZSBtZXRob2QgeW91J2QgcHJlZmVyIHRvIGRldGVybWluZSB3
aG8gdG8gQ0Mgb24gCmt2bS11bml0LXRlc3RzIHN1Ym1pc3Npb25zPwoKPiAtLS0KPiAgIHg4Ni9t
c3IuYyB8IDQ4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0t
LQo+ICAgMSBmaWxlIGNoYW5nZWQsIDM0IGluc2VydGlvbnMoKyksIDE0IGRlbGV0aW9ucygtKQo+
IAo+IGRpZmYgLS1naXQgYS94ODYvbXNyLmMgYi94ODYvbXNyLmMKPiBpbmRleCA3YTU1MWM0Li41
NTQwMTRlIDEwMDY0NAo+IC0tLSBhL3g4Ni9tc3IuYwo+ICsrKyBiL3g4Ni9tc3IuYwo+IEBAIC0z
LDYgKzMsNyBAQAo+ICAgI2luY2x1ZGUgImxpYmNmbGF0LmgiCj4gICAjaW5jbHVkZSAicHJvY2Vz
c29yLmgiCj4gICAjaW5jbHVkZSAibXNyLmgiCj4gKyNpbmNsdWRlIDxzdGRsaWIuaD4KPiAgIAo+
ICAgc3RydWN0IG1zcl9pbmZvIHsKPiAgIAlpbnQgaW5kZXg7Cj4gQEAgLTc3LDI1ICs3OCw0NCBA
QCBzdGF0aWMgdm9pZCB0ZXN0X3JkbXNyX2ZhdWx0KHN0cnVjdCBtc3JfaW5mbyAqbXNyKQo+ICAg
CSAgICAgICAiRXhwZWN0ZWQgI0dQIG9uIFJEU01SKCVzKSwgZ290IHZlY3RvciAlZCIsIG1zci0+
bmFtZSwgdmVjdG9yKTsKPiAgIH0KPiAgIAo+ICtzdGF0aWMgdm9pZCB0ZXN0X21zcihzdHJ1Y3Qg
bXNyX2luZm8gKm1zciwgYm9vbCBpc182NGJpdF9ob3N0KQo+ICt7Cj4gKwlpZiAoaXNfNjRiaXRf
aG9zdCB8fCAhbXNyLT5pc182NGJpdF9vbmx5KSB7Cj4gKwkJdGVzdF9tc3JfcncobXNyLCBtc3It
PnZhbHVlKTsKPiArCj4gKwkJLyoKPiArCQkgKiBUaGUgNjQtYml0IG9ubHkgTVNScyB0aGF0IHRh
a2UgYW4gYWRkcmVzcyBhbHdheXMgcGVyZm9ybQo+ICsJCSAqIGNhbm9uaWNhbCBjaGVja3Mgb24g
Ym90aCBJbnRlbCBhbmQgQU1ELgo+ICsJCSAqLwo+ICsJCWlmIChtc3ItPmlzXzY0Yml0X29ubHkg
JiYKPiArCQkgICAgbXNyLT52YWx1ZSA9PSBhZGRyXzY0KQo+ICsJCQl0ZXN0X3dybXNyX2ZhdWx0
KG1zciwgTk9OQ0FOT05JQ0FMKTsKPiArCX0gZWxzZSB7Cj4gKwkJdGVzdF93cm1zcl9mYXVsdCht
c3IsIG1zci0+dmFsdWUpOwo+ICsJCXRlc3RfcmRtc3JfZmF1bHQobXNyKTsKPiArCX0KPiArfQo+
ICsKCkkgd291bGQgcHJlZmVyIGlmIHlvdSBzZXBhcmF0ZSB0aGUgImV4dHJhY3QgaW5kaXZpZHVh
bCBNU1IgbG9naWMgaW50byAKZnVuY3Rpb24iIHBhcnQgZnJvbSB0aGUgIkFkZCBhIG5ldyBtb2Rl
IG9mIG9wZXJhdGlvbiB0byB0ZXN0IGEgCnBhcnRpY3VsYXIgTVNSIiBwYXJ0IGludG8gdHdvIHNl
cGFyYXRlIHBhdGNoZXMuIFRoYXQgd2F5IGl0J3MgZWFzaWVyIHRvIApyZXZpZXcuCgo+ICAgaW50
IG1haW4oaW50IGFjLCBjaGFyICoqYXYpCj4gICB7Cj4gICAJYm9vbCBpc182NGJpdF9ob3N0ID0g
dGhpc19jcHVfaGFzKFg4Nl9GRUFUVVJFX0xNKTsKPiAgIAlpbnQgaTsKPiAgIAo+IC0JZm9yIChp
ID0gMCA7IGkgPCBBUlJBWV9TSVpFKG1zcl9pbmZvKTsgaSsrKSB7Cj4gLQkJaWYgKGlzXzY0Yml0
X2hvc3QgfHwgIW1zcl9pbmZvW2ldLmlzXzY0Yml0X29ubHkpIHsKPiAtCQkJdGVzdF9tc3Jfcnco
Jm1zcl9pbmZvW2ldLCBtc3JfaW5mb1tpXS52YWx1ZSk7Cj4gLQo+IC0JCQkvKgo+IC0JCQkgKiBU
aGUgNjQtYml0IG9ubHkgTVNScyB0aGF0IHRha2UgYW4gYWRkcmVzcyBhbHdheXMgcGVyZm9ybQo+
IC0JCQkgKiBjYW5vbmljYWwgY2hlY2tzIG9uIGJvdGggSW50ZWwgYW5kIEFNRC4KPiAtCQkJICov
Cj4gLQkJCWlmIChtc3JfaW5mb1tpXS5pc182NGJpdF9vbmx5ICYmCj4gLQkJCSAgICBtc3JfaW5m
b1tpXS52YWx1ZSA9PSBhZGRyXzY0KQo+IC0JCQkJdGVzdF93cm1zcl9mYXVsdCgmbXNyX2luZm9b
aV0sIE5PTkNBTk9OSUNBTCk7Cj4gLQkJfSBlbHNlIHsKPiAtCQkJdGVzdF93cm1zcl9mYXVsdCgm
bXNyX2luZm9baV0sIG1zcl9pbmZvW2ldLnZhbHVlKTsKPiAtCQkJdGVzdF9yZG1zcl9mYXVsdCgm
bXNyX2luZm9baV0pOwo+ICsJaWYgKGFjID09IDQpIHsKClRoaXMgbWVhbnMgeW91IHJlcXVpcmUg
MyBjb21wbGV0ZWx5IHVuZG9jdW1lbnRlZCBjb21tYW5kIGxpbmUgYXJndW1lbnRzLCAKbm8/IEkn
bSBzdXJlIGV2ZW4geW91IGFzIHRoZSBhdXRob3Igb2YgdGhpcyBwYXRjaCB3aWxsIGZvcmdldCB3
aGF0IHRoZXkgCmFyZSBpbiAyIHllYXJzIDopLgoKU2hvdWxkbid0IHRoZXJlIGJlIHNvbWUgZG9j
dW1lbnRhdGlvbiB0aGF0IGV4cGxhaW5zIHVzZXJzIHRoYXQgYW5kIGhvdyAKdGhleSBjYW4gdXNl
IHRoaXMgc3BlY2lhbCBtb2RlIG9mIG9wZXJhdGlvbiBzb21ld2hlcmU/Cgo+ICsJCWNoYXIgbXNy
X25hbWVbMTZdOwo+ICsJCWludCBpbmRleCA9IHN0cnRvdWwoYXZbMV0sIE5VTEwsIDB4MTApOwo+
ICsJCXNucHJpbnRmKG1zcl9uYW1lLCBzaXplb2YobXNyX25hbWUpLCAiTVNSOjB4JXgiLCBpbmRl
eCk7Cj4gKwo+ICsJCXN0cnVjdCBtc3JfaW5mbyBtc3IgPSB7Cj4gKwkJCS5pbmRleCA9IGluZGV4
LAo+ICsJCQkubmFtZSA9IG1zcl9uYW1lLAo+ICsJCQkuaXNfNjRiaXRfb25seSA9ICFzdHJjbXAo
YXZbM10sICIwIiksCgpXaHkgZG8geW91IG5lZWQgdG8gcGFzcyB0aGlzIHdoZW4geW91IGludm9r
ZSB0aGUgdGVzdCBtYW51YWxseT8KCj4gKwkJCS52YWx1ZSA9IHN0cnRvdWwoYXZbMl0sIE5VTEws
IDB4MTApCgpPdmVyYWxsLCB0aGUgY29tbWFuZCBsaW5lIHBhcnNpbmcgaXMgcHJldHR5IGFkIGhv
YyBhbmQgd291bGRuJ3Qgc2NhbGUgCndlbGwgd2l0aCB1cGRhdGVzLiBQYW9sbywgaXMgdGhlcmUg
YW55IGNvbW1vbiB0aGVtZSBvbiBjb21tYW5kIGxpbmUgCmFyZ3VtZW50IHBhc3Npbmc/IERvIHdl
IGRvIHRoaW5ncyBsaWtlIGNvbW1hbmQgbGluZSBvcHRpb25zPyBIZWxwIHRleHRzPyAKRG8gd2Ug
aGF2ZSBzb21ldGhpbmcgZXZlbiByZW1vdGVseSBzaW1pbGFyIHRvIGdldG9wdD8KCgpUaGFua3Ms
CgpBbGV4Cgo+ICsJCX07Cj4gKwkJdGVzdF9tc3IoJm1zciwgaXNfNjRiaXRfaG9zdCk7Cj4gKwl9
IGVsc2Ugewo+ICsJCWZvciAoaSA9IDAgOyBpIDwgQVJSQVlfU0laRShtc3JfaW5mbyk7IGkrKykg
ewo+ICsJCQl0ZXN0X21zcigmbXNyX2luZm9baV0sIGlzXzY0Yml0X2hvc3QpOwo+ICAgCQl9Cj4g
ICAJfQo+ICAgCj4gCgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApL
cmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4g
U2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFy
bG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5
IDIzNyA4NzkKCgo=

