Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03133679D63
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 16:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbjAXP0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 10:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233174AbjAXP0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 10:26:18 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC41125B1
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 07:26:16 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id 88so3687489pjo.3
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 07:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5Egjet2PChlUSP9P/HhmF7wCKfNgUGYIAJ4SnLtZ758=;
        b=UIVyg9QdGgn0EuYx12nsBhWBFAZl7MjKYmPRXNtHzo722jZivvksBJghdgjuoht/wQ
         KFNMtcXpTmwjFH1EH8mtjuJfm86dzVcvfxEJArjwooLHRpw21zhYEuqhD/e4ncA7ekbC
         Q2qSjqxXZzjSvqYeVMxIJaJpBvDz2cHJH6aWb4VSsATPj2OovV1ILC+1EmWSqemfUtpj
         VN3qbiXOShwNjJtghP0w4wxTiU5jEoNapAZH3sFeliNBQJKOJ2f7v7dmngJtnyzzb2rS
         n/u4dfqPShJaeZwZ04b2YTVHHMU6fZAuQyvvvsVX31p04CaV7T7C1BiqhktSys6ceA3n
         nQNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Egjet2PChlUSP9P/HhmF7wCKfNgUGYIAJ4SnLtZ758=;
        b=bOSgG3MGHE0ke3CECdMDOt6Lc6R0NqvtxQb/ySEdL5FNDimvPIgtPAIqZJFz6e6Wke
         RbY+QDvW4wEiUJg8JBtsFCLWuLsEZF6bd53dzTKi2PfBWI6dmxzafOpcjWpA1FaMou9c
         Q/kvWOLmJYjbPk4AnjiAXdmbXJWi4+lFzYypihInuH+ah88zbCHsza/IlQ5ZhxU4nm/I
         HA9K3cn+6LTJT2Lz0pj4WkoSzMKVl4NG2i7jSH8GuBi+D465FIfXa1sIMZl9D3WJNYj4
         uC/OGYwPgFJwH2iqAvWia4raIZILvJ2EDY6t27DXkS4L4IqxX1HnoDfaKzFKPLMExdjz
         Phjg==
X-Gm-Message-State: AO0yUKV1R6Q/EtIIZC+jk7zZm7DGwz/l7LBAG+JIi5yI8bAQ3l/rs7aX
        bI+k7OKclrJPq5htHQiZpyzXww==
X-Google-Smtp-Source: AK7set9TJFKTRSpdCn4dXJflHjQfFqIsfCM3JbzIBQQ6d0t363bGyO7kHQ4/mqdVTTSn4/i4PD3XBQ==
X-Received: by 2002:a05:6a21:998a:b0:b8:c859:7fc4 with SMTP id ve10-20020a056a21998a00b000b8c8597fc4mr244767pzb.1.1674573975502;
        Tue, 24 Jan 2023 07:26:15 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id t6-20020a63b246000000b00499a90cce5bsm1598264pgo.50.2023.01.24.07.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 07:26:14 -0800 (PST)
Date:   Tue, 24 Jan 2023 07:26:11 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, alexandru.elisei@arm.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v3 3/4] arm: pmu: Add tests for 64-bit
 overflows
Message-ID: <Y8/4kxSdOP2QrJVm@google.com>
References: <20230109211754.67144-1-ricarkol@google.com>
 <20230109211754.67144-4-ricarkol@google.com>
 <8bfc9b2b-0bad-a6dc-3c23-f67ad3d56741@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bfc9b2b-0bad-a6dc-3c23-f67ad3d56741@redhat.com>
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

