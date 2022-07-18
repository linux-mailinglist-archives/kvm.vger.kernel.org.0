Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2169E5779E0
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 06:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiGREHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 00:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiGREHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 00:07:03 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A5811C3A
        for <kvm@vger.kernel.org>; Sun, 17 Jul 2022 21:06:59 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id e15so10001666wro.5
        for <kvm@vger.kernel.org>; Sun, 17 Jul 2022 21:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QqKqAsiuT2ci7oRoFpphbORkfNF9Sqdp2GAmlBxKgV4=;
        b=k6u7OoZnhtF2M0wYb5Ye/+qhGhYm0AWbwVrohe57R7ni8v92EpBP6R6TjsbolXypA1
         AahSW2NhR1X7hhjzZjDIVC1DS2dWM5MmBjEby9TCxPFmNmL4Vo+TyrPWxTa0+44/FwmY
         VjLl3xocn+U42excfVnEy/r1Kc3XhiuwTM3cGalvwKUnyPx9xyXsWSklura+LdvJsnRM
         WByOWuo2kWAzegVNbvKWRuw/KacEQwRwk0U2mgwy5YlYqR7u7qh1ltkCgYnus6yoYbgU
         hQTa7H9PdHBRC6Db+cZ9mxT//oY9oKI7poriDZ8xYHHrJ9lOUEVRnBoAaglE3EoiGBTO
         yI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QqKqAsiuT2ci7oRoFpphbORkfNF9Sqdp2GAmlBxKgV4=;
        b=GzTmU8Xxs5hUzhAcan4y7zk6hJMz9rlET5sV/Hzn+MoGxlBpiGCNZA6jTJxJSy7FwH
         rj0hgiyBMZPRB7lCbXm/Q0emnGh4BHWERg4QwweB5/VynLM7+tO16jrKhngocQjK/mgc
         YeEhNT5f8tUF6Sbo0RJgFLTYHahVo9hNHY3ZFDMT3NdR/5rpUiysDb/IjJUXCaK2P6GI
         wpVn1/N1sShTOBHoWXeqxSEH7wneTn49u1LyYbiWCpItHY0pey9Pp4gyTnxroV8oumou
         5cI29p6/UgQ4BCwjZcpEev+DK9/AWH5kWgzSN0HcfbrKSSLvSfHu09FY40pI6BkSZfwX
         MEXA==
X-Gm-Message-State: AJIora+DWpPgj4l75Ydw5Pg7wMKPlgKcTWpvl3UjJj/Qp4dkfwbYuy8Y
        fOUfHBZKj91rbmfeOWBNPW9+WtP0zLahD6H+to/Fcw==
X-Google-Smtp-Source: AGRyM1s+p/AHIWOyiFZ9AUYgPg2KUVC5CRbMvj1HvlqIf98hSHNCbUqdpykA32xYLeeKZqwM9lbiIuUv3Hc14M7gIAw=
X-Received: by 2002:a5d:67c4:0:b0:21d:6d91:7b1a with SMTP id
 n4-20020a5d67c4000000b0021d6d917b1amr20926351wrw.313.1658117218369; Sun, 17
 Jul 2022 21:06:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220707145248.458771-1-apatel@ventanamicro.com>
 <20220707145248.458771-4-apatel@ventanamicro.com> <CAOnJCU++MsxgPyGqumWMLrB7ihDk3UmzwwD_voW0Rfnf-BVPWQ@mail.gmail.com>
In-Reply-To: <CAOnJCU++MsxgPyGqumWMLrB7ihDk3UmzwwD_voW0Rfnf-BVPWQ@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 18 Jul 2022 09:36:46 +0530
Message-ID: <CAAhSdy2fbr-GtYNYgCW5Y3xCvxx7Cworev5q+xtpYhDJzd=sqg@mail.gmail.com>
Subject: Re: [PATCH 3/5] RISC-V: KVM: Add G-stage ioremap() and iounmap() functions
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 13, 2022 at 6:56 AM Atish Patra <atishp@atishpatra.org> wrote:
>
> On Thu, Jul 7, 2022 at 7:53 AM Anup Patel <apatel@ventanamicro.com> wrote:
> >
> > The in-kernel AIA IMSIC support requires on-demand mapping / unmapping
> > of Guest IMSIC address to Host IMSIC guest files. To help achieve this,
> > we add kvm_riscv_stage2_ioremap() and kvm_riscv_stage2_iounmap()
> > functions. These new functions for updating G-stage page table mappings
> > will be called in atomic context so we have special "in_atomic" parameter
> > for this purpose.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/kvm_host.h |  5 +++++
> >  arch/riscv/kvm/mmu.c              | 18 ++++++++++++++----
> >  2 files changed, 19 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> > index 59a0cf2ca7b9..60c517e4d576 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -284,6 +284,11 @@ void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
> >  void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
> >                                unsigned long hbase, unsigned long hmask);
> >
> > +int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
> > +                            phys_addr_t hpa, unsigned long size,
> > +                            bool writable, bool in_atomic);
> > +void kvm_riscv_gstage_iounmap(struct kvm *kvm, gpa_t gpa,
> > +                             unsigned long size);
> >  int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
> >                          struct kvm_memory_slot *memslot,
> >                          gpa_t gpa, unsigned long hva, bool is_write);
> > diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> > index b75d4e200064..f7862ca4c4c6 100644
> > --- a/arch/riscv/kvm/mmu.c
> > +++ b/arch/riscv/kvm/mmu.c
> > @@ -343,8 +343,9 @@ static void gstage_wp_memory_region(struct kvm *kvm, int slot)
> >         kvm_flush_remote_tlbs(kvm);
> >  }
> >
> > -static int gstage_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
> > -                         unsigned long size, bool writable)
> > +int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
> > +                            phys_addr_t hpa, unsigned long size,
> > +                            bool writable, bool in_atomic)
> >  {
> >         pte_t pte;
> >         int ret = 0;
> > @@ -353,6 +354,7 @@ static int gstage_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
> >         struct kvm_mmu_memory_cache pcache;
> >
> >         memset(&pcache, 0, sizeof(pcache));
> > +       pcache.gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0;
> >         pcache.gfp_zero = __GFP_ZERO;
> >
> >         end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
> > @@ -382,6 +384,13 @@ static int gstage_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
> >         return ret;
> >  }
> >
> > +void kvm_riscv_gstage_iounmap(struct kvm *kvm, gpa_t gpa, unsigned long size)
> > +{
> > +       spin_lock(&kvm->mmu_lock);
> > +       gstage_unmap_range(kvm, gpa, size, false);
> > +       spin_unlock(&kvm->mmu_lock);
> > +}
> > +
> >  void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> >                                              struct kvm_memory_slot *slot,
> >                                              gfn_t gfn_offset,
> > @@ -517,8 +526,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
> >                                 goto out;
> >                         }
> >
> > -                       ret = gstage_ioremap(kvm, gpa, pa,
> > -                                            vm_end - vm_start, writable);
> > +                       ret = kvm_riscv_gstage_ioremap(kvm, gpa, pa,
> > +                                                      vm_end - vm_start,
> > +                                                      writable, false);
> >                         if (ret)
> >                                 break;
> >                 }
> > --
> > 2.34.1
> >
>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>

Queued this patch for 5.20.

Thanks,
Anup
