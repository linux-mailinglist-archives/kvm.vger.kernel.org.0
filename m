Return-Path: <kvm+bounces-25063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1349095F750
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 19:01:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74E8FB21A0F
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 17:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B847198E89;
	Mon, 26 Aug 2024 17:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kNKervn9"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDBE18D638
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 17:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724691643; cv=none; b=oaTi8dixuaOmNJZ9VeTUnn2oaZ4hgxoEC8ypwxXDkFn3L1QbSsssFlkscLWOcctxu7Hzd7nOXk0I1YxaHw0kP0WMwxHgLBfH4oqgFOh4tyTcqReN2NUAHZ+S9pQ8OSoTDJdrdiXvWbMv+zGyx7VXGdRB8QPcrlvFsREWgH0vugM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724691643; c=relaxed/simple;
	bh=y57+2mOp6MwfLqW65/FGyTbYnYojmL4y+eOUfw6+Hb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JPt5jLStq4X99kQ+XOO4ZXZJEN3YXQGSUu3hqAGBoa7YHsFgPEfjEq1Gk49yso6zmrcLdfORbat5BfnLA7iQzBx8OAvjh2LKYOSgJSdwyzBxh5OpSxY1GcvKNDwfg4AajaDUG1zcH1ferybeH8oCVSMD+z9Hd6TxYJhNOUrC6Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kNKervn9; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <804a804c-f62d-4814-a174-51d19e3ea094@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724691637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rfGKENWRuewSAOwpAN/lMp6iaeHyoIbXcxwxsIfnPyA=;
	b=kNKervn9ODUPMnERP5FH//+eFPS7BSn0MTZ7GJszB97jBiYtlBjq1PsbN7jm6ET9+ZLwTV
	UQc0t1e1e4aY8waYq3kK3aGmTfn4Mvpa34C2oWeyTk6I0vDH2dKlKdgjF+8pKCYMhfPfPl
	u6P7dmeuHhb6yamg1LpgBfHuRa3A5Zs=
Date: Tue, 27 Aug 2024 01:00:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2] Loongarch: KVM: Add KVM hypercalls documentation for
 LoongArch
To: Dandan Zhang <zhangdandan@uniontech.com>
Cc: pbonzini@redhat.com, corbet@lwn.net, zhaotianrui@loongson.cn,
 maobibo@loongson.cn, chenhuacai@kernel.org, kernel@xen0n.name,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, guanwentao@uniontech.com,
 wangyuli@uniontech.com, baimingcong@uniontech.com,
 Xianglai Li <lixianglai@loongson.cn>, Mingcong Bai <jeffbai@aosc.io>
References: <DE6B1B9EAC9BEF4C+20240826054727.24166-1-zhangdandan@uniontech.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <DE6B1B9EAC9BEF4C+20240826054727.24166-1-zhangdandan@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

[ Trivial comments inline.  You can feel free to ignore them since I
  know almost nothing about loongarch. ]

