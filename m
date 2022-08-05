Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160C258A5CE
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 08:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbiHEGLC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 02:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiHEGLA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 02:11:00 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7EE6462;
        Thu,  4 Aug 2022 23:10:59 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id s206so1873260pgs.3;
        Thu, 04 Aug 2022 23:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=y5Uc7o9PWYp9IW61XAc1ElNuAfAMidHdLgh8XzLPcns=;
        b=Woc+rxSGTh6ioPfFT0PT2lOFTL9fCmFNeNbzNOXybrSTTEdeiUREDhCIo6JRN4/678
         u0eE34zCvwHT0CCAwOi3CrkkKLzTAfb3JnXV8EKhWrwq/ETk08Ts7uWZqIkL1rmyoNJr
         snsKy+AOjh4m8wQ2ZWMIqwFxOSkr9nhuUUO9UKm7+N3I9kIJbhSAsOk86rNoLDQg6UMP
         1dlJJJsbdE99nbNh8/19+E4e5J38UCHSWmhp6FnLpOgD5vzmb0dt6pwdN+uabVr8FSnh
         8VxdfVea3LUxEYceq9QYBaSkqcNFBJvgZruZ667ASBvyMPbchoKG68dfBqgGj70Uaqsn
         7zCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=y5Uc7o9PWYp9IW61XAc1ElNuAfAMidHdLgh8XzLPcns=;
        b=m1EFNMoR679s1o6UrK1SvyVS4ih7EphPl5dRn4wV8JLdqcoeBVLkOFZZX44NNgQvEC
         r0yIJ4WmT7xbSEM4LyHFa7CVCJ1Ua9JEeUbslm7/bxyxfQx/vV1d150F+FkIGZJOhkow
         dJBkDCdaKrP5lWq0BjZYZ8eP/O0n/juTSf3JwGJl8iLUUakoh7q9o+6dHR9ZK42wLtDA
         ILrxZZY4Px6FEgQDF28gClXt7lLEikTlSoYoxaB28GOHblSuGxmSa4JhDKe/XoTWdilX
         SITiBR1pMPwEsT/HOlEDNupurVPoBPaJyMAxw8VG7rknuXDxMvoa7wbH0NSAN5p+cXZB
         aJ4A==
X-Gm-Message-State: ACgBeo38+AHGSegkiRLWszPQl4bWykXk7FYRO1cm0Obs5LqRSE64YKFI
        BpX0P3edQaZI9BiQUTgOl4zOBugTtmumsw==
X-Google-Smtp-Source: AA6agR5IEXMEVkbNYfh35eMT1e6HVis2QH8JZnO0yI+Fl0lDc3ZwRU0jWo7RAOB4y3RbKwmqbHd1TQ==
X-Received: by 2002:a63:f0a:0:b0:41a:6c24:1bcb with SMTP id e10-20020a630f0a000000b0041a6c241bcbmr4633636pgl.474.1659679858823;
        Thu, 04 Aug 2022 23:10:58 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j7-20020a63cf07000000b00415d873b7a2sm828793pgg.11.2022.08.04.23.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 23:10:58 -0700 (PDT)
Message-ID: <d213bbf8-85da-d275-7032-4d9989f45e48@gmail.com>
Date:   Fri, 5 Aug 2022 14:10:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH] selftests: kvm/x86: test if it checks all the bits in the
 LBR_FMT bit-field
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220804073819.76460-1-likexu@tencent.com>
 <YuxVnDif6UMcFZ5I@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <YuxVnDif6UMcFZ5I@google.com>
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

