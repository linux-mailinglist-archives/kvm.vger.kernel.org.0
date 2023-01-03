Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74DB65C6CC
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 19:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238363AbjACSz4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 13:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbjACSzz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 13:55:55 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBFE5F54
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 10:55:54 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id c124so34080620ybb.13
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 10:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zQYTWmjt5FQcX2UxA0AXl1+Ue8Sq0BTNkGJBr9dSCRA=;
        b=IBwfdfhO8NgUvWtGuivlCIKr8bO4BElPG2Or6rFcgA5/f9UJFdeKYseVnBaOdZae5A
         HGwBUhevbmX41oi2HqlXlGbAm0g3UGoEOHZFMB15c3bROiH04aemVruBiW2dY4xNuBt4
         i91T/XMwNDgi0rXr88TDGYnxc9CT2wwDXEAtESMxxBoa5RaJrPa02IVNMdIbJVGbyMQI
         JiDSKQ4t2UtX3KxcBQNbXRqEzTx9DWxyfM5C93SK1IGNt0QCzZT2PBx3YiWH/TUlsReh
         TbkMSZPEnfv3r3XDOUeONLvJbh0pBQQTHw0kwJtXQAQuNMAnId0rWpG4B95th2EJIC39
         uT2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zQYTWmjt5FQcX2UxA0AXl1+Ue8Sq0BTNkGJBr9dSCRA=;
        b=0NYFZBfIikCJypCwFuF8DARxPSlYXDk6TlEUBDVMK1kfLy8lnvoE44kl9bCt/s+2+q
         4hJ5FARzHxx1EYboP9r+9s/GkRY2MpY2P1a9I6ID/7mQ4sdC0hJy6PqT7ggSld8ISW4Y
         cR2/9NsRG1jRrdYDwekQJfpqkHgGGcKFuT7CeCcc0v3VpyCEWuqpVh5xNkL3WNxOfcv0
         VDuApwvpVHKpi6c/YivNgOzm5RavX9nFVgJDVmgcnI2BgN70VwXy7Na6dTpe9KpEQaEX
         LFEe/kR4DxB8bLrHJziEtffN4/9W98dZXWBgcIUcGBA4MURF33LLi53iGMBYoGl0gOWP
         ze9Q==
X-Gm-Message-State: AFqh2koT4PIAf36hdQd44Ts7kSpGHK8ThljDN+HXqr1N79d6FNrst/aY
        14pIvk3WHiPs+aoxD/ZUlvk2cuxs2gJyrOnxZOBjFA==
X-Google-Smtp-Source: AMrXdXsJjmUyumx412omlS+7bb4uzVL3WLj9a97MK45jvTR5eAaPFzzNXlfaGe86KG8h57CWbILscCkAS4AxfqaL2go=
X-Received: by 2002:a25:6fc6:0:b0:782:ad2:8433 with SMTP id
 k189-20020a256fc6000000b007820ad28433mr2175033ybc.305.1672772153718; Tue, 03
 Jan 2023 10:55:53 -0800 (PST)
MIME-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com> <20221222023457.1764-7-vipinsh@google.com>
 <Y64eAvm4JglT1au4@google.com> <CALzav=fGmy=YmpA6u=b0-p8zxnKbF2rt5mQUo-DWm2wYBU7dzA@mail.gmail.com>
 <CAHVum0fdz8HmgQd5z2n9eAzWuTjtBPA5_aVrY123K=kAMdJvhw@mail.gmail.com>
In-Reply-To: <CAHVum0fdz8HmgQd5z2n9eAzWuTjtBPA5_aVrY123K=kAMdJvhw@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 3 Jan 2023 10:55:27 -0800
Message-ID: <CALzav=fpyskcX_vsJ=t_K-rM2QdbimNTt1C5w3UQW2TstjS7eQ@mail.gmail.com>
Subject: Re: [Patch v3 6/9] KVM: Provide NUMA node support to kvm_mmu_memory_cache{}
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Tue, Jan 3, 2023 at 10:46 AM Vipin Sharma <vipinsh@google.com> wrote:
>
> On Thu, Dec 29, 2022 at 3:12 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Thu, Dec 29, 2022 at 3:08 PM David Matlack <dmatlack@google.com> wrote:
> > >
> > > On Wed, Dec 21, 2022 at 06:34:54PM -0800, Vipin Sharma wrote:
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
> > > >       vcpu->arch.target = -1;
> > > >       bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> > > >
> > > > -     vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
> > > > +     INIT_KVM_MMU_MEMORY_CACHE(&vcpu->arch.mmu_page_cache, NULL, NUMA_NO_NODE);
> > > >
> > > >       /*
> > > >        * Default value for the FP state, will be overloaded at load
> > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > index 31d7fa4c7c14..bd07155e17fa 100644
> > > > --- a/arch/arm64/kvm/mmu.c
> > > > +++ b/arch/arm64/kvm/mmu.c
> > > > @@ -894,12 +894,14 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> > > >  {
> > > >       phys_addr_t addr;
> > > >       int ret = 0;
> > > > -     struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
> > > > +     struct kvm_mmu_memory_cache cache;
> > > >       struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> > > >       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
> > > >                                    KVM_PGTABLE_PROT_R |
> > > >                                    (writable ? KVM_PGTABLE_PROT_W : 0);
> > > >
> > > > +     INIT_KVM_MMU_MEMORY_CACHE(&cache, NULL, NUMA_NO_NODE);
> > >
> > > This is not any better than setting cache.node = NUMA_NO_NODE directly.
> > > Yes it's less lines of code, but it's harder to read (what does NULL
> > > mean here?), and every user of kvm_mmu_memory_cache still has to know to
> > > pass NUMA_NO_NODE.
> > >
> > > When I originally gave this suggestion, I intended to suggest that
> > > INIT_KVM_MMU_MEMORY_CACHE() provide just default initialization.
> > > Non-default initialization for gfp_zero, gfp_custom, kmem_cache, and
> > > node would remain as they are.
> > >
> > > Yes this adds some more lines, but keeps things readable, and doesn't
> > > every initialization site of kvm_mmu_memory_cache to know what to pass
> > > for gfp_zero, node, and kmem_cache. It only needs to set the fields
> > > *it* cares about.
> >
> > And to offset the extra lines to call INIT_KVM_MMU_MEMORY_CACHE(), we
> > could finally invert the meaning of gfp_zero so that caches use
> > __GFP_ZERO by default. The majority of caches want __GFP_ZERO, so that
> > should cut down a bunch of lines.
> >
>
> Can you clarify what you mean by invert?
>
> Caches which don't want __GFP_ZERO will explicitly set gfp_zero to 0.
> Is this what you intend?

When I wrote that comment I was thinking you can change `gfp_t
gfp_zero` to e.g. `bool skip_gfp_zero` so that the default initialized
value (false/0) means "use __GFP_ZERO".

However, that's silly once we have INIT_KVM_MMU_MEMORY_CACHE(). We can
do what you suggest: set gfp_zero to __GFP_ZERO in
INIT_KVM_MMU_MEMORY_CACHE() and then explicitly set it to 0 in caches
that don't need __GFP_ZERO.
