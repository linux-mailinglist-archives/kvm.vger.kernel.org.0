Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07CB1589F7F
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 18:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbiHDQoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 12:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiHDQov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 12:44:51 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0969739BBF
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 09:44:51 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y141so9835pfb.7
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 09:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=8IFc52prVDcAlJdw+nIMcnuB+1ViDT4c5tES66xsqnE=;
        b=eVAc19gZ5LTq1rarwRrtxPeswXS+8uoVhmlFcLQ8SBQa6eKqCRor/BPX/8reHAWgKf
         gI+1vWfH//mHgV8C4xjzhvZgQ6HjL7jyzCcqyilDz9Z3PZlpvaHSt1rMAZNsphcNo8/I
         1PJVxan85PinDaEaD3ZHG6pQcEH8P5N7m8DGrcZN6vyHNMFKkRHpr4OH3gkcoxBB71Sm
         abVq6N24Y8EnBX2QxZgnbdZoiWLKxC1g6Kxem151vVSdyUWqX5tsW2tCRINFq/8Tp3Cm
         PlnEAJ2Y4O2IYhyv/zWpDNrnlFrTmvgEiMtOXhoOuGIBY0FrteXhNpOFrt6Qe6M+M0uf
         YMSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=8IFc52prVDcAlJdw+nIMcnuB+1ViDT4c5tES66xsqnE=;
        b=XoCDizR7Sso91IlMQP/xQhKyaLC/BwJkHp/pT0vJwkVWAbVtbPIYZr46crHB2yPmTk
         0XbJhHLSXXInYpoY5usSo0fZckaWHXIhp7sKwEUKuPfKS15shCjY/Cx+IJBq0oBuSsqj
         LPJeSKwL1ogEtXg7i6s+iHshESUfCzO2vHPXo4vKoqGS8JKcHlIQGYgu/S7rSspe60B0
         X8koSceURhrmrUfloy9UReHRAkVIajy/7wRP9Io1IEDNlDw9O0YMNnUXJH70xMFFxPmt
         NCyMmFnlF3L1POvg2RnlMma3HKheEzmi/E5KLQkvCcGQ6rTvMFKAFoPVmIe4252eA13Q
         EFbA==
X-Gm-Message-State: ACgBeo0pV1wNmcsS6l9xbkMsRFjHnPSSUBr6iq7S/laN4N8T+aw50xy/
        m4jbcChVwneSRVWnwnym/ZmLBA==
X-Google-Smtp-Source: AA6agR4twfOOCu2K6fuXXekVpHzjWCwJa8j+/vAEvnnppQVG8x2zb8trIu1V4azGZoOUnqI9tH7QvQ==
X-Received: by 2002:a65:6d97:0:b0:41c:1e06:3ba4 with SMTP id bc23-20020a656d97000000b0041c1e063ba4mr2281445pgb.282.1659631490291;
        Thu, 04 Aug 2022 09:44:50 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g23-20020a63f417000000b0041983a8d8c2sm117132pgi.39.2022.08.04.09.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 09:44:49 -0700 (PDT)
Date:   Thu, 4 Aug 2022 16:44:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v3 3/5] selftests: kvm/x86: Add testing for masked events
Message-ID: <Yuv3fgk0ElbAfyJR@google.com>
References: <20220709010250.1001326-4-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220709010250.1001326-4-aaronlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 09, 2022, Aaron Lewis wrote:
> Add testing for the pmu event filter's masked events.  These tests run
> through different ways of finding an event the guest is attempting to
> program in an event list.  For any given eventsel, there may be
> multiple instances of it in an event list.  These tests try different
> ways of looking up a match to force the matching algorithm to walk the
> relevant eventsel's and ensure it is able to a) find a match, b) stays
> within its bounds.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  .../kvm/x86_64/pmu_event_filter_test.c        | 99 +++++++++++++++++++
>  1 file changed, 99 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index 4bff4c71ac45..29abe9c88f4f 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -18,8 +18,12 @@
>  /*
>   * In lieu of copying perf_event.h into tools...
>   */
> +#define ARCH_PERFMON_EVENTSEL_EVENT			0x000000FFULL
>  #define ARCH_PERFMON_EVENTSEL_OS			(1ULL << 17)
>  #define ARCH_PERFMON_EVENTSEL_ENABLE			(1ULL << 22)
> +#define AMD64_EVENTSEL_EVENT	\
> +	(ARCH_PERFMON_EVENTSEL_EVENT | (0x0FULL << 32))
> +
>  
>  union cpuid10_eax {
>  	struct {
> @@ -445,6 +449,99 @@ static bool use_amd_pmu(void)
>  		 is_zen3(entry->eax));
>  }
>  
> +#define ENCODE_MASKED_EVENT(select, mask, match, invert) \
> +		KVM_PMU_EVENT_ENCODE_MASKED_EVENT(select, mask, match, invert)

