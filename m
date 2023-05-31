Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B0371737B
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 04:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbjEaCEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 22:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjEaCEX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 22:04:23 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64EBEC
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 19:04:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba88ec544ddso10530196276.1
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 19:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685498662; x=1688090662;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oPl0xAXqZdbO8EtlrXhUJMISF8AeYDK8P/cmISui4pg=;
        b=JvvW5QCObtQiz9h/evP/xIfXhzSlfwKhz08eNhiNC4h0IAQUECdkWGa9y1FBwjVk1G
         nr1CqaC+qfbXFOS9OdQUOdJIwB+nsSySKCjJLrvGvg9s34ZfdnxBl0SGp0eudgdnz0RT
         rJXHsSWH/Br6TTUaLSbYa5WoAS02LrJ47eik/kNaQDQ7X1rhLl36n2utUU5ABG9tnkrF
         R0BVFaastWzrnVkID9KBBw2hVvGlG1p2rtouCemYaT+NtFhyiamUe8nmaIsEZE1oz+rs
         QOBiJ/5D6IBprILDtd52Og6AfUCGfHLB85l56sGvc0j1raYQiOy4MSnM6K3TPm73lb7m
         0uHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685498662; x=1688090662;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oPl0xAXqZdbO8EtlrXhUJMISF8AeYDK8P/cmISui4pg=;
        b=C7XI4m1GaZKL40bpPYaCouaxyEYS0dtMqoDadX5K1KlmnR6VXFk/JUYDlyLUGZbJl4
         NUK2FKm4AaG0uX4TzH7PgNdssUFTj1O2DUmYTlwFN+ezF1mhZ1GqleJB9ehs8PUZImez
         3SyD4SG7dg4q4JDfobkrF3g/FqomPs/8BbPR8wESZtuvwrZQ+kPgQFGPBZRaeHOFcw8M
         wQJEtGrofT6rI0P0IwE0XlEdlPKE1YZD/hAOElfaBcafxhrlvRwV/y7mwv+gGA4u2yzE
         +H7S5C7RwG1Sa1n0KTJhII0znmu0ucwpw8RncgEKAua9noL9uU0diTQ0q+TXqNppmmTb
         5ZeA==
X-Gm-Message-State: AC+VfDy5TITwKPZFicMTyLUu4ylUUpeCB/Z6JzV+BLqDdrirAo6Af99T
        GUzsEyM41yOxkZVqwNVMP6snYRs/uaM=
X-Google-Smtp-Source: ACHHUZ7xMW17agGZrMwJlLjH/cZpm7MCbX6aTZYwGgZHZTC+cOEziKmXRj6cKcqzRhqQhXrbPH2PtlQ7I9Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:543:b0:bab:cc56:76c2 with SMTP id
 z3-20020a056902054300b00babcc5676c2mr2508734ybs.8.1685498661884; Tue, 30 May
 2023 19:04:21 -0700 (PDT)
Date:   Tue, 30 May 2023 19:04:20 -0700
In-Reply-To: <ZHaikcUjbkq7yVbi@google.com>
Mime-Version: 1.0
References: <CADpTngX9LESCdHVu_2mQkNGena_Ng2CphWNwsRGSMxzDsTjU2A@mail.gmail.com>
 <ZHNMsmpo2LWjnw1A@debian.me> <CADpTngWiXNh1wAFM_EYGm-Coa8nv61Tu=3TG+Z2dVCojp2K1yg@mail.gmail.com>
 <ZHY0WkNlui91Mxoj@google.com> <ZHaikcUjbkq7yVbi@google.com>
Message-ID: <ZHarJCvD1KEkLVM+@google.com>
Subject: Re: WARNING trace at kvm_nx_huge_page_recovery_worker on 6.3.4
From:   Sean Christopherson <seanjc@google.com>
To:     Fabio Coatti <fabio.coatti@gmail.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, stable@vger.kernel.org,
        regressions@lists.linux.dev, kvm@vger.kernel.org,
        Junaid Shahid <junaids@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023, Sean Christopherson wrote:
> On Tue, May 30, 2023, Sean Christopherson wrote:
> > On Tue, May 30, 2023, Fabio Coatti wrote:
> > > Il giorno dom 28 mag 2023 alle ore 14:44 Bagas Sanjaya
> > > <bagasdotme@gmail.com> ha scritto:
> > > > #regzbot ^introduced: v6.3.1..v6.3.2
> > > > #regzbot title: WARNING trace at kvm_nx_huge_page_recovery_worker when opening a new tab in Chrome
> > > 
> > > Out of curiosity, I recompiled 6.3.4 after reverting the following
> > > commit mentioned in 6.3.2 changelog:
> > > 
> > > commit 2ec1fe292d6edb3bd112f900692d9ef292b1fa8b
> > > Author: Sean Christopherson <seanjc@google.com>
> > > Date:   Wed Apr 26 15:03:23 2023 -0700
> > > KVM: x86: Preserve TDP MMU roots until they are explicitly invalidated
> > > commit edbdb43fc96b11b3bfa531be306a1993d9fe89ec upstream.
> > > 
> > > And the WARN message no longer appears on my host kernel logs, at
> > > least so far :)
> > 
> > Hmm, more than likely an NX shadow page is outliving a memslot update.  I'll take
> > another look at those flows to see if I can spot a race or leak.
> 
> I didn't spot anything, and I couldn't reproduce the WARN even when dropping the
> dirty logging requirement and hacking KVM to periodically delete memslots.

Aha!  Apparently my brain was just waiting until I sat down for dinner to have
its lightbulb moment.

The memslot lookup isn't factoring in whether the shadow page is for non-SMM versus
SMM.  QEMU configures SMM to have memslots that do not exist in the non-SMM world,
so if kvm_recover_nx_huge_pages() encounters an SMM shadow page, the memslot lookup
can fail to find a memslot because it looks only in the set of non-SMM memslots.

Before commit 2ec1fe292d6e ("KVM: x86: Preserve TDP MMU roots until they are
explicitly invalidated"), KVM would zap all SMM TDP MMU roots and thus all SMM TDP
MMU shadow pages once all vCPUs exited SMM.  That made the window where this bug
could be encountered quite tiny, as the NX recovery thread would have to kick in
while at least one vCPU was in SMM.  QEMU VMs typically only use SMM during boot,
and so the "bad" shadow pages were gone by the time the NX recovery thread ran.

Now that KVM preserves TDP MMU roots until they are explicity invalidated (by a
memslot deletion), the window to encounter the bug is effectively never closed
because QEMU doesn't delete memslots after boot (except for a handful of special
scenarios.

Assuming I'm correct, this should fix the issue:

---
 arch/x86/kvm/mmu/mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d3812de54b02..d5c03f14cdc7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7011,7 +7011,10 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 		 */
 		slot = NULL;
 		if (atomic_read(&kvm->nr_memslots_dirty_logging)) {
-			slot = gfn_to_memslot(kvm, sp->gfn);
+			struct kvm_memslots *slots;
+
+			slots = kvm_memslots_for_spte_role(kvm, sp->role);
+			slot = __gfn_to_memslot(slots, sp->gfn);
 			WARN_ON_ONCE(!slot);
 		}
 

base-commit: 17f2d782f18c9a49943ea723d7628da1837c9204
-- 
