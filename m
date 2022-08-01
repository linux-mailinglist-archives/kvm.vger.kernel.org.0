Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E62F587145
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 21:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiHATQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 15:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234739AbiHATPk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 15:15:40 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E25DE92
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 12:15:20 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id e8-20020a17090a280800b001f2fef7886eso13065100pjd.3
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 12:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=/oStoCO0mT6rZhV2DeGrwB0VNg7LosUxnetqgViVbr8=;
        b=T0yeick6KigupptQPl0zhobPECqEarbUKCRNYbFsOAGJk283U6Of+l8cdV6KfiiymE
         zMqH+SadPLlqjJh3jr8zjYlKQS+pYwCURHiSdaN8oA62/D8xaYkwgjidUhAq2rPb5X6z
         86axOgJEUpSTgqUUla9elQf0w8hwVO/ENf7HIhwh0PBgg/d1Blz0oZOkWgSN7MXsqDl7
         okfu7Fyl00s/FO7ZANQ23iAoAIxEqIbqA2SBrnJPE7V+F5szdtI1WZucUwXC4s8DzXN2
         gAFFtsHGvU5H2pfXtt9KXusED3CaoOVP1oCC/PGnZG9BM7uGh4KP2kRGibZPN/eQEh76
         O75A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=/oStoCO0mT6rZhV2DeGrwB0VNg7LosUxnetqgViVbr8=;
        b=Gp79jxGq7ER9th2QvAJrsSpQ3km6fz5nl5yRk+EFpHgjf+pbBDg7CIhs2c4wgccKnj
         wJbx5jbuwYIV69dJUF1rxixSzrJfnMTOGxjW3MZxeMlbv61iFagt/Lj+VpBQ5mIn3jt9
         MF+tMsavkVklnVfu/YChUikH4lwI3YUi06nS8utG5U9TCqN0+jIGXTBr3trXTQXv+ZxW
         BhA+jRon79DCfn6W4kB5nv/leVl8CcceiuXhWW0Z8TJjGV+DRkd3qEPUNRn3ANayRSsx
         5/c13ZmVZV2Dx0LRtknNIEQcZ9tDlTnSThVedVxYYf53vkFh7Om+uTneyeWoOtmOlfCk
         YOKg==
X-Gm-Message-State: ACgBeo28U6hgNDqU0XEiag7faTKcpI91RdVupHZLeKrUKN2BO4QkVpHP
        2vsE/9Dj3ZZBHXXwnpLUd3r9jw==
X-Google-Smtp-Source: AA6agR4D8nyYYlDLtp3y9WVX5Prh8hDInUk2g83okT4qkBAwKcL+s+5gZbDGkpDSQ4RzA44uWUltfw==
X-Received: by 2002:a17:90a:988:b0:1f2:3dff:f1dd with SMTP id 8-20020a17090a098800b001f23dfff1ddmr20814591pjo.150.1659381320073;
        Mon, 01 Aug 2022 12:15:20 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id y6-20020a63de46000000b0040c40b022fbsm7575223pgi.94.2022.08.01.12.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 12:15:19 -0700 (PDT)
Date:   Mon, 1 Aug 2022 12:15:15 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Andrew Jones <andrew.jones@linux.dev>,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 3/3] arm: pmu: Remove checks for !overflow
 in chained counters tests
Message-ID: <YugmQ3lDPcw9qb0v@google.com>
References: <20220718154910.3923412-1-ricarkol@google.com>
 <20220718154910.3923412-4-ricarkol@google.com>
 <87sfmiwywd.wl-maz@kernel.org>
 <87r122wynd.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r122wynd.wl-maz@kernel.org>
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

