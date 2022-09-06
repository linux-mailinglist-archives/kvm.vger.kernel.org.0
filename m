Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACBA95AE980
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 15:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239898AbiIFN2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 09:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234293AbiIFN2f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 09:28:35 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFE674B82
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 06:28:34 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so5739940pjm.1
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 06:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=PpplshrpJUvVY9skRXOYSZ/STx+uExB8TQSXlDY1VuM=;
        b=C6aLlUDVcfzRdArdNW/202kCJseYp3yOhM1nj+0JRjVBexL7bvtrNOAUOgQRnLK5uk
         t9D+alsSdktWLLxPHzCLYDcsCQ+yMkO4wPS7Jgsj0q0n52bYHFguqa1lLfmpXGcZYiwz
         Xh3svI/DE83w5liraQ/SrUj6FXkY0SgmJdk8GnIBKYTHiQ+YsbzZfEpxzh8FlYkqJyGk
         z5SdkrzgBMzOxf/WNrIGJo5D9r1v9z0QYxAW4eeNMWqIQnT7GK1qJIZU6V7/qo00rNdc
         URFTPlqSzQ/X/m7ygeqBOiSn2SCJsDF0I5CpUcUYtojdpFtP2cK1m1t0fsA8dD0f8SmK
         S8aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=PpplshrpJUvVY9skRXOYSZ/STx+uExB8TQSXlDY1VuM=;
        b=foVSYnj06PwxEIbMi2x+kPosaOoSqM7V7Cko2C/eckD1dbcOh8XwwSOqa2pplwo0Fx
         rjiCWariBjdOxxvii/EmJOuwQvUQQeEcJpsNaAX0TPsyvmpKMUrVQDhaZ44gTXaG8tD0
         wiomkmbQr9d/Vrufl5SzipSlyuVtjOLroN0C48MYBJWPyJQsxhIA9CwJVbgpCl5cK0XR
         p3c5PKDuqUJrLow5pIyEOtVYoZ7TtSHvrpkzO8EA+BVLniEjeuoG2JJtQUWhG9rowCeQ
         FsPO3Y9RGMrd94MKLYxIcPURW1aEGER6J/7CCmHMMIKuCpS8u+QHQadVFFz09iVYiulm
         KdPg==
X-Gm-Message-State: ACgBeo39nXLDtI79m68b8twfrhq2M0zqjmab8wJ2/IRINUoQCRxDTv9X
        ISdBfhkaM/+rYrRQIx8bi2w=
X-Google-Smtp-Source: AA6agR6rku5WL9D+nv/yyGsRbUT+SFlWkVNTjM1fALS5+7wWY828q280X2pjQTT8ynvE99gKlJh2UQ==
X-Received: by 2002:a17:90a:4d8a:b0:200:183a:10ad with SMTP id m10-20020a17090a4d8a00b00200183a10admr17439414pjh.171.1662470913880;
        Tue, 06 Sep 2022 06:28:33 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b14-20020a1709027e0e00b0017542c2ddabsm9793289plm.288.2022.09.06.06.28.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 06:28:33 -0700 (PDT)
Message-ID: <a3185f9b-a496-2419-439a-b2b23fbf0531@gmail.com>
Date:   Tue, 6 Sep 2022 21:28:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v3 10/13] x86/pmu: Update testcases to
 cover Intel Arch PMU Version 1
Content-Language: en-US
To:     Sandipan Das <sandipan.das@amd.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-11-likexu@tencent.com>
 <895a4eab-5c1c-add1-35b7-8178b927fefd@amd.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <895a4eab-5c1c-add1-35b7-8178b927fefd@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/9/2022 3:15 pm, Sandipan Das wrote:
> Hi Like,
> 
> On 8/19/2022 4:39 PM, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> For most unit tests, the basic framework and use cases which test
>> any PMU counter do not require any changes, except for two things:
>>
>> - No access to registers introduced only in PMU version 2 and above;
>> - Expanded tolerance for testing counter overflows
>>    due to the loss of uniform control of the gloabl_ctrl register
>>
>> Adding some pmu_version() return value checks can seamlessly support
>> Intel Arch PMU Version 1, while opening the door for AMD PMUs tests.
>>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   x86/pmu.c | 64 +++++++++++++++++++++++++++++++++++++------------------
>>   1 file changed, 43 insertions(+), 21 deletions(-)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index 25fafbe..826472c 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> [...]
>> @@ -520,10 +544,13 @@ static void check_emulated_instr(void)
>>   	       "instruction count");
>>   	report(brnch_cnt.count - brnch_start >= EXPECTED_BRNCH,
>>   	       "branch count");
>> -	// Additionally check that those counters overflowed properly.
>> -	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
>> -	report(status & 1, "instruction counter overflow");
>> -	report(status & 2, "branch counter overflow");
>> +
>> +	if (pmu_version() > 1) {
>> +		// Additionally check that those counters overflowed properly.
>> +		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
>> +		report(status & 1, "instruction counter overflow");
>> +		report(status & 2, "branch counter overflow");
>> +	}
>>   
> 
> This should use status bit 1 for instructions and bit 0 for branches.

Yes, this misleading statement stems from
20cf914 ("x86/pmu: Test PMU virtualization on emulated instructions")

I will fix it as part of this patch set. Thanks.

> 
>>   	report_prefix_pop();
>>   }
>> [...]
> 
> - Sandipan
