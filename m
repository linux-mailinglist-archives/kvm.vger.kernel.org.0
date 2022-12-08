Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150E2647525
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 18:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiLHRur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 12:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiLHRum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 12:50:42 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D777A56E9
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 09:50:35 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id n7so1689519wms.3
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 09:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HcHEfoIgvQqzqdjIyO/o0yadEeMiUClkoqNRl4GZils=;
        b=DeT+cgArGsVoEBJmKsU2RBwdHKFXTtpobl7x8BEhCc1r77ieUhoA9UsMIsyET9Dawf
         Ggac+66EKkHXBo48iGQKlNCE4+UXU0BTTRr3CmYrokZPwfUVaE39eMX0D23ACVlvsho3
         qyadbda5NSqr7j0Z4UvhE5bV2J0BaSqzOrxS7pCJ4xFgdJdnMIBgOOmO8iGVc0PwEtC2
         hDNdn0dQX1dYe9iEq+GcmuW6U3fTmgx4+7b89xu5h/CXyHVY+rkyZOXjkd2TBn2UCcKr
         UlSGlYgb2GofIjV92hTfttO7uDTWWLayr58XWmXF60zv8iK27L/MtHjcjOd6UOt13zTY
         B/fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HcHEfoIgvQqzqdjIyO/o0yadEeMiUClkoqNRl4GZils=;
        b=ZzNV7oT7RBclWfCDFlgNSnzCBmaN0o6rB6iFJaemfHU2laHMvPneHydAF8ZQMsFwt2
         8YSbpSzu9rjYZD4mTl6biGEMnCeyJp2Vu8N5TqkvcVEuMWdURB/WUDJHjBP368kp8yBn
         bGr3HClJZ8aU9S+COOeGhYmiSi1gKMzw9YQstzyC++4CikslKqWgieYLz+pHXQ3Uz2cc
         iTFPDmLA4XqHaKIkZN1upQJS7qCxxswrVxzoEhqi+qbjasH0G/Nte9RF10xWR+jn22bW
         Y55bpgvsKGJK60/sfv+8qV+ZwhHRE4KcqCy4+iLkH6lqxLlU/ez2E5fx/XwETUfdiEke
         DV0g==
X-Gm-Message-State: ANoB5pl/fekXkDeGD/LIFFXesi9czHPs4MRQWF0+EDA5sHKdf8CqCQBB
        jMz9YAEN3+ogecHwoGzjvPc7OXAvzGhOA+JRbujH39T+3JLDN6Px
X-Google-Smtp-Source: AA0mqf7g1hT+EVeUzX4ihjsGp/nRfj2r7RdPfa8flvKM7lDsUanEkZ+PvRwGFLAZnaT5o+Arex6LpkuNJxazEx70GCY=
X-Received: by 2002:a05:600c:3847:b0:3d0:7d89:227e with SMTP id
 s7-20020a05600c384700b003d07d89227emr22185625wmr.166.1670521833742; Thu, 08
 Dec 2022 09:50:33 -0800 (PST)
MIME-Version: 1.0
References: <CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com>
 <Y4qgampvx4lrHDXt@google.com> <Y44NylxprhPn6AoN@x1n> <CALzav=d=N7teRvjQZ1p0fs6i9hjmH7eVppJLMh_Go4TteQqqwg@mail.gmail.com>
 <Y442dPwu2L6g8zAo@google.com> <CADrL8HV_8=ssHSumpQX5bVm2h2J01swdB=+at8=xLr+KtW79MQ@mail.gmail.com>
 <Y46VgQRU+do50iuv@google.com> <CADrL8HVM1poR5EYCsghhMMoN2U+FYT6yZr_5hZ8pLZTXpLnu8Q@mail.gmail.com>
 <Y4+DVdq1Pj3k4Nyz@google.com> <CADrL8HVftX-B+oHLbjnJCret01yjUpOjQfmHdDa7mYkMenOa+A@mail.gmail.com>
 <CALzav=cyPgsYPZfxsUFMBJ1j33LHxfSY-Bj0ttZqjozDm745Nw@mail.gmail.com>
