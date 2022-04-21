Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C728D50A87D
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 20:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358387AbiDUSzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 14:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbiDUSzc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 14:55:32 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624004C409
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 11:52:41 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id z19so1691588iof.12
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 11:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=swSRzKm5q0U28ACmf4EZZ+mBiZZlElbUcKa/JVKE+ZM=;
        b=Y9EwVZt3dzwUlz1pJbNp8azm9sUrHMHSeQIs/PBxwUytNGxZ115TNfL02V9tL8hebs
         ZEG03FG2kHM+3NIQg3cJDdNbXBR0MV30yoV/0Tix/F8/IOIedGuZcaoiW2HPmqiXG3yS
         ndxajDvVKTZRtUIzRYj/W5l5REF/lu55Uy/0fxSS9aTaFqftB6vJpoy2eauW53zrerbN
         4Qyf7UQmjdozkvARuY2twSIgusgRapZSMOFzTkcQyJXe+9FMqmYEVb5Hu+7ad6jzsrD8
         GKH9PJ/IarpqPV8r3GBF5uYT97FNePpt8AHpNxBvbqjtHE6ePVpfv67H19NeEH+I8goE
         BfGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=swSRzKm5q0U28ACmf4EZZ+mBiZZlElbUcKa/JVKE+ZM=;
        b=aChTP0i1vw6f5H+MkfRIFapTxQIVJL6zUt+bzJBS4Tj4QxEejSev8GAgMcYqwV6DVE
         u1MqbCP5DPy4cdu3cAxHP9dBZX0pD6UOlI9iYlhjIq03F22vDptneoM99CIZMEYXswKc
         W2cXYgb+GyiNOmLcJhbk1BxDfcubwgJeZ5dK96ib580CzwDHQ2TSMNbMWyp/mybaqBm5
         UrWGEs/94kIx6h10R6Xrrmbg1xrJ1fiKj7V5Gi5kjOIdE+HXBHuex9zjNNnDZpmzCLi6
         0CXf0IgDWtk1S5tsDhIdMkqe92vk4+nPFqL2ygyaTvoGXsIkQ0dAVzEtt8Jmacfi8zOe
         CqOg==
X-Gm-Message-State: AOAM530HnhrrvFxVvOGlEvxOo65vXwAX9U+DXVxpbGVg9MAf2gtViyNp
        LpNRuQ6yQALLUrdoxB9Q9nyYgw==
X-Google-Smtp-Source: ABdhPJzOfxLyJiiz19R6ch1LlTTcyvQsX0IvVMdBe8ACUJmzB7QDS67cWKXDVE64Ltcl/mJlJaRoFA==
X-Received: by 2002:a5d:9c87:0:b0:657:2670:35a8 with SMTP id p7-20020a5d9c87000000b00657267035a8mr522670iop.42.1650567160292;
        Thu, 21 Apr 2022 11:52:40 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id t11-20020a922c0b000000b002c85834eb06sm12931384ile.47.2022.04.21.11.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 11:52:38 -0700 (PDT)
Date:   Thu, 21 Apr 2022 18:52:34 +0000
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
Subject: Re: [RFC PATCH 06/17] KVM: arm64: Implement break-before-make
 sequence for parallel walks
Message-ID: <YmGn8hVSGWvna02R@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-7-oupton@google.com>
 <CANgfPd8RLDtmFks0BLEVyHPaEANF93d4iJxHt3n6cKewQsBLuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8RLDtmFks0BLEVyHPaEANF93d4iJxHt3n6cKewQsBLuA@mail.gmail.com>
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

On Thu, Apr 21, 2022 at 09:57:32AM -0700, Ben Gardon wrote:
> On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
> >
> > The ARM architecture requires that software use the 'break-before-make'
> > sequence whenever memory is being remapped. An additional requirement of
> > parallel page walks is a mechanism to ensure exclusive access to a pte,
> > thereby avoiding two threads changing the pte and invariably stomping on
> > one another.
> >
> > Roll the two concepts together into a new helper to implement the
> > 'break' sequence. Use a special invalid pte value to indicate that the
> > pte is under the exclusive control of a thread. If software walkers are
> > traversing the tables in parallel, use an atomic compare-exchange to
> > break the pte. Retry execution on a failed attempt to break the pte, in
> > the hopes that either the instruction will succeed or the pte lock will
> > be successfully acquired.
> >
> > Avoid unnecessary DSBs and TLBIs by only completing the sequence if the
> > evicted pte was valid. For counted non-table ptes drop the reference
> > immediately. Otherwise, references on tables are dropped in post-order
> > traversal as the walker must recurse on the pruned subtree.
> >
> > All of the new atomics do nothing (for now), as there are a few other
> > bits of the map walker that need to be addressed before actually walking
> > in parallel.
> 
> I want to make sure I understand the make before break / PTE locking
> patterns here.
> Please check my understanding of the following cases:
> 
> Case 1: Change a leaf PTE (for some reason)
> 1. Traverse the page table to the leaf
> 2. Invalidate the leaf PTE, replacing it with a locked PTE
> 3. Flush TLBs
> 4. Replace the locked PTE with the new value
> 
> In this case, no need to lock the parent SPTEs, right? This is pretty simple.

Right, if we're changing the OA of a leaf PTE. If we are just adjusting
attributes on a leaf we go through stage2_attr_walker(), which skips
step 2 and does the rest in this order: 1, 4, 3.

> Case 2:  Drop a page table
> 1. Traverse to some non-leaf PTE
> 2. Lock the PTE, invalidating it
> 3. Recurse into the child page table
> 4. Lock the PTEs in the child page table. (We need to lock ALL the
> PTEs here right? I don't think we'd get away with locking only the
> valid ones)

Right. We can just skip some of the TLBI/DSB dance when making an
invalid->invalid transition.

> 5. Flush TLBs
> 6. Unlock the PTE from 2
> 7. Free the child page after an RCU grace period (via callback)
> 
> Case 3: Drop a range of leaf PTEs
> 1. Traverse the page table to the first leaf
> 2. For each leaf in the range:
>         a. Invalidate the leaf PTE, replacing it with a locked PTE
> 3. Flush TLBs
> 4. unlock the locked PTEs
> 
> In this case we have to lock ALL PTEs in the range too, right? My
> worry about the whole locking scheme is making sure each thread
> correctly remembers which PTEs it locked versus which might have been
> locked by other threads.

Isn't exclusivity accomplished by checking what you get back from the
xchg()? If I get a locked PTE back, some other thread owns the PTE. If I
get anything else, then I've taken ownership of that PTE.

> On x86 we solved this by only locking one SPTE at a time, flushing,
> then fixing it, but if you're locking a bunch at once it might get
> complicated.
> Making this locking scheme work without demolishing performance seems hard.

We only change at most a single active PTE per fault on the stage 2 MMU.
We do one of three things on that path:

 1. Install a page/block PTE to an empty PTE
 2. Replace a table PTE with a block PTE
 3. Replace a block PTE with a table PTE

1 is pretty cheap and can skip flushes altogether.

2 only requires a single TLBI (a big, painful flush of the stage 2 context),
but child PTEs needn't be flushed.

3 also requires a single TLBI, but can be done with an IPA and level
hint.

Perhaps the answer is to push teardown into the rcu callback altogether,
IOW don't mess with links in the subtree until then. At that point
there's no need for TLBIs nor atomics.

--
Thanks,
Oliver
