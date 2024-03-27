Return-Path: <kvm+bounces-12776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2430488D9B7
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 10:01:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D6502A4687
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 09:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67F88364B4;
	Wed, 27 Mar 2024 09:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="BvTXXgW8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B93B376EC
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 09:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711530062; cv=none; b=WCgEWJstkDmzQenY/dG0c3/mxw3TygC7DRBvjPoN/15M0IEVbeldCppqawaZSK3UuNdee4IMY/4oKzkc9cja8dg4CmKcTr/V9ELum/ekGbUvZ3MNENsgnMKHm/lU80LtbcTquPkoveKbhj2Q1ipRoc5i+Z8u0yH9i2f6xQslRFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711530062; c=relaxed/simple;
	bh=5lba8/CGXQFs8kwH8R0Cu9xECwgKSeojyHNB9Dgo8Nc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pVI+i+l+p9K+eBehkXzodHB470sJzpv7zv5Z2ypKesl4TX6b7Xig0g8+BfuTWMzwDFnWEJ61xkCsdREHif12C2PFcXXm7PNGU7cLpPdFu0Mw0H2CMfGNsb03OjOB8nT6PQlHK2gCda4c4aVUhrc677Dx6ExUcmH7baLK5X5zng8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=BvTXXgW8; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-56c147205b9so1182578a12.0
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 02:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1711530057; x=1712134857; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S49Ir8EzIqeN8C+9F3Bf+M9f6K8kth+RpT7bWNpScDo=;
        b=BvTXXgW8Frt7VtCzhZfpm3ExfNlbHlIeFU0srn/3GRNNrZmHC2GXH3F0zHswtHIRTz
         20+Hfv7Jx2mQvji32UrZmgDIVC9FyIR6OVfiGJVh3J32wgYdsF9/eqMOEzb8jUZcGN1n
         /AClixf52xS6NeefX6WyoSfAuZ+b1TZN3om40+OxHKqPBBgE0W+trpFMrzfnxPK2/znz
         IcaRoVDiq6yKHYlB0gPf0U5VOdwCX3JLzaZOhXRnUvhZ6D/Ult71JCjNpkelqaf5FTJq
         gLc6FwGRxiSGuI6UWtFFrzwOFykgAmu+T677hDWqhnAJVtE0cf1UemxLPJHKA1aEvJU3
         wLuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711530057; x=1712134857;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S49Ir8EzIqeN8C+9F3Bf+M9f6K8kth+RpT7bWNpScDo=;
        b=okbmHjfWtr+lbMyHWwq1Vk0jPyDwBvT14Gtt1Gx1RGD7ErakUhH14UOGIyXPoLgrLu
         ioRCX0XCZQ89DMtcjfAGOrc1vtjmz4s+xElUy6zCm0wbigfw7qYe/2tNHjZSUd2x55eS
         iXNeQdk+BIxYdPIih0e1m7f7ra0ep1h+qlEed5/tL7zr11hLAyJBT4cMOWT017fai6w4
         QkDnpjpkLpSRuuM1SqTHNO0LvgUKgKk/RscuoLOOZsm78BE+ZAs3TiSh0x23xpE2mkFC
         T3XMtwZRq4TXTjn/PJCeCUJbnOtQLJaJLAwvbrDLq7qAZIoWR18CQWDGGRj5U//bupse
         1cyw==
X-Gm-Message-State: AOJu0Yw7XGaLqDjRoawuK48JuXlzWRCultm2ZrdM0X095yZV4gW4XTP0
	plHRFjQ2Xkyqzz1NLEYKb9RkmmuJLM5FoXPQBDI7Vl324DIJyV/sdWI2+RZ/y5k=
X-Google-Smtp-Source: AGHT+IEf8aAXBKVnDzQacY2yUJF6GBWyxPo0MzPbJ+qTxinZSB4n5jHt4nNjNkp/13kffrjN6kBmzA==
X-Received: by 2002:a50:d4cc:0:b0:56c:197c:ba49 with SMTP id e12-20020a50d4cc000000b0056c197cba49mr3486063edj.8.1711530056938;
        Wed, 27 Mar 2024 02:00:56 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id n5-20020a056402434500b0056c3e65caecsm405547edc.2.2024.03.27.02.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 02:00:56 -0700 (PDT)
Date: Wed, 27 Mar 2024 10:00:55 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	anup@brainfault.org, atishp@atishpatra.org, pbonzini@redhat.com, shuah@kernel.org, 
	dbarboza@ventanamicro.com, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, haibo1.xu@intel.com, duchao713@qq.com
Subject: Re: [PATCH v3 3/3] RISC-V: KVM: selftests: Add ebreak test support
Message-ID: <20240327-b867e01dab2996d68c15f899@orel>
References: <20240327075526.31855-1-duchao@eswincomputing.com>
 <20240327075526.31855-4-duchao@eswincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327075526.31855-4-duchao@eswincomputing.com>

