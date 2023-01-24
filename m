Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B55D679ED2
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 17:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjAXQgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 11:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbjAXQgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 11:36:08 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AB24C6F1
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 08:35:45 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id e10-20020a17090a630a00b0022bedd66e6dso2588055pjj.1
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 08:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rsEVtGGTFIHpkRLJZTulPXLpxSRPNED4KjXw3ufmnMM=;
        b=eJLQzZ6Le+Wr94ardYEzmhRznMRAHnCxPi09A3omzjJWVx9Pfu4C1okubr9KuBX608
         QEyvU+vu8pDwqBW1ZtH0RLeirRZxk454/iTsZyTwmhS5VY8XpXfDTxFtW/3xOxNSn1ar
         28vcouyM+SqZLYSmINekYzZOf5JVn2p0KZeNL4tpOe/rRFVJEoji+Am1XoBwU3mKyuQm
         QvAUeJZxqIOwFMADqW1+nRR8mEagSVUwPwg1vZRJq9XPF4WG0bt2656KjY/1lARX/pvC
         ppEWAJIY9QN6veMmH+Xo8gWeEnN7Mx02zrpBfYC86m33ba29izr5LgJ1XL6QtEFVkQuL
         RxGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rsEVtGGTFIHpkRLJZTulPXLpxSRPNED4KjXw3ufmnMM=;
        b=hca6ukS7tTPi3WtG9e6rPccrdLSU2KphXfEbOLIdGmQkXwVCpHmBCy5FOUy0FwHNap
         2J2Y10fm9mzid2w2KrE8x9sxIUCIHFywMI26yDkY/pYyB7qOHzgc3nsnRWdTFuFetkO2
         a3R2rtOgbzNMN3bJS50WRPzi3lPnmCP7sPdVcxsPTRCVd+J7Ld1t6YWxNP/zmpCw2M05
         Z1XAZ7gPiHhCsjzMhkmJTun5pmrG55uZ6WpumUUxZh4kHnZvlgFH9+GdWbtxa/aMzuJz
         G5B4dTWCeL03C9Ky1La5BnWkUqIX4B2R+D2lFLJgzuENY31i0gh9SkaPJy8R1O7DjCn6
         Ae9g==
X-Gm-Message-State: AO0yUKWyNhl2pBk7Ml3oCHtVyiQhKepUfUx2lmdmmREEcuOHDsDikQSa
        ynYZ0sfu/im1eEam3QXZ6IGdLg==
X-Google-Smtp-Source: AK7set8n2BrBRTSNTreW4tMk1tf3rE1i6CiDCf+wdpJvWB5aktsAehnhGADHQgW3O3+tm/hXPpvDgw==
X-Received: by 2002:a05:6a20:d688:b0:b9:14e:184b with SMTP id it8-20020a056a20d68800b000b9014e184bmr275160pzb.3.1674578143872;
        Tue, 24 Jan 2023 08:35:43 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id v10-20020a17090a00ca00b0022bab07f578sm4815954pjd.11.2023.01.24.08.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 08:35:43 -0800 (PST)
Date:   Tue, 24 Jan 2023 08:35:40 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 2/9] KVM: arm64: Add helper for creating removed stage2
 subtrees
Message-ID: <Y9AI3FWEeIaw9kRN@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-3-ricarkol@google.com>
 <CANgfPd-KSX=NOhjyoAQRrLyHArQ=Sw3uMjmdh5J0yrogUN8mbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-KSX=NOhjyoAQRrLyHArQ=Sw3uMjmdh5J0yrogUN8mbg@mail.gmail.com>
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

