Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE68F371565
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 14:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbhECMu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 08:50:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53581 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233757AbhECMu2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 08:50:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620046175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7N8wM6pd3fJDs1XgZWnHBJrRXPxm44PfvPFau0sejL0=;
        b=bugwkIrX8Cx/69wR+y3T64ryYQtxYS38kTaP35OgIZzkufSAAxbygbrOu9r0NPQ0Y5/ved
        /Cphv7zM7SkogWOFkkpXbwwqGjrOwl8MoXTUXYEhC1ItTB+mWa8HZGHG9vWo8Hl4oBN+UX
        M8pzGlvQXUjfLe7MFgjrvP5cUrPNswA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-elh-gkBsP7CtqSrv_stlWw-1; Mon, 03 May 2021 08:49:33 -0400
X-MC-Unique: elh-gkBsP7CtqSrv_stlWw-1
Received: by mail-wr1-f70.google.com with SMTP id 88-20020adf95610000b029010758d8d7e2so3832760wrs.19
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 05:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7N8wM6pd3fJDs1XgZWnHBJrRXPxm44PfvPFau0sejL0=;
        b=Ux78jY1JyKM/EFNx0khPAgzAnc6k8alLaRq2r8rXyKG1Jto55YsINFeWVNsrus1Xr5
         5q05LPw1zl/dSQCCKv/nJoeLQoI3cTIqzn6wFSyP19HkJrhW7lv0vF0sDMyArw9B0i60
         oVOQhmnoRQZI0HooicroQJzm6BZWsa68DoG1fHleOCHBuknAVUo18ZWYBTCUdgplfADh
         RbZRXQ17i47Zca9F3TB3jWUxcCjA02Pb+tz/785eICm1bkB6y8wFaVsR/no47d7G5Tjo
         6/MbeFwztjYmNqcnsmUhKrgZojcFNsOGgNZ93o5mrJVe5+iELPtSDWp7FQmm13aOYMjY
         uLtg==
X-Gm-Message-State: AOAM532UclxG+E91+2UanuIoBrZZVjtfK7hYAoU6u82vqFnIxXRBB6wl
        /Ia3UXFdYkNAMAwDoXVCvq4yLnQNunxAxgM1BrL3uQj8Bia5wBrQur9R9D79Rp8B2T3GHjuPKbr
        MEFVxe7sbhLj9
X-Received: by 2002:a5d:44cc:: with SMTP id z12mr25495857wrr.114.1620046172764;
        Mon, 03 May 2021 05:49:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0Yt/Rgo92AhSoYslgFeaCZBiEnHvoQPuvTvhYSejdfqyoXR0ITj5QKHQArtFKrHHeGKpfoQ==
X-Received: by 2002:a5d:44cc:: with SMTP id z12mr25495845wrr.114.1620046172629;
        Mon, 03 May 2021 05:49:32 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id z2sm13600048wrg.6.2021.05.03.05.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 05:49:32 -0700 (PDT)