Eww.  Use a helper.  Defining a passthrough macro just to get a shorter name is
silly, AFAICT all usages passes ~0ull / ~0x00 for the mask, and so that the test
can do it's own type checking, e.g. @invert can/should be a boolean.

> +
> +static void expect_success(uint64_t count)
> +{
> +	if (count != NUM_BRANCHES)
> +		pr_info("masked filter: Branch instructions retired = %lu (expected %u)\n",
> +			count, NUM_BRANCHES);

If the number of branches is expected to be precise, then assert on that.  If not,
then I don't see much value in printing anything.

> +	TEST_ASSERT(count, "Allowed PMU event is not counting");
> +}
> +
> +static void expect_failure(uint64_t count)
> +{
> +	if (count)
> +		pr_info("masked filter: Branch instructions retired = %lu (expected 0)\n",
> +			count);
> +	TEST_ASSERT(!count, "Disallowed PMU Event is counting");

Print the debug information in the assert.

> +}
> +
> +static void run_masked_events_test(struct kvm_vm *vm, uint64_t masked_events[],
> +				   const int nmasked_events, uint64_t event,
> +				   uint32_t action,
> +				   void (*expected_func)(uint64_t))

A function callback is overkill and unnecessary obfuscation.  And "expect_failure"
is misleading; the test isn't expected to "fail", rather the event is expected to
not count.

Actually, the function is completely unnecessary, the caller already passed in
ALLOW vs. DENY in action.

> +{
> +	struct kvm_pmu_event_filter *f;
> +	uint64_t old_event;
> +	uint64_t count;
> +	int i;
> +
> +	for (i = 0; i < nmasked_events; i++) {
> +		if ((masked_events[i] & AMD64_EVENTSEL_EVENT) != EVENT(event, 0))
> +			continue;
> +
> +		old_event = masked_events[i];
> +
> +		masked_events[i] =
> +			ENCODE_MASKED_EVENT(event, ~0x00, 0x00, 0);

Why double zeros?  And this easily fits on a single line.

		masked_events[i] = ENCODE_MASKED_EVENT(event, ~0ull, 0, 0);

> +
> +		f = create_pmu_event_filter(masked_events, nmasked_events, action,
> +				   KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
> +
> +		count = test_with_filter(vm, f);
> +		free(f);
> +

As alluded to above...

		if (action == KVM_PMU_EVENT_ALLOW)
			TEST_ASSERT(count, <here be verbose, helpful output>);
		else
			TEST_ASSERT(!count, <more verbose, helpful output>);

> +		expected_func(count);
> +
> +		masked_events[i] = old_event;
> +	}
> +}
> +
> +static void run_masked_events_tests(struct kvm_vm *vm, uint64_t masked_events[],
> +				    const int nmasked_events, uint64_t event)
> +{
> +	run_masked_events_test(vm, masked_events, nmasked_events, event,
> +			       KVM_PMU_EVENT_ALLOW, expect_success);
> +	run_masked_events_test(vm, masked_events, nmasked_events, event,
> +			       KVM_PMU_EVENT_DENY, expect_failure);
> +}
> +
> +static void test_masked_events(struct kvm_vm *vm)
> +{
> +	uint64_t masked_events[11];

Why '11'?

> +	const int nmasked_events = ARRAY_SIZE(masked_events);
> +	uint64_t prev_event, event, next_event;
> +	int i;
> +
> +	if (use_intel_pmu()) {
> +		/* Instructions retired */
> +		prev_event = 0xc0;
> +		event = INTEL_BR_RETIRED;
> +		/* Branch misses retired */
> +		next_event = 0xc5;
> +	} else {
> +		TEST_ASSERT(use_amd_pmu(), "Unknown platform");
> +		/* Retired instructions */
> +		prev_event = 0xc0;
> +		event = AMD_ZEN_BR_RETIRED;
> +		/* Retired branch instructions mispredicted */
> +		next_event = 0xc3;
> +	}
> +
> +	for (i = 0; i < nmasked_events; i++)
> +		masked_events[i] =
> +			ENCODE_MASKED_EVENT(event, ~0x00, i+1, 0);
> +
> +	run_masked_events_tests(vm, masked_events, nmasked_events, event);
> +

Why run the test twice?  Hint, comment... ;-)

> +	masked_events[0] = ENCODE_MASKED_EVENT(prev_event, ~0x00, 0, 0);
> +	masked_events[1] = ENCODE_MASKED_EVENT(next_event, ~0x00, 0, 0);
> +
> +	run_masked_events_tests(vm, masked_events, nmasked_events, event);
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	void (*guest_code)(void) = NULL;
> @@ -489,6 +586,8 @@ int main(int argc, char *argv[])
>  	test_not_member_deny_list(vm);
>  	test_not_member_allow_list(vm);
>  
> +	test_masked_events(vm);
> +
>  	kvm_vm_free(vm);
>  
>  	test_pmu_config_disable(guest_code);
> -- 
> 2.37.0.144.g8ac04bfd2-goog
> 
