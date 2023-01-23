Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B1C677E28
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 15:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbjAWOe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 09:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjAWOe7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 09:34:59 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A640B166E7
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 06:34:57 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id f25-20020a1c6a19000000b003da221fbf48so8710285wmc.1
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 06:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NYXZO/+I6Tj2auHQUaN1mdyHA2APFOFcC7l9cjd5m1Y=;
        b=y577DC+FR1wR2ZTMehaJlhUMpSWt8y2gpVM/9KIRwXh79iW4ZLkIo+qLG8+Gk9b9/9
         F8bVnG9AhPGet/xEeBHGlr/TsLhM66hyrBA5xpGXv90VkpQ7MFTlpq7rvC7nuVLyIO9n
         4By5CKfAz1J9gAvJ6Dgb/UUScWX7D7A92hk2ohw/rMpfNUgSKFXRzrtc+vqYUatXsSt9
         eLIbZDf2X/dbJUAU6va4kwpkolP+EOmhgiTGS8eDS/9hvRYCn6eP9F5oGHVvWZOpPwHP
         yohI6I+don/JVbDtnTXNlQBfLHf+/ombNMJZxcyA00HRgu1P81C8mzU5rHmSQ/uMXfVC
         27kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NYXZO/+I6Tj2auHQUaN1mdyHA2APFOFcC7l9cjd5m1Y=;
        b=X4wXyZbxgcw2DHEu+JMes/1UBAap9nRTJYgyDaGxzi4qBZWo7I51k+VsZjtqVMTpFj
         98tgqnlJvGg+6QPdnyjzKm7NYlFpCxd2tyiPb94XxFtmLrxK8aDKsiVZkjhkaRlkoCEb
         HRSA/vDS8Men/JcZv6TY6dNHjmKk4SxSwoqj0ACrht065UAirDkoOBCmola7ubJHDoMB
         rb4NpF1X6yvja5FCkqOSYumP4y+xWWEYex+Cp3pWeAO1qnYQsYxujz00/co8kw9n3NrQ
         EsjPyGmGu8u6CQon/JG4yazE1LSvychyeSpPbw2QVRf75kJmJL/OnoVqDroOrSpAJQI6
         31XQ==
X-Gm-Message-State: AFqh2krbW/lLdXwGTD2Zaod7+NFKqnnKCO2Nu9YWvJGby1vLGxWKKEAs
        VPCZfn4KLBpbxoJNS3WrlTd2VawmyCCLh4teyfdjQHNkaO9ygQ1m
X-Google-Smtp-Source: AMrXdXu0vsOo+SyPBXHsKyMNnmlRi1Rm0z1Zb/nnYJgByqkr1cktzTfdINU/WrgqZiQ85maXTmDh+hayFkqFAVvZiQM=
X-Received: by 2002:a05:600c:4d14:b0:3da:ff1f:e89e with SMTP id
 u20-20020a05600c4d1400b003daff1fe89emr1691278wmp.7.1674484496273; Mon, 23 Jan
 2023 06:34:56 -0800 (PST)
MIME-Version: 1.0
References: <20230123092928.808014-1-alexghiti@rivosinc.com>
 <bdabafb1-53f3-403c-ab9c-1c2d00421690@ghiti.fr> <CAAhSdy1grLz2EXEJUicGFZO7md7F=Hbnhv7ZqBFFx-vtnkpmmA@mail.gmail.com>
In-Reply-To: <CAAhSdy1grLz2EXEJUicGFZO7md7F=Hbnhv7ZqBFFx-vtnkpmmA@mail.gmail.com>
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
Date:   Mon, 23 Jan 2023 15:34:45 +0100
Message-ID: <CAHVXubjHBu7F9xaERTR6vppsUph2U8JX1DRSrFUAWs-jJ_8ncQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: RISC-V: Fix wrong usage of PGDIR_SIZE to check page sizes
To:     Anup Patel <anup@brainfault.org>
Cc:     Alexandre Ghiti <alex@ghiti.fr>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 23, 2023 at 12:28 PM Anup Patel <anup@brainfault.org> wrote:
>
> On Mon, Jan 23, 2023 at 3:01 PM Alexandre Ghiti <alex@ghiti.fr> wrote:
> >
> > @Anup: Sorry, forgot to add -fixes to the patch title, as I think this
> > should go into your fixes branch for 6.2.
>
> Can you provide the Fixes: line here ? I will include it at time of
> adding this patch to my fixes branch.

It actually fixes 2 commits: 9955371cc014 ("RISC-V: KVM: Implement MMU
notifiers") and 9d05c1fee837 ("RISC-V: KVM: Implement stage2 page
table programming"). But they were both part of the first KVM
patchset, so I only took the oldest one, but tell me if you want me to
split the patch into 2 different patches that fix one commit at a
time.

Fixes: 9d05c1fee837 ("RISC-V: KVM: Implement stage2 page table programming")

Thanks,

Alex

>
> Regards,
> Anup
>
> >
> > On 1/23/23 10:29, Alexandre Ghiti wrote:
> > > At the moment, riscv only supports PMD and PUD hugepages. For sv39,
> > > PGDIR_SIZE == PUD_SIZE but not for sv48 and sv57. So fix this by changing
> > > PGDIR_SIZE into PUD_SIZE.
> > >
> > > Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> > > ---
> > >   arch/riscv/kvm/mmu.c | 8 ++++----
> > >   1 file changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> > > index 34b57e0be2ef..dbc4ca060174 100644
> > > --- a/arch/riscv/kvm/mmu.c
> > > +++ b/arch/riscv/kvm/mmu.c
> > > @@ -585,7 +585,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> > >       if (!kvm->arch.pgd)
> > >               return false;
> > >
> > > -     WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
> > > +     WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
> > >
> > >       if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
> > >                                  &ptep, &ptep_level))
> > > @@ -603,7 +603,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> > >       if (!kvm->arch.pgd)
> > >               return false;
> > >
> > > -     WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
> > > +     WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
> > >
> > >       if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
> > >                                  &ptep, &ptep_level))
> > > @@ -645,12 +645,12 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
> > >       if (logging || (vma->vm_flags & VM_PFNMAP))
> > >               vma_pagesize = PAGE_SIZE;
> > >
> > > -     if (vma_pagesize == PMD_SIZE || vma_pagesize == PGDIR_SIZE)
> > > +     if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
> > >               gfn = (gpa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
> > >
> > >       mmap_read_unlock(current->mm);
> > >
> > > -     if (vma_pagesize != PGDIR_SIZE &&
> > > +     if (vma_pagesize != PUD_SIZE &&
> > >           vma_pagesize != PMD_SIZE &&
> > >           vma_pagesize != PAGE_SIZE) {
> > >               kvm_err("Invalid VMA page size 0x%lx\n", vma_pagesize);
