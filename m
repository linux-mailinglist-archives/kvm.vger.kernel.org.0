Return-Path: <kvm+bounces-4151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D696680E4AE
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 08:14:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B064B21C8C
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 07:14:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0DF168A3;
	Tue, 12 Dec 2023 07:13:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BABCEE
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 23:13:49 -0800 (PST)
Received: from duchao$eswincomputing.com ( [123.139.59.82] ) by
 ajax-webmail-app2 (Coremail) ; Tue, 12 Dec 2023 15:12:22 +0800 (GMT+08:00)
Date: Tue, 12 Dec 2023 15:12:22 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Chao Du" <duchao@eswincomputing.com>
To: "Daniel Henrique Barboza" <dbarboza@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, anup@brainfault.org, 
	atishp@atishpatra.org
Subject: Re: [PATCH] RISC-V: KVM: remove a redundant condition in
 kvm_arch_vcpu_ioctl_run()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.3 build 20220420(169d3f8c)
 Copyright (c) 2002-2023 www.mailtech.cn
 mispb-72143050-eaf5-4703-89e0-86624513b4ce-eswincomputing.com
In-Reply-To: <94bcaa6d-fe18-4eed-b2d4-a6a5521230bf@ventanamicro.com>
References: <20231211094014.4041-1-duchao@eswincomputing.com>
 <94bcaa6d-fe18-4eed-b2d4-a6a5521230bf@ventanamicro.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <4840760d.ce9.18c5cde9e56.Coremail.duchao@eswincomputing.com>
X-Coremail-Locale: en_US
X-CM-TRANSID:TQJkCgA3xtTWB3hlvxcBAA--.1258W
X-CM-SenderInfo: xgxfxt3r6h245lqf0zpsxwx03jof0z/1tbiAQEDDGV3K3YYiAACsS
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

