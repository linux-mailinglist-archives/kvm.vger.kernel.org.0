Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A01C4BAE42
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 09:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436540AbfIWHBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 03:01:55 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:62331 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405142AbfIWHBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 03:01:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1569222112; x=1600758112;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=lxoGkydS2xlQnZCbAG1BhC8FukhUIw2MKznZ0p4xXWc=;
  b=EKGtv+6/2kXzOjGrWM3iZzX3VgaIQID2YN5eqDv+86S+jd6QnVij9VR4
   cGq2/v/sKSuoGgUvN5+P2Jx2dr9rtyl4vnzkjCVjghXMGwN6V2nXZ5bUm
   xZNikB2ww7AT7NwhFEBbIfzb+KnrG8+Po4LbdWeNI2RVbEPSP7rCc0pnB
   Q=;
X-IronPort-AV: E=Sophos;i="5.64,539,1559520000"; 
   d="scan'208";a="786630338"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 23 Sep 2019 07:01:49 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com (Postfix) with ESMTPS id B7EE7A1C97;
        Mon, 23 Sep 2019 07:01:44 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 23 Sep 2019 07:01:43 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.5) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 23 Sep 2019 07:01:39 +0000
Subject: Re: [PATCH v7 18/21] RISC-V: KVM: Add SBI v0.1 support
To:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "Christoph Hellwig" <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190904161245.111924-1-anup.patel@wdc.com>
 <20190904161245.111924-20-anup.patel@wdc.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <d144652e-898b-bf6b-dc73-352fb1fffd40@amazon.com>
