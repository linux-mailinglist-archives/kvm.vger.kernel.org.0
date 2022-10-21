Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491D16070DD
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 09:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJUHVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 03:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJUHVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 03:21:52 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4F52465E6
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 00:21:48 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id f140so1841013pfa.1
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 00:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CXCSL7Xw2UJR8zDyNeQ+zFP8ixKN3GOqRRJLWY4DT5w=;
        b=h9NnF305IvhIBjzIbHP3CtPAl70TjJkeoXt5CEk5ficfg9H/Si9q/1W3gVc9WUloBu
         rtdT0Tz8EdvrFUm7xDJZGvGOKnPARZc/ueG2mcK7/LGZi+Jkznfuq3RoFLeP/PGgM57n
         IvqhH7FoRPBostkgDSsTkeGvMX7+Ah5kNs985V6iw30z2Kx6fmPck+wChpjEK45zLBef
         1IJ1MwRdP3pmuaURPpHmfjZ3FfxY59Y0H+Q2FGrJHH8rzRfZermR28ie1gTGpiOqzLJu
         YKVinDDxyJne9NwhnkNk9fBIPiAC+3ejfATQwyuQvOb1ad82BKCc+/lfSwNYSEa+34ku
         1qFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CXCSL7Xw2UJR8zDyNeQ+zFP8ixKN3GOqRRJLWY4DT5w=;
        b=vTp3RVxyghmQBWK7XMF3nFD+c1ATHFuEPxlAybE+64UnPAAToM3GYJWHvbAhVFjJFa
         tTRb830iLCMt+WTKADYnLZUQOCi7V7ppHl17yq1daPllFVrCPwDvghNJvSE82a11l87u
         fZXG/SA6kU7wglzZJIVhBCQoPhUO64J42THDUHDPMJn1BZDl9QmjHoA59aAP7BJO8u3s
         P+3ZsV8ShQqoNociR+jNpJst1xruG17Lk8ehlFzi8RIbkPmNi2J/maIY4oaE7yvlGXBT
         VMB6EBEp03mwBIik9JAw4H9QXo9nmJdVGWKxztLX6+rQyEAZFYN5lSq043j+tfI3xdqr
         Bqsg==
X-Gm-Message-State: ACrzQf0K/oEHGl98EXSRcVUBR4Qkc1KGDySrNbLXAEurpD7WlQpDXS7R
        cDW8tJ+5Ywuis7ZeHIVTTJ0=
X-Google-Smtp-Source: AMsMyM7YpiRIZHDdMYkqTmFFj+CbCT9JqBIHuSwqZxGX2+yHBCp+zuRqV7u0Vjt+/Xzttcqp+XEvVg==
X-Received: by 2002:a63:1b0f:0:b0:46b:910:6cd9 with SMTP id b15-20020a631b0f000000b0046b09106cd9mr15273165pgb.5.1666336907306;
        Fri, 21 Oct 2022 00:21:47 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h9-20020aa79f49000000b00537fb1f9f25sm14513904pfr.110.2022.10.21.00.21.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 00:21:46 -0700 (PDT)
Message-ID: <8aeb4890-269b-1bd5-abe6-974e79858390@gmail.com>
Date:   Fri, 21 Oct 2022 15:21:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
Subject: Re: [kvm-unit-tests PATCH v3 12/13] x86/pmu: Add assignment framework
 for Intel-specific HW resources
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-13-likexu@tencent.com> <Yz4IwVKje90pcIUN@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Yz4IwVKje90pcIUN@google.com>
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

On 6/10/2022 6:44 am, Sean Christopherson wrote:
> On Fri, Aug 19, 2022, Like Xu wrote:
>> @@ -65,7 +65,13 @@ struct pmu_event {
>>   };
>>   
>>   #define PMU_CAP_FW_WRITES	(1ULL << 13)
>> -static u64 gp_counter_base = MSR_IA32_PERFCTR0;
>> +static u32 gp_counter_base;
>> +static u32 gp_select_base;
>> +static unsigned int gp_events_size;
>> +static unsigned int nr_gp_counters;
>> +
>> +typedef struct pmu_event PMU_EVENTS_ARRAY_t[];
>> +static PMU_EVENTS_ARRAY_t *gp_events = NULL;
> 
> There's no need for a layer of indirection, C d.  The NULL is also not strictly
> required.  E.g. this should Just Work.
> 
>    static struct pmu_event *gp_events;

Applied.

> 
> And then I beleve a large number of changes in this series go away.
> 
>>   char *buf;
>>   
>> @@ -114,9 +120,9 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
>>   	if (is_gp(cnt)) {
>>   		int i;
>>   
>> -		for (i = 0; i < sizeof(gp_events)/sizeof(gp_events[0]); i++)
>> -			if (gp_events[i].unit_sel == (cnt->config & 0xffff))
>> -				return &gp_events[i];
>> +		for (i = 0; i < gp_events_size; i++)
>> +			if ((*gp_events)[i].unit_sel == (cnt->config & 0xffff))
>> +				return &(*gp_events)[i];
>>   	} else
>>   		return &fixed_events[cnt->ctr - MSR_CORE_PERF_FIXED_CTR0];
>>   
>> @@ -142,12 +148,22 @@ static void global_disable(pmu_counter_t *cnt)
>>   			~(1ull << cnt->idx));
>>   }
>>   
>> +static inline uint32_t get_gp_counter_msr(unsigned int i)
> 
> Rather than helpers, what about macros?  The problem with "get" is that it sounds
> like the helper is actually reading the counter/MSR.  E.g. see MSR_IA32_MCx_CTL()
> 
> Something like this?
> 
>    MSR_PERF_GP_CTRx()

The base address msr is different for intel and amd (including K7), and using 
different macros
in the same location sounds like it would require a helper.

This proposal will be dropped or need to be re-emphasised in the next version.

> 
>> +{
>> +	return gp_counter_base + i;
>> +}
>> +
>> +static inline uint32_t get_gp_select_msr(unsigned int i)
>> +{
>> +	return gp_select_base + i;
> 
> Same here, maybe?
> 
>    MSR_PERF_GP_SELECTx()
> 
> 
