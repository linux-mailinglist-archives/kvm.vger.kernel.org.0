Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AC34E1AC9
	for <lists+kvm@lfdr.de>; Sun, 20 Mar 2022 09:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242705AbiCTIxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Mar 2022 04:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239040AbiCTIxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Mar 2022 04:53:40 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECFA105049
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 01:52:16 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id c23so13807676ioi.4
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 01:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t5cNHSLzkb01u1MY5ngEsSOv+laZ6KmMygeBd2mYk54=;
        b=Wd0ilBqec0KDO3LSH+MsOd76RAyXO6QJlQtYGCgHHJiAYXaPlSJTOM1F3vHtbJqkFO
         gywTM5q6jypJR2pGAePLndNKQkZ4sVR+Y3t7LkQW/tD43c8XvP24RgumB+OvdtXsh/ZC
         pnXuetP8wNHif50GiKHoUYYF/AhL00wXb+wxTzGsFPEaqHnDdYuH3sIOJdXgizfqTRMf
         XttsQ4vTNX3UuYm6tEY5g5ATsXbSLcWYoxfffX8CL7xGR+l5o27mgHdE621F521C6W+6
         mx3Isyfi6wsybHqpyOzaCRdVutgME61qv2t8V94O5DCTYAtKitLljhdGr7fHWGr1UD5H
         G21g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t5cNHSLzkb01u1MY5ngEsSOv+laZ6KmMygeBd2mYk54=;
        b=JYxcIiKLv/VJ/ApbuzF1uC+L17IrUVQYNlYHpBhGYapZRysHMviZBzIsWGZxU3Qfwv
         awm6FwTf75mUf2gtbSHdK9/c1j08VYs6uonw0XaM1cO2XFkV8NAp7Z12MVlB51J0ZyAd
         zBBI5wknA3ztDw5tpi1t+dVBztI27f1HkOMbtc9BtQwSWJ4KkQFQg7jFMdpNF5BiPjE/
         Dna7wK17J2at3LCeRM/nPbmH4kXcVsmkhVVPhcGZHhA5DZc0WvC7DIKSZOQqg55NB5cB
         6dq4mD1wZH/KM80KkI5mbXCtkrveCiun/bD8WXkn36tFYPBU87CnO5SH2OkJuYnruWS6
         lWwA==
X-Gm-Message-State: AOAM530K/Wt0nQ68F6wifzO27KA660Sp5kJTDfpJ3kUy7Iw1chaO7GSJ
        3CW9lambZ0t3MFCiYClBh8mlmA==
X-Google-Smtp-Source: ABdhPJwKoZx4NJPJA6KG2NO5GZ1BE4uanT5EbT3S3SS5+wrIx604TxEQ2KRRyBaTa6rWX7A/cOJnrw==
X-Received: by 2002:a05:6638:1654:b0:319:9ffe:4089 with SMTP id a20-20020a056638165400b003199ffe4089mr8858124jat.100.1647766335958;
        Sun, 20 Mar 2022 01:52:15 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id g4-20020a92cda4000000b002c24724f23csm8027162ild.13.2022.03.20.01.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Mar 2022 01:52:15 -0700 (PDT)
Date:   Sun, 20 Mar 2022 08:52:11 +0000
From:   Oliver Upton <oupton@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
Message-ID: <YjbrOz+yT4R7FaX1@google.com>
References: <20220316045308.2313184-1-oupton@google.com>
 <34ccef81-fe54-a3fc-0ba9-06189b2c1d33@redhat.com>
 <YjTRyssYQhbxeNHA@google.com>
 <0bff64ae-0420-2f69-10ba-78b9c5ac7b81@redhat.com>
 <YjWNfQThS4URRMZC@google.com>
 <e48bc11a5c4b0864616686cb1365dfb4c11b5b61.camel@infradead.org>
 <a6011bed-79b4-72ab-843c-315bf3fcf51e@redhat.com>
 <3548e754-28ae-f6c4-5d4c-c316ae6fbbb0@redhat.com>
 <100b54469a8d59976bbd96f50dd4cd33.squirrel@twosheds.infradead.org>
 <9ca10e3a-cd99-714a-76ad-6f1b83bb0abf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ca10e3a-cd99-714a-76ad-6f1b83bb0abf@redhat.com>
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

