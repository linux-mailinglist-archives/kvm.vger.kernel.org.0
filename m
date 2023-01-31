Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6687268348D
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 19:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjAaSCS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 13:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjAaSBq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 13:01:46 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0120919690
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 10:01:42 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id e15so19160860ybn.10
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 10:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hG4GAMkUnvveluiCUBOIudNumzLbEEo3tvq5Dtd6sdM=;
        b=d8qqUxV1LG4n6/gqDu6Ip6tvP9Bw16loECWFruKdK+lu3xR/rbBa7gms//GRnUwkqw
         +P8e1LOicvj3Rzj3fXCHZxm6mu27qHlO7N4bfPcsGIVVEds4/Ou+w8GtAQ8hvor7aPNd
         bsZWRkL2k5mZHxy3UxUOV5wNaF+v5qStsCiiH5CcR95TMSxPzfqANnIFPVZ6rH0t8WTy
         xAFkZKEUP5LqQbAUvL7YlnHPaJ749U/45pnv3C5JwjIvIxAYEzVuIWK+vGuWOaNVifl7
         egboZzNGbBXvHxLOG0jSSzqcO0EjPYo1lDZ1/lKC55N8gxZVS2LsvNiJH30QN2IqXRQx
         vE9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hG4GAMkUnvveluiCUBOIudNumzLbEEo3tvq5Dtd6sdM=;
        b=Ea791jlSs/M6WFnWNvWsAllFiHh3wiccaPNTohEIJyVi1WPWoLr/qqWk3X/LT0An0G
         PTcAPlVOo5MGpYZrTe4cinxInCFWMr4G+gPRoFz16me7GsVWT/8FGMF9xdi5lOjra9NG
         9zdnxvxSdPmLKUYoL+ULq6hKUM6YzGauzm997UtuiRrG+LDmAcyKeSq7AiZZSaHwEk0V
         IoP8g8C2d0vVioMC5oOBqaWGIY030t7mTSVilXLPRMCyhp8+ATBOsy+1eq/LtPlEqGpv
         2ZWEwaoGmT2EEmocS7ePhoOekwbpl/MJHhTn8LFyNUd3Gu4Mz9diXPW9ZK/C5+9yrd+A
         zuDg==
X-Gm-Message-State: AFqh2kpeBqa8+hE1A6vykJjD1yQsz0ndsjOeLKrifhLiJOrLYINXmd1g
        ohjfXsk1CIlZ07A5IbsCd6oj0nwzjopR3FdbFW1KuQ==
X-Google-Smtp-Source: AMrXdXuysloz9vrHn2UXJqYC8vrizUYsw18sf4LEybqxDbf32L5omhHK4yRO0E2Krl1z4AII4KGSvzly/0dZIcjlJHg=
X-Received: by 2002:a25:105:0:b0:801:33b9:d9ac with SMTP id
 5-20020a250105000000b0080133b9d9acmr4614810ybb.2.1675188101952; Tue, 31 Jan
 2023 10:01:41 -0800 (PST)
MIME-Version: 1.0
References: <20230125213857.824959-1-vipinsh@google.com> <Y9GmiyRQ6sULCjEG@google.com>
 <CANgfPd9T7jdh1Cjjo4y6DcxC2poTaGhQ7wNLf6OgGtStg-yKJg@mail.gmail.com>
 <Y9HcHRBShQgjxsQb@google.com> <CALzav=fkmS0U4tb4trDtbCmDxo27EcJeOWbiwb+meagj9+PFiw@mail.gmail.com>
 <Y9hXmz/nDOr1hQal@google.com> <CALzav=cEoF4E3hYStpDDdi_RWvCYXF9iXvznbL234uuEQ0Zv=g@mail.gmail.com>
In-Reply-To: <CALzav=cEoF4E3hYStpDDdi_RWvCYXF9iXvznbL234uuEQ0Zv=g@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 31 Jan 2023 10:01:05 -0800
Message-ID: <CAHVum0da7MBi7G4=jwxpjd51s4OZ_JD-u40e9KJteRLKKyej5w@mail.gmail.com>
Subject: Re: [Patch] KVM: x86/mmu: Make optimized __handle_changed_spte() for
 clear dirty log
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>, pbonzini@redhat.com,
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

On Tue, Jan 31, 2023 at 9:41 AM David Matlack <dmatlack@google.com> wrote:
>
> On Mon, Jan 30, 2023 at 3:49 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Jan 30, 2023, David Matlack wrote:
> > > On Wed, Jan 25, 2023 at 5:49 PM Sean Christopherson <seanjc@google.com> wrote:
> > > [...]
> > > > ---
> > > >  arch/x86/kvm/mmu/tdp_mmu.c | 92 ++++++++++----------------------------
> > > >  1 file changed, 24 insertions(+), 68 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > > index bba33aea0fb0..2f78ca43a276 100644
> > > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > [...]
> > > > @@ -1289,8 +1244,7 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
> > > >                 new_spte = mark_spte_for_access_track(new_spte);
> > > >         }
> > > >
> > > > -       tdp_mmu_set_spte_no_acc_track(kvm, iter, new_spte);
> > > > -
> > > > +       kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte, new_spte, iter->level);
> > >
> > > This can race with fast_page_fault() setting the W-bit and the CPU
> > > setting the D-bit. i.e. This call to kvm_tdp_mmu_write_spte() could
> > > clear the W-bit or D-bit.
> >
> > Ugh, right.  Hrm.  Duh, I just didn't go far enough.  A straight XCHG is silly.
> > Except for the access-tracking mess, KVM wants to clear a single bit.  Writing
> > the entire thing and potentially clobbering bits is wasteful and unnecessarily
> > dangerous.  And the access-tracking code already needs special handling.
> >
> > We can just simplify this all by adding a helper to clear a single bit (and
> > maybe even use clear_bit() and __clear_bit() if we save the bit number for the
> > W/A/D bits and not just the mask).  And if it weren't for EPT (different A/D
> > locations), we could even use static asserts to restrict the usage to the W/A/D
> > bits :-/  Oh well.
> >
> > E.g. this
>
> This patch looks good. Vipin can you incorporate this in your next version?

On it.
