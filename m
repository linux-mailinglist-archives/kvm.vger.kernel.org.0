Return-Path: <kvm+bounces-14217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 402528A09B1
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 09:26:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 054192828DD
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 07:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6DFE13E039;
	Thu, 11 Apr 2024 07:26:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C9513DDB3;
	Thu, 11 Apr 2024 07:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.181.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712820380; cv=none; b=UqPLdLE/R/ESCKM6Y7PwxG8vd+gu7xmblxjZ+fkSgzQ1Geggp+P88kWfjerGFPJay3XGwz+szW9R8Eu9DpwI/zEEILQGZl3EuUD1jnm6o4LPe1v3+llfira3zwMp/jjlfK5R0OSUtuAXkS+zVJylc2a2KH28zCOfQW8qX4tiqMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712820380; c=relaxed/simple;
	bh=TpZ+XTCmRSUK0FH7HxlY1n3auYAjW2LvyNipcYqwEfo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=Cbq3MR5D8lZ3dWkTZDHK8bLT+mKcTgOmQ483uIcHjq2X5WVc2GEkz86+NNZw1mXZkWx96nOGWTyS1dtGYUr3fKdm8+RyY6mTimRqYb28QZ3RvGOiJlMj8OCdSmLfZkdhwY/l6cArLYoaVdw0syrjN2vejGFdBLx+ZonIaD/QSkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=209.97.181.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from liangshenlin$eswincomputing.com ( [10.12.96.90] ) by
 ajax-webmail-app2 (Coremail) ; Thu, 11 Apr 2024 15:24:07 +0800 (GMT+08:00)
Date: Thu, 11 Apr 2024 15:24:07 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Shenlin Liang" <liangshenlin@eswincomputing.com>
To: "Anup Patel" <anup@brainfault.org>
Cc: atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com, 
	acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, 
	irogers@google.com, adrian.hunter@intel.com, 
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 1/2] RISCV: KVM: add tracepoints for entry and exit
 events
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.3 build 20220420(169d3f8c)
 Copyright (c) 2002-2024 www.mailtech.cn
 mispb-72143050-eaf5-4703-89e0-86624513b4ce-eswincomputing.com
In-Reply-To: <CAAhSdy0DgW055iV7=_D6iOLr1iVeK9SZmG8hqBG0_hb1z=+07g@mail.gmail.com>
References: <20240328031220.1287-1-liangshenlin@eswincomputing.com>
 <20240328031220.1287-2-liangshenlin@eswincomputing.com>
 <CAAhSdy0DgW055iV7=_D6iOLr1iVeK9SZmG8hqBG0_hb1z=+07g@mail.gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <66245675.2875.18ecc0add4b.Coremail.liangshenlin@eswincomputing.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:TQJkCgAHGrwXkBdmkhMGAA--.3616W
X-CM-SenderInfo: xold0whvkh0z1lq6v25zlqu0xpsx3x1qjou0bp/1tbiAQEEDGYWXM
	cgsAABsy
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

