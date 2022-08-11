Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7B75906A9
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 21:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbiHKSvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 14:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236000AbiHKSvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 14:51:13 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF1B9BB5C
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 11:51:11 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id k14so15198174pfh.0
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 11:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=tzXKzqcIOW+4VppfefLhNGcPtTIpXz+B5AT/VtrugCw=;
        b=ZXcznfYgwu4Lai5+2B3n+E8oUQGNUmZYQxT8MDhwBDwt4DztkmFF6BE99F+Wg+jr49
         4KHAvGmOZPqPInsSKmIk++aFTuMiY3of9cizuRoJCwYnTC+HUT0dsZFUIYdsXhUfuAHB
         9NpQq0zLENdPk4YXwt26vXWxcWbhbpLKmmRkKCdGKkiUMkVQDt0SMoANHL/0yF+3f2vx
         nPvm6Woj7teXTMc5tijrkflAm7TtqIjd8qDDbmeBY2HOKK4qZKRH77FHTTIBzR2oY2eY
         Lbp0YqfwuRVz0WbraalnpSOP4Dnw62wPxajXh3Unzogxbt+DI4d4NOI4sJzZmHKsfSEB
         vV+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=tzXKzqcIOW+4VppfefLhNGcPtTIpXz+B5AT/VtrugCw=;
        b=TF/GKNLx6ZBgkaIil1Y6vou+Rt3y52XBljoTnl5xyQk9nItrhkLe0i/mUYPDZv6sjY
         4zAP1+i1ohbkdAN1MoRr9oA2plBZcV7ozK/DR0SQk6DKcKaVSxEVphMfEm8MaI9ZftYs
         z9Q3yJbdMkQF9MF1njzlo+FsYDbue1JALGQn0KftYewgKHcJQKKdw6kzGei4FjA/fEsF
         s8nhZiGiXJuj5mQLI34YxFzBPcIuHtw6pYuGJSchjKVrcJp3Oihw0lKutJF8XsAc/aR1
         rfLc6JzE0xDOCOgpi3fMc62i8bdZUns+IAfpt9GhD8UJ9OaLy511TCBwEl7nLU+s5gTk
         XyIA==
X-Gm-Message-State: ACgBeo0+E01uSsCwgy+vpRBPw3wwVHk7/JKg8b0nZYOozCzeSnuBOUOR
        f1pwnYItRQWR9iSeIprnYWyEYg==
X-Google-Smtp-Source: AA6agR4iLFNlDj0ph30X70GjHHvwd62LUom37XQvFaUVmx54k470b8KWdxZ3bJrQcorQ61NWoe0XFA==
X-Received: by 2002:aa7:88cb:0:b0:52f:76bd:7a65 with SMTP id k11-20020aa788cb000000b0052f76bd7a65mr543736pff.72.1660243871206;
        Thu, 11 Aug 2022 11:51:11 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id kb7-20020a17090ae7c700b001f56a5e5d2fsm14056163pjb.2.2022.08.11.11.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 11:51:10 -0700 (PDT)
Date:   Thu, 11 Aug 2022 11:51:06 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v3 2/3] arm: pmu: Reset the pmu registers
 before starting some tests
Message-ID: <YvVPmu9gkMK1v4CW@google.com>
References: <20220805004139.990531-1-ricarkol@google.com>
 <20220805004139.990531-3-ricarkol@google.com>
 <20220810190216.hqt3wyzufyvhhpkf@kamzik>
 <YvRARgEDkSI1ken5@google.com>
 <20220811070405.ivo5w2mliwi4cpqk@kamzik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811070405.ivo5w2mliwi4cpqk@kamzik>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 11, 2022 at 09:04:05AM +0200, Andrew Jones wrote:
> On Wed, Aug 10, 2022 at 04:33:26PM -0700, Ricardo Koller wrote:
> > On Wed, Aug 10, 2022 at 09:02:16PM +0200, Andrew Jones wrote:
> > > On Thu, Aug 04, 2022 at 05:41:38PM -0700, Ricardo Koller wrote:
> > > > Some registers like the PMOVS reset to an architecturally UNKNOWN value.
> > > > Most tests expect them to be reset (mostly zeroed) using pmu_reset().
> > > > Add a pmu_reset() on all the tests that need one.
> > > > 
> > > > As a bonus, fix a couple of comments related to the register state
> > > > before a sub-test.
> > > > 
> > > > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > > ---
> > > >  arm/pmu.c | 6 ++++--
> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/arm/pmu.c b/arm/pmu.c
> > > > index 4c601b05..12e7d84e 100644
> > > > --- a/arm/pmu.c
> > > > +++ b/arm/pmu.c
> > > > @@ -826,7 +826,7 @@ static void test_overflow_interrupt(void)
> > > >  	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> > > >  	isb();
> > > >  
> > > > -	/* interrupts are disabled */
> > > > +	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
> > > >  
> > > >  	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> > > >  	report(expect_interrupts(0), "no overflow interrupt after preset");
> > > > @@ -842,7 +842,7 @@ static void test_overflow_interrupt(void)
> > > >  	isb();
> > > >  	report(expect_interrupts(0), "no overflow interrupt after counting");
> > > >  
> > > > -	/* enable interrupts */
> > > > +	/* enable interrupts (PMINTENSET_EL1 <= ALL_SET) */
> > > >  
> > > >  	pmu_reset_stats();
> > > >  
> > > > @@ -890,6 +890,7 @@ static bool check_cycles_increase(void)
> > > >  	bool success = true;
> > > >  
> > > >  	/* init before event access, this test only cares about cycle count */
> > > > +	pmu_reset();
> > > 
> > > This and the other pmu_reset() call below break compilation on 32-bit arm,
> > > because there's no pmu_reset() defined for it.
> > I completely missed the 32-bit arm case. Thanks!
> > 
> > > It'd probably be best if
> > > we actually implemented some sort of reset for arm, considering it's being
> > > called in common tests.
> > 
> > Mind if I start by creating a pmu_reset() for 32-bit arm, which can
> > later be used by a general arm_reset()?
> 
> No need to worry about a general one. We just need a pmu_reset implemented
> for 32-bit arm up in its #ifdef __arm__ section.

Ahh, OK, for some reason I thought you meant a general one. Anyway,
sending v4.

Thanks,
Ricardo

> 
> Thanks,
> drew
> 
> > 
> > > 
> > > Thanks,
> > > drew
> > > 
> > > >  	set_pmcntenset(1 << PMU_CYCLE_IDX);
> > > >  	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
> > > >  
> > > > @@ -944,6 +945,7 @@ static bool check_cpi(int cpi)
> > > >  	uint32_t pmcr = get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
> > > >  
> > > >  	/* init before event access, this test only cares about cycle count */
> > > > +	pmu_reset();
> > > >  	set_pmcntenset(1 << PMU_CYCLE_IDX);
> > > >  	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
> > > >  
> > > > -- 
> > > > 2.37.1.559.g78731f0fdb-goog
> > > > 
