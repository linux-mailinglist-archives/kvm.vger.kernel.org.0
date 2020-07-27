Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10E822E934
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 11:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgG0Jjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 05:39:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41469 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726139AbgG0Jjc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 05:39:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595842769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=39tfQVO6MtMloI5k4q20czF8oW2Itekezek2bLxuhvw=;
        b=fBbFHjlsIoCWuZnxODiomrZxeFbB+mvgKi4F4+hWhHT4zjMlrBoIbCnaqMBGSFv0HY1G2R
        ThaOzg1TvpJ+d9gZMoXKPC745hYlydxFH/9WMaxFoZ9ufFu+seQTRyhAZqCfS3FVL85SeR
        FU/9u6PQg1uQLE0lG2xq8+H+wLTEszA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-m60pOdz1MBKpw8zbox3g4Q-1; Mon, 27 Jul 2020 05:39:25 -0400
X-MC-Unique: m60pOdz1MBKpw8zbox3g4Q-1
Received: by mail-ed1-f72.google.com with SMTP id p26so1795516edt.11
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 02:39:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=39tfQVO6MtMloI5k4q20czF8oW2Itekezek2bLxuhvw=;
        b=iwUvOrUgOmQDz7uJkZqHhl0jyDwbxLDtykY3iBukkiNXTEs/Xu6M7hRQ7F38BBUuds
         lCxspHkIN9z3mPrpOBr7PhpiryietHEwE8eG5GAovbYN3XPE3s1tNKa0Zc/pvMhgeo6f
         yEUNgJwiw9y9fvCpWcNvm1uIuOU0NX6ZV8KLv/x+vMui8D0Jpup4R0WdB9DjK0jRpjOM
         Dn5CI2d69qZ+3qu6MtXz1plgn5KBAkQWd5R7OcyCcEwADkvkrSq5os7CdKo9qHVl0EXj
         HJ98a5mpCAf1/ovO+3inEDNOvDIgJU2YB/50kWrrdypUVvda6d3/zuzpMNTGtmUaL7XX
         +QFQ==
X-Gm-Message-State: AOAM5329dBybtbEByDR9w4tEotecBmy6LaWATHREaqcGcapGoad26lQH
        m/hrPS3B2+88yxFeBjC8HTY48prBJwpKbZYAWfOS49cEokrUrpFDOzbfYh7juyUvbPpKRRqzFwE
        UYHqCiUWoyYx8
X-Received: by 2002:a17:906:a204:: with SMTP id r4mr12772272ejy.552.1595842763933;
        Mon, 27 Jul 2020 02:39:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEd8wS4oTDee5b7RQTVP1H3JTLiouM4aOzZsj+Knz9uaHZw3fIvtq/BYsJuLKADVJX6Mz50w==
X-Received: by 2002:a17:906:a204:: with SMTP id r4mr12772258ejy.552.1595842763661;
        Mon, 27 Jul 2020 02:39:23 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id s2sm356599ejh.95.2020.07.27.02.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 02:39:23 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com
Subject: Re: [PATCH 1/5 v2] KVM: x86: Change names of some of the kvm_x86_ops functions to make them more semantical and readable
In-Reply-To: <1595647598-53208-2-git-send-email-krish.sadhukhan@oracle.com>
References: <1595647598-53208-1-git-send-email-krish.sadhukhan@oracle.com> <1595647598-53208-2-git-send-email-krish.sadhukhan@oracle.com>
Date:   Mon, 27 Jul 2020 11:39:22 +0200
Message-ID: <87wo2pmh4l.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Krish Sadhukhan <krish.sadhukhan@oracle.com> writes:

> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 12 ++++++------
>  arch/x86/kvm/svm/svm.c          | 12 ++++++------
>  arch/x86/kvm/vmx/vmx.c          |  8 ++++----
>  arch/x86/kvm/x86.c              | 22 +++++++++++-----------
>  include/linux/kvm_host.h        |  2 +-
>  virt/kvm/kvm_main.c             |  4 ++--
>  6 files changed, 30 insertions(+), 30 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index be5363b..ccad66d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1080,7 +1080,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
>  struct kvm_x86_ops {
>  	int (*hardware_enable)(void);
>  	void (*hardware_disable)(void);
> -	void (*hardware_unsetup)(void);
> +	void (*hardware_teardown)(void);

I definitely welcome the change but we may want to fix other arches as
well:

 git grep hardware_unsetup HEAD

HEAD:arch/arm64/include/asm/kvm_host.h:static inline void kvm_arch_hardware_unsetup(void) {}
HEAD:arch/mips/include/asm/kvm_host.h:static inline void kvm_arch_hardware_unsetup(void) {}
HEAD:arch/powerpc/include/asm/kvm_host.h:static inline void kvm_arch_hardware_unsetup(void) {}
HEAD:arch/s390/kvm/kvm-s390.c:void kvm_arch_hardware_unsetup(void)

>  	bool (*cpu_has_accelerated_tpr)(void);
>  	bool (*has_emulated_msr)(u32 index);
>  	void (*cpuid_update)(struct kvm_vcpu *vcpu);
> @@ -1141,7 +1141,7 @@ struct kvm_x86_ops {
>  	 */
>  	void (*tlb_flush_guest)(struct kvm_vcpu *vcpu);
>  
> -	enum exit_fastpath_completion (*run)(struct kvm_vcpu *vcpu);
> +	enum exit_fastpath_completion (*vcpu_run)(struct kvm_vcpu *vcpu);
>  	int (*handle_exit)(struct kvm_vcpu *vcpu,
>  		enum exit_fastpath_completion exit_fastpath);
>  	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
> @@ -1150,8 +1150,8 @@ struct kvm_x86_ops {
>  	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
>  	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
>  				unsigned char *hypercall_addr);
> -	void (*set_irq)(struct kvm_vcpu *vcpu);
> -	void (*set_nmi)(struct kvm_vcpu *vcpu);
> +	void (*inject_irq)(struct kvm_vcpu *vcpu);
> +	void (*inject_nmi)(struct kvm_vcpu *vcpu);
>  	void (*queue_exception)(struct kvm_vcpu *vcpu);
>  	void (*cancel_injection)(struct kvm_vcpu *vcpu);
>  	int (*interrupt_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
> @@ -1258,8 +1258,8 @@ struct kvm_x86_ops {
>  	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
>  
>  	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
> -	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> -	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> +	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> +	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);

These two should probably pair with 

KVM_MEMORY_ENCRYPT_REG_REGION
KVM_MEMORY_ENCRYPT_UNREG_REGION

shortening "memory" as "mem" and "encrypt" as "enc" is probably OK
because I can't think of any other meaning but shortening "register" as
"reg" may be percieved as CPU register.

What if we change ioctls too:
KVM_MEM_ENC_REGISTER_REGION
KVM_MEM_ENC_UNREGISTER_REGION

to make this all consistent?

>  
>  	int (*get_msr_feature)(struct kvm_msr_entry *entry);
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c0da4dd..24755eb 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3969,7 +3969,7 @@ static int svm_vm_init(struct kvm *kvm)
>  }
>  
>  static struct kvm_x86_ops svm_x86_ops __initdata = {
> -	.hardware_unsetup = svm_hardware_teardown,
> +	.hardware_teardown = svm_hardware_teardown,
>  	.hardware_enable = svm_hardware_enable,
>  	.hardware_disable = svm_hardware_disable,
>  	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
> @@ -4016,15 +4016,15 @@ static int svm_vm_init(struct kvm *kvm)
>  	.tlb_flush_gva = svm_flush_tlb_gva,
>  	.tlb_flush_guest = svm_flush_tlb,
>  
> -	.run = svm_vcpu_run,
> +	.vcpu_run = svm_vcpu_run,
>  	.handle_exit = handle_exit,
>  	.skip_emulated_instruction = skip_emulated_instruction,
>  	.update_emulated_instruction = NULL,
>  	.set_interrupt_shadow = svm_set_interrupt_shadow,
>  	.get_interrupt_shadow = svm_get_interrupt_shadow,
>  	.patch_hypercall = svm_patch_hypercall,
> -	.set_irq = svm_set_irq,
> -	.set_nmi = svm_inject_nmi,
> +	.inject_irq = svm_set_irq,
> +	.inject_nmi = svm_inject_nmi,
>  	.queue_exception = svm_queue_exception,
>  	.cancel_injection = svm_cancel_injection,
>  	.interrupt_allowed = svm_interrupt_allowed,
> @@ -4080,8 +4080,8 @@ static int svm_vm_init(struct kvm *kvm)
>  	.enable_smi_window = enable_smi_window,
>  
>  	.mem_enc_op = svm_mem_enc_op,
> -	.mem_enc_reg_region = svm_register_enc_region,
> -	.mem_enc_unreg_region = svm_unregister_enc_region,
> +	.mem_enc_register_region = svm_register_enc_region,
> +	.mem_enc_unregister_region = svm_unregister_enc_region,
>  
>  	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cb22f33..90d91524 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7844,7 +7844,7 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
>  }
>  
>  static struct kvm_x86_ops vmx_x86_ops __initdata = {
> -	.hardware_unsetup = hardware_unsetup,
> +	.hardware_teardown = hardware_unsetup,
>  
>  	.hardware_enable = hardware_enable,
>  	.hardware_disable = hardware_disable,
> @@ -7889,15 +7889,15 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
>  	.tlb_flush_gva = vmx_flush_tlb_gva,
>  	.tlb_flush_guest = vmx_flush_tlb_guest,
>  
> -	.run = vmx_vcpu_run,
> +	.vcpu_run = vmx_vcpu_run,
>  	.handle_exit = vmx_handle_exit,
>  	.skip_emulated_instruction = vmx_skip_emulated_instruction,
>  	.update_emulated_instruction = vmx_update_emulated_instruction,
>  	.set_interrupt_shadow = vmx_set_interrupt_shadow,
>  	.get_interrupt_shadow = vmx_get_interrupt_shadow,
>  	.patch_hypercall = vmx_patch_hypercall,
> -	.set_irq = vmx_inject_irq,
> -	.set_nmi = vmx_inject_nmi,
> +	.inject_irq = vmx_inject_irq,
> +	.inject_nmi = vmx_inject_nmi,
>  	.queue_exception = vmx_queue_exception,
>  	.cancel_injection = vmx_cancel_injection,
>  	.interrupt_allowed = vmx_interrupt_allowed,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3b92db4..e850fb3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5270,8 +5270,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  			goto out;
>  
>  		r = -ENOTTY;
> -		if (kvm_x86_ops.mem_enc_reg_region)
> -			r = kvm_x86_ops.mem_enc_reg_region(kvm, &region);
> +		if (kvm_x86_ops.mem_enc_register_region)
> +			r = kvm_x86_ops.mem_enc_register_region(kvm, &region);
>  		break;
>  	}
>  	case KVM_MEMORY_ENCRYPT_UNREG_REGION: {
> @@ -5282,8 +5282,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  			goto out;
>  
>  		r = -ENOTTY;
> -		if (kvm_x86_ops.mem_enc_unreg_region)
> -			r = kvm_x86_ops.mem_enc_unreg_region(kvm, &region);
> +		if (kvm_x86_ops.mem_enc_unregister_region)
> +			r = kvm_x86_ops.mem_enc_unregister_region(kvm, &region);
>  		break;
>  	}
>  	case KVM_HYPERV_EVENTFD: {
> @@ -7788,10 +7788,10 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
>  	 */
>  	else if (!vcpu->arch.exception.pending) {
>  		if (vcpu->arch.nmi_injected) {
> -			kvm_x86_ops.set_nmi(vcpu);
> +			kvm_x86_ops.inject_nmi(vcpu);
>  			can_inject = false;
>  		} else if (vcpu->arch.interrupt.injected) {
> -			kvm_x86_ops.set_irq(vcpu);
> +			kvm_x86_ops.inject_irq(vcpu);
>  			can_inject = false;
>  		}
>  	}
> @@ -7867,7 +7867,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
>  		if (r) {
>  			--vcpu->arch.nmi_pending;
>  			vcpu->arch.nmi_injected = true;
> -			kvm_x86_ops.set_nmi(vcpu);
> +			kvm_x86_ops.inject_nmi(vcpu);
>  			can_inject = false;
>  			WARN_ON(kvm_x86_ops.nmi_allowed(vcpu, true) < 0);
>  		}
> @@ -7881,7 +7881,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
>  			goto busy;
>  		if (r) {
>  			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
> -			kvm_x86_ops.set_irq(vcpu);
> +			kvm_x86_ops.inject_irq(vcpu);
>  			WARN_ON(kvm_x86_ops.interrupt_allowed(vcpu, true) < 0);
>  		}
>  		if (kvm_cpu_has_injectable_intr(vcpu))
> @@ -8517,7 +8517,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
>  	}
>  
> -	exit_fastpath = kvm_x86_ops.run(vcpu);
> +	exit_fastpath = kvm_x86_ops.vcpu_run(vcpu);
>  
>  	/*
>  	 * Do this here before restoring debug registers on the host.  And
> @@ -9793,9 +9793,9 @@ int kvm_arch_hardware_setup(void *opaque)
>  	return 0;
>  }
>  
> -void kvm_arch_hardware_unsetup(void)
> +void kvm_arch_hardware_teardown(void)
>  {
> -	kvm_x86_ops.hardware_unsetup();
> +	kvm_x86_ops.hardware_teardown();
>  }
>  
>  int kvm_arch_check_processor_compat(void *opaque)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d564855..b49312c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -894,7 +894,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  int kvm_arch_hardware_enable(void);
>  void kvm_arch_hardware_disable(void);
>  int kvm_arch_hardware_setup(void *opaque);
> -void kvm_arch_hardware_unsetup(void);
> +void kvm_arch_hardware_teardown(void);
>  int kvm_arch_check_processor_compat(void *opaque);
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
>  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a852af5..4625f3a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4786,7 +4786,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  	unregister_reboot_notifier(&kvm_reboot_notifier);
>  	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
>  out_free_2:
> -	kvm_arch_hardware_unsetup();
> +	kvm_arch_hardware_teardown();
>  out_free_1:
>  	free_cpumask_var(cpus_hardware_enabled);
>  out_free_0:
> @@ -4808,7 +4808,7 @@ void kvm_exit(void)
>  	unregister_reboot_notifier(&kvm_reboot_notifier);
>  	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
>  	on_each_cpu(hardware_disable_nolock, NULL, 1);
> -	kvm_arch_hardware_unsetup();
> +	kvm_arch_hardware_teardown();

And this probably means we'll have to take care of non-x86 arches after
all.

>  	kvm_arch_exit();
>  	kvm_irqfd_exit();
>  	free_cpumask_var(cpus_hardware_enabled);

-- 
Vitaly

