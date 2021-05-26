Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B725C391CFB
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 18:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbhEZQZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 12:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbhEZQZj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 12:25:39 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603D9C061574
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 09:24:07 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id a5so2723467lfm.0
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 09:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3cM2mblDKhPquCYBmRFj917dK+x6jvgo/DRZVc2YBvo=;
        b=bvOwyjm8V8OURWbAa7pjtmmDplKWxFnzdmQNSOG1HZucDonFU/YU4ds08xHeRlSrS2
         wYSfDw1aXE9fIFgDrpoHZn6xa1dN9gY16VGlza36J0XIbviiTDkKGznEzxrNyJ+qfqAi
         Am/+RLHzvmPRXiyksCcrtNz/+BPYtywNTC506kizv9Vy2UDClNT0BjQMrsfudaf32QN2
         9hyK7GqKiHcPLT4PjUCMIczmwIn15NwfiV0TaqT5aAVTjoZ0sfrLixcPbjD+j050w1fR
         ouXC8sA7hn+8H4Jz2J1iimuCBDJC+bGOISUGioHVXxhnv7obn9w3nOkT6iTGFIpeFKkk
         ZboQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3cM2mblDKhPquCYBmRFj917dK+x6jvgo/DRZVc2YBvo=;
        b=IxxiNNI5AgdWzXh2aODgeb6yZPKhaMOWvgzPUi4zKsD2x+XVFm8dkhQnjipQKfAmyi
         UI/mv1kcSuPpE2FsvEDnVSt8I0j6LeJU+mes2wqdAUjWI9qbOdS4VGwtLMRxTVFabcQh
         DycSlDyY+RcUUXcMdONYWX3PVBlw6pKPbplFJheSfABbXCijZKzum/RCtEQbPAr0uVPZ
         Fj4FWHlcnHnxAfslEggLjpVUoCwRWYEbzBW3Bk6HEAFE1q80YwPMiniNpRf/yS0JgEd6
         Wr6eFYYOmBLW1gUw0VkjqpC3TCTr5twBiTeV5S/61EjuENKwCV+JH81dfC9zGxLU7ITl
         Yn+Q==
X-Gm-Message-State: AOAM530EpI/odv95YdRTPcUtUWrCJrLyu2HLMPkzOfc9Fln4JEyHpwvs
        6e+ysJrFlsFVqrqM4Fy+aud/BE8SbgrLq60/JJGOJg==
X-Google-Smtp-Source: ABdhPJxOpHOgwYhNbRtXLzq18uu8tU1DjuKtg3jUddZ/ZQpgaKbDZ5iIEdhDSfnWMBTMIhlLfLHPrbAlol1iToMde+Y=
X-Received: by 2002:ac2:5149:: with SMTP id q9mr2762988lfd.46.1622046245545;
 Wed, 26 May 2021 09:24:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210525223447.2724663-1-dmatlack@google.com> <YK5lVHARaeNfCJ5L@google.com>
In-Reply-To: <YK5lVHARaeNfCJ5L@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 26 May 2021 09:23:39 -0700
Message-ID: <CALzav=ccFrpUOXF0HQzaNMmzTbeks=P-TUHDg-UJShEqwRfZzA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove stale comment mentioning skip_4k
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021 at 8:12 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, May 25, 2021, David Matlack wrote:
> > This comment was left over from a previous version of the patch that
> > introduced wrprot_gfn_range, when skip_4k was passed in instead of
> > min_level.
> >
> > Remove the comment (instead of fixing it) since wrprot_gfn_range has
> > only one caller and min_level is documented there.
>
> That would be ok-ish if there were no comment whatsoever, but the function comment
> is now flat out wrong, which is bad.

You're right!

>
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 95eeb5ac6a8a..97f273912764 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1192,8 +1192,7 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> >  }
> >
> >  /*
> > - * Remove write access from all the SPTEs mapping GFNs [start, end). If
> > - * skip_4k is set, SPTEs that map 4k pages, will not be write-protected.
> > + * Remove write access from all the SPTEs mapping GFNs [start, end).
>
> If the goal is to avoid churn on the last sentence, what about:
>
>     * Write protect SPTEs mapping GFNs [start, end) at or above min_level.

Thanks. Will send another patch fixing the comment.

>
> >   * Returns true if an SPTE has been changed and the TLBs need to be flushed.
> >   */
> >  static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> > --
> > 2.32.0.rc0.204.g9fa02ecfa5-goog
> >
