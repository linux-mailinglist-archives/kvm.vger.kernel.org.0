Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DEF61E8E0
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 04:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiKGDKh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 22:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiKGDKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 22:10:36 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F64DF8A
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 19:10:35 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id b2so26721916eja.6
        for <kvm@vger.kernel.org>; Sun, 06 Nov 2022 19:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H1pcoCub6KdV/gUz+piTr4fdj2mnlqaFRmHq36k4mN4=;
        b=gQpUBAHaNtCtn8GOZM6K3nOKU9i/513DHG6kPmdKabejoExXLL0yKmZoHWD5IqrYnl
         BaH7/MlZuQ3cd3geild3XN0vIjfsuogd3DRyazx76rKFD1GxN2z2p5a1MMzxdPc3wvTw
         RxZD99Kfh6hz1mjWaldEvMgnh1z6ZDZqqXsSWsYVIgeKGUPakiXDa4BTKTMvzBMhceI0
         p+2o9fYelNd1OGlcY0c89OLh4mpaR3Ph8Z8pNTcesJ5e6yXb/WhpmYapUPDUZmdETGBa
         YNDaSceGSYjG/bGEYOqsAJz81Hj8vvE+0OhEFfMoxQFcd4iiMCUDxLdOXI4/qhCe4BWK
         wETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H1pcoCub6KdV/gUz+piTr4fdj2mnlqaFRmHq36k4mN4=;
        b=n8SRZ92ibAEIlufmQrMEJYmcH0gW7nGe1zP9eqtutUdm223FnMf3D+KG7ZPZP+6zYs
         /BBQcOrssYxJhD6FJEc+ndiZfHZhNJUYdqX3npijW5eK6AIKNPDJjas3hwgsh2Qi548C
         T6buLsgPUZzsHhvMvTxWXKEDrnl+3VHXOxK350ljYbAnKMIWv50THiYjEOaJIyEuHI1h
         E/h9Yn5sXJwt9z80s0QFU4GViN3gyG5D6O/uD8z9jb6fRE2CSXG1vOcb2AZ/sMCwY2n6
         za/q1RXnqLkq7CjDRJ4XgGWOY4WHyDuccY48kLjYeZ7x5dmaksgYLIN8CTu4vjspiIxy
         CQPg==
X-Gm-Message-State: ACrzQf3w+yIGm6+nhN60dfgyaCIOvBJHl7x82j1trVUqlQbeEDi2rTbj
        YsLUGaLnJiEX9CyReu50OyRQOrekKo+ddkqVUf8Mzw==
X-Google-Smtp-Source: AMsMyM7XCgJtPlnLGfYx3eSoncGi1AE82N9qaj+trfvM6WmHPWkeWUQhOX2da2jCOnZnugZUPvknpt/SuEsv4imbUmY=
X-Received: by 2002:a17:906:eec7:b0:733:189f:b07a with SMTP id
 wu7-20020a170906eec700b00733189fb07amr46196816ejb.230.1667790626379; Sun, 06
 Nov 2022 19:10:26 -0800 (PST)
MIME-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com> <20221102231911.3107438-24-seanjc@google.com>
In-Reply-To: <20221102231911.3107438-24-seanjc@google.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 7 Nov 2022 08:40:14 +0530
Message-ID: <CAAhSdy1XSv+yNHyhPf44H3f7oaz+7Ku6COkKAQt7Zy7ahdC7jA@mail.gmail.com>
Subject: Re: [PATCH 23/44] KVM: RISC-V: Tag init functions and data with
 __init, __ro_after_init
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

On Thu, Nov 3, 2022 at 4:49 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Now that KVM setup is handled directly in riscv_kvm_init(), tag functions
> and data that are used/set only during init with __init/__ro_after_init.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Thanks,
Anup

> ---
>  arch/riscv/include/asm/kvm_host.h |  6 +++---
>  arch/riscv/kvm/mmu.c              | 12 ++++++------
>  arch/riscv/kvm/vmid.c             |  4 ++--
>  3 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 8c771fc4f5d2..778ff0f282b7 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -295,11 +295,11 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>  int kvm_riscv_gstage_alloc_pgd(struct kvm *kvm);
>  void kvm_riscv_gstage_free_pgd(struct kvm *kvm);
>  void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu);
> -void kvm_riscv_gstage_mode_detect(void);
> -unsigned long kvm_riscv_gstage_mode(void);
> +void __init kvm_riscv_gstage_mode_detect(void);
> +unsigned long __init kvm_riscv_gstage_mode(void);
>  int kvm_riscv_gstage_gpa_bits(void);
>
> -void kvm_riscv_gstage_vmid_detect(void);
> +void __init kvm_riscv_gstage_vmid_detect(void);
>  unsigned long kvm_riscv_gstage_vmid_bits(void);
>  int kvm_riscv_gstage_vmid_init(struct kvm *kvm);
>  bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid);
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 3620ecac2fa1..f42a34c7879a 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -20,12 +20,12 @@
>  #include <asm/pgtable.h>
>
>  #ifdef CONFIG_64BIT
> -static unsigned long gstage_mode = (HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
> -static unsigned long gstage_pgd_levels = 3;
> +static unsigned long gstage_mode __ro_after_init = (HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
> +static unsigned long gstage_pgd_levels __ro_after_init = 3;
>  #define gstage_index_bits      9
>  #else
> -static unsigned long gstage_mode = (HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
> -static unsigned long gstage_pgd_levels = 2;
> +static unsigned long gstage_mode __ro_after_init = (HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
> +static unsigned long gstage_pgd_levels __ro_after_init = 2;
>  #define gstage_index_bits      10
>  #endif
>
> @@ -760,7 +760,7 @@ void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu)
>                 kvm_riscv_local_hfence_gvma_all();
>  }
>
> -void kvm_riscv_gstage_mode_detect(void)
> +void __init kvm_riscv_gstage_mode_detect(void)
>  {
>  #ifdef CONFIG_64BIT
>         /* Try Sv57x4 G-stage mode */
> @@ -784,7 +784,7 @@ void kvm_riscv_gstage_mode_detect(void)
>  #endif
>  }
>
> -unsigned long kvm_riscv_gstage_mode(void)
> +unsigned long __init kvm_riscv_gstage_mode(void)
>  {
>         return gstage_mode >> HGATP_MODE_SHIFT;
>  }
> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> index 6cd93995fb65..5246da1c9167 100644
> --- a/arch/riscv/kvm/vmid.c
> +++ b/arch/riscv/kvm/vmid.c
> @@ -17,10 +17,10 @@
>
>  static unsigned long vmid_version = 1;
>  static unsigned long vmid_next;
> -static unsigned long vmid_bits;
> +static unsigned long vmid_bits __ro_after_init;
>  static DEFINE_SPINLOCK(vmid_lock);
>
> -void kvm_riscv_gstage_vmid_detect(void)
> +void __init kvm_riscv_gstage_vmid_detect(void)
>  {
>         unsigned long old;
>
> --
> 2.38.1.431.g37b22c650d-goog
>
