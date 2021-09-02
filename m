Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80783FF55C
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 23:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347027AbhIBVJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 17:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347017AbhIBVJO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 17:09:14 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6680C061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 14:08:15 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id fz10so2282600pjb.0
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 14:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jsw+0RVz7kftEoRLavLgOo4GczdDf7aQJBZW/qWLrRg=;
        b=ka0Oj+PjP0myE0BToQV3XzncczscdjeGITakU0uoU2xiaHRnNeILJeuczOtmgz8P3d
         yELQU2R4mfWM6643HaIjUfniTIpSJxo/F9D5mn3sdXlFCPSzXAreDXb8K6ISu2KZa+qG
         WDcLvcG886JSY82qWMOSgbV7LrkN4stezqeSrPQdwsT0SOvAM0ui0At1yu1ppDDVIPct
         Gks8lW3uWkq2Fo/CmTq3VYOXdsKtfsdN4uWP/UDdBNk7XJhQzSlZnNBUtMIcxNNCb8u6
         CAY0wu82mF3SVke9rBAdhzNcDXGln2trGkSCi6UU5tZb0sH1VG9I7P4jbl2JXowUoVlk
         MFVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jsw+0RVz7kftEoRLavLgOo4GczdDf7aQJBZW/qWLrRg=;
        b=jHyV/k3R5lGDWQPl5hXgq5BQgzFddL7maOHxbmM1IEEWUFN9FE5GWAazBc2tkAP+IX
         Gsh8AiNbuj2NiXIr88LgxjGXwOtPSvHAse0f+g5t6ZIPkYbtb8xLOfFLRs6TGDXBEmQV
         Sl9akyQRV3Lo+nPTlWrr4yzZYKd6mjoIxG+rO74Xvflclu4a2gpzw7KiSunVnLRAmWG0
         rmaUBQPrpzukGjkyhWJu+OH+5ClU6E8J9rxXhvc8SEC5fbItURQ6Yz5zeEPRe0LtnMoe
         jZrtxbxXHkpLkLXnDGYgTtGcboY0KG9//D817nA8ArYWSoWndhWt4dHje8Q/mqBoa5A0
         1IDg==
X-Gm-Message-State: AOAM530YJKdhToZFKvn8dZpJTJu67IsVAUnB+i7C+4uPdQ5q05Qa0wEJ
        1XM+cqIpbWWgG/RVqOgoiPD8gw==
X-Google-Smtp-Source: ABdhPJyGGdSHjvZNith8nn/rlOSbpsGt4FmNaUkcIVgELS/5Et4dd93zq81nzbWh9rJTTJ/rSiYyaA==
X-Received: by 2002:a17:90a:f18d:: with SMTP id bv13mr6178724pjb.70.1630616895004;
        Thu, 02 Sep 2021 14:08:15 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gm5sm3087181pjb.32.2021.09.02.14.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:08:14 -0700 (PDT)
Date:   Thu, 2 Sep 2021 21:08:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 7/8] KVM: Pre-allocate cpumasks for
 kvm_make_all_cpus_request_except()
Message-ID: <YTE9OsXABLzUitUd@google.com>
References: <20210827092516.1027264-1-vkuznets@redhat.com>
 <20210827092516.1027264-8-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827092516.1027264-8-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021, Vitaly Kuznetsov wrote:
> Allocating cpumask dynamically in zalloc_cpumask_var() is not ideal.
> Allocation is somewhat slow and can (in theory and when CPUMASK_OFFSTACK)
> fail. kvm_make_all_cpus_request_except() already disables preemption so
> we can use pre-allocated per-cpu cpumasks instead.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 29 +++++++++++++++++++++++------
>  1 file changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2e9927c4eb32..2f5fe4f54a51 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -155,6 +155,8 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm);
>  static unsigned long long kvm_createvm_count;
>  static unsigned long long kvm_active_vms;
>  
> +static DEFINE_PER_CPU(cpumask_var_t, cpu_kick_mask);
> +
>  __weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
>  						   unsigned long start, unsigned long end)
>  {
> @@ -323,14 +325,15 @@ bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
>  				      struct kvm_vcpu *except)
>  {
>  	struct kvm_vcpu *vcpu;
> -	cpumask_var_t cpus;
> +	struct cpumask *cpus;
>  	bool called;
>  	int i, me;
>  
> -	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
> -
>  	me = get_cpu();
>  
> +	cpus = this_cpu_cpumask_var_ptr(cpu_kick_mask);
> +	cpumask_clear(cpus);
> +
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		if (vcpu == except)
>  			continue;
> @@ -340,7 +343,6 @@ bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
>  	called = kvm_kick_many_cpus(cpus, !!(req & KVM_REQUEST_WAIT));
>  	put_cpu();
>  
> -	free_cpumask_var(cpus);
>  	return called;
>  }
>  
> @@ -5581,9 +5583,15 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  		goto out_free_3;
>  	}
>  
> +	for_each_possible_cpu(cpu) {
> +		if (!alloc_cpumask_var_node(&per_cpu(cpu_kick_mask, cpu),
> +					    GFP_KERNEL, cpu_to_node(cpu)))
> +			goto out_free_4;

'r' needs to be explicitly set to -EFAULT, e.g. in the current code it's
guaranteed to be 0 here.

> +	}
> +
>  	r = kvm_async_pf_init();
>  	if (r)
> -		goto out_free;
> +		goto out_free_5;
>  
>  	kvm_chardev_ops.owner = module;
>  	kvm_vm_fops.owner = module;
> @@ -5609,7 +5617,11 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  
>  out_unreg:
>  	kvm_async_pf_deinit();
> -out_free:
> +out_free_5:
> +	for_each_possible_cpu(cpu) {

Unnecessary braces.

> +		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
> +	}
> +out_free_4:
>  	kmem_cache_destroy(kvm_vcpu_cache);
>  out_free_3:
>  	unregister_reboot_notifier(&kvm_reboot_notifier);
> @@ -5629,8 +5641,13 @@ EXPORT_SYMBOL_GPL(kvm_init);
>  
>  void kvm_exit(void)
>  {
> +	int cpu;
> +
>  	debugfs_remove_recursive(kvm_debugfs_dir);
>  	misc_deregister(&kvm_dev);
> +	for_each_possible_cpu(cpu) {

Same here.

> +		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
> +	}
>  	kmem_cache_destroy(kvm_vcpu_cache);
>  	kvm_async_pf_deinit();
>  	unregister_syscore_ops(&kvm_syscore_ops);
> -- 
> 2.31.1
> 
