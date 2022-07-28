Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39623583D79
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 13:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbiG1LcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 07:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235937AbiG1Lb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 07:31:58 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C96948E8D;
        Thu, 28 Jul 2022 04:31:57 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id x10so858966plb.3;
        Thu, 28 Jul 2022 04:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AHFXBtfnInBBhB8+8ekuBdhEVJM43N3HWoSzOr+qt9o=;
        b=HyCw2opjMwlX92l8mkJ8OyCi97w6+eQbenm1EnuOYD52pvBYdqc1Dvs7LFuTPVwKoh
         f1wJ6DUDZ4AmG0G0ur9UIZx5z7wM3u7astU3WPZwQIiEOamXsCQX9bL7m5iVtGaOay7Y
         EaqGZySvXBdWFZvSv0C0puRLWQCQ8IgKcuvvWB3Zg1OVjekejJPEL839xLF+f9voa8Uw
         5pMfgBwxLCei94pudahaj1nqlcM0zV7tFNiEBsHKzl33SqDPM4MHFJaEN2FCf66NSlij
         oSMCNAPDhWZv5MWrdzsnf/uwoGIK8bP5y00U+mmhCSsBd9Dh/6ZXme1Tvw/ieYiZQ1xm
         UKPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AHFXBtfnInBBhB8+8ekuBdhEVJM43N3HWoSzOr+qt9o=;
        b=kGw6ArtiB3D+7Ie4elr9CJpKu4w/3CdEQW8bTZ4Hz94a00hoYojr1KmW4IAlxCMXJv
         OZtduGSkvnQaQLqEuDqJBQoVkRQhgeNWvP6SlxxYg0YO35ymjcBbud/EQjm5er5wAbsR
         tq5//Zuqq4MD2hdZcjpxydhN+j+znuwJ+8xqpPq84xvcwr9VE8padtSGOpTbDUYsiqsr
         J5jN6k7BphciZkQjOEfHjYdNocrjYB9+yxXdbYaxWMc0RzgVmn1ZkT00xF2XFXRtJWm5
         JbV27aHTKFDb8M/46ImTTPWLsLsBpCFU84ZpoqFjNlDNykFUvzAEKBN+e3ObuAETPdS8
         0jZg==
X-Gm-Message-State: AJIora/S9Jfp4v4mvb0nl5XeltJ1htjjwgXt8Li1NycaQoOJ84khuNMV
        RNzfl27BLg0nSe1U3ksOiVo=
X-Google-Smtp-Source: AGRyM1uWZZx0u1ABXhdQpNT+vWIRAdVxwxaVVa9Mu1f9aoowNQe2xBBPyYem0C6z1VXmYDo3Grh6xw==
X-Received: by 2002:a17:90b:3148:b0:1ef:e4ce:1ebf with SMTP id ip8-20020a17090b314800b001efe4ce1ebfmr9531949pjb.220.1659007916800;
        Thu, 28 Jul 2022 04:31:56 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c2-20020a056a00008200b0051bbe085f16sm481828pfj.104.2022.07.28.04.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 04:31:56 -0700 (PDT)
Message-ID: <7efeb037-e82c-8401-2e7a-a880f3f21d9c@gmail.com>
Date:   Thu, 28 Jul 2022 19:31:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [kvm-unit-tests PATCH] x86: Add tests for Guest Processor Event
 Based Sampling (PEBS)
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220721103549.49543-1-likexu@tencent.com>
 <20220721103549.49543-9-likexu@tencent.com> <YuG/QtIM/fvhLI/u@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <YuG/QtIM/fvhLI/u@google.com>
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

On 28/7/2022 6:42 am, Sean Christopherson wrote:
> On Thu, Jul 21, 2022, Like Xu wrote:
>> +union perf_capabilities {
>> +	struct {
>> +		u64	lbr_format:6;
>> +		u64	pebs_trap:1;
>> +		u64	pebs_arch_reg:1;
>> +		u64	pebs_format:4;
>> +		u64	smm_freeze:1;
>> +		/*
>> +		 * PMU supports separate counter range for writing
>> +		 * values > 32bit.
>> +		 */
>> +		u64	full_width_write:1;
>> +		u64 pebs_baseline:1;
>> +		u64	perf_metrics:1;
>> +		u64	pebs_output_pt_available:1;
>> +		u64	anythread_deprecated:1;
>> +	};
>> +	u64	capabilities;
>> +};
>> +
>> +union cpuid10_eax {
>> +        struct {
>> +                unsigned int version_id:8;
>> +                unsigned int num_counters:8;
>> +                unsigned int bit_width:8;
>> +                unsigned int mask_length:8;
>> +        } split;
>> +        unsigned int full;
>> +} pmu_eax;
>> +
>> +union cpuid10_edx {
>> +        struct {
>> +                unsigned int num_counters_fixed:5;
>> +                unsigned int bit_width_fixed:8;
>> +                unsigned int reserved:19;
>> +        } split;
>> +        unsigned int full;
>> +} pmu_edx;
> 
> The generic unions are hopefully unnecessary now that helpers are provided by
> lib/x86/processor.h, e.g. for pmu_version().
> 
> I would prefer to have similar helpers instead of "union perf_capabilities",
> but it's not a sticking point if helpers a signifiantly more painful to use.
> 
>> +	if (!is_intel() || (pmu_eax.split.version_id < 2) ||
>> +	    !(perf.capabilities & PERF_CAP_PEBS_FORMAT) ||
>> +	    (rdmsr(MSR_IA32_MISC_ENABLE) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL)) {
> 
> Split these up, it's really, really annoying to have to guess which one of the
> four checks failed.
> 
>> +		report_skip("This platform doesn't support guest PEBS.");
>> +		return 0;
> 
> This needs be be "return report_summary()", otherwise the test says pass when it
> didn't do anyting:
> 
>   TESTNAME=pmu_pebs TIMEOUT=90s ACCEL=kvm ./x86/run x86/pmu_pebs.flat -smp 1 -cpu host,migratable=no
>   PASS pmu_pebs
> 
> wait a second...
> 
>    SKIP: This platform doesn't support guest PEBS.
> 
> E.g. (though if KUT can provide more information on why PERF_CAP_PEBS_FORMAT
> may not be advertised, e.g. requires ICX+?, that would be nice to have)
> 
>          if (!is_intel()) {
>                  report_skip("PEBS is only supported on Intel CPUs");
>                  return report_summary();
>          }
>          if (pmu_version() < 2) {
>                  report_skip("Architectural PMU not available");
>                  return report_summary();
>          }
>          if (!(perf.capabilities & PERF_CAP_PEBS_FORMAT)) {
>                  report_skip("PEBS not enumerated in PERF_CAPABILITIES");
>                  return report_summary();
>          }
>          if (rdmsr(MSR_IA32_MISC_ENABLE) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL) {
>                  report_skip("PEBS unavailable according to MISC_ENABLE");
>                  return report_summary();
>          }

Thanks, all applied. Please review this new version as a separate thread.
https://lore.kernel.org/kvm/20220728112119.58173-1-likexu@tencent.com/
