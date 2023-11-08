Return-Path: <kvm+bounces-1195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5862B7E560F
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 13:17:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 119C028127B
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:17:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEFAA17747;
	Wed,  8 Nov 2023 12:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="R+RVTkG8"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134FB16404;
	Wed,  8 Nov 2023 12:17:07 +0000 (UTC)
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081131BEF;
	Wed,  8 Nov 2023 04:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699445827; x=1730981827;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iVZc5sJ9jCp/SOQQXzFfqdnJItlqJjenGVVatYWX/y4=;
  b=R+RVTkG8ok5dULT0JxE2m7OEqCVh3St01DkrQKKI6bFXtAHNVGEa2X4+
   kKW51jwG8rXExnoDD3jDy22mYa9uVFH3ok3o9gErbygMX8AJ5uo8Fi0js
   yMf+GgM7lUKQLKnt8+nwUrMDb/UlaB/OObNkWgqP8V1EqZ8qI+lLNvi/t
   0=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="614876092"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 12:17:05 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
	by email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com (Postfix) with ESMTPS id D89F2A0AC3;
	Wed,  8 Nov 2023 12:17:01 +0000 (UTC)
Received: from EX19MTAUWA002.ant.amazon.com [10.0.38.20:20092]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.29.255:2525] with esmtp (Farcaster)
 id 59dcd525-ae25-4cc2-9a49-2d1fba5e59b9; Wed, 8 Nov 2023 12:17:01 +0000 (UTC)
X-Farcaster-Flow-ID: 59dcd525-ae25-4cc2-9a49-2d1fba5e59b9
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 12:17:01 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Wed, 8 Nov
 2023 12:16:57 +0000
Message-ID: <b83e86a4-4692-45e7-8237-4efd9d5f7daf@amazon.com>
Date: Wed, 8 Nov 2023 13:16:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 03/33] KVM: x86: hyper-v: Introduce XMM output support
Content-Language: en-US
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Nicolas Saenz Julienne
	<nsaenz@amazon.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <anelkz@amazon.com>,
	<dwmw@amazon.co.uk>, <jgowans@amazon.com>, <corbert@lwn.net>,
	<kys@microsoft.com>, <haiyangz@microsoft.com>, <decui@microsoft.com>,
	<x86@kernel.org>, <linux-doc@vger.kernel.org>
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <20231108111806.92604-4-nsaenz@amazon.com>
 <82c5a8c8-2c3c-43dc-95c2-4d465fe63985@amazon.com> <87o7g4e96v.fsf@redhat.com>
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <87o7g4e96v.fsf@redhat.com>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D039UWB004.ant.amazon.com (10.13.138.57) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64