On Wed, Mar 27, 2024 at 07:55:26AM +0000, Chao Du wrote:
> Initial support for RISC-V KVM ebreak test. Check the exit reason and
> the PC when guest debug is enabled. Also to make sure the guest could
> handle the ebreak exception without exiting to the VMM when guest debug
> is not enabled.
> 
> Signed-off-by: Chao Du <duchao@eswincomputing.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../testing/selftests/kvm/riscv/ebreak_test.c | 84 +++++++++++++++++++
>  2 files changed, 85 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/riscv/ebreak_test.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 741c7dc16afc..7f4430242c9e 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -189,6 +189,7 @@ TEST_GEN_PROGS_s390x += rseq_test
>  TEST_GEN_PROGS_s390x += set_memory_region_test
>  TEST_GEN_PROGS_s390x += kvm_binary_stats_test
>  
> +TEST_GEN_PROGS_riscv += riscv/ebreak_test
>  TEST_GEN_PROGS_riscv += arch_timer
>  TEST_GEN_PROGS_riscv += demand_paging_test
>  TEST_GEN_PROGS_riscv += dirty_log_test
> diff --git a/tools/testing/selftests/kvm/riscv/ebreak_test.c b/tools/testing/selftests/kvm/riscv/ebreak_test.c
> new file mode 100644
> index 000000000000..4c79c778e026
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/riscv/ebreak_test.c
> @@ -0,0 +1,84 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * RISC-V KVM ebreak test.
> + *
> + * Copyright 2024 Beijing ESWIN Computing Technology Co., Ltd.
> + *
> + */
> +#include "kvm_util.h"
> +
> +#define PC(v) ((uint64_t)&(v))

PC() isn't a good name for the function this is doing. It's getting
the address of a label. LABEL_ADDRESS() would be more appropriate.

> +
> +extern unsigned char sw_bp_1, sw_bp_2;
> +static volatile uint64_t sw_bp_addr;

Drop volatile here and use READ/WRITE_ONCE on sw_bp_addr when reading and
writing it.

> +
> +static void guest_code(void)
> +{
> +	/*
> +	 * nops are inserted to make sure that the "pc += 4" operation is
> +	 * compatible with the compressed instructions.
> +	 */
> +	asm volatile("sw_bp_1: ebreak\n"
> +		     "nop\n"
> +		     "sw_bp_2: ebreak\n"
> +		     "nop\n");

The nops are fine, but options should work too, something like

 asm volatile(
 ".option push\n"
 ".option norvc\n"
 "sw_bp_1: ebreak\n"
 "sw_bp_2: ebreak\n"
 ".option pop\n"
 );

> +	GUEST_ASSERT_EQ(sw_bp_addr, PC(sw_bp_2));
> +
> +	GUEST_DONE();
> +}
> +
> +static void guest_breakpoint_handler(struct ex_regs *regs)
> +{
> +	sw_bp_addr = regs->epc;
> +	regs->epc += 4;
> +}
> +
> +int main(void)
> +{
> +	struct kvm_vm *vm;
> +	struct kvm_vcpu *vcpu;
> +	uint64_t pc;
> +	struct kvm_guest_debug debug = {
> +		.control = KVM_GUESTDBG_ENABLE,
> +	};
> +	struct ucall uc;

You don't use 'uc', so you can drop it and...

> +
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SET_GUEST_DEBUG));
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +
> +	vm_init_vector_tables(vm);
> +	vcpu_init_vector_tables(vcpu);
> +	vm_install_exception_handler(vm, EXC_BREAKPOINT,
> +					guest_breakpoint_handler);
> +
> +	/*
> +	 * Enable the guest debug.
> +	 * ebreak should exit to the VMM with KVM_EXIT_DEBUG reason.
> +	 */
> +	vcpu_guest_debug_set(vcpu, &debug);
> +	vcpu_run(vcpu);
> +
> +	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_DEBUG);
> +
> +	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.pc), &pc);
> +	TEST_ASSERT_EQ(pc, PC(sw_bp_1));
> +
> +	/* skip sw_bp_1 */
> +	vcpu_set_reg(vcpu, RISCV_CORE_REG(regs.pc), pc + 4);
> +
> +	/*
> +	 * Disable all debug controls.
> +	 * Guest should handle the ebreak without exiting to the VMM.
> +	 */
> +	memset(&debug, 0, sizeof(debug));
> +	vcpu_guest_debug_set(vcpu, &debug);
> +
> +	vcpu_run(vcpu);
> +
> +	TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_DONE);

...call get_ucall() with NULL for the second parameter.

> +
> +	kvm_vm_free(vm);
> +
> +	return 0;
> +}
> -- 
> 2.17.1
>

Thanks,
drew

