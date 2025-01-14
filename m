Return-Path: <kvm+bounces-35359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74337A10253
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 09:42:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 913BB164FDE
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 08:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD302284A74;
	Tue, 14 Jan 2025 08:42:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECAF91C5F2A;
	Tue, 14 Jan 2025 08:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.164.42.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736844124; cv=none; b=pLqQoH2AfYxTCaBRTWLvbs6dwUfF4syiUNrjnAIBAoLFD7836SntGxzC+2ykwRLVwDBf+RbU4aLspYz5JNJIvjmyU5+bL/FwhSu4drpx3YVGEIICMZBwz4vLaAR1QHdxAUG38r/PgtSAC0oco+9tI3qc8a3jb3lMFztqWDRKh3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736844124; c=relaxed/simple;
	bh=uYN89YWMDJIkGeTg164qE0BPS4rRTZt8kOzUvyUZomg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=efhQdbS6nV9WPaVwCWiIL7Z4PU8IgDqCL/m4Mfg9CiqropsWdHnG2qoW9DTKCBqUWzs01vX+KqunV83bdvOGOCsReGAx2xnqPPChK83IG8rQH+esmh+iW2P2dZx/rkKBS1VPvV/NI6aIxnWA9hYQSKVrhdp8zNe89jL/rMAMTzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=61.164.42.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from wh1sper$zju.edu.cn ( [10.162.198.27] ) by
 ajax-webmail-mail-app4 (Coremail) ; Tue, 14 Jan 2025 16:41:46 +0800
 (GMT+08:00)
Date: Tue, 14 Jan 2025 16:41:46 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: =?UTF-8?B?5byg5rWp54S2?= <wh1sper@zju.edu.cn>
To: "Lei Yang" <leiyang@redhat.com>
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
	stefanha@redhat.com, eperezma@redhat.com,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Mike Christie" <michael.christie@oracle.com>
Subject: Re: Re: [PATCH] vhost/scsi: Fix improper cleanup in
 vhost_scsi_set_endpoint()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2024.1-cmXT5 build
 20240625(a75f206e) Copyright (c) 2002-2025 www.mailtech.cn zju.edu.cn
In-Reply-To: <CAPpAL=xC7+f_8V4D==JvZxs5X-CePa_VftOH=KDc8H1vPSNp9w@mail.gmail.com>
References: <20250111033454.26596-1-wh1sper@zju.edu.cn>
 <bae5ca72-c6ff-4412-a317-4649f2d09cdf@oracle.com>
 <481cd60a-d633-4251-bb53-d3026e005930@oracle.com>
 <CAPpAL=xC7+f_8V4D==JvZxs5X-CePa_VftOH=KDc8H1vPSNp9w@mail.gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <2b10f430.24ffd.19463f9dc80.Coremail.wh1sper@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:cS_KCgCHmRVKI4ZnTMIlAQ--.44913W
X-CM-SenderInfo: asssliaqzvq6lmxovvfxof0/1tbiAg0GB2eFSrAYpgAAso
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW7Jw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

