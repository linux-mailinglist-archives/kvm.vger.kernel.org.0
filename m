Return-Path: <kvm+bounces-35921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27985A1609E
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2025 07:51:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8CF03A6FAE
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2025 06:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86D1318BB9C;
	Sun, 19 Jan 2025 06:51:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8145433B3;
	Sun, 19 Jan 2025 06:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.150.39.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737269484; cv=none; b=A1bBG3hyUCcDptxRu/3TxhyPuqhDdaBoMUAle8/CDS/i+Wt+hmWxRwX+iSdEDd7mirihYeOuouHeSxKQlhRQQkf1xsSW6p67pw5TAEagNgqmlgSSGAijhT5yZruf1YNlhggDZ36Jpvj4XvORxJG/CKUwMlbw20db5KrNViXGlbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737269484; c=relaxed/simple;
	bh=NYxjFn5O/HYGQBXSkB2Ih0ZJSmfSJu1mT0uwYKs5wUg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=PbOyacDbhdbxZsSL4H0ZRKj1e9tmW3FOB/9QMhaPmGn5OyxLw4Z1aMqCM7d1srl6VeZWrp2q+xnBpJWdeAqW/zn0frjJ3GFfbyNAtnv/JNWKTRnyjVA2jOO2x+wROL1yF5nk0Jg1U8ekPPhwJClUXnM3p6oR/EQif5K2R0k8wzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=129.150.39.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [117.161.58.149])
	by mtasvr (Coremail) with SMTP id _____wDXKLzToIxnqVghAA--.11986S3;
	Sun, 19 Jan 2025 14:51:00 +0800 (CST)
Received: from wh1sper$zju.edu.cn ( [117.161.58.149] ) by
 ajax-webmail-mail-app4 (Coremail) ; Sun, 19 Jan 2025 14:50:58 +0800
 (GMT+08:00)
Date: Sun, 19 Jan 2025 14:50:58 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: =?UTF-8?B?5byg5rWp54S2?= <wh1sper@zju.edu.cn>
To: "Mike Christie" <michael.christie@oracle.com>
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
	stefanha@redhat.com, eperezma@redhat.com,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] vhost/scsi: Fix improper cleanup in
 vhost_scsi_set_endpoint()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2024.2-cmXT6 build
 20241206(f7804f05) Copyright (c) 2002-2025 www.mailtech.cn zju.edu.cn
In-Reply-To: <d00be9fa-364c-4b9e-a14e-a3b403e7bd6c@oracle.com>
References: <e418a5ee-45ca-4d18-9b5d-6f8b6b1add8e@oracle.com>
 <20250117114400.79792-1-wh1sper@zju.edu.cn>
 <d00be9fa-364c-4b9e-a14e-a3b403e7bd6c@oracle.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <38a0d34d.3d9.1947d5437b6.Coremail.wh1sper@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:zi_KCgD3usTToIxn__IVAA--.3858W
X-CM-SenderInfo: asssliaqzvq6lmxovvfxof0/1tbiAhMLB2eMLigWKwABsM
X-CM-DELIVERINFO: =?B?pdV91wXKKxbFmtjJiESix3B1w3u7BCRQAee6E0rsv8LVXQpn+jaR4luXxag8yWi2LJ
	86hqLH9YqTRpyMEfmF+fuNyi1Sd6lT/hU12woy/a1/0I0C7jTu6gekAeGASh89mmdAQxqh
	ujf1sBb02Nc673zlXcfRzpV+xy8BeugxFMBRsIyElIKIzcZ9RUWyTuI3wqo08A==
X-Coremail-Antispam: 1Uk129KBj9xXoWrKr47KFykGr4kCr17WFW5XFc_yoWkuwcEga
	yvvrZxG34Iqr1xZayftFW3XF18Wr1aqFyrZw10vFnrZFyUZayUXF10vFn7uFWI9a97trWD
	ZwnYyr9xGwnFyosvyTuYvTs0mTUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbyxYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7xvr2IYc2Ij64
	vIr40E4x8a64kEw24lFcxC0VAYjxAxZF0Ew4CEw7xC0wACY4xI67k04243AVC20s07MxAI
	w28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
	4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxG
	rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8Jw
	CI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2
	z280aVCY1x0267AKxVW8JVW8Jr1l6VACY4xI67k04243AbIYCTnIWIevJa73UjIFyTuYvj
	xU7GYpUUUUU

