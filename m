Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3FA64DC02
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 14:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiLONLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 08:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiLONLn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 08:11:43 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E452ED61;
        Thu, 15 Dec 2022 05:11:42 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id k79so6661346pfd.7;
        Thu, 15 Dec 2022 05:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xrhxzhT9JV75VSnaY6V+UjS1o2AP1XliAK6PLs2zUKw=;
        b=K82I9xquXsJALwGCLg6UdItvZ8v7s0Ng25dK+emcTTUN+4zpDpFAB46u6D8vumSLnm
         HPQqijmUVXmdF+eLzLe2lNKFzYg1rV+Pdg5+1ebOPFNnEgj0ZMK2zQbxbDuBcTgwVNZ3
         WaRbvLpYIcAG3SEzV7miDks3kDSwxoJe1klpQAobGWRIu4RUT4/DJDITx+2CO4GCxR5U
         TtnAVtzFAQoY+mHA2c9Vq+w3L3SGtn912iFCpPtDQT+OGT6adHBe8aYHVAIpUpgwgS+Q
         eOO7pCJ+hRGaZs1UXYh9IaCNz3qp/NvZhs0CAy/MBdJMsJyTn82m8HtdhjpvtS300CQk
         3bBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xrhxzhT9JV75VSnaY6V+UjS1o2AP1XliAK6PLs2zUKw=;
        b=xrFUnQqFlF9yrlnMl/UOvggn84JFCm8up0OEsbXPl4nP41HCTjk16k5JBffcWUk6Fb
         UgIeIFLGJPansa1ccyOLlX/d4XATqC7IBAQ5ES7guDqmgzOnqSxoDz9CRm1I0i4qfv+z
         uwOacXSgpDwDOHdQElT9VvA95vq+uPbRx1FcErmpZEGOWAlsqUd4SLrELCsLCZ+r51Xc
         O1qYzqzW8HKtFE9vS73BlTMJM9XDaMkyKXzUKof9ZxN90rfnFDnXjeMCC8FKQxwKYD5T
         R8aeEHR5x67i4sHxlZPHPO2zdsRHLTycUbs+McyA79Gx+5c57O9v2ikd9+ZCkC3+wzDB
         iWQw==
X-Gm-Message-State: ANoB5pnOzYCEsrLyrlB0rvJtUH3FENcJnGJh6KcklUWj+bZrLD9dwPmX
        BIhHNaR/LM/3JEHvLWcCVNk=
X-Google-Smtp-Source: AA0mqf5VkVNrnq7BXWVl6agz2NTf0dp+cDI3caC2isY08mPSkEWovHU/5eLtZ0qtr+s+nWE/TaW+SA==
X-Received: by 2002:aa7:924c:0:b0:573:a0a0:c5d2 with SMTP id 12-20020aa7924c000000b00573a0a0c5d2mr28952655pfp.7.1671109902254;
        Thu, 15 Dec 2022 05:11:42 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 9-20020a621609000000b005745788f44csm1684079pfw.124.2022.12.15.05.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 05:11:41 -0800 (PST)
Message-ID: <e8278857-1d30-877a-5c8d-329d3cba755b@gmail.com>
Date:   Thu, 15 Dec 2022 21:11:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH RFC 1/8] perf/core: Add *group_leader to
 perf_event_create_kernel_counter()
To:     Marc Zyngier <maz@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>, kvmarm@lists.linux.dev,
        linux-perf-users@vger.kernel.org
References: <20221212125844.41157-1-likexu@tencent.com>
 <20221212125844.41157-2-likexu@tencent.com> <865yegrc23.wl-maz@kernel.org>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <865yegrc23.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/2022 9:23 pm, Marc Zyngier wrote:
> On Mon, 12 Dec 2022 12:58:37 +0000,
> Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> From: Like Xu <likexu@tencent.com>
>>
>> Like syscalls users, kernel-space perf_event creators may also use group
>> counters abstraction to gain pmu functionalities, and an in-kernel counter
>> groups behave much like normal 'single' counters, following the group
>> semantics-based behavior.
>>
>> No functional changes at this time. An example will be that KVM creates
>> Intel slot event as group leader and other topdown metric events to emulate
>> MSR_PERF_METRICS pmu capability for guests.
>>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Fenghua Yu <fenghua.yu@intel.com>
>> Cc: kvmarm@lists.linux.dev
>> Cc: linux-perf-users@vger.kernel.org
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/arm64/kvm/pmu-emul.c                 | 4 ++--
>>   arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 4 ++--
>>   arch/x86/kvm/pmu.c                        | 2 +-
>>   arch/x86/kvm/vmx/pmu_intel.c              | 2 +-
>>   include/linux/perf_event.h                | 1 +
>>   kernel/events/core.c                      | 4 +++-
>>   kernel/events/hw_breakpoint.c             | 4 ++--
>>   kernel/events/hw_breakpoint_test.c        | 2 +-
>>   kernel/watchdog_hld.c                     | 2 +-
>>   9 files changed, 14 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index 24908400e190..11c3386bc86b 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -624,7 +624,7 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
>>   
>>   	attr.sample_period = compute_period(pmc, kvm_pmu_get_pmc_value(pmc));
>>   
>> -	event = perf_event_create_kernel_counter(&attr, -1, current,
>> +	event = perf_event_create_kernel_counter(&attr, -1, current, NULL,
>>   						 kvm_pmu_perf_overflow, pmc);
> 
> Wouldn't it be better to have a separate helper that takes the group leader
> as a parameter, and reimplement perf_event_create_kernel_counter() in term
> of this helper?
> 
> 	M.
> 

Applied. It makes changes more concise, thank you.
