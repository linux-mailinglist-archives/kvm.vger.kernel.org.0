Return-Path: <kvm+bounces-25920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A801E96CD85
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 05:58:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E316281D35
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 03:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4117C14B07E;
	Thu,  5 Sep 2024 03:58:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E121448C7;
	Thu,  5 Sep 2024 03:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725508693; cv=none; b=IcRAQR4XuMhmxcOkG8oea5//NRA04Qe2o5QejS4Vp0J6O8jeTMHaQG6B7XLWuCY7+N48GuEj3/zI9gaGY3FLCre0lxVA+kJqMwIumTkDFlPGq1oE9DOGUF2MU3moaXyvny8BFD6zFu41GEwwI1jCnyDoHx1Yy/ElxyPmE019X1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725508693; c=relaxed/simple;
	bh=luQb3xUecoD0vUC9Su5msUMd9lpUG6JGBOQr8+FWYfE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TSZ4kRAPTlZkLQmCph8FFDecyKcPu37jMOe8tg4LcW/MRjW3xIQb0h0EX5iaj3WxsZOYoB/UsOJl6PVNQ5VyqYIibpzcDhfEvndOgzaOUvArTLzSzqC9WZt3KnaIuHo6HtUA5kmQ/bvlF25dF+MxymXZ+5aqOP/W+QYJbNknHqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxSupQLNlmLvsqAA--.17723S3;
	Thu, 05 Sep 2024 11:58:08 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front2 (Coremail) with SMTP id qciowMBxjcVMLNlme34GAA--.18366S3;
	Thu, 05 Sep 2024 11:58:04 +0800 (CST)
Subject: Re: [PATCH v3] Loongarch: KVM: Add KVM hypercalls documentation for
 LoongArch
To: Dandan Zhang <zhangdandan@uniontech.com>, pbonzini@redhat.com,
 corbet@lwn.net, zhaotianrui@loongson.cn, chenhuacai@kernel.org,
 zenghui.yu@linux.dev
Cc: kernel@xen0n.name, kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 guanwentao@uniontech.com, wangyuli@uniontech.com, baimingcong@uniontech.com,
 Xianglai Li <lixianglai@loongson.cn>, Mingcong Bai <jeffbai@aosc.io>
References: <4769C036576F8816+20240828045950.3484113-1-zhangdandan@uniontech.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <da7ce1b6-87a9-05ec-3a4d-0bdf5204c1b7@loongson.cn>
Date: Thu, 5 Sep 2024 11:58:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <4769C036576F8816+20240828045950.3484113-1-zhangdandan@uniontech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qciowMBxjcVMLNlme34GAA--.18366S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3AF18ArW7Ar4UtF4DKr47WrX_yoW7uw15pF
	95G34xKrs7Jry7Aw17tw15WryUAr97tF47C3WxJry0yr1DZr1fJr4Utr90ya18G348AFW0
	qF18tr1j9F1UJ3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
	6rW5McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jr9NsUUU
	UU=


On 2024/8/28 下午12:59, Dandan Zhang wrote:
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
>   Documentation/virt/kvm/index.rst              |  1 +
>   .../virt/kvm/loongarch/hypercalls.rst         | 89 +++++++++++++++++++
>   Documentation/virt/kvm/loongarch/index.rst    | 10 +++
>   MAINTAINERS                                   |  1 +
>   4 files changed, 101 insertions(+)
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
> index 000000000000..dd96ded5d17d
> --- /dev/null
> +++ b/Documentation/virt/kvm/loongarch/hypercalls.rst
> @@ -0,0 +1,89 @@
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
> +The CPUCFG_KVM_BASE range, spanning from 0x40000000 to 0x400000FF, The
> +CPUCFG_KVM_BASE range between 0x40000000 - 0x400000FF is marked as reserved.
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
> +	========	================	================
> +	Register	IN			OUT
> +	========	================	================
> +	a0		function number		Return	code
> +	a1		1st	parameter	-
> +	a2		2nd	parameter	-
> +	a3		3rd	parameter	-
> +	a4		4th	parameter	-
> +	a5		5th	parameter	-
> +	========	================	================
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
> +1. KVM_HCALL_FUNC_IPI
> +------------------------
> +
> +:Purpose: Send IPIs to multiple vCPUs.
> +
> +- a0: KVM_HCALL_FUNC_IPI
> +- a1: Lower part of the bitmap for destination physical CPUIDs
> +- a2: Higher part of the bitmap for destination physical CPUIDs
> +- a3: The lowest physical CPUID in the bitmap
> +
> +The hypercall lets a guest send multiple IPIs (Inter-Process Interrupts) with
> +at most 128 destinations per hypercall. The destinations are represented in a
> +bitmap contained in the first two input registers (a1 and a2).
> +
> +Bit 0 of a1 corresponds to the physical CPUID in the third input register (a3)
> +and bit 1 corresponds to the physical CPUID in a3+1, and so on.
> +
> +PV IPI on LoongArch includes both PV IPI multicast sending and PV IPI receiving,
> +and SWI is used for PV IPI inject since there is no VM-exits accessing SWI registers.
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
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 878dcd23b331..c267ad7cc2c5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12294,6 +12294,7 @@ L:	kvm@vger.kernel.org
>   L:	loongarch@lists.linux.dev
>   S:	Maintained
>   T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
> +F:	Documentation/virt/kvm/loongarch/
>   F:	arch/loongarch/include/asm/kvm*
>   F:	arch/loongarch/include/uapi/asm/kvm*
>   F:	arch/loongarch/kvm/
> 
Reviewed-by: Bibo Mao <maobibo@loongson.cn>


