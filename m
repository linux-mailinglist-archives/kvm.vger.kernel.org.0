Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CC538B285
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 17:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239826AbhETPF5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 11:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243132AbhETPFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 11:05:39 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D43C061343
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 08:04:16 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id l70so12066322pga.1
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 08:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jrMt9QJez7P5+bvwpasBTmDL6nKnfeamyLw6Z/AnazM=;
        b=Po7kltvL+25HLzGM75Gdmo9X0cT+vXsymmDgTQtxUSKvzW+YHeGLasvaqtR16iJjOc
         tA46MXUSWQyMgmoc7o/INR0UrGOT74c3nHqi1aHAK56qFVSjAIj4+ZN7iqDxJbCFltsf
         E7Q21OHouf3q0+Fva2gLj3RfjWeKBm478pbe9Ucgp+u3OdI58XCPwAhSag7BRtwwVwVP
         E0jFelyX1woyWtC7IwlwYeC9mC993fPq6bF0fOfeeHZiTTc3ccMnpio+vsjA+8Eg4kzB
         BN60hkfgm0vVeGzt4KLLcwLZVkXsj7MqfMYD8nPsFo8VahQ+KkfrG7Zb/jVYiKRstUkr
         wQDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jrMt9QJez7P5+bvwpasBTmDL6nKnfeamyLw6Z/AnazM=;
        b=F2OqZNsRZfNoQN9d9bTxKuxVIfvsRi9fI7TVa0tIKwHGpn4CepGy4d3wUkyPO8l6tb
         Q0/jGOcO4yH4cTmMm0YvF9zUdajhBisfyCi0rcdK5PP8WBOGVuVndsJoQs5N+7eZDYHQ
         widuOnZnZDgLrIH35dAZyGK4Lj861fpZOzdxWgY35apMyV6JCf84x1G9CFQe2ylXizHP
         Qu+u86mpAR6LfahGFJod2nL08VGf3MouKotUnxbeGCZmjnRpmBfnveQk+DGtm9kL0Opa
         movsdAuv9a1xZQ1GsE1ahj+iSsm1Fr+VJ4mPOAox/fXn4+mJZkP0FpNuutQEEWDG8+9p
         ggEg==
X-Gm-Message-State: AOAM532IjbMC0coLU3+2uqEPFOdVxgkzak8ag4fPp4OK60jT/HVr2rA7
        sFe/wyepNhq9ExjJn+NP9cy1PQ==
X-Google-Smtp-Source: ABdhPJyIiyetgp2/t7PvsfPKZUEs42uWRMgeuPwV3PZwsDzLKTfrqIP0j7wxDH0MZ7q6ddMHwIoVbQ==
X-Received: by 2002:a63:a19:: with SMTP id 25mr5019828pgk.177.1621523055789;
        Thu, 20 May 2021 08:04:15 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id s3sm2254541pfu.9.2021.05.20.08.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 08:04:15 -0700 (PDT)
Date:   Thu, 20 May 2021 15:04:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 4/4 v2] KVM: x86: Add a new VM statistic to show number
 of VCPUs created in a given VM
Message-ID: <YKZ6a6UlJt/r985F@google.com>
References: <20210520005012.68377-1-krish.sadhukhan@oracle.com>
 <20210520005012.68377-5-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520005012.68377-5-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021, Krish Sadhukhan wrote:
> 'struct kvm' already has a member for counting the number of VCPUs created
> for a given VM. Add this as a new VM statistic to KVM debugfs.

Huh!??  Why?  Userspace is the one creating the vCPUs, it darn well should know
how many it's created.
 
> Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/svm/svm.c          | 3 +--
>  arch/x86/kvm/x86.c              | 1 +
>  virt/kvm/kvm_main.c             | 2 ++
>  4 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a19fe2cfaa93..69ca1d6f6557 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1139,6 +1139,7 @@ struct kvm_vm_stat {
>  	ulong nx_lpage_splits;
>  	ulong max_mmu_page_hash_collisions;
>  	ulong vcpus_ran_nested;
> +	u64 created_vcpus;
>  };
>  
>  struct kvm_vcpu_stat {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d1871c51411f..fef0baba043b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3875,8 +3875,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  		/* Track VMRUNs that have made past consistency checking */
>  		if (svm->nested.nested_run_pending &&
> -		    svm->vmcb->control.exit_code != SVM_EXIT_ERR &&
> -		    svm->vmcb->control.exit_code != SVM_EXIT_NPF) {
> +		    svm->vmcb->control.exit_code != SVM_EXIT_ERR) {

???

>  			if (!vcpu->stat.nested_runs)
>  				++vcpu->kvm->stat.vcpus_ran_nested;
>                          ++vcpu->stat.nested_runs;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cbca3609a152..a9d27ce4cc93 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -258,6 +258,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>  	VM_STAT("nx_largepages_splitted", nx_lpage_splits, .mode = 0444),
>  	VM_STAT("max_mmu_page_hash_collisions", max_mmu_page_hash_collisions),
>  	VM_STAT("vcpus_ran_nested", vcpus_ran_nested),
> +	VM_STAT("created_vcpus", created_vcpus),
>  	{ NULL }
>  };
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6b4feb92dc79..ac8f02d8a051 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3318,6 +3318,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>  	}
>  
>  	kvm->created_vcpus++;
> +	kvm->stat.created_vcpus++;
>  	mutex_unlock(&kvm->lock);
>  
>  	r = kvm_arch_vcpu_precreate(kvm, id);
> @@ -3394,6 +3395,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>  vcpu_decrement:
>  	mutex_lock(&kvm->lock);
>  	kvm->created_vcpus--;
> +	kvm->stat.created_vcpus--;
>  	mutex_unlock(&kvm->lock);
>  	return r;
>  }
> -- 
> 2.27.0
> 
