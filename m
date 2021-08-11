Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A86B3E8785
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 03:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236107AbhHKBH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 21:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235945AbhHKBH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 21:07:26 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F4AC061765
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 18:07:03 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id z128so1327283ybc.10
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 18:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a2EnmaKuDExlU8XnGG3RzNSaMcnDIxhrZpe2LhsoZ6U=;
        b=D+iac3BlDRd6s0yv+eLa06H+mhkklWKygguLtLbE9OuiaDc+/UyKG+rXsHuab5RuoC
         CsCc/0sFilzc9MaswCDRBsmqTtHlY9MRKXDRRbJCePew7jTeU+5AWO/DOuo3PQ1QpPq6
         H8EINzcA6L2OyDF1Ca9LDszPDOdjNPA3lUG3IxVfZcFGS6oTnDdxQCe6vinuPjcrFPfy
         3hcidiDyzHza4QxKwz/MTFk+rlSo4K06JRizz7yldoCmRlgk2mVtGcuPl5V8HRCIxdaw
         DW1XkVCypHjfAzeZqxtKNjPXwfdqnrwGnlLQkscZgq6py40eCQmzF6qotvBS0vvTFqcs
         cpwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a2EnmaKuDExlU8XnGG3RzNSaMcnDIxhrZpe2LhsoZ6U=;
        b=uT6BbbWYxp36V6wpUsPQuynzPfRUFuPkBcgT4eXbfHhqT9gDnFvhi2hYdcJwV4JpbZ
         yMD7fBc4mx/w5LEoByg2t38fnJrHM4kK9FzJBZFwryzT8Aahw/HAAvTpcXh1I/g0NaQQ
         ddHmkv37eQSzb3oalPrueWPq+yu5QzQWWI94g+SX3aYJ56e3aoe3eH3OjWSxyte8PgGl
         Ymz3EThJNbkf0UCXyBv9KaZuKyIjBGHMfJBVtiOe7mRxI5CIa/BxNTGIvXcsmiyjnSep
         64vCmTsik+qksiIWKaCVyw5OxU8V+EUxJNo/E05+oRHxERu0jAINdl59zG5drBxJ9n4/
         pk1A==
X-Gm-Message-State: AOAM5334OsiODmdigH0GlSzfmrSaKEm4uqFleoXYpYS57g1N/rcWvFyD
        1z9f836lUzwZ3nkfeLQdffeVftH1/BPBXn1RVPZWkw==
X-Google-Smtp-Source: ABdhPJzY4F8J7tsA37s1ErHMOBuLjkDBlVrO2agVXnayPhEOAxSieG0E/7DvxEyGXldhihU3agzg1tBDZQ+P/IECVtg=
X-Received: by 2002:a25:f503:: with SMTP id a3mr40167717ybe.501.1628644022703;
 Tue, 10 Aug 2021 18:07:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210803044607.599629-1-mizhang@google.com> <20210803044607.599629-4-mizhang@google.com>
 <CALMp9eR4AB0O7__VwGNbnm-99Pp7fNssr8XGHpq+6Pwkpo_oAw@mail.gmail.com>
 <CAL715WJLfJc3dnLUcMRY=wNPX0XDuL9WzF-4VWMdS_OudShXHg@mail.gmail.com>
 <CAL715WLO9+CpNa4ZQX4J2OdyqOBsX0+g0M4bNe+A+6FVxB2OxA@mail.gmail.com> <YRMKPd2ZarXCX6vm@t490s>
In-Reply-To: <YRMKPd2ZarXCX6vm@t490s>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Tue, 10 Aug 2021 18:06:51 -0700
Message-ID: <CAL715WJWPzBqmjeTJ6mZa=dUaF5+MdqaCrk5CEzvcz1X99cm0g@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] KVM: x86/mmu: Add detailed page size stats
To:     Peter Xu <peterx@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

Thanks for the comments. Please check my feedback inline.

> > From a functionality point of view, the above patch seems duplicate
> > with mine.
>
> The rmap statistics are majorly for rmap, not huge pages.
>

Got you. I guess the focus of the stat is different.


>
> I have a question: why change to using atomic ops?  As most kvm statistic=
s
> seems to be not with atomics before.
>
> AFAIK atomics are expensive, and they get even more expensive when the ho=
st is
> bigger (it should easily go into ten-nanosecond level).  So I have no ide=
a
> whether it's worth it for persuing that accuracy.
>
> Thanks,

Yes, regarding the usage of 'atomic_t', we previously had discussions
internally with Sean. So I think the main reason is because: in KVM
currently, mmu may have several modes. Among them, one is the mmu
running with TDP enabled (say, legacy mode in this scope) and another
one is the TDP mmu mode (mmu/tdp_mmu.c). In the legacy mode, mmu will
update spte under a write lock, while in comparison, in the TDP MMU
mode, mmu will use a read lock. I copied a simple code snippet to
illustrate the situation:

=C2=BB.......if (is_tdp_mmu_fault)
=C2=BB.......=C2=BB.......read_lock(&vcpu->kvm->mmu_lock);
=C2=BB.......else
=C2=BB.......=C2=BB.......write_lock(&vcpu->kvm->mmu_lock);

So here comes the problem: how do we make the page stat update
correctly across all modes? For the latter case, we definitely have to
update the stat in an atomic way unless we want extra locking (we
don't want that). So we could either 1) use a branch to update the
stat differently for each mode or 2) use an atomic update across all
cases. After review, Sean mentioned (in pre-v1 internal review) that
we should just use atomic. I agree since adding a branch at such a hot
path may slow down even more globally, especially if there is branch
misprediction? But I appreciate your feedback as well.

Regarding the pursuit for accuracy, I think there might be several
reasons. One of the most critical reasons that I know is that we need
to ensure dirty logging works correctly, i.e., when dirty logging is
enabled, all huge pages (both 2MB and 1GB) _are_ gone. Hope that
clarifies a little bit?

Thanks.
-Mingwei

-Mingwei


>
> --
> Peter Xu
>
