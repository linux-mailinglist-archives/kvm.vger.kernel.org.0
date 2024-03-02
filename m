Return-Path: <kvm+bounces-10721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E440C86EFE1
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 10:41:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1374F1C21A3A
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 09:41:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8CA14F7A;
	Sat,  2 Mar 2024 09:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="OULgf+63"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5335213FF1;
	Sat,  2 Mar 2024 09:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709372476; cv=none; b=WuTmeOmifKQTiAlgsYkd1VegkaHHoCLDoHwskpZcxvb8UeIEooHU+jd1QHNMyEkNg/yLMdPP7J7uoOpOzjEUl3Ah3FUMSFgdmPhpEE5670s00eIPZecuFOuQMXU/kaczsWAA01MJRP9BKbPtAxukubzpa1FapmU78KQLTTGJ38o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709372476; c=relaxed/simple;
	bh=XTih0RkV+CLsUxb68gWgpYMc79wSK+RIgjrzwxf8ctM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n0PHx4TebWGvWcN7r/S8/rEQUqgJk/OZDLZGXyVWPAAoh6CsIXWebCPItJGfV/dTnmn3kOlq+y3D7deF3owyOI3iOx7bhrLn6v6kvu6OfZ9ZkGgwW/DHAPR5lb+6wlNLvmtw880xu/D88vdXN1eKvRRouA3C3B0k+cM333F5J4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=OULgf+63; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1709372465; bh=XTih0RkV+CLsUxb68gWgpYMc79wSK+RIgjrzwxf8ctM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OULgf+638+aCiElp0G+z/v4qC41UAXqkxeuPcXc4MhNzBsg6mWQHalasEEV+Zsa+I
	 ZDYUE3QszDFZ1kKzjap29VlXyHV7aQiFHYV/wmDZYfQLEdyDzTZL8UNb4n6gjWX8w1
	 g1+x+P4XIWq8qjFsfHnB5yAyTVQVtuiPM7OHmKYk=
Received: from [IPV6:240e:46c:8710:297d:42ab:1d29:9ba8:1e03] (unknown [IPv6:240e:46c:8710:297d:42ab:1d29:9ba8:1e03])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 50A5D60111;
	Sat,  2 Mar 2024 17:41:04 +0800 (CST)
Message-ID: <846a5e46-4e8f-4f73-ac5b-323e78ec1bb1@xen0n.name>
Date: Sat, 2 Mar 2024 17:41:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/7] Documentation: KVM: Add hypercall for LoongArch
To: Bibo Mao <maobibo@loongson.cn>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240302082532.1415200-1-maobibo@loongson.cn>
 <20240302084724.1415344-1-maobibo@loongson.cn>
Content-Language: en-US
From: WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <20240302084724.1415344-1-maobibo@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/2/24 16:47, Bibo Mao wrote:
> Add documentation topic for using pv_virt when running as a guest
> on KVM hypervisor.
> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>   Documentation/virt/kvm/index.rst              |  1 +
>   .../virt/kvm/loongarch/hypercalls.rst         | 79 +++++++++++++++++++
>   Documentation/virt/kvm/loongarch/index.rst    | 10 +++
>   3 files changed, 90 insertions(+)
>   create mode 100644 Documentation/virt/kvm/loongarch/hypercalls.rst
>   create mode 100644 Documentation/virt/kvm/loongarch/index.rst
> 
> diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
> index ad13ec55ddfe..9ca5a45c2140 100644
> --- a/Documentation/virt/kvm/index.rst
> +++ b/Documentation/virt/kvm/index.rst
> @@ -14,6 +14,7 @@ KVM
>      s390/index
>      ppc-pv
>      x86/index
> +   loongarch/index
>   
>      locking
>      vcpu-requests
> diff --git a/Documentation/virt/kvm/loongarch/hypercalls.rst b/Documentation/virt/kvm/loongarch/hypercalls.rst
> new file mode 100644
> index 000000000000..1679e48d67d2
> --- /dev/null
> +++ b/Documentation/virt/kvm/loongarch/hypercalls.rst
> @@ -0,0 +1,79 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +===================================
> +The LoongArch paravirtual interface
> +===================================
> +
> +KVM hypercalls use the HVCL instruction with code 0x100, and the hypercall
> +number is put in a0 and up to five arguments may be placed in a1-a5, the
> +return value is placed in v0 (alias with a0).

Just say a0: the name v0 is long deprecated (has been the case ever 
since LoongArch got mainlined).

