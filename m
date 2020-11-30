Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634E52C8CF4
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 19:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388009AbgK3SiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 13:38:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387746AbgK3SiT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 13:38:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606761411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WcH74LiGKijaxHLnNTwWDO7sIvGTg9dUxv7MV0IWoYw=;
        b=hnqtkGh6k89qNOFh7jC0wu7kMnYDLdInFxHHmJrEFzdpwlTmLOvmtU8MCx4U12UDqd0ujH
        I9qp/09YPxbX/CaiEHxAKODXdzNfwQLfjQoG3F9l7UkkC3F1HO3j4EvCts+QMcO3uSqESG
        GSv/iA+LMZCQfpYe+nOcyZYAppW66XE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-Sfj4x4vPPaaNQJgDsza56w-1; Mon, 30 Nov 2020 13:36:48 -0500
X-MC-Unique: Sfj4x4vPPaaNQJgDsza56w-1
Received: by mail-ej1-f69.google.com with SMTP id t17so3242195ejd.12
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 10:36:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WcH74LiGKijaxHLnNTwWDO7sIvGTg9dUxv7MV0IWoYw=;
        b=PautHoh6q898lesHuQqXTrXtIDhaRGR0+tRYTzBqkLEYHMhF/283dG6bu8SjVbtBpX
         lGuh7eKS7vuTcNn2G+wvW4mq3+mk+WRc1YfIMCH5J/HtRgrCWEq3bj2KNL33DKsfPgej
         S4xXvkxx7MDJzAyl6+28XPb6Me4dWrcczFV1OO4OHc96njzy74uIz5Q/3pEyriJHA9uV
         TiVDvxAx0S2mHksQxRHXqPYbb11TKG1JLlqykA5YhOjoZMLL7/v5jyoCzziH4HTB7DBI
         ZcfMuLl/UGrurHKVKaGFraQ7t2OvSjC1JQwJ87raTkYxzTzErNn2X0LlhN3ILimEVwX0
         omAw==
X-Gm-Message-State: AOAM531BsAzRT2hIZO3LjymiMhLWjHQdT9/cnHxi0pmAbkZUUH0nTJ+N
        ws5FKhtpY6Skf7sLL1CzPOG8lQhxRmMrbhFmoGEm6JRTuGmHYybS1NT+tUsD0P6oDOHV7l5x6UX
        7EigEMlGvosnItppqD+6EOLchNHwXUfTDrViJJMbmuutceNn7EUXBA7wQU6CpRsNI
X-Received: by 2002:a05:6402:31b6:: with SMTP id dj22mr23167307edb.348.1606761406921;
        Mon, 30 Nov 2020 10:36:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwOIPKPnafhoIAH53W07rN9RY68HW7aiFWbeYtoe6N+0Bhbj3v0lgR9A4pitlMg3htV/9LusQ==
X-Received: by 2002:a05:6402:31b6:: with SMTP id dj22mr23167263edb.348.1606761406435;
        Mon, 30 Nov 2020 10:36:46 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b7sm5945876ejz.4.2020.11.30.10.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 10:36:45 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Reinstate userspace hypercall support
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <1bde4a992be29581e559f7a57818e206e11f84f5.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dc2d4330-e45d-641f-226b-005a477efd22@redhat.com>
Date:   Mon, 30 Nov 2020 19:36:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1bde4a992be29581e559f7a57818e206e11f84f5.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/11/20 15:20, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> For supporting Xen guests we really want to be able to use vmcall/vmmcall
> for hypercalls as Xen itself does. Reinstate the KVM_EXIT_HYPERCALL
> support that Anthony ripped out in 2007.
> 
> Yes, we *could* make it work with KVM_EXIT_IO if we really had to, but
> that makes it guest-visible and makes it distinctly non-trivial to do
> live migration from Xen because we'd have to update the hypercall page(s)
> (which are at unknown locations) as well as dealing with any guest RIP
> which happens to be *in* a hypercall page at the time.
> 
> We also actively want to *prevent* the KVM hypercalls from suddenly
> becoming available to guests which think they are Xen guests, which
> this achieves too.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
> Should this test work OK on AMD? I see a separate test which is
> explicitly testing VMCALL on AMD, which makes me suspect it's expected
> to work as well as VMMCALL?

