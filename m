Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7F9418FAF
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 09:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbhI0HIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 03:08:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59328 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233140AbhI0HIi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 03:08:38 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18R6iidY025203;
        Mon, 27 Sep 2021 03:06:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VrcGDOczcCHv4Pue4453yhBpNJYHgbMRpmBUKu3vveU=;
 b=GePVhr2f1Wg4Mr6taQ+EhyJANBVLG2r4WmaY/yUyNZe+Zj7npGlSkEOznV5hpyYIcVSg
 al39wug1HXEkbdU07ug1aivrGipAZe8yiC9rbvaCxSBig44xBehQGZTRo33A/vBNB8Zq
 7A3DA0F0hrj7X7gVXYD0a/fBHmmkTaKd0sbePcnbrV90yPqXjcJt17z9g0978ApseC51
 BBUtaD/9QCnhkpVZp9tWoeC7ZNL5nWLx6WqRJUmnfjoU8ROYs42IL8uJLMfeyGs9seuA
 9gnxQHUNyjNs6aTwUVLuSvYwtRWKstnJhrKLC5F8B2yO3RX5j54w8mt+fQAt+3pfMrpG VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bagnpmmvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 03:06:15 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18R6iY2s022168;
        Mon, 27 Sep 2021 03:06:15 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bagnpmmuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 03:06:15 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18R71NcP018678;
        Mon, 27 Sep 2021 07:06:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3b9ud9hjw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 07:06:12 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18R769tB5964454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 07:06:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BA3A52069;
        Mon, 27 Sep 2021 07:06:09 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.4.236])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7BD795207B;
        Mon, 27 Sep 2021 07:06:07 +0000 (GMT)
