Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798ED73E5E9
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 19:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbjFZRAL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 13:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjFZRAK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 13:00:10 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13403E6E
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 10:00:08 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-57320c10635so43783197b3.3
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 10:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687798807; x=1690390807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j9BxgDAhr/sOZwOi1b9Dq7JhH2qvW7rzz840YaChgo4=;
        b=AK9aXX4+ipxOh2er/OM84dfQic/ovWnL2dU0rA3Dd9S3fuOvaw0iTkASO3r/wNcP2s
         YPwJTn9fSRAxjnTRoD/uAabL0fRM9yI0QdjbsEuonAqshv23Wgb2k9aKjAmZsLp6xhGn
         RxJLjx9G9Ivcdl5RSZACTEQTOxIZo9z2I0hlgzxphPZtArEzFKmvfR6Gggv1K+Pkaxyz
         MEHrKk/XifJhU1qLg56Gu729bzI238/5dBRTb8k4FYplwM9FlKxIcIezNqPReFYDlk6K
         /IyF6eF8m3BPb6RQw1TvpAza/y0rK5romvqKwNk3yYHJkSuxQ1f7BhceE2d1CRe8iGep
         chfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687798807; x=1690390807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j9BxgDAhr/sOZwOi1b9Dq7JhH2qvW7rzz840YaChgo4=;
        b=jiBMVF80ayZrE4agynyv5x3U693GhXcADq2D7JgDZ7HGjxZ84mvkWwNqzNowSSPdD5
         3HQTclyjmcuXW897Ea+9ql0VjxfNYvoWvyjCtHz/cxomJbzvOWWhIMCG47kfISlQsd7s
         UNfN5JoZyW9wszPKAq+m/d3GAuj3XfUo2sCGAihAgefW+UA3SGm757cSVZsfiKLcY8DG
         rMIGpSji4XGmIxls0uf45gZAD7HC3Rge0inH1DQFLF0/n0Oijcheq/rCpsJuwpA3XdHe
         tgTzi4YGrVw5i11qa8hXbCkCT4RH1qbR5++/PehMHMJAe/Nq8G3QlSBpCTwGHEkTHCQF
         SYFw==
X-Gm-Message-State: AC+VfDxd+sAHEm/Bx4lM0awfAnblvnB7M9uI5wJcmGUYO2lISLKrDzEA
        3dALCzOQCSKED9fbHQQFvtXp6XCrngg=
X-Google-Smtp-Source: ACHHUZ6M+CozMiJrv4S4c/YeinlsszSCh5l+mJX08TZUAgEYs4ymMBbZRpO6B+8EWjUwk4fa2ByGY2DmQTU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6dd5:0:b0:c1e:f91c:2691 with SMTP id
 i204-20020a256dd5000000b00c1ef91c2691mr1598523ybc.10.1687798807292; Mon, 26
 Jun 2023 10:00:07 -0700 (PDT)
Date:   Mon, 26 Jun 2023 10:00:05 -0700
In-Reply-To: <MW4PR11MB5824653862500CB4F9EE4519BB21A@MW4PR11MB5824.namprd11.prod.outlook.com>
Mime-Version: 1.0
References: <20230616113353.45202-1-xiong.y.zhang@intel.com>
 <20230616113353.45202-4-xiong.y.zhang@intel.com> <ZJYCtDN+ITmrgCUs@google.com>
 <MW4PR11MB5824653862500CB4F9EE4519BB21A@MW4PR11MB5824.namprd11.prod.outlook.com>
Message-ID: <ZJnEFTXMpQkXdHRj@google.com>
Subject: Re: [PATCH 3/4] KVM: VMX/pmu: Enable inactive vLBR event in guest LBR
 MSR emulation
From:   Sean Christopherson <seanjc@google.com>
To:     Xiong Y Zhang <xiong.y.zhang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        Zhiyuan Lv <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Weijiang