On Mon, Jan 23, 2023 at 09:33:50PM +0100, Eric Auger wrote:
> Hi Ricardo,
> 
> On 1/9/23 22:17, Ricardo Koller wrote:
> > Modify all tests checking overflows to support both 32 (PMCR_EL0.LP == 0)
> > and 64-bit overflows (PMCR_EL0.LP == 1). 64-bit overflows are only
> > supported on PMUv3p5.
> >
> > Note that chained tests do not implement "overflow_at_64bits == true".
> > That's because there are no CHAIN events when "PMCR_EL0.LP == 1" (for more
> > details see AArch64.IncrementEventCounter() pseudocode in the ARM ARM DDI
> > 0487H.a, J1.1.1 "aarch64/debug").
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arm/pmu.c | 116 +++++++++++++++++++++++++++++++++++-------------------
> >  1 file changed, 75 insertions(+), 41 deletions(-)
> >
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index 0d06b59..72d0f50 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -28,6 +28,7 @@
> >  #define PMU_PMCR_X         (1 << 4)
> >  #define PMU_PMCR_DP        (1 << 5)
> >  #define PMU_PMCR_LC        (1 << 6)
> > +#define PMU_PMCR_LP        (1 << 7)
> >  #define PMU_PMCR_N_SHIFT   11
> >  #define PMU_PMCR_N_MASK    0x1f
> >  #define PMU_PMCR_ID_SHIFT  16
> > @@ -56,9 +57,13 @@
> >  
> >  #define ALL_SET			0x00000000FFFFFFFFULL
> >  #define ALL_CLEAR		0x0000000000000000ULL
> > -#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
> > +#define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
> > +#define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
> >  #define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
> >  
> > +#define PRE_OVERFLOW(__overflow_at_64bits)				\
> > +	(__overflow_at_64bits ? PRE_OVERFLOW_64 : PRE_OVERFLOW_32)
> > +
> >  #define PMU_PPI			23
> >  
> >  struct pmu {
> > @@ -449,8 +454,10 @@ static bool check_overflow_prerequisites(bool overflow_at_64bits)
> >  static void test_basic_event_count(bool overflow_at_64bits)
> >  {
> >  	uint32_t implemented_counter_mask, non_implemented_counter_mask;
> > -	uint32_t counter_mask;
> > +	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
> > +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
> >  	uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
> > +	uint32_t counter_mask;
> >  
> >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> >  	    !check_overflow_prerequisites(overflow_at_64bits))
> > @@ -472,13 +479,13 @@ static void test_basic_event_count(bool overflow_at_64bits)
> >  	 * clear cycle and all event counters and allow counter enablement
> >  	 * through PMCNTENSET. LC is RES1.
> >  	 */
> > -	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
> > +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P | pmcr_lp);
> >  	isb();
> > -	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC), "pmcr: reset counters");
> > +	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC | pmcr_lp), "pmcr: reset counters");
> >  
> >  	/* Preset counter #0 to pre overflow value to trigger an overflow */
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > -	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
> > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > +	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
> >  		"counter #0 preset to pre-overflow value");
> >  	report(!read_regn_el0(pmevcntr, 1), "counter #1 is 0");
> >  
> > @@ -531,6 +538,8 @@ static void test_mem_access(bool overflow_at_64bits)
> >  {
> >  	void *addr = malloc(PAGE_SIZE);
> >  	uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
> > +	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
> > +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
> >  
> >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> >  	    !check_overflow_prerequisites(overflow_at_64bits))
> > @@ -542,7 +551,7 @@ static void test_mem_access(bool overflow_at_64bits)
> >  	write_regn_el0(pmevtyper, 1, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  	isb();
> > -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> > +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> >  	report_info("counter #0 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
> >  	report_info("counter #1 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
> >  	/* We may measure more than 20 mem access depending on the core */
> > @@ -552,11 +561,11 @@ static void test_mem_access(bool overflow_at_64bits)
> >  
> >  	pmu_reset();
> >  
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > +	write_regn_el0(pmevcntr, 1, pre_overflow);
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  	isb();
> > -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> > +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> >  	report(read_sysreg(pmovsclr_el0) == 0x3,
> >  	       "Ran 20 mem accesses with expected overflows on both counters");
> >  	report_info("cnt#0 = %ld cnt#1=%ld overflow=0x%lx",
> > @@ -566,8 +575,10 @@ static void test_mem_access(bool overflow_at_64bits)
> >  
> >  static void test_sw_incr(bool overflow_at_64bits)
> >  {
> > +	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
> > +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
> >  	uint32_t events[] = {SW_INCR, SW_INCR};
> > -	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> > +	uint64_t cntr0 = (pre_overflow + 100) & pmevcntr_mask();
> >  	int i;
> >  
> >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> > @@ -581,7 +592,7 @@ static void test_sw_incr(bool overflow_at_64bits)
> >  	/* enable counters #0 and #1 */
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> >  	isb();
> >  
> >  	for (i = 0; i < 100; i++)
> > @@ -589,14 +600,14 @@ static void test_sw_incr(bool overflow_at_64bits)
> >  
> >  	isb();
> >  	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
> > -	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
> > +	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
> >  		"PWSYNC does not increment if PMCR.E is unset");
> >  
> >  	pmu_reset();
> >  
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> > -	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> > +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> >  	isb();
> >  
> >  	for (i = 0; i < 100; i++)
> > @@ -614,6 +625,7 @@ static void test_sw_incr(bool overflow_at_64bits)
> >  static void test_chained_counters(bool unused)
> >  {
> >  	uint32_t events[] = {CPU_CYCLES, CHAIN};
> > +	uint64_t all_set = pmevcntr_mask();
> ALL_SET_32 may be enough, as suggested by Reiji;

I think we still want to conditionally use ALL_SET_64 for the
pre-overflow value of the odd counter in the case of PMUv3p5.
More below.

> >  
> >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> >  		return;
> > @@ -624,7 +636,7 @@ static void test_chained_counters(bool unused)
> >  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> >  	/* enable counters #0 and #1 */
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> >  
> >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >  
> > @@ -636,26 +648,26 @@ static void test_chained_counters(bool unused)
> >  	pmu_reset();
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> >  	write_regn_el0(pmevcntr, 1, 0x1);
> >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> >  	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
> >  	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");

As we want to test the overflow of the chained counter, we need
ALL_SET_64 for its preoverflow value.

> >  
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > -	write_regn_el0(pmevcntr, 1, ALL_SET);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> > +	write_regn_el0(pmevcntr, 1, all_set);
> and here
> >  
> >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> > -	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
> > +	report(read_regn_el0(pmevcntr, 1) == 0, "CHAIN counter #1 wrapped");
> >  	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
> >  }
> >  
> >  static void test_chained_sw_incr(bool unused)
> >  {
> >  	uint32_t events[] = {SW_INCR, CHAIN};
> > -	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> > +	uint64_t cntr0 = (PRE_OVERFLOW_32 + 100) & pmevcntr_mask();
> >  	uint64_t cntr1 = (ALL_SET + 1) & pmevcntr_mask();
> >  	int i;
> the chained counter changes may be put in a separate patch to help the
> reviewer focus on the new 64b overflow tests.

Got it, will try that for the next version.

> >  
> > @@ -669,7 +681,7 @@ static void test_chained_sw_incr(bool unused)
> >  	/* enable counters #0 and #1 */
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> >  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> >  	isb();
> >  
> > @@ -687,7 +699,7 @@ static void test_chained_sw_incr(bool unused)
> >  	pmu_reset();
> >  
> >  	write_regn_el0(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> >  	write_regn_el0(pmevcntr, 1, ALL_SET);
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> > @@ -726,7 +738,7 @@ static void test_chain_promotion(bool unused)
> >  
> >  	/* Only enable even counter */
> >  	pmu_reset();
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> >  	write_sysreg_s(0x1, PMCNTENSET_EL0);
> >  	isb();
> >  
> > @@ -856,6 +868,9 @@ static bool expect_interrupts(uint32_t bitmap)
> >  
> >  static void test_overflow_interrupt(bool overflow_at_64bits)
> >  {
> > +	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
> > +	uint64_t all_set = pmevcntr_mask();
> > +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
> >  	uint32_t events[] = {MEM_ACCESS, SW_INCR};
> >  	void *addr = malloc(PAGE_SIZE);
> >  	int i;
> > @@ -874,16 +889,16 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> >  	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
> >  	write_regn_el0(pmevtyper, 1, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > +	write_regn_el0(pmevcntr, 1, pre_overflow);
> >  	isb();
> >  
> >  	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
> >  
> > -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> > +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> I noticed that undocumented change. Is it done on purpose?

Yes, it's intentional. It conditionally sets PMCR.LP for the next
subtest when overflow_at_64bits==true. That's also why the pre-overflow
value is close to ALL_SET_64 (and not ALL_SET_32).

> >  	report(expect_interrupts(0), "no overflow interrupt after preset");
> >  
> > -	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> > +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> >  	isb();
> >  
> >  	for (i = 0; i < 100; i++)
> > @@ -898,12 +913,12 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> >  
> >  	pmu_reset_stats();
> >  
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > +	write_regn_el0(pmevcntr, 1, pre_overflow);
> >  	write_sysreg(ALL_SET, pmintenset_el1);
> >  	isb();
> >  
> > -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> > +	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> >  	for (i = 0; i < 100; i++)
> >  		write_sysreg(0x3, pmswinc_el0);
> >  
> > @@ -912,25 +927,40 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> >  	report(expect_interrupts(0x3),
> >  		"overflow interrupts expected on #0 and #1");
> >  
> > -	/* promote to 64-b */
> > +	/*
> > +	 * promote to 64-b:
> > +	 *
> > +	 * This only applies to the !overflow_at_64bits case, as
> > +	 * overflow_at_64bits doesn't implement CHAIN events. The
> > +	 * overflow_at_64bits case just checks that chained counters are
> > +	 * not incremented when PMCR.LP == 1.
> > +	 */
> >  
> >  	pmu_reset_stats();
> >  
> >  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> >  	isb();
> > -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> > -	report(expect_interrupts(0x1),
> > -		"expect overflow interrupt on 32b boundary");
> > +	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> > +	report(expect_interrupts(0x1), "expect overflow interrupt");
> >  
> >  	/* overflow on odd counter */
> >  	pmu_reset_stats();
> > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > -	write_regn_el0(pmevcntr, 1, ALL_SET);
> > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > +	write_regn_el0(pmevcntr, 1, all_set);
> >  	isb();
> > -	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
> > -	report(expect_interrupts(0x3),
> > -		"expect overflow interrupt on even and odd counter");
> > +	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> > +	if (overflow_at_64bits) {
> > +		report(expect_interrupts(0x1),
> > +		       "expect overflow interrupt on even counter");
> > +		report(read_regn_el0(pmevcntr, 1) == all_set,
> > +		       "Odd counter did not change");
> > +	} else {
> > +		report(expect_interrupts(0x3),
> > +		       "expect overflow interrupt on even and odd counter");
> > +		report(read_regn_el0(pmevcntr, 1) != all_set,
> > +		       "Odd counter wrapped");
> > +	}
> >  }
> >  #endif
> >  
> > @@ -1131,10 +1161,13 @@ int main(int argc, char *argv[])
> >  		report_prefix_pop();
> >  	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
> >  		run_test(argv[1], test_basic_event_count, false);
> > +		run_test(argv[1], test_basic_event_count, true);
> >  	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
> >  		run_test(argv[1], test_mem_access, false);
> > +		run_test(argv[1], test_mem_access, true);
> >  	} else if (strcmp(argv[1], "pmu-sw-incr") == 0) {
> >  		run_test(argv[1], test_sw_incr, false);
> > +		run_test(argv[1], test_sw_incr, true);
> >  	} else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
> >  		run_test(argv[1], test_chained_counters, false);
> >  	} else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
> > @@ -1143,6 +1176,7 @@ int main(int argc, char *argv[])
> >  		run_test(argv[1], test_chain_promotion, false);
> >  	} else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
> >  		run_test(argv[1], test_overflow_interrupt, false);
> > +		run_test(argv[1], test_overflow_interrupt, true);
> >  	} else {
> >  		report_abort("Unknown sub-test '%s'", argv[1]);
> >  	}
> Thanks
> 
> Eric
> 
