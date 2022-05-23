Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87CC5317F8
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239851AbiEWSfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 14:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241067AbiEWSfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 14:35:21 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA0D15A3E2
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 11:13:44 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id f35so500241qtb.11
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 11:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9HFX9sjl+4VLRtd7vfZP8e0JAPWXxyf7EQ+egr1dfcA=;
        b=XmbHC6s54toCVJhe+r/t0oUqEEo6vDWi/pHAZbCRT05gdM7142NZCPkCgjNSbDneXa
         2HpkmYLGn+24ofjOzud50aHEqkNXt1LTQG3yZMKQqsw9VEqcO2V2Vb+0T2iuw03j+K2G
         hDs9ogxGqyL5a3X/u0ZmYwqJQpSm+Ny7bDTEHcUlg+U7Og5466M8sXwCbBXM3q7JApWz
         MLbxGNntDJc1tilQd9QdKWMHLowyt/5xXuLr+TQqWHJC18gPAgPGdZvjMo+clA05NFbd
         MkU7+k6RROPiJEctaZ/MKvf48EyVF2qYy2b7jEvZPZ9kgO7wZk8UXSZDRefysbVdSvwF
         QrnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9HFX9sjl+4VLRtd7vfZP8e0JAPWXxyf7EQ+egr1dfcA=;
        b=E9G0f5F5qbLhAufUa/XovM9mb/IRdwo6nkEnzic8pLayM7a1tnqYsBswoItUnjpItK
         Hom5wo7GiHO6M9KLva3haq+xXe5JtLrShGFirwhWsm8WiYCCsTFg1KoUXhzVAGBriBnr
         APGB4e6jaa1sslza0fv9w/wVjwULQP65pV/kHYARLA5AIN938PuE8k0LS6zINq0LnyCL
         /vb+3yvjJSfSK9sPkT3Ogn5TgPnI3OsYwHPUm6XWwwI5eYm+WB2sE+Nyepc3RC8AqOLM
         1puXpH/SRDhwuDRcxVBEfCbGbH2LZukj9NM7fcsy8ARzzu6jEnogQSMXNqOeZSGyOOiy
         2bKg==
X-Gm-Message-State: AOAM532H5FabLdeMsaPsnjKHPMvtfogU4nH+4rquq/uvmEg/vCSBpqUM
        Qk4c0SXE/bw6NeeEbty7xk3/OqJFRgc454hySjYP0w==
X-Google-Smtp-Source: ABdhPJyTpagwHeBg7qLoy4BlcwV85GdG9mZ1tyZUA0awaQdoCbca3Xf2RKHRW63ETWlsi2oNPpabaRdlW0+nTdF5Iqs=
X-Received: by 2002:a05:622a:1903:b0:2f3:ddac:436d with SMTP id
 w3-20020a05622a190300b002f3ddac436dmr16866137qtc.25.1653329610964; Mon, 23
 May 2022 11:13:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com> <20220516232138.1783324-22-dmatlack@google.com>
 <CAL715WJ5DVM-A8EFND0iQ-MH9nAhE3rvWdYWaEgRTCJEVeegRg@mail.gmail.com>
 <YovGUDrYZMZ7PXeY@google.com> <CALzav=fUTYGjDuWQxJusH4CzkEwGja-4xAmpqEOZdUfBftYwYw@mail.gmail.com>
In-Reply-To: <CALzav=fUTYGjDuWQxJusH4CzkEwGja-4xAmpqEOZdUfBftYwYw@mail.gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 23 May 2022 11:13:20 -0700
Message-ID: <CAL715WL8g4y=agnMCM7uX6dhBp1JdFKHOCcYsh-=HT0wF=sQUA@mail.gmail.com>
Subject: Re: [PATCH v6 21/22] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
To:     David Matlack <dmatlack@google.com>
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 23, 2022 at 10:44 AM David Matlack <dmatlack@google.com> wrote:
>
> On Mon, May 23, 2022 at 10:37 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, May 20, 2022, Mingwei Zhang wrote:
> > > On Mon, May 16, 2022 at 4:24 PM David Matlack <dmatlack@google.com> wrote:
> > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > index e089db822c12..5e2e75014256 100644
> > > > --- a/virt/kvm/kvm_main.c
> > > > +++ b/virt/kvm/kvm_main.c
> > > > @@ -369,14 +369,31 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> > > >                 return (void *)__get_free_page(gfp_flags);
> > > >  }
> > > >
> > > > -int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> > > > +static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
> > > >  {
> > > > +       gfp_t gfp = GFP_KERNEL_ACCOUNT;
> > > >         void *obj;
> > > >
> > > >         if (mc->nobjs >= min)
> > > >                 return 0;
> > > > -       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> > > > -               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> > > > +
> > > > +       if (unlikely(!mc->objects)) {
> > > > +               if (WARN_ON_ONCE(!capacity))
> > > > +                       return -EIO;
> > > > +
> > > > +               mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
> > > > +               if (!mc->objects)
> > > > +                       return -ENOMEM;
> > > > +
> > > > +               mc->capacity = capacity;
> > >
> > > Do we want to ensure the minimum value of the capacity? I think
> > > otherwise, we may more likely start using memory from GFP_ATOMIC if
> > > the capacity is less than, say 5? But the minimum value seems related
> > > to each cache type.
> >
> > Eh, if we specify a minimum, just make the arch default the minimum.  That way we
> > avoid adding even more magic/arbitrary numbers.  E.g. for whatever reason, MIPS's
> > default is '4'.
>
> I'm not exactly sure what you had in mind Mingwei. But there is a bug
> in this code if min > capacity. This function will happily return 0
> after filling up the cache, even though it did not allocate min
> objects. The same bug existed before this patch if min >
> ARRAY_SIZE(mc->objects). I can include a separate patch to fix this
> bug (e.g. WARN and return -ENOMEM if min > capacity).

oh, what I am saying is this one:
https://elixir.bootlin.com/linux/latest/source/virt/kvm/kvm_main.c#L417

If we are running out of kmem cache, then we start to use
__GFP_ATOMIC, which should be avoided as much as we can? Since this
patch parameterized the 'capacity', then to avoid the future usage
where caller provides a too small value, maybe we could add a warning
if the 'capacity' is too small, say, smaller than 40 (the default
value)?

The case of  'capacity' < min would be a more serious issue, that
situation probably should never be allowed.
