Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8585ECBD1
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 19:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbiI0R7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 13:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbiI0R7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 13:59:12 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1EA1DADF3
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 10:59:08 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id b75so10351310pfb.7
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 10:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ZC2aoQPBCdT6jnCFsUc+AVvhDPcTlahAhyvfiSa1bLg=;
        b=KDuVEbq6H+6sBcvhE0e6G8l4lIQAkTL43DznFPxMN+rNSdtlrSk/NOLd3sxES5pT2E
         FbK3vnsUqfMeZKYKxz/5durVhckp4zlTFLyWqPVnS678yF+DMQYmi58BYeI9kpMNef2Z
         XHwq/vI8xu0xoq6SZfUEefPi/ekLx72iK7ffmQvo4nJV5WHSSOkXpzo/iUkM4/8Js/XC
         7ROJEhl2iufS6FZBuPHGnlL4MXQeOMKN4O1vZl9OS59MsJ1cDFEPJX0I/cBlmsRW+JZl
         nVd3LpQO36s63jLHxdMbVNx4BBHBuQck2kWDHmclTc1BUmyjURhpFxvBFBcnBGWPma8X
         ZrOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ZC2aoQPBCdT6jnCFsUc+AVvhDPcTlahAhyvfiSa1bLg=;
        b=7kX4cAajA/IbUbokOFksL7UQShW8TlTIiLXJMN+jBeS1TwCDoO/Qy00leQY0h2NWgD
         QPH6tyCOwNPJi+JqSEnPmbwgHfDGBtqNoNS3T+k/Tq35r8jkoM+C7pqxWZq5WeOH09Br
         Anx/dkWPOqLjEm7EOqj8aF5l/867GC+L1rbiFcT8fu+g+frRvIrTvcEijOHDiMzyS76C
         0Xy66lQKGMaC9HPNSiSrV8361kwCLpG4AAAfpTl1ofei5oYOccc4JzpcnkOX5BfYedz6
         K7nCEj5VZ3scaFQYwmQsFif1cgfB7nwYLTSuJf7grCrwQFtpCVv7cit+vA3NHbdor1cz
         fcUQ==
X-Gm-Message-State: ACrzQf0EFOKtQY4uL9JfunmFycBiE3u5DwIjX6hqvRGzD7JqGCDTLuTM
        evJWQSbtkuzC9zMAWEKkuMFHPaDiLalFiQ==
X-Google-Smtp-Source: AMsMyM5n5m+rYSngEj0lC52NCYuusIzD3QwRvvKTd1XqjMAH7FxW+tOhRTgSleyLamQiZjp3Xqx2cg==
X-Received: by 2002:a63:3409:0:b0:438:c9c9:5582 with SMTP id b9-20020a633409000000b00438c9c95582mr24964179pga.69.1664301547725;
        Tue, 27 Sep 2022 10:59:07 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d13-20020a170903230d00b00172d0c7edf4sm1874446plh.106.2022.09.27.10.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 10:59:06 -0700 (PDT)
Date:   Tue, 27 Sep 2022 17:59:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: allow compiling out SMM support
Message-ID: <YzM55hqavzENQq7I@google.com>
References: <20220927152241.194900-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927152241.194900-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 27, 2022, Paolo Bonzini wrote:
> Some users of KVM implement the UEFI variable store through a paravirtual device
> that does not require the "SMM lockbox" component of edk2; allow them to
> compile out system management mode, which is not a full implementation
> especially in how it interacts with nested virtualization.

Woot, thanks!

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	The patch isn't pretty.  I could skip all the changes to add WARNs
> 	to called functions, but the point of adding the config symbol is
> 	to make sure that those functions, and all the baggage they bring,
> 	are dead.

I would much rather we go even further and completely kill off those functions
at compile time.

There are side effects that should also be eliminated, e.g. x86 should not define
__KVM_VCPU_MULTIPLE_ADDRESS_SPACE so that usersepace can't create memslots for
SMM.  Dropping the functions entirely wrapping those #defines in #ifdef as well,
and so makes it all but impossible for KVM to do anything SMM related.

Eliminating those at compile time requires a bit more #ifdeffery, but it's not
awful, and IMO it's better than sprinkling WARNs in a bunch of paths.  KVM_REQ_SMI
in particular might be going too far, but even for that one I vote to kill it.

As follow-up, we could even #ifdef out arch.smi_pending by moving that to a helper,
though that's probably overkill. 

> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index d7639d126e6c..d2d08a202b75 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1171,8 +1171,10 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
>  
>  	case APIC_DM_SMI:
>  		result = 1;

This should return '0', i.e. not touch result, to communicate to the caller that
the event was dropped.

> +#ifdef CONFIG_KVM_SMM
>  		kvm_make_request(KVM_REQ_SMI, vcpu);
>  		kvm_vcpu_kick(vcpu);
> +#endif
>  		break;
>  
>  	case APIC_DM_NMI:

...

> @@ -4885,8 +4888,8 @@ static int kvm_vcpu_ioctl_nmi(struct kvm_vcpu *vcpu)
>  
>  static int kvm_vcpu_ioctl_smi(struct kvm_vcpu *vcpu)
>  {
> -	kvm_make_request(KVM_REQ_SMI, vcpu);
> -
> +	if (IS_ENABLED(CONFIG_KVM_SMM))
> +		kvm_make_request(KVM_REQ_SMI, vcpu);
>  	return 0;

This should return -EINVAL, not 0.

Compile tested only.

---
 arch/x86/include/asm/kvm-x86-ops.h            |  2 +
 arch/x86/include/asm/kvm_host.h               |  9 +++
 arch/x86/kvm/Kconfig                          | 11 ++++
 arch/x86/kvm/emulate.c                        |  4 ++
 arch/x86/kvm/kvm_cache_regs.h                 |  4 ++
 arch/x86/kvm/kvm_emulate.h                    |  4 ++
 arch/x86/kvm/lapic.c                          |  2 +
 arch/x86/kvm/svm/nested.c                     |  2 +
 arch/x86/kvm/svm/svm.c                        |  6 ++
 arch/x86/kvm/vmx/vmx.c                        |  6 ++
 arch/x86/kvm/x86.c                            | 57 ++++++++++++++++---
 tools/testing/selftests/kvm/x86_64/smm_test.c |  2 +
 12 files changed, 101 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 82ba4a564e58..ea58e67e9a67 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -110,10 +110,12 @@ KVM_X86_OP_OPTIONAL_RET0(dy_apicv_has_pending_interrupt)
 KVM_X86_OP_OPTIONAL(set_hv_timer)
 KVM_X86_OP_OPTIONAL(cancel_hv_timer)
 KVM_X86_OP(setup_mce)
+#ifdef CONFIG_KVM_SMM
 KVM_X86_OP(smi_allowed)
 KVM_X86_OP(enter_smm)
 KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
+#endif
 KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d40206b16d6c..c785e7346486 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -81,7 +81,9 @@
 #define KVM_REQ_NMI			KVM_ARCH_REQ(9)
 #define KVM_REQ_PMU			KVM_ARCH_REQ(10)
 #define KVM_REQ_PMI			KVM_ARCH_REQ(11)
+#ifdef CONFIG_KVM_SMM
 #define KVM_REQ_SMI			KVM_ARCH_REQ(12)
+#endif
 #define KVM_REQ_MASTERCLOCK_UPDATE	KVM_ARCH_REQ(13)
 #define KVM_REQ_MCLOCK_INPROGRESS \
 	KVM_ARCH_REQ_FLAGS(14, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
@@ -1606,10 +1608,12 @@ struct kvm_x86_ops {
 
 	void (*setup_mce)(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_KVM_SMM
 	int (*smi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
 	int (*enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
 	int (*leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
+#endif
 
 	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
 	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
@@ -1988,6 +1992,8 @@ enum {
 #define HF_NMI_MASK		(1 << 3)
 #define HF_IRET_MASK		(1 << 4)
 #define HF_GUEST_MASK		(1 << 5) /* VCPU is in guest-mode */
+
+#ifdef CONFIG_KVM_SMM
 #define HF_SMM_MASK		(1 << 6)
 #define HF_SMM_INSIDE_NMI_MASK	(1 << 7)
 
@@ -1996,6 +2002,9 @@ enum {
 
 #define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
 #define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
+#else
+#define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, 0);
+#endif
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index e3cbd7706136..20d5aea868a4 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -86,6 +86,17 @@ config KVM_INTEL
 	  To compile this as a module, choose M here: the module
 	  will be called kvm-intel.
 
+config KVM_SMM
+	bool "System Management Mode emulation"
+	default y
+	depends on KVM
+	help
+	  Provides support for KVM to emulate System Management Mode (SMM)
+	  in virtual machines.  This can be used by the virtual machine
+	  firmware to implement UEFI secure boot.
+
+	  If unsure, say Y.
+
 config X86_SGX_KVM
 	bool "Software Guard eXtensions (SGX) Virtualization"
 	depends on X86_SGX && KVM_INTEL
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index b6180032dfd6..27c241c8e265 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2309,6 +2309,7 @@ static int em_lseg(struct x86_emulate_ctxt *ctxt)
 	return rc;
 }
 
+#ifdef CONFIG_KVM_SMM
 static int emulator_has_longmode(struct x86_emulate_ctxt *ctxt)
 {
 #ifdef CONFIG_X86_64
@@ -2639,6 +2640,7 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)
 	ctxt->ops->triple_fault(ctxt);
 	return X86EMUL_CONTINUE;
 }
+#endif /* CONFIG_KVM_SMM */
 
 static void
 setup_syscalls_segments(struct desc_struct *cs, struct desc_struct *ss)
@@ -4756,7 +4758,9 @@ static const struct opcode twobyte_table[256] = {
 	F(DstMem | SrcReg | Src2CL | ModRM, em_shld), N, N,
 	/* 0xA8 - 0xAF */
 	I(Stack | Src2GS, em_push_sreg), I(Stack | Src2GS, em_pop_sreg),
+#ifdef CONFIG_KVM_SMM
 	II(EmulateOnUD | ImplicitOps, em_rsm, rsm),
+#endif
 	F(DstMem | SrcReg | ModRM | BitOp | Lock | PageTable, em_bts),
 	F(DstMem | SrcReg | Src2ImmByte | ModRM, em_shrd),
 	F(DstMem | SrcReg | Src2CL | ModRM, em_shrd),
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 3febc342360c..5eb66cf1b7a6 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -202,7 +202,11 @@ static inline bool is_guest_mode(struct kvm_vcpu *vcpu)
 
 static inline bool is_smm(struct kvm_vcpu *vcpu)
 {
+#ifdef CONFIG_KVM_SMM
 	return vcpu->arch.hflags & HF_SMM_MASK;
+#else
+	return false;
+#endif
 }
 
 #endif
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 89246446d6aa..67a528bb9306 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -234,8 +234,10 @@ struct x86_emulate_ops {
 	void (*set_nmi_mask)(struct x86_emulate_ctxt *ctxt, bool masked);
 
 	unsigned (*get_hflags)(struct x86_emulate_ctxt *ctxt);
+#ifdef CONFIG_KVM_SMM
 	void (*exiting_smm)(struct x86_emulate_ctxt *ctxt);
 	int (*leave_smm)(struct x86_emulate_ctxt *ctxt, const char *smstate);
+#endif
 	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
 };
@@ -291,8 +293,10 @@ enum x86emul_mode {
 
 /* These match some of the HF_* flags defined in kvm_host.h  */
 #define X86EMUL_GUEST_MASK           (1 << 5) /* VCPU is in guest-mode */
+#ifdef CONFIG_KVM_SMM
 #define X86EMUL_SMM_MASK             (1 << 6)
 #define X86EMUL_SMM_INSIDE_NMI_MASK  (1 << 7)
+#endif
 
 /*
  * fastop functions are declared as taking a never-defined fastop parameter,
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d7639d126e6c..3e56c55e9198 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1170,9 +1170,11 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 		break;
 
 	case APIC_DM_SMI:
+#ifdef CONFIG_KVM_SMM
 		result = 1;
 		kvm_make_request(KVM_REQ_SMI, vcpu);
 		kvm_vcpu_kick(vcpu);
+#endif
 		break;
 
 	case APIC_DM_NMI:
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 4c620999d230..e865e7c10c59 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1377,6 +1377,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
+#ifdef CONFIG_KVM_SMM
 	if (vcpu->arch.smi_pending && !svm_smi_blocked(vcpu)) {
 		if (block_nested_events)
 			return -EBUSY;
@@ -1385,6 +1386,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 		nested_svm_simple_vmexit(svm, SVM_EXIT_SMI);
 		return 0;
 	}
+#endif
 
 	if (vcpu->arch.nmi_pending && !svm_nmi_blocked(vcpu)) {
 		if (block_nested_events)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58f0077d9357..7423a2b2c076 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4149,6 +4149,8 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
 		return false;
 	case MSR_IA32_SMBASE:
+		if (!IS_ENABLED(CONFIG_KVM_SMM))
+			return false;
 		/* SEV-ES guests do not support SMM, so report false */
 		if (kvm && sev_es_guest(kvm))
 			return false;
@@ -4405,6 +4407,7 @@ static void svm_setup_mce(struct kvm_vcpu *vcpu)
 	vcpu->arch.mcg_cap &= 0x1ff;
 }
 
+#ifdef CONFIG_KVM_SMM
 bool svm_smi_blocked(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4554,6 +4557,7 @@ static void svm_enable_smi_window(struct kvm_vcpu *vcpu)
 		/* We must be in SMM; RSM will cause a vmexit anyway.  */
 	}
 }
+#endif /* CONFIG_KVM_SMM */
 
 static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 					void *insn, int insn_len)
@@ -4829,10 +4833,12 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.pi_update_irte = avic_pi_update_irte,
 	.setup_mce = svm_setup_mce,
 
+#ifdef CONFIG_KVM_SMM
 	.smi_allowed = svm_smi_allowed,
 	.enter_smm = svm_enter_smm,
 	.leave_smm = svm_leave_smm,
 	.enable_smi_window = svm_enable_smi_window,
+#endif
 
 	.mem_enc_ioctl = sev_mem_enc_ioctl,
 	.mem_enc_register_region = sev_mem_enc_register_region,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9dba04b6b019..c265ca5fb81b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6840,6 +6840,8 @@ static bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
 {
 	switch (index) {
 	case MSR_IA32_SMBASE:
+		if (!IS_ENABLED(CONFIG_KVM_SMM))
+			return false;
 		/*
 		 * We cannot do SMM unless we can run the guest in big
 		 * real mode.
@@ -7902,6 +7904,7 @@ static void vmx_setup_mce(struct kvm_vcpu *vcpu)
 			~FEAT_CTL_LMCE_ENABLED;
 }
 
+#ifdef CONFIG_KVM_SMM
 static int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	/* we need a nested vmexit to enter SMM, postpone if run is pending */
@@ -7956,6 +7959,7 @@ static void vmx_enable_smi_window(struct kvm_vcpu *vcpu)
 {
 	/* RSM will cause a vmexit anyway.  */
 }
+#endif /* CONFIG_KVM_SMM */
 
 static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 {
@@ -8123,10 +8127,12 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.setup_mce = vmx_setup_mce,
 
+#ifdef CONFIG_KVM_SMM
 	.smi_allowed = vmx_smi_allowed,
 	.enter_smm = vmx_enter_smm,
 	.leave_smm = vmx_leave_smm,
 	.enable_smi_window = vmx_enable_smi_window,
+#endif
 
 	.can_emulate_instruction = vmx_can_emulate_instruction,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb9d2c23fb04..eb412f9f03ea 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -119,8 +119,11 @@ static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
+#ifdef CONFIG_KVM_SMM
+static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm);
 static void process_smi(struct kvm_vcpu *vcpu);
 static void enter_smm(struct kvm_vcpu *vcpu);
+#endif
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 static void store_regs(struct kvm_vcpu *vcpu);
 static int sync_regs(struct kvm_vcpu *vcpu);
@@ -3637,7 +3640,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	}
 	case MSR_IA32_SMBASE:
-		if (!msr_info->host_initiated)
+		if (!IS_ENABLED(CONFIG_KVM_SMM) || !msr_info->host_initiated)
 			return 1;
 		vcpu->arch.smbase = data;
 		break;
@@ -4053,7 +4056,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vcpu->arch.ia32_misc_enable_msr;
 		break;
 	case MSR_IA32_SMBASE:
-		if (!msr_info->host_initiated)
+		if (!IS_ENABLED(CONFIG_KVM_SMM) || !msr_info->host_initiated)
 			return 1;
 		msr_info->data = vcpu->arch.smbase;
 		break;
@@ -4427,6 +4430,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 			r |= KVM_X86_DISABLE_EXITS_MWAIT;
 		break;
 	case KVM_CAP_X86_SMM:
+		if (!IS_ENABLED(CONFIG_KVM_SMM))
+			break;
+
 		/* SMBASE is usually relocated above 1M on modern chipsets,
 		 * and SMM handlers might indeed rely on 4G segment limits,
 		 * so do not report SMM to be available if real mode is
@@ -4885,9 +4891,13 @@ static int kvm_vcpu_ioctl_nmi(struct kvm_vcpu *vcpu)
 
 static int kvm_vcpu_ioctl_smi(struct kvm_vcpu *vcpu)
 {
+#ifdef CONFIG_KVM_SMM
 	kvm_make_request(KVM_REQ_SMI, vcpu);
 
 	return 0;
+#else
+	return -EINVAL;
+#endif
 }
 
 static int vcpu_ioctl_tpr_access_reporting(struct kvm_vcpu *vcpu,
@@ -5025,8 +5035,10 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 
 	process_nmi(vcpu);
 
+#ifdef CONFIG_KVM_SMM
 	if (kvm_check_request(KVM_REQ_SMI, vcpu))
 		process_smi(vcpu);
+#endif
 
 	/*
 	 * KVM's ABI only allows for one exception to be migrated.  Luckily,
@@ -5093,10 +5105,14 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 
 	events->sipi_vector = 0; /* never valid when reporting to user space */
 
+#ifdef CONFIG_KVM_SMM
 	events->smi.smm = is_smm(vcpu);
 	events->smi.pending = vcpu->arch.smi_pending;
 	events->smi.smm_inside_nmi =
 		!!(vcpu->arch.hflags & HF_SMM_INSIDE_NMI_MASK);
+#else
+	memset(&events->smi, 0, sizeof(events->smi));
+#endif
 	events->smi.latched_init = kvm_lapic_latched_init(vcpu);
 
 	events->flags = (KVM_VCPUEVENT_VALID_NMI_PENDING
@@ -5112,8 +5128,6 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	memset(&events->reserved, 0, sizeof(events->reserved));
 }
 
-static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm);
-
 static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 					      struct kvm_vcpu_events *events)
 {
@@ -5186,6 +5200,7 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 		vcpu->arch.apic->sipi_vector = events->sipi_vector;
 
 	if (events->flags & KVM_VCPUEVENT_VALID_SMM) {
+#ifdef CONFIG_KVM_SMM
 		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm) {
 			kvm_x86_ops.nested_ops->leave_nested(vcpu);
 			kvm_smm_changed(vcpu, events->smi.smm);
@@ -5199,7 +5214,16 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 			else
 				vcpu->arch.hflags &= ~HF_SMM_INSIDE_NMI_MASK;
 		}
+#else
+		if (events->smi.smm || events->smi.pending ||
+		    events->smi.smm_inside_nmi)
+			return -EINVAL;
+#endif
 
+		/*
+		 * Pending INITs are incorrectly bundled with SMM.  They aren't
+		 * unique to SMM and so are allowed regardless of SMM support.
+		 */
 		if (lapic_in_kernel(vcpu)) {
 			if (events->smi.latched_init)
 				set_bit(KVM_APIC_INIT, &vcpu->arch.apic->pending_events);
@@ -8105,6 +8129,7 @@ static unsigned emulator_get_hflags(struct x86_emulate_ctxt *ctxt)
 	return emul_to_vcpu(ctxt)->arch.hflags;
 }
 
+#ifdef CONFIG_KVM_SMM
 static void emulator_exiting_smm(struct x86_emulate_ctxt *ctxt)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
@@ -8117,6 +8142,7 @@ static int emulator_leave_smm(struct x86_emulate_ctxt *ctxt,
 {
 	return static_call(kvm_x86_leave_smm)(emul_to_vcpu(ctxt), smstate);
 }
+#endif
 
 static void emulator_triple_fault(struct x86_emulate_ctxt *ctxt)
 {
@@ -8181,8 +8207,10 @@ static const struct x86_emulate_ops emulate_ops = {
 	.guest_has_rdpid     = emulator_guest_has_rdpid,
 	.set_nmi_mask        = emulator_set_nmi_mask,
 	.get_hflags          = emulator_get_hflags,
+#ifdef CONFIG_KVM_SMM
 	.exiting_smm         = emulator_exiting_smm,
 	.leave_smm           = emulator_leave_smm,
+#endif
 	.triple_fault        = emulator_triple_fault,
 	.set_xcr             = emulator_set_xcr,
 };
@@ -8254,8 +8282,6 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 		     cs_db				? X86EMUL_MODE_PROT32 :
 							  X86EMUL_MODE_PROT16;
 	BUILD_BUG_ON(HF_GUEST_MASK != X86EMUL_GUEST_MASK);
-	BUILD_BUG_ON(HF_SMM_MASK != X86EMUL_SMM_MASK);
-	BUILD_BUG_ON(HF_SMM_INSIDE_NMI_MASK != X86EMUL_SMM_INSIDE_NMI_MASK);
 
 	ctxt->interruptibility = 0;
 	ctxt->have_exception = false;
@@ -8514,6 +8540,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 static int complete_emulated_mmio(struct kvm_vcpu *vcpu);
 static int complete_emulated_pio(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_KVM_SMM
 static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
 {
 	trace_kvm_smm_transition(vcpu->vcpu_id, vcpu->arch.smbase, entering_smm);
@@ -8536,6 +8563,7 @@ static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
 
 	kvm_mmu_reset_context(vcpu);
 }
+#endif
 
 static int kvm_vcpu_check_hw_bp(unsigned long addr, u32 type, u32 dr7,
 				unsigned long *db)
@@ -9926,6 +9954,7 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 	 * in order to make progress and get back here for another iteration.
 	 * The kvm_x86_ops hooks communicate this by returning -EBUSY.
 	 */
+#ifdef CONFIG_KVM_SMM
 	if (vcpu->arch.smi_pending) {
 		r = can_inject ? static_call(kvm_x86_smi_allowed)(vcpu, true) : -EBUSY;
 		if (r < 0)
@@ -9938,6 +9967,7 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 		} else
 			static_call(kvm_x86_enable_smi_window)(vcpu);
 	}
+#endif
 
 	if (vcpu->arch.nmi_pending) {
 		r = can_inject ? static_call(kvm_x86_nmi_allowed)(vcpu, true) : -EBUSY;
@@ -10000,6 +10030,7 @@ static void process_nmi(struct kvm_vcpu *vcpu)
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
 
+#ifdef CONFIG_KVM_SMM
 static u32 enter_smm_get_segment_flags(struct kvm_segment *seg)
 {
 	u32 flags = 0;
@@ -10162,6 +10193,9 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	unsigned long cr0;
 	char buf[512];
 
+	BUILD_BUG_ON(HF_SMM_MASK != X86EMUL_SMM_MASK);
+	BUILD_BUG_ON(HF_SMM_INSIDE_NMI_MASK != X86EMUL_SMM_INSIDE_NMI_MASK);
+
 	memset(buf, 0, 512);
 #ifdef CONFIG_X86_64
 	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
@@ -10239,6 +10273,7 @@ static void process_smi(struct kvm_vcpu *vcpu)
 	vcpu->arch.smi_pending = true;
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
+#endif
 
 void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
 				       unsigned long *vcpu_bitmap)
@@ -10495,8 +10530,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		}
 		if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
 			record_steal_time(vcpu);
+#ifdef CONFIG_KVM_SMM
 		if (kvm_check_request(KVM_REQ_SMI, vcpu))
 			process_smi(vcpu);
+#endif
 		if (kvm_check_request(KVM_REQ_NMI, vcpu))
 			process_nmi(vcpu);
 		if (kvm_check_request(KVM_REQ_PMU, vcpu))
@@ -12794,10 +12831,12 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	     static_call(kvm_x86_nmi_allowed)(vcpu, false)))
 		return true;
 
+#ifdef CONFIG_KVM_SMM
 	if (kvm_test_request(KVM_REQ_SMI, vcpu) ||
 	    (vcpu->arch.smi_pending &&
 	     static_call(kvm_x86_smi_allowed)(vcpu, false)))
 		return true;
+#endif
 
 	if (kvm_arch_interrupt_allowed(vcpu) &&
 	    (kvm_cpu_has_interrupt(vcpu) ||
@@ -12838,8 +12877,10 @@ bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
 		return true;
 
 	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
-		kvm_test_request(KVM_REQ_SMI, vcpu) ||
-		 kvm_test_request(KVM_REQ_EVENT, vcpu))
+#ifdef CONFIG_KVM_SMM
+	    kvm_test_request(KVM_REQ_SMI, vcpu) ||
+#endif
+	    kvm_test_request(KVM_REQ_EVENT, vcpu))
 		return true;
 
 	return kvm_arch_dy_has_pending_interrupt(vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index 1f136a81858e..cb38a478e1f6 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -137,6 +137,8 @@ int main(int argc, char *argv[])
 	struct kvm_x86_state *state;
 	int stage, stage_reported;
 
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_X86_SMM));
+
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 

base-commit: c59fb127583869350256656b7ed848c398bef879
-- 

