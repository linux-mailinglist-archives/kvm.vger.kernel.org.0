Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425B736EF13
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 19:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240928AbhD2RqJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 13:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236036AbhD2RqI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 13:46:08 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A178C06138B
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 10:45:21 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id c8-20020a9d78480000b0290289e9d1b7bcso48031031otm.4
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 10:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GbYmESgQnmInPmbhpZ7rWt4zsWsa0tFAztscShVWN9U=;
        b=vo2hrfvnOI6K5Ln4dS+wWzLtKsRVK+bII/RzGZi/zH190Occ5Gd1Ik+idDOaOpnbta
         3tO3kUKyXRI4aBXIlJvFthSwTUmxRPSBoX8Mfw+PdFgqvn8fBB+6wR3GceKKQV66mJKm
         EQmKQClJUnZRdiy1R/LlPTUbXPcqlbmypPtTLlOResxjAy2PLcMqkHMuO/c0QBLd1dPX
         AdoUVG7nWCgh6hO+xG5DpB8AIHPuNzVYkW7B84gY0zdzKezbb4LvklN/3zzC4ghTMha6
         dH84LoDHmRSAM+YwqE6XmtbWHLg/QNmi9ZYhst4CaC9uwj7PgZwudqsFQ4vyUgX52NLS
         W9/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GbYmESgQnmInPmbhpZ7rWt4zsWsa0tFAztscShVWN9U=;
        b=nhyO13oBfI0JhVOU8eJ7eKFxcC+5P6zJjCKmC/zmcUU2z0seCRoccLdxYGQtxUodTi
         eY40NGP/cwh2+zoXgKHezyJM41MshKP6avqScps0at7nBlUMZOidMAmWkVtT/tRuNdCK
         pNdoBAv/9EeCaMMlMG7vhNdTyQnubOCI4KRR/oYUW/OEAOCpXfjNQCeOPKgMs7vtEo9D
         uCJUamrb8P59gH4ghYPy9vM4bDCwI/CkM0GQyqE1tJc6nta3BXjqOhs1Y9QIPXRuHh5c
         JwTVkB/evDMd6MnHbenPuwSh285NZ9FJ3RUj03RyNBzo59WE0DHL+UQzSCnE868g+g5Z
         mXww==
X-Gm-Message-State: AOAM530XGISIDoYJrD0YdUjwDeNZYoA4/jedw967bfDVTsst7yoCpnpv
        NWIKXtAnDQ+OILjVM7raoNn6davFzzDpTbUyQd/1/w==
X-Google-Smtp-Source: ABdhPJxWHOT49B50EOhJuCFIVghZvUxS4Pkj0+eUhcAl2GOyx5G+ZugyaaA3ny00e9zH+pduNU6Ek5Q70F5QxcYoCOs=
X-Received: by 2002:a9d:7857:: with SMTP id c23mr453371otm.208.1619718318872;
 Thu, 29 Apr 2021 10:45:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210427223635.2711774-1-bgardon@google.com> <20210427223635.2711774-6-bgardon@google.com>
 <997f9fe3-847b-8216-c629-1ad5fdd2ffae@redhat.com> <CANgfPd8RZXQ-BamwQPS66Q5hLRZaDFhi0WaA=ZvCP4BbofiUhg@mail.gmail.com>
 <d936b13b-bb00-fc93-de3b-adc59fa32a7b@redhat.com> <CANgfPd9kVJOAR_uq+oh9kE2gr00EUAGSPiJ9jMR9BdG2CAC+BA@mail.gmail.com>
 <5b4a0c30-118c-da1f-281c-130438a1c833@redhat.com> <CANgfPd_S=LjEs+s2UzcHZKfUHf+n498eSbfidpXNFXjJT8kxzw@mail.gmail.com>
 <16b2f0f3-c9a8-c455-fff0-231c2fe04a8e@redhat.com> <YIoAixSoRsM/APgx@google.com>
 <623c2305-91ae-4617-357e-fe7d9147b656@redhat.com>
