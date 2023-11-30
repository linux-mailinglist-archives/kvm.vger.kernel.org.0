Return-Path: <kvm+bounces-2828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 73D177FE603
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 02:31:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0247DB211A2
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 01:31:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40D566D24;
	Thu, 30 Nov 2023 01:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Iago0Nwu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820B4198
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 17:31:11 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-2859ab31b31so495897a91.2
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 17:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701307871; x=1701912671; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gg2L5gsFD+9s4hl0pMtih+KIpxYTNwuOj5uhIeuR3S4=;
        b=Iago0Nwuy1Oi2ymS5V4ElfPdJgaeDgb7+Qc8dywtnj1izLtsOLE8Jgsh9uAxnPVwK7
         tWJlDTmBiFrapzhy88JhVdf1JwOji5AqLDxShOPHXIKv9QQlKYH+ZLdqB3N8vgdk5nQ1
         jRhphMoMCtmTuXzV67dofIHHwQ0HJGc3+JVbLcuJ+5XF/Rvd1oepn8Qg9DA8YjfFlrG1
         7eR3PinPzVh5JHbtJbQ90xBYCCLbTSeO6TZP3T/cZNoQ68/yVu8Vbpn4GoAWZ/5Oqz7F
         5XhdrYKH3NTdhbLGXxxfXRCPzfElleou48jA7g50M23igrf24W8FWemJYYZoVZd3H+y7
         WITw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701307871; x=1701912671;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gg2L5gsFD+9s4hl0pMtih+KIpxYTNwuOj5uhIeuR3S4=;
        b=s6r7yq0JyKICJMR/6q9ppfdoY/kKL1E3MYsiXsysxmfOBFvQQbBsWn1546fP4L6cqm
         SN3xD6LaDjQnxAoc2zcU90JmqZsZ4ScWsGTSmjr6aFOP9eL12jvcwxR04rb2VfReWZjj
         jEKYIsaHSlLzowMGP1bF9r4Wj8lr/eKPLrDMRHWD7UWgLS4lLKgdrdIDbejsSsUo6s8K
         NlIkVrMeFgU7uhkdtZSQhuKeneuA3UB6De+4zqeOWTe9IPoNcoUDQI1t3zmBsGalbVaI
         TeXnL+eNC2H/26t7PKaRkLK84Me3KP9nzkFu7BSf9oT5gINdE4E/SdgPADD2ehLMO5WD
         mSFw==
X-Gm-Message-State: AOJu0YyJkwaxkOnfW1/zTnesFCEVFVgm+E7D8PQoSwh+AO0d7JeaDcXO
	dStvkKa9uVZw/7LaoJ3TP/WBjTR/QJw=
X-Google-Smtp-Source: AGHT+IEf54xAukPivH5tpowu00jPP0sWnfu+6RzFTXBIHH8UCfgEVawhe+PWswUWILRcgmfQ8Blksp9Mn7U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:a40a:b0:26d:2b05:4926 with SMTP id
 y10-20020a17090aa40a00b0026d2b054926mr4165886pjp.1.1701307871009; Wed, 29 Nov
 2023 17:31:11 -0800 (PST)
Date: Wed, 29 Nov 2023 17:31:09 -0800
In-Reply-To: <20231025152406.1879274-11-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231025152406.1879274-1-vkuznets@redhat.com> <20231025152406.1879274-11-vkuznets@redhat.com>
Message-ID: <ZWfl3ahamXPPoIGB@google.com>
Subject: Re: [PATCH 10/14] KVM: x86: Make Hyper-V emulation optional
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 25, 2023, Vitaly Kuznetsov wrote:
> Hyper-V emulation in KVM is a fairly big chunk and in some cases it may be
> desirable to not compile it in to reduce module sizes as well as the attack
> surface. Introduce CONFIG_KVM_HYPERV option to make it possible.
> 
> Note, there's room for further nVMX/nSVM code optimizations when
> !CONFIG_KVM_HYPERV, this will be done in follow-up patches.
> 
> Reorganize Makefile a bit so all CONFIG_HYPERV and CONFIG_KVM_HYPERV files
> are grouped together.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

...

> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index 8ea872401cd6..b97b875ad75f 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -11,32 +11,33 @@ include $(srctree)/virt/kvm/Makefile.kvm
>  
>  kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
>  			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
> -			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
> +			   debugfs.o mmu/mmu.o mmu/page_track.o \
>  			   mmu/spte.o
>  
> -ifdef CONFIG_HYPERV
> -kvm-y			+= kvm_onhyperv.o
> -endif
> -
>  kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
> +kvm-$(CONFIG_KVM_HYPERV) += hyperv.o
>  kvm-$(CONFIG_KVM_XEN)	+= xen.o
>  kvm-$(CONFIG_KVM_SMM)	+= smm.o
>  
>  kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
> -			   vmx/hyperv.o vmx/hyperv_evmcs.o vmx/nested.o vmx/posted_intr.o
> -kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
> +			   vmx/nested.o vmx/posted_intr.o
>  
> -ifdef CONFIG_HYPERV
> -kvm-intel-y		+= vmx/vmx_onhyperv.o
> -endif
> +kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
>  
>  kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
> -			   svm/sev.o svm/hyperv.o
> +			   svm/sev.o
>  
>  ifdef CONFIG_HYPERV
> +kvm-y			+= kvm_onhyperv.o
> +kvm-intel-y		+= vmx/vmx_onhyperv.o vmx/hyperv_evmcs.o
>  kvm-amd-y		+= svm/svm_onhyperv.o
>  endif
>  
> +ifdef CONFIG_KVM_HYPERV
> +kvm-intel-y		+= vmx/hyperv.o vmx/hyperv_evmcs.o
> +kvm-amd-y		+= svm/hyperv.o
> +endif

My strong preference is to avoid the unnecessary ifdef and instead do:

kvm-intel-y             += vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
                           vmx/nested.o vmx/posted_intr.o

kvm-intel-$(CONFIG_X86_SGX_KVM) += vmx/sgx.o
kvm-intel-$(CONFIG_KVM_HYPERV)  += vmx/hyperv.o vmx/hyperv_evmcs.o

kvm-amd-y               += svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
                           svm/sev.o
kvm-amd-$(CONFIG_KVM_HYPERV)    += svm/hyperv.o


CONFIG_HYPERV needs an ifdef because it can be 'y' or 'm', but otherwise ifdefs
just tend to be noisier.

>  static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>  {
> @@ -3552,11 +3563,13 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  	if (!nested_vmx_check_permission(vcpu))
>  		return 1;
>  
> +#ifdef CONFIG_KVM_HYPERV
>  	evmptrld_status = nested_vmx_handle_enlightened_vmptrld(vcpu, launch);
>  	if (evmptrld_status == EVMPTRLD_ERROR) {
>  		kvm_queue_exception(vcpu, UD_VECTOR);
>  		return 1;
>  	}
> +#endif
>  
>  	kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_BRANCH_INSTRUCTIONS);

This fails to build with CONFIG_KVM_HYPERV=n && CONFIG_KVM_WERROR=y:

arch/x86/kvm/vmx/nested.c:3577:9: error: variable 'evmptrld_status' is uninitialized when used here [-Werror,-Wuninitialized]
        if (CC(evmptrld_status == EVMPTRLD_VMFAIL))
               ^~~~~~~~~~~~~~~

Sadly, simply wrapping with an #ifdef also fails because then evmptrld_status
becomes unused.  I'd really prefer to avoid having to tag it __maybe_unused, and
adding more #ifdef would also be ugly.  Any ideas?

