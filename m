Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AD661E8C3
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 04:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiKGDBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 22:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiKGDBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 22:01:17 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CF9DF55
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 19:01:15 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id n12so26627271eja.11
        for <kvm@vger.kernel.org>; Sun, 06 Nov 2022 19:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JlY2OstXwROXIDpT6VsXnJfzUqv1irH1Acsts2GGjpg=;
        b=wH7KmpU7jVwmAquM9Wvk3ttImj9+lvZI8Rxq1i6YYsElC8cWksh48ZwROArAULlZ7C
         tWe8M8ahyJHdHwo2Ck68YVw1aHJ/MLoYcQlrnfABVok8QpmzXxG1ffcBMZXcH6h5LAvm
         0tBbIsqoRxCX/KnzpT+CYyHXfKhw4foQW6+Ax6UY2aF+XO4GKByYk/PtdVxGB2RT0Fbu
         ysRYJ78VJd30TMAFhUzwFf/xZ7AJ2g1baQLCe9iqAVhA1Yqqkk67FLLNxduytkqwDB7v
         JP5zJ/Gyoc7JfJxpc+R8WHDqVMk2NzGLLCgzvKh3qN6XuvMHVMMnDXEN4atLvrkjLInL
         jZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JlY2OstXwROXIDpT6VsXnJfzUqv1irH1Acsts2GGjpg=;
        b=hs4/I7hcaNMIOv9uKZrIInMzrOwzNlwsIU6MaBsRgnl3dslQv8CCEqS6GlnSEibYx+
         mh5DwY9QEj1lxqnn9iTuN4sBboCurZshVjjfU6FZWvpSCkeyHTGyKzey4QPJDl7cC8kJ
         RWpQ8QLGfxc2enbIPVHVVu0ZPVRI47Qy2go9wNGGaOf/S9tnCnmj4I/0h+Ap06PrhpLi
         pKbqPfomme7Bpg7RSYl6nXL7qUzktpvtaaBlEnqo3imfAFamb2ppjC1Rzqyf6t6juhLc
         V5ghhCzowzhlgRUYseF82fcCzuWLXwf1Gozj5RXct0o0PFBctZ+QC9zYt/IbsXHapunY
         KPGg==
X-Gm-Message-State: ACrzQf3O8Xb+yaEbSq9ByO8uQTUUy1G0MuhoANwHjDywt4heNv2lAAGk
        hvpEU5cZALIz7sdAzIQd1bxzMU0smM5pLN0XOGDVGg==
X-Google-Smtp-Source: AMsMyM6JBSnXu9W+mu2GHeFQ3pcqBebFarC8BvVQZEanz3Zu4tMlcAMijwZHL0jNoTpD/MpfGKS3dVLLizMbV1pDGog=
X-Received: by 2002:a17:906:dac8:b0:741:545b:796a with SMTP id
 xi8-20020a170906dac800b00741545b796amr45605430ejb.240.1667790073283; Sun, 06
 Nov 2022 19:01:13 -0800 (PST)
MIME-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com> <20221102231911.3107438-10-seanjc@google.com>
In-Reply-To: <20221102231911.3107438-10-seanjc@google.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 7 Nov 2022 08:31:01 +0530
Message-ID: <CAAhSdy10dC+_S5PZ=QziYqVJKHh6Gi6D0H0C7GSsxWdFVrTQjA@mail.gmail.com>
Subject: Re: [PATCH 09/44] KVM: Drop arch hardware (un)setup hooks
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 3, 2022 at 4:49 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Drop kvm_arch_hardware_setup() and kvm_arch_hardware_unsetup() now that
> all implementations are nops.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Thanks,
Anup

