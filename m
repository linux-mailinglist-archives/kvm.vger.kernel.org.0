Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9572467E71E
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 14:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbjA0Nx3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 08:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbjA0Nx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 08:53:28 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590017C70E
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 05:53:26 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id t10so5374297vsr.3
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 05:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RzUBqryTptYUzEfhbyg+Lbcb+hwacEV+TO0IK7LNXU8=;
        b=Nj0//xHZCol4X/4LoPRHBLp04mZ6EyoR6ifMGAJyZKXqDQ2DDO+UCVf7oXmiq8NKlv
         uZhMC6w+AZvGFtaDvUzwidx8Sj6lRH4ps0RND4mC75QLASrACcarZbZAwCO+OrbBgA2a
         g6FO/H9UpLopISqqI4EpbAT5FHiezaN0Fh8eq1vv3wpFDi1xJ1DxrF1FbWDGq1iQM8db
         jhsXmwcthCd/L7yBe0BjwKvAfI5jGJEJ22/YXzrIkm6RnhG1QA/BRHhzDOqjpj8yDCHA
         D4eYt52pTgdUF+rDhhr2qje3A/dPZp0eHCoQb4UOKqcPObAZwnduqaFfm0Ypw1PKn7gw
         EiTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RzUBqryTptYUzEfhbyg+Lbcb+hwacEV+TO0IK7LNXU8=;
        b=t3je/E3iT25IiZkFl0Ioco/j4AR4rkukPF0eXlLdheg6Qo3b+vS/mJTcs7lTdWb8sx
         LksmTEWLrgfQegNHwY+YrVR+tnm8q/SGG/YIAp/L5pOXa5qZOqGrbOFB5RTXZ7Gv9h7E
         +SDXQau3jYi3FQzyQXffl0mMSsBq9z3CP+CdfCDcnYvOsEEZdQ4gsBB4Aev7lry+tjd7
         mgG4mE0/AaJwb5De+g1UL0RpXjhPaU6rZ+GRbQujCzertFrMtNZmqxK/OkN4vigJczvQ
         gyye/z2hI0jzTzA9d+GWyx7dwVu/ME376Un97gusf+xtRGeTDqlAFPC5fB+t8d9aMCbj
         BYyA==
X-Gm-Message-State: AO0yUKX3AXINXx2j22EL9/y5SYNt70i76WuQw/Qsdw4k61tQIBAJ7mye
        l5u/mPCtrs8/kfWbk9vw5fVD/MTwfpKkZCVLHVNBLA==
X-Google-Smtp-Source: AK7set+G91Acv+61aPdZ7vz54qMR8TqpiXkerxphHeLdypTJtL9kTh+QKLLarGjOUcQbXe2xYcQWJXCbqIL8IuEg6ZM=
X-Received: by 2002:a05:6102:3098:b0:3ec:1029:9eae with SMTP id
 l24-20020a056102309800b003ec10299eaemr661243vsb.10.1674827605343; Fri, 27 Jan
 2023 05:53:25 -0800 (PST)
MIME-Version: 1.0
References: <20230112140304.1830648-1-apatel@ventanamicro.com>
 <20230112140304.1830648-4-apatel@ventanamicro.com> <20230126161147.6rewhfvlouqn4ual@orel>
