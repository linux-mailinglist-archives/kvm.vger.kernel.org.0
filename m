Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995821D8C9D
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 02:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgESA4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 20:56:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32535 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726374AbgESA4V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 20:56:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589849777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=thQddAY6xiE06AsTds9gxL3f7mPpOIX74t3ohAqchm0=;
        b=W3fnfm/QnMW8DJNFl14BfhXMLi9oInK1mqiXjejmUxwQzVMI1SgqS63j5fIfufA1pGxRfm
        3VUlUkZgLK8/gBV/ikQVCFZ6nF/K1EUcPBdnPE2mARqLXcqNvDf++2vHCJQCum1kt/8z3J
        eWb8Hx0NEGwh5UEnjFZuy/dX43A6cTI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-WG3J4hJqNluGbUzgfFN3kg-1; Mon, 18 May 2020 20:56:16 -0400
X-MC-Unique: WG3J4hJqNluGbUzgfFN3kg-1
Received: by mail-wm1-f70.google.com with SMTP id 23so614435wma.8
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 17:56:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=thQddAY6xiE06AsTds9gxL3f7mPpOIX74t3ohAqchm0=;
        b=RmAiArfvq0NqfJRx/3Nfg7KKX/oZBaKtf3L6N56CdZZDPQ2+ETDJw5CDykKWOd+TQi
         zcfuf7XOvV4EbOgkLRlAluPRkAWkj/D65ZOZpx9eVdxuO+/SKjEOsJSCuUius0a2SesJ
         NbDJa8YAAJkeXCp74AzZyFpzvEM+rsowMyVdFI36DnecnUuu4ORd9bCuShOpiFylviz7
         GBNw6TS7dRtFew+41dUAQfVLBqx2Uj/DfbZ+ssNZVx929idq8r5D1Z2417G3N+Q5gRtm
         flYeRFU2WnkfvuGDi6NX2eVtfpYgPtSdzxMakHxJpkyJc3nbNCR6ktw07R7lFo4PHOm/
         z7Og==
X-Gm-Message-State: AOAM532KuKqL/0XoVgyRxxeCiHT6p47BFBrfTV7KXn8Djdep/O6xbyBa
        6aVIso3fucL9dDHoIdJXvbWDZzXOK1gR8rgRAY++2XfsU33smVhJxebEc1Gijhk0Oo3NP0QP0rO
        jONwyoP7UqrxI
X-Received: by 2002:a1c:4b0e:: with SMTP id y14mr2285378wma.170.1589849774540;
        Mon, 18 May 2020 17:56:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjV9saR2Bljmd7DxaarV6aJTSqrYV0pig80p6YV7RW6d+BREUZfYV6R9E9N1tUnEDcPxR2zg==
X-Received: by 2002:a1c:4b0e:: with SMTP id y14mr2285353wma.170.1589849774181;
        Mon, 18 May 2020 17:56:14 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y3sm18519632wrm.64.2020.05.18.17.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 17:56:13 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Makarand Sonare <makarandsonare@google.com>
Cc:     Makarand Sonare <makarandsonare@google.com>, kvm@vger.kernel.org,
        pshier@google.com, jmattson@google.com
Subject: Re: [PATCH  2/2] KVM: selftests: VMX preemption timer migration test
In-Reply-To: <20200518201600.255669-3-makarandsonare@google.com>
References: <20200518201600.255669-1-makarandsonare@google.com> <20200518201600.255669-3-makarandsonare@google.com>
Date:   Tue, 19 May 2020 02:56:12 +0200
Message-ID: <87367wvj2r.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Makarand Sonare <makarandsonare@google.com> writes:

