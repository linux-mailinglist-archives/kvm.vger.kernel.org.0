Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0316C39097E
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 21:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbhEYTQI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 15:16:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230029AbhEYTQH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 15:16:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621970077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cfTxeL4OIgUD4b6FbpNY1WhY4/EMKJgcfnAtaYBoGiY=;
        b=Cc5VlDX5j6zBaAN8fEqt+aNGwdslLgT4nJdzQ3Z0JMsgDD9mK9xQv2W8vH7fz1qMgr/oHj
        cpL92ZhP11Kp1s2CLEEKgbcjJSprATn7Jf59ZVzkb0DiqCIGj0BRTEgHiWDpS4AC4kOKmH
        mgLgDHT+HJ0pZzv0eR1t0GtDnqJj76M=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-sQqASVJ4PZ2WYTfdDwAorw-1; Tue, 25 May 2021 15:14:35 -0400
X-MC-Unique: sQqASVJ4PZ2WYTfdDwAorw-1
Received: by mail-qt1-f197.google.com with SMTP id u18-20020a05622a14d2b029022c2829ba03so7779490qtx.13
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 12:14:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cfTxeL4OIgUD4b6FbpNY1WhY4/EMKJgcfnAtaYBoGiY=;
        b=oNcvGuda5Y3Z7iZJTn83FgBnZJ7BWea8/jc2a4niDD/8QBnmiPfU9dI8/SduFwEPuo
         4ajwBWwMLDvwNwY1nBfMzMnCL3rhYdfSVFNyEorF3pvtKeJ/F15dhaJa0+b6pVLbThJo
         gYrZKJN/481tv48pOnBRrMgjd59VdAJCkD0b8nqcXqhFD8VFx4Ltrpkyckm4ryp9g9KT
         THEv/s9gM4ylFrv+MTjzRn15EWJV0sm0qtaMAokGwl7dyRpOYH/uMLZrSyWAiUCybYMp
         Gk5FdVEt03i8w8D+RBXIDpQbwsfT1+NMEL/Mrg5sPD8JilvD2/JtLQGntlQeZ3CVcd3G
         wpBw==
X-Gm-Message-State: AOAM53140fqe4H59W5mIMIkProHwUP0dVjN3qqdUvGQK/oOMqI8QRI7d
        LkuSxW6Q4iaI2TzXKeOQn0tGTNhTeLc17DSCC/qWpEYOx+KO+zZ29Gf45oJ3Syx/OKt2yMgF8bo
        g32DgCloH/JAt
X-Received: by 2002:ac8:5748:: with SMTP id 8mr34578218qtx.233.1621970075329;
        Tue, 25 May 2021 12:14:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxl/91fApvYQOfoy9kvZW3hQ0vatecFu6v5xIPY0TDelorIfiaaZOdq2Sm9NqsEyUvk5BPnVA==
X-Received: by 2002:ac8:5748:: with SMTP id 8mr34578198qtx.233.1621970075031;
        Tue, 25 May 2021 12:14:35 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id z17sm52618qkb.59.2021.05.25.12.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 12:14:34 -0700 (PDT)
Date:   Tue, 25 May 2021 15:14:33 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [patch 2/3] KVM: rename KVM_REQ_PENDING_TIMER to KVM_REQ_UNBLOCK
Message-ID: <YK1MmcHqJGCR631n@t490s>
References: <20210525134115.135966361@redhat.com>
 <20210525134321.303768132@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210525134321.303768132@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021 at 10:41:17AM -0300, Marcelo Tosatti wrote:
