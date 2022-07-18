Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB795779DD
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 06:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbiGREEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 00:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiGREEd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 00:04:33 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03A311C35
        for <kvm@vger.kernel.org>; Sun, 17 Jul 2022 21:04:28 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id a11so277485wmq.3
        for <kvm@vger.kernel.org>; Sun, 17 Jul 2022 21:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EsNHa5a7SYRE73Woad1Pm7o9hAag7TsYX0J/jHgYB7o=;
        b=g4VJ8tJfoUHwr0f7YDkQKkA2v6ULPwzVFzxffb3/pOBGZWeRc9VcpfIi8GgVh01apL
         EGkJik7CdGhR9BPWa8mqiVzx5QYd+vhhGjykJBI6EjIqzuxCyhDcApT2gdAhndSkjmOw
         Y7lydZUx1es+7aBOqRlgDjEGmQRUYTYX+YnrfmwWmdUkf1v5HHFLlFcVogRKXs4Vs9hj
         n8grMRfAXob3+G2SMsba001Dfuvtk27dCCVgZrkl2Xg8piE993Ccs7hvVSfUJFX6I87C
         ZGxeMqyKG9exBMjSphCcDQKjtwHGfSlKZz9HTxj9Cj9ApFho6snHsD+u7VXjKwpwzqJc
         OzPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EsNHa5a7SYRE73Woad1Pm7o9hAag7TsYX0J/jHgYB7o=;
        b=Olzaws6Mc84equafVWfQnJfFDqIpIVkS6bUc/Xr4xVLwXNXTWQYQ97G1+2JBIgR4Ox
         uQ7fRuMoCarl4Ty8rRJ2koRT2SElxkuwXD88AQeb9djN/cUvspLpOnYOvtHc4FHiobOr
         PWUUR59vaGEiY+yswDPmyx67BrNp/xQ67QQVskI/j2+UZ9iGZ4HhY9NRqayws9wIeXLH
         ZZqz2IdDTHKhr5q8FTZve7i/axMRaGUYUrwH5W8WTLoyuCi7YtG5VQiaUymukH5N/PT9
         MYPPZdRfAQkVp8zI7VKYQI0wjamPn17XgSJ4MjFO5yv4nJ7FR7wElqfN5iFHFMaY58ZQ
         BGuQ==
X-Gm-Message-State: AJIora+abN0PfY2xteO7WwI8fLaI9ChJNJ8cQcauFiNULN755MzyOP6h
        8FW6aCCZoKsCEnkVzT3Aydmvn0jc5WlKxYFzm1EsjlRoboo=
X-Google-Smtp-Source: AGRyM1uPK2XPDB2+i2fdHzYggyrdGIUO/R1IO1YCkIEJGgYoGsS7JVP4puAb7bkgO7oZNrpuaDKO9lthTTbezmNv0GQ=
X-Received: by 2002:a05:600c:3caa:b0:394:8fb8:716 with SMTP id
 bg42-20020a05600c3caa00b003948fb80716mr30056082wmb.105.1658117067083; Sun, 17
 Jul 2022 21:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220707145248.458771-1-apatel@ventanamicro.com>
 <20220707145248.458771-2-apatel@ventanamicro.com> <CAOnJCUKNaNz0iF5dfS9quRyDS_ZD1adWWAFjOnBPwqKEefpS8Q@mail.gmail.com>
In-Reply-To: <CAOnJCUKNaNz0iF5dfS9quRyDS_ZD1adWWAFjOnBPwqKEefpS8Q@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 18 Jul 2022 09:34:15 +0530
Message-ID: <CAAhSdy2rN4rrKep=P4W_hen_OsHR8USQ7xGH5=fKd-5_t8NTew@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: Add gfp_custom flag in struct kvm_mmu_memory_cache
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Atish Patra <atishp@atishpatra.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Wed, Jul 13, 2022 at 6:57 AM Atish Patra <atishp@atishpatra.org> wrote:
>
> On Thu, Jul 7, 2022 at 7:53 AM Anup Patel <apatel@ventanamicro.com> wrote:
> >
> > The kvm_mmu_topup_memory_cache() always uses GFP_KERNEL_ACCOUNT for
> > memory allocation which prevents it's use in atomic context. To address
> > this limitation of kvm_mmu_topup_memory_cache(), we add gfp_custom flag
> > in struct kvm_mmu_memory_cache. When the gfp_custom flag is set to some
> > GFP_xyz flags, the kvm_mmu_topup_memory_cache() will use that instead of
> > GFP_KERNEL_ACCOUNT.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  include/linux/kvm_types.h | 1 +
> >  virt/kvm/kvm_main.c       | 4 +++-
> >  2 files changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > index ac1ebb37a0ff..1dcfba68076a 100644
> > --- a/include/linux/kvm_types.h
> > +++ b/include/linux/kvm_types.h
> > @@ -87,6 +87,7 @@ struct gfn_to_pfn_cache {
> >  struct kvm_mmu_memory_cache {
> >         int nobjs;
> >         gfp_t gfp_zero;
> > +       gfp_t gfp_custom;
> >         struct kmem_cache *kmem_cache;
> >         void *objects[KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE];
> >  };
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index a49df8988cd6..e3a6f7647474 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -386,7 +386,9 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> >         if (mc->nobjs >= min)
> >                 return 0;
> >         while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> > -               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> > +               obj = mmu_memory_cache_alloc_obj(mc, (mc->gfp_custom) ?
> > +                                                mc->gfp_custom :
> > +                                                GFP_KERNEL_ACCOUNT);
> >                 if (!obj)
> >                         return mc->nobjs >= min ? 0 : -ENOMEM;
> >                 mc->objects[mc->nobjs++] = obj;
> > --
> > 2.34.1
> >
>
> Acked-by: Atish Patra <atishp@rivosinc.com>

I have queued this patch for 5.20.

Please let me know if you are not okay or need changes in this patch.

Thanks,
Anup
