Return-Path: <kvm+bounces-66291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DFE2BCCE443
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 03:29:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 225CA303C809
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 02:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C37221FDA;
	Fri, 19 Dec 2025 02:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="f9b6Yn9l"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C9E17BA6;
	Fri, 19 Dec 2025 02:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766111290; cv=none; b=UXnosE11xu/UwIT4oZfYInsvoZl+ZXwpUAE+mFSjVGF6BUpW2us73wI5nNdRQnQB1+wDozsvz+861rIO46HGFrbdU9mq+wFPhGHE1CqAFfvZkMCXo5HkHyZ1GzgnkqV+gtg69MuPJ+DEj5VHlCR/NyTr97em7t8kmEpr9n14psw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766111290; c=relaxed/simple;
	bh=zzWTfLen8COuX/q/sKLUzJAtj9cSvrwCqbBUYVz6l10=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=I5G29TdC8gOZBDnC68qr5FIncKImMIi+EDXI3W59NThfcjLpkimx27qrQr3ZEFSBafrLu9PfhbF17nAsjClV+crIl2N6H08/4eLo6Fm5irUPMJ5irElG3Qi7ccO8qG5bhUVhcxMkD0XqGvK0MZbd/qLXX2upzNF4J29FRUihEGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=f9b6Yn9l; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=zzWTfLen8COuX/q/sKLUzJAtj9cSvrwCqbBUYVz6l10=; b=f
	9b6Yn9lpfldBIebFac8ZhjCAfipn5whg40ODcftNj/pMJAS2/R1nEXKECOUF7mwa
	7En0Kk5Lg4n9rU5PPO6f68NY4XANcZg8Fzn5k6pqs6vSexPCUr0vRBgls48z1Tnh
	g5amu67ah9mCP9PLJqN6C0uL0XSMwEiycAExhK7HFg=
Received: from 15927021679$163.com ( [116.128.244.169] ) by
 ajax-webmail-wmsvr-40-107 (Coremail) ; Fri, 19 Dec 2025 10:27:09 +0800
 (CST)
Date: Fri, 19 Dec 2025 10:27:09 +0800 (CST)
From: =?GBK?B?0NzOsMPxICA=?= <15927021679@163.com>
To: "Leon Romanovsky" <leon@kernel.org>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	"David Hildenbrand" <david@redhat.com>,
	"Jason Wang" <jasowang@redhat.com>,
	"Stefano Garzarella" <sgarzare@redhat.com>,
	"Thomas Monjalon" <thomas@monjalon.net>,
	"David Marchand" <david.marchand@redhat.com>,
	"Luca Boccassi" <bluca@debian.org>,
	"Kevin Traynor" <ktraynor@redhat.com>,
	"Christian Ehrhardt" <christian.ehrhardt@canonical.com>,
	"Xuan Zhuo" <xuanzhuo@linux.alibaba.com>,
	=?GBK?Q?Eugenio_P=A8=A6rez?= <eperezma@redhat.com>,
	"Xueming Li" <xuemingl@nvidia.com>,
	"Maxime Coquelin" <maxime.coquelin@redhat.com>,
	"Chenbo Xia" <chenbox@nvidia.com>,
	"Bruce Richardson" <bruce.richardson@intel.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	"RDMA mailing list" <linux-rdma@vger.kernel.org>
Subject: Re:Re: Implement initial driver for virtio-RDMA device(kernel)
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20250723(a044bf12) Copyright (c) 2002-2025 www.mailtech.cn 163com
In-Reply-To: <20251218163008.GH400630@unreal>
References: <20251218091050.55047-1-15927021679@163.com>
 <20251218163008.GH400630@unreal>
X-NTES-SC: AL_Qu2dBP2avkop7yKcYukfmU0VgOc9XsWwu/Uk2YRXc+AEvhn91i0NcGBfB13x3/C3Cw2orgSHdD9v4+NFc5ZjnscnuIaIph6uoKKQX33d3Q==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <7076944c.4ac4.19b346eb549.Coremail.15927021679@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:aygvCgBnhST9t0Rps8U_AA--.11607W
X-CM-SenderInfo: jprvmjixqsilmxzbiqqrwthudrp/xtbC0R2YIWlEt-1cmgAA3U
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CgoKCgoKCgoKCgoKCgoKCgoKQXQgMjAyNS0xMi0xOSAwMDozMDowOCwgIkxlb24gUm9tYW5vdnNr
eSIgPGxlb25Aa2VybmVsLm9yZz4gd3JvdGU6Cj5PbiBUaHUsIERlYyAxOCwgMjAyNSBhdCAwNTow
OTo0MFBNICswODAwLCBYaW9uZyBXZWltaW4gd3JvdGU6Cj4+IEhpIGFsbCwKPj4gCj4+IFRoaXMg
dGVzdGluZyBpbnN0cnVjdGlvbnMgYWltcyB0byBpbnRyb2R1Y2UgYW4gZW11bGF0aW5nIGEgc29m
dCBST0NFIAo+PiBkZXZpY2Ugd2l0aCBub3JtYWwgTklDKG5vIFJETUEpLCB3ZSBoYXZlIGZpbmlz
aGVkIGEgdmhvc3QtdXNlciBSRE1BCj4+IGRldmljZSBkZW1vLCB3aGljaCBjYW4gd29yayB3aXRo
IFJETUEgZmVhdHVyZXMgc3VjaCBhcyBDTSwgUVAgdHlwZSBvZiAKPj4gVUMvVUQgYW5kIHNvIG9u
Lgo+Cj5TYW1lIHF1ZXN0aW9uIGFzIG9uIHlvdXIgUUVNVSBwYXRjaGVzLgo+aHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvYWxsLzIwMjUxMjE4MTYyMDI4LkdHNDAwNjMwQHVucmVhbC8KPgo+QW5kIGFz
IGEgYmFyZSBtaW5pbXVtLCB5b3Ugc2hvdWxkIHJ1biBnZXRfbWFpbnRhaW5lcnMucGwgc2NyaXB0
IG9uIHlvdXIKPnBhdGNoZXMgYW5kIGFkZCB0aGUgcmlnaHQgcGVvcGxlIGFuZCBNTCB0byB0aGUg
Q0MvVE8gZmllbGRzLgo+Cgo+VGhhbmtzCgoKU2luY2UgdGhpcyBmZWF0dXJlIGludm9sdmVzIGNv
b3JkaW5hdGVkIGNoYW5nZXMgYWNyb3NzIFFFTVUsIERQREssIGFuZCB0aGUga2VybmVsLCAKSSBo
YXZlIHN1Ym1pdHRlZCBwYXRjaGVzIGZvciBhbGwgdGhyZWUgY29tcG9uZW50cyB0byBldmVyeSBt
YWludGFpbmVyLiBUaGlzIGlzIHRvIAplbnN1cmUgdGhhdCBzZW5pb3IgZGV2ZWxvcGVycyBjYW4g
cmV2aWV3IHRoZSBjb21wbGV0ZSBhcmNoaXRlY3R1cmUgYW5kIGNvZGUuCgoKVGhhbmtzLg==