T24gMjAyNC0wNC0wOCAyMDozNywgQW51cCBQYXRlbCA8YW51cEBicmFpbmZhdWx0Lm9yZz4gd3Jv
dGU6Cgo+IAo+IE9uIFRodSwgTWFyIDI4LCAyMDI0IGF0IDg6NDnigK9BTSBTaGVubGluIExpYW5n
Cj4gPGxpYW5nc2hlbmxpbkBlc3dpbmNvbXB1dGluZy5jb20+IHdyb3RlOgo+ID4KPiA+IExpa2Ug
b3RoZXIgYXJjaGl0ZWN0dXJlcywgUklTQ1YgS1ZNIGFsc28gbmVlZHMgdG8gYWRkIHRoZXNlIGV2
ZW50Cj4gPiB0cmFjZXBvaW50cyB0byBjb3VudCB0aGUgbnVtYmVyIG9mIHRpbWVzIGt2bSBndWVz
dCBlbnRyeS9leGl0Lgo+ID4KPiA+IFNpZ25lZC1vZmYtYnk6IFNoZW5saW4gTGlhbmcgPGxpYW5n
c2hlbmxpbkBlc3dpbmNvbXB1dGluZy5jb20+Cj4gPiAtLS0KPiA+ICBhcmNoL3Jpc2N2L2t2bS90
cmFjZV9yaXNjdi5oIHwgNjAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4g
PiAgYXJjaC9yaXNjdi9rdm0vdmNwdS5jICAgICAgICB8ICA3ICsrKysrCj4gPiAgMiBmaWxlcyBj
aGFuZ2VkLCA2NyBpbnNlcnRpb25zKCspCj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGFyY2gvcmlz
Y3Yva3ZtL3RyYWNlX3Jpc2N2LmgKPiA+Cj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9yaXNjdi9rdm0v
dHJhY2VfcmlzY3YuaCBiL2FyY2gvcmlzY3Yva3ZtL3RyYWNlX3Jpc2N2LmgKPiA+IG5ldyBmaWxl
IG1vZGUgMTAwNjQ0Cj4gPiBpbmRleCAwMDAwMDAwMDAwMDAuLjU4NDgwODNjN2E1ZQo+ID4gLS0t
IC9kZXYvbnVsbAo+ID4gKysrIGIvYXJjaC9yaXNjdi9rdm0vdHJhY2VfcmlzY3YuaAo+ID4gQEAg
LTAsMCArMSw2MCBAQAo+ID4gKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wCj4g
PiArLyoKPiA+ICsgKiBUcmFjZXBvaW50cyBmb3IgUklTQy1WIEtWTQo+ID4gKyAqCj4gPiArICog
Q29weXJpZ2h0IDIwMjQgQmVpamluZyBFU1dJTiBDb21wdXRpbmcgVGVjaG5vbG9neSBDby4sIEx0
ZC4KPiA+ICsgKgo+ID4gKyAqLwo+ID4gKyNpZiAhZGVmaW5lZChfVFJBQ0VfUlNJQ1ZfS1ZNX0gp
IHx8IGRlZmluZWQoVFJBQ0VfSEVBREVSX01VTFRJX1JFQUQpCj4gPiArI2RlZmluZSBfVFJBQ0Vf
UlNJQ1ZfS1ZNX0gKPiAKPiBzL19SU0lDVl8vX1JJU0NWXy8KPiAKPiA+ICsKPiA+ICsjaW5jbHVk
ZSA8bGludXgvdHJhY2Vwb2ludC5oPgo+ID4gKwo+ID4gKyN1bmRlZiBUUkFDRV9TWVNURU0KPiA+
ICsjZGVmaW5lIFRSQUNFX1NZU1RFTSBrdm0KPiA+ICsKPiA+ICtUUkFDRV9FVkVOVChrdm1fZW50
cnksCj4gPiArICAgICAgIFRQX1BST1RPKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSksCj4gPiArICAg
ICAgIFRQX0FSR1ModmNwdSksCj4gPiArCj4gPiArICAgICAgIFRQX1NUUlVDVF9fZW50cnkoCj4g
PiArICAgICAgICAgICAgICAgX19maWVsZCh1bnNpZ25lZCBsb25nLCBwYykKPiA+ICsgICAgICAg
KSwKPiA+ICsKPiA+ICsgICAgICAgVFBfZmFzdF9hc3NpZ24oCj4gPiArICAgICAgICAgICAgICAg
X19lbnRyeS0+cGMgICAgID0gdmNwdS0+YXJjaC5ndWVzdF9jb250ZXh0LnNlcGM7Cj4gPiArICAg
ICAgICksCj4gPiArCj4gPiArICAgICAgIFRQX3ByaW50aygiUEM6IDB4JTAxNmx4IiwgX19lbnRy
eS0+cGMpCj4gPiArKTsKPiA+ICsKPiA+ICtUUkFDRV9FVkVOVChrdm1fZXhpdCwKPiA+ICsgICAg
ICAgVFBfUFJPVE8oc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1bnNpZ25lZCBsb25nIGV4aXRfcmVh
c29uLAo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgbG9uZyBzY2F1c2UpLAo+
ID4gKyAgICAgICBUUF9BUkdTKHZjcHUsIGV4aXRfcmVhc29uLCBzY2F1c2UpLAo+ID4gKwo+ID4g
KyAgICAgICBUUF9TVFJVQ1RfX2VudHJ5KAo+ID4gKyAgICAgICAgICAgICAgIF9fZmllbGQodW5z
aWduZWQgbG9uZywgcGMpCj4gPiArICAgICAgICAgICAgICAgX19maWVsZCh1bnNpZ25lZCBsb25n
LCBleGl0X3JlYXNvbikKPiA+ICsgICAgICAgICAgICAgICBfX2ZpZWxkKHVuc2lnbmVkIGxvbmcs
IHNjYXVzZSkKPiAKPiBUaGlzIGlzIG5vdCB0aGUgcmlnaHQgY29udGVudHMgZGVzY3JpYmluZyBh
IEtWTSBleGl0Lgo+IAo+IFRoZSBmaWVsZHMgb3ZlciBoZXJlIHNob3VsZCBiZSBhbGlnbmVkIHdp
dGggInN0cnVjdCBrdm1fY3B1X3RyYXAiCj4gc28gd2Ugc2hvdWxkIGhhdmUgZm9sbG93aW5nIGZp
ZWxkczoKPiAgICAgX19maWVsZCh1bnNpZ25lZCBsb25nLCBzZXBjKQo+ICAgICBfX2ZpZWxkKHVu
c2lnbmVkIGxvbmcsIHNjYXVzZSkKPiAgICAgX19maWVsZCh1bnNpZ25lZCBsb25nLCBzdHZhbCkK
PiAgICAgX19maWVsZCh1bnNpZ25lZCBsb25nLCBodHZhbCkKPiAgICAgX19maWVsZCh1bnNpZ25l
ZCBsb25nLCBodGluc3QpCj4gCj4gPiArICAgICAgICksCj4gPiArCj4gPiArICAgICAgIFRQX2Zh
c3RfYXNzaWduKAo+ID4gKyAgICAgICAgICAgICAgIF9fZW50cnktPnBjICAgICAgICAgICAgID0g
dmNwdS0+YXJjaC5ndWVzdF9jb250ZXh0LnNlcGM7Cj4gPiArICAgICAgICAgICAgICAgX19lbnRy
eS0+ZXhpdF9yZWFzb24gICAgPSBleGl0X3JlYXNvbjsKPiA+ICsgICAgICAgICAgICAgICBfX2Vu
dHJ5LT5zY2F1c2UgICAgICAgICA9IHNjYXVzZTsKPiA+ICsgICAgICAgKSwKPiA+ICsKPiA+ICsg
ICAgICAgVFBfcHJpbnRrKCJFWElUX1JFQVNPTjoweCVseCxQQzogMHglMDE2bHgsU0NBVVNFOjB4
JWx4IiwKPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIF9fZW50cnktPmV4aXRfcmVhc29uLCBf
X2VudHJ5LT5wYywgX19lbnRyeS0+c2NhdXNlKQo+ID4gKyk7Cj4gPiArCj4gPiArI2VuZGlmIC8q
IF9UUkFDRV9SU0lDVl9LVk1fSCAqLwo+ID4gKwo+ID4gKyN1bmRlZiBUUkFDRV9JTkNMVURFX1BB
VEgKPiA+ICsjZGVmaW5lIFRSQUNFX0lOQ0xVREVfUEFUSCAuCj4gPiArI3VuZGVmIFRSQUNFX0lO
Q0xVREVfRklMRQo+ID4gKyNkZWZpbmUgVFJBQ0VfSU5DTFVERV9GSUxFIHRyYWNlX3Jpc2N2Cj4g
PiArCj4gPiArLyogVGhpcyBwYXJ0IG11c3QgYmUgb3V0c2lkZSBwcm90ZWN0aW9uICovCj4gPiAr
I2luY2x1ZGUgPHRyYWNlL2RlZmluZV90cmFjZS5oPgo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvcmlz
Y3Yva3ZtL3ZjcHUuYyBiL2FyY2gvcmlzY3Yva3ZtL3ZjcHUuYwo+ID4gaW5kZXggYjVjYTlmMmU5
OGFjLi5lZDA5MzJmMGQ1MTQgMTAwNjQ0Cj4gPiAtLS0gYS9hcmNoL3Jpc2N2L2t2bS92Y3B1LmMK
PiA+ICsrKyBiL2FyY2gvcmlzY3Yva3ZtL3ZjcHUuYwo+ID4gQEAgLTIxLDYgKzIxLDkgQEAKPiA+
ICAjaW5jbHVkZSA8YXNtL2NhY2hlZmx1c2guaD4KPiA+ICAjaW5jbHVkZSA8YXNtL2t2bV92Y3B1
X3ZlY3Rvci5oPgo+ID4KPiA+ICsjZGVmaW5lIENSRUFURV9UUkFDRV9QT0lOVFMKPiA+ICsjaW5j
bHVkZSAidHJhY2VfcmlzY3YuaCIKPiA+ICsKPiA+ICBjb25zdCBzdHJ1Y3QgX2t2bV9zdGF0c19k
ZXNjIGt2bV92Y3B1X3N0YXRzX2Rlc2NbXSA9IHsKPiA+ICAgICAgICAgS1ZNX0dFTkVSSUNfVkNQ
VV9TVEFUUygpLAo+ID4gICAgICAgICBTVEFUU19ERVNDX0NPVU5URVIoVkNQVSwgZWNhbGxfZXhp
dF9zdGF0KSwKPiA+IEBAIC03ODIsNiArNzg1LDggQEAgaW50IGt2bV9hcmNoX3ZjcHVfaW9jdGxf
cnVuKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPiA+ICAgICAgICAgICAgICAgICAgKi8KPiA+ICAg
ICAgICAgICAgICAgICBrdm1fcmlzY3ZfbG9jYWxfdGxiX3Nhbml0aXplKHZjcHUpOwo+ID4KPiA+
ICsgICAgICAgICAgICAgICB0cmFjZV9rdm1fZW50cnkodmNwdSk7Cj4gPiArCj4gPiAgICAgICAg
ICAgICAgICAgZ3Vlc3RfdGltaW5nX2VudGVyX2lycW9mZigpOwo+ID4KPiA+ICAgICAgICAgICAg
ICAgICBrdm1fcmlzY3ZfdmNwdV9lbnRlcl9leGl0KHZjcHUpOwo+ID4gQEAgLTgyMCw2ICs4MjUs
OCBAQCBpbnQga3ZtX2FyY2hfdmNwdV9pb2N0bF9ydW4oc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+
ID4KPiA+ICAgICAgICAgICAgICAgICBsb2NhbF9pcnFfZW5hYmxlKCk7Cj4gPgo+ID4gKyAgICAg
ICAgICAgICAgIHRyYWNlX2t2bV9leGl0KHZjcHUsIHJ1bi0+ZXhpdF9yZWFzb24sIHRyYXAuc2Nh
dXNlKTsKPiA+ICsKPiA+ICAgICAgICAgICAgICAgICBwcmVlbXB0X2VuYWJsZSgpOwo+ID4KPiA+
ICAgICAgICAgICAgICAgICBrdm1fdmNwdV9zcmN1X3JlYWRfbG9jayh2Y3B1KTsKPiA+IC0tCj4g
PiAyLjM3LjIKPiA+Cj4gCj4gUmVnYXJkcywKPiBBbnVwCgpUaGFuayB5b3UgZm9yIHRoZSByZXZp
ZXcuIEkgd2lsbCBzZW5kIHRoZSB2MiB2ZXJzaW9uLg==

