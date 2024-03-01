Return-Path: <kvm+bounces-10609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44ACC86DE84
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 10:44:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72E121C2284C
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 09:44:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01B016A8BA;
	Fri,  1 Mar 2024 09:44:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF276A32F
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 09:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.150.39.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709286246; cv=none; b=WKxt+dduBa/Lg0RHLQbUcghOrINf1D1cvIUVyxJkz97tiLQNv4mGkl6yK4/594cu10TFf/UPdpl6hGi9ZfSYg06cVEEh4/LhGkIfXgIkN0J6HjFdkQoPzqcBTt9zPX6lxJtNzy2OoNjIKSjaWJUshjozTT9wpkPFoTYWxZ1sIWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709286246; c=relaxed/simple;
	bh=rs+YMAJgsTpc1M6XNBVWi+ryyYv6qIQGn/pLKX7tcyY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=H7krbK0HMm91yHJepVbivHmMiMKAseLaxVA0W05Tv9p3zu5nB3gQfQnplcSk13qcSGX3qKPjfMWDGO///pdKmC/3pasrFDIqjkxNbzs+Aggzf4cRNqFqENyCUawTKDBG5FGegRhvBHIxAMVBZlWdsVFrYx56UgTfiop/PB0MwmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=129.150.39.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from duchao$eswincomputing.com ( [10.64.113.11] ) by
 ajax-webmail-app2 (Coremail) ; Fri, 1 Mar 2024 17:43:37 +0800 (GMT+08:00)
Date: Fri, 1 Mar 2024 17:43:37 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Chao Du" <duchao@eswincomputing.com>
To: "Andrew Jones" <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, anup@brainfault.org, 
	atishp@atishpatra.org, pbonzini@redhat.com, shuah@kernel.org, 
	dbarboza@ventanamicro.com, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, duchao713@qq.com
Subject: Re: [PATCH v2 3/3] RISC-V: KVM: selftests: Add breakpoints test
 support
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.3 build 20220420(169d3f8c)
 Copyright (c) 2002-2024 www.mailtech.cn
 mispb-72143050-eaf5-4703-89e0-86624513b4ce-eswincomputing.com
In-Reply-To: <20240301-16a75ed14197d3c5e0e7251e@orel>
References: <20240301013545.10403-1-duchao@eswincomputing.com>
 <20240301013545.10403-4-duchao@eswincomputing.com>
 <20240301-16a75ed14197d3c5e0e7251e@orel>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <53c9d1f0.1501.18df965d8ca.Coremail.duchao@eswincomputing.com>
X-Coremail-Locale: en_US
X-CM-TRANSID:TQJkCgDHVdRJo+FlHjYdAA--.10121W
X-CM-SenderInfo: xgxfxt3r6h245lqf0zpsxwx03jof0z/1tbiAQEDDGXgo4Qn4wAAsp
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW3Jw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

