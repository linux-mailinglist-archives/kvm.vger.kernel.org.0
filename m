Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2057D1DA7C3
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 04:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgETCOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 22:14:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54068 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgETCOR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 22:14:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2Blbi009490;
        Wed, 20 May 2020 02:14:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=boj97ginHruVl7wPG6EjLd4Q1e49o4KqjJTFGM62h3U=;
 b=DZRpQA7fO8b2+9DtEaiTCHf4XOgGtVXWUHEu0Up3AWiAeurjZ606sYgQksXz3epV9yHG
 uN7ByixwPZ54pX69ggeXVp2J4ZkunnJY2Nc1kuNEhYBnvvINVUMwLll3IxFqJcVESjMu
 5gsHhxRKaep+u480FVuYxuQKfgdy7RqZnHITb3f38hgPg/CACsExrhTEvmvoh8VDL3sC
 DIL//vd84gVkWG/jItEyWUyuB0S7GcTrsSaR35R1lxthiBPEMqDOHcBoFrF6YqHyHz3e
 g73WsoLoUK0Izs3BKrY6R4MWa2X3uQvc46i5BmQgiG5efCFeXImEAe+yI91fJE+se5QT Lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31284m0k9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 02:14:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K28PvN136336;
        Wed, 20 May 2020 02:14:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 314gm64x6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 02:14:13 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04K2ECYA022026;
        Wed, 20 May 2020 02:14:12 GMT
Received: from localhost.localdomain (/10.159.232.15)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 19:14:11 -0700
Subject: Re: [PATCH 2/2] KVM: selftests: VMX preemption timer migration test
To:     Makarand Sonare <makarandsonare@google.com>, kvm@vger.kernel.org,
        pshier@google.com, jmattson@google.com
References: <20200518201600.255669-1-makarandsonare@google.com>
 <20200518201600.255669-3-makarandsonare@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <433a171c-c248-e58a-f2f7-778042bf66ff@oracle.com>
Date:   Tue, 19 May 2020 19:14:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200518201600.255669-3-makarandsonare@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=2
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005200016
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/18/20 1:16 PM, Makarand Sonare wrote:
> When a nested VM with a VMX-preemption timer is migrated, verify that the
> nested VM and its parent VM observe the VMX-preemption timer exit close to
> the original expiration deadline.
>
> Signed-off-by: Makarand Sonare <makarandsonare@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Change-Id: Ia79337c682ee161399525edc34201fad473fc190
> ---
>   tools/arch/x86/include/uapi/asm/kvm.h         |   1 +
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../testing/selftests/kvm/include/kvm_util.h  |   2 +
>   .../selftests/kvm/include/x86_64/processor.h  |  11 +-
>   .../selftests/kvm/include/x86_64/vmx.h        |  27 ++
>   .../kvm/x86_64/vmx_preemption_timer_test.c    | 256 ++++++++++++++++++
>   7 files changed, 295 insertions(+), 4 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
>
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
> index 60701178b9cc1..13dca545554dc 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -402,6 +402,7 @@ struct kvm_sync_regs {
>   struct kvm_vmx_nested_state_data {
>   	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
>   	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
> +	__u64 preemption_timer_deadline;
>   };
>   
>   struct kvm_vmx_nested_state_hdr {
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 222e50104296a..f159718f90c0a 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -10,6 +10,7 @@
>   /x86_64/set_sregs_test
>   /x86_64/smm_test
>   /x86_64/state_test
> +/x86_64/vmx_preemption_timer_test
>   /x86_64/svm_vmcall_test
>   /x86_64/sync_regs_test
>   /x86_64/vmx_close_while_nested_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index c66f4eec34111..780f0c189a7bc 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -20,6 +20,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
>   TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
>   TEST_GEN_PROGS_x86_64 += x86_64/smm_test
>   TEST_GEN_PROGS_x86_64 += x86_64/state_test
> +TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
>   TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
>   TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index e244c6ecfc1d5..919e161dd2893 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -314,6 +314,8 @@ void ucall_uninit(struct kvm_vm *vm);
>   void ucall(uint64_t cmd, int nargs, ...);
>   uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
>   
> +#define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
> +				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
>   #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
>   #define GUEST_DONE()		ucall(UCALL_DONE, 0)
>   #define __GUEST_ASSERT(_condition, _nargs, _args...) do {	\
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 7428513a4c687..7cb19eca6c72d 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -79,13 +79,16 @@ static inline uint64_t get_desc64_base(const struct desc64 *desc)
>   static inline uint64_t rdtsc(void)
>   {
>   	uint32_t eax, edx;
> -
> +	uint32_t tsc_val;
>   	/*
>   	 * The lfence is to wait (on Intel CPUs) until all previous
> -	 * instructions have been executed.
> +	 * instructions have been executed. If software requires RDTSC to be
> +	 * executed prior to execution of any subsequent instruction, it can
> +	 * execute LFENCE immediately after RDTSC
>   	 */
> -	__asm__ __volatile__("lfence; rdtsc" : "=a"(eax), "=d"(edx));
> -	return ((uint64_t)edx) << 32 | eax;
> +	__asm__ __volatile__("lfence; rdtsc; lfence" : "=a"(eax), "=d"(edx));
> +	tsc_val = ((uint64_t)edx) << 32 | eax;
> +	return tsc_val;
>   }
>   
>   static inline uint64_t rdtscp(uint32_t *aux)
> diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> index 3d27069b9ed9c..ccff3e6e27048 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> @@ -575,6 +575,33 @@ struct vmx_pages {
>   	void *eptp;
>   };
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
>   struct vmx_pages *vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva);
>   bool prepare_for_vmx_operation(struct vmx_pages *vmx);
>   void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp);
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


Please use vmcs_read(VM_EXIT_INSTRUCTION_LEN) instead of 3.

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


Why not do this check in the beginning of L1, before VMLAUNCH of L2 ? If 
these two controls are not supported, the test is just void.

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


I am wondering if checking just the EXIT reason is enough to determine 
that L2 has gone through a successful migration.

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
> +		vcpu_alloc_vmx(vm, &vmx_pages_gva);
> +		vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
> +	} else {
> +		pr_info("will skip nested state checks\n");


This error message looks odd. Shouldn't it say something like,

     "nested state capability not available, skipping test"

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


For readability, it's better to put a block comment here for the entire 
save/restore operation as a whole.

Also, this save/restore block should be placed before the above stage2 
block.

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
