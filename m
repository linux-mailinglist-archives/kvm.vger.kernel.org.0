Return-Path: <kvm+bounces-18096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EF918CDF4E
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 03:51:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E614B20DB4
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 01:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10CA022F03;
	Fri, 24 May 2024 01:51:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3BDD79C8;
	Fri, 24 May 2024 01:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716515461; cv=none; b=Tb5YjTiVbiyI3gOaHmzmfwoYYAyeW+nFkkbPSwU3ED5CZlh6zbyaf7/HA0E9JSzof5nDHYBYoQhNkTPasy+w1N+KpD35K7XiyCzZXVbevrwnx/MTV9lbut9b1Oq24wma1btuzDgPRs8r2+NWcKArekAh/8Yhj5eBKNSA8cjeius=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716515461; c=relaxed/simple;
	bh=N/NewkKbyUb7UrI1/SHjF9zkPikBTE9MYNulI6nPEq0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=MUiGxpIMvxqrg740UTWeTIPbf8iKAO5o74BClnNyh+BCr2lnQt9fCgP1bLehTGEwniCuAnbjxgbMRKnpvJM8vSWrfm4icajEUwHwx7eiDOWiE6Fizg13O/uuP+lrb4qNHuuKNEa/7fItd+zcLMLjmoGHtrlABg481jotn/lwMN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8Cxaep_8k9mTTkDAA--.3876S3;
	Fri, 24 May 2024 09:50:55 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxHMd78k9mJHEHAA--.20507S3;
	Fri, 24 May 2024 09:50:53 +0800 (CST)
Subject: Re: [PATCH v2 4/6] KVM: Delete the now unused kvm_arch_sched_in()
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20240522014013.1672962-1-seanjc@google.com>
 <20240522014013.1672962-5-seanjc@google.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <d2810a82-3111-36f0-c27d-fb7c4c7efe58@loongson.cn>
Date: Fri, 24 May 2024 09:50:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240522014013.1672962-5-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxHMd78k9mJHEHAA--.20507S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxtF47GFW5Jry5Jr4DGw45Arc_yoWxtF4Upa
	s3uFs5Wa1fKryrKa4DJr4q93y5Zws5Kw1av34UKrW5JFn8trn8JF4kKr9rJr98JrW093WS
	kFy3KF1ruF4jywcCm3ZEXasCq-sJn29KB7ZKAUJUUUUA529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUtVW8ZwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWr
	XwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jw0_GFylx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUShiSDUUUU



On 2024/5/22 上午9:40, Sean Christopherson wrote:
> Delete kvm_arch_sched_in() now that all implementations are nops.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/arm64/include/asm/kvm_host.h     | 1 -
>   arch/loongarch/include/asm/kvm_host.h | 1 -
>   arch/mips/include/asm/kvm_host.h      | 1 -
>   arch/powerpc/include/asm/kvm_host.h   | 1 -
>   arch/riscv/include/asm/kvm_host.h     | 1 -
>   arch/s390/include/asm/kvm_host.h      | 1 -
>   arch/x86/kvm/pmu.c                    | 6 +++---
>   arch/x86/kvm/x86.c                    | 5 -----
>   include/linux/kvm_host.h              | 2 --
>   virt/kvm/kvm_main.c                   | 1 -
>   10 files changed, 3 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 8170c04fde91..615e7a2e5590 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1225,7 +1225,6 @@ static inline bool kvm_system_needs_idmapped_vectors(void)
>   }
>   
>   static inline void kvm_arch_sync_events(struct kvm *kvm) {}
> -static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>   
>   void kvm_arm_init_debug(void);
>   void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index c87b6ea0ec47..4162a252cdf6 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -261,7 +261,6 @@ static inline bool kvm_is_ifetch_fault(struct kvm_vcpu_arch *arch)
>   static inline void kvm_arch_hardware_unsetup(void) {}
>   static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>   static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
> -static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>   static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>   static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>   static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 179f320cc231..6743a57c1ab4 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -890,7 +890,6 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>   static inline void kvm_arch_free_memslot(struct kvm *kvm,
>   					 struct kvm_memory_slot *slot) {}
>   static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
> -static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>   static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>   static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>   
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 8abac532146e..c4fb6a27fb92 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -897,7 +897,6 @@ struct kvm_vcpu_arch {
>   static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>   static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
>   static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
> -static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>   static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>   static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>   
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index d96281278586..dd77c2db6819 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -286,7 +286,6 @@ struct kvm_vcpu_arch {
>   };
>   
>   static inline void kvm_arch_sync_events(struct kvm *kvm) {}
> -static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>   
>   #define KVM_RISCV_GSTAGE_TLB_MIN_ORDER		12
>   
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 95990461888f..e9fcaf4607a6 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -1045,7 +1045,6 @@ extern int kvm_s390_gisc_register(struct kvm *kvm, u32 gisc);
>   extern int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc);
>   
>   static inline void kvm_arch_sync_events(struct kvm *kvm) {}
> -static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>   static inline void kvm_arch_free_memslot(struct kvm *kvm,
>   					 struct kvm_memory_slot *slot) {}
>   static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index a593b03c9aed..f9149c9fc275 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -521,9 +521,9 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
>   	}
>   
>   	/*
> -	 * Unused perf_events are only released if the corresponding MSRs
> -	 * weren't accessed during the last vCPU time slice. kvm_arch_sched_in
> -	 * triggers KVM_REQ_PMU if cleanup is needed.
> +	 * Release unused perf_events if the corresponding guest MSRs weren't
> +	 * accessed during the last vCPU time slice (need_cleanup is set when
> +	 * the vCPU is scheduled back in).
>   	 */
>   	if (unlikely(pmu->need_cleanup))
>   		kvm_pmu_cleanup(vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e924d1c51e31..59aa772af755 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12586,11 +12586,6 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
>   	return (vcpu->arch.apic_base & MSR_IA32_APICBASE_BSP) != 0;
>   }
>   
> -void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
> -{
> -
> -}
> -
>   void kvm_arch_free_vm(struct kvm *kvm)
>   {
>   #if IS_ENABLED(CONFIG_HYPERV)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index bde69f74b031..c404c428a866 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1495,8 +1495,6 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>   					struct kvm_guest_debug *dbg);
>   int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu);
>   
> -void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
> -
>   void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>   void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
>   int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7ecea573d121..b312d0cbe60b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -6286,7 +6286,6 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
>   	WRITE_ONCE(vcpu->ready, false);
>   
>   	__this_cpu_write(kvm_running_vcpu, vcpu);
> -	kvm_arch_sched_in(vcpu, cpu);
>   	kvm_arch_vcpu_load(vcpu, cpu);
>   
>   	WRITE_ONCE(vcpu->scheduled_out, false);
> 

Reviewed-by: Bibo Mao <maobibo@loongson.cn>