> KVM_REQ_UNBLOCK will be used to exit a vcpu from
> its inner vcpu halt emulation loop.
> 
> Rename KVM_REQ_PENDING_TIMER to KVM_REQ_UNBLOCK, switch
> PowerPC to arch specific request bit.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> Index: kvm/include/linux/kvm_host.h
> ===================================================================
> --- kvm.orig/include/linux/kvm_host.h
> +++ kvm/include/linux/kvm_host.h
> @@ -146,7 +146,7 @@ static inline bool is_error_page(struct
>   */
>  #define KVM_REQ_TLB_FLUSH         (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> -#define KVM_REQ_PENDING_TIMER     2
> +#define KVM_REQ_UNBLOCK           2
>  #define KVM_REQ_UNHALT            3
>  #define KVM_REQUEST_ARCH_BASE     8
>  
> Index: kvm/virt/kvm/kvm_main.c
> ===================================================================
> --- kvm.orig/virt/kvm/kvm_main.c
> +++ kvm/virt/kvm/kvm_main.c
> @@ -2794,6 +2794,8 @@ static int kvm_vcpu_check_block(struct k
>  		goto out;
>  	if (signal_pending(current))
>  		goto out;
> +	if (kvm_check_request(KVM_REQ_UNBLOCK, vcpu))
> +		goto out;
>  
>  	ret = 0;
>  out:
> Index: kvm/Documentation/virt/kvm/vcpu-requests.rst
> ===================================================================
> --- kvm.orig/Documentation/virt/kvm/vcpu-requests.rst
> +++ kvm/Documentation/virt/kvm/vcpu-requests.rst
> @@ -118,10 +118,11 @@ KVM_REQ_MMU_RELOAD
>    necessary to inform each VCPU to completely refresh the tables.  This
>    request is used for that.
>  
> -KVM_REQ_PENDING_TIMER
> +KVM_REQ_UNBLOCK
>  
>    This request may be made from a timer handler run on the host on behalf
> -  of a VCPU.  It informs the VCPU thread to inject a timer interrupt.
> +  of a VCPU, or when device assignment is performed. It informs the VCPU to
> +  exit the vcpu halt inner loop.
>  
>  KVM_REQ_UNHALT
>  
> Index: kvm/arch/powerpc/include/asm/kvm_host.h
> ===================================================================
> --- kvm.orig/arch/powerpc/include/asm/kvm_host.h
> +++ kvm/arch/powerpc/include/asm/kvm_host.h
> @@ -51,6 +51,7 @@
>  /* PPC-specific vcpu->requests bit members */
>  #define KVM_REQ_WATCHDOG	KVM_ARCH_REQ(0)
>  #define KVM_REQ_EPR_EXIT	KVM_ARCH_REQ(1)
> +#define KVM_REQ_PENDING_TIMER	KVM_ARCH_REQ(2)
>  
>  #include <linux/mmu_notifier.h>
>  
> Index: kvm/arch/x86/kvm/lapic.c
> ===================================================================
> --- kvm.orig/arch/x86/kvm/lapic.c
> +++ kvm/arch/x86/kvm/lapic.c
> @@ -1657,7 +1657,7 @@ static void apic_timer_expired(struct kv
>  	}
>  
>  	atomic_inc(&apic->lapic_timer.pending);
> -	kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
> +	kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
>  	if (from_timer_fn)
>  		kvm_vcpu_kick(vcpu);
>  }

Pure question on the existing code: why do we need kvm_make_request() for
timer?  As I see kvm_vcpu_check_block() already checks explicitly for timers:

static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
{
        ...
	if (kvm_cpu_has_pending_timer(vcpu))
		goto out;
        ...
}

for x86:

int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
{
	if (lapic_in_kernel(vcpu))
		return apic_has_pending_timer(vcpu);

	return 0;
}

So wondering why we can drop the two references to KVM_REQ_PENDING_TIMER in x86
directly..

> Index: kvm/arch/x86/kvm/x86.c
> ===================================================================
> --- kvm.orig/arch/x86/kvm/x86.c
> +++ kvm/arch/x86/kvm/x86.c
> @@ -9300,7 +9300,7 @@ static int vcpu_run(struct kvm_vcpu *vcp
>  		if (r <= 0)
>  			break;
>  
> -		kvm_clear_request(KVM_REQ_PENDING_TIMER, vcpu);
> +		kvm_clear_request(KVM_REQ_UNBLOCK, vcpu);
>  		if (kvm_cpu_has_pending_timer(vcpu))
>  			kvm_inject_pending_timer_irqs(vcpu);
>  
> 
> 

-- 
Peter Xu

