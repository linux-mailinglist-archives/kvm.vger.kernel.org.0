Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A610683414
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 18:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjAaRlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 12:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjAaRld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 12:41:33 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB940577E9
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:41:31 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id y8so16936490vsq.0
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UCx2vxuL1yW/aqxFsyC3X5oRhoumoRb7Us6ry2Ohm/8=;
        b=B0WIQQRWtqXFIMW9ne1pzR1geefcm/QBxSmIuRLA/pM2gElyoWJVOwQ2mWMC5PpPbL
         AuRKonYdBvkAw3tSI3kNQGAcFyhUHf7cnuJ5Nf9swNsiIMadu19g79LifXnTzP0HxRCD
         sdE9+BkWVWJAo7kJyw0Sk0+4j9zIsdP6oEIGDdwlqxFYE4rJhB3tvmF6rA/uMeDqXRBc
         LNBQnQ7NVZAik8DVzFmJ3cNNR2h7OSylhZ/XUhrbIk/VeZw6DdNKL0cfFA1H40P+hDgw
         hBVZJgGClW0yAb4e7qZf66Y7dcP4Xn+xGcaQbFOGVyCfcAMu+yAXqUPQabJxYIjTVfpu
         av4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UCx2vxuL1yW/aqxFsyC3X5oRhoumoRb7Us6ry2Ohm/8=;
        b=SpnN7+sK2707ijmvjRJVowixlCfMmzK0zVnTLhCJrDr1/Fvs54+6TAUvgweHUTCRvr
         cN92TsngVX532dGjME8XoT6IZEPi/RdN+N7oShz0sEaPBk9BF/tHm4zcjIIrRy9z4i3f
         bVqgc6XrnzZe4neRd+/zy5OFEVGM7OjswFzaFOnXgIUw22JPk+mIfmpZAXDQUNDgHeVa
         hPDBnp3f2wh5CykhDLJWpCgLFhnCoFTls2aAPLeNRfI9/dGt/+8fpBBI4ZI0xd/NsBgl
         f0q/T9yij6ZXfwdOkqwjyvwopzBTUqPBDo8QTxbIVvp15H/UT/IoJrgUvyI+qdpWtzCa
         G3gw==
X-Gm-Message-State: AO0yUKX7EidvgTCe7lKjwP0RsG135CXn21yO4jjDJc0zCV10vZzC7FIv
        JDx7iWk2rFWzHesXfdntJQzuI6F+XpN2KsiWXjil/w==
X-Google-Smtp-Source: AK7set+yL0wuf4gZ5gqpcdiUgDKC3nPewltObXz/OcIl30zT//GOyIPopTSsoFr61d+v5YhgvAnROqDwILyFLm+sA2E=
X-Received: by 2002:a67:f812:0:b0:3eb:dd6d:487d with SMTP id
 l18-20020a67f812000000b003ebdd6d487dmr2680061vso.16.1675186890959; Tue, 31
 Jan 2023 09:41:30 -0800 (PST)
MIME-Version: 1.0
References: <20230125213857.824959-1-vipinsh@google.com> <Y9GmiyRQ6sULCjEG@google.com>
 <CANgfPd9T7jdh1Cjjo4y6DcxC2poTaGhQ7wNLf6OgGtStg-yKJg@mail.gmail.com>
 <Y9HcHRBShQgjxsQb@google.com> <CALzav=fkmS0U4tb4trDtbCmDxo27EcJeOWbiwb+meagj9+PFiw@mail.gmail.com>
 <Y9hXmz/nDOr1hQal@google.com>
In-Reply-To: <Y9hXmz/nDOr1hQal@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 31 Jan 2023 09:41:04 -0800
Message-ID: <CALzav=cEoF4E3hYStpDDdi_RWvCYXF9iXvznbL234uuEQ0Zv=g@mail.gmail.com>
Subject: Re: [Patch] KVM: x86/mmu: Make optimized __handle_changed_spte() for
 clear dirty log
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>, Vipin Sharma <vipinsh@google.com>,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Mon, Jan 30, 2023 at 3:49 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jan 30, 2023, David Matlack wrote:
> > On Wed, Jan 25, 2023 at 5:49 PM Sean Christopherson <seanjc@google.com> wrote:
> > [...]
> > > ---
> > >  arch/x86/kvm/mmu/tdp_mmu.c | 92 ++++++++++----------------------------
> > >  1 file changed, 24 insertions(+), 68 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index bba33aea0fb0..2f78ca43a276 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > [...]
> > > @@ -1289,8 +1244,7 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
> > >                 new_spte = mark_spte_for_access_track(new_spte);
> > >         }
> > >
> > > -       tdp_mmu_set_spte_no_acc_track(kvm, iter, new_spte);
> > > -
> > > +       kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte, new_spte, iter->level);
> >
> > This can race with fast_page_fault() setting the W-bit and the CPU
> > setting the D-bit. i.e. This call to kvm_tdp_mmu_write_spte() could
> > clear the W-bit or D-bit.
>
> Ugh, right.  Hrm.  Duh, I just didn't go far enough.  A straight XCHG is silly.
> Except for the access-tracking mess, KVM wants to clear a single bit.  Writing
> the entire thing and potentially clobbering bits is wasteful and unnecessarily
> dangerous.  And the access-tracking code already needs special handling.
>
> We can just simplify this all by adding a helper to clear a single bit (and
> maybe even use clear_bit() and __clear_bit() if we save the bit number for the
> W/A/D bits and not just the mask).  And if it weren't for EPT (different A/D
> locations), we could even use static asserts to restrict the usage to the W/A/D
> bits :-/  Oh well.
>
> E.g. this

This patch looks good. Vipin can you incorporate this in your next version?
