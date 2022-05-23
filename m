Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D60C531E94
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 00:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiEWW10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 18:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiEWW1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 18:27:24 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2549C7DE2F
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 15:27:22 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id i11so27894217ybq.9
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 15:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x9UvpRLSY5zsz98jmsxKkKeHOvgVXmiYIhmkTUpVkyM=;
        b=jckEK50RFGV8DufRw4qT6Z0WDGO6UlG2Lh2PP4EDu2xD7NgLU6p4j3NitfMa1A/LFx
         1kTG1pVXrmpgTXrSOru9knU3e1C/aycFL2S3ifwCHAn+eUTpx/WWwCqJixVugsDWQZFx
         d9hF/nT/rsbB5Ffx9nIft4by/5AJR7Qsfkwa7+jE4KRKDC20Nq4EWU0Jp2leg3UvuygL
         S5hgOEFUyU/EFN6piNWGz89ad0yoz04JckXNTXK2UKUKg3UbK1m6BXKuzWTljP8DIYJR
         5921C4ORMend1M0cg4FvpsuB6GSjr3Z4RysSk04+lYsh5Z/CCD052zwvIacuqaPbAU1o
         TQ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x9UvpRLSY5zsz98jmsxKkKeHOvgVXmiYIhmkTUpVkyM=;
        b=5I6+bnpmkWJCc3ONfcEcP1wxdtgSuHy2Uuk4vR4Coxu8Hy0eqkfqAIuNsUmX1V+wD1
         +Z9mGXi6MDP+/BVl17G9slYTMCy1uzjYy9sPC4F1NzNxl2Rwd9uPkCuu+xTxB/imHA2h
         hdM5Mq7aALirckt/AOKmljv73jFcl1T3jXAp/nG1561oR7I35c6jdEByIOul0abUcEXS
         fLCTxyzr681udxtDsmJyDrrnSHanoEV0g7Wpm776raPNmA2pPskrrdtXhKFDF+2QuVD3
         M6UL2Jl0MrNwhgKHeZEYOqyASD3aO6t5ZKwL1+6EMoz/82ZwElgxZN7xW+mBq578Pxnn
         Jjlw==
X-Gm-Message-State: AOAM530SLjKLRmay6DDljfOGfCMml+g/GaQCAaPgewK066iVehWSBltU
        GTkLv0LW5tjrmKGbQY22sSW544K6ZaZcFIyMxQSVig==
X-Google-Smtp-Source: ABdhPJzIghg22UtEe1dAs5j2rwLl7sRnoxOFf4nS7Fci0D6HMktnaBG16wLf6m/6zODNYR4O0NjfWUHIC4uJeGMFR+Y=
X-Received: by 2002:a05:6902:1102:b0:64f:37a3:6b9e with SMTP id
 o2-20020a056902110200b0064f37a36b9emr22428531ybu.21.1653344841151; Mon, 23
 May 2022 15:27:21 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1651774250.git.isaku.yamahata@intel.com> <75912816e498ddf62e7efb6a187d763c89e72f45.1651774250.git.isaku.yamahata@intel.com>
In-Reply-To: <75912816e498ddf62e7efb6a187d763c89e72f45.1651774250.git.isaku.yamahata@intel.com>
From:   Sagi Shahar <sagis@google.com>
Date:   Mon, 23 May 2022 15:27:10 -0700
Message-ID: <CAAhR5DGQ+btmAh9bs=_8c4cqH__4yk8R8C1ko1ZHUc0ZTjJuDw@mail.gmail.com>
Subject: Re: [RFC PATCH v6 003/104] KVM: Refactor CPU compatibility check on
 module initialiization
To:     "Yamahata, Isaku" <isaku.yamahata@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 5, 2022 at 11:15 AM <isaku.yamahata@intel.com> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Although non-x86 arch doesn't break as long as I inspected code, it's by
> code inspection.  This should be reviewed by each arch maintainers.
>
> kvm_init() checks CPU compatibility by calling
> kvm_arch_check_processor_compat() on all online CPUs.  Move the callback
> to hardware_enable_nolock() and add hardware_enable_all() and
> hardware_disable_all().
> Add arch specific callback kvm_arch_post_hardware_enable_setup() for arch
> to do arch specific initialization that required hardware_enable_all().

There's no reference to kvm_arch_post_hardware_enable_setup in this
patch. Looks like it's introduced in a later patch in the series.

This patch might be clearer if the kvm_arch_post_hardware_enable_setup
is introduced and used here. Otherwise, the commit log should be
updated to make it clear that kvm_arch_post_hardware_enable_setup is
introduced in a later patch in the series.

