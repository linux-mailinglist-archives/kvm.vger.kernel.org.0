Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DEB38EF7E
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 17:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhEXP6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 11:58:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234203AbhEXP4v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 11:56:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621871723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qUvndj0H92/0C1AlagHrJv4+Ez1XUG/XmzgCt7vP0jU=;
        b=cs1zyzhGapBkdqGUha6PyVfrtIkfvVR6rSMH3fZ5JWKrtHuiNld3EGdFqYA7aRAqmw+yNR
        74pfRYPr09XIMc+LTXU19puHwjWA6VO+QszUCp8lSG2mekBZ6MPo28UgZnOJpAqecDo3e7
        lLW29c9JEc6Hf+0EhbXzXBQ0e7uBhpg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-H7qJmWRINu-1mnCYinJTmA-1; Mon, 24 May 2021 11:55:21 -0400
X-MC-Unique: H7qJmWRINu-1mnCYinJTmA-1
Received: by mail-ej1-f72.google.com with SMTP id z1-20020a1709068141b02903cd421d7803so7742508ejw.22
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 08:55:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qUvndj0H92/0C1AlagHrJv4+Ez1XUG/XmzgCt7vP0jU=;
        b=KW00KBallQNOl3Nkdq4n+i/OL7Csg5kcoU1Z81yBFjUN0JdEdV5Rv2ndhFgTFbqRLJ
         JrC5DTZ+PUB6T57H5OhI5AXwgl/0CTrE5Ymj87MXBskAtuPsRSiWGRTmUbSOBiKTtRXR
         O7JlZI5YBgXpfucoFBvV8QQfshA0gl4IQr+j5/gV0BBvOXoj4m6Pkj9kwsRDkbvUXljP
         p8n5djcddp8QdykTZTwJJ5NlmRD6m+RpOHPagV/f07xfnNAnuSYpFB5SlJIhgZXmiC/U
         obhE4LhlNGE8SJi/GIZoYGFnhfDXIup2y0Kzu/YxX2/m/Lq2Pa5buA0yzjsK90P7+2+E
         lJoQ==
X-Gm-Message-State: AOAM530HuhGLK6qqXie59IPafI5WmojoXD90GbhI5V//cm1XNlwoLG5n
        X2Es7anl7qXf8IhjwomWTJeSrICNc27Yv9CEUT3JARuvfhbHurqLukA6dJ9jnApVgS/wKHcgxJ0
        ZLIRDJhCkvsDT
X-Received: by 2002:a05:6402:896:: with SMTP id e22mr26859283edy.256.1621871720428;
        Mon, 24 May 2021 08:55:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAhMSFduTteQP9rNbU0FjPhVSzPNHMVpB41WLlYbLgXFsCdjcfs96ypVP52n+1Q5LIPPy4VQ==
X-Received: by 2002:a05:6402:896:: with SMTP id e22mr26859276edy.256.1621871720298;
        Mon, 24 May 2021 08:55:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q16sm8090700ejm.12.2021.05.24.08.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 08:55:19 -0700 (PDT)
Subject: Re: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
To:     Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>, Pei Zhang <pezhang@redhat.com>
References: <20210510172646.930550753@redhat.com>
 <20210510172818.025080848@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e929da71-8f7d-52b2-2a71-30cb078535d3@redhat.com>
Date:   Mon, 24 May 2021 17:55:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210510172818.025080848@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/05/21 19:26, Marcelo Tosatti wrote:
> +void vmx_pi_start_assignment(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int i;
> +
> +	if (!irq_remapping_cap(IRQ_POSTING_CAP))
> +		return;
> +
> +	/*
> +	 * Wakeup will cause the vCPU to bail out of kvm_vcpu_block() and
> +	 * go back through vcpu_block().
> +	 */
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (!kvm_vcpu_apicv_active(vcpu))
> +			continue;
> +
> +		kvm_vcpu_wake_up(vcpu);

Would you still need the check_block callback, if you also added a 
kvm_make_request(KVM_REQ_EVENT)?

In fact, since this is entirely not a hot path, can you just do 
kvm_make_all_cpus_request(kvm, KVM_REQ_EVENT) instead of this loop?

Thanks,

Paolo

> +	}
> +}
>   
>   /*
>    * pi_update_irte - set IRTE for Posted-Interrupts
> Index: kvm/arch/x86/kvm/vmx/posted_intr.h
> ===================================================================
> --- kvm.orig/arch/x86/kvm/vmx/posted_intr.h
> +++ kvm/arch/x86/kvm/vmx/posted_intr.h
> @@ -95,5 +95,7 @@ void __init pi_init_cpu(int cpu);
>   bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
>   int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
>   		   bool set);
> +void vmx_pi_start_assignment(struct kvm *kvm);
> +int vmx_vcpu_check_block(struct kvm_vcpu *vcpu);
>   
>   #endif /* __KVM_X86_VMX_POSTED_INTR_H */
> Index: kvm/arch/x86/kvm/vmx/vmx.c
> ===================================================================
> --- kvm.orig/arch/x86/kvm/vmx/vmx.c
> +++ kvm/arch/x86/kvm/vmx/vmx.c
> @@ -7727,13 +7727,13 @@ static struct kvm_x86_ops vmx_x86_ops __
>   
>   	.pre_block = vmx_pre_block,
>   	.post_block = vmx_post_block,
> -	.vcpu_check_block = NULL,
> +	.vcpu_check_block = vmx_vcpu_check_block,
>   
>   	.pmu_ops = &intel_pmu_ops,
>   	.nested_ops = &vmx_nested_ops,
>   
>   	.update_pi_irte = pi_update_irte,
> -	.start_assignment = NULL,
> +	.start_assignment = vmx_pi_start_assignment,
>   
>   #ifdef CONFIG_X86_64
>   	.set_hv_timer = vmx_set_hv_timer,
> 
> 