In-Reply-To: <20230126161147.6rewhfvlouqn4ual@orel>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Fri, 27 Jan 2023 19:23:13 +0530
Message-ID: <CAK9=C2XzTdqXr+vWZ4Ua=HET1gvskAY+y9yFtGbmR2LGg87asQ@mail.gmail.com>
Subject: Re: [PATCH 3/7] RISC-V: KVM: Drop the _MASK suffix from hgatp.VMID
 mask defines
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 26, 2023 at 9:41 PM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Thu, Jan 12, 2023 at 07:33:00PM +0530, Anup Patel wrote:
> > The hgatp.VMID mask defines are used before shifting when extracting
> > VMID value from hgatp CSR value so based on the convention followed
> > in the other parts of asm/csr.h, the hgatp.VMID mask defines should
> > not have a _MASK suffix.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/csr.h | 8 ++++----
> >  arch/riscv/kvm/mmu.c         | 3 +--
> >  arch/riscv/kvm/vmid.c        | 4 ++--
> >  3 files changed, 7 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> > index d608dac4b19f..36d580528f90 100644
> > --- a/arch/riscv/include/asm/csr.h
> > +++ b/arch/riscv/include/asm/csr.h
> > @@ -131,12 +131,12 @@
> >
> >  #define HGATP32_MODE_SHIFT   31
> >  #define HGATP32_VMID_SHIFT   22
> > -#define HGATP32_VMID_MASK    _AC(0x1FC00000, UL)
> > +#define HGATP32_VMID         _AC(0x1FC00000, UL)
> >  #define HGATP32_PPN          _AC(0x003FFFFF, UL)
> >
> >  #define HGATP64_MODE_SHIFT   60
> >  #define HGATP64_VMID_SHIFT   44
> > -#define HGATP64_VMID_MASK    _AC(0x03FFF00000000000, UL)
> > +#define HGATP64_VMID         _AC(0x03FFF00000000000, UL)
> >  #define HGATP64_PPN          _AC(0x00000FFFFFFFFFFF, UL)
> >
> >  #define HGATP_PAGE_SHIFT     12
> > @@ -144,12 +144,12 @@
> >  #ifdef CONFIG_64BIT
> >  #define HGATP_PPN            HGATP64_PPN
> >  #define HGATP_VMID_SHIFT     HGATP64_VMID_SHIFT
> > -#define HGATP_VMID_MASK              HGATP64_VMID_MASK
> > +#define HGATP_VMID           HGATP64_VMID
> >  #define HGATP_MODE_SHIFT     HGATP64_MODE_SHIFT
> >  #else
> >  #define HGATP_PPN            HGATP32_PPN
> >  #define HGATP_VMID_SHIFT     HGATP32_VMID_SHIFT
> > -#define HGATP_VMID_MASK              HGATP32_VMID_MASK
> > +#define HGATP_VMID           HGATP32_VMID
> >  #define HGATP_MODE_SHIFT     HGATP32_MODE_SHIFT
> >  #endif
> >
> > diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> > index 34b57e0be2ef..034746638fa6 100644
> > --- a/arch/riscv/kvm/mmu.c
> > +++ b/arch/riscv/kvm/mmu.c
> > @@ -748,8 +748,7 @@ void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu)
> >       unsigned long hgatp = gstage_mode;
> >       struct kvm_arch *k = &vcpu->kvm->arch;
> >
> > -     hgatp |= (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) &
> > -              HGATP_VMID_MASK;
> > +     hgatp |= (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) & HGATP_VMID;
> >       hgatp |= (k->pgd_phys >> PAGE_SHIFT) & HGATP_PPN;
> >
> >       csr_write(CSR_HGATP, hgatp);
> > diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> > index 6cd93995fb65..6f4d4979a759 100644
> > --- a/arch/riscv/kvm/vmid.c
> > +++ b/arch/riscv/kvm/vmid.c
> > @@ -26,9 +26,9 @@ void kvm_riscv_gstage_vmid_detect(void)
> >
> >       /* Figure-out number of VMID bits in HW */
> >       old = csr_read(CSR_HGATP);
> > -     csr_write(CSR_HGATP, old | HGATP_VMID_MASK);
> > +     csr_write(CSR_HGATP, old | HGATP_VMID);
> >       vmid_bits = csr_read(CSR_HGATP);
> > -     vmid_bits = (vmid_bits & HGATP_VMID_MASK) >> HGATP_VMID_SHIFT;
> > +     vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
> >       vmid_bits = fls_long(vmid_bits);
> >       csr_write(CSR_HGATP, old);
> >
> > --
> > 2.34.1
> >
>
> Could switch to GENMASK too at the same time :-)

Okay, I will update.

>
> Anyway,
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>

Thanks,
Anup
