Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E46667DD22
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 06:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbjA0Fik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 00:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbjA0Fij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 00:38:39 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFB32449C
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 21:38:37 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y19so3801004edc.2
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 21:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JFUPc+lU7HPxppOgMcNwGj0PM3SP5fzaDIR99v18sAU=;
        b=GAsAwJWc2omReq9wRMhsy8ixlevj5d66DwqJ4FlkYBhSNpcSidZ6gdah1QzYIeOaV3
         Dzf6TpzLYPPm0JMNGHeusI3nRUQxowVHj18tdwIEeXObFXSprtyKJbTkw5CjDeUI7DVA
         KgIbxI88i75Zu2Nxj0qBuhmTGlOTSGk19dtnbts8+G/Xi6dElnsUayJJ4VneM4tJR6Hb
         P0RwvokuJguAkKGx/SdkpK5vS2sg825BSiMS5Lm5U7v0T7UrQ2yciAwHbx3oMLmNQTj2
         A51zvAh3EzkgMBbA+uEfsUqISLSiaFBhhhNtaFrkboKMdy2hD6npK5NwkXmbjSnLwHr0
         Wmug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JFUPc+lU7HPxppOgMcNwGj0PM3SP5fzaDIR99v18sAU=;
        b=TUK687kUUnN9EV9JI9NVosrPW+ycresYY0A/BHtDRKD1et3g57eHFvC8jnCOZuxWOp
         6hFnyL8TDaXPckAYYAkT7aEd8AeeBUuoKasl4e2yqZov1W4UB9lBBJBuYi3a9fzjauHt
         vpYKJVm5HA4zZLzAWnMeTC3cNQNgr4CldtW5/zAbGARlu1USnTyYm2HWio+RGzChSYEh
         6DxM/7Fa2Q1ojovEDdPX0MCqZXSMb5azZIpM+imElc6cvNEHg1HCf9JtJD+dnKiD+00T
         nOPKbppvk4RYt4DRia/wio6Yt6hF+Yf47zqBFb+UerzuDIKwhGvER34Yf1VnwFRmKV74
         f+iA==
X-Gm-Message-State: AFqh2kpbjgBihKKWPLnyKWa4rZuLNf1xtE3mt4bp1BzIYomoc6RGYf2X
        uaXEKRL7RLLhfN9rWEIqzCpToGgbH5ua33AGve5jBg==
X-Google-Smtp-Source: AMrXdXs7S9OHnQa8OaHPiBaDup6GXNYIWliRtThREoOzhrNSBrUwL1ewg84TBMC8dceoEWYGm6yAB/X6MnGnHTNAhG4=
X-Received: by 2002:a05:6402:1008:b0:499:f0f:f788 with SMTP id
 c8-20020a056402100800b004990f0ff788mr6180622edu.25.1674797916410; Thu, 26 Jan
 2023 21:38:36 -0800 (PST)
MIME-Version: 1.0
References: <20230123092928.808014-1-alexghiti@rivosinc.com>
 <bdabafb1-53f3-403c-ab9c-1c2d00421690@ghiti.fr> <CAAhSdy1grLz2EXEJUicGFZO7md7F=Hbnhv7ZqBFFx-vtnkpmmA@mail.gmail.com>
 <CAHVXubjHBu7F9xaERTR6vppsUph2U8JX1DRSrFUAWs-jJ_8ncQ@mail.gmail.com>
In-Reply-To: <CAHVXubjHBu7F9xaERTR6vppsUph2U8JX1DRSrFUAWs-jJ_8ncQ@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 27 Jan 2023 11:08:24 +0530
Message-ID: <CAAhSdy1FdXvZQo9+bpfqHUA0FD-6NnxbL59Cs-+7zrw8EBcmJg@mail.gmail.com>
Subject: Re: [PATCH] KVM: RISC-V: Fix wrong usage of PGDIR_SIZE to check page sizes
To:     Alexandre Ghiti <alexghiti@rivosinc.com>
Cc:     Alexandre Ghiti <alex@ghiti.fr>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 23, 2023 at 8:04 PM Alexandre Ghiti <alexghiti@rivosinc.com> wrote:
>
> On Mon, Jan 23, 2023 at 12:28 PM Anup Patel <anup@brainfault.org> wrote:
> >
> > On Mon, Jan 23, 2023 at 3:01 PM Alexandre Ghiti <alex@ghiti.fr> wrote:
> > >
> > > @Anup: Sorry, forgot to add -fixes to the patch title, as I think this
> > > should go into your fixes branch for 6.2.
> >
> > Can you provide the Fixes: line here ? I will include it at time of
> > adding this patch to my fixes branch.
>
> It actually fixes 2 commits: 9955371cc014 ("RISC-V: KVM: Implement MMU
> notifiers") and 9d05c1fee837 ("RISC-V: KVM: Implement stage2 page
> table programming"). But they were both part of the first KVM
> patchset, so I only took the oldest one, but tell me if you want me to
> split the patch into 2 different patches that fix one commit at a
> time.
>
> Fixes: 9d05c1fee837 ("RISC-V: KVM: Implement stage2 page table programming")

The Linux-6.3 merge window is near so I have queued this patch
for Linux-6.3

Thanks,
Anup

>
> Thanks,
>
> Alex
>
> >
> > Regards,
> > Anup
> >
> > >
> > > On 1/23/23 10:29, Alexandre Ghiti wrote:
> > > > At the moment, riscv only supports PMD and PUD hugepages. For sv39,
> > > > PGDIR_SIZE == PUD_SIZE but not for sv48 and sv57. So fix this by changing
> > > > PGDIR_SIZE into PUD_SIZE.
> > > >
> > > > Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> > > > ---
> > > >   arch/riscv/kvm/mmu.c | 8 ++++----
> > > >   1 file changed, 4 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> > > > index 34b57e0be2ef..dbc4ca060174 100644
> > > > --- a/arch/riscv/kvm/mmu.c
> > > > +++ b/arch/riscv/kvm/mmu.c
> > > > @@ -585,7 +585,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> > > >       if (!kvm->arch.pgd)
> > > >               return false;
> > > >
> > > > -     WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
> > > > +     WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
> > > >
> > > >       if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
> > > >                                  &ptep, &ptep_level))
> > > > @@ -603,7 +603,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> > > >       if (!kvm->arch.pgd)
> > > >               return false;
> > > >
> > > > -     WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
> > > > +     WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
> > > >
> > > >       if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
> > > >                                  &ptep, &ptep_level))
> > > > @@ -645,12 +645,12 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
> > > >       if (logging || (vma->vm_flags & VM_PFNMAP))
> > > >               vma_pagesize = PAGE_SIZE;
> > > >
> > > > -     if (vma_pagesize == PMD_SIZE || vma_pagesize == PGDIR_SIZE)
> > > > +     if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
> > > >               gfn = (gpa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
> > > >
> > > >       mmap_read_unlock(current->mm);
> > > >
> > > > -     if (vma_pagesize != PGDIR_SIZE &&
> > > > +     if (vma_pagesize != PUD_SIZE &&
> > > >           vma_pagesize != PMD_SIZE &&
> > > >           vma_pagesize != PAGE_SIZE) {
> > > >               kvm_err("Invalid VMA page size 0x%lx\n", vma_pagesize);
