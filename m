Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16CF58F4E9
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 01:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbiHJXdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 19:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiHJXdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 19:33:32 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891BF7FE6B
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 16:33:31 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id c24so10833780pgg.11
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 16:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=KboTvwgUFUJZZgdLSyM30lTXnrslAqe3eOSw/sVDlUY=;
        b=jM6njugBVrh9WNTJQOr6gE5k45aeD/aB+ULFzWYMorDQhSH8zrpJNCjyFiWB34SbY7
         WrnyyGxzRlMhfroh8aQ737/XyEaYQpiBOOqoRSZnWPMuBT+nx1NiNcTIQyf8DFkWD1zf
         9wLEzWuB9v3Xgg9qJW1ptkKyd1BRRs47MabRONrogQjvNn0ZozusgLcRGTWRpYlHNk39
         WpwUFsKxAnqsrgMT5premRn33serrhdKBLJRhP+dYdoskAzny7eySKhtcc/C0yi+HpoH
         elCYpIACP4H2F6AmMaaul8Yx5pQdJj5SejLLeyrx2olqFCjH5qaM+167ZXvZ5LAicER8
         IfUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=KboTvwgUFUJZZgdLSyM30lTXnrslAqe3eOSw/sVDlUY=;
        b=HWxnPZxJ3aeOUktcecYZ6qN6Roy8F5vQS+cMZsMbsLALjOKQnCf3pjNm41IwGIOXQE
         sGmpfhoXoKnDv2aaJ6ukMw2Eulghcp3j8CLyvw0wV/GOaB52W5W+R6SrvWGxzkX3y7Qo
         mpGlMuvM8yM4TFnSSxzI1JfX9MZK/Eut+Ii+gylgtIJr+KUb5H5pKHQUih8sWZkryZGo
         Fnqtnib9f3LhlQRT7V2/++8ihyMS0OKaFHgjEHYv7qrDxcX0H6t7tUyXeQJVmTPow9a8
         KR7eiH7ncct5u0Zqdd+n2Kt1tv2i/5ZMB2u16Me3PqKV39AVtFajrt4zdvurISqn6lN9
         nxTg==
X-Gm-Message-State: ACgBeo1VSk1MBzP7BjIE1i+q01YUK0TfliGVCTPChwElrloAwD/PVA90
        TgaK88i1D3Uwx4d9VkEAJ+zguw==
X-Google-Smtp-Source: AA6agR7L/RXaWNWjaSPyN9BUFzkksyrI4OgzKqR2iz1PyEsp2uz10foTn2uB8rPwHVCSuh3R9Obibw==
X-Received: by 2002:a05:6a00:1821:b0:52e:3c7c:9297 with SMTP id y33-20020a056a00182100b0052e3c7c9297mr29474982pfa.54.1660174410908;
        Wed, 10 Aug 2022 16:33:30 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id i126-20020a628784000000b0052d33bf14d6sm2603501pfe.63.2022.08.10.16.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 16:33:30 -0700 (PDT)
Date:   Wed, 10 Aug 2022 16:33:26 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v3 2/3] arm: pmu: Reset the pmu registers
 before starting some tests
Message-ID: <YvRARgEDkSI1ken5@google.com>
References: <20220805004139.990531-1-ricarkol@google.com>
 <20220805004139.990531-3-ricarkol@google.com>
 <20220810190216.hqt3wyzufyvhhpkf@kamzik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810190216.hqt3wyzufyvhhpkf@kamzik>
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

On Wed, Aug 10, 2022 at 09:02:16PM +0200, Andrew Jones wrote:
> On Thu, Aug 04, 2022 at 05:41:38PM -0700, Ricardo Koller wrote:
> > Some registers like the PMOVS reset to an architecturally UNKNOWN value.
> > Most tests expect them to be reset (mostly zeroed) using pmu_reset().
> > Add a pmu_reset() on all the tests that need one.
> > 
> > As a bonus, fix a couple of comments related to the register state
> > before a sub-test.
> > 
> > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arm/pmu.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index 4c601b05..12e7d84e 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -826,7 +826,7 @@ static void test_overflow_interrupt(void)
> >  	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> >  	isb();
> >  
> > -	/* interrupts are disabled */
> > +	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
> >  
> >  	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> >  	report(expect_interrupts(0), "no overflow interrupt after preset");
> > @@ -842,7 +842,7 @@ static void test_overflow_interrupt(void)
> >  	isb();
> >  	report(expect_interrupts(0), "no overflow interrupt after counting");
> >  
> > -	/* enable interrupts */
> > +	/* enable interrupts (PMINTENSET_EL1 <= ALL_SET) */
> >  
> >  	pmu_reset_stats();
> >  
> > @@ -890,6 +890,7 @@ static bool check_cycles_increase(void)
> >  	bool success = true;
> >  
> >  	/* init before event access, this test only cares about cycle count */
> > +	pmu_reset();
> 
> This and the other pmu_reset() call below break compilation on 32-bit arm,
> because there's no pmu_reset() defined for it.
I completely missed the 32-bit arm case. Thanks!

> It'd probably be best if
> we actually implemented some sort of reset for arm, considering it's being
> called in common tests.

Mind if I start by creating a pmu_reset() for 32-bit arm, which can
later be used by a general arm_reset()?

> 
> Thanks,
> drew
> 
> >  	set_pmcntenset(1 << PMU_CYCLE_IDX);
> >  	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
> >  
> > @@ -944,6 +945,7 @@ static bool check_cpi(int cpi)
> >  	uint32_t pmcr = get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
> >  
> >  	/* init before event access, this test only cares about cycle count */
> > +	pmu_reset();
> >  	set_pmcntenset(1 << PMU_CYCLE_IDX);
> >  	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
> >  
> > -- 
> > 2.37.1.559.g78731f0fdb-goog
> > 
