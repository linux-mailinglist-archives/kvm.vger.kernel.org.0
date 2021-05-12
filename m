Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537C937B6D9
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 09:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhELH2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 03:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhELH2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 03:28:41 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0009CC061574
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 00:27:33 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id v11-20020a17090a6b0bb029015cba7c6bdeso2564960pjj.0
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 00:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qu5bUY4P3YOXNAIJwhXnEFiIYHEf2eg3RygWqGEj1LA=;
        b=E74wQy05gd2c+w5pTTW1VdDrDy1ZB7lqhZvIjYnxeZLxevzGri8wLvK/fbNLgmiaNq
         egtUrgJI1fVuGgFvTw20d4uuRVU2tXOqWkbospX2/6i9YHxe+nVZmL47Dz4bftgIkEsr
         PIuxFA5AIxbILiBSr8shcUoorfu+HrGEdShetCl74LGXmn19hBJMdsbE1wlX7UFKjhZW
         2CcX4pKWJ1v1X6SdR6oHRYn3K5KfBPFyUQpc75yzuZA2XEw4klLeWRlWuni8Z5z1sxLI
         ppZmdfsBUegdvY6skUqRSFHf6pAKTDp4E+xXulFgreBXJmB8Q+nnZCHL8qPm/9GdTd65
         LaxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qu5bUY4P3YOXNAIJwhXnEFiIYHEf2eg3RygWqGEj1LA=;
        b=XXYCpDCHkimxICkElvYdSH29ai2tZsr0au17CjHyMRnYGvUEjk35pmLpzBqsD9ViM2
         TssgDcIqiYQl01wgaD+olhFVAUu6ye8WIYOgFQQHhE0fth8QiD+olYFnRTI/bXH9c5Xe
         +tMjtjqRuAQAzzMf5PpEvvV4XtKETIaT1700yj0UxOdZsvxgPOjxoJDivAD7e/3OIt8Y
         G540dOTvbwkHlypJ/uNWevStuyMCzE5J2VtHlJ46KQ4BG/zssWtVM4y3yPm5BzQS4KfB
         a38LrOupzzQxdGGlYfPa+dHY0CFlyv7fpewbZ8+MwrN14HqmdLRPM+hHhS6aVadNb7yO
         qdVg==
X-Gm-Message-State: AOAM532jRB1VPKmVIr9I7/Cq12/zB66oMBI6aGLCBG/pRS7QtZGBEf/G
        MXSHH2TsRyftSA0aC7VlAMpuKg==
X-Google-Smtp-Source: ABdhPJyrMbNUhsXh8VRaNt4mQLu6QuapZZPsY1KV6quO6cQVInamasmavYHYRqySZct+OfcNqJmJtw==
X-Received: by 2002:a17:902:bd94:b029:ef:2953:918e with SMTP id q20-20020a170902bd94b02900ef2953918emr17979154pls.63.1620804453240;
        Wed, 12 May 2021 00:27:33 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id g16sm9242549pfq.157.2021.05.12.00.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 00:27:32 -0700 (PDT)
Date:   Wed, 12 May 2021 00:27:29 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com,
        drjones@redhat.com, alexandru.elisei@arm.com
Subject: Re: [PATCH v2 4/5] KVM: selftests: Add exception handling support
 for aarch64
Message-ID: <YJuDYZbqe8V47YCJ@google.com>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-5-ricarkol@google.com>
 <87a6pcumyg.wl-maz@kernel.org>
 <YJBLFVoRmsehRJ1N@google.com>
 <20915a2f-d07c-2e61-3cce-ff385e98e796@redhat.com>
 <YJRADhU4CcTE7bdm@google.com>
 <8a99d57b-0513-557c-79e0-98084799812f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a99d57b-0513-557c-79e0-98084799812f@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 07, 2021 at 04:08:07PM +0200, Auger Eric wrote:
