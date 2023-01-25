Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2E367AE08
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 10:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235260AbjAYJcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 04:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbjAYJcb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 04:32:31 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4241614EAC;
        Wed, 25 Jan 2023 01:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JUR7w1G00Y0He4cAcVm9pPAQ/J74+kmIZA1AkSH0LVI=; b=Jipq/atGXkJrsmihydbB2nRZuP
        TXJJ3h6XChv1qV8eZz0SZdLDq5Zk7Al6vKyvwAgn4AsdU0LPunyJ1XUjQSfgr3kAvVw6m2UjIJps4
        KTMooqSyFrvV/rQLezYZ5jvPHmObPM6xbWlf/+VCvxU9TG64pSmvl3IeDchh3K574VZ4uBb7zruse
        Jzmlse0nCBAITVsQO3y/lq90ZAzgPMl4Rm2NYqdmfBmZUZrGq8awQgfCdsq0POmEtDzlAptk/Tn32
        4NXfmBFTCQqr9AQjPC8ZlAjxFihVSqykRw6OmTHtlB4daHRK0zfUSCPIb4aalZhV+ozgrQCnS/Gdt
        i/mdvvGw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pKc87-005oRU-4Q; Wed, 25 Jan 2023 09:31:43 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id EEEBB3001E7;
        Wed, 25 Jan 2023 10:31:41 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D86AA2C5B690E; Wed, 25 Jan 2023 10:31:41 +0100 (CET)
Date:   Wed, 25 Jan 2023 10:31:41 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Mark Rutland <mark.rutland@arm.com>
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
Message-ID: <Y9D2/TcAJUPVWasU@hirez.programming.kicks-ass.net>
References: <20230123205009.790550642@infradead.org>
 <Y9AIj1s5iPPki3dK@FVFF77S0Q05N>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9AIj1s5iPPki3dK@FVFF77S0Q05N>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 24, 2023 at 04:34:23PM +0000, Mark Rutland wrote:
> Hi Peter,
> 
> On Mon, Jan 23, 2023 at 09:50:09PM +0100, Peter Zijlstra wrote:
> > 0-day robot reported graph-tracing made the cpuidle-vs-rcu rework go splat.
> 
> Do you have a link toe the splat somewhere?
> 
> I'm assuming that this is partially generic, and I'd like to make sure I test
> the right thing on arm64. I'll throw my usual lockdep options at the ftrace
> selftests...

0-day triggered this by running tools/testing/selftests/ftrace/ftracetest,
which is what I've been using to reproduce.

If that don't work for you I can try and dig out the 0day email to see
if it has more details on.
