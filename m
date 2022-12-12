Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2957164A923
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 22:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbiLLVCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 16:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbiLLVBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 16:01:21 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489CB192AF
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 13:00:33 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id hd14-20020a17090b458e00b0021909875bccso14390680pjb.1
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 13:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q9Cyo+MN6iBVlGOYy9H2mOmmPEe1O5thk2JRcg21fBc=;
        b=KNx9YYvO93M5B4T55A8WKWO154LIH84Vo3+FddYs42VspFrdJyrMt/0QeFruvwvuhD
         D1A1dZFuhoNGfz3iGlwt4AUJeRC//kF1kT1nI+I1CfdI4dftF+t6YjPxYPKlpHdtGcrV
         6h17olcjsZKcD/cbVdH2P7SkU8ST1A24TA6BcaVZKr4/5+u6S3/+rGxEYz9Z7rGiNjCw
         bmneFuy9ChqbLHUay0pRh7IQkvI5wATkD4tBSplwQWXt5i1ZO71cMc1S6cJHjhLy2ZUY
         ktTMJoanlkW9I3IJwh4WQcjNkGFnB5o72Yd3mNZr01qQhrl1KkLb+Tjhi3PGlu/MCwEA
         6eYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q9Cyo+MN6iBVlGOYy9H2mOmmPEe1O5thk2JRcg21fBc=;
        b=IrFYeC4XGwg60bQcvgW9U3qbC0p/lQHZf+LR3CtAvHdN1fLVizbNYvB0ijwhdf+DVs
         DGx3e1+313Gl0Ge12saFdOnV7oWJ+l+pXaf4owPi7z6K3DyU6ZYDOoK9ULLbgnCEV/cL
         pXUmcL5cESskqK59cEIRNFPF9BMTfeOWr0OGFC3r1vfQ+n+Txmb3P76bFppNnudVGniT
         pnTsHY5Lm1Np2eFaitDhz/tNqQtW/Yj83uhG+PAZPPPXK56BwcOjiMsKx0qdaDTKiyxy
         /cI+uSsguCd4yR5R9nZZDQgwhTljfiHzqMjG3aPqDV8lppX/xaXbVSs/x3wXpgGxVksy
         bDcA==
X-Gm-Message-State: ANoB5pl79v4OrMT0AVIa/+cpscPgzkoLUqK8olDv+LA64vFUtqgQoyCB
        r/fknZ9ew8auuT5qA/MLgodgYA==
X-Google-Smtp-Source: AA0mqf5tIy71VbMFz6SVtwFMYe0tokUeSCJNdKhzpY/uiVg8ygC0fgJJRcgKfbPfsOuqoXFXn9nuZQ==
X-Received: by 2002:a05:6a20:1d57:b0:a7:891b:3601 with SMTP id cs23-20020a056a201d5700b000a7891b3601mr723671pzb.1.1670878832582;
        Mon, 12 Dec 2022 13:00:32 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id e9-20020a63ae49000000b0046b1dabf9a8sm1128741pgp.70.2022.12.12.13.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 13:00:32 -0800 (PST)
Date:   Mon, 12 Dec 2022 13:00:28 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, maz@kernel.org, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 1/3] arm: pmu: Fix overflow checks for
 PMUv3p5 long counters
Message-ID: <Y5eWbEEDD/eOInYx@google.com>
References: <20221202045527.3646838-1-ricarkol@google.com>
 <20221202045527.3646838-2-ricarkol@google.com>
 <Y5N0os7zL/BaMBa3@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5N0os7zL/BaMBa3@monolith.localdoman>
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

