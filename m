Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D020361E977
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 04:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiKGDQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 22:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbiKGDPq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 22:15:46 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C91F12D00
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 19:13:38 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id bj12so26644102ejb.13
        for <kvm@vger.kernel.org>; Sun, 06 Nov 2022 19:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSzSSykdSUMY4z4QifNhRv3KUDv6uVGdlzhODRpQKlU=;
        b=Q5Al979g3+9Gavat8UlkB2Vleew+RmRbxdo+12K5r30eUrjF3YlGq0gOgvyYiLB3mt
         xgUU5ersVZgrB7+2jJY/bYXwsyIwwhtdWpcjxIdfzpDR5elbZNcB3K1l5DpUeR+BlciO
         idhic3khR724h6Kur7YB5I6R8BRlRfSrPOCcVMYpVLmUdl3EmI7WB0tcku7Xie02geae
         eDiGCrNsXaCEqHNBI+afAsQfH8ga4ziKwv6dMs7TpaKnqLBYnx3mO1Kmkb76PW7I4nHp
         zTYmmE0IV6+5AUD6cMBbhksIlq29dbZUxDj36O2JK9+DFGax2INM4cuyGR/ddy4VkTs8
         0+GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZSzSSykdSUMY4z4QifNhRv3KUDv6uVGdlzhODRpQKlU=;
        b=UgFZBjaGAEAcTe7kheiSFo9CTAgljKecFEimYXisx/CgWE7uqlFglW6Zrf7XKdenqr
         o7/tH0BQ9SqNukGvgNh3/yQ86Ksy8FU3KrkywWZqgJh2NC2jDtGQpb1EGAozdvjLgMHn
         04tr2FCy0zBDcXuGJCNYvnKwlXAZdxejl9y93oq9uR3RoILD9pQ9JjxTa6CLyf3OtuyU
         SYcjL9R+3baRr695fJHnzmGmz/cCuJPLXv7XSbz/PTYBPs3uhEqR0x5sgZp2rJVLY8SG
         BTApT5l4gNYH6UpspbnxLGzYF2tHjI+OJ6qTZdQjfTINDmEjN7ByYwK36YjKJdLlOg3D
         9//w==
X-Gm-Message-State: ACrzQf2NFbzYV+eMa1iwElH5pHE/rRZhXReZCXbnK7ui7tGEfmXacGNq
        qaSlsP9WDAawc26QyhXtTK4Bfx/zfGOMY5fmh6y0Zw==
X-Google-Smtp-Source: AMsMyM7D2DoscbPAWYNYytpiXrSBqYxlapsLxGuKk8BIHT4WrARNfmGmCFDOprFU5TU26yMJOep8BKHwirYzuxZh2l8=
X-Received: by 2002:a17:906:dac8:b0:741:545b:796a with SMTP id
 xi8-20020a170906dac800b00741545b796amr45641186ejb.240.1667790817058; Sun, 06
 Nov 2022 19:13:37 -0800 (PST)
MIME-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com> <20221102231911.3107438-28-seanjc@google.com>
In-Reply-To: <20221102231911.3107438-28-seanjc@google.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 7 Nov 2022 08:43:25 +0530
Message-ID: <CAAhSdy0NME71v2QMBWG-OFn1LLvGVZ=Gvadfiw70+OpZ2uLdPQ@mail.gmail.com>
Subject: Re: [PATCH 27/44] KVM: Drop kvm_arch_{init,exit}() hooks
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
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 3, 2022 at 4:50 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Drop kvm_arch_init() and kvm_arch_exit() now that all implementations
> are nops.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Thanks,
Anup

