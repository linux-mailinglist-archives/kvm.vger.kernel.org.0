Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146F351F3E4
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 07:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbiEIFho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 01:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232689AbiEIFgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 01:36:07 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C95B149169
        for <kvm@vger.kernel.org>; Sun,  8 May 2022 22:32:10 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id m2-20020a1ca302000000b003943bc63f98so7596389wme.4
        for <kvm@vger.kernel.org>; Sun, 08 May 2022 22:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LcfykvzzxOiiw+jUTB5oG4jSYC/kWrfsWiX4vYPyo9M=;
        b=kcIUmvvtYBneIxYWYiv7+ZFh4noeZ8Am8LxJbwy0tzXZr9y8d+KI/QsxlJYsuNmM08
         OGVALXNd+CoIDFW0iCeuANfBqIyQS40FLvfNaMi065NgKl77XGww480iffDwl6iePFnE
         /vJB/ZxTrHlkneSUP3qUDzxPQAp3k9HVD/gzvdtZ1VCKGBwXgKM82C1otDJIg0CsWkjK
         vsabX+kfPaNfmRig6dYdjkMY9DINlp5EnFbw/ugfF3n9ZVJn+hGULwm5aCit+DiPEilU
         PCSa4bC99EGefh/P+fD5m0E04J6FnoNl2PNtaY0heLJiAHpFynaawAWRjO/PVQgC5jjR
         TvSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LcfykvzzxOiiw+jUTB5oG4jSYC/kWrfsWiX4vYPyo9M=;
        b=Sfm17GXdW6nbuMzU2UHpcFPDkPijJsqTj4wVmz/1okOq3KkTuUWYd+8LIZkVIv24Te
         xcWgbZFnecV3KBkKh3qneWPybGDrzCfqfPXVUnF9v9efp4TvBwluYY+JXGsGy2cYyofg
         EfASSNzhjCXQ/NfAMmfR7hk8zZssMaMF12/9Z1v+ulMLn+N5Ra43p3sx5401ZtQ4M/Tf
         SXXshBc23PzgLGasoLbCjEuLDSS/RcNZnOmk2jCanJV4JpRCXa8hUV0eE4pdTnmLS183
         llDnGEm/WrJgHLuoK8RZXf68ebs4UrtO1/XhXBVqAmkcSi3bdYwTK/JEjNHpdIs24Xvp
         Uk1A==
X-Gm-Message-State: AOAM531J7ARs0OVu5d14fRz1+JpRDf9ITqqwmqFnEsJlr5Uup8pTZBGU
        f7QMwttCd2MQ69o+PCpNb5haGpZVSudv4c5nQ/UKQg==
X-Google-Smtp-Source: ABdhPJxcZ1/tgNOui63k7ToPoh6qdNSpLhheGOV0wgT4W9krBezLdETiXX52tCZksOb5ycmvbLFkw5ri8O5JCMC9+GA=
X-Received: by 2002:a05:600c:3caa:b0:394:8fb8:716 with SMTP id
 bg42-20020a05600c3caa00b003948fb80716mr3550006wmb.105.1652074328778; Sun, 08
 May 2022 22:32:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220420112450.155624-1-apatel@ventanamicro.com>
 <20220420112450.155624-3-apatel@ventanamicro.com> <CAOnJCUJ3KzJdqLa3zXUd+YEa00_W1P7aNWY0ibpvO9jaqarOtA@mail.gmail.com>
In-Reply-To: <CAOnJCUJ3KzJdqLa3zXUd+YEa00_W1P7aNWY0ibpvO9jaqarOtA@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 9 May 2022 11:01:57 +0530
Message-ID: <CAAhSdy1gyJekSvUtZ6TQutTryGATupjP3YEzEts-QJ_DifJVjw@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] RISC-V: KVM: Add Sv57x4 mode support for G-stage
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
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 4, 2022 at 7:44 AM Atish Patra <atishp@atishpatra.org> wrote:
>
> On Wed, Apr 20, 2022 at 4:25 AM Anup Patel <apatel@ventanamicro.com> wrote:
> >
> > Latest QEMU supports G-stage Sv57x4 mode so this patch extends KVM
> > RISC-V G-stage handling to detect and use Sv57x4 mode when available.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/csr.h |  1 +
> >  arch/riscv/kvm/main.c        |  3 +++
> >  arch/riscv/kvm/mmu.c         | 11 ++++++++++-
> >  3 files changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> > index e935f27b10fd..cc40521e438b 100644
> > --- a/arch/riscv/include/asm/csr.h
> > +++ b/arch/riscv/include/asm/csr.h
> > @@ -117,6 +117,7 @@
> >  #define HGATP_MODE_SV32X4      _AC(1, UL)
> >  #define HGATP_MODE_SV39X4      _AC(8, UL)
> >  #define HGATP_MODE_SV48X4      _AC(9, UL)
> > +#define HGATP_MODE_SV57X4      _AC(10, UL)
> >
> >  #define HGATP32_MODE_SHIFT     31
> >  #define HGATP32_VMID_SHIFT     22
> > diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> > index c374dad82eee..1549205fe5fe 100644
> > --- a/arch/riscv/kvm/main.c
> > +++ b/arch/riscv/kvm/main.c
> > @@ -105,6 +105,9 @@ int kvm_arch_init(void *opaque)
> >         case HGATP_MODE_SV48X4:
> >                 str = "Sv48x4";
> >                 break;
> > +       case HGATP_MODE_SV57X4:
> > +               str = "Sv57x4";
> > +               break;
> >         default:
> >                 return -ENODEV;
> >         }
> > diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> > index dc0520792e31..8823eb32dcde 100644
> > --- a/arch/riscv/kvm/mmu.c
> > +++ b/arch/riscv/kvm/mmu.c
> > @@ -751,14 +751,23 @@ void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu)
> >  void kvm_riscv_gstage_mode_detect(void)
> >  {
> >  #ifdef CONFIG_64BIT
> > +       /* Try Sv57x4 G-stage mode */
> > +       csr_write(CSR_HGATP, HGATP_MODE_SV57X4 << HGATP_MODE_SHIFT);
> > +       if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV57X4) {
> > +               gstage_mode = (HGATP_MODE_SV57X4 << HGATP_MODE_SHIFT);
> > +               gstage_pgd_levels = 5;
> > +               goto skip_sv48x4_test;
> > +       }
> > +
> >         /* Try Sv48x4 G-stage mode */
> >         csr_write(CSR_HGATP, HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
> >         if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV48X4) {
> >                 gstage_mode = (HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
> >                 gstage_pgd_levels = 4;
> >         }
> > -       csr_write(CSR_HGATP, 0);
> > +skip_sv48x4_test:
> >
> > +       csr_write(CSR_HGATP, 0);
> >         __kvm_riscv_hfence_gvma_all();
> >  #endif
> >  }
> > --
> > 2.25.1
> >
>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>

Queued this patch for 5.19

Thanks,
Anup

>
> --
> Regards,
> Atish
