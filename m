Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC1564604C
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 18:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiLGRc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 12:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiLGRc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 12:32:56 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF9C5E9D9
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 09:32:55 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id cm20so18309801pjb.1
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 09:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gSytGWam2RsfZ8LDTXkI5HjY+j/pAQztbn0XEeCsCwU=;
        b=l/guce6zU5tkdP1Fsai1HdMH375B1J1+FAu5avObfFwBew8DKDDWNueXLdA0wcnyRu
         D+GmIizw1V5vReqrgZxwuA9l2gk4ZEc4gKxsm1GOWpsp26T38RliO4hYAOf80uqf544g
         IPhfFnrW7vmozoSMxVZEUlSryLxy0ApW9IBVudYmg85F288FD57ZyHxy0wC1vH14aE7H
         etGnPX09BP2AaxGchWVP6JqEUXpz/8f9FYrfpHtJw3kUNe0+nXt5vPJjPdKhpk/Qc3p9
         nse6plPuR5xzqBXPsmxoSLUIk6B7FzsICHCRaUYXpiqS/l5YsMfSapTzNDjncaCBI040
         ZlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gSytGWam2RsfZ8LDTXkI5HjY+j/pAQztbn0XEeCsCwU=;
        b=A6I0nBim75rgTxfEKLZ2j7SnS803XetQIqAb64IOkvKnN01cxZNcY552b4/B7IiE53
         YKmsJ5D1gE17CRbGEH+1NLg/myRVXcJW6egaUSSTOirWBTlBoiQkd6UBEwREeapYpfYB
         fSOoHGq+JQ4+2Sb9/eSvFXkwk6nxq1Pl/9IAIQ3WVu+cYwEnJcK2wNU2gmJG5QYyw0S2
         uEgSaa0oV2LCDz2bCvUN8+wxSUMquglCVYxDjuzJLptaRHKEntOtOV12o9W7gXl42Yu+
         jpe7CIsyKgcLarF2rDVYepv5xzoihHAQ76RSTbY0+PUtxIuFpA9a2K2jLvjOPlpaSMuJ
         z28A==
X-Gm-Message-State: ANoB5pkJX4HNkN30UYqTLqy3QICZI8YTXalQKoXOh/THMk3lpDNp4NlL
        fhH8XG+26XueXSZoyh7sdbKUpw==
X-Google-Smtp-Source: AA0mqf4YBY5cMi6mJjSx24Uxe6LWKvbJ3oUClYq/wCU+BgOOCsXJMgMFHSm/JA3aK2fI+/4tfLy9wg==
X-Received: by 2002:a05:6a20:9597:b0:a3:49d2:9504 with SMTP id iu23-20020a056a20959700b000a349d29504mr1637716pzb.3.1670434375344;
        Wed, 07 Dec 2022 09:32:55 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t3-20020aa79463000000b00576b0893ecasm7844765pfq.46.2022.12.07.09.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 09:32:54 -0800 (PST)
Date:   Wed, 7 Dec 2022 17:32:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests] x86/pmu: Add Intel Guest Transactional
 (commited) cycles testcase
Message-ID: <Y5DOQ3v2ylWTbGZ7@google.com>
References: <20221207071506.15733-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207071506.15733-1-likexu@tencent.com>
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

On Wed, Dec 07, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> On Intel platforms with TSX feature, pmu users in guest can collect
> the commited or total transactional cycles for a tsx-enabled workload,
> adding new test cases to cover them, as they are not strictly the same
> as normal hardware events from the KVM implementation point of view.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  x86/pmu.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 72 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 72c2c9c..d4c6813 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -20,7 +20,7 @@
>  
>  typedef struct {
>  	uint32_t ctr;
> -	uint32_t config;
> +	uint64_t config;
>  	uint64_t count;
>  	int idx;
>  } pmu_counter_t;
> @@ -547,6 +547,76 @@ static void check_emulated_instr(void)
>  	report_prefix_pop();
>  }
>  
> +#define _XBEGIN_STARTED		(~0u)
> +
> +static inline int

This should be "unsigned int".  EAX can yield a negative value, e.g. via "XABORT
0xff", which is why the compiler instrinsics use this explicit, unsigned value
(that relies on reserved bits in the abort status).

