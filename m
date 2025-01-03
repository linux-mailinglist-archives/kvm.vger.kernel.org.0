Return-Path: <kvm+bounces-34516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C3305A002FF
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 04:05:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F23151883F07
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 03:05:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB9991B3920;
	Fri,  3 Jan 2025 03:04:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tmja2lje4os4yms4ymjma.icoremail.net (zg8tmja2lje4os4yms4ymjma.icoremail.net [206.189.21.223])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 198B31957FF;
	Fri,  3 Jan 2025 03:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=206.189.21.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735873462; cv=none; b=ff4UFzj9HaoO2a+DMoxKiMtgzpYh5xCsr1eShbxqL898Ll/OTh6D+C7eFqBi8LZ7lIGrUae6ucnCVmMURQ72YwN4YgvqRGwX0iVQiuVcFt6nmBrfFTnY6vOlAZfnw+xp6xY+R941fQF9rDMadY6NBUUMEK2h0neJr7/HMUexfiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735873462; c=relaxed/simple;
	bh=b84H8V0RCiWWEiQdiQT7j2XLx+dL7zq6v7MEYmFfcWI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=M8BpldsT68n1vFsIfj/MFJazrByXzRGVNmjgJtCMHjkoIVL8ddoUItC6Q0yUr5jtTFb0oH1dfWSkNLySW3DG5WYzkK1zwsxuG5sVJeK1hofhhni/BNNFHTrJQ5PIY/FaPvU1qDuRTcw0/2v6BDb8ouXKwYsmm8CasABoJeJ87A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=206.189.21.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from zhangdongdong$eswincomputing.com ( [10.12.96.111] ) by
 ajax-webmail-app2 (Coremail) ; Fri, 3 Jan 2025 11:03:56 +0800 (GMT+08:00)
Date: Fri, 3 Jan 2025 11:03:56 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: DongdongZhang <zhangdongdong@eswincomputing.com>
To: "Alex Williamson" <alex.williamson@redhat.com>
Cc: bhelgaas@google.com, yishaih@nvidia.com, avihaih@nvidia.com,
	yi.l.liu@intel.com, ankita@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: Re: [PATCH v2] PCI: Remove redundant macro
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2024.2-cmXT6 build
 20241010(a2f59183) Copyright (c) 2002-2025 www.mailtech.cn
 mispb-72143050-eaf5-4703-89e0-86624513b4ce-eswincomputing.com
In-Reply-To: <20250102165004.2470fbb0.alex.williamson@redhat.com>
References: <20241216013536.4487-1-zhangdongdong@eswincomputing.com>
 <20250102165004.2470fbb0.alex.williamson@redhat.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <29fffca1.18a8.1942a1e9aa0.Coremail.zhangdongdong@eswincomputing.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:TQJkCgD3Y2qcU3dna54KAA--.3373W
X-CM-SenderInfo: x2kd0wpgrqwvxrqjqvxvzl0uprps33xlqjhudrp/1tbiAQELCmd2v
	1EDaAADsW
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

