Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9DC6455A3
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 09:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiLGIp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 03:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiLGIoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 03:44:46 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065AE2FFE0;
        Wed,  7 Dec 2022 00:44:22 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id 124so16980046pfy.0;
        Wed, 07 Dec 2022 00:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Aq3HGZp76kd1IhxcBQ0sV7wyhIxHXLUJxX9uaW3maVM=;
        b=i0hKOZw04aUYKyoYSWFGPQP2C62KidWwhG+DlldCs2fqXoMGucwSSVg1rMHisM4bNx
         5dQlofsLZL+VNDyAPGwOlW4Wnlkw63FXjddLvCe5DraA57IjyUH0adheqyYpUc9a8/0X
         MYjboA1P6bhAfRv1jKNnCFP4Xx3TKl4N448lVbPesmFsMf+7SH7RtIVgXrHfehp7BFqT
         nmMKcoHIxzxTGx6T9hmleoPe3VTGW51GJZpC3mbX+KFQZcVnG/2txt6p+1YvPoE7LKPF
         dLEVArdKvT3jMTjsD5XryzQ04Oz46OYPtBTZudBK8QJmf+NLn+iI0Z5cX1/zZT7ss2Wb
         qcOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aq3HGZp76kd1IhxcBQ0sV7wyhIxHXLUJxX9uaW3maVM=;
        b=iZd8ElBhkBVNfS0FdInm1Hb2oWlkQQZ+EgETZZDUcM5ZAFQJu3nGoFj2VHnKMYkePm
         5gL+x0JVqfxEDcGjc2yJbslH+rM0fBuPcPVayEKnep4GxO53UWL9WU+oJciX+ieovRw0
         uQ5lQk+Gt1SQsZmQmbmjUpAJ0O9A8vt1zsKdRkqUL53HMUm5SXZk4U9hdh358D3U3twd
         c1r2VPByUZquku3cJWisF5BGxIZ4e5rmijQ36BMtCDwV4SB6+lTovuWj1MaelK4df8Cv
         RbyT0/u78GP2fC9+xXyPgwkORJRqaRZsnV1exEbxz+TkmZlofG8WDUDB886M/VsPJ2xG
         uiFg==
X-Gm-Message-State: ANoB5pkF2gg3XUcQPTAZKrK4gPgubVaMaQAYrKjNcFS/Rhxq+3U2ueWg
        MLd78TcmGxBvfMYan5NNkBM=
X-Google-Smtp-Source: AA0mqf57MSjH+nG9lMX/ezXPrV6wwfC2E5m98eO2WdJBYYYTk/S/NCJQtHOlxzCj8gIXh5fjvuIqQA==
X-Received: by 2002:a05:6a00:1711:b0:576:c2f0:d6a1 with SMTP id h17-20020a056a00171100b00576c2f0d6a1mr510404pfc.8.1670402661511;
        Wed, 07 Dec 2022 00:44:21 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id g81-20020a625254000000b00561d79f1064sm13003043pfb.57.2022.12.07.00.44.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 00:44:19 -0800 (PST)
Message-ID: <7db2bc22-99b8-96f3-66f3-d1695e2e82c1@gmail.com>
Date:   Wed, 7 Dec 2022 16:44:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH] KVM: x86/pmu: Avoid ternary operator by directly
 referring to counters->type
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221205113718.1487-1-likexu@tencent.com>
 <Y44gbvm5Zb7a1Sbj@google.com>
 <38b2a836-f9a4-23e4-107b-61efc74638a4@gmail.com>
 <Y495sF0rDGrrfstD@google.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y495sF0rDGrrfstD@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/12/2022 1:19 am, Sean Christopherson wrote:
> On Tue, Dec 06, 2022, Like Xu wrote:
>>>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>>>> index e5cec07ca8d9..28b0a784f6e9 100644
>>>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>>>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>>>> @@ -142,7 +142,7 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
>>>>    	}
>>>>    	if (idx >= num_counters)
>>>>    		return NULL;
>>>> -	*mask &= pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : KVM_PMC_GP];
>>>> +	*mask &= pmu->counter_bitmask[counters->type];
>>>
>>> In terms of readability, I have a slight preference for the current code as I

IMO, using counters->type directly just like pmc_bitmask() will add more readability
and opportunistically helps some stale compilers behave better.

>>> don't have to look at counters->type to understand its possible values.
>> When someone tries to add a new type of pmc type, the code bugs up.
> 
> Are there new types coming along?  If so, I definitely would not object to refactoring
> this code in the context of a series that adds a new type(s).  But "fixing" this one
> case is not sufficient to support a new type, e.g. intel_is_valid_rdpmc_ecx() also
> needs to be updated.  Actually, even this function would need additional updates
> to perform a similar sanity check.

True but this part of the change is semantically relevant, which should not
be present in a harmless generic optimization like this one. Right ?

> 
> 	if (fixed) {
> 		counters = pmu->fixed_counters;
> 		num_counters = pmu->nr_arch_fixed_counters;
> 	} else {
> 		counters = pmu->gp_counters;
> 		num_counters = pmu->nr_arch_gp_counters;
> 	}
> 	if (idx >= num_counters)
> 		return NULL;
> 
>> And, this one will make all usage of pmu->counter_bitmask[] more consistent.
> 
> How's that?  There's literally one instance of using ->type
> 
>    static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
>    {
> 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> 
> 	return pmu->counter_bitmask[pmc->type];
>    }
> 
> everything else is hardcoded.  And using pmc->type there make perfect sense in
> that case.  But in intel_rdpmc_ecx_to_pmc(), there is already usage of "fixed",
> so IMO switching to ->type makes that function somewhat inconsistent with itself.

More, it's rare to see code like " [ a ? b : c] " in the world of both KVM and x86.
Good practice (branchless) should be scattered everywhere and not the other way 
around.

I have absolutely no objection to your "slight preference". Thanks for your time 
in reviewing this.
