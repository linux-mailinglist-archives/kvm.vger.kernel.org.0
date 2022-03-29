Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1130E4EB13D
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 18:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239141AbiC2QEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 12:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbiC2QEu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 12:04:50 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B6F25B91F
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 09:03:06 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id p10so25211293lfa.12
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 09:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O/S9pLHXh/L7uUQXKq/5ZERdX4mQt3cg5AXjS90eCwc=;
        b=S/NV9pDjHkZotdRTs7jr4Vegmvps7I4gjibysdXJWem9wRuX8y0WGLZP7/z4S03/MV
         Ifjj1CrsTL8E/wzMy0AG6riLHB9JvJ4hFLfNGhKW/I6Wpo5qvFOHIl8Ym9wnz+0uz1Ft
         7+j54AIAtRxtapy8NfgSo7TNgcOULm0k2PjCrEtohWGdUsz078QVvr2RTnzVZ45gSZev
         Gk5CohfcBiRqANj5fw4b4seaKCcdOdQzrjBqkLDv9jwGgy6sdg8KB+L9+H0V5jYRNKGy
         Q+D0WJJSKPHizY1Il+ashNz/2clmT88RoljBIZHyegEXRvKRneiHoJ7QQTwLF/7Kr8eo
         fNew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O/S9pLHXh/L7uUQXKq/5ZERdX4mQt3cg5AXjS90eCwc=;
        b=PKRXS9rFL1c2Kli7ZEqGQokmC1ATv9FxB44Cyd2LDIeDE2lW+KCC8jNd3TZ9J5yjst
         JhQHi4C4z5/5pYzWW1mXiSVFgJh2sKTnuwce29R53neGUDiz3/Bh3oOs3IIavnA5GeRP
         2GxvcMqm+7Dqcw4aZx+Zt7UT2vbqHUTzD8SlmKB1LRwruGyF3rHYkD+z2rtuabQkl+fG
         O/jl7eMr5QvdhxQG43nboBKzNstLzDra8lsgeNE/OcpPMXk0pxtD6+dLapLgbs1VhwEh
         hoxg3Vn8mjYx+mAvXxLW5Ln7APk5JvdbaOnqyUwWzZUW9IhfgqQC5RSrUfa6VJ1C2FMY
         ZJHg==
X-Gm-Message-State: AOAM5308UY+ZLRaBZqC2/JGO2mxV42CsPyofUgxbboBFe0A3VehbJVJY
        KNfRSkJpMn5t6tzhd3ZKaGIRGwjGw2KBuYRANZkFmw==
X-Google-Smtp-Source: ABdhPJwzN59kFGrGpl9nrYWHHZsJvU4gkdQArWd8wB1Gps/2vAoCXba/ZCw1OPpTberrRsQ76lAgnJyOo4fx61K1ftk=
X-Received: by 2002:ac2:510f:0:b0:44a:5ccc:99fb with SMTP id
 q15-20020ac2510f000000b0044a5ccc99fbmr3314310lfb.38.1648569782711; Tue, 29
 Mar 2022 09:03:02 -0700 (PDT)
MIME-Version: 1.0
References: <5BD1FCB2-3164-4785-B4D0-94E19E6D7537@amazon.com>
 <YjpFP+APSqjU7fUi@google.com> <875ynwg7tk.ffs@tglx>
In-Reply-To: <875ynwg7tk.ffs@tglx>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 29 Mar 2022 09:02:44 -0700
Message-ID: <CAOQ_QsgDY0oeS0kU62MWMWj9JR3mKfU_p=MC7kto=LX5tQ2PPA@mail.gmail.com>
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "Franke, Daniel" <dff@amazon.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On Tue, Mar 29, 2022 at 7:19 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> > Let's just assume for now that the hypervisor will *not* quiesce
> > the guest into an S2IDLE state before migration. I think quiesced
> > migrations are a good thing to have in the toolbelt, but there will
> > always be host-side problems that require us to migrate a VM off a host
> > immediately with no time to inform the guest.
>
> Quiesced migrations are the right thing on the principle of least
> surprise.

Absolutely no argument here. Furthermore, it is likely the laziest
solution as well since all the adjustment is done within the guest.

The one thing I envision is that it's highly unlikely that a migration
will block until the guest cooperates. If the guest doesn't act within
a certain threshold then sorry, you're going along for the ride
anyway.

But it is very easy to paint that as user error if advance notice was
given for the migration :)

> > It seems possible to block racing reads of REALTIME if we protect it with
> > a migration sequence counter. Host raises the sequence after a migration
> > when control is yielded back to the guest. The sequence is odd if an
> > update is pending. Guest increments the sequence again after the
> > interrupt handler accounts for time travel. That has the side effect of
> > blocking all realtime clock reads until the interrupt is handled. But
> > what are the value of those reads if we know they're wrong? There is
> > also the implication that said shared memory interface gets mapped
> > through to userspace for vDSO, haven't thought at all about those
> > implications yet.
>
> So you need two sequence counters to be checked similar to the
> pv_clock() case, which prevents the usage of TSC without the pv_clock()
> overhead.
>
> That also means that CLOCK_REALTIME, CLOCK_TAI and CLOCK_REALTIME_COARSE
> will need to become special cased in the VDSO and all realtime based
> syscall interfaces.
>
> I'm sure that will be well received from a performance perspective.

Lol. Yeah, I was rambling and this still falls apart for the case
where a clock read came in before the migration, which you raise
below.

