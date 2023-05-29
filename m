Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B2B714BFA
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 16:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjE2OZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 10:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjE2OZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 10:25:32 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8262AD;
        Mon, 29 May 2023 07:25:30 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-64d3fdcadb8so2461600b3a.3;
        Mon, 29 May 2023 07:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685370330; x=1687962330;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s0kZQZAOomcqcKQth80IQ2fTscM5DRIxEg+3sdENsiE=;
        b=e93XWhspHajsDP99VtcVBxnHLpNTihKtNP6VemWTRLPPkLcjCWVFY9odExQlAhCiCG
         zSVF0MDpCXyBpEG3GeTfkXREHnUKK9AptViuZJCic141yVDr5J99j95Faic7+ZwZipl2
         Aq5kdcUnaz43BsmnPz5MS00ieyMu+go6whMkh7pSNuFkB7hwezxmLq2ZLGGdpX4xhV28
         7gdJjI+rf23dKSp+rYYehqxdyFTtomgRNSiN0GXhq92qJ+WHt+iiZRb39qwXLnJWuNAW
         Rb0XxjrYEHfckNjiUjogGTGNfSryn5gJIYoDro//27rUNj1DGQy9eniSty1GGA0Ft4mY
         YcWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685370330; x=1687962330;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s0kZQZAOomcqcKQth80IQ2fTscM5DRIxEg+3sdENsiE=;
        b=YLw9Ukhczf9krpVO7TfqwWm53WDo3+kJinmZEser7/bj+3NHGlf3YXx/oWIRjU838Q
         wKAl1VP1IjdjNadpnkHU4Vj0pfETsgpRk/Q7kAeOodiiNkhyyAQNUjSSDhIyuZDvY1TL
         PoT4MncRINadHy9GW+be80Fu4JF8L9TGl2kqW1o6QI9YRz8nIm85P/heAYBVKjWEkGdf
         Tb+Zz5mb/TZAmr3qYVBJmTyJhARjlxNZECG0PRCIXxDw6mogOp0I9dPpVxVTgWn/m+zU
         GBHzDonecxN98vLSP2IY2McUBdScu9Z7cjVrGJPnAgkAFcCKbQ6f7ZMBDcgcH+pgZxPI
         9Wqg==
X-Gm-Message-State: AC+VfDwhDxcKACBJtEKqVBmuFC82zTeZVdBXPuKoZipXPFkO/tBLWQYX
        VBQRxXFPgKe5gYZL+BRcAI+KeWT5/AELMGfNfS8=
X-Google-Smtp-Source: ACHHUZ5jPwsjqLMSYmT7XCPLOgaQc7vImdBwkMLlW4CQ/c4saCrLbRnKsw6u2M0rS4BSzG47wUQQkA==
X-Received: by 2002:a05:6a00:248f:b0:649:450f:3231 with SMTP id c15-20020a056a00248f00b00649450f3231mr14212327pfv.9.1685370330267;
        Mon, 29 May 2023 07:25:30 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 12-20020aa7910c000000b0064fd8b3dd13sm22297pfh.110.2023.05.29.07.25.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 07:25:29 -0700 (PDT)
Message-ID: <514b2966-77a6-3b93-f7fe-80e78783ef55@gmail.com>
Date:   Mon, 29 May 2023 22:25:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH V5 05/10] KVM: x86/pmu: Disable vPMU if the minimum num of
 counters isn't met
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230410105056.60973-1-likexu@tencent.com>
 <20230410105056.60973-6-likexu@tencent.com>
 <CALMp9eTLvJ6GW1mfgjO7CL7tW-79asykyz9=Fb=FfT74VRkDVA@mail.gmail.com>
 <9a7d5814-9eb1-d7af-7968-a6e3ebb90248@gmail.com>
 <CALMp9eR6DwY0EjAb1hcV9XGWQizN6R0dXtLaC4NXDgtCqv5cTA@mail.gmail.com>
 <81bbb700-9346-3d0d-ab86-6e684b185772@gmail.com>
 <CALMp9eSKnE8+jMpp0KzBRC7NDjT+S2cRz9CcBNDKB7JCU8dmTg@mail.gmail.com>
 <f4ef3b07-d2f2-5cfc-6783-49e9b6be7a95@gmail.com>
 <ZG6f1GYvtZ/Ndf7H@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZG6f1GYvtZ/Ndf7H@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/5/2023 7:37 am, Sean Christopherson wrote:
> On Wed, Apr 19, 2023, Like Xu wrote:
>> Jim, sorry for the late reply.
>>
>> On 11/4/2023 10:58 pm, Jim Mattson wrote:
>>>>>> Jim, does this help you or could you explain more about your confusion ?
>>>>>
>>>>> You say that "fewer than four counters can lead to guest instability
>>>>> as software expects four counters to be available." Your solution is
>>>>> to disable the PMU, which leaves zero counters available. Zero is less
>>>>> than four. Hence, by your claim, disabling the PMU can lead to guest
>>>>> instability. I don't see how this is an improvement over one, two, or
>>>>> three counters.
> 
> KVM can't do the right thing regardless.  I would rather have KVM explicitly tell
> userspace via that it can't support a vPMU than to carry on with a bogus and
> unexpected setup.
> 
>>> Does this actually guarantee that the requisite number of counters are
>>> available and will always be available while the guest is running?
>>
>> Not 100%, the scheduling of physical counters depends on the host perf scheduler.
> 
> Or put differently, the same thing that happens on Intel.  kvm_pmu_cap.num_counters_gp
> is the number of counters reported by perf when KVM loads, i.e. barring oddities,
> it's the number of counters present in the host.  Most importantly, if perf doesn't
> find the expected number of counters, perf will bail and use software only events,
> and then clear all of x86_pmu.
> 
> In other words, KVM's new sanity *should* be a nop with respect to current
> behavior.  If we're concerned about "unnecessarily" hiding the PMU when there are
> 1-3 counters, I'd be ok with a WARN_ON_ONCE().
> 
> Actually, looking more closely, there's unaddressed feedback from v4[*].  Folding
> that in, we can enable the sanity check for both Intel and AMD, though that's a
> bit of a lie since Intel will be '1'.  But the code looks pretty!

The below diff looks good to me. Please confirm that the other patches are in 
good shape
so that we can iterate on the next version. Thanks.

> 
> 	if (enable_pmu) {
> 		perf_get_x86_pmu_capability(&kvm_pmu_cap);
> 
> 		/*
> 		 * WARN if perf did NOT disable hardware PMU if the number of
> 		 * architecturally required GP counters aren't present, i.e. if
> 		 * there are a non-zero number of counters, but fewer than what
> 		 * is architecturally required.
> 		 */
> 		if (!kvm_pmu_cap.num_counters_gp ||
> 		    WARN_ON_ONCE(kvm_pmu_cap.num_counters_gp < pmu_ops->MIN_NR_GP_COUNTERS))
> 			enable_pmu = false;
> 		else if (is_intel && !kvm_pmu_cap.version)
> 			enable_pmu = false;
> 	}
> 
> 	if (!enable_pmu) {
> 		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
> 		return;
> 	}
> 
> [*] https://lore.kernel.org/all/ZC9ijgZBaz6p1ecw@google.com