> +
> +The code for that interface can be found in arch/loongarch/kvm/*
> +
> +Querying for existence
> +======================
> +
> +To find out if we're running on KVM or not, cpucfg can be used with index
> +CPUCFG_KVM_BASE (0x40000000), cpucfg range between 0x40000000 - 0x400000FF
> +is marked as a specially reserved range. All existing and future processors
> +will not implement any features in this range.
> +
> +When Linux is running on KVM, cpucfg with index CPUCFG_KVM_BASE (0x40000000)
> +returns magic string "KVM\0"
> +
> +Once you determined you're running under a PV capable KVM, you can now use
> +hypercalls as described below.

So this is still the approach similar to the x86 CPUID-based 
implementation. But here the non-privileged behavior isn't specified -- 
I see there is PLV checking in Patch 3 but it's safer to have the 
requirement spelled out here too.

But I still think this approach touches more places than strictly 
needed. As it is currently the case in 
arch/loongarch/kernel/cpu-probe.c, the FEATURES IOCSR is checked for a 
bit IOCSRF_VM that already signifies presence of a hypervisor; if this 
information can be interpreted as availability of the HVCL instruction 
(which I suppose is the case -- a hypervisor can always trap-and-emulate 
in case HVCL isn't provided by hardware), here we can already start 
making calls with HVCL.

We can and should define a uniform interface for probing the hypervisor 
kind, similar to the centrally-managed RISC-V SBI implementation ID 
registry [1]: otherwise future non-KVM hypervisors would have to

1. somehow pretend they are KVM and eventually fail to do so, leading to 
subtle incompatibilities,
2. invent another way of probing for their existence,
3. piggy-back on the current KVM definition, which is inelegant (reading 
the LoongArch-KVM-defined CPUCFG leaf only to find it's not KVM) and 
utterly makes the definition here *not* KVM-specific.

[1]: 
https://github.com/riscv-non-isa/riscv-sbi-doc/blob/v2.0/src/ext-base.adoc

My take on this:

To check if we are running on Linux KVM or not, first check IOCSR 0x8 
(``LOONGARCH_IOCSR_FEATURES``) for bit 11 (``IOCSRF_VM``); we are 
running under a hypervisor if the bit is set. Then invoke ``HVCL 0`` to 
find out the hypervisor implementation ID; a return value in ``$a0`` of 
0x004d564b (``KVM\0``) means Linux KVM, in which case the rest of the 
convention applies.

> +
> +KVM hypercall ABI
> +=================
> +
> +Hypercall ABI on KVM is simple, only one scratch register a0 (v0) and at most
> +five generic registers used as input parameter. FP register and vector register
> +is not used for input register and should not be modified during hypercall.
> +Hypercall function can be inlined since there is only one scratch register.

It should be pointed out explicitly that on hypercall return all 
architectural state except ``$a0`` is preserved. Or is the whole ``$a0 - 
$t8`` range clobbered, just like with Linux syscalls?

> +
> +The parameters are as follows:
> +
> +        ========	================	================
> +	Register	IN			OUT
> +        ========	================	================
> +	a0		function number		Return code
> +	a1		1st parameter		-
> +	a2		2nd parameter		-
> +	a3		3rd parameter		-
> +	a4		4th parameter		-
> +	a5		5th parameter		-
> +        ========	================	================
> +
> +Return codes can be as follows:
> +
> +	====		=========================
> +	Code		Meaning
> +	====		=========================
> +	0		Success
> +	-1		Hypercall not implemented
> +	-2		Hypercall parameter error

What about re-using well-known errno's, like -ENOSYS for "hypercall not 
implemented" and -EINVAL for "invalid parameter"? This could save people 
some hair when more error codes are added in the future.

> +	====		=========================
> +
> +KVM Hypercalls Documentation
> +============================
> +
> +The template for each hypercall is:
> +1. Hypercall name
> +2. Purpose
> +
> +1. KVM_HCALL_FUNC_PV_IPI
> +------------------------
> +
> +:Purpose: Send IPIs to multiple vCPUs.
> +
> +- a0: KVM_HCALL_FUNC_PV_IPI
> +- a1: lower part of the bitmap of destination physical CPUIDs
> +- a2: higher part of the bitmap of destination physical CPUIDs
> +- a3: the lowest physical CPUID in bitmap

"CPU ID", instead of "CPUID" for clarity: I suppose most people reading 
this also know about x86, so "CPUID" could evoke the wrong intuition.

This function is equivalent to the C signature "void hypcall(int func, 
u128 mask, int lowest_cpu_id)", which I think is fine, but one can also 
see that the return value description is missing.

> +
> +The hypercall lets a guest send multicast IPIs, with at most 128
> +destinations per hypercall.  The destinations are represented by a bitmap
> +contained in the first two arguments (a1 and a2). Bit 0 of a1 corresponds
> +to the physical CPUID in the third argument (a3), bit 1 corresponds to the
> +physical ID a3+1, and so on.
> diff --git a/Documentation/virt/kvm/loongarch/index.rst b/Documentation/virt/kvm/loongarch/index.rst
> new file mode 100644
> index 000000000000..83387b4c5345
> --- /dev/null
> +++ b/Documentation/virt/kvm/loongarch/index.rst
> @@ -0,0 +1,10 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=========================
> +KVM for LoongArch systems
> +=========================
> +
> +.. toctree::
> +   :maxdepth: 2
> +
> +   hypercalls.rst

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/


