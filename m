Return-Path: <kvm+bounces-1935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 316317EED7E
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 09:24:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A92241F26255
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 08:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CAE0FC1A;
	Fri, 17 Nov 2023 08:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A9A0130;
	Fri, 17 Nov 2023 00:24:19 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8BxHOsxI1dlcsI6AA--.45935S3;
	Fri, 17 Nov 2023 16:24:17 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxrdwrI1dlNCNFAA--.20259S3;
	Fri, 17 Nov 2023 16:24:13 +0800 (CST)
Subject: Re: [PATCH v1 1/2] LoongArch: KVM: Add lsx support
To: Tianrui Zhao <zhaotianrui@loongson.cn>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, loongarch@lists.linux.dev,
 Jens Axboe <axboe@kernel.dk>, Mark Brown <broonie@kernel.org>,
 Alex Deucher <alexander.deucher@amd.com>,
 Oliver Upton <oliver.upton@linux.dev>, Xi Ruoyao <xry111@xry111.site>
References: <20231115091921.85516-1-zhaotianrui@loongson.cn>
 <20231115091921.85516-2-zhaotianrui@loongson.cn>
From: maobibo <maobibo@loongson.cn>
Message-ID: <2161517e-1934-9d18-3bdf-1e397413b3a8@loongson.cn>
Date: Fri, 17 Nov 2023 16:24:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20231115091921.85516-2-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxrdwrI1dlNCNFAA--.20259S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxKF4DJrWDtr1xWr4rCrW8KrX_yoW3uw17pF
	97Zrn8ta1xWF1Sk3s7tF1qgrnxZr4kKryIgasrJay3AF1Yqry5XF4kKrZrWFy5Gw4rAFyS
	vF1rtr15uayDJ3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	AVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4SoGDU
	UUU