Ck9uIDA4LjExLjIzIDEzOjExLCBWaXRhbHkgS3V6bmV0c292IHdyb3RlOgo+IEFsZXhhbmRlciBH
cmFmIDxncmFmQGFtYXpvbi5jb20+IHdyaXRlczoKPgo+PiBPbiAwOC4xMS4yMyAxMjoxNywgTmlj
b2xhcyBTYWVueiBKdWxpZW5uZSB3cm90ZToKPj4+IFByZXBhcmUgaW5mcmFzdHJ1Y3R1cmUgdG8g
YmUgYWJsZSB0byByZXR1cm4gZGF0YSB0aHJvdWdoIHRoZSBYTU0KPj4+IHJlZ2lzdGVycyB3aGVu
IEh5cGVyLVYgaHlwZXJjYWxscyBhcmUgaXNzdWVzIGluIGZhc3QgbW9kZS4gVGhlIFhNTQo+Pj4g
cmVnaXN0ZXJzIGFyZSBleHBvc2VkIHRvIHVzZXItc3BhY2UgdGhyb3VnaCBLVk1fRVhJVF9IWVBF
UlZfSENBTEwgYW5kCj4+PiByZXN0b3JlZCBvbiBzdWNjZXNzZnVsIGh5cGVyY2FsbCBjb21wbGV0
aW9uLgo+Pj4KPj4+IFNpZ25lZC1vZmYtYnk6IE5pY29sYXMgU2FlbnogSnVsaWVubmUgPG5zYWVu
ekBhbWF6b24uY29tPgo+Pj4gLS0tCj4+PiAgICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9oeXBlcnYt
dGxmcy5oIHwgIDIgKy0KPj4+ICAgIGFyY2gveDg2L2t2bS9oeXBlcnYuYyAgICAgICAgICAgICAg
fCAzMyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0KPj4+ICAgIGluY2x1ZGUvdWFwaS9s
aW51eC9rdm0uaCAgICAgICAgICAgfCAgNiArKysrKysKPj4+ICAgIDMgZmlsZXMgY2hhbmdlZCwg
MzkgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKPj4+Cj4+PiBkaWZmIC0tZ2l0IGEvYXJj
aC94ODYvaW5jbHVkZS9hc20vaHlwZXJ2LXRsZnMuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2h5
cGVydi10bGZzLmgKPj4+IGluZGV4IDJmZjI2ZjUzY2Q2Mi4uYWY1OTRhYTY1MzA3IDEwMDY0NAo+
Pj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vaHlwZXJ2LXRsZnMuaAo+Pj4gKysrIGIvYXJj
aC94ODYvaW5jbHVkZS9hc20vaHlwZXJ2LXRsZnMuaAo+Pj4gQEAgLTQ5LDcgKzQ5LDcgQEAKPj4+
ICAgIC8qIFN1cHBvcnQgZm9yIHBoeXNpY2FsIENQVSBkeW5hbWljIHBhcnRpdGlvbmluZyBldmVu
dHMgaXMgYXZhaWxhYmxlKi8KPj4+ICAgICNkZWZpbmUgSFZfWDY0X0NQVV9EWU5BTUlDX1BBUlRJ
VElPTklOR19BVkFJTEFCTEUgIEJJVCgzKQo+Pj4gICAgLyoKPj4+IC0gKiBTdXBwb3J0IGZvciBw
YXNzaW5nIGh5cGVyY2FsbCBpbnB1dCBwYXJhbWV0ZXIgYmxvY2sgdmlhIFhNTQo+Pj4gKyAqIFN1
cHBvcnQgZm9yIHBhc3NpbmcgaHlwZXJjYWxsIGlucHV0IGFuZCBvdXRwdXQgcGFyYW1ldGVyIGJs
b2NrIHZpYSBYTU0KPj4+ICAgICAqIHJlZ2lzdGVycyBpcyBhdmFpbGFibGUKPj4+ICAgICAqLwo+
Pj4gICAgI2RlZmluZSBIVl9YNjRfSFlQRVJDQUxMX1hNTV9JTlBVVF9BVkFJTEFCTEUgICAgICAg
ICAgICAgICBCSVQoNCkKPj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vaHlwZXJ2LmMgYi9h
cmNoL3g4Ni9rdm0vaHlwZXJ2LmMKPj4+IGluZGV4IDIzOGFmZDczMzVlNC4uZTFiYzg2MWFiM2Iw
IDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC94ODYva3ZtL2h5cGVydi5jCj4+PiArKysgYi9hcmNoL3g4
Ni9rdm0vaHlwZXJ2LmMKPj4+IEBAIC0xODE1LDYgKzE4MTUsNyBAQCBzdHJ1Y3Qga3ZtX2h2X2hj
YWxsIHsKPj4+ICAgICAgIHUxNiByZXBfaWR4Owo+Pj4gICAgICAgYm9vbCBmYXN0Owo+Pj4gICAg
ICAgYm9vbCByZXA7Cj4+PiArICAgIGJvb2wgeG1tX2RpcnR5Owo+Pj4gICAgICAgc3NlMTI4X3Qg
eG1tW0hWX0hZUEVSQ0FMTF9NQVhfWE1NX1JFR0lTVEVSU107Cj4+Pgo+Pj4gICAgICAgLyoKPj4+
IEBAIC0yMzQ2LDkgKzIzNDcsMzMgQEAgc3RhdGljIGludCBrdm1faHZfaHlwZXJjYWxsX2NvbXBs
ZXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTY0IHJlc3VsdCkKPj4+ICAgICAgIHJldHVybiBy
ZXQ7Cj4+PiAgICB9Cj4+Pgo+Pj4gK3N0YXRpYyB2b2lkIGt2bV9odl93cml0ZV94bW0oc3RydWN0
IGt2bV9oeXBlcnZfeG1tX3JlZyAqeG1tKQo+Pj4gK3sKPj4+ICsgICAgaW50IHJlZzsKPj4+ICsK
Pj4+ICsgICAga3ZtX2ZwdV9nZXQoKTsKPj4+ICsgICAgZm9yIChyZWcgPSAwOyByZWcgPCBIVl9I
WVBFUkNBTExfTUFYX1hNTV9SRUdJU1RFUlM7IHJlZysrKSB7Cj4+PiArICAgICAgICAgICAgY29u
c3Qgc3NlMTI4X3QgZGF0YSA9IHNzZTEyOCh4bW1bcmVnXS5sb3csIHhtbVtyZWddLmhpZ2gpOwo+
Pj4gKyAgICAgICAgICAgIF9rdm1fd3JpdGVfc3NlX3JlZyhyZWcsICZkYXRhKTsKPj4+ICsgICAg
fQo+Pj4gKyAgICBrdm1fZnB1X3B1dCgpOwo+Pj4gK30KPj4+ICsKPj4+ICtzdGF0aWMgYm9vbCBr
dm1faHZfaXNfeG1tX291dHB1dF9oY2FsbCh1MTYgY29kZSkKPj4+ICt7Cj4+PiArICAgIHJldHVy
biBmYWxzZTsKPj4+ICt9Cj4+PiArCj4+PiAgICBzdGF0aWMgaW50IGt2bV9odl9oeXBlcmNhbGxf
Y29tcGxldGVfdXNlcnNwYWNlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPj4+ICAgIHsKPj4+IC0g
ICAgcmV0dXJuIGt2bV9odl9oeXBlcmNhbGxfY29tcGxldGUodmNwdSwgdmNwdS0+cnVuLT5oeXBl
cnYudS5oY2FsbC5yZXN1bHQpOwo+Pj4gKyAgICBib29sIGZhc3QgPSAhISh2Y3B1LT5ydW4tPmh5
cGVydi51LmhjYWxsLmlucHV0ICYgSFZfSFlQRVJDQUxMX0ZBU1RfQklUKTsKPj4+ICsgICAgdTE2
IGNvZGUgPSB2Y3B1LT5ydW4tPmh5cGVydi51LmhjYWxsLmlucHV0ICYgMHhmZmZmOwo+Pj4gKyAg
ICB1NjQgcmVzdWx0ID0gdmNwdS0+cnVuLT5oeXBlcnYudS5oY2FsbC5yZXN1bHQ7Cj4+PiArCj4+
PiArICAgIGlmIChrdm1faHZfaXNfeG1tX291dHB1dF9oY2FsbChjb2RlKSAmJiBodl9yZXN1bHRf
c3VjY2VzcyhyZXN1bHQpICYmIGZhc3QpCj4+PiArICAgICAgICAgICAga3ZtX2h2X3dyaXRlX3ht
bSh2Y3B1LT5ydW4tPmh5cGVydi51LmhjYWxsLnhtbSk7Cj4+PiArCj4+PiArICAgIHJldHVybiBr
dm1faHZfaHlwZXJjYWxsX2NvbXBsZXRlKHZjcHUsIHJlc3VsdCk7Cj4+PiAgICB9Cj4+Pgo+Pj4g
ICAgc3RhdGljIHUxNiBrdm1faHZjYWxsX3NpZ25hbF9ldmVudChzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUsIHN0cnVjdCBrdm1faHZfaGNhbGwgKmhjKQo+Pj4gQEAgLTI2MjMsNiArMjY0OCw5IEBAIGlu
dCBrdm1faHZfaHlwZXJjYWxsKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPj4+ICAgICAgICAgICAg
ICAgYnJlYWs7Cj4+PiAgICAgICB9Cj4+Pgo+Pj4gKyAgICBpZiAoKHJldCAmIEhWX0hZUEVSQ0FM
TF9SRVNVTFRfTUFTSykgPT0gSFZfU1RBVFVTX1NVQ0NFU1MgJiYgaGMueG1tX2RpcnR5KQo+Pj4g
KyAgICAgICAgICAgIGt2bV9odl93cml0ZV94bW0oKHN0cnVjdCBrdm1faHlwZXJ2X3htbV9yZWcq
KWhjLnhtbSk7Cj4+PiArCj4+PiAgICBoeXBlcmNhbGxfY29tcGxldGU6Cj4+PiAgICAgICByZXR1
cm4ga3ZtX2h2X2h5cGVyY2FsbF9jb21wbGV0ZSh2Y3B1LCByZXQpOwo+Pj4KPj4+IEBAIC0yNjMy
LDYgKzI2NjAsOCBAQCBpbnQga3ZtX2h2X2h5cGVyY2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUp
Cj4+PiAgICAgICB2Y3B1LT5ydW4tPmh5cGVydi51LmhjYWxsLmlucHV0ID0gaGMucGFyYW07Cj4+
PiAgICAgICB2Y3B1LT5ydW4tPmh5cGVydi51LmhjYWxsLnBhcmFtc1swXSA9IGhjLmluZ3BhOwo+
Pj4gICAgICAgdmNwdS0+cnVuLT5oeXBlcnYudS5oY2FsbC5wYXJhbXNbMV0gPSBoYy5vdXRncGE7
Cj4+PiArICAgIGlmIChoYy5mYXN0KQo+Pj4gKyAgICAgICAgICAgIG1lbWNweSh2Y3B1LT5ydW4t
Pmh5cGVydi51LmhjYWxsLnhtbSwgaGMueG1tLCBzaXplb2YoaGMueG1tKSk7Cj4+PiAgICAgICB2
Y3B1LT5hcmNoLmNvbXBsZXRlX3VzZXJzcGFjZV9pbyA9IGt2bV9odl9oeXBlcmNhbGxfY29tcGxl
dGVfdXNlcnNwYWNlOwo+Pj4gICAgICAgcmV0dXJuIDA7Cj4+PiAgICB9Cj4+PiBAQCAtMjc4MCw2
ICsyODEwLDcgQEAgaW50IGt2bV9nZXRfaHZfY3B1aWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBz
dHJ1Y3Qga3ZtX2NwdWlkMiAqY3B1aWQsCj4+PiAgICAgICAgICAgICAgICAgICAgICAgZW50LT5l
YnggfD0gSFZfRU5BQkxFX0VYVEVOREVEX0hZUEVSQ0FMTFM7Cj4+Pgo+Pj4gICAgICAgICAgICAg
ICAgICAgICAgIGVudC0+ZWR4IHw9IEhWX1g2NF9IWVBFUkNBTExfWE1NX0lOUFVUX0FWQUlMQUJM
RTsKPj4+ICsgICAgICAgICAgICAgICAgICAgIGVudC0+ZWR4IHw9IEhWX1g2NF9IWVBFUkNBTExf
WE1NX09VVFBVVF9BVkFJTEFCTEU7Cj4+Cj4+IFNob3VsZG4ndCB0aGlzIGJlIGd1YXJkZWQgYnkg
YW4gRU5BQkxFX0NBUCB0byBtYWtlIHN1cmUgb2xkIHVzZXIgc3BhY2UKPj4gdGhhdCBkb2Vzbid0
IGtub3cgYWJvdXQgeG1tIG91dHB1dHMgaXMgc3RpbGwgYWJsZSB0byBydW4gd2l0aCBuZXdlciBr
ZXJuZWxzPwo+Pgo+IE5vLCB3ZSBkb24ndCBkbyBDQVBzIGZvciBuZXcgSHlwZXItViBmZWF0dXJl
cyBhbnltb3JlIHNpbmNlIHdlIGhhdmUKPiBLVk1fR0VUX1NVUFBPUlRFRF9IVl9DUFVJRC4gVXNl
cnNwYWNlIGlzIG5vdCBzdXBwb3NlZCB0byBzaW1wbHkgY29weQo+IGl0cyBvdXRwdXQgaW50byBn
dWVzdCB2aXNpYmxlIENQVUlEcywgaXQgbXVzdCBvbmx5IGVuYWJsZSBmZWF0dXJlcyBpdAo+IGtu
b3dzLiBFdmVuICdodl9wYXNzdGhyb3VnaCcgb3B0aW9uIGluIFFFTVUgZG9lc24ndCBwYXNzIHVu
a25vd24KPiBmZWF0dXJlcyB0aHJvdWdoLgoKCkFoLCBuaWNlIDopLiBUaGF0IHNpbXBsaWZpZXMg
dGhpbmdzLgoKCkFsZXgKCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJI
CktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlh
biBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENo
YXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAy
ODkgMjM3IDg3OQoKCg==


