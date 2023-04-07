Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F197C6DA875
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 07:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238022AbjDGFJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 01:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238199AbjDGFJO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 01:09:14 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B2DAD1E;
        Thu,  6 Apr 2023 22:09:09 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j14-20020a17090a7e8e00b002448c0a8813so3055689pjl.0;
        Thu, 06 Apr 2023 22:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680844149; x=1683436149;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TeAXmDP/cFiP6WG+CpKKR4q+KTAuD3yxegfih7/mG3c=;
        b=WbMeWJvi/Dkfbtq09vrJ5yn3xM1hykOp4ZQu8Cw4qweh43UtFMCnYQ23a8+TAalCXm
         vedLVjtiD/2BnwkT3R86Lu6eeiuRJYRgOu2pShIFhYorbflcy9QcjuHalBwIUN0YLp53
         hqKL8RDn9Qn+TJJhUF8OuBDPfqc5QlGTYB9zc8VIihRCGROYujW2l4KTyuYUxBp8ULMp
         nry+XMDym5n/VIylZDgdOMZqZcZfDBG56rSz56ujWLuaRLYY6OD3uCZEr+l2L/uTHFnm
         O3I1gjIM119smsjTIvzK+CLfY3xVuVU+NP4epUbiqDRT5Fne1K5/sNGzVS6phGZRkq8d
         Wifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680844149; x=1683436149;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TeAXmDP/cFiP6WG+CpKKR4q+KTAuD3yxegfih7/mG3c=;
        b=S6ktXu7ZuAuKQR4G2C9e+t6ej8X0S7HxVdctj7ciZatK+HyhA4v9bIYxSpKSXN0uXR
         EjGpI+UYk0eEkUQUT7H+tX2uqZncYnhHI/VuoHuFV5mL9Dv+PZNyZnXmyQi+d6ewz9fm
         q6fFDPVXcf9lMNaLRLSkaZABVpHSSLExTkt+EGP2XSpBCLuBN+hkhtfkcwZuXl5RVEsH
         lqJ6Y1VmSpmK0LVD3RJTzn0/KpLqzQqC/CEKm7IOUB3DIE6uzAudfod3weejmt35Lj8y
         xyVBvFRmnGuBA0J0jLnu4TI0D+3aicFG02RV80z5zjvchVz73nIYyU+WfZ1MgmzfSqae
         TyMw==
X-Gm-Message-State: AAQBX9fZASLPb/YPc4fXLkicBWkkT30lKz+ut7GXgWo9wkEN63uOC0Zl
        sm3hd0ibshS3nsERO8osay8=
X-Google-Smtp-Source: AKy350ZxJHMRRKXRALS12Gyy3xY4le7u2vcLS2cFjO06XqDEF0tPy5MNQrmVGy5NPt7oCFIL++JF+w==
X-Received: by 2002:a05:6a20:121f:b0:e8:825a:7af5 with SMTP id v31-20020a056a20121f00b000e8825a7af5mr1620735pzf.14.1680844148869;
        Thu, 06 Apr 2023 22:09:08 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u22-20020aa78496000000b005938f5b7231sm2126176pfn.201.2023.04.06.22.09.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 22:09:07 -0700 (PDT)
Message-ID: <37a18b89-c0c3-4c88-7f07-072573ac0c92@gmail.com>
Date:   Fri, 7 Apr 2023 13:08:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH v4 05/12] KVM: x86/pmu: Error when user sets the
 GLOBAL_STATUS reserved bits
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230214050757.9623-1-likexu@tencent.com>
 <20230214050757.9623-6-likexu@tencent.com> <ZC9Zqn/+J5vaXKfo@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZC9Zqn/+J5vaXKfo@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/4/2023 7:45 am, Sean Christopherson wrote:
> On Tue, Feb 14, 2023, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> If the user space sets reserved bits when restoring the MSR_CORE_
>> PERF_GLOBAL_STATUS register, these bits will be accidentally returned
>> when the guest runs a read access to this register, and cannot be cleared
>> up inside the guest, which makes the guest's PMI handler very confused.
> 
> The changelog needs to state what the patch actually does.
> 
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/vmx/pmu_intel.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index 904f832fc55d..aaea25d2cae8 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -397,7 +397,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   			reprogram_fixed_counters(pmu, data);
>>   		break;
>>   	case MSR_CORE_PERF_GLOBAL_STATUS:
>> -		if (!msr_info->host_initiated)
>> +		if (!msr_info->host_initiated || (data & pmu->global_ovf_ctrl_mask))
> 
> This is wrong.  Bits 60:58 are reserved in IA32_PERF_GLOBAL_OVF_CTRL, but are
> ASCI, CTR_FREEZE, and LBR_FREEZE respectively in MSR_CORE_PERF_GLOBAL_STATUS.

CTR_FREEZE and LBR_FREEZE are only required for the guest CPUID.0AH: EAX[7:0]>3.
PMU support (ASCI bit) for guest SGX isn't supported either.

So for now, reusing pmu->global_ovf_ctrl_mask here is effective enough.

> 
>>   			return 1; /* RO MSR */
>>   
>>   		pmu->global_status = data;
>> -- 
>> 2.39.1
>>