On 2023/11/15 下午5:19, Tianrui Zhao wrote:
> This patch adds LSX support for LoongArch KVM. The LSX means
> LoongArch 128-bits vector instruction.
> There will be LSX exception in KVM when guest use the LSX
> instruction. KVM will enable LSX and restore the vector
> registers for guest then return to guest to continue running.
> 
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>   arch/loongarch/include/asm/kvm_host.h |  6 ++++
>   arch/loongarch/include/asm/kvm_vcpu.h | 12 +++++++
>   arch/loongarch/kvm/exit.c             | 18 ++++++++++
>   arch/loongarch/kvm/switch.S           | 22 +++++++++++++
>   arch/loongarch/kvm/trace.h            |  4 ++-
>   arch/loongarch/kvm/vcpu.c             | 47 +++++++++++++++++++++++++--
>   6 files changed, 105 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index 11328700d4..6c65c25169 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -94,6 +94,7 @@ enum emulation_result {
>   #define KVM_LARCH_FPU		(0x1 << 0)
>   #define KVM_LARCH_SWCSR_LATEST	(0x1 << 1)
>   #define KVM_LARCH_HWCSR_USABLE	(0x1 << 2)
> +#define KVM_LARCH_LSX		(0x1 << 3)
>   
>   struct kvm_vcpu_arch {
>   	/*
> @@ -175,6 +176,11 @@ static inline void writel_sw_gcsr(struct loongarch_csrs *csr, int reg, unsigned
>   	csr->csrs[reg] = val;
>   }
>   
> +static inline bool kvm_guest_has_lsx(struct kvm_vcpu_arch *arch)
> +{
> +	return arch->cpucfg[2] & CPUCFG2_LSX;
> +}
> +
>   /* Debug: dump vcpu state */
>   int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu);
>   
> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
> index 553cfa2b2b..c629771e12 100644
> --- a/arch/loongarch/include/asm/kvm_vcpu.h
> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> @@ -55,6 +55,18 @@ void kvm_save_fpu(struct loongarch_fpu *fpu);
>   void kvm_restore_fpu(struct loongarch_fpu *fpu);
>   void kvm_restore_fcsr(struct loongarch_fpu *fpu);
>   
> +#ifdef CONFIG_CPU_HAS_LSX
> +void kvm_own_lsx(struct kvm_vcpu *vcpu);
> +void kvm_save_lsx(struct loongarch_fpu *fpu);
> +void kvm_restore_lsx(struct loongarch_fpu *fpu);
> +void kvm_restore_lsx_upper(struct loongarch_fpu *fpu);
> +#else
> +static inline void kvm_own_lsx(struct kvm_vcpu *vcpu) { }
> +static inline void kvm_save_lsx(struct loongarch_fpu *fpu) { }
> +static inline void kvm_restore_lsx(struct loongarch_fpu *fpu) { }
> +static inline void kvm_restore_lsx_upper(struct loongarch_fpu *fpu) { }
> +#endif
> +
>   void kvm_acquire_timer(struct kvm_vcpu *vcpu);
>   void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long hz);
>   void kvm_reset_timer(struct kvm_vcpu *vcpu);
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index ce8de3fa47..1b1c58ccc8 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -659,6 +659,23 @@ static int kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu)
>   	return RESUME_GUEST;
>   }
>   
> +/*
> + * kvm_handle_lsx_disabled() - Guest used LSX while disabled in root.
> + * @vcpu:      Virtual CPU context.
> + *
> + * Handle when the guest attempts to use LSX when it is disabled in the root
> + * context.
> + */
> +static int kvm_handle_lsx_disabled(struct kvm_vcpu *vcpu)
> +{
> +	if (!kvm_guest_has_lsx(&vcpu->arch))
> +		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
> +	else
> +		kvm_own_lsx(vcpu);
> +
> +	return RESUME_GUEST;
> +}
> +
>   /*
>    * LoongArch KVM callback handling for unimplemented guest exiting
>    */
> @@ -687,6 +704,7 @@ static exit_handle_fn kvm_fault_tables[EXCCODE_INT_START] = {
>   	[EXCCODE_TLBS]			= kvm_handle_write_fault,
>   	[EXCCODE_TLBM]			= kvm_handle_write_fault,
>   	[EXCCODE_FPDIS]			= kvm_handle_fpu_disabled,
> +	[EXCCODE_LSXDIS]                = kvm_handle_lsx_disabled,
>   	[EXCCODE_GSPR]			= kvm_handle_gspr,
>   };
>   
> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
> index 0ed9040307..32ba092a44 100644
> --- a/arch/loongarch/kvm/switch.S
> +++ b/arch/loongarch/kvm/switch.S
> @@ -245,6 +245,28 @@ SYM_FUNC_START(kvm_restore_fpu)
>   	jr                 ra
>   SYM_FUNC_END(kvm_restore_fpu)
>   
> +#ifdef CONFIG_CPU_HAS_LSX
> +SYM_FUNC_START(kvm_save_lsx)
> +	fpu_save_csr    a0 t1
> +	fpu_save_cc     a0 t1 t2
> +	lsx_save_data   a0 t1
> +	jirl            zero, ra, 0
> +SYM_FUNC_END(kvm_save_lsx)
> +
> +SYM_FUNC_START(kvm_restore_lsx)
> +	lsx_restore_data a0 t1
> +	fpu_restore_cc   a0 t1 t2
> +	fpu_restore_csr  a0 t1
> +	jirl             zero, ra, 0
> +SYM_FUNC_END(kvm_restore_lsx)
> +
> +SYM_FUNC_START(kvm_restore_lsx_upper)
> +	lsx_restore_all_upper a0 t0 t1
> +
> +	jirl                  zero, ra, 0
> +SYM_FUNC_END(kvm_restore_lsx_upper)
> +#endif
> +
>   	.section ".rodata"
>   SYM_DATA(kvm_exception_size, .quad kvm_exc_entry_end - kvm_exc_entry)
>   SYM_DATA(kvm_enter_guest_size, .quad kvm_enter_guest_end - kvm_enter_guest)
> diff --git a/arch/loongarch/kvm/trace.h b/arch/loongarch/kvm/trace.h
> index a1e35d6554..7da4e230e8 100644
> --- a/arch/loongarch/kvm/trace.h
> +++ b/arch/loongarch/kvm/trace.h
> @@ -102,6 +102,7 @@ TRACE_EVENT(kvm_exit_gspr,
>   #define KVM_TRACE_AUX_DISCARD		4
>   
>   #define KVM_TRACE_AUX_FPU		1
> +#define KVM_TRACE_AUX_LSX		2
>   
>   #define kvm_trace_symbol_aux_op				\
>   	{ KVM_TRACE_AUX_SAVE,		"save" },	\
> @@ -111,7 +112,8 @@ TRACE_EVENT(kvm_exit_gspr,
>   	{ KVM_TRACE_AUX_DISCARD,	"discard" }
>   
>   #define kvm_trace_symbol_aux_state			\
> -	{ KVM_TRACE_AUX_FPU,     "FPU" }
> +	{ KVM_TRACE_AUX_FPU,     "FPU" },		\
> +	{ KVM_TRACE_AUX_LSX,     "LSX" }
>   
>   TRACE_EVENT(kvm_aux,
>   	    TP_PROTO(struct kvm_vcpu *vcpu, unsigned int op,
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 73d0c2b9c1..f0bb583353 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -378,9 +378,13 @@ static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
>   		break;
>   	case KVM_REG_LOONGARCH_CPUCFG:
>   		id = KVM_GET_IOC_CPUCFG_IDX(reg->id);
> -		if (id >= 0 && id < KVM_MAX_CPUCFG_REGS)
> +		if (id >= 0 && id < KVM_MAX_CPUCFG_REGS) {
>   			vcpu->arch.cpucfg[id] = (u32)v;
> -		else
> +			if (id == 2 && v & CPUCFG2_LSX && !cpu_has_lsx) {
Hi Tianrui,

Can you add some annotations about these piece of codes? so that
people can understand easily.

And do we need interface to get host capabilities to user application?
Such as QEMU first gets supported capabilities from kvm and then sets 
the required ones.

Regards
Bibo Mao
> +				vcpu->arch.cpucfg[id] &= ~CPUCFG2_LSX;
> +				ret = -EINVAL;
> +			}
> +		} else
>   			ret = -EINVAL;
>   		break;
>   	case KVM_REG_LOONGARCH_KVM:
> @@ -561,12 +565,49 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
>   	preempt_enable();
>   }
>   
> +#ifdef CONFIG_CPU_HAS_LSX
> +/* Enable LSX for guest and restore context */
> +void kvm_own_lsx(struct kvm_vcpu *vcpu)
> +{
> +	preempt_disable();
> +
> +	/* Enable LSX for guest */
> +	set_csr_euen(CSR_EUEN_LSXEN | CSR_EUEN_FPEN);
> +	switch (vcpu->arch.aux_inuse & KVM_LARCH_FPU) {
> +	case KVM_LARCH_FPU:
> +		/*
> +		 * Guest FPU state already loaded,
> +		 * only restore upper LSX state
> +		 */
> +		kvm_restore_lsx_upper(&vcpu->arch.fpu);
> +		break;
> +	default:
> +		/* Neither FP or LSX already active,
> +		 * restore full LSX state
> +		 */
> +		kvm_restore_lsx(&vcpu->arch.fpu);
> +	break;
> +	}
> +
> +	trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LSX);
> +	vcpu->arch.aux_inuse |= KVM_LARCH_LSX | KVM_LARCH_FPU;
> +	preempt_enable();
> +}
> +#endif
> +
>   /* Save context and disable FPU */
>   void kvm_lose_fpu(struct kvm_vcpu *vcpu)
>   {
>   	preempt_disable();
>   
> -	if (vcpu->arch.aux_inuse & KVM_LARCH_FPU) {
> +	if (vcpu->arch.aux_inuse & KVM_LARCH_LSX) {
> +		kvm_save_lsx(&vcpu->arch.fpu);
> +		vcpu->arch.aux_inuse &= ~(KVM_LARCH_LSX | KVM_LARCH_FPU);
> +		trace_kvm_aux(vcpu, KVM_TRACE_AUX_SAVE, KVM_TRACE_AUX_LSX);
> +
> +		/* Disable LSX & FPU */
> +		clear_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN);
> +	} else if (vcpu->arch.aux_inuse & KVM_LARCH_FPU) {
>   		kvm_save_fpu(&vcpu->arch.fpu);
>   		vcpu->arch.aux_inuse &= ~KVM_LARCH_FPU;
>   		trace_kvm_aux(vcpu, KVM_TRACE_AUX_SAVE, KVM_TRACE_AUX_FPU);
> 


