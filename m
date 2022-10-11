Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16AC5FAB6B
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 05:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiJKDu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 23:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiJKDuX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 23:50:23 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C0925584
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 20:50:13 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id d7-20020a17090a2a4700b0020d268b1f02so5365585pjg.1
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 20:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HhqceA9XVnV2jj9E6aHbcgTtQtB5Rry1ltkGlDIo+pA=;
        b=J2dNBDaHKoR12uDNtoxL90mg7ZDM/KQOl/HNokibBrEUiPwsGvgQ1E+72raQP420xc
         Dh4fvZ0KnalxEBZWvOVe5+keZ2UP2NyCCOteMva63fW7WWbmPceLlt+FhEATosOj2gJ8
         BbVpLhO3QPvE6lLn1sSlb8gef2/9iT+BiG7H0Nil5k0qp1Ef+shTC60KatBYodqF5aBt
         dNAUQs9ByDwEwuvOJYi8ix1eRwLXF1frndT3u6AkP2Tpz2urU7Jj0u3sEvoVrndPpXW/
         hliUQMouNFYxSj6Jo/XEgVVGrhH0+VgCx2fv6NWT8vIv7MKXu2InTPKJKPxJTQvZz7QY
         I9VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HhqceA9XVnV2jj9E6aHbcgTtQtB5Rry1ltkGlDIo+pA=;
        b=PYXjhEWAHVg/h9g8Db/67vj4sXo4ja0sjnRJYHTfVIt98ScKv7OEw/eNeF4QqPbLzT
         2YkXPIG3kr+EdlaFINojJPTRZcuF41hFo/w+8wXb9pyJGaHJ1ca+h2b+3KaryDbHHV64
         LrAvM+l4TBxJ+d8hj19SzJK23fM0seJLIwp9kI6BmojgWvmv9H1OwpSO/yue5lJ/A61U
         id563muW8WoJtFdO1fJhtJ+Yp4K2f2KScDmHTQ6Bpi52O2bjrY+sqGZnTsYy5qtm+qqN
         e6oewloJ3VznVxU817QY3/oADoM+DkjI9A+5rFXF1dKijD90pt7eP8jW4NeOWqC+5reG
         pVUQ==
X-Gm-Message-State: ACrzQf3zy1MuxGfP+M8MkWiQKz12nhyA12cl+uostOcaovwfbnhSbR67
        UscMQ7jIX4Qsgw7jw980g5VtIA==
X-Google-Smtp-Source: AMsMyM7DCRFYQkEj/T2FjkIv61uGnwpf5X7GHkQzIRmf2Us4HuI+pNXriPXsIa+FJ/Hzh18avR2o4Q==
X-Received: by 2002:a17:90b:4d8d:b0:20a:ad78:7826 with SMTP id oj13-20020a17090b4d8d00b0020aad787826mr24684083pjb.237.1665460212289;
        Mon, 10 Oct 2022 20:50:12 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id w35-20020a17090a6ba600b0020ad7678ba0sm6790553pjj.3.2022.10.10.20.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 20:50:11 -0700 (PDT)
Date:   Mon, 10 Oct 2022 20:50:08 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        maz@kernel.org, oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v3 0/3] arm: pmu: Fixes for bare metal
Message-ID: <Y0Tn8FNjsRgesMjh@google.com>
References: <20220805004139.990531-1-ricarkol@google.com>
 <89c93f1e-6e78-f679-aecb-7e506fa0cea3@redhat.com>
 <YzxmHpV2rpfaUdWi@monolith.localdoman>
 <5b69f259-4a25-18eb-6c7c-4b59e1f81036@redhat.com>
 <Yz1MiE64ZEa7twtM@monolith.localdoman>
 <2c577c0a-7bdb-81b0-f0c3-6ede3688b94d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2c577c0a-7bdb-81b0-f0c3-6ede3688b94d@redhat.com>
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

