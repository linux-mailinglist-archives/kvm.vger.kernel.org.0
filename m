Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0FEA65C527
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 18:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbjACRhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 12:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233374AbjACRha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 12:37:30 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7159B87E
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 09:37:28 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id g4so33857323ybg.7
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 09:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OeWoV2jDJv8fM4Dg3JYXPgrQnOUrSK9gsg7zC/eF8E4=;
        b=TPkqz6ugysO/Ainbe2exHeibI4ZMUjP7dUE/L2EFkFgPKqQndvZuh+xBMazTijUOHb
         7NSgN/YiganWrWNBUfrwv4rgtGMfnQB4waNbo8b2/sIK13pbGPDaMBXBROH0UvcmVP6p
         xzcO+i9ALp3ZzlqiEHigxO+1AZZ6O5TdrAGRYcKw0LW9W2xMa4Mw48NO7o5mssCFe3zH
         N4CrONsXgkn2UxCZHOFXu63lYI+165i/egMXZ0yVA9oD/98AYhH3T6U1d0JIRFRavYeg
         7cVd6wrzGUNFzZIRViTZrJtk+23qVwDMmvz65+9qPHjA5Nd2oycxhglfK2GIQNMbomfw
         eEiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OeWoV2jDJv8fM4Dg3JYXPgrQnOUrSK9gsg7zC/eF8E4=;
        b=pckG/R+EpyU4oCIcMJ1tiVU1s5/mH6YFfVr45whLLoGpGxmHjBRyr5eQaEhNkpen6y
         T22Udi0SbsEUhsULtF+k8Jx1rL9XMRgoNRR4VTOnvD81WZLivkRFITCR55BtyD2DoaiT
         weC3dUI06Ie3XgqfmSLETH9mNuPGvFtIKtdpTurnjPZCc0/jpL8kPQF4Zrc2C9gMQU55
         c6+H/i7AWxCXRmrwyj6YtD34yCvoRA6O2PjzJuRqmFdOY+0eFS1VeOC48+gcewOxsGjZ
         ZKnfI1E9U5Nq/JnGGz568n/d5feUGGyFFHU6Bpo5s6aQgx2RbMxulQaz2J04PCyC7cIN
         ITaw==
X-Gm-Message-State: AFqh2kpJ96FXAt/X6HHFHs3Q+gtMxYdb/JgzLNjhIZNdpP5NgOlY9dBH
        ovAKjtnMwBD2X69D1n3YiIdLv73PgEA2x1ifBYb7NA==
X-Google-Smtp-Source: AMrXdXu8GSgfBPWxgydDd2VXKPn6C9kVOiid1xdDcwjSNmmaplcDYLpEMrF/beW8ri/5hqrJgbgQyQdWu2jBsgUJQkw=
X-Received: by 2002:a25:da14:0:b0:707:34cf:b4b1 with SMTP id
 n20-20020a25da14000000b0070734cfb4b1mr4271075ybf.123.1672767447737; Tue, 03
 Jan 2023 09:37:27 -0800 (PST)
MIME-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com> <20221222023457.1764-7-vipinsh@google.com>
 <CANgfPd_=WwrgVVQnooZLCSXpSnEjRVOdt6qZtrvhO_wmxc5Tzg@mail.gmail.com>
 <CAHVum0dkqp1MnMyqoOQdGp2K74h5NFrzZ4KaT=0+ezVP-JJnVQ@mail.gmail.com> <CANgfPd8KU3pqSYu--bSP1QesmkrnLqqB8QH_8rZVS=8S4HNBDQ@mail.gmail.com>