Yes, it should (via the #UD intercept instead of the VMMCALL exit).

> Do we have the test infrastructure for running 32-bit guests easily?

Nope, unfortunately not, and I'm not going to ask you to port the 
selftests infrastructure to 32-bit x86 (though it should not be too hard).

Paolo

>   Documentation/virt/kvm/api.rst                | 23 +++--
>   arch/x86/include/asm/kvm_host.h               |  1 +
>   arch/x86/kvm/x86.c                            | 46 +++++++++
>   include/uapi/linux/kvm.h                      |  1 +
>   tools/include/uapi/linux/kvm.h                | 57 ++++++++++-
>   tools/testing/selftests/kvm/.gitignore        |  1 +
>   tools/testing/selftests/kvm/Makefile          |  1 +
>   .../selftests/kvm/x86_64/user_vmcall_test.c   | 94 +++++++++++++++++++
>   8 files changed, 214 insertions(+), 10 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/user_vmcall_test.c
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 70254eaa5229..fa9160920a08 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4990,13 +4990,13 @@ to the byte array.
>   
>   .. note::
>   
> -      For KVM_EXIT_IO, KVM_EXIT_MMIO, KVM_EXIT_OSI, KVM_EXIT_PAPR,
> -      KVM_EXIT_EPR, KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR the corresponding
> -      operations are complete (and guest state is consistent) only after userspace
> -      has re-entered the kernel with KVM_RUN.  The kernel side will first finish
> -      incomplete operations and then check for pending signals.  Userspace
> -      can re-enter the guest with an unmasked signal pending to complete
> -      pending operations.
> +      For KVM_EXIT_IO, KVM_EXIT_MMIO, KVM_EXIT_OSI, KVM_EXIT_PAPR, KVM_EXIT_EPR,
> +      KVM_EXIT_HYPERCALL, KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR the
> +      corresponding operations are complete (and guest state is consistent) only
> +      after userspace has re-entered the kernel with KVM_RUN.  The kernel side
> +      will first finish incomplete operations and then check for pending signals.
> +      Userspace can re-enter the guest with an unmasked signal pending to
> +      complete pending operations.
>   
>   ::
>   
> @@ -5009,8 +5009,13 @@ to the byte array.
>   			__u32 pad;
>   		} hypercall;
>   
> -Unused.  This was once used for 'hypercall to userspace'.  To implement
> -such functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s390).
> +This occurs when KVM_CAP_X86_USER_SPACE_HYPERCALL is enabled and the vcpu has
> +executed a VMCALL(Intel) or VMMCALL(AMD) instruction. The arguments are taken
> +from the vcpu registers in accordance with the Xen hypercall ABI.
> +
> +Except for compatibility with existing hypervisors such as Xen, userspace
> +handling of hypercalls is discouraged. To implement such functionality,
> +use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s390).
>   
>   .. note:: KVM_EXIT_IO is significantly faster than KVM_EXIT_MMIO.
>   
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f002cdb13a0b..a6f72adc48cd 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -984,6 +984,7 @@ struct kvm_arch {
>   
>   	bool guest_can_read_msr_platform_info;
>   	bool exception_payload_enabled;
> +	bool user_space_hypercall;
>   
>   	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
>   	u32 user_space_msr_mask;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a3fdc16cfd6f..e8c5c079a85d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3755,6 +3755,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_SET_GUEST_DEBUG:
>   	case KVM_CAP_LAST_CPU:
>   	case KVM_CAP_X86_USER_SPACE_MSR:
> +	case KVM_CAP_X86_USER_SPACE_HYPERCALL:
>   	case KVM_CAP_X86_MSR_FILTER:
>   	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
>   		r = 1;
> @@ -5275,6 +5276,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		kvm->arch.user_space_msr_mask = cap->args[0];
>   		r = 0;
>   		break;
> +	case KVM_CAP_X86_USER_SPACE_HYPERCALL:
> +		kvm->arch.user_space_hypercall = cap->args[0];
> +		r = 0;
> +		break;
>   	default:
>   		r = -EINVAL;
>   		break;
> @@ -8063,11 +8068,52 @@ static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
>   		kvm_vcpu_yield_to(target);
>   }
>   
> +static int complete_userspace_hypercall(struct kvm_vcpu *vcpu)
> +{
> +	kvm_rax_write(vcpu, vcpu->run->hypercall.ret);
> +
> +	return kvm_skip_emulated_instruction(vcpu);
> +}
> +
> +int kvm_userspace_hypercall(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_run *run = vcpu->run;
> +
> +	if (is_long_mode(vcpu)) {
> +		run->hypercall.longmode = 1;
> +		run->hypercall.nr = kvm_rax_read(vcpu);
> +		run->hypercall.args[0] = kvm_rdi_read(vcpu);
> +		run->hypercall.args[1] = kvm_rsi_read(vcpu);
> +		run->hypercall.args[2] = kvm_rdx_read(vcpu);
> +		run->hypercall.args[3] = kvm_r10_read(vcpu);
> +		run->hypercall.args[4] = kvm_r8_read(vcpu);
> +		run->hypercall.args[5] = kvm_r9_read(vcpu);
> +		run->hypercall.ret = -KVM_ENOSYS;
> +	} else {
> +		run->hypercall.longmode = 0;
> +		run->hypercall.nr = (u32)kvm_rbx_read(vcpu);
> +		run->hypercall.args[0] = (u32)kvm_rbx_read(vcpu);
> +		run->hypercall.args[1] = (u32)kvm_rcx_read(vcpu);
> +		run->hypercall.args[2] = (u32)kvm_rdx_read(vcpu);
> +		run->hypercall.args[3] = (u32)kvm_rsi_read(vcpu);
> +		run->hypercall.args[4] = (u32)kvm_rdi_read(vcpu);
> +		run->hypercall.args[5] = (u32)kvm_rbp_read(vcpu);
> +		run->hypercall.ret = (u32)-KVM_ENOSYS;
> +	}
> +	run->exit_reason = KVM_EXIT_HYPERCALL;
> +	vcpu->arch.complete_userspace_io = complete_userspace_hypercall;
> +
> +	return 0;
> +}
> +
>   int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   {
>   	unsigned long nr, a0, a1, a2, a3, ret;
>   	int op_64_bit;
>   
> +	if (vcpu->kvm->arch.user_space_hypercall)
> +		return kvm_userspace_hypercall(vcpu);
> +
>   	if (kvm_hv_hypercall_enabled(vcpu->kvm))
>   		return kvm_hv_hypercall(vcpu);
>   
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 886802b8ffba..e01b679e0132 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1056,6 +1056,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
>   #define KVM_CAP_SYS_HYPERV_CPUID 191
>   #define KVM_CAP_DIRTY_LOG_RING 192
> +#define KVM_CAP_X86_USER_SPACE_HYPERCALL 193
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index ca41220b40b8..e01b679e0132 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -250,6 +250,7 @@ struct kvm_hyperv_exit {
>   #define KVM_EXIT_ARM_NISV         28
>   #define KVM_EXIT_X86_RDMSR        29
>   #define KVM_EXIT_X86_WRMSR        30
> +#define KVM_EXIT_DIRTY_RING_FULL  31
>   
>   /* For KVM_EXIT_INTERNAL_ERROR */
>   /* Emulate instruction failed. */
> @@ -1053,6 +1054,9 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_X86_USER_SPACE_MSR 188
>   #define KVM_CAP_X86_MSR_FILTER 189
>   #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
> +#define KVM_CAP_SYS_HYPERV_CPUID 191
> +#define KVM_CAP_DIRTY_LOG_RING 192
> +#define KVM_CAP_X86_USER_SPACE_HYPERCALL 193
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> @@ -1511,7 +1515,7 @@ struct kvm_enc_region {
>   /* Available with KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2 */
>   #define KVM_CLEAR_DIRTY_LOG          _IOWR(KVMIO, 0xc0, struct kvm_clear_dirty_log)
>   
> -/* Available with KVM_CAP_HYPERV_CPUID */
> +/* Available with KVM_CAP_HYPERV_CPUID (vcpu) / KVM_CAP_SYS_HYPERV_CPUID (system) */
>   #define KVM_GET_SUPPORTED_HV_CPUID _IOWR(KVMIO, 0xc1, struct kvm_cpuid2)
>   
>   /* Available with KVM_CAP_ARM_SVE */
> @@ -1557,6 +1561,9 @@ struct kvm_pv_cmd {
>   /* Available with KVM_CAP_X86_MSR_FILTER */
>   #define KVM_X86_SET_MSR_FILTER	_IOW(KVMIO,  0xc6, struct kvm_msr_filter)
>   
> +/* Available with KVM_CAP_DIRTY_LOG_RING */
> +#define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
> +
>   /* Secure Encrypted Virtualization command */
>   enum sev_cmd_id {
>   	/* Guest initialization commands */
> @@ -1710,4 +1717,52 @@ struct kvm_hyperv_eventfd {
>   #define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
>   #define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
>   
> +/*
> + * Arch needs to define the macro after implementing the dirty ring
> + * feature.  KVM_DIRTY_LOG_PAGE_OFFSET should be defined as the
> + * starting page offset of the dirty ring structures.
> + */
> +#ifndef KVM_DIRTY_LOG_PAGE_OFFSET
> +#define KVM_DIRTY_LOG_PAGE_OFFSET 0
> +#endif
> +
> +/*
> + * KVM dirty GFN flags, defined as:
> + *
> + * |---------------+---------------+--------------|
> + * | bit 1 (reset) | bit 0 (dirty) | Status       |
> + * |---------------+---------------+--------------|
> + * |             0 |             0 | Invalid GFN  |
> + * |             0 |             1 | Dirty GFN    |
> + * |             1 |             X | GFN to reset |
> + * |---------------+---------------+--------------|
> + *
> + * Lifecycle of a dirty GFN goes like:
> + *
> + *      dirtied         harvested        reset
> + * 00 -----------> 01 -------------> 1X -------+
> + *  ^                                          |
> + *  |                                          |
> + *  +------------------------------------------+
> + *
> + * The userspace program is only responsible for the 01->1X state
> + * conversion after harvesting an entry.  Also, it must not skip any
> + * dirty bits, so that dirty bits are always harvested in sequence.
> + */
> +#define KVM_DIRTY_GFN_F_DIRTY           BIT(0)
> +#define KVM_DIRTY_GFN_F_RESET           BIT(1)
> +#define KVM_DIRTY_GFN_F_MASK            0x3
> +
> +/*
> + * KVM dirty rings should be mapped at KVM_DIRTY_LOG_PAGE_OFFSET of
> + * per-vcpu mmaped regions as an array of struct kvm_dirty_gfn.  The
> + * size of the gfn buffer is decided by the first argument when
> + * enabling KVM_CAP_DIRTY_LOG_RING.
> + */
> +struct kvm_dirty_gfn {
> +	__u32 flags;
> +	__u32 slot;
> +	__u64 offset;
> +};
> +
>   #endif /* __LINUX_KVM_H */
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 5468db7dd674..3c715f6491c1 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -18,6 +18,7 @@
>   /x86_64/sync_regs_test
>   /x86_64/tsc_msrs_test
>   /x86_64/user_msr_test
> +/x86_64/user_vmcall_test
>   /x86_64/vmx_apic_access_test
>   /x86_64/vmx_close_while_nested_test
>   /x86_64/vmx_dirty_log_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 4febf4d5ead9..c7468eb1dcf0 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -59,6 +59,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
>   TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
>   TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
>   TEST_GEN_PROGS_x86_64 += x86_64/user_msr_test
> +TEST_GEN_PROGS_x86_64 += x86_64/user_vmcall_test
>   TEST_GEN_PROGS_x86_64 += demand_paging_test
>   TEST_GEN_PROGS_x86_64 += dirty_log_test
>   TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
> diff --git a/tools/testing/selftests/kvm/x86_64/user_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/user_vmcall_test.c
> new file mode 100644
> index 000000000000..e6286e5d5294
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/user_vmcall_test.c
> @@ -0,0 +1,94 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * user_vmcall_test
> + *
> + * Copyright © 2020 Amazon.com, Inc. or its affiliates.
> + *
> + * Userspace hypercall testing
> + */
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +
> +#define VCPU_ID		5
> +
> +static struct kvm_vm *vm;
> +
> +#define ARGVALUE(x) (0xdeadbeef5a5a0000UL + x)
> +#define RETVALUE 0xcafef00dfbfbffffUL
> +
> +static void guest_code(void)
> +{
> +	unsigned long rax = ARGVALUE(1);
> +	unsigned long rdi = ARGVALUE(2);
> +	unsigned long rsi = ARGVALUE(3);
> +	unsigned long rdx = ARGVALUE(4);
> +	register unsigned long r10 __asm__("r10") = ARGVALUE(5);
> +	register unsigned long r8 __asm__("r8") = ARGVALUE(6);
> +	register unsigned long r9 __asm__("r9") = ARGVALUE(7);
> +	__asm__ __volatile__("vmcall" :
> +			     "=a"(rax) :
> +			     "a"(rax), "D"(rdi), "S"(rsi), "d"(rdx),
> +			     "r"(r10), "r"(r8), "r"(r9));
> +	GUEST_ASSERT(rax == RETVALUE);
> +	GUEST_DONE();
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	if (!kvm_check_cap(KVM_CAP_X86_USER_SPACE_HYPERCALL)) {
> +		print_skip("KVM_CAP_X86_USER_SPACE_HYPERCALL not available");
> +		exit(KSFT_SKIP);
> +	}
> +
> +	struct kvm_enable_cap cap = {
> +		.cap = KVM_CAP_X86_USER_SPACE_HYPERCALL,
> +		.flags = 0,
> +		.args[0] = 1,
> +	};
> +	vm = vm_create_default(VCPU_ID, 0, (void *) guest_code);
> +	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
> +
> +	vm_enable_cap(vm, &cap);
> +
> +	for (;;) {
> +		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
> +		struct ucall uc;
> +
> +		vcpu_run(vm, VCPU_ID);
> +
> +		if (run->exit_reason == KVM_EXIT_HYPERCALL) {
> +			ASSERT_EQ(run->hypercall.longmode, 1);
> +			ASSERT_EQ(run->hypercall.nr, ARGVALUE(1));
> +			ASSERT_EQ(run->hypercall.args[0], ARGVALUE(2));
> +			ASSERT_EQ(run->hypercall.args[1], ARGVALUE(3));
> +			ASSERT_EQ(run->hypercall.args[2], ARGVALUE(4));
> +			ASSERT_EQ(run->hypercall.args[3], ARGVALUE(5));
> +			ASSERT_EQ(run->hypercall.args[4], ARGVALUE(6));
> +			ASSERT_EQ(run->hypercall.args[5], ARGVALUE(7));
> +			run->hypercall.ret = RETVALUE;
> +			continue;
> +		}
> +
> +		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
> +			    run->exit_reason,
> +			    exit_reason_str(run->exit_reason));
> +
> +		switch (get_ucall(vm, VCPU_ID, &uc)) {
> +		case UCALL_ABORT:
> +			TEST_FAIL("%s", (const char *)uc.args[0]);
> +			/* NOT REACHED */
> +		case UCALL_SYNC:
> +			break;
> +		case UCALL_DONE:
> +			goto done;
> +		default:
> +			TEST_FAIL("Unknown ucall 0x%lx.", uc.cmd);
> +		}
> +	}
> +done:
> +	kvm_vm_free(vm);
> +	return 0;
> +}
> 