Date:   Mon, 23 Sep 2019 09:01:36 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190904161245.111924-20-anup.patel@wdc.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.5]
X-ClientProxiedBy: EX13D27UWA002.ant.amazon.com (10.43.160.30) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNC4wOS4xOSAxODoxNiwgQW51cCBQYXRlbCB3cm90ZToKPiBGcm9tOiBBdGlzaCBQYXRy
YSA8YXRpc2gucGF0cmFAd2RjLmNvbT4KPiAKPiBUaGUgS1ZNIGhvc3Qga2VybmVsIHJ1bm5pbmcg
aW4gSFMtbW9kZSBuZWVkcyB0byBoYW5kbGUgU0JJIGNhbGxzIGNvbWluZwo+IGZyb20gZ3Vlc3Qg
a2VybmVsIHJ1bm5pbmcgaW4gVlMtbW9kZS4KPiAKPiBUaGlzIHBhdGNoIGFkZHMgU0JJIHYwLjEg
c3VwcG9ydCBpbiBLVk0gUklTQy1WLiBBbGwgdGhlIFNCSSBjYWxscyBhcmUKPiBpbXBsZW1lbnRl
ZCBjb3JyZWN0bHkgZXhjZXB0IHJlbW90ZSB0bGIgZmx1c2hlcy4gRm9yIHJlbW90ZSBUTEIgZmx1
c2hlcywKPiB3ZSBhcmUgZG9pbmcgZnVsbCBUTEIgZmx1c2ggYW5kIHRoaXMgd2lsbCBiZSBvcHRp
bWl6ZWQgaW4gZnV0dXJlLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEF0aXNoIFBhdHJhIDxhdGlzaC5w
YXRyYUB3ZGMuY29tPgo+IFNpZ25lZC1vZmYtYnk6IEFudXAgUGF0ZWwgPGFudXAucGF0ZWxAd2Rj
LmNvbT4KPiBBY2tlZC1ieTogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4KPiBS
ZXZpZXdlZC1ieTogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4KPiAtLS0KPiAg
IGFyY2gvcmlzY3YvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCB8ICAgMiArCj4gICBhcmNoL3Jpc2N2
L2t2bS9NYWtlZmlsZSAgICAgICAgICAgfCAgIDIgKy0KPiAgIGFyY2gvcmlzY3Yva3ZtL3ZjcHVf
ZXhpdC5jICAgICAgICB8ICAgMyArCj4gICBhcmNoL3Jpc2N2L2t2bS92Y3B1X3NiaS5jICAgICAg
ICAgfCAxMDQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4gICA0IGZpbGVzIGNoYW5n
ZWQsIDExMCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4gICBjcmVhdGUgbW9kZSAxMDA2
NDQgYXJjaC9yaXNjdi9rdm0vdmNwdV9zYmkuYwo+IAo+IGRpZmYgLS1naXQgYS9hcmNoL3Jpc2N2
L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggYi9hcmNoL3Jpc2N2L2luY2x1ZGUvYXNtL2t2bV9ob3N0
LmgKPiBpbmRleCA5MjhjNjc4MjhiMWIuLjI2OWJmYTU2NDFiMSAxMDA2NDQKPiAtLS0gYS9hcmNo
L3Jpc2N2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKPiArKysgYi9hcmNoL3Jpc2N2L2luY2x1ZGUv
YXNtL2t2bV9ob3N0LmgKPiBAQCAtMjUwLDQgKzI1MCw2IEBAIGJvb2wga3ZtX3Jpc2N2X3ZjcHVf
aGFzX2ludGVycnVwdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOwo+ICAgdm9pZCBrdm1fcmlzY3Zf
dmNwdV9wb3dlcl9vZmYoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsKPiAgIHZvaWQga3ZtX3Jpc2N2
X3ZjcHVfcG93ZXJfb24oc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsKPiAgIAo+ICtpbnQga3ZtX3Jp
c2N2X3ZjcHVfc2JpX2VjYWxsKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7Cj4gKwo+ICAgI2VuZGlm
IC8qIF9fUklTQ1ZfS1ZNX0hPU1RfSF9fICovCj4gZGlmZiAtLWdpdCBhL2FyY2gvcmlzY3Yva3Zt
L01ha2VmaWxlIGIvYXJjaC9yaXNjdi9rdm0vTWFrZWZpbGUKPiBpbmRleCAzZTBjNzU1ODMyMGQu
LmI1NmRjMTY1MGQyYyAxMDA2NDQKPiAtLS0gYS9hcmNoL3Jpc2N2L2t2bS9NYWtlZmlsZQo+ICsr
KyBiL2FyY2gvcmlzY3Yva3ZtL01ha2VmaWxlCj4gQEAgLTksNiArOSw2IEBAIGNjZmxhZ3MteSA6
PSAtSXZpcnQva3ZtIC1JYXJjaC9yaXNjdi9rdm0KPiAgIGt2bS1vYmpzIDo9ICQoY29tbW9uLW9i
anMteSkKPiAgIAo+ICAga3ZtLW9ianMgKz0gbWFpbi5vIHZtLm8gdm1pZC5vIHRsYi5vIG1tdS5v
Cj4gLWt2bS1vYmpzICs9IHZjcHUubyB2Y3B1X2V4aXQubyB2Y3B1X3N3aXRjaC5vIHZjcHVfdGlt
ZXIubwo+ICtrdm0tb2JqcyArPSB2Y3B1Lm8gdmNwdV9leGl0Lm8gdmNwdV9zd2l0Y2gubyB2Y3B1
X3RpbWVyLm8gdmNwdV9zYmkubwo+ICAgCj4gICBvYmotJChDT05GSUdfS1ZNKQkrPSBrdm0ubwo+
IGRpZmYgLS1naXQgYS9hcmNoL3Jpc2N2L2t2bS92Y3B1X2V4aXQuYyBiL2FyY2gvcmlzY3Yva3Zt
L3ZjcHVfZXhpdC5jCj4gaW5kZXggMzk0NjlmNjdiMjQxLi4wZWU0ZTg5NDNmNGYgMTAwNjQ0Cj4g
LS0tIGEvYXJjaC9yaXNjdi9rdm0vdmNwdV9leGl0LmMKPiArKysgYi9hcmNoL3Jpc2N2L2t2bS92
Y3B1X2V4aXQuYwo+IEBAIC01OTQsNiArNTk0LDkgQEAgaW50IGt2bV9yaXNjdl92Y3B1X2V4aXQo
c3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qga3ZtX3J1biAqcnVuLAo+ICAgCQkgICAgKHZj
cHUtPmFyY2guZ3Vlc3RfY29udGV4dC5oc3RhdHVzICYgSFNUQVRVU19TVEwpKQo+ICAgCQkJcmV0
ID0gc3RhZ2UyX3BhZ2VfZmF1bHQodmNwdSwgcnVuLCBzY2F1c2UsIHN0dmFsKTsKPiAgIAkJYnJl
YWs7Cj4gKwljYXNlIEVYQ19TVVBFUlZJU09SX1NZU0NBTEw6Cj4gKwkJaWYgKHZjcHUtPmFyY2gu
Z3Vlc3RfY29udGV4dC5oc3RhdHVzICYgSFNUQVRVU19TUFYpCj4gKwkJCXJldCA9IGt2bV9yaXNj
dl92Y3B1X3NiaV9lY2FsbCh2Y3B1KTsKCmltcGxpY2l0IGZhbGwtdGhyb3VnaAoKPiAgIAlkZWZh
dWx0Ogo+ICAgCQlicmVhazsKPiAgIAl9Owo+IGRpZmYgLS1naXQgYS9hcmNoL3Jpc2N2L2t2bS92
Y3B1X3NiaS5jIGIvYXJjaC9yaXNjdi9rdm0vdmNwdV9zYmkuYwo+IG5ldyBmaWxlIG1vZGUgMTAw
NjQ0Cj4gaW5kZXggMDAwMDAwMDAwMDAwLi5iNDE1YjhiNTRiYjEKPiAtLS0gL2Rldi9udWxsCj4g
KysrIGIvYXJjaC9yaXNjdi9rdm0vdmNwdV9zYmkuYwo+IEBAIC0wLDAgKzEsMTA0IEBACj4gKy8v
IFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wCj4gKy8qKgo+ICsgKiBDb3B5cmlnaHQg
KGMpIDIwMTkgV2VzdGVybiBEaWdpdGFsIENvcnBvcmF0aW9uIG9yIGl0cyBhZmZpbGlhdGVzLgo+
ICsgKgo+ICsgKiBBdXRob3JzOgo+ICsgKiAgICAgQXRpc2ggUGF0cmEgPGF0aXNoLnBhdHJhQHdk
Yy5jb20+Cj4gKyAqLwo+ICsKPiArI2luY2x1ZGUgPGxpbnV4L2Vycm5vLmg+Cj4gKyNpbmNsdWRl
IDxsaW51eC9lcnIuaD4KPiArI2luY2x1ZGUgPGxpbnV4L2t2bV9ob3N0Lmg+Cj4gKyNpbmNsdWRl
IDxhc20vY3NyLmg+Cj4gKyNpbmNsdWRlIDxhc20va3ZtX3ZjcHVfdGltZXIuaD4KPiArCj4gKyNk
ZWZpbmUgU0JJX1ZFUlNJT05fTUFKT1IJCQkwCj4gKyNkZWZpbmUgU0JJX1ZFUlNJT05fTUlOT1IJ
CQkxCj4gKwo+ICtzdGF0aWMgdm9pZCBrdm1fc2JpX3N5c3RlbV9zaHV0ZG93bihzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUsIHUzMiB0eXBlKQo+ICt7Cj4gKwlpbnQgaTsKPiArCXN0cnVjdCBrdm1fdmNw
dSAqdG1wOwo+ICsKPiArCWt2bV9mb3JfZWFjaF92Y3B1KGksIHRtcCwgdmNwdS0+a3ZtKQo+ICsJ
CXRtcC0+YXJjaC5wb3dlcl9vZmYgPSB0cnVlOwo+ICsJa3ZtX21ha2VfYWxsX2NwdXNfcmVxdWVz
dCh2Y3B1LT5rdm0sIEtWTV9SRVFfU0xFRVApOwo+ICsKPiArCW1lbXNldCgmdmNwdS0+cnVuLT5z
eXN0ZW1fZXZlbnQsIDAsIHNpemVvZih2Y3B1LT5ydW4tPnN5c3RlbV9ldmVudCkpOwo+ICsJdmNw
dS0+cnVuLT5zeXN0ZW1fZXZlbnQudHlwZSA9IHR5cGU7Cj4gKwl2Y3B1LT5ydW4tPmV4aXRfcmVh
c29uID0gS1ZNX0VYSVRfU1lTVEVNX0VWRU5UOwoKSXMgdGhlcmUgYSBwYXJ0aWN1bGFyIHJlYXNv
biB0aGlzIGhhcyB0byBiZSBpbXBsZW1lbnRlZCBpbiBrZXJuZWwgc3BhY2U/IApJdCdzIG5vdCBw
ZXJmb3JtYW5jZSBjcml0aWNhbCBhbmQgYWxsIHN0b3BwaW5nIHZjcHVzIGlzIHNvbWV0aGluZyB1
c2VyIApzcGFjZSBzaG91bGQgYmUgYWJsZSB0byBkbyBhcyB3ZWxsLCBubz8KCj4gK30KPiArCj4g
K2ludCBrdm1fcmlzY3ZfdmNwdV9zYmlfZWNhbGwoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+ICt7
Cj4gKwlpbnQgaSwgcmV0ID0gMTsKPiArCXU2NCBuZXh0X2N5Y2xlOwo+ICsJc3RydWN0IGt2bV92
Y3B1ICpydmNwdTsKPiArCWJvb2wgbmV4dF9zZXBjID0gdHJ1ZTsKPiArCXVsb25nIGhtYXNrLCB1
dF9zY2F1c2UgPSAwOwo+ICsJc3RydWN0IGt2bV9jcHVfY29udGV4dCAqY3AgPSAmdmNwdS0+YXJj
aC5ndWVzdF9jb250ZXh0Owo+ICsKPiArCWlmICghY3ApCj4gKwkJcmV0dXJuIC1FSU5WQUw7Cj4g
Kwo+ICsJc3dpdGNoIChjcC0+YTcpIHsKPiArCWNhc2UgU0JJX1NFVF9USU1FUjoKPiArI2lmIF9f
cmlzY3ZfeGxlbiA9PSAzMgo+ICsJCW5leHRfY3ljbGUgPSAoKHU2NCljcC0+YTEgPDwgMzIpIHwg
KHU2NCljcC0+YTA7Cj4gKyNlbHNlCj4gKwkJbmV4dF9jeWNsZSA9ICh1NjQpY3AtPmEwOwo+ICsj
ZW5kaWYKPiArCQlrdm1fcmlzY3ZfdmNwdV90aW1lcl9uZXh0X2V2ZW50KHZjcHUsIG5leHRfY3lj
bGUpOwo+ICsJCWJyZWFrOwo+ICsJY2FzZSBTQklfQ0xFQVJfSVBJOgo+ICsJCWt2bV9yaXNjdl92
Y3B1X3Vuc2V0X2ludGVycnVwdCh2Y3B1LCBJUlFfU19TT0ZUKTsKPiArCQlicmVhazsKPiArCWNh
c2UgU0JJX1NFTkRfSVBJOgo+ICsJCWhtYXNrID0ga3ZtX3Jpc2N2X3ZjcHVfdW5wcml2X3JlYWQo
dmNwdSwgZmFsc2UsIGNwLT5hMCwKPiArCQkJCQkJICAgJnV0X3NjYXVzZSk7Cj4gKwkJaWYgKHV0
X3NjYXVzZSkgewo+ICsJCQlrdm1fcmlzY3ZfdmNwdV90cmFwX3JlZGlyZWN0KHZjcHUsIHV0X3Nj
YXVzZSwKPiArCQkJCQkJICAgICBjcC0+YTApOwo+ICsJCQluZXh0X3NlcGMgPSBmYWxzZTsKPiAr
CQl9IGVsc2Ugewo+ICsJCQlmb3JfZWFjaF9zZXRfYml0KGksICZobWFzaywgQklUU19QRVJfTE9O
Rykgewo+ICsJCQkJcnZjcHUgPSBrdm1fZ2V0X3ZjcHVfYnlfaWQodmNwdS0+a3ZtLCBpKTsKPiAr
CQkJCWt2bV9yaXNjdl92Y3B1X3NldF9pbnRlcnJ1cHQocnZjcHUsIElSUV9TX1NPRlQpOwo+ICsJ
CQl9Cj4gKwkJfQo+ICsJCWJyZWFrOwo+ICsJY2FzZSBTQklfU0hVVERPV046Cj4gKwkJa3ZtX3Ni
aV9zeXN0ZW1fc2h1dGRvd24odmNwdSwgS1ZNX1NZU1RFTV9FVkVOVF9TSFVURE9XTik7Cj4gKwkJ
cmV0ID0gMDsKPiArCQlicmVhazsKPiArCWNhc2UgU0JJX1JFTU9URV9GRU5DRV9JOgo+ICsJCXNi
aV9yZW1vdGVfZmVuY2VfaShOVUxMKTsKPiArCQlicmVhazsKPiArCS8qCj4gKwkgKiBUT0RPOiBU
aGVyZSBzaG91bGQgYmUgYSB3YXkgdG8gY2FsbCByZW1vdGUgaGZlbmNlLmJ2bWEuCj4gKwkgKiBQ
cmVmZXJyZWQgbWV0aG9kIGlzIG5vdyBhIFNCSSBjYWxsLiBVbnRpbCB0aGVuLCBqdXN0IGZsdXNo
Cj4gKwkgKiBhbGwgdGxicy4KPiArCSAqLwo+ICsJY2FzZSBTQklfUkVNT1RFX1NGRU5DRV9WTUE6
Cj4gKwkJLyogVE9ETzogUGFyc2Ugdm1hIHJhbmdlLiAqLwo+ICsJCXNiaV9yZW1vdGVfc2ZlbmNl
X3ZtYShOVUxMLCAwLCAwKTsKPiArCQlicmVhazsKPiArCWNhc2UgU0JJX1JFTU9URV9TRkVOQ0Vf
Vk1BX0FTSUQ6Cj4gKwkJLyogVE9ETzogUGFyc2Ugdm1hIHJhbmdlIGZvciBnaXZlbiBBU0lEICov
Cj4gKwkJc2JpX3JlbW90ZV9zZmVuY2Vfdm1hKE5VTEwsIDAsIDApOwo+ICsJCWJyZWFrOwo+ICsJ
ZGVmYXVsdDoKPiArCQkvKgo+ICsJCSAqIEZvciBub3csIGp1c3QgcmV0dXJuIGVycm9yIHRvIEd1
ZXN0Lgo+ICsJCSAqIFRPRE86IEluLWZ1dHVyZSwgd2Ugd2lsbCByb3V0ZSB1bnN1cHBvcnRlZCBT
QkkgY2FsbHMKPiArCQkgKiB0byB1c2VyLXNwYWNlLgo+ICsJCSAqLwo+ICsJCWNwLT5hMCA9IC1F
Tk9UU1VQUDsKPiArCQlicmVhazsKPiArCX07Cj4gKwo+ICsJaWYgKHJldCA+PSAwKQo+ICsJCWNw
LT5zZXBjICs9IDQ7CgpJIGRvbid0IHNlZSB5b3UgZXZlciBzZXR0aW5nIHJldCBleGNlcHQgZm9y
IHNodXRkb3duPwoKUmVhbGx5LCBub3cgaXMgdGhlIHRpbWUgdG8gcGx1bWIgU0JJIGNhbGxzIGRv
d24gdG8gdXNlciBzcGFjZS4gSXQgYWxsb3dzIAp5b3UgdG8gaGF2ZSBhIGNsZWFuIHNodXRkb3du
IHN0b3J5IGZyb20gZGF5IDEuCgoKQWxleAoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdl
cm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5n
OiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBSYWxmIEhlcmJyaWNoCkVpbmdldHJhZ2VuIGFtIEFtdHNn
ZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0
LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

