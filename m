Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D1D68C334
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 17:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjBFQ2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 11:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjBFQ2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 11:28:44 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B2528856
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 08:28:40 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id bl15so5547222qkb.4
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 08:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GsYXRrrozy1Y6bByTyL/QEQBzvwU4NP0DVeauv7JHVo=;
        b=PyrE+NbJPLiIf/5JN0tHX/r9jZH6PpBUlPc1wPOi/HN3yduaaGZTOVQI7q+PsSYIzr
         X3+SMYQtWHyP3QD7vM/BtM2BBHCLbBD/cWolg7B4kGtAb0b5rgj2A856XRzAur+e6Xf5
         j02OcPgg7bvJAEqAS11RQwyvmngQir+dB9IDlXtZga61ZIHiE1Orc9kVhzxW5rRG7zq1
         sWoLuoIxyaPJGkc+I7uzaoiFvPM/IcGdkgAgFddQyJM+63snIPTkNbmXNE+qlnoD3RCg
         QuzmpwuetOzEiL7dwsQhCOgtYkrsUI0lRe3xKdMhWLmbpgVJ4252QH4+CUKFbuSaewFb
         2nGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GsYXRrrozy1Y6bByTyL/QEQBzvwU4NP0DVeauv7JHVo=;
        b=Gpp2hd+iI5sSiMpnb0OX+hGLtuIJUdJGBYhKrV2ugLps3a64MBzkPiFLv+tqpN4dkZ
         dzakA5asmymcw+kmECY9a9vEvP2XVms/jK5hqM1dpUcmX7vftRC9syr7gu03a9ZVtOeI
         LNnl2HvB17f/qD2KiChI3EShD3XuReaZcnHOHshOaAGIJwU/bPy/Jz0m1Wxm6V2G09r2
         f6V8/fmgA/UmL+HnhMtIuCuYwjg0XTymqnE62hIRbNXZQawBLOUWHUfzm3Ipw3I1sFop
         Q7w1O3f8tg8plKh1rJf5RQoYYVq8ePtsHRFLRnBAZheFAKFqoJGNvOgN9nPs2pMrmbIq
         afeA==
X-Gm-Message-State: AO0yUKV06De89bgaa8V7O0/KMHZXbHAyW7IxeQjZL00QRmSHZ5nLEA3e
        VZEv/pxXO2GxaXNPTHeFrEuDQMEG/hJ7M9DTinBoZw==
X-Google-Smtp-Source: AK7set+Is1Am6YXWwW05Tb0uG6N5+i/m82QjceMYk7c4ZbDQIJ4gzCa1XcyEHzVZC3zCoir1wrW7TTG92QYmJnmli6g=
X-Received: by 2002:a05:620a:4483:b0:72b:ada6:1295 with SMTP id
 x3-20020a05620a448300b0072bada61295mr1062720qkp.211.1675700918954; Mon, 06
 Feb 2023 08:28:38 -0800 (PST)
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-4-ricarkol@google.com>
 <59f0d41e-d8ac-dab3-9136-af48efe55578@huawei.com>
In-Reply-To: <59f0d41e-d8ac-dab3-9136-af48efe55578@huawei.com>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Mon, 6 Feb 2023 08:28:27 -0800
Message-ID: <CAOHnOryTynkFo9qhtVwfjDAnzUPjz-WipWBpaxCg0N2ARtrF6Q@mail.gmail.com>
Subject: Re: [PATCH 3/9] KVM: arm64: Add kvm_pgtable_stage2_split()
To:     Zheng Chuan <zhengchuan@huawei.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Xiexiangyou <xiexiangyou@huawei.com>, yezhenyu2@huawei.com
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

Hi Zheng,

