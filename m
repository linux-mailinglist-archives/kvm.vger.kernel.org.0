Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4AC7195CB
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 10:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbjFAIkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 04:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbjFAIjc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 04:39:32 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608031B3;
        Thu,  1 Jun 2023 01:38:40 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-30789a4c537so534985f8f.0;
        Thu, 01 Jun 2023 01:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685608719; x=1688200719;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RWj0okTmH1/Iwkq+XM29U+ErdzrXEOxYzcXAhUEQaJY=;
        b=n7Skum7oCgWWlbn9Xt9Bum2UemlCyB+lov3V713Qv4hSHdaws4/CV5hL5FhY9KGtKm
         kLl5jOfWtWSo3ayvQMvne8ejA1Qw1LPODhEdTUIHxtdDAZk+cxOnuzaF6TxHvQFQx7Lx
         96pfzgpWACbCbppIOfiMl4gYRB4JWVIo9r2jf0jsjCApQ1nnuKAbMfQzEV1ebe0PzNVb
         LlW8YcBUA47cTuYR5ebpQlBokje64LIDJnFI6A9bWs+1/DL1/Xf6lkAPfsbOE1CEo7Ej
         M9Bqxtq/uxwMGPLPC6wqpKWXcTNs8HA9+aDL8t0iXSwLdTQPGhXPlGsFHJqVdPUM0rJg
         017Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685608719; x=1688200719;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RWj0okTmH1/Iwkq+XM29U+ErdzrXEOxYzcXAhUEQaJY=;
        b=RyIo3eJG924ypHJDiO4fGrlGuoSMlBOlfZMZVUI5L7kNI/1ROMoVy/CqxEDhLYsatX
         FP5GziIYNFM2vrjMv1zvIPU7NssVtsxvVtFkTrzYBZH2R1iCnVTo7QqSJGq8ueFLWC2+
         eKOZg2y7gaxj2Krs12tA69qlxd3u87wtTfNIYgExweU5xn33eVQnlv6LWrWy+NNxN7H3
         mG3aQ2eLy2K13RBOjyrEgHjRtx4UY5TvDOTPXUnTUcMIfoVLUb1eyA+UnZOf6faRwzde
         AR0ElV5AYp281tM1uwcbFAZfhvyX7eq9hS12Oi/r9DPeJoeiaE5SbM8Qf80GVKDrcrEG
         veCw==
X-Gm-Message-State: AC+VfDwePASBhneonh6nB6B7/DJakQqiVHTkltKyxylO0DGQUpIm6TTR
        s8rmwhuq2mxJ9NnXK0yhdgRJAEBtAzYUdBBeTp4=
X-Google-Smtp-Source: ACHHUZ41KegIhPxEAmnPEMAsOlewS4E1I9wNIROgrmATHvZQwrnLbLtdlrb6bxnhtmB1X9cC2trI3jl6qXBTMrTak/k=
X-Received: by 2002:adf:ed83:0:b0:309:507a:3f5b with SMTP id
 c3-20020adfed83000000b00309507a3f5bmr1040562wro.8.1685608718320; Thu, 01 Jun
 2023 01:38:38 -0700 (PDT)
MIME-Version: 1.0
References: <CADpTngX9LESCdHVu_2mQkNGena_Ng2CphWNwsRGSMxzDsTjU2A@mail.gmail.com>
 <ZHNMsmpo2LWjnw1A@debian.me> <CADpTngWiXNh1wAFM_EYGm-Coa8nv61Tu=3TG+Z2dVCojp2K1yg@mail.gmail.com>
 <ZHY0WkNlui91Mxoj@google.com> <ZHaikcUjbkq7yVbi@google.com> <ZHarJCvD1KEkLVM+@google.com>
In-Reply-To: <ZHarJCvD1KEkLVM+@google.com>
From:   Fabio Coatti <fabio.coatti@gmail.com>
Date:   Thu, 1 Jun 2023 10:38:26 +0200
Message-ID: <CADpTngU+L_dECPRdPPM+DoRyVMwBLEowBmwg2cvKwu_BmTaoNw@mail.gmail.com>
Subject: Re: WARNING trace at kvm_nx_huge_page_recovery_worker on 6.3.4
To:     Sean Christopherson <seanjc@google.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, stable@vger.kernel.org,
        regressions@lists.linux.dev, kvm@vger.kernel.org,
        Junaid Shahid <junaids@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Il giorno mer 31 mag 2023 alle ore 04:04 Sean Christopherson
