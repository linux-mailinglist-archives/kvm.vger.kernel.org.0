Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02F64B7E99
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 04:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243124AbiBPD0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 22:26:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238009AbiBPD0X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 22:26:23 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DBEFEB2E
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 19:26:10 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id bg21-20020a05600c3c9500b0035283e7a012so668097wmb.0
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 19:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jwhFIm2pjxqH4S1QMmhp69WD0Yx/q3G7DzS41sze+Fs=;
        b=riYhJ/NFDeUTP+27duj6KaHVTshaiOQWoiNe0wD5HsocnEG4P2zjeu1WJJDyF+7tg8
         HCeN+YgLtAuAqFdXC5u5r4J1kreE47Ve+t4e9Tzc3e/bR6dW6cfCEx+AULlAjs0UFA7b
         5iYtqizK/2DbwQ3MdQzFC5ShahlfHXfxfbRTyv3sjEKEHhbO96isAQ/oJlBBafJ4RfO6
         Ik2sa+YCrQVXyZRleWwPOmZS9xfiQMBjan/DE793V7AulbEAwpf909pO0yRuMLybh51Z
         HNPSzg49iXmvLcs5NFrZBcGz1w3jwq6ATwFOagq0fPdiZtS5k3qPuXa39lc6+Ewfq3Uz
         nhCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jwhFIm2pjxqH4S1QMmhp69WD0Yx/q3G7DzS41sze+Fs=;
        b=qX+jBXm9E4/WkPK+gM6zH95umJU3GUwkVSffryikIf3zlRS+98qhvlR/rJW9NuAw/u
         nO6lbUp7qG7aJ/CqDqLjzHtK2LiXXa95t/vtC33ChKaQhQk02Tj0M19qJZ7Ztj8OhdYT
         qV3xP0Lx0qEJs+FRwxzNkwuP+MMBbeWvKwmpQPDc6DDwADdERtBfDUTHH8gkV1q65Rca
         jWjsibry/zsH1Ilb2PWePhU7qwP/wwZVilgRq4gc7SUZwJsT+gavvG7ijpQgeGb3Q76T
         f7lsbSCkDEw+U2cKnS78L2UKFQB8bL2bPSGupE2dYQ0d2NDwQvpW5ouKKBZNBBRcW2Ys
         HlyA==
X-Gm-Message-State: AOAM533bilKDH8vBcnsiVPtefscNmeLigCcdVEvK3igoLSwRzwnOipWa
        bfURQleD9BR/fX7rMGREnRTISCXXEvhbYVTiQlMtwQ==
X-Google-Smtp-Source: ABdhPJyRrOhHG9NugLem/Yuo2TIr9R5jqud/r7I7SljQVLpVr4bWltjwldVI0/2cSoJTehq0BS93uj6Y8dpcZ9dYSY0=
X-Received: by 2002:a7b:cf16:0:b0:37b:c4c9:96c6 with SMTP id
 l22-20020a7bcf16000000b0037bc4c996c6mr683144wmg.59.1644981969162; Tue, 15 Feb
 2022 19:26:09 -0800 (PST)
MIME-Version: 1.0
References: <20220216031528.92558-1-chao.gao@intel.com> <20220216031528.92558-3-chao.gao@intel.com>
In-Reply-To: <20220216031528.92558-3-chao.gao@intel.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 16 Feb 2022 08:55:55 +0530
Message-ID: <CAAhSdy0PfCegu9vQY76pD-cLfP_S1xnyWARdinG4jbuJ_eVQkg@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] Partially revert "KVM: Pass kvm_init()'s opaque
 param to additional arch funcs"
To:     Chao Gao <chao.gao@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        KVM General <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kevin.tian@intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 16, 2022 at 8:46 AM Chao Gao <chao.gao@intel.com> wrote:
>
> This partially reverts commit b99040853738 ("KVM: Pass kvm_init()'s opaque
> param to additional arch funcs") remove opaque from
> kvm_arch_check_processor_compat because no one uses this opaque now.
> Address conflicts for ARM (due to file movement) and manually handle RISC-V
> which comes after the commit.
>
> And changes about kvm_arch_hardware_setup() in original commit are still
> needed so they are not reverted.
>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup


> ---
>  arch/arm64/kvm/arm.c       |  2 +-
>  arch/mips/kvm/mips.c       |  2 +-
>  arch/powerpc/kvm/powerpc.c |  2 +-
>  arch/riscv/kvm/main.c      |  2 +-
>  arch/s390/kvm/kvm-s390.c   |  2 +-
>  arch/x86/kvm/x86.c         |  2 +-
>  include/linux/kvm_host.h   |  2 +-
>  virt/kvm/kvm_main.c        | 16 +++-------------
>  8 files changed, 10 insertions(+), 20 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index ecc5958e27fe..0165cf3aac3a 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -73,7 +73,7 @@ int kvm_arch_hardware_setup(void *opaque)
>         return 0;
>  }
>
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>  {
>         return 0;
>  }
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index a25e0b73ee70..092d09fb6a7e 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -140,7 +140,7 @@ int kvm_arch_hardware_setup(void *opaque)
>         return 0;
>  }
>
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>  {
>         return 0;
>  }
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 2ad0ccd202d5..30c817f3fa0c 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -423,7 +423,7 @@ int kvm_arch_hardware_setup(void *opaque)
>         return 0;
>  }
>
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>  {
>         return kvmppc_core_check_processor_compat();
>  }
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index 2e5ca43c8c49..992877e78393 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -20,7 +20,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
>         return -EINVAL;
>  }
>
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>  {
>         return 0;
>  }
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 577f1ead6a51..0053b81c6b02 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -252,7 +252,7 @@ int kvm_arch_hardware_enable(void)
>         return 0;
>  }
>
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>  {
>         return 0;
>  }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9b484ed61f37..ffb88f0b7265 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11509,7 +11509,7 @@ void kvm_arch_hardware_unsetup(void)
>         static_call(kvm_x86_hardware_unsetup)();
>  }
>
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>  {
>         struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f11039944c08..2ad78e729bf7 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1413,7 +1413,7 @@ int kvm_arch_hardware_enable(void);
>  void kvm_arch_hardware_disable(void);
>  int kvm_arch_hardware_setup(void *opaque);
>  void kvm_arch_hardware_unsetup(void);
> -int kvm_arch_check_processor_compat(void *opaque);
> +int kvm_arch_check_processor_compat(void);
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
>  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
>  int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 83c57bcc6eb6..ee47d33d69e1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5643,22 +5643,14 @@ void kvm_unregister_perf_callbacks(void)
>  }
>  #endif
>
> -struct kvm_cpu_compat_check {
> -       void *opaque;
> -       int *ret;
> -};
> -
> -static void check_processor_compat(void *data)
> +static void check_processor_compat(void *rtn)
>  {
> -       struct kvm_cpu_compat_check *c = data;
> -
> -       *c->ret = kvm_arch_check_processor_compat(c->opaque);
> +       *(int *)rtn = kvm_arch_check_processor_compat();
>  }
>
>  int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>                   struct module *module)
>  {
> -       struct kvm_cpu_compat_check c;
>         int r;
>         int cpu;
>
> @@ -5686,10 +5678,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>         if (r < 0)
>                 goto out_free_1;
>
> -       c.ret = &r;
> -       c.opaque = opaque;
>         for_each_online_cpu(cpu) {
> -               smp_call_function_single(cpu, check_processor_compat, &c, 1);
> +               smp_call_function_single(cpu, check_processor_compat, &r, 1);
>                 if (r < 0)
>                         goto out_free_2;
>         }
> --
> 2.25.1
>