> As I explained before, this does not solve the following:
>
>    T = now();
>    -----------> interruption of some sort (Tout)
>    use(T);
>
> Any use case which cares about Tout being less than a certain threshold
> has to be carefully designed to handle this. See also below.
>
> > Doing this the other way around (advance the TSC, tell the guest to fix
> > MONOTONIC) is fundamentally wrong, as it violates two invariants of the
> > monotonic clock. Monotonic counts during a migration, which really is a
> > forced suspend. Additionally, you cannot step the monotonic clock.
>
> A migration _should_ have suspend semantics, but the forced suspend
> which is done by migration today does not have proper defined semantics
> at all.
>
> Also clock monotonic can be stepped forward under certain circumstances
> and the kernel is very well able to handle it within well defined
> limits. Think about scheduled out vCPUs. From their perspective clock
> monotonic is stepping forwards.
>

Right. For better or worse, the kernel has been conditioned to
tolerate small steps due to scheduling. There is just zero definition
around how much slop is allowed.

> The problem starts when the 'force suspended' time becomes excessive, as
> that causes the mass expiry of clock monotonic timers with all the nasty
> side effects described in a3ed0e4393d6. In the worst case it's going to
> exceed the catchup limit of non-suspended timekeeping (~440s for a TSC
> @2GHz) which in fact breaks the world and some more.
>
> So let me go back to the use cases:
>
>  1) Regular freeze of a VM to disk and resume at some arbitrary point in
>     the future.
>
>  2) Live migration
>
> In both cases the proper solution is to make the guest go into a well
> defined state (suspend) and resume it on restore. Everything just works
> because it is well defined.
>
> Though you say that there is a special case (not that I believe it):

I believe the easier special case to articulate is when the hypervisor
has already done its due diligence to warn the guest about a
migration. Guest doesn't heed the warning and doesn't quiesce. The
most predictable state at this point is probably just to kill the VM
on the spot, but that is likely to be a _very_ tough sell :)

So assuming that it's still possible for a non-cooperative suspend
(live migration, VM freeze, etc.) there's still a need to stop the
bleeding. I think you touch on what that may look like:

>   1) Trestart - Tstop < TOLERABLE_THRESHOLD
>
>      That's the easy case as you just can adjust TSC on restore by that
>      amount on all vCPUs and be done with it. Just works like scheduling
>      out all vCPUs for some time.
>
>   2) Trestart - Tstop >= TOLERABLE_THRESHOLD
>
>      Avoid adjusting TSC for the reasons above.

Which naturally will prompt the question: what is the value of
TOLERABLE_THRESHOLD? Speaking from experience (Google already does
something similar, but without a good fallback for exceeding the
threshold), there's ~zero science in deriving that value. But, IMO if
it's at least documented we can make the shenanigans at least a bit
more predictable. It also makes it very easy to define who
(guest/host) is responsible for cleaning up the mess.

In absence of documentation there's an unlimited license for VM
operators to do as they please and I fear we will forever perpetuate
the pain of time in virt.

>      That leaves you with the options of
>
>      A) Make NTP unhappy as of today
>
>      B) Provide information about the fact that the vCPUs got scheduled
>         out for a long time and teach NTP to be smart about it.
>
>         Right now NTP decides to declare itself unstable when it
>         observes the time jump on CLOCK_REALTIME from the NTP server.
>
>         That's exactly the situation described above:
>
>         T = now();
>         -----------> interruption of some sort (Tout)
>         use(T);
>
>         NTP observes that T is inconsistent because it does not know
>         about Tout due to the fact that neither clock MONOTONIC nor
>         clock BOOTTIME advanced.
>
>         So here is where you can bring PV information into play by
>         providing a migration sequence number in PV shared memory.
>
>         On source host:
>            Stop the guest dead in it's tracks.
>            Record metadata:
>              - migration sequence number
>              - clock TAI as observed on the host
>            Transfer the image along with metadata
>
>         On destination host:
>            Restore memory image
>            Expose metadata in PV:
>              - migration sequence number + 1
>              - Tout (dest/source host delta of clock TAI)
>            Run guest
>
>         Guest kernel:
>
>            - Keep track of the PV migration sequence number.
>
>              If it changed act accordingly by injecting the TAI delta,
>              which updates NTP state, wakes TFD_TIMER_CANCEL_ON_SET,
>              etc...
>
>              We have to do that in the kernel because we cannot rely on
>              NTP being running.
>
>              That can be an explicit IPI injected from the host or just
>              polling from the tick. It doesn't matter much.
>
>            - Expose information to user space:
>                - Migration sequence counter
>
>            - Add some smarts to adjtimex() to prevent user space racing
>              against a pending migration update in the kernel.
>
>         NTP:
>            - utilize the sequence counter information
>
>              seq = get_migration_sequence();
>
>              do stuff();
>
>              if (seq != get_migration_sequence())
>                 do_something_smart();
>              else
>                 proceed_as_usual();

Agreed pretty much the whole way through. There's no point in keeping
NTP naive at this point.

There's a need to sound the alarm for NTP regardless of whether
TOLERABLE_THRESHOLD is exceeded. David pointed out that the host
advancing the guest clocks (delta injection or TSC advancement) could
inject some error. Also, hardware has likely changed and the new parts
will have their own errors as well.

>         That still will leave everything else exposed to
>         CLOCK_REALTIME/TAI jumping forward, but there is nothing you can
>         do about that and any application which cares about this has to
>         be able to deal with it anyway.

Right. There's no cure-all between hypervisor/guest kernel that could
fix the problem for userspace entirely.

Appreciate you chiming in on this topic yet again.

--
Thanks,
Oliver