<seanjc@google.com> ha scritto:
>
> On Tue, May 30, 2023, Sean Christopherson wrote:
> > On Tue, May 30, 2023, Sean Christopherson wrote:
> > > On Tue, May 30, 2023, Fabio Coatti wrote:
> > > > Il giorno dom 28 mag 2023 alle ore 14:44 Bagas Sanjaya
> > > > <bagasdotme@gmail.com> ha scritto:
> > > > > #regzbot ^introduced: v6.3.1..v6.3.2
> > > > > #regzbot title: WARNING trace at kvm_nx_huge_page_recovery_worker when opening a new tab in Chrome
> > > >
> > > > Out of curiosity, I recompiled 6.3.4 after reverting the following
> > > > commit mentioned in 6.3.2 changelog:
> > > >
> > > > commit 2ec1fe292d6edb3bd112f900692d9ef292b1fa8b
> > > > Author: Sean Christopherson <seanjc@google.com>
> > > > Date:   Wed Apr 26 15:03:23 2023 -0700
> > > > KVM: x86: Preserve TDP MMU roots until they are explicitly invalidated
> > > > commit edbdb43fc96b11b3bfa531be306a1993d9fe89ec upstream.
> > > >
> > > > And the WARN message no longer appears on my host kernel logs, at
> > > > least so far :)
> > >
> > > Hmm, more than likely an NX shadow page is outliving a memslot update.  I'll take
> > > another look at those flows to see if I can spot a race or leak.
> >
> > I didn't spot anything, and I couldn't reproduce the WARN even when dropping the
> > dirty logging requirement and hacking KVM to periodically delete memslots.
>
> Aha!  Apparently my brain was just waiting until I sat down for dinner to have
> its lightbulb moment.
>
> The memslot lookup isn't factoring in whether the shadow page is for non-SMM versus
> SMM.  QEMU configures SMM to have memslots that do not exist in the non-SMM world,
> so if kvm_recover_nx_huge_pages() encounters an SMM shadow page, the memslot lookup
> can fail to find a memslot because it looks only in the set of non-SMM memslots.
>
> Before commit 2ec1fe292d6e ("KVM: x86: Preserve TDP MMU roots until they are
> explicitly invalidated"), KVM would zap all SMM TDP MMU roots and thus all SMM TDP
> MMU shadow pages once all vCPUs exited SMM.  That made the window where this bug
> could be encountered quite tiny, as the NX recovery thread would have to kick in
> while at least one vCPU was in SMM.  QEMU VMs typically only use SMM during boot,
> and so the "bad" shadow pages were gone by the time the NX recovery thread ran.
>
> Now that KVM preserves TDP MMU roots until they are explicity invalidated (by a
> memslot deletion), the window to encounter the bug is effectively never closed
> because QEMU doesn't delete memslots after boot (except for a handful of special
> scenarios.
>
> Assuming I'm correct, this should fix the issue:
>
> ---
>  arch/x86/kvm/mmu/mmu.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d3812de54b02..d5c03f14cdc7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7011,7 +7011,10 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
>                  */
>                 slot = NULL;
>                 if (atomic_read(&kvm->nr_memslots_dirty_logging)) {
> -                       slot = gfn_to_memslot(kvm, sp->gfn);
> +                       struct kvm_memslots *slots;
> +
> +                       slots = kvm_memslots_for_spte_role(kvm, sp->role);
> +                       slot = __gfn_to_memslot(slots, sp->gfn);
>                         WARN_ON_ONCE(!slot);
>                 }
>
>
> base-commit: 17f2d782f18c9a49943ea723d7628da1837c9204

I applied this patch on the same kernel I was using for testing
(6.3.4) and indeed I'm no longer able to see the WARN message, so I
assume that you are indeed correct :) . Many thanks, it seems to be
fixed at least on my machine!



-- 
Fabio
