Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2324EEFAAB
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 11:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388342AbfKEKQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 05:16:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37180 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387821AbfKEKQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 05:16:17 -0500
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E3B607FDC6
        for <kvm@vger.kernel.org>; Tue,  5 Nov 2019 10:16:16 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id u2so5975166wrm.7
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 02:16:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ct8tCrODlfwykP6VQq2exRkG1sdhY/k8AxLcXtCzuNM=;
        b=eN5K3RDSXskvPY+HJXZQ2SgsV9GW18MUWBTyc8mdiAG5JG6+PZiPO5s62KEPn0ydGK
         TWpAxXcbEBf9jm+yQvkRLS+2ozfUmv1F1C4O7rmifRJytvHwebfkfGGsqx763SS9x3Bf
         mvwYloEl57npVZXgUJFJ8v9QJDC7HA3O+ty9hp7HKOKMqHQUa5Xn5kfu0BkJGEeDWekm
         SQ/eZoPJWuvLegolwLTuR1zPhQNSm1+ApFxGP9+FgLwb8iPI5wqt1b3AsJq/loa+lw/y
         l1g0oaS02lX9ndf7RJjw+/SeBXBW0fLVrwW5LXFWb5LjDdMU3FQ5liw23p0vVuC+Sv96
         3RSA==
X-Gm-Message-State: APjAAAU+St8DVmVoRiE9qwW1fZ/+67sMdRrA9q46MW6pm1Hc2Q5NvCAB
        3UMYfytG+OgkvlNWnShfwoDyAQO/WqHyVVgqDezSym4dRd4G4X1BPDSNJL/pnis1VT85GdikJsT
        IYAeGphcQB5bC
X-Received: by 2002:adf:f7d1:: with SMTP id a17mr26340169wrq.111.1572948975207;
        Tue, 05 Nov 2019 02:16:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqzzrBjS31Na9MISZVsU/VfkSzWt2ceJJQK5DBc+d8jhpC31klO5n4owghI0PA9vpfjCySZkgg==
X-Received: by 2002:adf:f7d1:: with SMTP id a17mr26340145wrq.111.1572948974888;
        Tue, 05 Nov 2019 02:16:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4051:461:136e:3f74? ([2001:b07:6468:f312:4051:461:136e:3f74])
        by smtp.gmail.com with ESMTPSA id 65sm31147840wrs.9.2019.11.05.02.16.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 02:16:14 -0800 (PST)
Subject: Re: [PATCH 05/13] KVM: monolithic: add more section prefixes
To:     Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
 <20191104230001.27774-6-aarcange@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <62961d8f-39b9-86e2-59b8-b64b77022939@redhat.com>
Date:   Tue, 5 Nov 2019 11:16:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104230001.27774-6-aarcange@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/11/19 23:59, Andrea Arcangeli wrote:
> Add more section prefixes because with the monolithic KVM model the
> section checker can now do a more accurate static analysis at build
> time and this allows to build without
> CONFIG_SECTION_MISMATCH_WARN_ONLY=n.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  arch/powerpc/kvm/book3s.c | 2 +-
>  arch/x86/kvm/x86.c        | 4 ++--
>  include/linux/kvm_host.h  | 8 ++++----
>  virt/kvm/arm/arm.c        | 2 +-
>  virt/kvm/kvm_main.c       | 6 +++---
>  5 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
> index ec2547cc5ecb..e80e9504722a 100644
> --- a/arch/powerpc/kvm/book3s.c
> +++ b/arch/powerpc/kvm/book3s.c
> @@ -1067,7 +1067,7 @@ int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
>  
>  #endif /* CONFIG_KVM_XICS */
>  
> -static int kvmppc_book3s_init(void)
> +static __init int kvmppc_book3s_init(void)
>  {
>  	int r;
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fb963e6b2e54..5e98fa6b7bf8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9272,7 +9272,7 @@ void kvm_arch_hardware_disable(void)
>  	drop_user_return_notifiers();
>  }
>  
> -int kvm_arch_hardware_setup(void)
> +__init int kvm_arch_hardware_setup(void)
>  {
>  	int r;
>  
> @@ -9303,7 +9303,7 @@ void kvm_arch_hardware_unsetup(void)
>  	kvm_x86_hardware_unsetup();
>  }
>  
> -int kvm_arch_check_processor_compat(void)
> +__init int kvm_arch_check_processor_compat(void)
>  {
>  	return kvm_x86_check_processor_compatibility();
>  }
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 719fc3e15ea4..426bc2f485a9 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -616,8 +616,8 @@ static inline void kvm_irqfd_exit(void)
>  {
>  }
>  #endif
> -int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
> -		  struct module *module);
> +__init int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
> +		    struct module *module);
>  void kvm_exit(void);
>  
>  void kvm_get_kvm(struct kvm *kvm);
> @@ -867,9 +867,9 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu);
>  
>  int kvm_arch_hardware_enable(void);
>  void kvm_arch_hardware_disable(void);
> -int kvm_arch_hardware_setup(void);
> +__init int kvm_arch_hardware_setup(void);
>  void kvm_arch_hardware_unsetup(void);
> -int kvm_arch_check_processor_compat(void);
> +__init int kvm_arch_check_processor_compat(void);
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
>  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
>  int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 86c6aa1cb58e..65f7f0f6868d 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1726,7 +1726,7 @@ void kvm_arch_exit(void)
>  	kvm_perf_teardown();
>  }
>  
> -static int arm_init(void)
> +static __init int arm_init(void)
>  {
>  	int rc = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
>  	return rc;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d6f0696d98ef..1b7fbd138406 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4246,13 +4246,13 @@ static void kvm_sched_out(struct preempt_notifier *pn,
>  	kvm_arch_vcpu_put(vcpu);
>  }
>  
> -static void check_processor_compat(void *rtn)
> +static __init void check_processor_compat(void *rtn)
>  {
>  	*(int *)rtn = kvm_arch_check_processor_compat();
>  }
>  
> -int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
> -		  struct module *module)
> +__init int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
> +		    struct module *module)
>  {
>  	int r;
>  	int cpu;
> 

Queued, thanks.

Paolo