> When a nested VM with a VMX-preemption timer is migrated, verify that the
> nested VM and its parent VM observe the VMX-preemption timer exit close to
> the original expiration deadline.
>
> Signed-off-by: Makarand Sonare <makarandsonare@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Change-Id: Ia79337c682ee161399525edc34201fad473fc190
> ---
>  tools/arch/x86/include/uapi/asm/kvm.h         |   1 +
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../testing/selftests/kvm/include/kvm_util.h  |   2 +
>  .../selftests/kvm/include/x86_64/processor.h  |  11 +-
>  .../selftests/kvm/include/x86_64/vmx.h        |  27 ++
>  .../kvm/x86_64/vmx_preemption_timer_test.c    | 256 ++++++++++++++++++
>  7 files changed, 295 insertions(+), 4 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
>
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
> index 60701178b9cc1..13dca545554dc 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -402,6 +402,7 @@ struct kvm_sync_regs {
>  struct kvm_vmx_nested_state_data {
>  	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
>  	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
> +	__u64 preemption_timer_deadline;
>  };
>  
>  struct kvm_vmx_nested_state_hdr {
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 222e50104296a..f159718f90c0a 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -10,6 +10,7 @@
>  /x86_64/set_sregs_test
>  /x86_64/smm_test
>  /x86_64/state_test
> +/x86_64/vmx_preemption_timer_test
>  /x86_64/svm_vmcall_test
>  /x86_64/sync_regs_test
>  /x86_64/vmx_close_while_nested_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index c66f4eec34111..780f0c189a7bc 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -20,6 +20,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
>  TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
>  TEST_GEN_PROGS_x86_64 += x86_64/smm_test
>  TEST_GEN_PROGS_x86_64 += x86_64/state_test
> +TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
>  TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
>  TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index e244c6ecfc1d5..919e161dd2893 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -314,6 +314,8 @@ void ucall_uninit(struct kvm_vm *vm);
>  void ucall(uint64_t cmd, int nargs, ...);
>  uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
>  
> +#define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
> +				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
>  #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
>  #define GUEST_DONE()		ucall(UCALL_DONE, 0)
>  #define __GUEST_ASSERT(_condition, _nargs, _args...) do {	\
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 7428513a4c687..7cb19eca6c72d 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -79,13 +79,16 @@ static inline uint64_t get_desc64_base(const struct desc64 *desc)
>  static inline uint64_t rdtsc(void)
>  {
>  	uint32_t eax, edx;
> -
> +	uint32_t tsc_val;
>  	/*
>  	 * The lfence is to wait (on Intel CPUs) until all previous
> -	 * instructions have been executed.
> +	 * instructions have been executed. If software requires RDTSC to be
> +	 * executed prior to execution of any subsequent instruction, it can
> +	 * execute LFENCE immediately after RDTSC
>  	 */
> -	__asm__ __volatile__("lfence; rdtsc" : "=a"(eax), "=d"(edx));
> -	return ((uint64_t)edx) << 32 | eax;
> +	__asm__ __volatile__("lfence; rdtsc; lfence" : "=a"(eax), "=d"(edx));
> +	tsc_val = ((uint64_t)edx) << 32 | eax;
> +	return tsc_val;
>  }
>  
>  static inline uint64_t rdtscp(uint32_t *aux)
> diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> index 3d27069b9ed9c..ccff3e6e27048 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> @@ -575,6 +575,33 @@ struct vmx_pages {
>  	void *eptp;
>  };
>  
> +union vmx_basic {
> +	u64 val;
> +	struct {
> +		u32 revision;
> +		u32	size:13,
> +			reserved1:3,
> +			width:1,
> +			dual:1,
> +			type:4,
> +			insouts:1,
> +			ctrl:1,
> +			vm_entry_exception_ctrl:1,
> +			reserved2:7;
> +	};
> +};
> +
> +union vmx_ctrl_msr {
> +	u64 val;
> +	struct {
> +		u32 set, clr;
> +	};
> +};
> +
> +union vmx_basic basic;
> +union vmx_ctrl_msr ctrl_pin_rev;
> +union vmx_ctrl_msr ctrl_exit_rev;
> +
>  struct vmx_pages *vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva);
>  bool prepare_for_vmx_operation(struct vmx_pages *vmx);
>  void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp);
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
> new file mode 100644
> index 0000000000000..10893b11511be
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
> @@ -0,0 +1,256 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * VMX-preemption timer test
> + *
> + * Copyright (C) 2020, Google, LLC.
> + *
> + * Test to ensure the VM-Enter after migration doesn't
> + * incorrectly restarts the timer with the full timer
> + * value instead of partially decayed timer value
> + *
> + */
> +#define _GNU_SOURCE /* for program_invocation_short_name */
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +
> +#include "test_util.h"
> +
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "vmx.h"
> +
> +#define VCPU_ID		5
> +#define PREEMPTION_TIMER_VALUE			100000000ull
> +#define PREEMPTION_TIMER_VALUE_THRESHOLD1	 80000000ull
> +
> +u32 vmx_pt_rate;
> +bool l2_save_restore_done;
> +static u64 l2_vmx_pt_start;
> +volatile u64 l2_vmx_pt_finish;
> +
> +void l2_guest_code(void)
> +{
> +	u64 vmx_pt_delta;
> +
> +	vmcall();
> +	l2_vmx_pt_start = (rdtsc() >> vmx_pt_rate) << vmx_pt_rate;
> +
> +	//
> +	// Wait until the 1st threshold has passed
> +	//
> +	do {
> +		l2_vmx_pt_finish = rdtsc();
> +		vmx_pt_delta = (l2_vmx_pt_finish - l2_vmx_pt_start) >>
> +				vmx_pt_rate;
> +	} while (vmx_pt_delta < PREEMPTION_TIMER_VALUE_THRESHOLD1);
> +
> +	//
> +	// Force L2 through Save and Restore cycle
> +	//
> +	GUEST_SYNC(1);
> +
> +	l2_save_restore_done = 1;
> +
> +	//
> +	// Now wait for the preemption timer to fire and
> +	// exit to L1
> +	//
> +	while ((l2_vmx_pt_finish = rdtsc()))
> +		;
> +}
> +
> +void l1_guest_code(struct vmx_pages *vmx_pages)
> +{
> +#define L2_GUEST_STACK_SIZE 64
> +	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
> +	u64 l1_vmx_pt_start;
> +	u64 l1_vmx_pt_finish;
> +	u64 l1_tsc_deadline, l2_tsc_deadline;
> +
> +	GUEST_ASSERT(vmx_pages->vmcs_gpa);
> +	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
> +	GUEST_ASSERT(load_vmcs(vmx_pages));
> +	GUEST_ASSERT(vmptrstz() == vmx_pages->vmcs_gpa);
> +
> +	prepare_vmcs(vmx_pages, l2_guest_code,
> +		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
> +
> +	GUEST_ASSERT(!vmlaunch());
> +	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
> +	vmwrite(GUEST_RIP, vmreadz(GUEST_RIP) + 3);
> +
> +	//
> +	// Check for Preemption timer support and turn on PIN control
> +	//
> +	basic.val = rdmsr(MSR_IA32_VMX_BASIC);
> +	ctrl_pin_rev.val = rdmsr(basic.ctrl ? MSR_IA32_VMX_TRUE_PINBASED_CTLS
> +			: MSR_IA32_VMX_PINBASED_CTLS);
> +	ctrl_exit_rev.val = rdmsr(basic.ctrl ? MSR_IA32_VMX_TRUE_EXIT_CTLS
> +			: MSR_IA32_VMX_EXIT_CTLS);
> +
> +	if (!(ctrl_pin_rev.clr & PIN_BASED_VMX_PREEMPTION_TIMER) ||
> +	    !(ctrl_exit_rev.clr & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER))
> +		return;
> +
> +	GUEST_ASSERT(!vmwrite(PIN_BASED_VM_EXEC_CONTROL,
> +			      vmreadz(PIN_BASED_VM_EXEC_CONTROL) |
> +			      PIN_BASED_VMX_PREEMPTION_TIMER));
> +
> +	GUEST_ASSERT(!vmwrite(VMX_PREEMPTION_TIMER_VALUE,
> +			      PREEMPTION_TIMER_VALUE));
> +
> +	vmx_pt_rate = rdmsr(MSR_IA32_VMX_MISC) & 0x1F;
> +
> +	l2_save_restore_done = 0;
> +
> +	l1_vmx_pt_start = (rdtsc() >> vmx_pt_rate) << vmx_pt_rate;
> +
> +	GUEST_ASSERT(!vmresume());
> +
> +	l1_vmx_pt_finish = rdtsc();
> +
> +	//
> +	// Ensure exit from L2 happens after L2 goes through
> +	// save and restore
> +	GUEST_ASSERT(l2_save_restore_done);
> +
> +	//
> +	// Ensure the exit from L2 is due to preemption timer expiry
> +	//
> +	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_PREEMPTION_TIMER);
> +
> +	l1_tsc_deadline = l1_vmx_pt_start +
> +		(PREEMPTION_TIMER_VALUE << vmx_pt_rate);
> +
> +	l2_tsc_deadline = l2_vmx_pt_start +
> +		(PREEMPTION_TIMER_VALUE << vmx_pt_rate);
> +
> +	//
> +	// Sync with the host and pass the l1|l2 pt_expiry_finish times and
> +	// tsc deadlines so that host can verify they are as expected
> +	//
> +	GUEST_SYNC_ARGS(2, l1_vmx_pt_finish, l1_tsc_deadline,
> +		l2_vmx_pt_finish, l2_tsc_deadline);
> +}
> +
> +void guest_code(struct vmx_pages *vmx_pages)
> +{
> +	if (vmx_pages)
> +		l1_guest_code(vmx_pages);
> +
> +	GUEST_DONE();
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	vm_vaddr_t vmx_pages_gva = 0;
> +
> +	struct kvm_regs regs1, regs2;
> +	struct kvm_vm *vm;
> +	struct kvm_run *run;
> +	struct kvm_x86_state *state;
> +	struct ucall uc;
> +	int stage;
> +
> +	/*
> +	 * AMD currently does not implement any VMX features, so for now we
> +	 * just early out.
> +	 */
> +	nested_vmx_check_supported();
> +
> +	/* Create VM */
> +	vm = vm_create_default(VCPU_ID, 0, guest_code);
> +	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
> +	run = vcpu_state(vm, VCPU_ID);
> +
> +	vcpu_regs_get(vm, VCPU_ID, &regs1);
> +
> +	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {

You need to check the newly added KVM_CAP_NESTED_STATE_PREEMPTION_TIMER
instead or skip the whole test.

> +		vcpu_alloc_vmx(vm, &vmx_pages_gva);
> +		vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
> +	} else {
> +		pr_info("will skip nested state checks\n");

Copy/paste from state_test.c detected :-)

> +		goto done;
> +	}
> +
> +	for (stage = 1;; stage++) {
> +		_vcpu_run(vm, VCPU_ID);
> +		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +			    "Stage %d: unexpected exit reason: %u (%s),\n",
> +			    stage, run->exit_reason,
> +			    exit_reason_str(run->exit_reason));
> +
> +		switch (get_ucall(vm, VCPU_ID, &uc)) {
> +		case UCALL_ABORT:
> +			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
> +				  __FILE__, uc.args[1]);
> +			/* NOT REACHED */
> +		case UCALL_SYNC:
> +			break;
> +		case UCALL_DONE:
> +			goto done;
> +		default:
> +			TEST_FAIL("Unknown ucall %lu", uc.cmd);
> +		}
> +
> +		/* UCALL_SYNC is handled here.  */
> +		TEST_ASSERT(!strcmp((const char *)uc.args[0], "hello") &&
> +			    uc.args[1] == stage, "Stage %d: Unexpected register values vmexit, got %lx",
> +			    stage, (ulong)uc.args[1]);
> +		//
> +		// If this stage 2 then we should verify the vmx pt expiry
> +		// is as expected
> +		//