On Wed, Oct 05, 2022 at 11:50:09AM +0200, Eric Auger wrote:
> Hi Alexandru,
> 
> On 10/5/22 11:21, Alexandru Elisei wrote:
> > Hi Eric,
> >
> > On Tue, Oct 04, 2022 at 07:31:25PM +0200, Eric Auger wrote:
> >> Hi Alexandru,
> >>
> >> On 10/4/22 18:58, Alexandru Elisei wrote:
> >>> Hi Eric,
> >>>
> >>> On Tue, Oct 04, 2022 at 06:20:23PM +0200, Eric Auger wrote:
> >>>> Hi Ricardo, Marc,
> >>>>
> >>>> On 8/5/22 02:41, Ricardo Koller wrote:
> >>>>> There are some tests that fail when running on bare metal (including a
> >>>>> passthrough prototype).  There are three issues with the tests.  The
> >>>>> first one is that there are some missing isb()'s between enabling event
> >>>>> counting and the actual counting. This wasn't an issue on KVM as
> >>>>> trapping on registers served as context synchronization events. The
> >>>>> second issue is that some tests assume that registers reset to 0.  And
> >>>>> finally, the third issue is that overflowing the low counter of a
> >>>>> chained event sets the overflow flag in PMVOS and some tests fail by
> >>>>> checking for it not being set.
> >>>>>
> >>>>> Addressed all comments from the previous version:
> >>>>> https://lore.kernel.org/kvmarm/20220803182328.2438598-1-ricarkol@google.com/T/#t
> >>>>> - adding missing isb() and fixed the commit message (Alexandru).
> >>>>> - fixed wording of a report() check (Andrew).
> >>>>>
> >>>>> Thanks!
> >>>>> Ricardo
> >>>>>
> >>>>> Ricardo Koller (3):
> >>>>>   arm: pmu: Add missing isb()'s after sys register writing
> >>>>>   arm: pmu: Reset the pmu registers before starting some tests
> >>>>>   arm: pmu: Check for overflow in the low counter in chained counters
> >>>>>     tests
> >>>>>
> >>>>>  arm/pmu.c | 56 ++++++++++++++++++++++++++++++++++++++-----------------
> >>>>>  1 file changed, 39 insertions(+), 17 deletions(-)
> >>>>>
> >>>> While testing this series and the related '[PATCH 0/9] KVM: arm64: PMU:
> >>>> Fixing chained events, and PMUv3p5 support' I noticed I have kvm unit
> >>>> test failures on some machines. This does not seem related to those
> >>>> series though since I was able to get them without. The failures happen
> >>>> on Amberwing machine for instance with the pmu-chain-promotion.
> >>>>
> >>>> While further investigating I noticed there is a lot of variability on
> >>>> the kvm unit test mem_access_loop() count. I can get the counter = 0x1F
> >>>> on the first iteration and 0x96 on the subsequent ones for instance.
> >>>> While running mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E) I was
> >>>> expecting the counter to be close to 20. It is on some HW.
> >>>>
> >>>> [..]
> >>>>
> >>>> So I come to the actual question. Can we do any assumption on the
> >>>> (virtual) PMU quality/precision? If not, the tests I originally wrote
> >>>> are damned to fail on some HW (on some other they always pass) and I
> >>>> need to make a decision wrt re-writing part of them, expecially those
> >>>> which expect overflow after a given amount of ops. Otherwise, there is
> >>>> either something wrong in the test (asm?) or in KVM PMU emulation.

I don't think it's the asm because in that case the counter value should
be the same every time (even if wrong).