SGkgQWxleCzCoMKgCgpUaGFuayB5b3UgZm9yIHRoZSByZXZpZXcgYW5kIGZvciBwcm92aWRpbmcg
eW91ciBBY2tlZC1ieSHCoMKgCkkgYWdyZWUgdGhhdCB0aGlzIHBhdGNoIHByaW1hcmlseSBpbnZv
bHZlcyBQQ0kgY2hhbmdlcywgCmluY2x1ZGluZyBhIG1vZGlmaWNhdGlvbiB0byBQQ0kgVUFQSS4g
VGhlcmVmb3JlLCBJIGJlbGlldmUKaXQgd291bGQgbWFrZSB0aGUgbW9zdCBzZW5zZSB0byBoYXZl
IGl0IGdvIHRocm91Z2ggdGhlIFBDSSB0cmVlLsKgwqAKClBsZWFzZSBsZXQgbWUga25vdyBpZiB0
aGVyZSBhcmUgYW55IGFkZGl0aW9uYWwgc3RlcHMgSQpzaG91bGQgdGFrZSB0byBlbnN1cmUgYSBz
bW9vdGggc3VibWlzc2lvbi7CoMKgCgpUaGFua3MgYWdhaW4gZm9yIHlvdXIgdGltZSBhbmQgc3Vw
cG9ydCHCoMKgCgpCZXN0IHJlZ2FyZHMswqDCoApEb25nZG9uZyBaaGFuZ8KgwqAKCgoKCj4gLS0t
LS3ljp/lp4vpgq7ku7YtLS0tLQo+IOWPkeS7tuS6ujogIkFsZXggV2lsbGlhbXNvbiIgPGFsZXgu
d2lsbGlhbXNvbkByZWRoYXQuY29tPgo+IOWPkemAgeaXtumXtDoyMDI1LTAxLTAzIDA3OjUwOjA0
ICjmmJ/mnJ/kupQpCj4g5pS25Lu25Lq6OiB6aGFuZ2Rvbmdkb25nQGVzd2luY29tcHV0aW5nLmNv
bQo+IOaKhOmAgTogYmhlbGdhYXNAZ29vZ2xlLmNvbSwgeWlzaGFpaEBudmlkaWEuY29tLCBhdmlo
YWloQG52aWRpYS5jb20sIHlpLmwubGl1QGludGVsLmNvbSwgYW5raXRhQG52aWRpYS5jb20sIGt2
bUB2Z2VyLmtlcm5lbC5vcmcsIGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcsIGxpbnV4LXBj
aUB2Z2VyLmtlcm5lbC5vcmcKPiDkuLvpopg6IFJlOiBbUEFUQ0ggdjJdIFBDSTogUmVtb3ZlIHJl
ZHVuZGFudCBtYWNybwo+IAo+IE9uIE1vbiwgMTYgRGVjIDIwMjQgMDk6MzU6MzYgKzA4MDAKPiB6
aGFuZ2Rvbmdkb25nQGVzd2luY29tcHV0aW5nLmNvbSB3cm90ZToKPiAKPiA+IEZyb206IERvbmdk
b25nIFpoYW5nIDx6aGFuZ2Rvbmdkb25nQGVzd2luY29tcHV0aW5nLmNvbT4KPiA+IAo+ID4gUmVt
b3ZlZCB0aGUgZHVwbGljYXRlIG1hY3JvIGBQQ0lfVlNFQ19IRFJgIGFuZCBpdHMgcmVsYXRlZCBt
YWNybwo+ID4gYFBDSV9WU0VDX0hEUl9MRU5fU0hJRlRgIGZyb20gYHBjaV9yZWdzLmhgIHRvIGF2
b2lkIHJlZHVuZGFuY3kgYW5kCj4gPiBpbmNvbnNpc3RlbmNpZXMuIFVwZGF0ZWQgVkZJTyBQQ0kg
Y29kZSB0byB1c2UgYFBDSV9WTkRSX0hFQURFUmAgYW5kCj4gPiBgUENJX1ZORFJfSEVBREVSX0xF
TigpYCBmb3IgY29uc2lzdGVudCBuYW1pbmcgYW5kIGZ1bmN0aW9uYWxpdHkuCj4gPiAKPiA+IFRo
ZXNlIGNoYW5nZXMgYWltIHRvIHN0cmVhbWxpbmUgaGVhZGVyIGhhbmRsaW5nIHdoaWxlIG1pbmlt
aXppbmcKPiA+IGltcGFjdCwgZ2l2ZW4gdGhlIG5pY2hlIHVzYWdlIG9mIHRoZXNlIG1hY3JvcyBp
biB1c2Vyc3BhY2UuCj4gPiAKPiA+IFNpZ25lZC1vZmYtYnk6IERvbmdkb25nIFpoYW5nIDx6aGFu
Z2Rvbmdkb25nQGVzd2luY29tcHV0aW5nLmNvbT4KPiA+IC0tLQo+ID4gIGRyaXZlcnMvdmZpby9w
Y2kvdmZpb19wY2lfY29uZmlnLmMgfCA1ICsrKy0tCj4gCj4gQWNrZWQtYnk6IEFsZXggV2lsbGlh
bXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+Cj4gCj4gTGV0IG1lIGtub3cgaWYgdGhp
cyBpcyBleHBlY3RlZCB0byBnbyB0aHJvdWdoIHRoZSB2ZmlvIHRyZWUuICBHaXZlbgo+IHRoYXQg
dmZpbyBpcyBqdXN0IGNvbGxhdGVyYWwgdG8gYSBQQ0kgY2hhbmdlIGFuZCBpdCdzIHRvdWNoaW5n
IFBDSQo+IHVhcGksIEknbSBhc3N1bWluZyBpdCdsbCBnbyB0aHJvdWdoIHRoZSBQQ0kgdHJlZS4g
IFRoYW5rcywKPiAKPiBBbGV4Cj4gCj4gPiAgaW5jbHVkZS91YXBpL2xpbnV4L3BjaV9yZWdzLmgg
ICAgICB8IDMgLS0tCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDUgZGVs
ZXRpb25zKC0pCj4gPiAKPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNp
X2NvbmZpZy5jIGIvZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9jb25maWcuYwo+ID4gaW5kZXgg
ZWEyNzQ1YzFhYzVlLi41NTcyZmQ5OWI5MjEgMTAwNjQ0Cj4gPiAtLS0gYS9kcml2ZXJzL3ZmaW8v
cGNpL3ZmaW9fcGNpX2NvbmZpZy5jCj4gPiArKysgYi9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNp
X2NvbmZpZy5jCj4gPiBAQCAtMTM4OSwxMSArMTM4OSwxMiBAQCBzdGF0aWMgaW50IHZmaW9fZXh0
X2NhcF9sZW4oc3RydWN0IHZmaW9fcGNpX2NvcmVfZGV2aWNlICp2ZGV2LCB1MTYgZWNhcCwgdTE2
IGVwbwo+ID4gIAo+ID4gIAlzd2l0Y2ggKGVjYXApIHsKPiA+ICAJY2FzZSBQQ0lfRVhUX0NBUF9J
RF9WTkRSOgo+ID4gLQkJcmV0ID0gcGNpX3JlYWRfY29uZmlnX2R3b3JkKHBkZXYsIGVwb3MgKyBQ
Q0lfVlNFQ19IRFIsICZkd29yZCk7Cj4gPiArCQlyZXQgPSBwY2lfcmVhZF9jb25maWdfZHdvcmQo
cGRldiwgZXBvcyArIFBDSV9WTkRSX0hFQURFUiwKPiA+ICsJCQkJCSAgICAmZHdvcmQpOwo+ID4g
IAkJaWYgKHJldCkKPiA+ICAJCQlyZXR1cm4gcGNpYmlvc19lcnJfdG9fZXJybm8ocmV0KTsKPiA+
ICAKPiA+IC0JCXJldHVybiBkd29yZCA+PiBQQ0lfVlNFQ19IRFJfTEVOX1NISUZUOwo+ID4gKwkJ
cmV0dXJuIFBDSV9WTkRSX0hFQURFUl9MRU4oZHdvcmQpOwo+ID4gIAljYXNlIFBDSV9FWFRfQ0FQ
X0lEX1ZDOgo+ID4gIAljYXNlIFBDSV9FWFRfQ0FQX0lEX1ZDOToKPiA+ICAJY2FzZSBQQ0lfRVhU
X0NBUF9JRF9NRlZDOgo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9wY2lfcmVn
cy5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L3BjaV9yZWdzLmgKPiA+IGluZGV4IDE2MDFjN2VkNWZh
Yi4uYmNkNDRjN2NhMDQ4IDEwMDY0NAo+ID4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L3BjaV9y
ZWdzLmgKPiA+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9wY2lfcmVncy5oCj4gPiBAQCAtMTAw
MSw5ICsxMDAxLDYgQEAKPiA+ICAjZGVmaW5lIFBDSV9BQ1NfQ1RSTAkJMHgwNgkvKiBBQ1MgQ29u
dHJvbCBSZWdpc3RlciAqLwo+ID4gICNkZWZpbmUgUENJX0FDU19FR1JFU1NfQ1RMX1YJMHgwOAkv
KiBBQ1MgRWdyZXNzIENvbnRyb2wgVmVjdG9yICovCj4gPiAgCj4gPiAtI2RlZmluZSBQQ0lfVlNF
Q19IRFIJCTQJLyogZXh0ZW5kZWQgY2FwIC0gdmVuZG9yLXNwZWNpZmljICovCj4gPiAtI2RlZmlu
ZSAgUENJX1ZTRUNfSERSX0xFTl9TSElGVAkyMAkvKiBzaGlmdCBmb3IgbGVuZ3RoIGZpZWxkICov
Cj4gPiAtCj4gPiAgLyogU0FUQSBjYXBhYmlsaXR5ICovCj4gPiAgI2RlZmluZSBQQ0lfU0FUQV9S
RUdTCQk0CS8qIFNBVEEgUkVHcyBzcGVjaWZpZXIgKi8KPiA+ICAjZGVmaW5lICBQQ0lfU0FUQV9S
RUdTX01BU0sJMHhGCS8qIGxvY2F0aW9uIC0gQkFSIy9pbmxpbmUgKi8K

