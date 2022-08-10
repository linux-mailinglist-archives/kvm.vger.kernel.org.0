Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1395058F281
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 20:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiHJSqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 14:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiHJSq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 14:46:29 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C90F832F0
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 11:46:29 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id p18so14992769plr.8
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 11:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=w7tKdaFpkXOHqmzRmN3TS17bbMv5aY9ZVRa8viTMmRA=;
        b=mryMQKfp8NuK+lcMB/v4C/eZQvysrNsacXRGGU+ns1YlKLYZ4an1sak74CP/9uOQwj
         vmTcazpGmj0QSeEzqJhEMQVGuQEY4cRda9cnUkwjM2oTVfhDrEZ1zauUSDY729M/zK3M
         8V441nXBXcjEh3O3pgwmUOIaj7407tX8vatsx0kc1be4BjvdwVliuYvLxN8cVFLxzS09
         uwj4XXDR3c3DAaI1nZYnE2FeAV8KXK0Dc5w5a+wmkq0lH2/bDu8gx8nwPTQghoSTx5qj
         lDx10dGGr6P0NGcyC3JXUEoEB7QTime/O3F3q+NKlIu4W/FiWEkKW3cmFhhiYiuvGX4q
         TW6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=w7tKdaFpkXOHqmzRmN3TS17bbMv5aY9ZVRa8viTMmRA=;
        b=R65+wub4Ag0uqS4AZtIYu6uW1yX3qPx0rtdUCuIVIDUwXX7Sc1U8BzxLA7MMxu10df
         HciIOohSzEgjlBOG9uBiSL8keEH3WUlGx5CWPuTA5EIJNNMAHmlImVO6jP48c8bw6ol0
         Gbfg5SoU9fioarrJMIk/1Q/lPobCvKjoSiHJXybKPNas/f/SgEECf0GcOjFPBlUYyI8J
         a5qD5xAh4J6i8uIpKFlAldXfOUX6jzneR4FWONylmjmD7qj/8iHylandKbjRG0sdPvIJ
         tNjVoIQv3CPJUGzpix6K+R0zcAMWhlfRm+kzl3bbZYK8zYnmNy9AZq7mzi1JSlRmKIuG
         kl7w==
X-Gm-Message-State: ACgBeo1GLX9TRZOz6XJV2nR+ZAy394STUgxKUfrMpcOu0PmJUY5XzBip
        PeF8CzwZZD8S2y4QSSeNIp4lGA==
X-Google-Smtp-Source: AA6agR5YxgHA27P0ktUotSKJbRJ8qV0IwK9/mACrXmCnkz/YNaR7XQoDc+CBbP8mCvVE8aYBRlYVHA==
X-Received: by 2002:a17:903:1cd:b0:171:3543:6b13 with SMTP id e13-20020a17090301cd00b0017135436b13mr4703078plh.96.1660157188397;
        Wed, 10 Aug 2022 11:46:28 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id w18-20020a1709027b9200b0016dbb878f8asm13157232pll.82.2022.08.10.11.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 11:46:27 -0700 (PDT)
Date:   Wed, 10 Aug 2022 11:46:22 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>, kernel-team@android.com
Subject: Re: [PATCH 0/9] KVM: arm64: PMU: Fixing chained events, and PMUv3p5
 support
Message-ID: <YvP8/m9uDI2PcyoP@google.com>
References: <20220805135813.2102034-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805135813.2102034-1-maz@kernel.org>
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

On Fri, Aug 05, 2022 at 02:58:04PM +0100, Marc Zyngier wrote:
> Ricardo recently reported[1] that our PMU emulation was busted when it
> comes to chained events, as we cannot expose the overflow on a 32bit
> boundary (which the architecture requires).
> 
> This series aims at fixing this (by deleting a lot of code), and as a
> bonus adds support for PMUv3p5, as this requires us to fix a few more
> things.
> 
> Tested on A53 (PMUv3) and FVP (PMUv3p5).
> 
> [1] https://lore.kernel.org/r/20220805004139.990531-1-ricarkol@google.com
> 
> Marc Zyngier (9):
>   KVM: arm64: PMU: Align chained counter implementation with
>     architecture pseudocode
>   KVM: arm64: PMU: Distinguish between 64bit counter and 64bit overflow
>   KVM: arm64: PMU: Only narrow counters that are not 64bit wide
>   KVM: arm64: PMU: Add counter_index_to_*reg() helpers
>   KVM: arm64: PMU: Simplify setting a counter to a specific value
>   KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver limit to VM creation
>   KVM: arm64: PMU: Aleven ID_AA64DFR0_EL1.PMUver to be set from userspace
>   KVM: arm64: PMU: Implement PMUv3p5 long counter support
>   KVM: arm64: PMU: Aleven PMUv3p5 to be exposed to the guest
> 
>  arch/arm64/include/asm/kvm_host.h |   1 +
>  arch/arm64/kvm/arm.c              |   6 +
>  arch/arm64/kvm/pmu-emul.c         | 372 ++++++++++--------------------
>  arch/arm64/kvm/sys_regs.c         |  65 +++++-
>  include/kvm/arm_pmu.h             |  16 +-
>  5 files changed, 208 insertions(+), 252 deletions(-)
> 
> -- 
> 2.34.1
> 

Hi Marc,

There is one extra potential issue with exposing PMUv3p5. I see this
weird behavior when doing passthrough ("bare metal") on the fast-model
configured to emulate PMUv3p5: the [63:32] half of the counters
overflowing at 32-bits is still incremented.

  Fast model - ARMv8.5:
   
	Assuming the initial state is even=0xFFFFFFFF and odd=0x0,
	incrementing the even counter leads to:

	0x00000001_00000000	0x00000000_00000001		0x1
	even counter		odd counter			PMOVSET

	Assuming the initial state is even=0xFFFFFFFF and odd=0xFFFFFFFF,
	incrementing the even counter leads to:

	0x00000001_00000000	0x00000001_00000000		0x3
	even counter		odd counter			PMOVSET

More specifically, the pmu-chained-sw-incr kvm-unit-test fails when
doing passthrough of PMUv3p5 (fast model - ARMv8.5):

  INFO: PMU version: 0x5
  INFO: PMU implementer/ID code: 0x41("A")/0
  INFO: Implements 8 event counters
  PASS: pmu: pmu-chained-sw-incr: overflow and chain counter incremented after 100 SW_INCR/CHAIN
  INFO: pmu: pmu-chained-sw-incr: overflow=0x1, #0=4294967380 #1=1
                                                ^^^^^^^^^^^^^
                                                #0=0x00000001_00000054
                                                #1=0x00000000_00000001
  FAIL: pmu: pmu-chained-sw-incr: expected overflows and values after 100 SW_INCR/CHAIN
  INFO: pmu: pmu-chained-sw-incr: overflow=0x3, #0=4294967380 #1=4294967296
                                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^
                                                  #0=0x00000001_00000054
                                                  #1=0x00000001_00000000

There's really no good use for this behavior, and not sure if it's worth
emulating it. Can't find any reference in the ARM ARM.

Thanks,
Ricardo