T24gMjAyNS0wMS0xOCAwMDo1MDowNCwgTWlrZSBDaHJpc3RpZSB3cm90ZToKPiBZZWFoLCBJJ20g
bm90IHN1cmUgaWYgYmVpbmcgYWJsZSB0byBjYWxsIHZob3N0X3Njc2lfc2V0X2VuZHBvaW50IG11
bHRpcGxlCj4gdGltZXMgYW5kIHBpY2sgdXAgbmV3IHRwZ3MgaXMgYWN0dWFsbHkgYSBmZWF0dXJl
IG9yIG5vdC4gVGhlcmUncyBzbyBtYW55Cj4gYnVncyBhbmQgaXQgYWxzbyBkb2Vzbid0IHN1cHBv
cnQgdHBnIHJlbW92YWwuCgpJdCBzZWVtcyB2aG9zdF9zY3NpX2NsZWFyX2VuZHBvaW50KCkgaXMg
YXR0ZW1wdGluZyB0byBoYW5kbGUgdGhpcywgYnV0IGl0IGFjdHVhbGx5IHVuZGVwZW5kcyBhbGwg
VFBHcywgaWdub3JpbmcgdGhlIHRhcmdldCwgYW5kIGFsc28gaW50cm9kdWNlcyB0aGUgZGFuZ2xp
bmcgcG9pbnRlciB3aGVuIGBtYXRjaCA9PSAwYC4KCgo+ID4gW1BBVENIXSB2aG9zdC9zY3NpOiBG
aXggZGFuZ2xpbmcgcG9pbnRlciBpbiB2aG9zdF9zY3NpX3NldF9lbmRwb2ludCgpCj4gPiAKPiA+
IFNpbmNlIGNvbW1pdCA0ZjdmNDZkMzJjOTggKCJ0Y21fdmhvc3Q6IFVzZSB2cS0+cHJpdmF0ZV9k
YXRhIHRvIGluZGljYXRlCj4gPiBpZiB0aGUgZW5kcG9pbnQgaXMgc2V0dXAiKSwgYSBkYW5nbGlu
ZyBwb2ludGVyIGlzc3VlIGhhcyBiZWVuIGludHJvZHVjZWQKPiA+IGluIHZob3N0X3Njc2lfc2V0
X2VuZHBvaW50KCkgd2hlbiB0aGUgaG9zdCBmYWlscyB0byByZWNvbmZpZ3VyZSB0aGUKPiA+IHZo
b3N0LXNjc2kgZW5kcG9pbnQuIFNwZWNpZmljYWxseSwgdGhpcyBjYXVzZXMgYSBVQUYgZmF1bHQg
aW4KPiA+IHZob3N0X3Njc2lfZ2V0X3JlcSgpIHdoZW4gdGhlIGd1ZXN0IGF0dGVtcHRzIHRvIHNl
bmQgYW4gU0NTSSByZXF1ZXN0Lgo+ID4gCj4gSSBzYXcgdGhhdCB3aGlsZSByZXZpZXdpbmcgdGhl
IGNvZGUuIEhlcmUgaXMgbXkgcGF0Y2guIEkganVzdCBhZGRlZCBhIG5ldwo+IGdvdG8sIGJlY2F1
c2Ugd2UgZG9uJ3QgbmVlZCB0byBkbyB0aGUgdW5kZXBlbmQgc2luY2Ugd2UgbmV2ZXIgZGlkIGFu
eQo+IGRlcGVuZCBjYWxscy4KClllcywgdGhlcmUncyBubyBuZWVkIHRvIGNhbGwgdW5kZXBlbmRf
aXRlbSAtIGp1c3QgZnJlZSB2c190cGcuIE15IHBhdGNoIHdhcyBpbmNvcnJlY3QsIHRoYW5rcyBm
b3IgYnJpbmdpbmcgdGhhdCB0byBteSBhdHRlbnRpb24uCg==