On Sun, Mar 20, 2022 at 09:10:15AM +0100, Paolo Bonzini wrote:
> On 3/19/22 14:13, David Woodhouse wrote:
> > 
> > 
> > > On 3/19/22 12:54, Paolo Bonzini wrote:
> > > > On 3/19/22 09:08, David Woodhouse wrote:
> > > > > If a basic API requires this much documentation, my instinct is to
> > > > > *fix* it with fire first, then document what's left.
> > > > I agree, but you're missing all the improvements that went in together
> > > > with the offset API in order to enable the ugly algorithm.
> > > > 
> > > > > A userspace-friendly API for migration would be more like KVM on the
> > > > > source host giving me { TIME_OF_DAY, TSC } and then all I have to do on
> > > > > the destination host (after providing the TSC frequency) is give it
> > > > > precisely the same data.
> > > 
> > > I guess you meant {hostTimeOfDay, hostTSC} _plus_ the constant
> > > {guestTSCScale, guestTSCOffset, guestTimeOfDayOffset}.  That would work,
> > > and in that case it wouldn't even be KVM returning that host information.
> > 
> > I would have said nobody cares about the host TSC value and frequency.
> > That is for KVM to know and deal with internally.
> 
> There are two schools as to how to do migration.  The QEMU school is to just
> load back the guest TOD and TSC and let NTP resync.  They had better be
> synced, but a difference of a few microseconds might not matter.
> 
> This has the advantage of not showing the guest that there was a pause.
> QEMU is doing it this way due to not having postcopy live migration for a
> long time; precopy is subject to longer brownout between source and
> destination, which might result in soft lockups.  Apart from this it really
> has only disadvantage.
> 
> The Google school has the destination come up with the guest TOD and TSC
> that takes into account the length of the brownout phase.  This is where the
> algorithm in Documentation/ comes into play, and why you need the host pair
> as well.  Actually Google does not use it because they already have precise
> time available to userspace as part of Spanner.  Maybe so does Amazon (?),
> but for the rest of the world the host {TOD, TSC} pair is required to
> compute what the guest TSC "should look like" on the destination.

Hey, beat me to the punch :) Paolo is pretty much spot on, but there are
a few additional details here that I believe are relevant.

I really don't think we want to effectively step the guest's monotonic
clock if at all possible. It hurts when you do this for large windows,
and leads to soft lockups as you've noted above. Nonetheless, its a
kludgy way to advance the guest's realtime clock without informing it
that it is about to experience time travel.

Given all of this, there is a limit to how much we advance the TSC in
the Google school. If this limit is exceeded we refuse to step the TSC
further and inform the guest it has experienced time travel [1]. It is
an attempt to bridge the gap and avoid completely laying waste to guest
clocks while hiding the migration if we're confident it was smooth
enough. Beyond that, guest userspace wants to be appraised of time
travel as well (TFD_TIMER_CANCEL_ON_SET). Having the guest clean up a
messy migration ensures that this all 'just works'.

The offset interface completely punts the decision around guest clocks
to userspace. We (KVM) have absolutely no idea what userspace is about
to do with the guest. The guest could be paused for 5 seconds or 5
years. Encouraging host userspace to just read/write a { TOD, TSC } pair
and let KVM do the heavy lifting could completely wreck the guest's
monotonic clock.

Additionally, it is impossible for userspace to enforce policy/limits on
how much to time travel a guest with a value-based interface. Any event
could sneak in between the time userspace checks the value and KVM sets
the L1 offset. Offsets are idempotent and will still uphold userspace's
intentions even if an inordinate amount of time elapses until KVM
processes it.

Apologies for grandstanding, but clocks has been a real source of pain
during migration. I do agree that the documented algorithm is a mess at
the moment, given that there's no good way for userspace to transform
host_tsc -> guest_tsc. Poking the host TSC frequency out in sysfs is
nice to have, but probably not ABI to hang this whole thing off of.

What do you folks think about having a new R/O vCPU attribute that
returns a { TOD, guest_tsc } pair? I believe that would immediately
satisfy the needs of upstream to implement clock-advancing live
migration.

[1]: https://github.com/GoogleCloudPlatform/guest-agent/blob/main/google_guest_agent/clock.go
--
Thanks,
Oliver
