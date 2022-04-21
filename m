Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F5950A629
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 18:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbiDUQtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 12:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbiDUQt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 12:49:29 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BC649245
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:46:39 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e1so3429783ile.2
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ckFrAKsgzMvhyYwd1DVzzN/3nS9H6cXtvsMtyZqX9aM=;
        b=GGnQsYCBc7m0sb4hHXxmKxyVDlaKtiaUHTSkrcsRbKdnF/OLl9BH9pkaG8KmPePwAH
         GFnZvAnXZTNxNDVxKvJkJmlFGbDhiP+zy8Z3LECciut3GiViyDXLAAuyDjhcvgvCHd95
         9RZno8WXANvk1HA27qMQsBhii5EMRryAqFjMHiA6jQZ89AnnpaarP0duHppYZ+nG5SZv
         c66Bk7ryt53J/3iOloBULhibsniEkSISPrkGaQYvqiUq2fcHGaw89VI+6Wveqzv+9dxy
         ZR/Jw0K3SrcDXPSnc73yUsx4FXiPdd6DMCbMoeCWI5y1g2cc4geCxc1qUCY15L7+5TuW
         3xfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ckFrAKsgzMvhyYwd1DVzzN/3nS9H6cXtvsMtyZqX9aM=;
        b=tSRrpY6j+0SgVR/1HcB4GXSbuUaqDDr4x5ydkGtb62ydNvzPcEsfeINS6q3fVHURuQ
         78gaTX3bv7UY2g6MI72tBenS8T/rwx0jgwRwNoikEbVbyYIyQpETiteKdLWYMdx65g/l
         Jf32DCkk4olk3J/SvDKthvfCU7t//fcbluzdbT1RNoeiI7dlMviCiTP/jF5rTvwOLDJy
         6Vb2hruYhAfDYMt22UkWDYpHjSisFlErbMPBhHi1rQFk/9WgHwbE7yg2uPeVG6Ejd9we
         yh8nYRF0Ddk6pCT+Nxc5NCbJf6fWGlmpodd8Z6d+y/c3IS/kdYReJv6avLQ5ewazdt4h
         3H2A==
X-Gm-Message-State: AOAM533mZWYBzuxIMJDploaJDEf6lJMsbD35Sue1y3jSoDnqLqZCpVri
        uWYPjUFcSdE9JSl3v2gplnLlNg==
X-Google-Smtp-Source: ABdhPJxWbQuijQVv7g9clCzQllXZaGyUynAlG+W8mud7Ir6TVd5bJHybLM8Rf2hpLE1AQFIvqx0Uow==
X-Received: by 2002:a05:6e02:1d83:b0:2cc:1dbc:7c34 with SMTP id h3-20020a056e021d8300b002cc1dbc7c34mr285019ila.315.1650559598456;
        Thu, 21 Apr 2022 09:46:38 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id p6-20020a0566022b0600b0064c59797e67sm15044931iov.46.2022.04.21.09.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 09:46:37 -0700 (PDT)
Date:   Thu, 21 Apr 2022 16:46:34 +0000
From:   Oliver Upton <oupton@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [RFC PATCH 16/17] KVM: arm64: Enable parallel stage 2 MMU faults
Message-ID: <YmGKaoStt9Lf9xOP@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-17-oupton@google.com>
 <CANgfPd9bb213hsdKTMW9K0EsVLuKEKCF8V0pb6xM1qfnRj1qfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd9bb213hsdKTMW9K0EsVLuKEKCF8V0pb6xM1qfnRj1qfw@mail.gmail.com>
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

On Thu, Apr 21, 2022 at 09:35:27AM -0700, Ben Gardon wrote:
> On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
> >
> > Voila! Since the map walkers are able to work in parallel there is no
> > need to take the write lock on a stage 2 memory abort. Relax locking
> > on map operations and cross fingers we got it right.
> 
> Might be worth a healthy sprinkle of lockdep on the functions taking
> "shared" as an argument, just to make sure the wrong value isn't going
> down a callstack you didn't expect.

If we're going to go this route we might need to just punch a pointer
to the vCPU through to the stage 2 table walker. All of this plumbing is
built around the idea that there are multiple tables to manage and
needn't be in the context of a vCPU/VM, which is why I went the WARN()
route instead of better lockdep assertions.

> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 21 +++------------------
> >  1 file changed, 3 insertions(+), 18 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 63cf18cdb978..2881051c3743 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1127,7 +1127,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >         gfn_t gfn;
> >         kvm_pfn_t pfn;
> >         bool logging_active = memslot_is_logging(memslot);
> > -       bool use_read_lock = false;
> >         unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
> >         unsigned long vma_pagesize, fault_granule;
> >         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > @@ -1162,8 +1161,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >         if (logging_active) {
> >                 force_pte = true;
> >                 vma_shift = PAGE_SHIFT;
> > -               use_read_lock = (fault_status == FSC_PERM && write_fault &&
> > -                                fault_granule == PAGE_SIZE);
> >         } else {
> >                 vma_shift = get_vma_page_shift(vma, hva);
> >         }
> > @@ -1267,15 +1264,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >         if (exec_fault && device)
> >                 return -ENOEXEC;
> >
> > -       /*
> > -        * To reduce MMU contentions and enhance concurrency during dirty
> > -        * logging dirty logging, only acquire read lock for permission
> > -        * relaxation.
> > -        */
> > -       if (use_read_lock)
> > -               read_lock(&kvm->mmu_lock);
> > -       else
> > -               write_lock(&kvm->mmu_lock);
> > +       read_lock(&kvm->mmu_lock);
> > +
> 
> Ugh, I which we could get rid of the analogous ugly block on x86.

Maybe we could fold it in to a MMU macro in the arch-generic scope?
Conditional locking is smelly, I was very pleased to delete these lines :)

--
Thanks,
Oliver
