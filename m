Return-Path: <kvm+bounces-5509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9565822915
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 08:41:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1D4C1C23041
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 07:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E676182D2;
	Wed,  3 Jan 2024 07:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bnxs7XKZ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bnxs7XKZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A464D182BF;
	Wed,  3 Jan 2024 07:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0AB7E2200B;
	Wed,  3 Jan 2024 07:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1704267635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FvJqj9G6CkaWfL2tvKqatPGcr7aAI+dxETtjoKbXHu8=;
	b=bnxs7XKZQL0mt8b9tuWY+pRaPYoSyCWS4RbRaqi29aQYNzE6ogl5+djG1acGcg27PykGeF
	Aj8/Do3Gw5ScwVHVts1sYFFwWA3/GsFN2kv3lr1S78oUPXKhN5RYoAcP07KQ3bdNIWppAr
	YXfHgcgCzlwCbf+pTq52Qpe6Jc/lWFY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1704267635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FvJqj9G6CkaWfL2tvKqatPGcr7aAI+dxETtjoKbXHu8=;
	b=bnxs7XKZQL0mt8b9tuWY+pRaPYoSyCWS4RbRaqi29aQYNzE6ogl5+djG1acGcg27PykGeF
	Aj8/Do3Gw5ScwVHVts1sYFFwWA3/GsFN2kv3lr1S78oUPXKhN5RYoAcP07KQ3bdNIWppAr
	YXfHgcgCzlwCbf+pTq52Qpe6Jc/lWFY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C4EA113AA6;
	Wed,  3 Jan 2024 07:40:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HhhGLnIPlWWGUQAAD6G6ig
	(envelope-from <jgross@suse.com>); Wed, 03 Jan 2024 07:40:34 +0000
