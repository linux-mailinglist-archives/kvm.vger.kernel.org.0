Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A841F663189
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 21:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237085AbjAIUcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 15:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236966AbjAIUcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 15:32:20 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CE36086B
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 12:32:20 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso14037259pjp.4
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 12:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ube/z5cXNqkiqqrDlf/LShptZ1QKnuxu0cgh5aXiZh0=;
        b=PuDz0+Ve3hAAtAbJQI9L/EWmNfBGAO5kPyPZMs0n6VOgFAlR4JIy1+NmfJdN0JDOlH
         Rx0qpUZZrik0Ex44YNtX6+7vgWmfW23LdXg0mvITSs7o4HvwTxGy6WwH+SwQT2H4jhZc
         tA8mEUSOZgbBfODI9DA3kd7J3JInvPtkprIuqmek3LFP0saWyeFxrUfrkb/jQNxViMsA
         UEoaR95GH/l6H2R3BpmgvTNS3CHsmB5dSq0hXVc66UnlpyqzPSdRfy7ErtDSCUubBKg3
         vqQodFb9OZgagaa1VKs9R0XGalpuihejGDOr8AwIW2sxWmbPKVtdxQLXleB+MqwEsItB
         sc3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ube/z5cXNqkiqqrDlf/LShptZ1QKnuxu0cgh5aXiZh0=;
        b=5s8wXHK34bnDtgMH/IyBdu3Wx3kH4E4yeuJaGH8D+2vpHgW+xqKlFYa+eYx0pOcd9V
         dg50kpVIj/5OnV1WRXoNA7aXhsbJfSDRn7C2lVlo9nTMQ4I+H+xhePxhNBD0W5wdsNLC
         Orhuwjuv0fsI6De8VCCBUkpWylv9c52hfc5UK0totmKQo5+5B3zUsH/00OXL3rXn18I6
         vqxwbEvhbkNqNBjiA25zkFs2TloA/1WVOoqrtr2G7Q85565u529CIGsirA0Lw1Sni8fF
         2PfMqnPxMKeSNYkYDVXJ2hCPFlw1ta0V3K5mdw8WWO08A7ACo+9LuDLXuX57HVJoa2tm
         PbcQ==
X-Gm-Message-State: AFqh2kofg3S/pIHJrHzBlAQaQ5WBG+vG7HpZ/X7ikhOaShFocvDrryK6
        Wfutj966jRryqu7zEvvw2X3NTA==
X-Google-Smtp-Source: AMrXdXtx708ZuyoaqXftL7Du2TKzGccrtgR+321QfAl0eTFpDQabw3aYTnRM+u399/rbHhFX19kEdQ==
X-Received: by 2002:a17:903:40cd:b0:193:256d:8afe with SMTP id t13-20020a17090340cd00b00193256d8afemr549776pld.2.1673296339433;
        Mon, 09 Jan 2023 12:32:19 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id q8-20020a170902a3c800b0017f74cab9eesm1903448plb.128.2023.01.09.12.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 12:32:19 -0800 (PST)
Date:   Mon, 9 Jan 2023 12:32:15 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] arm: pmu: Fix overflow checks for
 PMUv3p5 long counters
Message-ID: <Y7x5zyMIlNvDoPiT@google.com>
References: <20221220031032.2648701-1-ricarkol@google.com>
 <20221220031032.2648701-2-ricarkol@google.com>
 <Y7h2eQp5oFd/DN7A@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7h2eQp5oFd/DN7A@google.com>
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

On Fri, Jan 06, 2023 at 07:28:57PM +0000, Oliver Upton wrote:
> Hi Ricardo,
> 
> On Tue, Dec 20, 2022 at 03:10:29AM +0000, Ricardo Koller wrote:
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
> >  arm/pmu.c | 37 +++++++++++++++++++++++++------------
> >  1 file changed, 25 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index cd47b14..1b55e20 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -54,10 +54,13 @@
> >  #define EXT_COMMON_EVENTS_LOW	0x4000
> >  #define EXT_COMMON_EVENTS_HIGH	0x403F
> >  
> > -#define ALL_SET			0xFFFFFFFF
> > -#define ALL_CLEAR		0x0
> > -#define PRE_OVERFLOW		0xFFFFFFF0
> > -#define PRE_OVERFLOW2		0xFFFFFFDC
> > +#define ALL_SET			0x00000000FFFFFFFFULL
> > +#define ALL_SET_64		0xFFFFFFFFFFFFFFFFULL
> > +#define ALL_CLEAR		0x0000000000000000ULL
> > +#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
> > +#define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
> > +
> > +#define ALL_SET_AT(_64b)       (_64b ? ALL_SET_64 : ALL_SET)
> 
> AFAICT, ALL_SET is mostly used to toggle all PMCs in a configuration
> register. Using it for PMEVCNTR<n> seems a bit odd to me. How about
> introducing a helper for getting the counter mask to avoid the
> open-coded version check?
> 
> static uint64_t pmevcntr_mask(void)
> {
> 	/*
> 	 * Bits [63:0] are always incremented for 64-bit counters,
> 	 * even if the PMU is configured to generate an overflow at
> 	 * bits [31:0]
> 	 *
> 	 * See DDI0487I.a, section D11.3 ("Behavior on overflow") for
> 	 * more details.
> 	 */
> 	if (pmu.version >= ID_DFR0_PMU_V3_8_5)
> 		return ~0;
> 
> 	return (uint32_t)~0;
> }
> 
> I've always found the PMU documentation to be a bit difficult to grok,
> and the above citation only mentions the intended behavior in passing.
> Please feel free to update with a better citation if it exists.

For this particular case, "Bits [63:0] are always incremented for 64-bit
counters", I find AArch64.IncrementEventCounter() a bit easier.

> 
> >  #define PMU_PPI			23
> >  
> > @@ -538,6 +541,7 @@ static void test_mem_access(void)
> >  static void test_sw_incr(void)
> >  {
> >  	uint32_t events[] = {SW_INCR, SW_INCR};
> > +	uint64_t cntr0;
> >  	int i;
> >  
> >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > @@ -572,9 +576,11 @@ static void test_sw_incr(void)
> >  		write_sysreg(0x3, pmswinc_el0);
> >  
> >  	isb();
> > -	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
> > -	report(read_regn_el0(pmevcntr, 1)  == 100,
> > -		"counter #0 after + 100 SW_INCR");
> > +	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ?
> > +		(uint32_t)PRE_OVERFLOW + 100 :
> > +		(uint64_t)PRE_OVERFLOW + 100;
> 
> With the above suggestion, it would be nice to rewrite like so:
> 
> 	cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> 
> If you do go this route, then you'll probably want to drop all the other
> open-coded PMUv3p5 checks in favor of the helper.
> 
> --
> Thanks,
> Oliver
