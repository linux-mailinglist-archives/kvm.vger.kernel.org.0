Return-Path: <kvm+bounces-12548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9CE3887A0F
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 20:02:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9263F1C20C52
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 19:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08FE247A70;
	Sat, 23 Mar 2024 19:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="ExGVrAu/"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6C63A8FF;
	Sat, 23 Mar 2024 19:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711220544; cv=none; b=uOXEK2tBHPSEKhRc3L9Kv3DikyGdhvxnMOYRTT9JSvLTjvx0vPzDdndE+bH4G3Fx0Qlsfmoc/kR5MIWfG5AOptYeLhVC7fa+XJLOtvcepIlmPFEzJoyy6GnWdjCc1WVeAIKWulZRWYTDkJEz0KGd+zyX/z2f8GQGpEIXQ26eYQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711220544; c=relaxed/simple;
	bh=tFoKc1U020apqjY0CyTn0PLkWp/8f59KT4myiLC5PH4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YdBo7j13RMneFf3PXswFto5b+8yqsMjyhkL22wvz6cNHxnHDVGopZaN01AEVQRJ7nRZV/l+sRO9pFJJNVpereBg0Bpji9/l8LJL6AR3jbVnrftFXUho788p1tIkDURKedepIjoxFoxtY0uG4BNxyF3EIX1b22YBtRaNT2PzX/tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=ExGVrAu/; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1711220539; bh=tFoKc1U020apqjY0CyTn0PLkWp/8f59KT4myiLC5PH4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ExGVrAu/5SFYnug9FVfmW9AU5A4FlDHPTXX9W8cY+kxaBK1DgNwGWCfWo/O0VEWTx
	 ZHNygDTnQ97aMEQOdKPQSi7o75izdTUhmIvu709DdWihl+1be7sP0NBJ3mWhFghB2m
	 SojDik3yNPgo/XZyJA7ok+vj+uiGTba3DwFphci0=
Received: from [IPV6:240e:388:8d00:6500:cccf:e2b8:7fab:4dfb] (unknown [IPv6:240e:388:8d00:6500:cccf:e2b8:7fab:4dfb])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 20B3C600A6;
	Sun, 24 Mar 2024 03:02:19 +0800 (CST)
Message-ID: <4668e606-a7b5-49b7-a68d-1c2af86f7d76@xen0n.name>
Date: Sun, 24 Mar 2024 03:02:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/7] LoongArch: KVM: Add cpucfg area for kvm hypervisor
Content-Language: en-US
To: Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240315080710.2812974-1-maobibo@loongson.cn>
 <20240315080710.2812974-4-maobibo@loongson.cn>
From: WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <20240315080710.2812974-4-maobibo@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/24 16:07, Bibo Mao wrote:
> Instruction cpucfg can be used to get processor features. And there
> is trap exception when it is executed in VM mode, and also it is
> to provide cpu features to VM. On real hardware cpucfg area 0 - 20
> is used.  Here one specified area 0x40000000 -- 0x400000ff is used
> for KVM hypervisor to privide PV features, and the area can be extended
> for other hypervisors in future. This area will never be used for
> real HW, it is only used by software.
> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>   arch/loongarch/include/asm/inst.h      |  1 +
>   arch/loongarch/include/asm/loongarch.h | 10 +++++
>   arch/loongarch/kvm/exit.c              | 59 +++++++++++++++++++-------
>   3 files changed, 54 insertions(+), 16 deletions(-)
> 

Sorry for the late reply, but I think it may be a bit non-constructive 
to repeatedly submit the same code without due explanation in our 
previous review threads. Let me try to recollect some of the details 
though...

If I remember correctly, during the previous reviews, it was mentioned 
that the only upsides of using CPUCFG were:

- it was exactly identical to the x86 approach,
- it would not require access to the LoongArch Reference Manual Volume 3 
to use, and
- it was plain old data.

But, for the first point, we don't have to follow x86 convention after 
all. The second reason might be compelling, but on the one hand that's 
another problem orthogonal to the current one, and on the other hand 
HVCL is:

- already effectively public because of the fact that this very patchset 
is public,
- its semantics is trivial to implement even without access to the LVZ 
manual, because of its striking similarity with SYSCALL, and
- by being a function call, we reserve the possibility for hypervisors 
to invoke logic for self-identification purposes, even if this is likely 
overkill from today's perspective.

And, even if we decide that using HVCL for self-identification is 
overkill after all, we still have another choice that's IOCSR. We 
already read LOONGARCH_IOCSR_FEATURES (0x8) for its bit 11 (IOCSRF_VM) 
to populate the CPU_FEATURE_HYPERVISOR bit, and it's only natural that 
we put the identification word in the IOCSR space. As far as I can see, 
the IOCSR space is plenty and equally available for making reservations; 
it can only be even easier when it's done by a Loongson team.

Finally, I've mentioned multiple times, that varying CPUCFG behavior 
based on PLV is not something well documented on the manuals, hence not 
friendly to low-level developers. Devs of third-party firmware and/or 
kernels do exist, I've personally spoken to some of them on the 
2023-11-18 3A6000 release event; in order for the varying CPUCFG 
behavior approach to pass for me, at the very least, the LoongArch 
reference manual must be amended to explicitly include an explanation of 
it, and a reference to potential use cases.

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/