Message-ID: <66c15a1b-fb28-4653-982f-37494a01cd4f@suse.com>
Date: Wed, 3 Jan 2024 08:40:34 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] LoongArch: Add paravirt interface for guest kernel
Content-Language: en-US
To: Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240103071615.3422264-1-maobibo@loongson.cn>
 <20240103071615.3422264-5-maobibo@loongson.cn>
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
In-Reply-To: <20240103071615.3422264-5-maobibo@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Level: 
X-Spamd-Result: default: False [-2.32 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 RCPT_COUNT_SEVEN(0.00)[7];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[loongson.cn:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 R_MIXED_CHARSET(0.77)[subject];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Score: -2.32
X-Spam-Flag: NO

On 03.01.24 08:16, Bibo Mao wrote:
> The patch add paravirt interface for guest kernel, it checks whether
> system runs on VM mode. If it is, it will detect hypervisor type. And
> returns true it is KVM hypervisor, else return false. Currently only
> KVM hypervisor is supported, so there is only hypervisor detection
> for KVM type.

I guess you are talking of pv_guest_init() here? Or do you mean
kvm_para_available()?

> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>   arch/loongarch/Kconfig                        |  8 ++++
>   arch/loongarch/include/asm/kvm_para.h         |  7 ++++
>   arch/loongarch/include/asm/paravirt.h         | 27 ++++++++++++
>   .../include/asm/paravirt_api_clock.h          |  1 +
>   arch/loongarch/kernel/Makefile                |  1 +
>   arch/loongarch/kernel/paravirt.c              | 41 +++++++++++++++++++
>   arch/loongarch/kernel/setup.c                 |  2 +
>   7 files changed, 87 insertions(+)
>   create mode 100644 arch/loongarch/include/asm/paravirt.h
>   create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.h
>   create mode 100644 arch/loongarch/kernel/paravirt.c
> 
> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> index ee123820a476..940e5960d297 100644
> --- a/arch/loongarch/Kconfig
> +++ b/arch/loongarch/Kconfig
> @@ -564,6 +564,14 @@ config CPU_HAS_PREFETCH
>   	bool
>   	default y
>   
> +config PARAVIRT
> +	bool "Enable paravirtualization code"
> +	help
> +          This changes the kernel so it can modify itself when it is run
> +	  under a hypervisor, potentially improving performance significantly
> +	  over full virtualization.  However, when run without a hypervisor
> +	  the kernel is theoretically slower and slightly larger.
> +
>   config ARCH_SUPPORTS_KEXEC
>   	def_bool y
>   
> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
> index 9425d3b7e486..41200e922a82 100644
> --- a/arch/loongarch/include/asm/kvm_para.h
> +++ b/arch/loongarch/include/asm/kvm_para.h
> @@ -2,6 +2,13 @@
>   #ifndef _ASM_LOONGARCH_KVM_PARA_H
>   #define _ASM_LOONGARCH_KVM_PARA_H
>   
> +/*
> + * Hypcall code field
> + */
> +#define HYPERVISOR_KVM			1
> +#define HYPERVISOR_VENDOR_SHIFT		8
> +#define HYPERCALL_CODE(vendor, code)	((vendor << HYPERVISOR_VENDOR_SHIFT) + code)
> +
>   /*
>    * LoongArch hypcall return code
>    */
> diff --git a/arch/loongarch/include/asm/paravirt.h b/arch/loongarch/include/asm/paravirt.h
> new file mode 100644
> index 000000000000..b64813592ba0
> --- /dev/null
> +++ b/arch/loongarch/include/asm/paravirt.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_LOONGARCH_PARAVIRT_H
> +#define _ASM_LOONGARCH_PARAVIRT_H
> +
> +#ifdef CONFIG_PARAVIRT
> +#include <linux/static_call_types.h>
> +struct static_key;
> +extern struct static_key paravirt_steal_enabled;
> +extern struct static_key paravirt_steal_rq_enabled;
> +
> +u64 dummy_steal_clock(int cpu);
> +DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
> +
> +static inline u64 paravirt_steal_clock(int cpu)
> +{
> +	return static_call(pv_steal_clock)(cpu);
> +}
> +
> +int pv_guest_init(void);
> +#else
> +static inline int pv_guest_init(void)
> +{
> +	return 0;
> +}
> +
> +#endif // CONFIG_PARAVIRT
> +#endif
> diff --git a/arch/loongarch/include/asm/paravirt_api_clock.h b/arch/loongarch/include/asm/paravirt_api_clock.h
> new file mode 100644
> index 000000000000..65ac7cee0dad
> --- /dev/null
> +++ b/arch/loongarch/include/asm/paravirt_api_clock.h
> @@ -0,0 +1 @@
> +#include <asm/paravirt.h>
> diff --git a/arch/loongarch/kernel/Makefile b/arch/loongarch/kernel/Makefile
> index 3c808c680370..662e6e9de12d 100644
> --- a/arch/loongarch/kernel/Makefile
> +++ b/arch/loongarch/kernel/Makefile
> @@ -48,6 +48,7 @@ obj-$(CONFIG_MODULES)		+= module.o module-sections.o
>   obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
>   
>   obj-$(CONFIG_PROC_FS)		+= proc.o
> +obj-$(CONFIG_PARAVIRT)		+= paravirt.o
>   
>   obj-$(CONFIG_SMP)		+= smp.o
>   
> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
> new file mode 100644
> index 000000000000..21d01d05791a
> --- /dev/null
> +++ b/arch/loongarch/kernel/paravirt.c
> @@ -0,0 +1,41 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/export.h>
> +#include <linux/types.h>
> +#include <linux/jump_label.h>
> +#include <linux/kvm_para.h>
> +#include <asm/paravirt.h>
> +#include <linux/static_call.h>
> +
> +struct static_key paravirt_steal_enabled;
> +struct static_key paravirt_steal_rq_enabled;
> +
> +static u64 native_steal_clock(int cpu)
> +{
> +	return 0;
> +}
> +
> +DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);

This is the 4th arch with the same definition of native_steal_clock() and
pv_steal_clock. I think we should add a common file kernel/paravirt.c and
move the related functions from the archs into the new file.

If you don't want to do that I can prepare a series.

> +
> +static bool kvm_para_available(void)
> +{
> +	static int hypervisor_type;
> +	int config;
> +
> +	if (!hypervisor_type) {
> +		config = read_cpucfg(CPUCFG_KVM_SIG);
> +		if (!memcmp(&config, KVM_SIGNATURE, 4))
> +			hypervisor_type = HYPERVISOR_KVM;
> +	}
> +
> +	return hypervisor_type == HYPERVISOR_KVM;
> +}
> +
> +int __init pv_guest_init(void)
> +{
> +	if (!cpu_has_hypervisor)
> +		return 0;
> +	if (!kvm_para_available())
> +		return 0;
> +
> +	return 1;
> +}
> diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
> index d183a745fb85..fa680bdd0bd1 100644
> --- a/arch/loongarch/kernel/setup.c
> +++ b/arch/loongarch/kernel/setup.c
> @@ -43,6 +43,7 @@
>   #include <asm/efi.h>
>   #include <asm/loongson.h>
>   #include <asm/numa.h>
> +#include <asm/paravirt.h>
>   #include <asm/pgalloc.h>
>   #include <asm/sections.h>
>   #include <asm/setup.h>
> @@ -376,6 +377,7 @@ void __init platform_init(void)
>   	pr_info("The BIOS Version: %s\n", b_info.bios_version);
>   
>   	efi_runtime_init();
> +	pv_guest_init();

Any reason pv_guest_init() needs to return a value at all, seeing that you don't
use the returned value?


Juergen

