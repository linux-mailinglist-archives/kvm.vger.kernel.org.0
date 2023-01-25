Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBD167AE16
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 10:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbjAYJgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 04:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234420AbjAYJgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 04:36:17 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5EA582201E;
        Wed, 25 Jan 2023 01:36:16 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2E4D4B3;
        Wed, 25 Jan 2023 01:36:57 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.9.209])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E0903F5A1;
        Wed, 25 Jan 2023 01:36:11 -0800 (PST)
Date:   Wed, 25 Jan 2023 09:36:08 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mingo@kernel.org, will@kernel.org, boqun.feng@gmail.com,
        tglx@linutronix.de, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, jgross@suse.com, srivatsa@csail.mit.edu,
        amakhalov@vmware.com, pv-drivers@vmware.com, rostedt@goodmis.org,
        mhiramat@kernel.org, wanpengli@tencent.com, vkuznets@redhat.com,
        boris.ostrovsky@oracle.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/6] A few cpuidle vs rcu fixes
Message-ID: <Y9D4CJMvV4Jv3iMs@FVFF77S0Q05N>
References: <20230123205009.790550642@infradead.org>
 <Y9AIj1s5iPPki3dK@FVFF77S0Q05N>
 <Y9D2/TcAJUPVWasU@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9D2/TcAJUPVWasU@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 25, 2023 at 10:31:41AM +0100, Peter Zijlstra wrote:
> On Tue, Jan 24, 2023 at 04:34:23PM +0000, Mark Rutland wrote:
> > Hi Peter,
> > 
> > On Mon, Jan 23, 2023 at 09:50:09PM +0100, Peter Zijlstra wrote:
> > > 0-day robot reported graph-tracing made the cpuidle-vs-rcu rework go splat.
> > 
> > Do you have a link toe the splat somewhere?
> > 
> > I'm assuming that this is partially generic, and I'd like to make sure I test
> > the right thing on arm64. I'll throw my usual lockdep options at the ftrace
> > selftests...
> 
> 0-day triggered this by running tools/testing/selftests/ftrace/ftracetest,
> which is what I've been using to reproduce.
> 
> If that don't work for you I can try and dig out the 0day email to see
> if it has more details on.

I had a go running those on arm64, but got different splats (as per my other
replies), so I just wanted to see the backtraces and/or config to check I
wasn't missing something due to CONFIG_* or arch differences.

If you have the email to hand, that'd be great, but don't worry too much about
it!

Thanks,
Mark.