On Sat, Jul 30, 2022 at 01:52:38PM +0100, Marc Zyngier wrote:
> Crumbs... With Drew's new email this time.
> 
> On Sat, 30 Jul 2022 13:47:14 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> > 
> > Hi Ricardo,
> > 
> > On Mon, 18 Jul 2022 16:49:10 +0100,
> > Ricardo Koller <ricarkol@google.com> wrote:
> > > 
> > > A chained event overflowing on the low counter can set the overflow flag
> > > in PMOVS.  KVM does not set it, but real HW and the fast-model seem to.
> > > Moreover, the AArch64.IncrementEventCounter() pseudocode in the ARM ARM
> > > (DDI 0487H.a, J1.1.1 "aarch64/debug") also sets the PMOVS bit on
> > > overflow.
> > > 
> > > The pmu chain tests fail on bare metal when checking the overflow flag
> > > of the low counter _not_ being set on overflow.  Fix by removing the
> > > checks.
> > > 
> > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > ---
> > >  arm/pmu.c | 21 ++++++++++-----------
> > >  1 file changed, 10 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/arm/pmu.c b/arm/pmu.c
> > > index a7899c3c..4f2c5096 100644
> > > --- a/arm/pmu.c
> > > +++ b/arm/pmu.c
> > > @@ -581,7 +581,6 @@ static void test_chained_counters(void)
> > >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> > >  
> > >  	report(read_regn_el0(pmevcntr, 1) == 1, "CHAIN counter #1 incremented");
> > > -	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #1");
> > >  
> > >  	/* test 64b overflow */
> > >  
> > > @@ -593,7 +592,7 @@ static void test_chained_counters(void)
> > >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> > >  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> > >  	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
> > > -	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #2");
> > > +	report((read_sysreg(pmovsclr_el0) & 0x2) == 0, "no overflow recorded for chained incr #2");
> > >  
> > >  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > >  	write_regn_el0(pmevcntr, 1, ALL_SET);
> > > @@ -601,7 +600,7 @@ static void test_chained_counters(void)
> > >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> > >  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> > >  	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
> > > -	report(read_sysreg(pmovsclr_el0) == 0x2, "overflow on chain counter");
> > > +	report(read_sysreg(pmovsclr_el0) & 0x2, "overflow on chain counter");
> > >  }
> > >  
> > >  static void test_chained_sw_incr(void)
> > > @@ -626,10 +625,10 @@ static void test_chained_sw_incr(void)
> > >  	for (i = 0; i < 100; i++)
> > >  		write_sysreg(0x1, pmswinc_el0);
> > >  
> > > -	report(!read_sysreg(pmovsclr_el0) && (read_regn_el0(pmevcntr, 1) == 1),
> > > -		"no overflow and chain counter incremented after 100 SW_INCR/CHAIN");
> > > +	report(read_regn_el0(pmevcntr, 1) == 1,
> > > +			"no chain counter incremented after 100 SW_INCR/CHAIN");
> > >  	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
> > > -		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> > > +			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> > >  
> > >  	/* 64b SW_INCR and overflow on CHAIN counter*/
> > >  	pmu_reset();
> > > @@ -644,7 +643,7 @@ static void test_chained_sw_incr(void)
> > >  	for (i = 0; i < 100; i++)
> > >  		write_sysreg(0x1, pmswinc_el0);
> > >  
> > > -	report((read_sysreg(pmovsclr_el0) == 0x2) &&
> > > +	report((read_sysreg(pmovsclr_el0) & 0x2) &&
> > >  		(read_regn_el0(pmevcntr, 1) == 0) &&
> > >  		(read_regn_el0(pmevcntr, 0) == 84),
> > >  		"overflow on chain counter and expected values after 100 SW_INCR/CHAIN");
> > > @@ -727,8 +726,8 @@ static void test_chain_promotion(void)
> > >  	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> > >  		    read_regn_el0(pmevcntr, 0));
> > >  
> > > -	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
> > > -		"CHAIN counter enabled: CHAIN counter was incremented and no overflow");
> > > +	report((read_regn_el0(pmevcntr, 1) == 1),
> > > +		"CHAIN counter enabled: CHAIN counter was incremented");
> > >  
> > >  	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
> > >  		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
> > > @@ -755,8 +754,8 @@ static void test_chain_promotion(void)
> > >  	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> > >  		    read_regn_el0(pmevcntr, 0));
> > >  
> > > -	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
> > > -		"32b->64b: CHAIN counter incremented and no overflow");
> > > +	report((read_regn_el0(pmevcntr, 1) == 1),
> > > +		"32b->64b: CHAIN counter incremented");
> > >  
> > >  	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
> > >  		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
> > 
> > I'm looking at fixing KVM to match this (see the binch of hacks at
> > [1]), and still getting a couple of failures in the PMU overflow tests
> > despite my best effort to fix the code:
> > 
> > $ ./arm-run  arm/pmu.flat --append pmu-overflow-interrupt
> > /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/pmu.flat --append pmu-overflow-interrupt # -initrd /tmp/tmp.RQ6FmkvXay
> > INFO: PMU version: 0x1
> > INFO: PMU implementer/ID code: 0x41("A")/0x3
> > INFO: Implements 6 event counters
> > PASS: pmu: pmu-overflow-interrupt: no overflow interrupt after preset
> > PASS: pmu: pmu-overflow-interrupt: no overflow interrupt after counting
> > INFO: pmu: pmu-overflow-interrupt: overflow=0x0
> > PASS: pmu: pmu-overflow-interrupt: overflow interrupts expected on #0 and #1
> > FAIL: pmu: pmu-overflow-interrupt: no overflow interrupt expected on 32b boundary
> > FAIL: pmu: pmu-overflow-interrupt: expect overflow interrupt on odd counter
> > SUMMARY: 5 tests, 2 unexpected failures
> > 
> > Looking at the kut code, I'm wondering whether you're still missing a
> > couple of extra fixes such as:
> > 
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index 4f2c5096..e0b9f71a 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -861,8 +861,8 @@ static void test_overflow_interrupt(void)
> >  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> >  	isb();
> >  	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> > -	report(expect_interrupts(0),
> > -		"no overflow interrupt expected on 32b boundary");
> > +	report(expect_interrupts(1),
> > +		"expect overflow interrupt on 32b counter");
> >  
> >  	/* overflow on odd counter */
> >  	pmu_reset_stats();
> > @@ -870,8 +870,8 @@ static void test_overflow_interrupt(void)
> >  	write_regn_el0(pmevcntr, 1, ALL_SET);
> >  	isb();
> >  	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
> > -	report(expect_interrupts(0x2),
> > -		"expect overflow interrupt on odd counter");
> > +	report(expect_interrupts(0x3),
> > +		"expect overflow interrupt on even+odd counters");
> >  }
> >  #endif
> >  
> > With that, all PMU tests pass. Am I missing something? Did you notice
> > these failing on HW?
> > 

Actually, yes. But, I wasn't 100% sure. I tried a PMU passthrough
prototype on both real HW and the fast-model, and with
test_overflow_interrupt() I see an interrupt overflow hitting EL2. I
wasn't sure whether I should be forwarding it to the guest.

Thanks,
Ricardo

> > Thanks,
> > 
> > 	M.
> > 
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pmu-chained
> > 
> > -- 
> > Without deviation from the norm, progress is not possible.
> 
> -- 
> Without deviation from the norm, progress is not possible.