Cj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlcy0tLS0tRnJvbToiRGFuaWVsIEhlbnJpcXVlIEJhcmJv
emEiIDxkYmFyYm96YUB2ZW50YW5hbWljcm8uY29tPlNlbnQgVGltZToyMDIzLTEyLTExIDIwOjA2
OjMzIChNb25kYXkpVG86IkNoYW8gRHUiIDxkdWNoYW9AZXN3aW5jb21wdXRpbmcuY29tPiwga3Zt
QHZnZXIua2VybmVsLm9yZywga3ZtLXJpc2N2QGxpc3RzLmluZnJhZGVhZC5vcmcsIGFudXBAYnJh
aW5mYXVsdC5vcmcsIGF0aXNocEBhdGlzaHBhdHJhLm9yZ0NjOlN1YmplY3Q6UmU6IFtQQVRDSF0g
UklTQy1WOiBLVk06IHJlbW92ZSBhIHJlZHVuZGFudCBjb25kaXRpb24gaW4ga3ZtX2FyY2hfdmNw
dV9pb2N0bF9ydW4oKQo+IAo+IAo+IAo+IE9uIDEyLzExLzIzIDA2OjQwLCBDaGFvIER1IHdyb3Rl
Ogo+ID4gVGhlIGxhdGVzdCByZXQgdmFsdWUgaXMgdXBkYXRlZCBieSBrdm1fcmlzY3ZfdmNwdV9h
aWFfdXBkYXRlKCksCj4gPiB0aGUgbG9vcCB3aWxsIGNvbnRpbnVlIGlmIHRoZSByZXQgaXMgbGVz
cyB0aGFuIG9yIGVxdWFsIHRvIHplcm8uCj4gPiBTbyB0aGUgbGF0ZXIgY29uZGl0aW9uIHdpbGwg
bmV2ZXIgaGl0LiBUaHVzIHJlbW92ZSBpdC4KPiAKPiBHb29kIGNhdGNoLiBUaGVyZSdzIGFub3Ro
ZXIgcG90ZW50aWFsIG9wdGltaXphdGlvbiB0byBiZSBkb25lIGEgbGl0dGxlIGFib3ZlCj4gdGhp
cyBjaGFuZ2U6Cj4gCj4gCj4gCXdoaWxlIChyZXQgPiAwKSB7Cj4gCQkoLi4uKQo+IAo+IAkJLyog
VXBkYXRlIEFJQSBIVyBzdGF0ZSBiZWZvcmUgZW50ZXJpbmcgZ3Vlc3QgKi8KPiAJCXJldCA9IGt2
bV9yaXNjdl92Y3B1X2FpYV91cGRhdGUodmNwdSk7Cj4gCQlpZiAocmV0IDw9IDApIHsKPiAJCQlw
cmVlbXB0X2VuYWJsZSgpOwo+IAkJCWNvbnRpbnVlOyA8LS0tLS0tLS0tLS0tLS0tLS0tCj4gCQl9
Cj4gCQkoLi4uKQo+IAo+IE5vdGUgdGhhdCB0aGlzICdjb250aW51ZScgaXNuJ3QgZG9pbmcgbXVj
aCAtIHdlJ2xsIHJlc3RhcnQgdGhlIGxvb3Agd2l0aCByZXQgPD0gMAo+IHdoaWxlIHJlcXVpcmlu
ZyByZXQgPiAwIHRvIGRvIGFub3RoZXIgaXRlcmF0aW9uLiBJLmUuIHRoaXMgJ2NvbnRpbnVlJyBj
YW4gYmUKPiByZXBsYWNlZCBmb3IgJ2JyZWFrJyB3aXRob3V0IGNvbXByb21pc2luZyB0aGUgbG9n
aWMuCgpZZXMsIHlvdSBhcmUgcmlnaHQuIFRoZSAnY29udGludWUnIGNvdWxkIGJlIHJlcGxhY2Vk
IGJ5IGEgJ2JyZWFrJy4KSSBhbHNvIGZpbmQgYW5vdGhlciBzbWFsbCBwb2ludDoKCgkJcmV0ID0g
MTsKCgkJKC4uLikKCgkJLyogVXBkYXRlIEFJQSBIVyBzdGF0ZSBiZWZvcmUgZW50ZXJpbmcgZ3Vl
c3QgKi8KCQlyZXQgPSBrdm1fcmlzY3ZfdmNwdV9haWFfdXBkYXRlKHZjcHUpOwoKdGhlIGFzc2ln
bm1lbnQgJ3JldCA9IDEnIGlzIHNvbWVob3cgcmVkdW5kYW50LCBzaW5jZSBpdCB3aWxsIGJlCm92
ZXJ3cml0dGVuIGJlZm9yZSBhbnkgcmVmZXJlbmNlLgoKPiAKPiAob2YgY291cnNlLCB0ZXN0aW5n
IGl0IHRvIGJlIHN1cmUgaXMgYWx3YXlzIGFkdmlzZWQgOkQgKQo+IAo+ID4gCj4gPiBTaWduZWQt
b2ZmLWJ5OiBDaGFvIER1IDxkdWNoYW9AZXN3aW5jb21wdXRpbmcuY29tPgo+ID4gLS0tCj4gCj4g
Cj4gUmV2aWV3ZWQtYnk6IERhbmllbCBIZW5yaXF1ZSBCYXJib3phIDxkYmFyYm96YUB2ZW50YW5h
bWljcm8uY29tPgo+IAo+IAo+ID4gICBhcmNoL3Jpc2N2L2t2bS92Y3B1LmMgfCAzICstLQo+ID4g
ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pCj4gPiAKPiA+
IGRpZmYgLS1naXQgYS9hcmNoL3Jpc2N2L2t2bS92Y3B1LmMgYi9hcmNoL3Jpc2N2L2t2bS92Y3B1
LmMKPiA+IGluZGV4IGUwODdjODA5MDczYy4uYmYzOTUyZDFhNjIxIDEwMDY0NAo+ID4gLS0tIGEv
YXJjaC9yaXNjdi9rdm0vdmNwdS5jCj4gPiArKysgYi9hcmNoL3Jpc2N2L2t2bS92Y3B1LmMKPiA+
IEBAIC03NTcsOCArNzU3LDcgQEAgaW50IGt2bV9hcmNoX3ZjcHVfaW9jdGxfcnVuKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSkKPiA+ICAgCQkvKiBVcGRhdGUgSFZJUCBDU1IgZm9yIGN1cnJlbnQgQ1BV
ICovCj4gPiAgIAkJa3ZtX3Jpc2N2X3VwZGF0ZV9odmlwKHZjcHUpOwo+ID4gICAKPiA+IC0JCWlm
IChyZXQgPD0gMCB8fAo+ID4gLQkJICAgIGt2bV9yaXNjdl9nc3RhZ2Vfdm1pZF92ZXJfY2hhbmdl
ZCgmdmNwdS0+a3ZtLT5hcmNoLnZtaWQpIHx8Cj4gPiArCQlpZiAoa3ZtX3Jpc2N2X2dzdGFnZV92
bWlkX3Zlcl9jaGFuZ2VkKCZ2Y3B1LT5rdm0tPmFyY2gudm1pZCkgfHwKPiA+ICAgCQkgICAga3Zt
X3JlcXVlc3RfcGVuZGluZyh2Y3B1KSB8fAo+ID4gICAJCSAgICB4ZmVyX3RvX2d1ZXN0X21vZGVf
d29ya19wZW5kaW5nKCkpIHsKPiA+ICAgCQkJdmNwdS0+bW9kZSA9IE9VVFNJREVfR1VFU1RfTU9E
RTsK