T24gMjAyNC0wMy0wMSAxNzoyNCwgQW5kcmV3IEpvbmVzIDxham9uZXNAdmVudGFuYW1pY3JvLmNv
bT4gd3JvdGU6Cj4gCj4gT24gRnJpLCBNYXIgMDEsIDIwMjQgYXQgMDE6MzU6NDVBTSArMDAwMCwg
Q2hhbyBEdSB3cm90ZToKPiA+IEluaXRpYWwgc3VwcG9ydCBmb3IgUklTQy1WIEtWTSBicmVha3Bv
aW50IHRlc3QuIENoZWNrIHRoZSBleGl0IHJlYXNvbgo+ID4gYW5kIHRoZSBQQyB3aGVuIGd1ZXN0
IGRlYnVnIGlzIGVuYWJsZWQuCj4gPiAKPiA+IFNpZ25lZC1vZmYtYnk6IENoYW8gRHUgPGR1Y2hh
b0Blc3dpbmNvbXB1dGluZy5jb20+Cj4gPiAtLS0KPiA+ICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0
cy9rdm0vTWFrZWZpbGUgICAgICAgICAgfCAgMSArCj4gPiAgLi4uL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2t2bS9yaXNjdi9icmVha3BvaW50cy5jIHwgNDkgKysrKysrKysrKysrKysrKysrKwo+ID4gIDIg
ZmlsZXMgY2hhbmdlZCwgNTAgaW5zZXJ0aW9ucygrKQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCB0
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vcmlzY3YvYnJlYWtwb2ludHMuYwo+ID4gCj4gPiBk
aWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL01ha2VmaWxlIGIvdG9vbHMv
dGVzdGluZy9zZWxmdGVzdHMva3ZtL01ha2VmaWxlCj4gPiBpbmRleCA0OTJlOTM3ZmFiMDAuLjVm
OTA0OGE3NDBiMCAxMDA2NDQKPiA+IC0tLSBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9N
YWtlZmlsZQo+ID4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL01ha2VmaWxlCj4g
PiBAQCAtMTg0LDYgKzE4NCw3IEBAIFRFU1RfR0VOX1BST0dTX3MzOTB4ICs9IHJzZXFfdGVzdAo+
ID4gIFRFU1RfR0VOX1BST0dTX3MzOTB4ICs9IHNldF9tZW1vcnlfcmVnaW9uX3Rlc3QKPiA+ICBU
RVNUX0dFTl9QUk9HU19zMzkweCArPSBrdm1fYmluYXJ5X3N0YXRzX3Rlc3QKPiA+ICAKPiA+ICtU
RVNUX0dFTl9QUk9HU19yaXNjdiArPSByaXNjdi9icmVha3BvaW50cwo+ID4gIFRFU1RfR0VOX1BS
T0dTX3Jpc2N2ICs9IGRlbWFuZF9wYWdpbmdfdGVzdAo+ID4gIFRFU1RfR0VOX1BST0dTX3Jpc2N2
ICs9IGRpcnR5X2xvZ190ZXN0Cj4gPiAgVEVTVF9HRU5fUFJPR1NfcmlzY3YgKz0gZ2V0LXJlZy1s
aXN0Cj4gPiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL3Jpc2N2L2Jy
ZWFrcG9pbnRzLmMgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vcmlzY3YvYnJlYWtwb2lu
dHMuYwo+ID4gbmV3IGZpbGUgbW9kZSAxMDA2NDQKPiA+IGluZGV4IDAwMDAwMDAwMDAwMC4uYmUy
ZDk0ODM3YzgzCj4gPiAtLS0gL2Rldi9udWxsCj4gPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0
ZXN0cy9rdm0vcmlzY3YvYnJlYWtwb2ludHMuYwo+ID4gQEAgLTAsMCArMSw0OSBAQAo+ID4gKy8v
IFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wCj4gPiArLyoKPiA+ICsgKiBSSVNDLVYg
S1ZNIGJyZWFrcG9pbnQgdGVzdHMuCj4gPiArICoKPiA+ICsgKiBDb3B5cmlnaHQgMjAyNCBCZWlq
aW5nIEVTV0lOIENvbXB1dGluZyBUZWNobm9sb2d5IENvLiwgTHRkLgo+ID4gKyAqCj4gPiArICov
Cj4gPiArI2luY2x1ZGUgImt2bV91dGlsLmgiCj4gPiArCj4gPiArI2RlZmluZSBQQyh2KSAoKHVp
bnQ2NF90KSYodikpCj4gPiArCj4gPiArZXh0ZXJuIHVuc2lnbmVkIGNoYXIgc3dfYnA7Cj4gPiAr
Cj4gPiArc3RhdGljIHZvaWQgZ3Vlc3RfY29kZSh2b2lkKQo+ID4gK3sKPiA+ICsJYXNtIHZvbGF0
aWxlKCJzd19icDogZWJyZWFrIik7Cj4gPiArCWFzbSB2b2xhdGlsZSgibm9wIik7Cj4gPiArCWFz
bSB2b2xhdGlsZSgibm9wIik7Cj4gPiArCWFzbSB2b2xhdGlsZSgibm9wIik7Cj4gCj4gV2hhdCBh
cmUgdGhlIG5vcHMgZm9yPyBBbmQsIHNpbmNlIHRoZXkncmUgYWxsIGluIHRoZWlyIG93biBhc20o
KSdzIHRoZQo+IGNvbXBpbGVyIGNvdWxkIGJlIGluc2VydGluZyBpbnN0cnVjdGlvbnMgYmV0d2Vl
biB0aGVtIGFuZCBhbHNvIHRoZSBlYnJlYWsKPiBhYm92ZS4gSWYgd2UgbmVlZCB0aHJlZSBub3Bz
IGltbWVkaWF0ZWx5IGZvbGxvd2luZyB0aGUgZWJyZWFrIHRoZW4gd2UKPiBuZWVkIHRvIHB1dCBl
dmVyeXRoaW5nIGluIG9uZSBhc20oKQo+IAo+ICAgYXNtIHZvbGF0aWxlKAo+ICAgInN3X2JwOgll
YnJlYWtcbiIKPiAgICIJCW5vcFxuIgo+ICAgIgkJbm9wXG4iCj4gICAiCQlub3BcbiIpOwo+IAoK
QWN0dWFsbHkgdGhlIG5vcHMgaGF2ZSBubyBzcGVjaWFsIHB1cnBvc2UsIEkgd2lsbCByZW1vdmUg
YW5kIGp1c3Qga2VlcCB0aGUKZWJyZWFrIGhlcmUuCgo+ID4gKwo+ID4gKwlHVUVTVF9ET05FKCk7
Cj4gPiArfQo+ID4gKwo+ID4gK2ludCBtYWluKHZvaWQpCj4gPiArewo+ID4gKwlzdHJ1Y3Qga3Zt
X3ZtICp2bTsKPiA+ICsJc3RydWN0IGt2bV92Y3B1ICp2Y3B1Owo+ID4gKwlzdHJ1Y3Qga3ZtX2d1
ZXN0X2RlYnVnIGRlYnVnOwo+ID4gKwl1aW50NjRfdCBwYzsKPiA+ICsKPiA+ICsJVEVTVF9SRVFV
SVJFKGt2bV9oYXNfY2FwKEtWTV9DQVBfU0VUX0dVRVNUX0RFQlVHKSk7Cj4gPiArCj4gPiArCXZt
ID0gdm1fY3JlYXRlX3dpdGhfb25lX3ZjcHUoJnZjcHUsIGd1ZXN0X2NvZGUpOwo+ID4gKwo+ID4g
KwltZW1zZXQoJmRlYnVnLCAwLCBzaXplb2YoZGVidWcpKTsKPiA+ICsJZGVidWcuY29udHJvbCA9
IEtWTV9HVUVTVERCR19FTkFCTEU7Cj4gCj4gbml0OiBUaGUgYWJvdmUgdHdvIGxpbmVzIGNhbiBi
ZSByZW1vdmVkIGlmIHdlIGluaXRpYWxpemUgZGVidWcgYXMKPiAKPiAgIHN0cnVjdCBrdm1fZ3Vl
c3RfZGVidWcgZGVidWcgPSB7Cj4gICAgICAuY29udHJvbCA9IEtWTV9HVUVTVERCR19FTkFCTEUs
Cj4gICB9Owo+IAoKWWVhaCwgSSB3aWxsIGRvIHNvIGluIHRoZSBuZXh0IHBhdGNoLgoKPiA+ICsJ
dmNwdV9ndWVzdF9kZWJ1Z19zZXQodmNwdSwgJmRlYnVnKTsKPiA+ICsJdmNwdV9ydW4odmNwdSk7
Cj4gPiArCj4gPiArCVRFU1RfQVNTRVJUX0tWTV9FWElUX1JFQVNPTih2Y3B1LCBLVk1fRVhJVF9E
RUJVRyk7Cj4gCj4gQXMgQW51cCBwb2ludGVkIG91dCwgd2UgbmVlZCB0byBhbHNvIGVuc3VyZSB0
aGF0IHdpdGhvdXQgbWFraW5nIHRoZQo+IEtWTV9TRVRfR1VFU1RfREVCVUcgaW9jdGwgY2FsbCB3
ZSBnZXQgdGhlIGV4cGVjdGVkIGJlaGF2aW9yLiBZb3UKPiBjYW4gdXNlIEdVRVNUX1NZTkMoKSBp
biB0aGUgZ3Vlc3QgY29kZSB0byBwcm92ZSB0aGF0IGl0IHdhcyBhYmxlIHRvCj4gaXNzdWUgYW4g
ZWJyZWFrIHdpdGhvdXQgZXhpdGluZyB0byB0aGUgVk1NLgo+IAoKU3VyZSwgd2lsbCBjb3ZlciB0
aGF0IGNhc2UgYWxzby4KCj4gPiArCj4gPiArCXZjcHVfZ2V0X3JlZyh2Y3B1LCBSSVNDVl9DT1JF
X1JFRyhyZWdzLnBjKSwgJnBjKTsKPiA+ICsKPiA+ICsJVEVTVF9BU1NFUlRfRVEocGMsIFBDKHN3
X2JwKSk7Cj4gPiArCj4gPiArCWt2bV92bV9mcmVlKHZtKTsKPiA+ICsKPiA+ICsJcmV0dXJuIDA7
Cj4gPiArfQo+ID4gLS0gCj4gPiAyLjE3LjEKPiA+Cj4gCj4gVGhhbmtzLAo+IGRyZXcK