> >>>>
> >>>> I tried to bisect because I did observe the same behavior on some older
> >>>> kernels but the bisect was not successful as the issue does not happen
> >>>> always.
> >>>>
> >>>> Thoughts?
> >>> Looking at mem_access_loop(), the first thing that jumps out is the fact
> >>> that is missing a DSB barrier. ISB affects only instructions, not memory
> >>> accesses and without a DSB, the PE can reorder memory accesses however it
> >>> sees fit.
> >> Following your suggestion I added a dsh ish at the end of loop and
> >> before disabling pmcr_el0 (I hope this is the place you were thinking
> >> of) but unfortunately it does not seem to fix my issue.
> > Yes, DSB ISH after "b.gt 1b\n" and before the write to PMCR_EL0 that
> > disables the PMU.
> >
> > I think you also need a DSB ISH before the write to PMCR_EL0 that enables
> > the PMU in the first instruction of the asm block. In your example, the
> > MEM_ACCESS event count is higher than expected, and one explanation for the
> > large disparity that I can think of is that previous memory accesses are
> > reordered past the instruction that enables the PMU, which makes the PMU
> > add these events to the total event count.
> 
> Makes sense. I added those at the 2 locations but unfortunately it does
> not change the result for me.
> >
> >>> I also believe precise_instrs_loop() to be in the same situation, as the
> >>> architecture doesn't guarantee that the cycle counter increments after
> >>> every CPU cycle (ARM DDI 0487I.a, page D11-5246):
> >>>
> >>> "Although the architecture requires that direct reads of PMCCNTR_EL0 or
> >>> PMCCNTR occur in program order, there is no requirement that the count
> >>> increments between two such reads. Even when the counter is incrementing on
> >>> every clock cycle, software might need check that the difference between
> >>> two reads of the counter is nonzero."
> >> OK
> >>> There's also an entire section in ARM DDI 0487I.a dedicated to this, titled
> >>> "A reasonable degree of inaccuracy" (page D11-5248). I'll post some
> >>> snippets that I found interesting, but there are more examples and
> >>> explanations to be found in that chapter.
> >> yeah I saw that, hence my question about the reasonable disparity we can
> >> expect from the HW/SW stack.
> >>> "In exceptional circumstances, such as a change in Security state or other
> >>> boundary condition, it is acceptable for the count to be inaccurate."
> >>>
> >>> PMCR writes are trapped by KVM. Is a change in exception level an
> >>> "exception circumstance"? Could be, but couldn't find anything definitive.
> >>> For example, the architecture allows an implementation to drop an event in
> >>> the case of an interrupt:
> >>>
> >>> "However, dropping a single branch count as the result of a rare
> >>> interaction with an interrupt is acceptable."
> >>>
> >>> So events could definitely be dropped because of an interrupt for the host.
> >>>
> >>> And there's also this:
> >>>
> >>> "The imprecision means that the counter might have counted an event around
> >>> the time the counter was disabled, but does not allow the event to be
> >>> observed as counted after the counter was disabled."
> >> In our case there seems to be a huge discrepancy.
> > I agree. There is this about the MEM_ACCESS event in the Arm ARM:
> >
> > "The counter counts each Memory-read operation or Memory-write operation
> > that the PE makes."
> >
> > As for what a Memory-read operation is (emphasis added by me):
> >
> > "A memory-read operation might be due to:
> > The result of an architecturally executed memory-reading instructions.
> > The result of a Speculatively executed memory-reading instructions <- this
> > is why the DSB ISH is needed before enabling the PMU.
> > **A translation table walk**."
> >
> > Those extra memory accesses might be caused by the table walker deciding to
> > walk the tables, speculatively or not. Software has no control over the
> > table walker (as long as it is enabled).
> That's indeed an interesting track. But can it be possible that for 20
> expected load instructions we end up with ~150 actual memory accesses.
> I can't help thinking this is a quite surprising amount.  Also the
> pattern is surprising: the first iteration gives low counter count (~30)
> while subsequent ones bring higher and constant ones (~150). I would
> have expected the opposite, no? I will try to run the same experience on
> various HW I have access to.
> 
> Anyway there is a problem while interpreting the result of the tests.
> Either it can happen on some HW (it is a valid behavior according to the
> ARM spec) and the test is simply not runnable or it is a bug somewhere
> in the SW stack. 
> 
> It would be interesting to run the same tests at baremetal level on
> Amberwing and see what are the results. Ricardo/Drew, could you give
> some links about the setup?

Actually, the "bare metal" tests I performed were on a prototype
passthrough implementation:
https://github.com/ricarkol/linux/commit/c2b009e813e18e89d6945915bd3ae5787bbe3164
Let me know how it goes.

Thanks,
Ricardo

> 
> Thanks
> 
> Eric
> >
> > Thanks,
> > Alex
> >
> >>> If you want my opinion, if it is necessary to count the number of events
> >>> for a test instead, I would define a margin of error on the number of
> >>> events counted. Or the test could be changed to check that at least one
> >>> such event was observed.
> >> I agree with you on the fact a reasonable margin must be observed and
> >> the tests may need to be rewritten to account for the observed disparity
> >> if considered "normal". Another way to proceed is to compute the
> >> disparity before launching the main tests and if too big, skip the main
> >> tests. Again on some HW, the counts are really 'as expected' and constant.
> >>
> >> Thanks!
> >>
> >> Eric
> >>> Thanks,
> >>> Alex
> >>>
> 