On Mon, Feb 6, 2023 at 1:21 AM Zheng Chuan <zhengchuan@huawei.com> wrote:
>
> Hi, Ricardo
>
> On 2023/1/13 11:49, Ricardo Koller wrote:
> > Add a new stage2 function, kvm_pgtable_stage2_split(), for splitting a
> > range of huge pages. This will be used for eager-splitting huge pages
> > into PAGE_SIZE pages. The goal is to avoid having to split huge pages
> > on write-protection faults, and instead use this function to do it
> > ahead of time for large ranges (e.g., all guest memory in 1G chunks at
> > a time).
> >
> > No functional change intended. This new function will be used in a
> > subsequent commit.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 29 ++++++++++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 67 ++++++++++++++++++++++++++++
> >  2 files changed, 96 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 8ad78d61af7f..5fbdc1f259fd 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -644,6 +644,35 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
> >   */
> >  int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
> >
> > +/**
> > + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> > + *                           to PAGE_SIZE guest pages.
> > + * @pgt:     Page-table structure initialised by kvm_pgtable_stage2_init*().
> > + * @addr:    Intermediate physical address from which to split.
> > + * @size:    Size of the range.
> > + * @mc:              Cache of pre-allocated and zeroed memory from which to allocate
> > + *           page-table pages.
> > + *
> > + * @addr and the end (@addr + @size) are effectively aligned down and up to
> > + * the top level huge-page block size. This is an exampe using 1GB
> > + * huge-pages and 4KB granules.
> > + *
> > + *                          [---input range---]
> > + *                          :                 :
> > + * [--1G block pte--][--1G block pte--][--1G block pte--][--1G block pte--]
> > + *                          :                 :
> > + *                   [--2MB--][--2MB--][--2MB--][--2MB--]
> > + *                          :                 :
> > + *                   [ ][ ][:][ ][ ][ ][ ][ ][:][ ][ ][ ]
> > + *                          :                 :
> > + *
> > + * Return: 0 on success, negative error code on failure. Note that
> > + * kvm_pgtable_stage2_split() is best effort: it tries to break as many
> > + * blocks in the input range as allowed by the size of the memcache. It
> > + * will fail it wasn't able to break any block.
> > + */
> > +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc);
> > +
> >  /**
> >   * kvm_pgtable_walk() - Walk a page-table.
> >   * @pgt:     Page-table structure initialised by kvm_pgtable_*_init().
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 0dee13007776..db9d1a28769b 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1229,6 +1229,73 @@ int kvm_pgtable_stage2_create_removed(struct kvm_pgtable *pgt,
> >       return 0;
> >  }
> >
> > +struct stage2_split_data {
> > +     struct kvm_s2_mmu               *mmu;
> > +     void                            *memcache;
> > +};
> > +
> > +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > +                            enum kvm_pgtable_walk_flags visit)
> > +{
> > +     struct stage2_split_data *data = ctx->arg;
> > +     struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> > +     kvm_pte_t pte = ctx->old, new, *childp;
> > +     enum kvm_pgtable_prot prot;
> > +     void *mc = data->memcache;
> > +     u32 level = ctx->level;
> > +     u64 phys;
> > +     int ret;
> > +
> > +     /* Nothing to split at the last level */
> > +     if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> > +             return 0;
> > +
> > +     /* We only split valid block mappings */
> > +     if (!kvm_pte_valid(pte) || kvm_pte_table(pte, ctx->level))
> > +             return 0;
> > +
> IIUC, It should be !kvm_pte_table(pte, ctx->level)?

It's the other way around; if the current PTE is a table then there's
nothing to split
(it's already a table), and we leave early.

> also, the kvm_pte_table includes the level check and kvm_pte_valid, so, it just be like:
> -       /* Nothing to split at the last level */
> -       if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> -               return 0;
> -
> -       /* We only split valid block mappings */
> +       if (!kvm_pte_table(pte, ctx->level))
> +               return 0;

Still need the kvm_pte_valid() check because !kvm_pte_table() does not imply
that the pte is valid. Same with the level check.

Thanks for taking a look at the patch,
Ricardo

>
> > +     phys = kvm_pte_to_phys(pte);
> > +     prot = kvm_pgtable_stage2_pte_prot(pte);
> > +
> > +     ret = kvm_pgtable_stage2_create_removed(data->mmu->pgt, &new, phys,
> > +                                             level, prot, mc);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (!stage2_try_break_pte(ctx, data->mmu)) {
> > +             childp = kvm_pte_follow(new, mm_ops);
> > +             kvm_pgtable_stage2_free_removed(mm_ops, childp, level);
> > +             mm_ops->put_page(childp);
> > +             return -EAGAIN;
> > +     }
> > +
> > +     /*
> > +      * Note, the contents of the page table are guaranteed to be
> > +      * made visible before the new PTE is assigned because
> > +      * stage2_make_pte() writes the PTE using smp_store_release().
> > +      */
> > +     stage2_make_pte(ctx, new);
> > +     dsb(ishst);
> > +     return 0;
> > +}
> > +
> > +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt,
> > +                          u64 addr, u64 size, void *mc)
> > +{
> > +     struct stage2_split_data split_data = {
> > +             .mmu            = pgt->mmu,
> > +             .memcache       = mc,
> > +     };
> > +
> > +     struct kvm_pgtable_walker walker = {
> > +             .cb     = stage2_split_walker,
> > +             .flags  = KVM_PGTABLE_WALK_LEAF,
> > +             .arg    = &split_data,
> > +     };
> > +
> > +     return kvm_pgtable_walk(pgt, addr, size, &walker);
> > +}
> > +
> >  int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> >                             struct kvm_pgtable_mm_ops *mm_ops,
> >                             enum kvm_pgtable_stage2_flags flags,
> >
>
> --
> Regards.
> Chuan
>