On 5/8/2022 7:26 am, Sean Christopherson wrote:
> On Thu, Aug 04, 2022, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> User space only enable guest LBR feature when the exactly supported
>> LBR format value is initialized to the MSR_IA32_PERF_CAPABILITIES.
>> The input is also invalid if only partially supported bits are set.
>>
>> Note for PEBS feature, the PEBS_FORMAT bit field is the primary concern,
>> thus if the PEBS_FORMAT input is empty, the other bits check about PEBS
>> (like PEBS_TRAP or ARCH_REG) will be ignored.
>>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
>> index 6ec901dab61e..98483947f921 100644
>> --- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
>> +++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
>> @@ -13,6 +13,7 @@
>>   
>>   #define _GNU_SOURCE /* for program_invocation_short_name */
>>   #include <sys/ioctl.h>
>> +#include <linux/bitmap.h>
>>   
>>   #include "kvm_util.h"
>>   #include "vmx.h"
>> @@ -56,7 +57,7 @@ int main(int argc, char *argv[])
>>   	const struct kvm_cpuid_entry2 *entry_a_0;
>>   	struct kvm_vm *vm;
>>   	struct kvm_vcpu *vcpu;
>> -	int ret;
>> +	int ret, bit;
>>   	union cpuid10_eax eax;
>>   	union perf_capabilities host_cap;
>>   
>> @@ -97,6 +98,12 @@ int main(int argc, char *argv[])
>>   	ret = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, 0x30);
>>   	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
>>   
>> +	/* testcase 4, reject LBR_FMT if only partially supported bits are set */
>> +	for_each_set_bit(bit, (unsigned long *)&host_cap.capabilities, 6) {
>> +		ret = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, BIT_ULL(bit));
>> +		TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
>> +	}
> 
> Rather than add another testcase and target only a subset of possible values, what
> about replacing (fixing IMO) testcase #3 with fully exhaustive approach?

Yeah, much better.

> 
> ---
> From: Sean Christopherson <seanjc@google.com>
> Date: Thu, 4 Aug 2022 12:18:15 -0700
> Subject: [PATCH] KVM: selftests: Test all possible "invalid"
>   PERF_CAPABILITIES.LBR_FMT vals
> 
> Test all possible input values to verify that KVM rejects all values
> except the exact host value.  Due to the LBR format affecting the core
> functionality of LBRs, KVM can't emulate "other" formats, so even though
> there are a variety of legal values, KVM should reject anything but an
> exact host match.
> 
> Suggested-by: Like Xu <like.xu.linux@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   .../selftests/kvm/x86_64/vmx_pmu_caps_test.c    | 17 ++++++++++++-----
>   1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> index 6ec901dab61e..069589c52f41 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> @@ -59,6 +59,7 @@ int main(int argc, char *argv[])
>   	int ret;
>   	union cpuid10_eax eax;
>   	union perf_capabilities host_cap;
> +	uint64_t val;
> 
>   	host_cap.capabilities = kvm_get_feature_msr(MSR_IA32_PERF_CAPABILITIES);
>   	host_cap.capabilities &= (PMU_CAP_FW_WRITES | PMU_CAP_LBR_FMT);
> @@ -91,11 +92,17 @@ int main(int argc, char *argv[])
>   	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, host_cap.lbr_format);
>   	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), (u64)host_cap.lbr_format);
> 
> -	/* testcase 3, check invalid LBR format is rejected */
> -	/* Note, on Arch LBR capable platforms, LBR_FMT in perf capability msr is 0x3f,
> -	 * to avoid the failure, use a true invalid format 0x30 for the test. */
> -	ret = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, 0x30);
> -	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
> +	/*
> +	 * Testcase 3, check that an "invalid" LBR format is rejected.  Only an
> +	 * exact match of the host's format (and 0/disabled) is allowed.
> +	 */
> +	for (val = 1; val <= PMU_CAP_LBR_FMT; val++) {
> +		if (val == (host_cap.capabilities & PMU_CAP_LBR_FMT))

Emm,

		if (val == host_cap.lbr_format)

to save a minor cost of logical operation.

> +			continue;
> +
> +		ret = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, val);
> +		TEST_ASSERT(!ret, "Bad LBR FMT = 0x%lx didn't fail", val);
> +	}
> 
>   	printf("Completed perf capability tests.\n");
>   	kvm_vm_free(vm);
> 
> base-commit: 93472b79715378a2386598d6632c654a2223267b
> --
> 
