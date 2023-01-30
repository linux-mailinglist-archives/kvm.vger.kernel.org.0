Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8AC680BFA
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 12:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbjA3LaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 06:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234199AbjA3LaW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 06:30:22 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B68765BC;
        Mon, 30 Jan 2023 03:30:21 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id j20so833522pfj.0;
        Mon, 30 Jan 2023 03:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1zwI9zoUbpBGdhOy5hWUZHiBhmKQj11GWohM9EvLfkI=;
        b=hbFwWnrDzD6Rxbb3KalzTTSJV/RKSKgObnGmomuDrR0UuwjOWYG2vdWHotEjyPxt1s
         Z45znw26CQu4EhSoJ2ceBeDJTAMhHi8mByoC4UmngfqDlpeVX9UV4DZwbiADZLNITgta
         86D7z7gD0mfN9R1UxeM0lZeWcxctjSMaVJNxSlguQ0zyd0EpYKJr+jn8RQsQkayAoPad
         OMZch41pSbz1MSijt8None/ay/iHo01rQS2iryH721b+lWbr6eqhy/0tU3ns/wKuJm12
         GTE20jXj4+36cBoLHIPDuvB73jWuMJI6qNDMfHe9K6O03HC9U2Ge6Z3cyRF48P/cyuZJ
         nEFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1zwI9zoUbpBGdhOy5hWUZHiBhmKQj11GWohM9EvLfkI=;
        b=0QtLXfsdFgqTv9Iyw7eero3qQyqlYeC1Ut92C+s/BJ1CfuTLvHXe/7q//LzqtkSvAZ
         H2o5qAgcpDhuUeJbR/fJlfilR8LQJazMgFNrk1ZaYn+v8ga2DYnXMPxtd8oxUtV8Zg12
         DoFovTMO5ZnhwCY6GmUs6c+CermU9sJDtICpNxS/ABHH4adlmx80aHamPU5jLrGkhcos
         8j2xFozAmvVZTFLDYvdAu85i6Z9Sx42fTurz+zP0pMgwVE6oc+fjWMu1cyg8yL4qMTGV
         M+tPjgBNmMB1vwLnVo3OO3SAD8SInGfp3jtI56Szpsb9dBmnSEsDMnu33wnfrvMwDd5W
         RDEw==
X-Gm-Message-State: AO0yUKUh5pmAeKdEXtCsvhq/jGxujxr9MDpcZjQwtV8yb8FPLRTSkJEB
        YBCL+x7KR1NNDlAyBwoaMhk=
X-Google-Smtp-Source: AK7set9IwXfCl5OTsiFGnuTBFqM1mO1QWfJuE70dLMfTlFda2Q7qxCJZ8/O+YVvjzLhUp50jvyw1GA==
X-Received: by 2002:a05:6a00:1516:b0:593:af5d:7c2f with SMTP id q22-20020a056a00151600b00593af5d7c2fmr6471598pfu.11.1675078220895;
        Mon, 30 Jan 2023 03:30:20 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id n7-20020a622707000000b00593d7db7f29sm773883pfn.216.2023.01.30.03.30.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 03:30:20 -0800 (PST)
Message-ID: <9b422d58-72ab-051f-e317-02b4d8e7211d@gmail.com>
Date:   Mon, 30 Jan 2023 19:30:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v3 1/3] KVM: x86/pmu: Disable guest PEBS on hybird cpu due
 to heterogeneity
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20221109082802.27543-1-likexu@tencent.com>
 <20221109082802.27543-2-likexu@tencent.com> <Y8nknyxfKl4p/0GY@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y8nknyxfKl4p/0GY@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/1/2023 8:47 am, Sean Christopherson wrote:
> On Wed, Nov 09, 2022, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>>  From vPMU enabling perspective, KVM does not have proper support for
>> hybird x86 core. The reported perf_capabilities value (e.g. the format
>> of pebs record) depends on the type of cpu the kvm-intel module is init.
>> When a vcpu of one pebs format migrates to a vcpu of another pebs format,
>> the incorrect parsing of pebs records by guest can make profiling data
>> analysis extremely problematic.
>>
>> The safe way to fix this is to disable this part of the support until the
>> guest recognizes that it is running on the hybird cpu, which is appropriate
>> at the moment given that x86 hybrid architectures are not heavily touted
>> in the data center market.
>>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/vmx/capabilities.h | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
>> index cd2ac9536c99..ea0498684048 100644
>> --- a/arch/x86/kvm/vmx/capabilities.h
>> +++ b/arch/x86/kvm/vmx/capabilities.h
>> @@ -392,7 +392,9 @@ static inline bool vmx_pt_mode_is_host_guest(void)
>>   
>>   static inline bool vmx_pebs_supported(void)
>>   {
>> -	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
>> +	return boot_cpu_has(X86_FEATURE_PEBS) &&
>> +	       !boot_cpu_has(X86_FEATURE_HYBRID_CPU) &&
>> +	       kvm_pmu_cap.pebs_ept;
> 
> I assume the patch I just posted[*] to disable the vPMU entirely is sufficient, or

AFAI, some developers doing client-side virtualization on a hybrid cpu will 
specifically want vPMU,
in which case it makes perfect sense for KVM to expose common pmu capabilities 
(not PEBS at the current) of big and little cores, such as the most basic 
performance counter.

> do we need this as well in order to hide X86_FEATURE_DS and X86_FEATURE_DTES64?

I think we still need this diff. Better to prioritize this minor feature a 
little bit for hungry users.

> 
> [*] https://lore.kernel.org/all/20230120004051.2043777-1-seanjc@google.com