In-Reply-To: <CALzav=cyPgsYPZfxsUFMBJ1j33LHxfSY-Bj0ttZqjozDm745Nw@mail.gmail.com>
From:   James Houghton <jthoughton@google.com>
Date:   Thu, 8 Dec 2022 12:50:22 -0500
Message-ID: <CADrL8HV2K=NAGATdRobq8aMJJwRapiF7gxrJovhz7k-Me3ZFuw@mail.gmail.com>
Subject: Re: [RFC] Improving userfaultfd scalability for live migration
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Linux MM <linux-mm@kvack.org>, kvm <kvm@vger.kernel.org>,
        chao.p.peng@linux.intel.com, Oliver Upton <oupton@google.com>
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

On Wed, Dec 7, 2022 at 8:57 PM David Matlack <dmatlack@google.com> wrote:
>
> On Tue, Dec 6, 2022 at 12:41 PM James Houghton <jthoughton@google.com> wrote:
> > On Tue, Dec 6, 2022 at 1:01 PM Sean Christopherson <seanjc@google.com> wrote:
> > > Can you elaborate on what makes it better?  Or maybe generate a list of pros and
> > > cons?  I can think of (dis)advantages for both approaches, but I haven't identified
> > > anything that would be a blocking issue for either approach.  Doesn't mean there
> > > isn't one or more blocking issues, just that I haven't thought of any :-)
> >
> > Let's see.... so using no-slow-GUP over no UFFD waiting:
> > - No need to take mmap_lock in mem fault path.
> > - Change the relevant __gfn_to_pfn_memslot callers
> > (kvm_faultin_pfn/user_mem_abort/others?) to set `atomic = true` if the
> > new CAP is used.
> > - No need for a new PF_NO_UFFD_WAIT (would be toggled somewhere
> > in/near kvm_faultin_pfn/user_mem_abort).
> > - Userspace has to indirectly figure out the state of the page tables
> > to know what action to take (which introduces some weirdness, like if
> > anyone MADV_DONTNEEDs some guest memory, we need to know).
>
> I'm no expert but I believe a guest access to MADV_DONTNEED'd GFN
> would just cause a new page to be allocated by the kernel. So I think
> userspace can still blindly do MADV_POPULATE_WRITE in this case. Were
> there any other scenarios you had in mind?

MADV_POPULATE_WRITE would drop into handle_userfault() if we're using
uffd minor faults after we do MADV_DONTNEED. For uffd minor faults, if
the PTE is none (i.e., completely blank, no swap information or
anything), then we drop into handle_userfault().

I partially take back what I said. We have to be careful about someone
messing with our page tables no matter which API we choose.

Here is a better description of the weirdness that we have to put up
with given each choice, with this assumption that, normally, we want
to UFFDIO_CONTINUE a page exactly once:

- For the no-slow-GUP choice, if someone MADV_DONTNEEDed memory and we
didn't know about it, we would get stuck in MADV_POPULATE_WRITE. By
using UFFD_FEATURE_THREAD_ID, we can tell if we got a userfault for a
thread that is in the middle of a MADV_POPULATE_WRITE, and we can try
to unblock the thread by doing an extra UFFDIO_CONTINUE.

- For the PF_NO_UFFD_WAIT choice, if someone MADV_DONTNEEDed memory,
we would just keep trying to start the vCPU without doing anything (we
assume some other thread has UFFDIO_CONTINUEd for us). This is
basically the same as if we were stuck in MADV_POPULATE_WRITE, and we
can try to unblock the thread in a fashion similar to how we would in
the other case.

So really these approaches have similar requirements for what
userspace needs to track. So I think I prefer the no-slow-GUP approach
then.

>
> > - While userfaultfd is registered (so like during post-copy), any
> > hva_to_pfn() calls that were resolvable with slow GUP before (without
> > dropping into handle_userfault()) will now need to be resolved by
> > userspace manually with a call to MADV_POPULATE_WRITE. This extra trip
> > to userspace could slow things down.
>
> Is there any way to enable fast-gup to identify when a PTE is not
> present due to userfaultfd specifically without taking the mmap_lock
> (e.g. using an unused bit in the PTE)? Then we could avoid extra trips
> to userspace for MADV_POPULATE_WRITE.

To know if you would have dropped into handle_userfault(), you have to
at least check the VMA flags, so at the moment, no. :(