On Mon, Jan 23, 2023 at 04:55:40PM -0800, Ben Gardon wrote:
> On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Add a stage2 helper, kvm_pgtable_stage2_create_removed(), for creating
> > removed tables (the opposite of kvm_pgtable_stage2_free_removed()).
> > Creating a removed table is useful for splitting block PTEs into
> > subtrees of 4K PTEs.  For example, a 1G block PTE can be split into 4K
> > PTEs by first creating a fully populated tree, and then use it to
> > replace the 1G PTE in a single step.  This will be used in a
> > subsequent commit for eager huge-page splitting (a dirty-logging
> > optimization).
> >
> > No functional change intended. This new function will be used in a
> > subsequent commit.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 25 +++++++++++++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 47 ++++++++++++++++++++++++++++
> >  2 files changed, 72 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 84a271647007..8ad78d61af7f 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -450,6 +450,31 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
> >   */
> >  void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
> >
> > +/**
> > + * kvm_pgtable_stage2_free_removed() - Create a removed stage-2 paging structure.
> > + * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> > + * @new:       Unlinked stage-2 paging structure to be created.
> 
> Oh, I see so the "removed" page table is actually a new page table
> that has never been part of the paging structure. In that case I would
> find it much more intuitive to call it "unlinked" or similar.
>

Sounds good, I like "unlinked".

Oliver, are you OK if I rename free_removed() as well? just to keep them
symmetric.

> > + * @phys:      Physical address of the memory to map.
> > + * @level:     Level of the stage-2 paging structure to be created.
> > + * @prot:      Permissions and attributes for the mapping.
> > + * @mc:                Cache of pre-allocated and zeroed memory from which to allocate
> > + *             page-table pages.
> > + *
> > + * Create a removed page-table tree of PAGE_SIZE leaf PTEs under *new.
> > + * This new page-table tree is not reachable (i.e., it is removed) from the
> > + * root pgd and it's therefore unreachableby the hardware page-table
> > + * walker. No TLB invalidation or CMOs are performed.
> > + *
> > + * If device attributes are not explicitly requested in @prot, then the
> > + * mapping will be normal, cacheable.
> > + *
> > + * Return: 0 only if a fully populated tree was created, negative error
> > + * code on failure. No partially-populated table can be returned.
> > + */
> > +int kvm_pgtable_stage2_create_removed(struct kvm_pgtable *pgt,
> > +                                     kvm_pte_t *new, u64 phys, u32 level,
> > +                                     enum kvm_pgtable_prot prot, void *mc);
> > +
> >  /**
> >   * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
> >   * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 87fd40d09056..0dee13007776 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1181,6 +1181,53 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
> >         return kvm_pgtable_walk(pgt, addr, size, &walker);
> >  }
> >
> > +/*
> > + * map_data->force_pte is true in order to force creating PAGE_SIZE PTEs.
> > + * data->addr is 0 because the IPA is irrelevant for a removed table.
> > + */
> > +int kvm_pgtable_stage2_create_removed(struct kvm_pgtable *pgt,
> > +                                     kvm_pte_t *new, u64 phys, u32 level,
> > +                                     enum kvm_pgtable_prot prot, void *mc)
> > +{
> > +       struct stage2_map_data map_data = {
> > +               .phys           = phys,
> > +               .mmu            = pgt->mmu,
> > +               .memcache       = mc,
> > +               .force_pte      = true,
> > +       };
> > +       struct kvm_pgtable_walker walker = {
> > +               .cb             = stage2_map_walker,
> > +               .flags          = KVM_PGTABLE_WALK_LEAF |
> > +                                 KVM_PGTABLE_WALK_REMOVED,
> > +               .arg            = &map_data,
> > +       };
> > +       struct kvm_pgtable_walk_data data = {
> > +               .walker = &walker,
> > +               .addr   = 0,
> > +               .end    = kvm_granule_size(level),
> > +       };
> > +       struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
> > +       kvm_pte_t *pgtable;
> > +       int ret;
> > +
> > +       ret = stage2_set_prot_attr(pgt, prot, &map_data.attr);
> > +       if (ret)
> > +               return ret;
> > +
> > +       pgtable = mm_ops->zalloc_page(mc);
> > +       if (!pgtable)
> > +               return -ENOMEM;
> > +
> > +       ret = __kvm_pgtable_walk(&data, mm_ops, pgtable, level + 1);
> > +       if (ret) {
> > +               kvm_pgtable_stage2_free_removed(mm_ops, pgtable, level);
> > +               mm_ops->put_page(pgtable);
> > +               return ret;
> > +       }
> > +
> > +       *new = kvm_init_table_pte(pgtable, mm_ops);
> > +       return 0;
> > +}
> >
> >  int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> >                               struct kvm_pgtable_mm_ops *mm_ops,
> > --
> > 2.39.0.314.g84b9a713c41-goog
> >
