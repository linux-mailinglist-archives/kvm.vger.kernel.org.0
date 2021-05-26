Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DD6391FE4
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 21:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235190AbhEZTDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 15:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235215AbhEZTDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 15:03:03 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2344BC061756
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 12:01:28 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id w7so3060860lji.6
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 12:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LZnBooSrTbsSOnYbfhKHaDk4XuLdXNGP1B/S6YvK9d4=;
        b=txIwSIHp0E61getYyScW68BHZcr0Q6sr4xrTHzySprBTLrKpMKwTG6VxIsRS9GWZmj
         6z2NIvPxdhiaqTGQFJqe8Wktp+zztSLGYzBrzHyUQnEBuUB/gRk8ITKpH7LGdI1WISBy
         QhvaNvv2JBqoWt6pYFdCKc8LlpT8eFfgTiYpENgFt5GJAniyPxME+omAQ3cuJ3hy9yQN
         /X0NVf3ailAL/q4qIseOSD3lo1w5lKbcPvTcEZ4Z3551pvbCdH0ZbG94ySPH3Q9lnDJC
         Xlhzfu96fZQa1DRyjxtV488uJzBjhguDNNOmPNCEkObWbgKi4Vq2JhYEsSqOGVbcf1QV
         W/aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LZnBooSrTbsSOnYbfhKHaDk4XuLdXNGP1B/S6YvK9d4=;
        b=PEzUw5z+mwzLxNLJ4FH+kLPeR5ei6DBQdsfEXMWZVrdzSANeXsRETZvi5autwMub9e
         9puvgbLsIPWQsMuerC3ZiwRtJoVw+BnWRD888Le/9G+2yn3NjxBy3XSacWcrhuCVtvs7
         FT9pxD725pgUUfulkseNGc3plbgTs4lInrFb8je5mRcPqmKexQ/F9by3B1JcpLbq7a++
         FfLtKFy7GGz9JjXksYnAKOHNAT7U9Vph0qIyXCD7vzPfkIIiK54gMgMi8Vov1QUGt5wB
         gtdiZvGbWGCJmaFEWUqh8kiTnnMQhQGiGWJ6RJ+hy1HRqOWauVdU5Jl1MO9+sGTWrCLQ
         gQCw==
X-Gm-Message-State: AOAM531EQds3h/BqJkWPjpqWjjQL5ogLJmL+LQrNJqanIbOt2k5vHooc
        sKBqheVjUjnGAR0qS6xUCdTFfdSPjCprscST6odnQQ==
X-Google-Smtp-Source: ABdhPJxLqxCryoZfaXvG+tWF+sReBvFKKYUujFi7cDcNkFCKx9hOGm8wGfrFLoWaigt/U+qbqFT8pLsXRjuMpILbGsQ=
X-Received: by 2002:a2e:b4e9:: with SMTP id s9mr3330984ljm.383.1622055686213;
 Wed, 26 May 2021 12:01:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210526163227.3113557-1-dmatlack@google.com> <YK6FdtswnFklJuAO@google.com>
 <CALzav=dsgEP6cdfLic_7ffjf22Z8R8LTrJODyVWw3HqSZR4zFQ@mail.gmail.com> <YK6Ywl57/FXqcSR0@google.com>
In-Reply-To: <YK6Ywl57/FXqcSR0@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 26 May 2021 12:00:59 -0700
Message-ID: <CALzav=dN5sAv8GaH5tQ3nkPAEhufXVTDweQk5NF8GjB+NeDOfQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Fix comment mentioning skip_4k
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021 at 11:51 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, May 26, 2021, David Matlack wrote:
> > On Wed, May 26, 2021 at 10:29 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > Put version information in the subject, otherwise it's not always obvious which
> > > patch you want to be accepted, e.g.
> > >
> > >   [PATCH v2] KVM: x86/mmu: Fix comment mentioning skip_4k
> >
> > Got it. My thinking was that I changed the title of the patch so
> > should omit the v2, but that doesn't really make sense.
>
> Ha, yeah, the version should get bumped even if a patch/series gets heavily
> rewritten.  There are exceptions (though I'm struggling to think of a good
> example), but even then it's helpful to describe the relationship to any
> previous series.
>
> It's also customery to describe the changes between versions in the cover letter,
> or in the case of a one-off patch, in the part of the patch that git ignores.
>
> And my own personal preference is to also include lore links to previous versions,
> e.g. in this case I would do something like:
>
>   v2: Reword comment to document min_level. [sean]
>
>   v1: https://lkml.kernel.org/r/20210526163227.3113557-1-dmatlack@google.com
>
> Providing the explicit link in addition to the delta summaray makes it easy for
> reviewers to see the history and understand the context of _why_ changes were
> made.  That's especially helpful for reviewers that didn't read/review earlier
> versions.

Great advice. Thanks Sean!