On Fri, Dec 09, 2022 at 05:47:14PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Fri, Dec 02, 2022 at 04:55:25AM +0000, Ricardo Koller wrote:
> > PMUv3p5 uses 64-bit counters irrespective of whether the PMU is configured
> > for overflowing at 32 or 64-bits. The consequence is that tests that check
> > the counter values after overflowing should not assume that values will be
> > wrapped around 32-bits: they overflow into the other half of the 64-bit
> > counters on PMUv3p5.
> > 
> > Fix tests by correctly checking overflowing-counters against the expected
> > 64-bit value.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arm/pmu.c | 29 ++++++++++++++++++-----------
> >  1 file changed, 18 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index cd47b14..eeac984 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -54,10 +54,10 @@
> >  #define EXT_COMMON_EVENTS_LOW	0x4000
> >  #define EXT_COMMON_EVENTS_HIGH	0x403F
> >  
> > -#define ALL_SET			0xFFFFFFFF
> > -#define ALL_CLEAR		0x0
> > -#define PRE_OVERFLOW		0xFFFFFFF0
> > -#define PRE_OVERFLOW2		0xFFFFFFDC
> > +#define ALL_SET			0x00000000FFFFFFFFULL
> > +#define ALL_CLEAR		0x0000000000000000ULL
> > +#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
> > +#define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
> >  
> >  #define PMU_PPI			23
> >  
> > @@ -538,6 +538,7 @@ static void test_mem_access(void)
> >  static void test_sw_incr(void)
> >  {
> >  	uint32_t events[] = {SW_INCR, SW_INCR};
> > +	uint64_t cntr0;
> >  	int i;
> >  
> >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > @@ -572,9 +573,9 @@ static void test_sw_incr(void)
> >  		write_sysreg(0x3, pmswinc_el0);
> >  
> >  	isb();
> > -	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
> > -	report(read_regn_el0(pmevcntr, 1)  == 100,
> > -		"counter #0 after + 100 SW_INCR");
> > +	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : PRE_OVERFLOW + 100;
> 
> Hm... in the Arm ARM it says that counters are 64-bit if PMUv3p5 is
> implemented.  But it doesn't say anywhere that versions newer than p5 are
> required to implement PMUv3p5.
> 
> For example, for PMUv3p7, it says that the feature is mandatory in Arm8.7
> implementations. My interpretation of that is that it is not forbidden for
> an implementer to cherry-pick this version on older versions of the
> architecture where PMUv3p5 is not implemented.
> 
> Maybe the check should be pmu.version == ID_DFR0_PMU_V3_8_5, to match the
> counter definitions in the architecture?
> 
> Also, I found the meaning of those numbers to be quite cryptic. Perhaps
> something like this would be more resilient to changes to the value of
> PRE_OVERFLOW and easier to understand:
> 
> +       cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ?
> +               (uint32_t)PRE_OVERFLOW + 100 :
> +               (uint64_t)PRE_OVERFLOW + 100;
> 
> I haven't tested the code, would that work?

Just checked. That works. It's much cleaner, thank you very much.

Will send a v2 a the end of the week, maybe after some more reviews.

> 
> Thanks,
> Alex
> 
> > +	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
> > +	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
> >  	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
> >  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> >  	report(read_sysreg(pmovsclr_el0) == 0x1,
> > @@ -584,6 +585,7 @@ static void test_sw_incr(void)
> >  static void test_chained_counters(void)
> >  {
> >  	uint32_t events[] = {CPU_CYCLES, CHAIN};
> > +	uint64_t cntr1;
> >  
> >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> >  		return;
> > @@ -618,13 +620,16 @@ static void test_chained_counters(void)
> >  
> >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> > -	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
> > +	cntr1 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 0 : ALL_SET + 1;
> > +	report(read_regn_el0(pmevcntr, 1) == cntr1, "CHAIN counter #1 wrapped");
> > +
> >  	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
> >  }
> >  
> >  static void test_chained_sw_incr(void)
> >  {
> >  	uint32_t events[] = {SW_INCR, CHAIN};
> > +	uint64_t cntr0, cntr1;
> >  	int i;
> >  
> >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > @@ -665,10 +670,12 @@ static void test_chained_sw_incr(void)
> >  		write_sysreg(0x1, pmswinc_el0);
> >  
> >  	isb();
> > +	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 0 : ALL_SET + 1;
> > +	cntr1 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : PRE_OVERFLOW + 100;
> >  	report((read_sysreg(pmovsclr_el0) == 0x3) &&
> > -		(read_regn_el0(pmevcntr, 1) == 0) &&
> > -		(read_regn_el0(pmevcntr, 0) == 84),
> > -		"expected overflows and values after 100 SW_INCR/CHAIN");
> > +	       (read_regn_el0(pmevcntr, 1) == cntr0) &&
> > +	       (read_regn_el0(pmevcntr, 0) == cntr1),
> > +	       "expected overflows and values after 100 SW_INCR/CHAIN");
> >  	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
> >  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> >  }
> > -- 
> > 2.39.0.rc0.267.gcb52ba06e7-goog
> > 
