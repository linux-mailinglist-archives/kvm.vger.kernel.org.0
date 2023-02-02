Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4D3687CA3
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 12:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjBBLrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 06:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbjBBLrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 06:47:16 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760918D616;
        Thu,  2 Feb 2023 03:46:55 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id f3so1136461pgc.2;
        Thu, 02 Feb 2023 03:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OCHv+Rtu/T4PvxYHPWW8MnIPWqx9+x/w+3ZCigYTGeo=;
        b=gBGsmXvDj7gKK8xLG2DDBPKoN+F5GpdpsEeTMUzi7Z09FMcz+VoCBnFpP4xl6/3Ke3
         uuYc8qTvyE1y+OepENJBCwlwYPTAPtG9z4ZW/TuAPPFxWIjA9x22K8jVwkOkwW7k7cmt
         RMOvpTVw1ecppwfRhJNPj6+Z+MFYA4TNZmnqVfBWKxd4isOdH8fNJBO98TItN7iITU03
         AjxJ/+TDIxk3TmYURg9KomQh9PZCWoP2CPJnBlgqBAUL+gY9O1MsthHdUJmwP3TJThkA
         nL/tzSlSMco/QmEGOhalmnktDssNg3+Ah02X3A/9TQoDpcec/alYJOP9suvpJFtg2El0
         pyjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OCHv+Rtu/T4PvxYHPWW8MnIPWqx9+x/w+3ZCigYTGeo=;
        b=WvgYsITQH+/NxFRIhv5CzWVOb3g6gCLu69zOcbWT8lZj6ts/gIr+dOHaSA+SWNQi1k
         DUq40UTeYAa2rfOT5tR3Gd0vFwI4Q7LWZGTWwXkp39DdikuFqX/AzxtMo+NVlunocwAS
         cCemRT5ZFzWtXzss0no7S3Hnea8UJspqn1F3AfsmDtGf4uHqXJEbijwmbOP/PNu9dEbq
         lxHCtxD0tPol9TUppTs9Kl5H8Tbtr8G5FkJkclnPZ6/aqzzg7i+of9KmnnfvQ82jh9WZ
         7XC8BbjfdApLqlId9Qgl9Uu6kHOAaTenUfdptAeJ/a7tlecpq+AUuWsDgyrbaDfk8MRU
         cnvg==
X-Gm-Message-State: AO0yUKUc7ickh5zkxU9JjdX42Y+M+LlYPmktGPHKU1OhwXj7rquEYI92
        UVY2MnppmKEt17N2ODP+O80=
X-Google-Smtp-Source: AK7set8eGQ8qm7P4Mq8Oi5ijbj3+njAE13TIs6LPMK1xA4qne/Lyf3/ludlqGYJ3wth3RNWZFiJSNQ==
X-Received: by 2002:a62:b519:0:b0:58e:151c:f7fe with SMTP id y25-20020a62b519000000b0058e151cf7femr4901305pfe.4.1675338414936;
        Thu, 02 Feb 2023 03:46:54 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id p56-20020a056a0026f800b0058882b59d22sm13335902pfw.219.2023.02.02.03.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 03:46:54 -0800 (PST)
Message-ID: <839ac9f7-92ff-c04d-37d3-d12db91d8829@gmail.com>
Date:   Thu, 2 Feb 2023 19:46:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v3 1/8] KVM: x86/pmu: Rename pmc_is_enabled() to
 pmc_is_globally_enabled()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
References: <20221111102645.82001-1-likexu@tencent.com>
 <20221111102645.82001-2-likexu@tencent.com> <Y9Mw3pcW/SL/Mna8@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y9Mw3pcW/SL/Mna8@google.com>
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

On 27/1/2023 10:03 am, Sean Christopherson wrote:
> On Fri, Nov 11, 2022, Like Xu wrote:
>> From: Like Xu<likexu@tencent.com>
>>
>> The name of function pmc_is_enabled() is a bit misleading. A PMC can
>> be disabled either by PERF_CLOBAL_CTRL or by its corresponding EVTSEL.
>> Add the global semantic to its name.
>>
>> Suggested-by: Jim Mattson<jmattson@google.com>
>> Signed-off-by: Like Xu<likexu@tencent.com>
>> ---
> ...
> 
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 684393c22105..e57f707fb940 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -83,7 +83,7 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
>>   #undef __KVM_X86_PMU_OP
>>   }
>>   
>> -static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
>> +static inline bool pmc_is_globally_enabled(struct kvm_pmc *pmc)
>>   {
>>   	return static_call(kvm_x86_pmu_pmc_is_enabled)(pmc);
> This doesn't compile.  v3, and I'm getting pings, and the very first patch doesn't
> compile.
> 

Oops, very sorry for this breaking the git-bisect attribute, it's my fault to 
split the code diff incorrectly
(weakly it compiles fine w/ 4th patch), I will enhance the process before 
sending any patches to you.
Thank you for taking time to review the rest of patches in detail as you always 
do. The new version is
under construction, apologies again.
