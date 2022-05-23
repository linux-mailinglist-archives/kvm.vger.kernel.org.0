Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D95531879
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239494AbiEWSnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 14:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242934AbiEWSmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 14:42:40 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E43519C746
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 11:23:26 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id s5so18184658ljd.10
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 11:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JBE+c6B6mu+AU/hAc8TEq+k0wWV4teBbrl8ksLPajFc=;
        b=cWHVnC7SjbQmMEiVyXfCzVIwsV3Lh2RylQXtUjn75DQ9ceQTENt+WSdC1+qQPWw8yy
         SpilqZe8fjKZ2i4ZcQNVW/Xq0QMQ/FwJiZMkeGDFUTu5YZHSdHeRx8ieJzECO8muh3Bt
         krUpWLStrKeGzqo0aLvY1wu7oGH4X5EtBrO1MG9y4N5YbR+JT8IUm7O8vcYLqskmy1SI
         SCIaY6VoNwevl9WnTh6ITh4or1ZmLLZEXDOsmRxsiZdaqklvLnhpa5Uni3T3Rc7oytnp
         7WnKbUaItrZqB9NYSo6Dt90ETwk9rrSVO6HZU2Zkx4UZkTjinD/QFxrX+oYCwgEAlqZF
         moLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JBE+c6B6mu+AU/hAc8TEq+k0wWV4teBbrl8ksLPajFc=;
        b=Lf0efEbe5ZOQT/srJ+50KGJGIiSSbQUfxw7p5mECwRd4RqmPgDzukGZxLFt7DznpS5
         WYTvYpa83VZ2XQ6VlY2LMUg24iZn0ehM4XIUzGEW05/o/YZrwzeQGHNCyq84BBf/E0TD
         7ajeqVZzzr2nJZuhE1yhdOj/pz3XO16RExgBxfbOTZiwz53qjMj3sgE1mx64tgOpOIZY
         rke0anSQ8Shwx7ToQ1MkkzyjezEMwAqBPo4uLKSIPf5nyhqHJ5eKbnUgHXcZHyxtK79z
         3VnouF+u/q8D0Y5OTQ86We0AvM0jegZem00rvspIvMATZ7clgJ04BopnbGBSVQ1dQrjg
         aOFw==
X-Gm-Message-State: AOAM5315kIVlzuKSUv9Po9dZSWPPpnG57BhfLwH0aU0WCiCOLjTqJ8Eo
        pjIMcgpMTTQP/d3kS0jr+LMX0KHBfcUi5Nxsi6Xc0A==
X-Google-Smtp-Source: ABdhPJyNsj6lIr9f0L/th/WhKwBNwG+T8hd6N7+QYW7amPHZGMNM9aG5b3qM5eH0DKS98CKLvqIisTXtpNcpRY+gaWM=
X-Received: by 2002:a2e:9d93:0:b0:253:c9bd:288 with SMTP id
 c19-20020a2e9d93000000b00253c9bd0288mr13678056ljj.223.1653330204606; Mon, 23
 May 2022 11:23:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com> <20220516232138.1783324-22-dmatlack@google.com>
 <CAL715WJ5DVM-A8EFND0iQ-MH9nAhE3rvWdYWaEgRTCJEVeegRg@mail.gmail.com>
 <YovGUDrYZMZ7PXeY@google.com> <CALzav=fUTYGjDuWQxJusH4CzkEwGja-4xAmpqEOZdUfBftYwYw@mail.gmail.com>
 <CAL715WL8g4y=agnMCM7uX6dhBp1JdFKHOCcYsh-=HT0wF=sQUA@mail.gmail.com>
In-Reply-To: <CAL715WL8g4y=agnMCM7uX6dhBp1JdFKHOCcYsh-=HT0wF=sQUA@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 23 May 2022 11:22:57 -0700
Message-ID: <CALzav=dcFmkZsEBUWGECUQVzrE4TiF=eOxhRXW-XQ-_q4cXchA@mail.gmail.com>
Subject: Re: [PATCH v6 21/22] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 23, 2022 at 11:13 AM Mingwei Zhang <mizhang@google.com> wrote:
>
> On Mon, May 23, 2022 at 10:44 AM David Matlack <dmatlack@google.com> wrote:
> >
> > On Mon, May 23, 2022 at 10:37 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Fri, May 20, 2022, Mingwei Zhang wrote:
> > > > On Mon, May 16, 2022 at 4:24 PM David Matlack <dmatlack@google.com> wrote:
> > > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > > index e089db822c12..5e2e75014256 100644
> > > > > --- a/virt/kvm/kvm_main.c
> > > > > +++ b/virt/kvm/kvm_main.c
> > > > > @@ -369,14 +369,31 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> > > > >                 return (void *)__get_free_page(gfp_flags);
> > > > >  }
> > > > >
> > > > > -int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> > > > > +static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
> > > > >  {
> > > > > +       gfp_t gfp = GFP_KERNEL_ACCOUNT;
> > > > >         void *obj;
> > > > >
> > > > >         if (mc->nobjs >= min)
> > > > >                 return 0;
> > > > > -       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> > > > > -               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> > > > > +
> > > > > +       if (unlikely(!mc->objects)) {
> > > > > +               if (WARN_ON_ONCE(!capacity))
> > > > > +                       return -EIO;
> > > > > +
> > > > > +               mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
> > > > > +               if (!mc->objects)
> > > > > +                       return -ENOMEM;
> > > > > +
> > > > > +               mc->capacity = capacity;
> > > >
> > > > Do we want to ensure the minimum value of the capacity? I think
> > > > otherwise, we may more likely start using memory from GFP_ATOMIC if
> > > > the capacity is less than, say 5? But the minimum value seems related
> > > > to each cache type.
> > >
> > > Eh, if we specify a minimum, just make the arch default the minimum.  That way we
> > > avoid adding even more magic/arbitrary numbers.  E.g. for whatever reason, MIPS's
> > > default is '4'.
> >
> > I'm not exactly sure what you had in mind Mingwei. But there is a bug
> > in this code if min > capacity. This function will happily return 0
> > after filling up the cache, even though it did not allocate min
> > objects. The same bug existed before this patch if min >
> > ARRAY_SIZE(mc->objects). I can include a separate patch to fix this
> > bug (e.g. WARN and return -ENOMEM if min > capacity).
>
> oh, what I am saying is this one:
> https://elixir.bootlin.com/linux/latest/source/virt/kvm/kvm_main.c#L417
>
> If we are running out of kmem cache, then we start to use
> __GFP_ATOMIC, which should be avoided as much as we can? Since this
> patch parameterized the 'capacity', then to avoid the future usage
> where caller provides a too small value, maybe we could add a warning
> if the 'capacity' is too small, say, smaller than 40 (the default
> value)?

I'm not too worried about that. Callers of
kvm_mmu_topup_memory_cache() are responsible for passing in a min
value. It doesn't matter if capacity is a number lower than 40, as
long as kvm_mmu_topup_memory_cache() is able to allocate min objects,
the call is a success (and the GFP_ATOMIC fallback should never
trigger, and if it does, we'll get a WARN splat).

The only actual loophole I can spot is if capacity is less than min.
In that case topup will return 0 despite allocating less than min
objects. Again we'll still hit the GFP_ATOMIC and get a WARN splat,
but we can detect the problem in kvm_mmu_topup_memory_cache() which
will include the buggy callsite in the backtrace.

>
> The case of  'capacity' < min would be a more serious issue, that
> situation probably should never be allowed.