Subject: Re: [PATCH 09/14] KVM: Rename kvm_vcpu_block() => kvm_vcpu_halt()
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-10-seanjc@google.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <91d02a7a-4494-1631-27c6-221884f426c5@de.ibm.com>
Date:   Mon, 27 Sep 2021 09:06:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210925005528.1145584-10-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 56FRp7-MT8VcgfF7q1wu5AhXxv17W5a3
X-Proofpoint-ORIG-GUID: mUPsPtUked4WhniIXn1Ith2thO-2AjvU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-27_02,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 suspectscore=0 phishscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=965
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270046
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 25.09.21 um 02:55 schrieb Sean Christopherson:
> Rename kvm_vcpu_block() to kvm_vcpu_halt() in preparation for splitting
> the actual "block" sequences into a separate helper (to be named
> kvm_vcpu_block()).  x86 will use the standalone block-only path to handle
> non-halt cases where the vCPU is not runnable.
> 
> Rename block_ns to halt_ns to match the new function name.
> 
> Opportunistically move an x86-specific comment to x86, and enhance it, too.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>   arch/arm64/kvm/arch_timer.c       |  2 +-
>   arch/arm64/kvm/handle_exit.c      |  4 ++--
>   arch/arm64/kvm/psci.c             |  2 +-
>   arch/mips/kvm/emulate.c           |  2 +-
>   arch/powerpc/kvm/book3s_pr.c      |  2 +-
>   arch/powerpc/kvm/book3s_pr_papr.c |  2 +-
>   arch/powerpc/kvm/booke.c          |  2 +-
>   arch/powerpc/kvm/powerpc.c        |  2 +-
>   arch/s390/kvm/interrupt.c         |  2 +-
>   arch/x86/kvm/x86.c                | 11 +++++++++--
>   include/linux/kvm_host.h          |  2 +-
>   virt/kvm/kvm_main.c               | 20 +++++++++-----------
>   12 files changed, 29 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 3df67c127489..7e8396f74010 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -467,7 +467,7 @@ static void timer_save_state(struct arch_timer_context *ctx)
>   }
>   
>   /*
> - * Schedule the background timer before calling kvm_vcpu_block, so that this
> + * Schedule the background timer before calling kvm_vcpu_halt, so that this
>    * thread is removed from its waitqueue and made runnable when there's a timer
>    * interrupt to handle.
>    */
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 275a27368a04..08f823984712 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -82,7 +82,7 @@ static int handle_no_fpsimd(struct kvm_vcpu *vcpu)
>    *
>    * WFE: Yield the CPU and come back to this vcpu when the scheduler
>    * decides to.
> - * WFI: Simply call kvm_vcpu_block(), which will halt execution of
> + * WFI: Simply call kvm_vcpu_halt(), which will halt execution of
>    * world-switches and schedule other host processes until there is an
>    * incoming IRQ or FIQ to the VM.
>    */
> @@ -95,7 +95,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
>   	} else {
>   		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
>   		vcpu->stat.wfi_exit_stat++;
> -		kvm_vcpu_block(vcpu);
> +		kvm_vcpu_halt(vcpu);
>   		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>   	}
>   
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 74c47d420253..e275b2ca08b9 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -46,7 +46,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
>   	 * specification (ARM DEN 0022A). This means all suspend states
>   	 * for KVM will preserve the register state.
>   	 */
> -	kvm_vcpu_block(vcpu);
> +	kvm_vcpu_halt(vcpu);
>   	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>   
>   	return PSCI_RET_SUCCESS;
> diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
> index 22e745e49b0a..b494d8d39290 100644
> --- a/arch/mips/kvm/emulate.c
> +++ b/arch/mips/kvm/emulate.c
> @@ -952,7 +952,7 @@ enum emulation_result kvm_mips_emul_wait(struct kvm_vcpu *vcpu)
>   	if (!vcpu->arch.pending_exceptions) {
>   		kvm_vz_lose_htimer(vcpu);
>   		vcpu->arch.wait = 1;
> -		kvm_vcpu_block(vcpu);
> +		kvm_vcpu_halt(vcpu);
>   
>   		/*
>   		 * We we are runnable, then definitely go off to user space to
> diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
> index 6bc9425acb32..0ced1b16f0e5 100644
> --- a/arch/powerpc/kvm/book3s_pr.c
> +++ b/arch/powerpc/kvm/book3s_pr.c
> @@ -492,7 +492,7 @@ static void kvmppc_set_msr_pr(struct kvm_vcpu *vcpu, u64 msr)
>   
>   	if (msr & MSR_POW) {
>   		if (!vcpu->arch.pending_exceptions) {
> -			kvm_vcpu_block(vcpu);
> +			kvm_vcpu_halt(vcpu);
>   			kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>   			vcpu->stat.generic.halt_wakeup++;
>   
> diff --git a/arch/powerpc/kvm/book3s_pr_papr.c b/arch/powerpc/kvm/book3s_pr_papr.c
> index ac14239f3424..1f10e7dfcdd0 100644
> --- a/arch/powerpc/kvm/book3s_pr_papr.c
> +++ b/arch/powerpc/kvm/book3s_pr_papr.c
> @@ -376,7 +376,7 @@ int kvmppc_h_pr(struct kvm_vcpu *vcpu, unsigned long cmd)
>   		return kvmppc_h_pr_stuff_tce(vcpu);
>   	case H_CEDE:
>   		kvmppc_set_msr_fast(vcpu, kvmppc_get_msr(vcpu) | MSR_EE);
> -		kvm_vcpu_block(vcpu);
> +		kvm_vcpu_halt(vcpu);
>   		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>   		vcpu->stat.generic.halt_wakeup++;
>   		return EMULATE_DONE;
> diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
> index 977801c83aff..12abffa40cd9 100644
> --- a/arch/powerpc/kvm/booke.c
> +++ b/arch/powerpc/kvm/booke.c
> @@ -718,7 +718,7 @@ int kvmppc_core_prepare_to_enter(struct kvm_vcpu *vcpu)
>   
>   	if (vcpu->arch.shared->msr & MSR_WE) {
>   		local_irq_enable();
> -		kvm_vcpu_block(vcpu);
> +		kvm_vcpu_halt(vcpu);
>   		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>   		hard_irq_disable();
>   
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 8ab90ce8738f..565eed2dab81 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -236,7 +236,7 @@ int kvmppc_kvm_pv(struct kvm_vcpu *vcpu)
>   		break;
>   	case EV_HCALL_TOKEN(EV_IDLE):
>   		r = EV_SUCCESS;
> -		kvm_vcpu_block(vcpu);
> +		kvm_vcpu_halt(vcpu);
>   		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
>   		break;
>   	default:
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 520450a7956f..10bd648170b7 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -1335,7 +1335,7 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
>   	VCPU_EVENT(vcpu, 4, "enabled wait: %llu ns", sltime);
>   no_timer:
>   	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
> -	kvm_vcpu_block(vcpu);
> +	kvm_vcpu_halt(vcpu);
>   	vcpu->valid_wakeup = false;
>   	__unset_cpu_idle(vcpu);
>   	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eade8a2bdccf..0d71c73a61bb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8645,6 +8645,13 @@ void kvm_arch_exit(void)
>   
>   static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
>   {
> +	/*
> +	 * The vCPU has halted, e.g. executed HLT.  Update the run state if the
> +	 * local APIC is in-kernel, the run loop will detect the non-runnable
> +	 * state and halt the vCPU.  Exit to userspace if the local APIC is
> +	 * managed by userspace, in which case userspace is responsible for
> +	 * handling wake events.
> +	 */
>   	++vcpu->stat.halt_exits;
>   	if (lapic_in_kernel(vcpu)) {
>   		vcpu->arch.mp_state = state;
> @@ -9886,7 +9893,7 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>   	if (!kvm_arch_vcpu_runnable(vcpu) &&
>   	    (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu) == 0)) {
>   		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
> -		kvm_vcpu_block(vcpu);
> +		kvm_vcpu_halt(vcpu);
>   		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
>   
>   		if (kvm_x86_ops.post_block)
> @@ -10120,7 +10127,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   			r = -EINTR;
>   			goto out;
>   		}
> -		kvm_vcpu_block(vcpu);
> +		kvm_vcpu_halt(vcpu);
>   		if (kvm_apic_accept_events(vcpu) < 0) {
>   			r = 0;
>   			goto out;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3f87d6ad20bf..d2a8be3fb9ba 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -965,7 +965,7 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
>   void kvm_sigset_activate(struct kvm_vcpu *vcpu);
>   void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
>   
> -void kvm_vcpu_block(struct kvm_vcpu *vcpu);
> +void kvm_vcpu_halt(struct kvm_vcpu *vcpu);
>   void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
>   void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
>   bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f96cda8312f3..280cf1dca7db 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3221,16 +3221,13 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>   	}
>   }
>   
> -/*
> - * The vCPU has executed a HLT instruction with in-kernel mode enabled.
> - */
> -void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> +void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>   {
>   	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
>   	bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
>   	ktime_t start, cur, poll_end;
>   	bool waited = false;
> -	u64 block_ns;
> +	u64 halt_ns;
>   
>   	start = cur = poll_end = ktime_get();
>   	if (do_halt_poll) {
> @@ -3273,7 +3270,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>   	}
>   
>   out:
> -	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
> +	/* The total time the vCPU was "halted", including polling time. */
> +	halt_ns = ktime_to_ns(cur) - ktime_to_ns(start);
>   
>   	/*
>   	 * Note, halt-polling is considered successful so long as the vCPU was
> @@ -3287,24 +3285,24 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>   		if (!vcpu_valid_wakeup(vcpu)) {
>   			shrink_halt_poll_ns(vcpu);
>   		} else if (vcpu->kvm->max_halt_poll_ns) {
> -			if (block_ns <= vcpu->halt_poll_ns)
> +			if (halt_ns <= vcpu->halt_poll_ns)
>   				;
>   			/* we had a long block, shrink polling */
>   			else if (vcpu->halt_poll_ns &&
> -					block_ns > vcpu->kvm->max_halt_poll_ns)
> +				 halt_ns > vcpu->kvm->max_halt_poll_ns)
>   				shrink_halt_poll_ns(vcpu);
>   			/* we had a short halt and our poll time is too small */
>   			else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
> -					block_ns < vcpu->kvm->max_halt_poll_ns)
> +				 halt_ns < vcpu->kvm->max_halt_poll_ns)
>   				grow_halt_poll_ns(vcpu);
>   		} else {
>   			vcpu->halt_poll_ns = 0;
>   		}
>   	}
>   
> -	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
> +	trace_kvm_vcpu_wakeup(halt_ns, waited, vcpu_valid_wakeup(vcpu));
>   }
> -EXPORT_SYMBOL_GPL(kvm_vcpu_block);
> +EXPORT_SYMBOL_GPL(kvm_vcpu_halt);
>   
>   bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
>   {
> 