> This makes a room for TDX module to initialize on kvm module loading.  TDX
> module requires all online cpu to enable VMX by VMXON.
>
> If kvm_arch_hardware_enable/disable() depend on (*) part, such dependency
> must be called before kvm_init().  In fact kvm_intel() does.  Although
> other arch doesn't as long as I checked as follows, it should be reviewed
> by each arch maintainers.
>
> Before this patch:
> - Arch module initialization
>   - kvm_init()
>     - kvm_arch_init()
>     - kvm_arch_check_processor_compat() on each CPUs
>   - post arch specific initialization ---- (*)
>
> - when creating/deleting first/last VM
>    - kvm_arch_hardware_enable() on each CPUs --- (A)
>    - kvm_arch_hardware_disable() on each CPUs --- (B)
>
> After this patch:
> - Arch module initialization
>   - kvm_init()
>     - kvm_arch_init()
>     - kvm_arch_hardware_enable() on each CPUs  (A)
>     - kvm_arch_check_processor_compat() on each CPUs
>     - kvm_arch_hardware_disable() on each CPUs (B)
>   - post arch specific initialization  --- (*)
>
> Code inspection result:
> (A)/(B) can depend on (*) before this patch.  If there is dependency, such
> initialization must be moved before kvm_init() with this patch.  VMX does
> in fact.  As long as I inspected other archs and find only mips has it.
>
> - arch/mips/kvm/mips.c
>   module init function, kvm_mips_init(), does some initialization after
>   kvm_init().  Compile test only.  Needs review.
>
> - arch/x86/kvm/x86.c
>   - uses vm_list which is statically initialized.
>   - static_call(kvm_x86_hardware_enable)();
>     - SVM: (*) is empty.
>     - VMX: needs fix
>
> - arch/powerpc/kvm/powerpc.c
>   kvm_arch_hardware_enable/disable() are nop
>
> - arch/s390/kvm/kvm-s390.c
>   kvm_arch_hardware_enable/disable() are nop
>
> - arch/arm64/kvm/arm.c
>   module init function, arm_init(), calls only kvm_init().
>   (*) is empty
>
> - arch/riscv/kvm/main.c
>   module init function, riscv_kvm_init(), calls only kvm_init().
>   (*) is empty
>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/mips/kvm/mips.c   | 12 +++++++-----
>  arch/x86/kvm/vmx/vmx.c | 15 +++++++++++----
>  virt/kvm/kvm_main.c    | 20 ++++++++++----------
>  3 files changed, 28 insertions(+), 19 deletions(-)
>
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 092d09fb6a7e..17228584485d 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -1643,11 +1643,6 @@ static int __init kvm_mips_init(void)
>         }
>
>         ret = kvm_mips_entry_setup();
> -       if (ret)
> -               return ret;
> -
> -       ret = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
> -
>         if (ret)
>                 return ret;
>
> @@ -1656,6 +1651,13 @@ static int __init kvm_mips_init(void)
>
>         register_die_notifier(&kvm_mips_csr_die_notifier);
>
> +       ret = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
> +
> +       if (ret) {
> +               unregister_die_notifier(&kvm_mips_csr_die_notifier);
> +               return ret;
> +       }
> +
>         return 0;
>  }
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e30493fe4553..9bc46c1e64d9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8254,6 +8254,15 @@ static void vmx_exit(void)
>  }
>  module_exit(vmx_exit);
>
> +/* initialize before kvm_init() so that hardware_enable/disable() can work. */
> +static void __init vmx_init_early(void)
> +{
> +       int cpu;
> +
> +       for_each_possible_cpu(cpu)
> +               INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> +}
> +
>  static int __init vmx_init(void)
>  {
>         int r, cpu;
> @@ -8291,6 +8300,7 @@ static int __init vmx_init(void)
>         }
>  #endif
>
> +       vmx_init_early();
>         r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
>                      __alignof__(struct vcpu_vmx), THIS_MODULE);
>         if (r)
> @@ -8309,11 +8319,8 @@ static int __init vmx_init(void)
>                 return r;
>         }
>
> -       for_each_possible_cpu(cpu) {
> -               INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> -
> +       for_each_possible_cpu(cpu)
>                 pi_init_cpu(cpu);
> -       }
>
>  #ifdef CONFIG_KEXEC_CORE
>         rcu_assign_pointer(crash_vmclear_loaded_vmcss,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ec365291c625..0ff03889aa5d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4883,8 +4883,13 @@ static void hardware_enable_nolock(void *junk)
>
>         cpumask_set_cpu(cpu, cpus_hardware_enabled);
>
> +       r = kvm_arch_check_processor_compat();
> +       if (r)
> +               goto out;
> +
>         r = kvm_arch_hardware_enable();
>
> +out:
>         if (r) {
>                 cpumask_clear_cpu(cpu, cpus_hardware_enabled);
>                 atomic_inc(&hardware_enable_failed);
> @@ -5681,11 +5686,6 @@ void kvm_unregister_perf_callbacks(void)
>  }
>  #endif
>
> -static void check_processor_compat(void *rtn)
> -{
> -       *(int *)rtn = kvm_arch_check_processor_compat();
> -}
> -
>  int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>                   struct module *module)
>  {
> @@ -5716,11 +5716,11 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>         if (r < 0)
>                 goto out_free_1;
>
> -       for_each_online_cpu(cpu) {
> -               smp_call_function_single(cpu, check_processor_compat, &r, 1);
> -               if (r < 0)
> -                       goto out_free_2;
> -       }
> +       /* hardware_enable_nolock() checks CPU compatibility on each CPUs. */
> +       r = hardware_enable_all();
> +       if (r)
> +               goto out_free_2;
> +       hardware_disable_all();
>
>         r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
>                                       kvm_starting_cpu, kvm_dying_cpu);
> --
> 2.25.1
>

Sagi