In-Reply-To: <CANgfPd8KU3pqSYu--bSP1QesmkrnLqqB8QH_8rZVS=8S4HNBDQ@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 3 Jan 2023 09:36:51 -0800
Message-ID: <CAHVum0c+17Z-RbGAFdU-xmRejDjDQ+MKOfN4XaObh2SwgWAjLg@mail.gmail.com>
Subject: Re: [Patch v3 6/9] KVM: Provide NUMA node support to kvm_mmu_memory_cache{}
To:     chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com
Cc:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 29, 2022 at 10:22 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Wed, Dec 28, 2022 at 2:08 PM Vipin Sharma <vipinsh@google.com> wrote:
> >
> > On Tue, Dec 27, 2022 at 11:10 AM Ben Gardon <bgardon@google.com> wrote:
> > >
> > > On Wed, Dec 21, 2022 at 6:35 PM Vipin Sharma <vipinsh@google.com> wrote:
> > > >
> > > > Add 'node' variable in kvm_mmu_memory_cache{} to denote which NUMA node
> > > > this cache should allocate memory from. Default initialize to
> > > > NUMA_NO_NODE in all architectures.
> > > >
> > > > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > > > ---
> > > >  arch/arm64/kvm/arm.c      |  2 +-
> > > >  arch/arm64/kvm/mmu.c      |  4 +++-
> > > >  arch/mips/kvm/mips.c      |  2 ++
> > > >  arch/riscv/kvm/mmu.c      |  2 +-
> > > >  arch/riscv/kvm/vcpu.c     |  2 +-
> > > >  arch/x86/kvm/mmu/mmu.c    | 22 ++++++++++++----------
> > > >  include/linux/kvm_host.h  |  6 ++++++
> > > >  include/linux/kvm_types.h |  2 ++
> > > >  8 files changed, 28 insertions(+), 14 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > index 9c5573bc4614..52a41f4532e2 100644
> > > > --- a/arch/arm64/kvm/arm.c
> > > > +++ b/arch/arm64/kvm/arm.c
> > > > @@ -340,7 +340,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> > > >         vcpu->arch.target = -1;
> > > >         bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> > > >
> > > > -       vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
> > > > +       INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache, NULL, NUMA_NO_NODE);
> > > >
> > > >         /*
> > > >          * Default value for the FP state, will be overloaded at load
> > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > index 31d7fa4c7c14..bd07155e17fa 100644
> > > > --- a/arch/arm64/kvm/mmu.c
> > > > +++ b/arch/arm64/kvm/mmu.c
> > > > @@ -894,12 +894,14 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> > > >  {
> > > >         phys_addr_t addr;
> > > >         int ret = 0;
> > > > -       struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
> > > > +       struct kvm_mmu_memory_cache cache;
> > > >         struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> > > >         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
> > > >                                      KVM_PGTABLE_PROT_R |
> > > >                                      (writable ? KVM_PGTABLE_PROT_W : 0);
> > > >
> > > > +       INIT_KVM_MMU_MEMORY_CACHE(&cache, NULL, NUMA_NO_NODE);
> > > > +
> > > >         if (is_protected_kvm_enabled())
> > > >                 return -EPERM;
> > > >
> > > > diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> > > > index a25e0b73ee70..b017c29a9340 100644
> > > > --- a/arch/mips/kvm/mips.c
> > > > +++ b/arch/mips/kvm/mips.c
> > > > @@ -304,6 +304,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> > > >                      HRTIMER_MODE_REL);
> > > >         vcpu->arch.comparecount_timer.function = kvm_mips_comparecount_wakeup;
> > > >
> > > > +       vcpu->arch.mmu_page_cache.node = NUMA_NO_NODE;
> > > > +
> > >
> > > It looks weird to have MIPS not using the initialization MACRO. Should
> > > it just have a GFP_ZERO parameter?
> >
> > MIPS is not setting GFP_ZERO explicitly before my series, so, I didn't
> > make it GFP_ZERO. I am not sure if MIPS needs it or not, I tried to
> > keep the same functionality in my patch.
> >
> > May be someone from MIPS can tell more about it.
>
> That makes sense, I just don't want to see MIPS get left behind
> because we move the cache init logic to a macro or function. Folks
> might update the init function but forget to update MIPS too.
>

Hi Huacai, Aleksandar,

I have noticed that MIPS doesn't use __GFP_ZERO flag for
mmu_page_cache in KVM. Is it intentional? I was wondering if it will
be useful if I add zero flag for cache in this patch for MIPS? All
other architectures seem to use __GFP_ZERO flag for their caches.

Thanks
Vipin