> _xbegin(void)

These having nothing to do with the PMU, i.e. belong in processor.h.

The naming is also non-stanard, i.e. drop the underscore.  I assume you're
trying to match the compiler instrinsics, but that's bound to do more harm than
good.  Either use the instrinsics or write code that aligns with KUT's style.
Using instrinsics is probably a bad idea because eventually we'll want to do
something weird, e.g. provide a bogus fallback address. And having to go lookup
gcc/clang documentation is rather annoything.

> +{
> +	int ret = _XBEGIN_STARTED;

Newline after declarations.

> +	asm volatile(".byte 0xc7,0xf8 ; .long 0" : "+a" (ret) :: "memory");

This is just mean.

	unsigned int ret = XBEGIN_STARTED;
	
	asm volatile("xbegin 1f\n\t"
		     "1:\n\t"
		     : "+a" (ret) :: "memory");
	return ret;

> +	return ret;
> +}
> +
> +static inline void _xend(void)
> +{
> +	asm volatile(".byte 0x0f,0x01,0xd5" ::: "memory");

Like XBEGIN, use the mnemonic.

> +}
> +
> +int *ptr;

I'm honestly at a loss for words.

> +static void tsx_fault(void)

s/fault/abort.  Yes, a fault causes an abort, but no fault is ever observed by
software.  Though I don't quite understand why helpers are needed in the first
place.

> +{
> +	int value = 0;
> +
> +	ptr = NULL;
> +	if(_xbegin() == _XBEGIN_STARTED) {

Space after the "if".

> +		value++;
> +		// causes abort
> +		*ptr = value;

		/* Generate a non-canonical #GP to trigger ABORT. */
		(int *)NONCANONICAL) = 0;

> +		_xend();

Why bother with XEND?

> +	}
> +}
> +
> +static void tsx_normal(void)
> +{
> +	int value = 0;
> +
> +	if(_xbegin() == _XBEGIN_STARTED) {
> +		value++;

What's the purpose of incrementing an arbitrary value?

> +		_xend();

Does this test rely on the region being successfully committed?  If so, the test
is guaranteed to be flaky, e.g. due to a host IRQ at the "wrong" time.  Assuming
success is not required, please add a comment describing the requirements.

> +	}
> +}
> +
> +static void check_tsx_cycles(void)
> +{
> +	pmu_counter_t cnt;
> +	int i;
> +
> +	if (!this_cpu_has(X86_FEATURE_RTM) || !this_cpu_has(X86_FEATURE_HLE))
> +		return;
> +
> +	report_prefix_push("TSX cycles");
> +
> +	for (i = 0; i < pmu.nr_gp_counters; i++) {
> +		cnt.ctr = MSR_GP_COUNTERx(i);
> +
> +		if (i == 2)
> +			/* Transactional cycles commited only on gp counter 2 */
> +			cnt.config = EVNTSEL_OS | EVNTSEL_USR | 0x30000003c;
> +		else
> +			/* Transactional cycles */
> +			cnt.config = EVNTSEL_OS | EVNTSEL_USR | 0x10000003c;
> +
> +		start_event(&cnt);
> +		tsx_fault();
> +		tsx_normal();

As a above, why bother with helpers?  Can't this just be:


		start_event(&cnt);

		/* Generate a non-canonical #GP to trigger ABORT. */
		if (xbegin() == XBEGIN_STARTED)
			*(int *)NONCANONICAL = 0;

		/* <comment about what requirements of this code> */
		if (xbegin() == XBEGIN_STARTED)
			xend();

		stop_event(&cnt);

> +		stop_event(&cnt);
> +
> +		report(cnt.count > 0, "gp cntr-%d", i);
> +	}
> +
> +	report_prefix_pop();
> +}
> +
>  static void check_counters(void)
>  {
>  	if (is_fep_available())
> @@ -559,6 +629,7 @@ static void check_counters(void)
>  	check_counter_overflow();
>  	check_gp_counter_cmask();
>  	check_running_counter_wrmsr();
> +	check_tsx_cycles();
>  }
>  
>  static void do_unsupported_width_counter_write(void *index)
> -- 
> 2.38.1
> 