> ---
>  arch/arm64/kvm/arm.c                | 11 -----------
>  arch/mips/kvm/mips.c                | 10 ----------
>  arch/powerpc/include/asm/kvm_host.h |  1 -
>  arch/powerpc/kvm/powerpc.c          |  5 -----
>  arch/riscv/kvm/main.c               |  9 ---------
>  arch/s390/kvm/kvm-s390.c            | 10 ----------
>  arch/x86/kvm/x86.c                  | 10 ----------
>  include/linux/kvm_host.h            |  3 ---
>  virt/kvm/kvm_main.c                 | 19 ++-----------------
>  9 files changed, 2 insertions(+), 76 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 6e0061eac627..75c5125b0dd3 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2284,17 +2284,6 @@ static __init int kvm_arm_init(void)
>         return err;
>  }
>
> -int kvm_arch_init(void *opaque)
> -{
> -       return 0;
> -}
> -
> -/* NOP: Compiling as a module not supported */
> -void kvm_arch_exit(void)
> -{
> -
> -}
> -
>  static int __init early_kvm_mode_cfg(char *arg)
>  {
>         if (!arg)
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index ae7a24342fdf..3cade648827a 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -1010,16 +1010,6 @@ long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>         return r;
>  }
>
> -int kvm_arch_init(void *opaque)
> -{
> -       return 0;
> -}
> -
> -void kvm_arch_exit(void)
> -{
> -
> -}
> -
>  int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
>                                   struct kvm_sregs *sregs)
>  {
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 5d2c3a487e73..0a80e80c7b9e 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -881,7 +881,6 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
>  static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> -static inline void kvm_arch_exit(void) {}
>  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 36c27381a769..34278042ad27 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -2525,11 +2525,6 @@ void kvmppc_init_lpid(unsigned long nr_lpids_param)
>  }
>  EXPORT_SYMBOL_GPL(kvmppc_init_lpid);
>
> -int kvm_arch_init(void *opaque)
> -{
> -       return 0;
> -}
> -
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ppc_instr);
>
>  void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index cb063b8a9a0f..4710a6751687 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -65,15 +65,6 @@ void kvm_arch_hardware_disable(void)
>         csr_write(CSR_HIDELEG, 0);
>  }
>
> -int kvm_arch_init(void *opaque)
> -{
> -       return 0;
> -}
> -
> -void kvm_arch_exit(void)
> -{
> -}
> -
>  static int __init riscv_kvm_init(void)
>  {
>         const char *str;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index f6ae845bc1c1..7c1c6d81b5d7 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -533,16 +533,6 @@ static void __kvm_s390_exit(void)
>         debug_unregister(kvm_s390_dbf_uv);
>  }
>
> -int kvm_arch_init(void *opaque)
> -{
> -       return 0;
> -}
> -
> -void kvm_arch_exit(void)
> -{
> -
> -}
> -
>  /* Section: device related */
>  long kvm_arch_dev_ioctl(struct file *filp,
>                         unsigned int ioctl, unsigned long arg)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 218707597bea..2b4530a33298 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9271,16 +9271,6 @@ static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
>         kvm_pmu_ops_update(ops->pmu_ops);
>  }
>
> -int kvm_arch_init(void *opaque)
> -{
> -       return 0;
> -}
> -
> -void kvm_arch_exit(void)
> -{
> -
> -}
> -
>  static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  {
>         u64 host_pat;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9b52bd40be56..6c2a28c4c684 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1423,9 +1423,6 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>                                         struct kvm_guest_debug *dbg);
>  int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu);
>
> -int kvm_arch_init(void *opaque);
> -void kvm_arch_exit(void);
> -
>  void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
>
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 27ce263a80e4..17c852cb6842 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5833,20 +5833,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>         int r;
>         int cpu;
>
> -       /*
> -        * FIXME: Get rid of kvm_arch_init(), vendor code should call arch code
> -        * directly.  Note, kvm_arch_init() _must_ be called before anything
> -        * else as x86 relies on checks buried in kvm_arch_init() to guard
> -        * against multiple calls to kvm_init().
> -        */
> -       r = kvm_arch_init(opaque);
> -       if (r)
> -               return r;
> -
> -       if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
> -               r = -ENOMEM;
> -               goto err_hw_enabled;
> -       }
> +       if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL))
> +               return -ENOMEM;
>
>         c.ret = &r;
>         c.opaque = opaque;
> @@ -5934,8 +5922,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>         cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
>  out_free_2:
>         free_cpumask_var(cpus_hardware_enabled);
> -err_hw_enabled:
> -       kvm_arch_exit();
>         return r;
>  }
>  EXPORT_SYMBOL_GPL(kvm_init);
> @@ -5963,7 +5949,6 @@ void kvm_exit(void)
>         on_each_cpu(hardware_disable_nolock, NULL, 1);
>         kvm_irqfd_exit();
>         free_cpumask_var(cpus_hardware_enabled);
> -       kvm_arch_exit();
>  }
>  EXPORT_SYMBOL_GPL(kvm_exit);
>
> --
> 2.38.1.431.g37b22c650d-goog
>
