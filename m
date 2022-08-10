Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30F758F3FF
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 23:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbiHJVzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 17:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbiHJVzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 17:55:19 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B3D6FA0B
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 14:55:18 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id s199so13483627oie.3
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 14:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=BzsgySgNos3OORO2ZeHRW1YfFHHmZorYT7Lbyu8z2o4=;
        b=Sq7mo/xV3CVU0BM3n8CRWTNGJwjq5SZx24STkgihs8lBjzxfLLM5tXwvfoGBaafeUe
         H4fLOnEM3sMevG7Jk3Nv/DdkG7XPXn/NM1UJZN6Re467UyU8ojDwCVxZOLmdrKxv5dqj
         ckuPPcGtG9qECwxQcW6yUp8mmncBryBF8Q/zf35KEPNTg6UiSJvemc3t3xmc22IVJxl6
         c3+/w2sFpEHcN+FE5F3mWqaaKiDOylfkBYCXM1wKWq/V88URh2RozkKTSGwpDYIMC0s3
         t2Tm0GbMnRXssWRJq5VY6zWBPx/yxgEy7PI8HvcTFFonlRHz0LGxdBtnN3pzhKpupe3z
         gl/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=BzsgySgNos3OORO2ZeHRW1YfFHHmZorYT7Lbyu8z2o4=;
        b=yMpZJ0k2oR1JVFoIwmyZLAeqgKzkdKpxB0LI7eTJx7RcLMOypJE2KNy+YY1cTiX82g
         If/ut3Skih19TNgh3qFJhjQXBsbFtaUQWNJDPU+HgZL1tdGRY10SWeh1oDE/6QtveOzV
         gA7b2PO8u6OKj30oqfqdeA/i9Z0YVMH25396La6Rd+J+scU2gh4M4FOHYFsQV0NpWZpx
         2D9dots0LDUVx1GsB24/VSYIuW6L8Q9NV9PnMFCqC5A6gai+qdgETV6KGExyIpbO0Ugd
         LO95axbBWt2heP99v+IujLJ+4E4FmDd9jIorj23daigb10UrRIQwjgNoxmD+X4NqASUa
         KTSA==
X-Gm-Message-State: ACgBeo2gC4jYxrl0SfFf4eJ5F9WeWb51fWv5a9mxmS5Ts3osmXzkiM6x
        qnZjxlGRi9VxTAij6crbugcvn2MimNDzYw==
X-Google-Smtp-Source: AA6agR4BwNvdqbySv2xBzGTGwFVENV9mkrbnUGpS+DzuFxdVuwqt2mi7PKg8B6+uYkf9cRTOg0crwg==
X-Received: by 2002:a17:90a:e7cc:b0:1f7:26c9:ee9f with SMTP id kb12-20020a17090ae7cc00b001f726c9ee9fmr5613200pjb.75.1660168507148;
        Wed, 10 Aug 2022 14:55:07 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id w16-20020a1709026f1000b001712c008f99sm3309460plk.11.2022.08.10.14.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 14:55:06 -0700 (PDT)
Date:   Wed, 10 Aug 2022 14:55:03 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 0/9] KVM: arm64: PMU: Fixing chained events, and PMUv3p5
 support
Message-ID: <YvQpN3SYePyTw13z@google.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <YvP8/m9uDI2PcyoP@google.com>
 <YvQIIWnUkCGl9Ltp@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YvQIIWnUkCGl9Ltp@google.com>
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