> Hi Ricardo,
> 
> On 5/6/21 9:14 PM, Ricardo Koller wrote:
> > On Thu, May 06, 2021 at 02:30:17PM +0200, Auger Eric wrote:
> >> Hi Ricardo,
> >>
> > 
> > Hi Eric,
> > 
> > Thank you very much for the test.
> > 
> >> On 5/3/21 9:12 PM, Ricardo Koller wrote:
> >>> On Mon, May 03, 2021 at 11:32:39AM +0100, Marc Zyngier wrote:
> >>>> On Sat, 01 May 2021 00:24:06 +0100,
> >>>> Ricardo Koller <ricarkol@google.com> wrote:
> >>>>>
> >>>>> Add the infrastructure needed to enable exception handling in aarch64
> >>>>> selftests. The exception handling defaults to an unhandled-exception
> >>>>> handler which aborts the test, just like x86. These handlers can be
> >>>>> overridden by calling vm_install_vector_handler(vector) or
> >>>>> vm_install_exception_handler(vector, ec). The unhandled exception
> >>>>> reporting from the guest is done using the ucall type introduced in a
> >>>>> previous commit, UCALL_UNHANDLED.
> >>>>>
> >>>>> The exception handling code is heavily inspired on kvm-unit-tests.
> >>
> >> running the test on 5.12 I get
> >>

Hi Eric,

I'm able to reproduce the failure you are seeing on 5.6, specifically
with kernels older than this commit:

  4942dc6638b0 KVM: arm64: Write arch.mdcr_el2 changes since last vcpu_load on VHE

but not yet on v5.12. Could you share the commit of the kernel you are
testing, please?

Thanks!
Ricardo