On 2024/8/26 13:47, Dandan Zhang wrote:
> From: Bibo Mao <maobibo@loongson.cn>
> 
> Add documentation topic for using pv_virt when running as a guest
> on KVM hypervisor.
> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> Co-developed-by: Mingcong Bai <jeffbai@aosc.io>
> Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
> Link: https://lore.kernel.org/all/5c338084b1bcccc1d57dce9ddb1e7081@aosc.io/
> Signed-off-by: Dandan Zhang <zhangdandan@uniontech.com>
> ---
>  Documentation/virt/kvm/index.rst              |  1 +
>  .../virt/kvm/loongarch/hypercalls.rst         | 86 +++++++++++++++++++
>  Documentation/virt/kvm/loongarch/index.rst    | 10 +++
>  MAINTAINERS                                   |  1 +
>  4 files changed, 98 insertions(+)
>  create mode 100644 Documentation/virt/kvm/loongarch/hypercalls.rst
>  create mode 100644 Documentation/virt/kvm/loongarch/index.rst
> 
> diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
> index ad13ec55ddfe..9ca5a45c2140 100644
> --- a/Documentation/virt/kvm/index.rst
> +++ b/Documentation/virt/kvm/index.rst
> @@ -14,6 +14,7 @@ KVM
>     s390/index
>     ppc-pv
>     x86/index
> +   loongarch/index
>  
>     locking
>     vcpu-requests
> diff --git a/Documentation/virt/kvm/loongarch/hypercalls.rst b/Documentation/virt/kvm/loongarch/hypercalls.rst
> new file mode 100644
> index 000000000000..58168dc7166c
> --- /dev/null
> +++ b/Documentation/virt/kvm/loongarch/hypercalls.rst
> @@ -0,0 +1,86 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +===================================
> +The LoongArch paravirtual interface
> +===================================
> +
> +KVM hypercalls use the HVCL instruction with code 0x100 and the hypercall
> +number is put in a0. Up to five arguments may be placed in registers a1 - a5.
> +The return value is placed in v0 (an alias of a0).
> +
> +Source code for this interface can be found in arch/loongarch/kvm*.
> +
> +Querying for existence
> +======================
> +
> +To determine if the host is running on KVM, we can utilize the cpucfg()
> +function at index CPUCFG_KVM_BASE (0x40000000).
> +
> +The CPUCPU_KVM_BASE range, spanning from 0x40000000 to 0x400000FF, The
> +CPUCPU_KVM_BASE range between 0x40000000 - 0x400000FF is marked as reserved.

What is CPUCPU_KVM_BASE? Grepping it in the code shows nothing.

> +Consequently, all current and future processors will not implement any
> +feature within this range.
> +
> +On a KVM-virtualized Linux system, a read operation on cpucfg() at index
> +CPUCFG_KVM_BASE (0x40000000) returns the magic string 'KVM\0'.
> +
> +Once you have determined that your host is running on a paravirtualization-
> +capable KVM, you may now use hypercalls as described below.
> +
> +KVM hypercall ABI
> +=================
> +
> +The KVM hypercall ABI is simple, with one scratch register a0 (v0) and at most
> +five generic registers (a1 - a5) used as input parameters. The FP (Floating-
> +point) and vector registers are not utilized as input registers and must
> +remain unmodified during a hypercall.
> +
> +Hypercall functions can be inlined as it only uses one scratch register.
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

Please consistently use tab.

> +
> +The return codes may be one of the following:
> +
> +	====		=========================
> +	Code		Meaning
> +	====		=========================
> +	0		Success
> +	-1		Hypercall not implemented
> +	-2		Bad Hypercall parameter
> +	====		=========================
> +
> +KVM Hypercalls Documentation
> +============================
> +
> +The template for each hypercall is as follows:
> +
> +1. Hypercall name
> +2. Purpose
> +
> +1. KVM_HCALL_FUNC_PV_IPI

Is it still a work-in-progress thing? I don't see it in mainline.

> +------------------------
> +
> +:Purpose: Send IPIs to multiple vCPUs.
> +
> +- a0: KVM_HCALL_FUNC_PV_IPI
> +- a1: Lower part of the bitmap for destination physical CPUIDs
> +- a2: Higher part of the bitmap for destination physical CPUIDs
> +- a3: The lowest physical CPUID in the bitmap

- Is it a feature that implements IPI broadcast with a PV method?
- Don't you need to *at least* specify which IPI to send by issuing this
  hypercall?

But again, as I said I know nothing about loongarch.  I might have
missed some obvious points.

> +
> +The hypercall lets a guest send multiple IPIs (Inter-Process Interrupts) with
> +at most 128 destinations per hypercall.The destinations are represented in a
                                          ^
Add a blank space.

> +bitmap contained in the first two input registers (a1 and a2).
> +
> +Bit 0 of a1 corresponds to the physical CPUID in the third input register (a3)
> +and bit 1 corresponds to the physical CPUID in a3+1 (a4), and so on.

This looks really confusing.  "Bit 63 of a1 corresponds to the physical
CPUID in a3+63 (a66)"?

Zenghui