Date:   Mon, 3 May 2021 14:49:25 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com
Subject: Re: [PATCH v2 5/5] KVM: selftests: Add aarch64/debug-exceptions test
Message-ID: <20210503124925.wxdcyzharpyzeu4v@gator.home>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-6-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430232408.2707420-6-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 04:24:07PM -0700, Ricardo Koller wrote:
> Covers fundamental tests for debug exceptions. The guest installs and
> handle its debug exceptions itself, without KVM_SET_GUEST_DEBUG.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/aarch64/debug-exceptions.c  | 244 ++++++++++++++++++
>  .../selftests/kvm/include/aarch64/processor.h |  14 +-
>  4 files changed, 254 insertions(+), 6 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index e65d5572aefc..f09ed908422b 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -1,4 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +/aarch64/debug-exceptions
>  /aarch64/get-reg-list
>  /aarch64/get-reg-list-sve
>  /aarch64/vgic_init
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 618c5903f478..2f92442c0cc9 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -73,6 +73,7 @@ TEST_GEN_PROGS_x86_64 += memslot_modification_stress_test
>  TEST_GEN_PROGS_x86_64 += set_memory_region_test
>  TEST_GEN_PROGS_x86_64 += steal_time
>  
> +TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list-sve
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
> diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> new file mode 100644
> index 000000000000..87352ee09211
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> @@ -0,0 +1,244 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_util.h>
> +#include <kvm_util.h>
> +#include <processor.h>
> +
> +#define VCPU_ID 0
> +
> +#define MDSCR_KDE	(1 << 13)
> +#define MDSCR_MDE	(1 << 15)
> +#define MDSCR_SS	(1 << 0)
> +
> +#define DBGBCR_LEN8	(0xff << 5)
> +#define DBGBCR_EXEC	(0x0 << 3)
> +#define DBGBCR_EL1	(0x1 << 1)
> +#define DBGBCR_E	(0x1 << 0)
> +
> +#define DBGWCR_LEN8	(0xff << 5)
> +#define DBGWCR_RD	(0x1 << 3)
> +#define DBGWCR_WR	(0x2 << 3)
> +#define DBGWCR_EL1	(0x1 << 1)
> +#define DBGWCR_E	(0x1 << 0)
> +
> +extern unsigned char sw_bp, hw_bp, bp_svc, bp_brk, hw_wp, ss_start;
> +static volatile uint64_t sw_bp_addr, hw_bp_addr;
> +static volatile uint64_t wp_addr, wp_data_addr;
> +static volatile uint64_t svc_addr;
> +static volatile uint64_t ss_addr[4], ss_idx;
> +#define  PC(v)  ((uint64_t)&(v))
> +
> +static void reset_debug_state(void)
> +{
> +	asm volatile("msr daifset, #8");
> +
> +	write_sysreg(osdlr_el1, 0);
> +	write_sysreg(oslar_el1, 0);
> +	asm volatile("isb" : : : "memory");

We may want to create an isb() macro in include/aarch64/processor.h

> +
> +	write_sysreg(mdscr_el1, 0);
> +	/* This test only uses the first bp and wp slot. */
> +	write_sysreg(dbgbvr0_el1, 0);
> +	write_sysreg(dbgbcr0_el1, 0);
> +	write_sysreg(dbgwcr0_el1, 0);
> +	write_sysreg(dbgwvr0_el1, 0);
> +	asm volatile("isb" : : : "memory");
> +}
> +
> +static void install_wp(uint64_t addr)
> +{
> +	uint32_t wcr;
> +	uint32_t mdscr;
> +
> +	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
> +	write_sysreg(dbgwcr0_el1, wcr);
> +	write_sysreg(dbgwvr0_el1, addr);
> +	asm volatile("isb" : : : "memory");
> +
> +	asm volatile("msr daifclr, #8");
> +
> +	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
> +	write_sysreg(mdscr_el1, mdscr);

no isb?

> +}
> +
> +static void install_hw_bp(uint64_t addr)
> +{
> +	uint32_t bcr;
> +	uint32_t mdscr;
> +
> +	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
> +	write_sysreg(dbgbcr0_el1, bcr);
> +	write_sysreg(dbgbvr0_el1, addr);
> +	asm volatile("isb" : : : "memory");
> +
> +	asm volatile("msr daifclr, #8");
> +
> +	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
> +	write_sysreg(mdscr_el1, mdscr);

no isb?

> +}
> +
> +static void install_ss(void)
> +{
> +	uint32_t mdscr;
> +
> +	asm volatile("msr daifclr, #8");
> +
> +	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_SS;
> +	write_sysreg(mdscr_el1, mdscr);

no isb?

> +}
> +
> +static volatile char write_data;
> +
> +static void guest_code(void)
> +{
> +	GUEST_SYNC(0);
> +
> +	/* Software-breakpoint */
> +	asm volatile("sw_bp: brk #0");
> +	GUEST_ASSERT_EQ(sw_bp_addr, PC(sw_bp));
> +
> +	GUEST_SYNC(1);
> +
> +	/* Hardware-breakpoint */
> +	reset_debug_state();
> +	install_hw_bp(PC(hw_bp));
> +	asm volatile("hw_bp: nop");
> +	GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp));
> +
> +	GUEST_SYNC(2);
> +
> +	/* Hardware-breakpoint + svc */
> +	reset_debug_state();
> +	install_hw_bp(PC(bp_svc));
> +	asm volatile("bp_svc: svc #0");
> +	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_svc));
> +	GUEST_ASSERT_EQ(svc_addr, PC(bp_svc) + 4);
> +
> +	GUEST_SYNC(3);
> +
> +	/* Hardware-breakpoint + software-breakpoint */
> +	reset_debug_state();
> +	install_hw_bp(PC(bp_brk));
> +	asm volatile("bp_brk: brk #0");
> +	GUEST_ASSERT_EQ(sw_bp_addr, PC(bp_brk));
> +	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_brk));
> +
> +	GUEST_SYNC(4);
> +
> +	/* Watchpoint */
> +	reset_debug_state();
> +	install_wp(PC(write_data));
> +	write_data = 'x';
> +	GUEST_ASSERT_EQ(write_data, 'x');
> +	GUEST_ASSERT_EQ(wp_data_addr, PC(write_data));
> +
> +	GUEST_SYNC(5);
> +
> +	/* Single-step */
> +	reset_debug_state();
> +	install_ss();
> +	ss_idx = 0;
> +	asm volatile("ss_start:\n"
> +		     "mrs x0, esr_el1\n"
> +		     "add x0, x0, #1\n"
> +		     "msr daifset, #8\n"
> +		     : : : "x0");
> +	GUEST_ASSERT_EQ(ss_addr[0], PC(ss_start));
> +	GUEST_ASSERT_EQ(ss_addr[1], PC(ss_start) + 4);
> +	GUEST_ASSERT_EQ(ss_addr[2], PC(ss_start) + 8);
> +
> +	GUEST_DONE();
> +}
> +
> +static void guest_sw_bp_handler(struct ex_regs *regs)
> +{
> +	sw_bp_addr = regs->pc;
> +	regs->pc += 4;
> +}
> +
> +static void guest_hw_bp_handler(struct ex_regs *regs)
> +{
> +	hw_bp_addr = regs->pc;
> +	regs->pstate |= SPSR_D;
> +}
> +
> +static void guest_wp_handler(struct ex_regs *regs)
> +{
> +	wp_data_addr = read_sysreg(far_el1);
> +	wp_addr = regs->pc;
> +	regs->pstate |= SPSR_D;
> +}
> +
> +static void guest_ss_handler(struct ex_regs *regs)
> +{
> +	GUEST_ASSERT_1(ss_idx < 4, ss_idx);
> +	ss_addr[ss_idx++] = regs->pc;
> +	regs->pstate |= SPSR_SS;
> +}
> +
> +static void guest_svc_handler(struct ex_regs *regs)
> +{
> +	svc_addr = regs->pc;
> +}
> +
> +static int debug_version(struct kvm_vm *vm)
> +{
> +	uint64_t id_aa64dfr0;
> +
> +	get_reg(vm, VCPU_ID, ARM64_SYS_REG(ID_AA64DFR0_EL1), &id_aa64dfr0);
> +	return id_aa64dfr0 & 0xf;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct kvm_vm *vm;
> +	struct ucall uc;
> +	int stage;
> +
> +	vm = vm_create_default(VCPU_ID, 0, guest_code);
> +	ucall_init(vm, NULL);
> +
> +	vm_init_descriptor_tables(vm);
> +	vcpu_init_descriptor_tables(vm, VCPU_ID);
> +
> +	if (debug_version(vm) < 6) {
> +		print_skip("Armv8 debug architecture not supported.");
> +		kvm_vm_free(vm);
> +		exit(KSFT_SKIP);
> +	}
> +
> +	vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
> +				ESR_EC_BRK_INS, guest_sw_bp_handler);
> +	vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
> +				ESR_EC_HW_BP_CURRENT, guest_hw_bp_handler);
> +	vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
> +				ESR_EC_WP_CURRENT, guest_wp_handler);
> +	vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
> +				ESR_EC_SSTEP_CURRENT, guest_ss_handler);
> +	vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
> +				ESR_EC_SVC64, guest_svc_handler);
> +
> +	for (stage = 0; stage < 7; stage++) {
> +		vcpu_run(vm, VCPU_ID);
> +
> +		switch (get_ucall(vm, VCPU_ID, &uc)) {
> +		case UCALL_SYNC:
> +			TEST_ASSERT(uc.args[1] == stage,
> +				"Stage %d: Unexpected sync ucall, got %lx",
> +				stage, (ulong)uc.args[1]);
> +			break;
> +		case UCALL_ABORT:
> +			TEST_FAIL("%s at %s:%ld\n\tvalues: %#lx, %#lx",
> +				(const char *)uc.args[0],
> +				__FILE__, uc.args[1], uc.args[2], uc.args[3]);
> +			break;
> +		case UCALL_DONE:
> +			goto done;
> +		default:
> +			TEST_FAIL("Unknown ucall %lu", uc.cmd);
> +		}
> +	}
> +
> +done:
> +	kvm_vm_free(vm);
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 40aae31b4afc..a3ebef8e88c7 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -14,12 +14,14 @@
>  #define ARM64_CORE_REG(x) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
>  			   KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
>  
> -#define CPACR_EL1	3, 0,  1, 0, 2
> -#define TCR_EL1		3, 0,  2, 0, 2
> -#define MAIR_EL1	3, 0, 10, 2, 0
> -#define TTBR0_EL1	3, 0,  2, 0, 0
> -#define SCTLR_EL1	3, 0,  1, 0, 0
> -#define VBAR_EL1	3, 0, 12, 0, 0
> +#define CPACR_EL1               3, 0,  1, 0, 2
> +#define TCR_EL1                 3, 0,  2, 0, 2
> +#define MAIR_EL1                3, 0, 10, 2, 0
> +#define TTBR0_EL1               3, 0,  2, 0, 0
> +#define SCTLR_EL1               3, 0,  1, 0, 0
> +#define VBAR_EL1                3, 0, 12, 0, 0
> +
> +#define ID_AA64DFR0_EL1         3, 0,  0, 5, 0
>  
>  /*
>   * Default MAIR
> -- 
> 2.31.1.527.g47e6f16901-goog
>

Other than the potentially missing isb's it looks good to me.

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