WWVzLCBhbmQgaXQgYWxzbyBwcm90ZWN0cyB0aGUga2VybmVsIGZyb20gdGhlIFBvQywgYXMgSSd2
ZSB0ZXN0ZWQuCgpPbiAyMDI1LTAxLTE0IDEwOjE3OjUwIExlaSBZYW5nIHdyb3RlOgo+IEkgdGVz
dGVkIHRoaXMgcGF0Y2ggd2l0aCB2aXJ0aW8tbmV0IHJlZ3Jlc3Npb24gdGVzdHMsIGV2ZXJ5dGhp
bmcgd29ya3MgZmluZS4KPiAKPiBUZXN0ZWQtYnk6IExlaSBZYW5nIDxsZWl5YW5nQHJlZGhhdC5j
b20+Cj4gCj4gCj4gT24gTW9uLCBKYW4gMTMsIDIwMjUgYXQgNToyMOKAr0FNIE1pa2UgQ2hyaXN0
aWUKPiA8bWljaGFlbC5jaHJpc3RpZUBvcmFjbGUuY29tPiB3cm90ZToKPiA+Cj4gPiBPbiAxLzEy
LzI1IDExOjM1IEFNLCBtaWNoYWVsLmNocmlzdGllQG9yYWNsZS5jb20gd3JvdGU6Cj4gPiA+IFNv
IEkgdGhpbmsgdG8gZml4IHRoZSBpc3N1ZSwgd2Ugd291bGQgd2FudCB0bzoKPiA+ID4KPiA+ID4g
MS4gbW92ZSB0aGUKPiA+ID4KPiA+ID4gbWVtY3B5KHZzX3RwZywgdnMtPnZzX3RwZywgbGVuKTsK
PiA+ID4KPiA+ID4gdG8gdGhlIGVuZCBvZiB0aGUgZnVuY3Rpb24gYWZ0ZXIgd2UgZG8gdGhlIHZo
b3N0X3Njc2lfZmx1c2guIFRoaXMgd2lsbAo+ID4gPiBiZSBtb3JlIGNvbXBsaWNhdGVkIHRoYW4g
dGhlIGN1cnJlbnQgbWVtY3B5IHRob3VnaC4gV2Ugd2lsbCB3YW50IHRvCj4gPiA+IG1lcmdlIHRo
ZSBsb2NhbCB2c190cGcgYW5kIHRoZSB2cy0+dnNfdHBnIGxpa2U6Cj4gPiA+Cj4gPiA+IGZvciAo
aSA9IDA7IGkgPCBWSE9TVF9TQ1NJX01BWF9UQVJHRVQ7IGkrKykgewo+ID4gPiAgICAgICBpZiAo
dnNfdHBnW2ldKQo+ID4gPiAgICAgICAgICAgICAgIHZzLT52c190cGdbaV0gPSB2c190cGdbaV0p
Cj4gPiA+IH0KPiA+Cj4gPiBJIHRoaW5rIEkgd3JvdGUgdGhhdCBpbiByZXZlcnNlLiBXZSB3b3Vs
ZCB3YW50Ogo+ID4KPiA+IHZob3N0X3Njc2lfZmx1c2godnMpOwo+ID4KPiA+IGlmICh2cy0+dnNf
dHBnKSB7Cj4gPiAgICAgICAgIGZvciAoaSA9IDA7IGkgPCBWSE9TVF9TQ1NJX01BWF9UQVJHRVQ7
IGkrKykgewo+ID4gICAgICAgICAgICAgICAgIGlmICh2cy0+dnNfdHBnW2ldKQo+ID4gICAgICAg
ICAgICAgICAgICAgICAgICAgdnNfdHBnW2ldID0gdnMtPnZzX3RwZ1tpXSkKPiA+ICAgICAgICAg
fQo+ID4gfQo+ID4KPiA+IGtmcmVlKHZzLT52c190cGcpOwo+ID4gdnMtPnZzX3RwZyA9IHZzX3Rw
ZzsKPiA+Cj4gPiBvciB3ZSBjb3VsZCBqdXN0IGFsbG9jYXRlIHRoZSB2c190cGcgd2l0aCB0aGUg
dmhvc3Rfc2NzaSBsaWtlOgo+ID4KPiA+IHN0cnVjdCB2aG9zdF9zY3NpIHsKPiA+ICAgICAgICAg
Li4uLgo+ID4KPiA+ICAgICAgICAgc3RydWN0IHZob3N0X3Njc2lfdHBnICp2c190cGdbVkhPU1Rf
U0NTSV9NQVhfVEFSR0VUXTsKPiA+Cj4gPiB0aGVuIHdoZW4gd2UgbG9vcCBpbiB2aG9zdF9zY3Np
X3NldC9jbGVhcl9lbmRwb2ludCBzZXQvY2xlYXIgdGhlCj4gPiBldmVyeSB2c190cGcgZW50cnku
Cj4gPgo=