> ---
>  arch/arm64/include/asm/kvm_host.h   |  1 -
>  arch/arm64/kvm/arm.c                |  5 -----
>  arch/mips/include/asm/kvm_host.h    |  1 -
>  arch/mips/kvm/mips.c                |  5 -----
>  arch/powerpc/include/asm/kvm_host.h |  1 -
>  arch/powerpc/kvm/powerpc.c          |  5 -----
>  arch/riscv/include/asm/kvm_host.h   |  1 -
>  arch/riscv/kvm/main.c               |  5 -----
>  arch/s390/kvm/kvm-s390.c            | 10 ----------
>  arch/x86/kvm/x86.c                  | 10 ----------
>  include/linux/kvm_host.h            |  2 --
>  virt/kvm/kvm_main.c                 |  7 -------
>  12 files changed, 53 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 45e2136322ba..5d5a887e63a5 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -859,7 +859,6 @@ static inline bool kvm_system_needs_idmapped_vectors(void)
>
>  void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
>
> -static inline void kvm_arch_hardware_unsetup(void) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 94d33e296e10..2ee729f54ce0 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -63,11 +63,6 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>         return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
>  }
>
> -int kvm_arch_hardware_setup(void *opaque)
> -{
> -       return 0;
> -}
> -
>  int kvm_arch_check_processor_compat(void *opaque)
>  {
>         return 0;
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 5cedb28e8a40..28f0ba97db71 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -888,7 +888,6 @@ extern unsigned long kvm_mips_get_ramsize(struct kvm *kvm);
>  extern int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
>                              struct kvm_mips_interrupt *irq);
>
> -static inline void kvm_arch_hardware_unsetup(void) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_free_memslot(struct kvm *kvm,
>                                          struct kvm_memory_slot *slot) {}
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index a25e0b73ee70..af29490d9740 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -135,11 +135,6 @@ void kvm_arch_hardware_disable(void)
>         kvm_mips_callbacks->hardware_disable();
>  }
>
> -int kvm_arch_hardware_setup(void *opaque)
> -{
> -       return 0;
> -}
> -
>  int kvm_arch_check_processor_compat(void *opaque)
>  {
>         return 0;
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index caea15dcb91d..5d2c3a487e73 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -877,7 +877,6 @@ struct kvm_vcpu_arch {
>  #define __KVM_HAVE_CREATE_DEVICE
>
>  static inline void kvm_arch_hardware_disable(void) {}
> -static inline void kvm_arch_hardware_unsetup(void) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
>  static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index b850b0efa201..74ea5687ecbc 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -441,11 +441,6 @@ int kvm_arch_hardware_enable(void)
>         return 0;
>  }
>
> -int kvm_arch_hardware_setup(void *opaque)
> -{
> -       return 0;
> -}
> -
>  int kvm_arch_check_processor_compat(void *opaque)
>  {
>         return kvmppc_core_check_processor_compat();
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index dbbf43d52623..8c771fc4f5d2 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -229,7 +229,6 @@ struct kvm_vcpu_arch {
>         bool pause;
>  };
>
> -static inline void kvm_arch_hardware_unsetup(void) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index df2d8716851f..a146fa0ce4d2 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -25,11 +25,6 @@ int kvm_arch_check_processor_compat(void *opaque)
>         return 0;
>  }
>
> -int kvm_arch_hardware_setup(void *opaque)
> -{
> -       return 0;
> -}
> -
>  int kvm_arch_hardware_enable(void)
>  {
>         unsigned long hideleg, hedeleg;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 1aaee15211f2..7fcd2d3b3558 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -321,16 +321,6 @@ static struct notifier_block kvm_clock_notifier = {
>         .notifier_call = kvm_clock_sync,
>  };
>
> -int kvm_arch_hardware_setup(void *opaque)
> -{
> -       return 0;
> -}
> -
> -void kvm_arch_hardware_unsetup(void)
> -{
> -
> -}
> -
>  static void allow_cpu_feat(unsigned long nr)
>  {
>         set_bit_inv(nr, kvm_s390_available_cpu_feat);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 80ee580a9cd4..40d4bfaa17a4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11985,16 +11985,6 @@ void kvm_arch_hardware_disable(void)
>         drop_user_return_notifiers();
>  }
>
> -int kvm_arch_hardware_setup(void *opaque)
> -{
> -       return 0;
> -}
> -
> -void kvm_arch_hardware_unsetup(void)
> -{
> -
> -}
> -
>  int kvm_arch_check_processor_compat(void *opaque)
>  {
>         struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 18592bdf4c1b..9b52bd40be56 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1447,8 +1447,6 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
>
>  int kvm_arch_hardware_enable(void);
>  void kvm_arch_hardware_disable(void);
> -int kvm_arch_hardware_setup(void *opaque);
> -void kvm_arch_hardware_unsetup(void);
>  int kvm_arch_check_processor_compat(void *opaque);
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
>  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f592dd4ce8f2..27ce263a80e4 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5843,10 +5843,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>         if (r)
>                 return r;
>
> -       r = kvm_arch_hardware_setup(opaque);
> -       if (r < 0)
> -               goto err_hw_setup;
> -
>         if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
>                 r = -ENOMEM;
>                 goto err_hw_enabled;
> @@ -5939,8 +5935,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  out_free_2:
>         free_cpumask_var(cpus_hardware_enabled);
>  err_hw_enabled:
> -       kvm_arch_hardware_unsetup();
> -err_hw_setup:
>         kvm_arch_exit();
>         return r;
>  }
> @@ -5969,7 +5963,6 @@ void kvm_exit(void)
>         on_each_cpu(hardware_disable_nolock, NULL, 1);
>         kvm_irqfd_exit();
>         free_cpumask_var(cpus_hardware_enabled);
> -       kvm_arch_hardware_unsetup();
>         kvm_arch_exit();
>  }
>  EXPORT_SYMBOL_GPL(kvm_exit);
> --
> 2.38.1.431.g37b22c650d-goog
>