Nitpick: coding style requirements for selftests is definitely lower
than for KVM itself but could you please be consistent with comments and
use kernel style 
  /*
   * This is a comment.
   */
comments exclusively (you seem to have a mix)? Thanks!

> +		if (stage == 2) {
> +
> +			pr_info("Stage %d: L1 PT expiry TSC (%lu) , L1 TSC deadline (%lu)\n",
> +				stage, uc.args[2], uc.args[3]);
> +
> +			pr_info("Stage %d: L2 PT expiry TSC (%lu) , L2 TSC deadline (%lu)\n",
> +				stage, uc.args[4], uc.args[5]);
> +
> +			//
> +			// From L1's perspective verify Preemption timer hasn't
> +			// expired too early
> +			//
> +
> +			TEST_ASSERT(uc.args[2] >= uc.args[3],
> +				"Stage %d: L1 PT expiry TSC (%lu) < L1 TSC deadline (%lu)",
> +				stage, uc.args[2], uc.args[3]);
> +
> +			//
> +			// From L2's perspective verify Preemption timer hasn't
> +			// expired too late
> +			//
> +			TEST_ASSERT(uc.args[4] < uc.args[5],
> +				"Stage %d: L2 PT expiry TSC (%lu) > L2 TSC deadline (%lu)",
> +				stage, uc.args[4], uc.args[5]);
> +		}
> +
> +		state = vcpu_save_state(vm, VCPU_ID);
> +		memset(&regs1, 0, sizeof(regs1));
> +		vcpu_regs_get(vm, VCPU_ID, &regs1);
> +
> +		kvm_vm_release(vm);
> +
> +		/* Restore state in a new VM.  */
> +		kvm_vm_restart(vm, O_RDWR);
> +		vm_vcpu_add(vm, VCPU_ID);
> +		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
> +		vcpu_load_state(vm, VCPU_ID, state);
> +		run = vcpu_state(vm, VCPU_ID);
> +		free(state);
> +
> +		memset(&regs2, 0, sizeof(regs2));
> +		vcpu_regs_get(vm, VCPU_ID, &regs2);
> +		TEST_ASSERT(!memcmp(&regs1, &regs2, sizeof(regs2)),
> +			    "Unexpected register values after vcpu_load_state; rdi: %lx rsi: %lx",
> +			    (ulong) regs2.rdi, (ulong) regs2.rsi);
> +	}
> +
> +done:
> +	kvm_vm_free(vm);
> +}

-- 
Vitaly

