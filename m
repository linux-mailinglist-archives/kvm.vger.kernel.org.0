Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C3B519F08
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 14:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349341AbiEDMPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 08:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343788AbiEDMPt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 08:15:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8375D237D0
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 05:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651666332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dCPW4qvwcpTydZ0St+Yp5/C2uYiVBC1zbL1N8xJvOoE=;
        b=CKVrzrvkieZoKi9dijBY0ppKw/FQZwjG01j+NyOXX6O6iKA9USoT5jaUjmOv5nF2wNoQEW
        Sd2sMg1IUPF7KtsTXY+p55WxdApuEts50X2Mn20fl3uXdhsK1AzinVPtkCEQjy6FTH2QEL
        o9+bolhdlijr5RGZWMihhqUnXxan98M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-AtJSXlWaPcOqkMhwKzTjBA-1; Wed, 04 May 2022 08:12:09 -0400
X-MC-Unique: AtJSXlWaPcOqkMhwKzTjBA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 978AB3C01D8B;
        Wed,  4 May 2022 12:12:08 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F8CE2024CBC;
        Wed,  4 May 2022 12:12:03 +0000 (UTC)
Message-ID: <a883ff438d6202f2dc0458dc4d7c1ab3688f5db8.camel@redhat.com>
Subject: Re: [PATCH v3 03/14] KVM: SVM: Detect X2APIC virtualization
 (x2AVIC) support
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Wed, 04 May 2022 15:12:02 +0300
In-Reply-To: <20220504073128.12031-4-suravee.suthikulpanit@amd.com>
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
         <20220504073128.12031-4-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-04 at 02:31 -0500, Suravee Suthikulpanit wrote:
> Add CPUID check for the x2APIC virtualization (x2AVIC) feature.
> If available, the SVM driver can support both AVIC and x2AVIC modes
> when load the kvm_amd driver with avic=1. The operating mode will be
> determined at runtime depending on the guest APIC mode.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/include/asm/svm.h |  3 +++
>  arch/x86/kvm/svm/avic.c    | 40 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c     | 15 ++------------
>  arch/x86/kvm/svm/svm.h     |  1 +
>  4 files changed, 46 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index f70a5108d464..2c2a104b777e 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -195,6 +195,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  #define AVIC_ENABLE_SHIFT 31
>  #define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
>  
> +#define X2APIC_MODE_SHIFT 30
> +#define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
> +
>  #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
>  #define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
>  
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index a8f514212b87..fc3ba6071482 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -40,6 +40,15 @@
>  #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
>  #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
>  
> +enum avic_modes {
> +	AVIC_MODE_NONE = 0,
> +	AVIC_MODE_X1,
> +	AVIC_MODE_X2,
> +};
> +
> +static bool force_avic;
> +module_param_unsafe(force_avic, bool, 0444);
> +
>  /* Note:
>   * This hash table is used to map VM_ID to a struct kvm_svm,
>   * when handling AMD IOMMU GALOG notification to schedule in
> @@ -50,6 +59,7 @@ static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
>  static u32 next_vm_id = 0;
>  static bool next_vm_id_wrapped = 0;
>  static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
> +static enum avic_modes avic_mode;
>  
>  /*
>   * This is a wrapper of struct amd_iommu_ir_data.
> @@ -1077,3 +1087,33 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  
>  	avic_vcpu_load(vcpu);
>  }
> +
> +/*
> + * Note:
> + * - The module param avic enable both xAPIC and x2APIC mode.
> + * - Hypervisor can support both xAVIC and x2AVIC in the same guest.
> + * - The mode can be switched at run-time.
> + */
> +bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
> +{
> +	if (!npt_enabled)
> +		return false;
> +
> +	if (boot_cpu_has(X86_FEATURE_AVIC)) {
> +		avic_mode = AVIC_MODE_X1;
> +		pr_info("AVIC enabled\n");
> +	} else if (force_avic) {
> +		pr_warn("AVIC is not supported in CPUID but force enabled");
> +		pr_warn("Your system might crash and burn");

I think in this case avic_mode should also be set to AVIC_MODE_X1
(Hopefully this won't be needed for systems that have x2avic enabled)

Best regards,
	Maxim Levitsky

> +	}
> +
> +	if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
> +		avic_mode = AVIC_MODE_X2;
> +		pr_info("x2AVIC enabled\n");
> +	}
> +
> +	if (avic_mode != AVIC_MODE_NONE)
> +		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
> +
> +	return !!avic_mode;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3b49337998ec..74e6f86f5dc3 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -188,9 +188,6 @@ module_param(tsc_scaling, int, 0444);
>  static bool avic;
>  module_param(avic, bool, 0444);
>  
> -static bool force_avic;
> -module_param_unsafe(force_avic, bool, 0444);
> -
>  bool __read_mostly dump_invalid_vmcb;
>  module_param(dump_invalid_vmcb, bool, 0644);
>  
> @@ -4913,17 +4910,9 @@ static __init int svm_hardware_setup(void)
>  			nrips = false;
>  	}
>  
> -	enable_apicv = avic = avic && npt_enabled && (boot_cpu_has(X86_FEATURE_AVIC) || force_avic);
> +	enable_apicv = avic = avic && avic_hardware_setup(&svm_x86_ops);
>  
> -	if (enable_apicv) {
> -		if (!boot_cpu_has(X86_FEATURE_AVIC)) {
> -			pr_warn("AVIC is not supported in CPUID but force enabled");
> -			pr_warn("Your system might crash and burn");
> -		} else
> -			pr_info("AVIC enabled\n");
> -
> -		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
> -	} else {
> +	if (!enable_apicv) {
>  		svm_x86_ops.vcpu_blocking = NULL;
>  		svm_x86_ops.vcpu_unblocking = NULL;
>  		svm_x86_ops.vcpu_get_apicv_inhibit_reasons = NULL;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 32220a1b0ea2..678fc7757fe4 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -603,6 +603,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
>  
>  /* avic.c */
>  
> +bool avic_hardware_setup(struct kvm_x86_ops *ops);
>  int avic_ga_log_notifier(u32 ga_tag);
>  void avic_vm_destroy(struct kvm *kvm);
>  int avic_vm_init(struct kvm *kvm);