On Sun, Jun 25, 2023, Xiong Y Zhang wrote:
> > > On Fri, Jun 16, 2023, Xiong Zhang wrote:
> > > vLBR event could be inactive in two case:
> > > a. host per cpu pinned LBR event occupy LBR when vLBR event is created
> > > b. vLBR event is preempted by host per cpu pinned LBR event during vm
> > > exit handler.
> > > When vLBR event is inactive, guest couldn't access LBR msr, and it is
> > > forced into error state and is excluded from schedule by perf scheduler.
> > > So vLBR event couldn't be active through perf scheduler even if host
> > > per cpu pinned LBR event has released LBR, kvm could enable vLBR event
> > > proactively, then vLBR event may be active and LBR msr could be
> > > passthrough into guest.
> > >
> > > Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> > > ---
> > >  arch/x86/kvm/vmx/pmu_intel.c | 11 ++++++++++-
> > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/vmx/pmu_intel.c
> > > b/arch/x86/kvm/vmx/pmu_intel.c index 741efe2c497b..5a3ab8c8711b 100644
> > > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > > @@ -314,7 +314,16 @@ static bool intel_pmu_handle_lbr_msrs_access(struct
> > kvm_vcpu *vcpu,
> > >  	if (!intel_pmu_is_valid_lbr_msr(vcpu, index))
> > >  		return false;
> > >
> > > -	if (!lbr_desc->event && intel_pmu_create_guest_lbr_event(vcpu) < 0)
> > > +	/* vLBR event may be inactive, but physical LBR may be free now.
> > 
> > 	/*
> > 	 * This is the preferred block comment style.
> > 	 */
> > 
> > > +	 * but vLBR event is pinned event, once it is inactive state, perf
> > > +	 * will force it to error state in merge_sched_in() and exclude it from
> > > +	 * perf schedule, so even if LBR is free now, vLBR event couldn't be
> > active
> > > +	 * through perf scheduler and vLBR event could be active through
> > > +	 * perf_event_enable().
> > > +	 */
> > 
> > Trimming that down, is this what you mean?
> Yes, thanks a lot.
> > 
> > 	/*
> > 	 * Attempt to re-enable the vLBR event if it was disabled due to
> > 	 * contention with host LBR usage, i.e. was put into an error state.
> > 	 * Perf doesn't notify KVM if the host stops using LBRs, i.e. KVM needs
> > 	 * to manually re-enable the event.
> > 	 */
> > 
> > Which begs the question, why can't there be a notification of some form that
> > the LBRs are once again available?
> This is perf scheduler rule. If pinned event couldn't get resource as
> resource limitation, perf will put it into error state and exclude it from
> perf scheduler, even if resource available later, perf won't schedule it
> again as it is in error state, the only way to reschedule it is to enable it
> again.  If non-pinned event couldn't get resource as resource limitation,
> perf will put it into inactive state, perf will reschedule it automatically
> once resource is available.  vLBR event is per process pinned event.

That doesn't answer my question.  I get that all of this is subject to perf
scheduling, I'm asking why perf doesn't communicate directly with KVM to coordinate
access to LBRs instead of pulling the rug out from under KVM.

> > Assuming that's too difficult for whatever reason, why wait until the guest tries
> > to read LBRs?  E.g. why not be more aggressive and try to re-enable vLBRs on
> > every VM-Exit.
> Yes, it is a good suggestion. Actually vmx_passthrough_lbr_msrs() is called on every
> VM-exit, it also check vLBR event state, so I could re-enable vLBR in this function.
> > 
> > And if we do wait until the guest touches relevant MSRs, shouldn't writes to
> > DEBUG_CTL that set DEBUGCTLMSR_LBR also try to re-enable the event?
> Only perf know whether vLBR event could be active or not at this moment, if
> vLBR is active, KVM could read/write DEBUG_CTL[0] with irq disable/enable
> pair in theory, but it is better that kvm don't touch perf hw resource
> directly, as vLBR event is one host LBR event, host may have other LBR event,
> perf will schedule them according to perf scheduler rule.  If vLBR is
> inactive, KVM shouldn't touch DEBUG_CTL MSR totally.

Again, this doesn't answer my question.  I didn't suggest KVM write anything
directly, I asked why KVM doesn't try to re-enable the perf LBR event when emulating
a guest write to DEBUG_CTL.

> > Lastly, what guarantees that the MSRs hold guest data?  I assume perf purges
> > the MSRs at some point, but it would be helpful to call that out in the changelog.
> For DEBUG_CTL msr, VMCS has two fields for this:
> 1. "Save debug controls" in VM-Exit controls
> 2. "Load debug controls" in VM-Entry controls
> For LBR records MSRs, perf will save them at process schedule out and load them at process schedule in.

Once again, this doesn't answer my question.  I want to know *exactly* when perf
can take control of the LBRs.  The fact that intel_pmu_handle_lbr_msrs_access()
disables IRQs when checking lbr_desc->event->state strongly suggests that the
answer isn't "when a task is scheduled in".

Your other response[1] mostly answered that question, but I want explicit documentation
on the contract between perf and KVM with respect to LBRs.  In short, please work
with Weijiang to fulfill my request/demand[*] that someone document KVM's LBR support,
and justify the "design".  I am simply not willing to take KVM LBR patches until that
documentation is provided.

Copy+pasting my request/demand for convenience:

  : First and foremost, the existing LBR support needs to be documented.  Someone,
  : I don't care who, needs to provide a detailed writeup of the contract between KVM
  : and perf.  Specifically, I want to know:
  : 
  :   1. When exactly is perf allowed to take control of LBR MRS.  Task switch?  IRQ?
  :      NMI?
  : 
  :   2. What is the expected behavior when perf is using LBRs?  Is the guest supposed
  :      to be traced?
  : 
  :   3. Why does KVM snapshot DEBUGCTL with IRQs enabled, but disables IRQs when
  :      accessing LBR MSRs?
  : 
  : It doesn't have to be polished, e.g. I'll happily wordsmith things into proper
  : documentation, but I want to have a very clear understanding of how LBR support
  : is _intended_ to function and how it all _actually_ functions without having to
  : make guesses.
  : 
  : And depending on the answers, I want to revisit KVM's LBR implementation before
  : tackling arch LBRs.  Letting perf usurp LBRs while KVM has the vCPU loaded is
  : frankly ridiculous.  Just have perf set a flag telling KVM that it needs to take
  : control of LBRs and have KVM service the flag as a request or something.  Stealing
  : the LBRs back in IRQ context adds a stupid amount of complexity without much value,
  : e.g. waiting a few branches for KVM to get to a safe place isn't going to meaningfully
  : change the traces.  If that can't actually happen, then why on earth does KVM need
  : to disable IRQs to read MSRs?
  : 
  : And AFAICT, since KVM unconditionally loads the guest's DEBUGCTL, whether or not
  : guest branches show up in the LBRs when the host is tracing is completely up to
  : the whims of the guest.  If that's correct, then again, what's the point of the
  : dance between KVM and perf?

[1] https://lkml.kernel.org/r/MW4PR11MB5824480492ED55C63769FF11BB21A%40MW4PR11MB5824.namprd11.prod.outlook.com
[2] https://lore.kernel.org/all/Y9RUOvJ5dkCU9J8C@google.com