On Wed, Aug 10, 2022 at 02:33:53PM -0500, Oliver Upton wrote:
> Hi Ricardo,
> 
> On Wed, Aug 10, 2022 at 11:46:22AM -0700, Ricardo Koller wrote:
> > On Fri, Aug 05, 2022 at 02:58:04PM +0100, Marc Zyngier wrote:
> > > Ricardo recently reported[1] that our PMU emulation was busted when it
> > > comes to chained events, as we cannot expose the overflow on a 32bit
> > > boundary (which the architecture requires).
> > > 
> > > This series aims at fixing this (by deleting a lot of code), and as a
> > > bonus adds support for PMUv3p5, as this requires us to fix a few more
> > > things.
> > > 
> > > Tested on A53 (PMUv3) and FVP (PMUv3p5).
> > > 
> > > [1] https://lore.kernel.org/r/20220805004139.990531-1-ricarkol@google.com
> > > 
> > > Marc Zyngier (9):
> > >   KVM: arm64: PMU: Align chained counter implementation with
> > >     architecture pseudocode
> > >   KVM: arm64: PMU: Distinguish between 64bit counter and 64bit overflow
> > >   KVM: arm64: PMU: Only narrow counters that are not 64bit wide
> > >   KVM: arm64: PMU: Add counter_index_to_*reg() helpers
> > >   KVM: arm64: PMU: Simplify setting a counter to a specific value
> > >   KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver limit to VM creation
> > >   KVM: arm64: PMU: Aleven ID_AA64DFR0_EL1.PMUver to be set from userspace
> > >   KVM: arm64: PMU: Implement PMUv3p5 long counter support
> > >   KVM: arm64: PMU: Aleven PMUv3p5 to be exposed to the guest
> > > 
> > >  arch/arm64/include/asm/kvm_host.h |   1 +
> > >  arch/arm64/kvm/arm.c              |   6 +
> > >  arch/arm64/kvm/pmu-emul.c         | 372 ++++++++++--------------------
> > >  arch/arm64/kvm/sys_regs.c         |  65 +++++-
> > >  include/kvm/arm_pmu.h             |  16 +-
> > >  5 files changed, 208 insertions(+), 252 deletions(-)
> > > 
> > > -- 
> > > 2.34.1
> > > 
> > 
> > Hi Marc,
> > 
> > There is one extra potential issue with exposing PMUv3p5. I see this
> > weird behavior when doing passthrough ("bare metal") on the fast-model
> > configured to emulate PMUv3p5: the [63:32] half of the counters
> > overflowing at 32-bits is still incremented.
> > 
> >   Fast model - ARMv8.5:
> >    
> > 	Assuming the initial state is even=0xFFFFFFFF and odd=0x0,
> > 	incrementing the even counter leads to:
> > 
> > 	0x00000001_00000000	0x00000000_00000001		0x1
> > 	even counter		odd counter			PMOVSET
> > 
> > 	Assuming the initial state is even=0xFFFFFFFF and odd=0xFFFFFFFF,
> > 	incrementing the even counter leads to:
> > 
> > 	0x00000001_00000000	0x00000001_00000000		0x3
> > 	even counter		odd counter			PMOVSET
> 
> This is to be expected, actually. PMUv8p5 counters are always 64 bit,
> regardless of the configured overflow.
> 
> DDI 0487H D8.3 Behavior on overflow
> 
>   If FEAT_PMUv3p5 is implemented, 64-bit event counters are implemented,
>   HDCR.HPMN is not 0, and either n is in the range [0 .. (HDCR.HPMN-1)]
>   or EL2 is not implemented, then event counter overflow is configured
>   by PMCR.LP:
> 
>   — When PMCR.LP is set to 0, if incrementing PMEVCNTR<n> causes an unsigned
>     overflow of bits [31:0] of the event counter, the PE sets PMOVSCLR[n] to 1.
>   — When PMCR.LP is set to 1, if incrementing PMEVCNTR<n> causes an unsigned
>     overflow of bits [63:0] of the event counter, the PE sets PMOVSCLR[n] to 1.
> 
>   [...]
> 
>   For all 64-bit counters, incrementing the counter is the same whether an
>   unsigned overflow occurs at [31:0] or [63:0]. If the counter increments
>   for an event, bits [63:0] are always incremented.
> 
> Do you see this same (expected) failure w/ Marc's series?

I don't know, I'm hitting another bug it seems.

Just realized that KVM does not offer PMUv3p5 (with this series applied)
when the real hardware is only Armv8.2 (the setup I originally tried).
So, tried these other two setups on the fast model:

has_arm_v8-5=1

	# ./lkvm-static run --nodefaults --pmu pmu.flat -p pmu-chained-sw-incr
	# lkvm run -k pmu.flat -m 704 -c 8 --name guest-135

	INFO: PMU version: 0x6
                           ^^^
                           PMUv3 for Armv8.5
	INFO: PMU implementer/ID code: 0x41("A")/0
	INFO: Implements 8 event counters
	FAIL: pmu: pmu-chained-sw-incr: overflow and chain counter incremented after 100 SW_INCR/CHAIN
	INFO: pmu: pmu-chained-sw-incr: overflow=0x0, #0=4294967380 #1=0
                                                 ^^^
                                                 no overflows
	FAIL: pmu: pmu-chained-sw-incr: expected overflows and values after 100 SW_INCR/CHAIN
	INFO: pmu: pmu-chained-sw-incr: overflow=0x0, #0=84 #1=-1
	INFO: pmu: pmu-chained-sw-incr: overflow=0x0, #0=4294967380 #1=4294967295
	SUMMARY: 2 tests, 2 unexpected failures

has_arm_v8-2=1

	# ./lkvm-static run --nodefaults --pmu pmu.flat -p pmu-chained-sw-incr
	# lkvm run -k pmu.flat -m 704 -c 8 --name guest-134

	INFO: PMU version: 0x4
                           ^^^
                           PMUv3 for Armv8.1
	INFO: PMU implementer/ID code: 0x41("A")/0
	INFO: Implements 8 event counters
	PASS: pmu: pmu-chained-sw-incr: overflow and chain counter incremented after 100 SW_INCR/CHAIN
	INFO: pmu: pmu-chained-sw-incr: overflow=0x1, #0=84 #1=1
	PASS: pmu: pmu-chained-sw-incr: expected overflows and values after 100 SW_INCR/CHAIN
	INFO: pmu: pmu-chained-sw-incr: overflow=0x3, #0=84 #1=0
	SUMMARY: 2 tests

The Armv8.2 case is working as expected, but the Armv8.5 one is not.

> 
> --
> Thanks,
> Oliver
