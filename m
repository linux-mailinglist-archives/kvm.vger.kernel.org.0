Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF6E37ABE1
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 18:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhEKQ1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 12:27:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32551 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230401AbhEKQ1T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 12:27:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620750372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+C1zNHFwaT9mjcpGe12CfeiNIVjWrEyhc/cM+7VRgF0=;
        b=E8wPRo6z/DTQgaQJftAl6rw4aePNQ76tdGOR3lWVV8fNGCF/5bTC4vBkEarjJNg6DJ8SOU
        uIY/NnFg4x656GnO1RQjOCXCgRa/cN1ZP46uGPo19MnSPike5gjOsqUHBJ1Y3Sdr1MppNJ
        LGFe01aQ4CMNedbVd0M28Ujx1A328HM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-1Rvd7NdjNvu3QrV0iAmATg-1; Tue, 11 May 2021 12:26:11 -0400
X-MC-Unique: 1Rvd7NdjNvu3QrV0iAmATg-1
Received: by mail-qv1-f69.google.com with SMTP id i19-20020a0cf3930000b02901c3869f9a1dso15948345qvk.5
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 09:26:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+C1zNHFwaT9mjcpGe12CfeiNIVjWrEyhc/cM+7VRgF0=;
        b=arMWlk2dGRPDVW/WDzc/0K4AOg45fp7LsFHL9AlipN9uuvaHhncvPNFxWOBGtGwfK7
         oLNgLtwjC4+VV9oJ7U7crsOeyEBzymgxMV2RodJ38iSr9ZK8inRQBRxqVtTA6i4ervuh
         RwEta1ugIX3ScxSxMefnKW2wMOul9D9UronmkjKtKoVSHlH/1/+eldX8Zn75k8/eXHuO
         DeEK2CIiPlaOfD2pCcHJ2eaD+b2XWzYlRWnDrR28DP83L644cEHrEN8EEuXyt6o0oGB5
         9/MK4a4mCohgTG6bQriqBqMg8l2P5U6BOjDNiQ9SAdmkad/WhRAcPOyfoDAEw1WebWlM
         jnFg==
X-Gm-Message-State: AOAM530BR5XioNPtmN+gnGyXcGcLL97u8OKKXaOyaPIaM7ROK3avU3aG
        UZfSAJXg1I0y4LRMt3kxqL1dEGu+WXqjbgjzZuqTLquwzAmnv+cKmJ17iQo11k5ElI2GffZI10N
        rhhcnQT6m6MEj
X-Received: by 2002:ac8:7658:: with SMTP id i24mr29089074qtr.368.1620750370679;
        Tue, 11 May 2021 09:26:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxinRoiKxmu6EN21KQQUKZFk1HE1qTjdiFw5Ux15KjMCw4XZP7Sb7+3x+pDbqzdRqNEZI6xJg==
X-Received: by 2002:ac8:7658:: with SMTP id i24mr29089045qtr.368.1620750370403;
        Tue, 11 May 2021 09:26:10 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id z9sm4098073qtf.10.2021.05.11.09.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 09:26:09 -0700 (PDT)
Date:   Tue, 11 May 2021 12:26:08 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [patch 1/4] KVM: x86: add start_assignment hook to kvm_x86_ops
Message-ID: <YJqwIGqkMfCIMOdS@t490s>
References: <20210510172646.930550753@redhat.com>
 <20210510172817.934490238@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210510172817.934490238@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021 at 02:26:47PM -0300, Marcelo Tosatti wrote:
> Add a start_assignment hook to kvm_x86_ops, which is called when 
> kvm_arch_start_assignment is done.
> 
> The hook is required to update the wakeup vector of a sleeping vCPU
> when a device is assigned to the guest.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> Index: kvm/arch/x86/include/asm/kvm_host.h
> ===================================================================
> --- kvm.orig/arch/x86/include/asm/kvm_host.h
> +++ kvm/arch/x86/include/asm/kvm_host.h
> @@ -1322,6 +1322,7 @@ struct kvm_x86_ops {
>  
>  	int (*update_pi_irte)(struct kvm *kvm, unsigned int host_irq,
>  			      uint32_t guest_irq, bool set);
> +	void (*start_assignment)(struct kvm *kvm);
>  	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
>  	bool (*dy_apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);
>  
> Index: kvm/arch/x86/kvm/svm/svm.c
> ===================================================================
> --- kvm.orig/arch/x86/kvm/svm/svm.c
> +++ kvm/arch/x86/kvm/svm/svm.c
> @@ -4601,6 +4601,7 @@ static struct kvm_x86_ops svm_x86_ops __
>  	.deliver_posted_interrupt = svm_deliver_avic_intr,
>  	.dy_apicv_has_pending_interrupt = svm_dy_apicv_has_pending_interrupt,
>  	.update_pi_irte = svm_update_pi_irte,
> +	.start_assignment = NULL,

Can this be dropped (as default NULL)?

>  	.setup_mce = svm_setup_mce,
>  
>  	.smi_allowed = svm_smi_allowed,
> Index: kvm/arch/x86/kvm/vmx/vmx.c
> ===================================================================
> --- kvm.orig/arch/x86/kvm/vmx/vmx.c
> +++ kvm/arch/x86/kvm/vmx/vmx.c
> @@ -7732,6 +7732,7 @@ static struct kvm_x86_ops vmx_x86_ops __
>  	.nested_ops = &vmx_nested_ops,
>  
>  	.update_pi_irte = pi_update_irte,
> +	.start_assignment = NULL,

Same here?

>  
>  #ifdef CONFIG_X86_64
>  	.set_hv_timer = vmx_set_hv_timer,
> Index: kvm/arch/x86/kvm/x86.c
> ===================================================================
> --- kvm.orig/arch/x86/kvm/x86.c
> +++ kvm/arch/x86/kvm/x86.c
> @@ -11295,7 +11295,11 @@ bool kvm_arch_can_dequeue_async_page_pre
>  
>  void kvm_arch_start_assignment(struct kvm *kvm)
>  {
> -	atomic_inc(&kvm->arch.assigned_device_count);
> +	int ret;
> +
> +	ret = atomic_inc_return(&kvm->arch.assigned_device_count);
> +	if (ret == 1)
> +		static_call_cond(kvm_x86_start_assignment)(kvm);

Maybe "ret" can be dropped too?

void kvm_arch_start_assignment(struct kvm *kvm)
{
	if (atomic_inc_return(&kvm->arch.assigned_device_count) == 1)
		static_call_cond(kvm_x86_start_assignment)(kvm);
}

Otherwise looks good to me.  Thanks,

-- 
Peter Xu