In-Reply-To: <623c2305-91ae-4617-357e-fe7d9147b656@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 29 Apr 2021 10:45:07 -0700
Message-ID: <CANgfPd9BWoO4Hy0e8urus4AaJP8t6fByqHK+ddsed6KFg6W97A@mail.gmail.com>
Subject: Re: [PATCH 5/6] KVM: x86/mmu: Protect kvm->memslots with a mutex
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021 at 12:02 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 29/04/21 02:40, Sean Christopherson wrote:
> > On Thu, Apr 29, 2021, Paolo Bonzini wrote:
> >> it's not ugly and it's still relatively easy to explain.
> >
> > LOL, that's debatable.
>
>  From your remark below it looks like we have different priorities on
> what to avoid modifying.
>
> I like the locks to be either very coarse or fine-grained enough for
> them to be leaves, as I find that to be the easiest way to avoid
> deadlocks and complex hierarchies.  For this reason, I treat unlocking
> in the middle of a large critical section as "scary by default"; you
> have to worry about which invariants might be required (in the case of
> RCU, which pointers might be stored somewhere and would be invalidated),
> and which locks are taken at that point so that the subsequent relocking
> would change the lock order from AB to BA.

The idea of dropping the srcu read lock to allocate the rmaps scares
me too. I have no idea what it protects, in addition to the memslots,
and where we might be making assumptions about things staying valid
because of it.
Is there anywhere that we enumerate the things protected by that SRCU?
I wonder if we have complete enough annotations for the SRCU / lockdep
checker to find a problem if we were dropping the SRCU read lock in a
bad place.

>
> This applies to every path leading to the unlock/relock.  So instead
> what matters IMO is shielding architecture code from the races that Ben
> had to point out to me, _and the possibility to apply easily explained
> rules_ outside more complex core code.
>
> So, well, "relatively easy" because it's indeed subtle.  But if you
> consider what the locking rules are, "you can choose to protect
> slots->arch data with this mutex and it will have no problematic
> interactions with the memslot copy/update code" is as simple as it can get.
>
> >> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> >> index 2799c6660cce..48929dd5fb29 100644
> >> --- a/virt/kvm/kvm_main.c
> >> +++ b/virt/kvm/kvm_main.c
> >> @@ -1377,16 +1374,17 @@ static int kvm_set_memslot(struct kvm *kvm,
> >>              goto out_slots;
> >>      update_memslots(slots, new, change);
> >> -    slots = install_new_memslots(kvm, as_id, slots);
> >> +    install_new_memslots(kvm, as_id, slots);
> >>      kvm_arch_commit_memory_region(kvm, mem, old, new, change);
> >> -
> >> -    kvfree(slots);
> >>      return 0;
> >>   out_slots:
> >> -    if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
> >> +    if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
> >> +            slot = id_to_memslot(slots, old->id);
> >> +            slot->flags &= ~KVM_MEMSLOT_INVALID;
> >
> > Modifying flags on an SRCU-protect field outside of said protection is sketchy.
> > It's probably ok to do this prior to the generation update, emphasis on
> > "probably".  Of course, the VM is also likely about to be killed in this case...
> >
> >>              slots = install_new_memslots(kvm, as_id, slots);
> >
> > This will explode if memory allocation for KVM_MR_MOVE fails.  In that case,
> > the rmaps for "slots" will have been cleared by kvm_alloc_memslot_metadata().
>
> I take your subsequent reply as a sort-of-review that the above approach
> works, though we may disagree on its elegance and complexity.

I'll try Paolo's suggestion about using a second dup_slots to avoid
backing the higher level rmap arrays with dynamic memory and send out
a V2.

>
> Paolo
>
> > The SRCU index is already tracked in vcpu->srcu_idx, why not temporarily drop
> > the SRCU lock if activate_shadow_mmu() needs to do work so that it can take
> > slots_lock?  That seems simpler and I think would avoid modifying the common
> > memslot code.
> >
> > kvm_arch_async_page_ready() is the only path for reaching kvm_mmu_reload() that
> > looks scary, but that should be impossible to reach with the correct MMU context.
> > We could always and an explicit sanity check on the rmaps being avaiable.
>