> >> ==== Test Assertion Failure ====
> >>   aarch64/debug-exceptions.c:232: false
> >>   pid=6477 tid=6477 errno=4 - Interrupted system call
> >>      1	0x000000000040147b: main at debug-exceptions.c:230
> >>      2	0x000003ff8aa60de3: ?? ??:0
> >>      3	0x0000000000401517: _start at :?
> >>   Failed guest assert: hw_bp_addr == PC(hw_bp) at
> >> aarch64/debug-exceptions.c:105
> >> 	values: 0, 0x401794
> >>
> >>
> >> I guess it is not an expected result. Any known bug waiting on the list?
> >>
> > 
> > Not expected. That should work, or at least abort early because there is
> > no HW breakpoints support.
> > 
> > I'm trying to reproduce the failure; can you help me with some
> > questions, please?
> sure, please find the answers below.
> > 
> > - does your setup have support for hardware breakpoints? Can you try a
> >   'dmesg | grep break'? I'm looking for something like 'hw-breakpoint:
> >   found ...'. If there is no such line it's very likely that the check
> >   for "debug_ver >= 6" is not enough and the test should check for
> >   "num_breakpoints > 0".
> [   25.640418] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
> > - does it fail consistently (every single attempt)?
> yes it does.
> 
> I will try to find some time to investigate too
> 
> Thanks
> 
> Eric
> > 
> > Thanks!
> > Ricardo
> > 
> >>
> >> Thanks
> >>
> >> Eric
> > 
> > 
> >>>>>
> >>>>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> >>>>> ---
> >>>>>  tools/testing/selftests/kvm/Makefile          |   2 +-
> >>>>>  .../selftests/kvm/include/aarch64/processor.h |  78 +++++++++++
> >>>>>  .../selftests/kvm/lib/aarch64/handlers.S      | 130 ++++++++++++++++++
> >>>>>  .../selftests/kvm/lib/aarch64/processor.c     | 124 +++++++++++++++++
> >>>>>  4 files changed, 333 insertions(+), 1 deletion(-)
> >>>>>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S
> >>>>>
> >>>>> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> >>>>> index 4e548d7ab0ab..618c5903f478 100644
> >>>>> --- a/tools/testing/selftests/kvm/Makefile
> >>>>> +++ b/tools/testing/selftests/kvm/Makefile
> >>>>> @@ -35,7 +35,7 @@ endif
> >>>>>  
> >>>>>  LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
> >>>>>  LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
> >>>>> -LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c
> >>>>> +LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S
> >>>>>  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
> >>>>>  
> >>>>>  TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
> >>>>> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> >>>>> index b7fa0c8551db..40aae31b4afc 100644
> >>>>> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> >>>>> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> >>>>> @@ -8,6 +8,7 @@
> >>>>>  #define SELFTEST_KVM_PROCESSOR_H
> >>>>>  
> >>>>>  #include "kvm_util.h"
> >>>>> +#include <linux/stringify.h>
> >>>>>  
> >>>>>  
> >>>>>  #define ARM64_CORE_REG(x) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
> >>>>> @@ -18,6 +19,7 @@
> >>>>>  #define MAIR_EL1	3, 0, 10, 2, 0
> >>>>>  #define TTBR0_EL1	3, 0,  2, 0, 0
> >>>>>  #define SCTLR_EL1	3, 0,  1, 0, 0
> >>>>> +#define VBAR_EL1	3, 0, 12, 0, 0
> >>>>>  
> >>>>>  /*
> >>>>>   * Default MAIR
> >>>>> @@ -56,4 +58,80 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
> >>>>>  void aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid,
> >>>>>  			      struct kvm_vcpu_init *init, void *guest_code);
> >>>>>  
> >>>>> +struct ex_regs {
> >>>>> +	u64 regs[31];
> >>>>> +	u64 sp;
> >>>>> +	u64 pc;
> >>>>> +	u64 pstate;
> >>>>> +};
> >>>>> +
> >>>>> +#define VECTOR_NUM	16
> >>>>> +
> >>>>> +enum {
> >>>>> +	VECTOR_SYNC_CURRENT_SP0,
> >>>>> +	VECTOR_IRQ_CURRENT_SP0,
> >>>>> +	VECTOR_FIQ_CURRENT_SP0,
> >>>>> +	VECTOR_ERROR_CURRENT_SP0,
> >>>>> +
> >>>>> +	VECTOR_SYNC_CURRENT,
> >>>>> +	VECTOR_IRQ_CURRENT,
> >>>>> +	VECTOR_FIQ_CURRENT,
> >>>>> +	VECTOR_ERROR_CURRENT,
> >>>>> +
> >>>>> +	VECTOR_SYNC_LOWER_64,
> >>>>> +	VECTOR_IRQ_LOWER_64,
> >>>>> +	VECTOR_FIQ_LOWER_64,
> >>>>> +	VECTOR_ERROR_LOWER_64,
> >>>>> +
> >>>>> +	VECTOR_SYNC_LOWER_32,
> >>>>> +	VECTOR_IRQ_LOWER_32,
> >>>>> +	VECTOR_FIQ_LOWER_32,
> >>>>> +	VECTOR_ERROR_LOWER_32,
> >>>>> +};
> >>>>> +
> >>>>> +#define VECTOR_IS_SYNC(v) ((v) == VECTOR_SYNC_CURRENT_SP0 || \
> >>>>> +			   (v) == VECTOR_SYNC_CURRENT     || \
> >>>>> +			   (v) == VECTOR_SYNC_LOWER_64    || \
> >>>>> +			   (v) == VECTOR_SYNC_LOWER_32)
> >>>>> +
> >>>>> +/* Some common EC (Exception classes) */
> >>>>> +#define ESR_EC_ILLEGAL_INS	0x0e
> >>>>> +#define ESR_EC_SVC64		0x15
> >>>>> +#define ESR_EC_IABORT_CURRENT	0x21
> >>>>> +#define ESR_EC_DABORT_CURRENT	0x25
> >>>>> +#define ESR_EC_SERROR		0x2f
> >>>>> +#define ESR_EC_HW_BP_CURRENT	0x31
> >>>>> +#define ESR_EC_SSTEP_CURRENT	0x33
> >>>>> +#define ESR_EC_WP_CURRENT	0x35
> >>>>> +#define ESR_EC_BRK_INS		0x3C
> >>>>> +
> >>>>> +#define ESR_EC_NUM		64
> >>>>> +
> >>>>> +#define ESR_EC_SHIFT		26
> >>>>> +#define ESR_EC_MASK		(ESR_EC_NUM - 1)
> >>>>> +
> >>>>> +void vm_init_descriptor_tables(struct kvm_vm *vm);
> >>>>> +void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
> >>>>> +
> >>>>> +typedef void(*handler_fn)(struct ex_regs *);
> >>>>> +void vm_install_exception_handler(struct kvm_vm *vm,
> >>>>> +		int vector, int ec, handler_fn handler);
> >>>>> +void vm_install_vector_handler(struct kvm_vm *vm,
> >>>>> +		int vector, handler_fn handler);
> >>>>> +
> >>>>> +#define SPSR_D          (1 << 9)
> >>>>> +#define SPSR_SS         (1 << 21)
> >>>>> +
> >>>>> +#define write_sysreg(reg, val)						  \
> >>>>> +({									  \
> >>>>> +	u64 __val = (u64)(val);						  \
> >>>>> +	asm volatile("msr " __stringify(reg) ", %x0" : : "rZ" (__val));	  \
> >>>>> +})
> >>>>> +
> >>>>> +#define read_sysreg(reg)						  \
> >>>>> +({	u64 val;							  \
> >>>>> +	asm volatile("mrs %0, "__stringify(reg) : "=r"(val) : : "memory");\
> >>>>> +	val;								  \
> >>>>> +})
> >>>>> +
> >>>>>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> >>>>> diff --git a/tools/testing/selftests/kvm/lib/aarch64/handlers.S b/tools/testing/selftests/kvm/lib/aarch64/handlers.S
> >>>>> new file mode 100644
> >>>>> index 000000000000..8a560021892b
> >>>>> --- /dev/null
> >>>>> +++ b/tools/testing/selftests/kvm/lib/aarch64/handlers.S
> >>>>> @@ -0,0 +1,130 @@
> >>>>> +/* SPDX-License-Identifier: GPL-2.0 */
> >>>>> +.macro save_registers, vector
> >>>>> +	add	sp, sp, #-16 * 17
> >>>>> +
> >>>>> +	stp	x0, x1, [sp, #16 * 0]
> >>>>> +	stp	x2, x3, [sp, #16 * 1]
> >>>>> +	stp	x4, x5, [sp, #16 * 2]
> >>>>> +	stp	x6, x7, [sp, #16 * 3]
> >>>>> +	stp	x8, x9, [sp, #16 * 4]
> >>>>> +	stp	x10, x11, [sp, #16 * 5]
> >>>>> +	stp	x12, x13, [sp, #16 * 6]
> >>>>> +	stp	x14, x15, [sp, #16 * 7]
> >>>>> +	stp	x16, x17, [sp, #16 * 8]
> >>>>> +	stp	x18, x19, [sp, #16 * 9]
> >>>>> +	stp	x20, x21, [sp, #16 * 10]
> >>>>> +	stp	x22, x23, [sp, #16 * 11]
> >>>>> +	stp	x24, x25, [sp, #16 * 12]
> >>>>> +	stp	x26, x27, [sp, #16 * 13]
> >>>>> +	stp	x28, x29, [sp, #16 * 14]
> >>>>> +
> >>>>> +	.if \vector >= 8
> >>>>> +	mrs	x1, sp_el0
> >>>>
> >>>> I'm still a bit perplexed by this. SP_EL0 is never changed, since you
> >>>> always run in handler mode. Therefore, saving/restoring it is only
> >>>> overhead. If an exception handler wants to introspect it, it is
> >>>> already available in the relevant system register.
> >>>>
> >>>> Or did you have something else in mind for it?
> >>>>
> >>>
> >>> Not really. The reason for saving sp_el0 in there was just for
> >>> consistency, so that handlers for both el0 and el1 exceptions could get
> >>> the sp at regs->sp.
> >>>
> >>> Restoring sp_el0 might be too much. So, what do you think of this v3: we
> >>> keep the saving of sp_el0 into regs->sp (to keep things the same between
> >>> el0 and el1) and delete the restoring of sp_el0?
> >>>
> >>> Thanks,
> >>> Ricardo
> >>>
> >>>>> +	.else
> >>>>> +	/*
> >>>>> +	 * This stores sp_el1 into ex_regs.sp so exception handlers can
> >>>>> +	 * "look" at it. It will _not_ be used to restore the sp_el1 on
> >>>>> +	 * return from the exception so handlers can not update it.
> >>>>> +	 */
> >>>>> +	mov	x1, sp
> >>>>> +	.endif
> >>>>> +	stp	x30, x1, [sp, #16 * 15] /* x30, SP */
> >>>>> +
> >>>>> +	mrs	x1, elr_el1
> >>>>> +	mrs	x2, spsr_el1
> >>>>> +	stp	x1, x2, [sp, #16 * 16] /* PC, PSTATE */
> >>>>> +.endm
> >>>>> +
> >>>>> +.macro restore_registers, vector
> >>>>> +	ldp	x1, x2, [sp, #16 * 16] /* PC, PSTATE */
> >>>>> +	msr	elr_el1, x1
> >>>>> +	msr	spsr_el1, x2
> >>>>> +
> >>>>> +	ldp	x30, x1, [sp, #16 * 15] /* x30, SP */
> >>>>> +	.if \vector >= 8
> >>>>> +	msr	sp_el0, x1
> >>>>> +	.endif
> >>>>> +
> >>>>> +	ldp	x28, x29, [sp, #16 * 14]
> >>>>> +	ldp	x26, x27, [sp, #16 * 13]
> >>>>> +	ldp	x24, x25, [sp, #16 * 12]
> >>>>> +	ldp	x22, x23, [sp, #16 * 11]
> >>>>> +	ldp	x20, x21, [sp, #16 * 10]
> >>>>> +	ldp	x18, x19, [sp, #16 * 9]
> >>>>> +	ldp	x16, x17, [sp, #16 * 8]
> >>>>> +	ldp	x14, x15, [sp, #16 * 7]
> >>>>> +	ldp	x12, x13, [sp, #16 * 6]
> >>>>> +	ldp	x10, x11, [sp, #16 * 5]
> >>>>> +	ldp	x8, x9, [sp, #16 * 4]
> >>>>> +	ldp	x6, x7, [sp, #16 * 3]
> >>>>> +	ldp	x4, x5, [sp, #16 * 2]
> >>>>> +	ldp	x2, x3, [sp, #16 * 1]
> >>>>> +	ldp	x0, x1, [sp, #16 * 0]
> >>>>> +
> >>>>> +	add	sp, sp, #16 * 17
> >>>>> +
> >>>>> +	eret
> >>>>> +.endm
> >>>>> +
> >>>>> +.pushsection ".entry.text", "ax"
> >>>>> +.balign 0x800
> >>>>> +.global vectors
> >>>>> +vectors:
> >>>>> +.popsection
> >>>>> +
> >>>>> +.set	vector, 0
> >>>>> +
> >>>>> +/*
> >>>>> + * Build an exception handler for vector and append a jump to it into
> >>>>> + * vectors (while making sure that it's 0x80 aligned).
> >>>>> + */
> >>>>> +.macro HANDLER, label
> >>>>> +handler_\()\label:
> >>>>> +	save_registers vector
> >>>>> +	mov	x0, sp
> >>>>> +	mov	x1, #vector
> >>>>> +	bl	route_exception
> >>>>> +	restore_registers vector
> >>>>> +
> >>>>> +.pushsection ".entry.text", "ax"
> >>>>> +.balign 0x80
> >>>>> +	b	handler_\()\label
> >>>>> +.popsection
> >>>>> +
> >>>>> +.set	vector, vector + 1
> >>>>> +.endm
> >>>>> +
> >>>>> +.macro HANDLER_INVALID
> >>>>> +.pushsection ".entry.text", "ax"
> >>>>> +.balign 0x80
> >>>>> +/* This will abort so no need to save and restore registers. */
> >>>>> +	mov	x0, #vector
> >>>>> +	b	kvm_exit_unexpected_vector
> >>>>> +.popsection
> >>>>> +
> >>>>> +.set	vector, vector + 1
> >>>>> +.endm
> >>>>> +
> >>>>> +/*
> >>>>> + * Caution: be sure to not add anything between the declaration of vectors
> >>>>> + * above and these macro calls that will build the vectors table below it.
> >>>>> + */
> >>>>> +	HANDLER_INVALID                         // Synchronous EL1t
> >>>>> +	HANDLER_INVALID                         // IRQ EL1t
> >>>>> +	HANDLER_INVALID                         // FIQ EL1t
> >>>>> +	HANDLER_INVALID                         // Error EL1t
> >>>>> +
> >>>>> +	HANDLER	el1h_sync                       // Synchronous EL1h
> >>>>> +	HANDLER	el1h_irq                        // IRQ EL1h
> >>>>> +	HANDLER el1h_fiq                        // FIQ EL1h
> >>>>> +	HANDLER	el1h_error                      // Error EL1h
> >>>>> +
> >>>>> +	HANDLER	el0_sync_64                     // Synchronous 64-bit EL0
> >>>>> +	HANDLER	el0_irq_64                      // IRQ 64-bit EL0
> >>>>> +	HANDLER	el0_fiq_64                      // FIQ 64-bit EL0
> >>>>> +	HANDLER	el0_error_64                    // Error 64-bit EL0
> >>>>> +
> >>>>> +	HANDLER	el0_sync_32                     // Synchronous 32-bit EL0
> >>>>> +	HANDLER	el0_irq_32                      // IRQ 32-bit EL0
> >>>>> +	HANDLER	el0_fiq_32                      // FIQ 32-bit EL0
> >>>>> +	HANDLER	el0_error_32                    // Error 32-bit EL0
> >>>>> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> >>>>> index cee92d477dc0..25be71ec88be 100644
> >>>>> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> >>>>> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> >>>>> @@ -6,6 +6,7 @@
> >>>>>   */
> >>>>>  
> >>>>>  #include <linux/compiler.h>
> >>>>> +#include <assert.h>
> >>>>>  
> >>>>>  #include "kvm_util.h"
> >>>>>  #include "../kvm_util_internal.h"
> >>>>> @@ -14,6 +15,8 @@
> >>>>>  #define KVM_GUEST_PAGE_TABLE_MIN_PADDR		0x180000
> >>>>>  #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN	0xac0000
> >>>>>  
> >>>>> +vm_vaddr_t exception_handlers;
> >>>>> +
> >>>>>  static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
> >>>>>  {
> >>>>>  	return (v + vm->page_size) & ~(vm->page_size - 1);
> >>>>> @@ -334,6 +337,127 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
> >>>>>  	va_end(ap);
> >>>>>  }
> >>>>>  
> >>>>> +void kvm_exit_unexpected_vector(int vector)
> >>>>> +{
> >>>>> +	ucall(UCALL_UNHANDLED, 3, vector, 0, false /* !valid_ec */);
> >>>>> +}
> >>>>> +
> >>>>> +void kvm_exit_unexpected_exception(int vector, uint64_t ec)
> >>>>> +{
> >>>>> +	ucall(UCALL_UNHANDLED, 3, vector, ec, true /* valid_ec */);
> >>>>> +}
> >>>>> +
> >>>>>  void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
> >>>>>  {
> >>>>> +	struct ucall uc;
> >>>>> +
> >>>>> +	if (get_ucall(vm, vcpuid, &uc) != UCALL_UNHANDLED)
> >>>>> +		return;
> >>>>> +
> >>>>> +	if (uc.args[2]) /* valid_ec */ {
> >>>>> +		assert(VECTOR_IS_SYNC(uc.args[0]));
> >>>>> +		TEST_ASSERT(false,
> >>>>> +			"Unexpected exception (vector:0x%lx, ec:0x%lx)",
> >>>>> +			uc.args[0], uc.args[1]);
> >>>>> +	} else {
> >>>>> +		assert(!VECTOR_IS_SYNC(uc.args[0]));
> >>>>> +		TEST_ASSERT(false,
> >>>>> +			"Unexpected exception (vector:0x%lx)",
> >>>>> +			uc.args[0]);
> >>>>> +	}
> >>>>> +}
> >>>>> +
> >>>>> +/*
> >>>>> + * This exception handling code was heavily inspired on kvm-unit-tests. There
> >>>>> + * is a set of default vector handlers stored in vector_handlers. These default
> >>>>> + * vector handlers call user-installed handlers stored in exception_handlers.
> >>>>> + * Synchronous handlers are indexed by (vector, ec), and irq handlers by
> >>>>> + * (vector, ec=0).
> >>>>> + */
> >>>>> +
> >>>>> +typedef void(*vector_fn)(struct ex_regs *, int vector);
> >>>>> +
> >>>>> +struct handlers {
> >>>>> +	vector_fn vector_handlers[VECTOR_NUM];
> >>>>> +	handler_fn exception_handlers[VECTOR_NUM][ESR_EC_NUM];
> >>>>> +};
> >>>>> +
> >>>>> +void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
> >>>>> +{
> >>>>> +	extern char vectors;
> >>>>> +
> >>>>> +	set_reg(vm, vcpuid, ARM64_SYS_REG(VBAR_EL1), (uint64_t)&vectors);
> >>>>> +}
> >>>>> +
> >>>>> +void default_sync_handler(struct ex_regs *regs, int vector)
> >>>>> +{
> >>>>> +	struct handlers *handlers = (struct handlers *)exception_handlers;
> >>>>> +	uint64_t esr = read_sysreg(esr_el1);
> >>>>> +	uint64_t ec = (esr >> ESR_EC_SHIFT) & ESR_EC_MASK;
> >>>>> +
> >>>>> +	GUEST_ASSERT(VECTOR_IS_SYNC(vector));
> >>>>> +
> >>>>> +	if (handlers && handlers->exception_handlers[vector][ec])
> >>>>> +		handlers->exception_handlers[vector][ec](regs);
> >>>>> +	else
> >>>>> +		kvm_exit_unexpected_exception(vector, ec);
> >>>>> +}
> >>>>> +
> >>>>> +void default_irq_handler(struct ex_regs *regs, int vector)
> >>>>> +{
> >>>>> +	struct handlers *handlers = (struct handlers *)exception_handlers;
> >>>>> +
> >>>>> +	GUEST_ASSERT(!VECTOR_IS_SYNC(vector));
> >>>>> +
> >>>>> +	if (handlers && handlers->exception_handlers[vector][0])
> >>>>> +		handlers->exception_handlers[vector][0](regs);
> >>>>> +	else
> >>>>> +		kvm_exit_unexpected_vector(vector);
> >>>>> +}
> >>>>> +
> >>>>> +void route_exception(struct ex_regs *regs, int vector)
> >>>>> +{
> >>>>> +	struct handlers *handlers = (struct handlers *)exception_handlers;
> >>>>> +
> >>>>> +	if (handlers && handlers->vector_handlers[vector])
> >>>>> +		handlers->vector_handlers[vector](regs, vector);
> >>>>> +	else
> >>>>> +		kvm_exit_unexpected_vector(vector);
> >>>>> +}
> >>>>> +
> >>>>> +void vm_init_descriptor_tables(struct kvm_vm *vm)
> >>>>> +{
> >>>>> +	struct handlers *handlers;
> >>>>> +
> >>>>> +	vm->handlers = vm_vaddr_alloc(vm, sizeof(struct handlers),
> >>>>> +			vm->page_size, 0, 0);
> >>>>> +
> >>>>> +	handlers = (struct handlers *)addr_gva2hva(vm, vm->handlers);
> >>>>> +	handlers->vector_handlers[VECTOR_SYNC_CURRENT] = default_sync_handler;
> >>>>> +	handlers->vector_handlers[VECTOR_IRQ_CURRENT] = default_irq_handler;
> >>>>> +	handlers->vector_handlers[VECTOR_SYNC_LOWER_64] = default_sync_handler;
> >>>>> +	handlers->vector_handlers[VECTOR_IRQ_LOWER_64] = default_irq_handler;
> >>>>
> >>>> How about FIQ, Error? Although they are unlikely, they are valid
> >>>> exceptions.
> >>>>
> >>>>> +
> >>>>> +	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
> >>>>> +}
> >>>>> +
> >>>>> +void vm_install_exception_handler(struct kvm_vm *vm, int vector, int ec,
> >>>>> +			 void (*handler)(struct ex_regs *))
> >>>>> +{
> >>>>> +	struct handlers *handlers = (struct handlers *)addr_gva2hva(vm, vm->handlers);
> >>>>> +
> >>>>> +	assert(VECTOR_IS_SYNC(vector));
> >>>>> +	assert(vector < VECTOR_NUM);
> >>>>> +	assert(ec < ESR_EC_NUM);
> >>>>> +	handlers->exception_handlers[vector][ec] = handler;
> >>>>> +}
> >>>>> +
> >>>>> +void vm_install_vector_handler(struct kvm_vm *vm, int vector,
> >>>>> +			 void (*handler)(struct ex_regs *))
> >>>>> +{
> >>>>> +	struct handlers *handlers = (struct handlers *)addr_gva2hva(vm, vm->handlers);
> >>>>> +
> >>>>> +	assert(!VECTOR_IS_SYNC(vector));
> >>>>> +	assert(vector < VECTOR_NUM);
> >>>>> +	handlers->exception_handlers[vector][0] = handler;
> >>>>>  }
> >>>>
> >>>> Thanks,
> >>>>
> >>>> 	M.
> >>>>
> >>>> -- 
> >>>> Without deviation from the norm, progress is not possible.
> >>>
> >>
> > 
> 
