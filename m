Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBF43042E8
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 16:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391719AbhAZPmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 10:42:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57869 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392831AbhAZPkv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 10:40:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611675562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NyKAGnu0Dzw8+jDrxr/Ep1aGiPjWBIFfIK64+l4ewV8=;
        b=H2Y9nuUQCzUdTrDypNLoCriQEALObGrXd9+eYCYPFt54z67DBrb/OLWR93EMiiNaruukMC
        6uA7RW/6HUCSuPC3oiLBALGnwO8+EQvWKK+S2N1RrMa+KSNtMGUmqXXQ1FKAmGDYm231Sb
        t6L7Q8OgxtW95FqOgYRMOrVqN66NB1Y=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-NmhzkOBeMD6GDP5zWjD7cw-1; Tue, 26 Jan 2021 10:39:20 -0500
X-MC-Unique: NmhzkOBeMD6GDP5zWjD7cw-1
Received: by mail-oo1-f71.google.com with SMTP id l5so6956502ooj.2
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 07:39:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NyKAGnu0Dzw8+jDrxr/Ep1aGiPjWBIFfIK64+l4ewV8=;
        b=E1VDXCRPLEsyRPIsZjhLHdy3x0HhwItHUxg+h5LxQualiNYXqe+lUSnk9HIlpaSFY3
         NnHzFQo1L3kR0Oanbh4YNUYIGtJpqbaJ072BjlEtgb7U+JexmgkbEa3YhfGrXRJBQ/+I
         WF+WUi4rmUPMXOgOdccq+Shw13NEKYTb+DkxvdSAk7Nq9Z4ZGw9x/msdqtcnXAWKJkDB
         L0szmVv9ky8JJ+X4zPx+THgFCJm77ilSTCUMSpGIckRFZ0pX+dPCPjlkgRCOp2VETEi7
         cunvHHIYIQwqE4q4OY14NC3nERe5jh8ndYcuEXyi2FOB/iP+72Y7RdEbZF3/jwf8yKzb
         3NDA==
X-Gm-Message-State: AOAM532RNtU/rkPOr9Nc7MXy/Rx+gv+tZd4qohjNfwam/1UP8DDLtuhQ
        oXYmQ+8T/8sOsWPvBG6uNGkDFGxnZoZzgZJY7hRqmSRye4aPr4lqtdb62itrcrTREsRQ7Ou4crb
        0VFJtex0EQWHx
X-Received: by 2002:aca:4d97:: with SMTP id a145mr136416oib.147.1611675560052;
        Tue, 26 Jan 2021 07:39:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzMbcypJ5oSFTaiecJO8qs1t+tc8ekhdrPrFMmZO8Mc/NS5EH0sSElr4VVhYtgOpU5jYyUYZA==
X-Received: by 2002:aca:4d97:: with SMTP id a145mr136400oib.147.1611675559862;
        Tue, 26 Jan 2021 07:39:19 -0800 (PST)
Received: from [192.168.1.38] (cpe-70-113-46-183.austin.res.rr.com. [70.113.46.183])
        by smtp.gmail.com with ESMTPSA id d10sm3870758ooh.32.2021.01.26.07.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 07:39:18 -0800 (PST)
From:   Wei Huang <wehuang@redhat.com>
X-Google-Original-From: Wei Huang <wei.huang2@amd.com>
Subject: Re: [PATCH v3 3/4] KVM: SVM: Add support for SVM instruction address
 check change
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, seanjc@google.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, luto@amacapital.net
References: <20210126081831.570253-1-wei.huang2@amd.com>
 <20210126081831.570253-4-wei.huang2@amd.com>
 <f8a2fbc829a553b936b8babc5c1df2b1e88f51d7.camel@redhat.com>
Message-ID: <aee0d84b-52b6-bf1e-557f-5990dfe4000d@amd.com>
Date:   Tue, 26 Jan 2021 09:39:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <f8a2fbc829a553b936b8babc5c1df2b1e88f51d7.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/26/21 5:52 AM, Maxim Levitsky wrote:
> On Tue, 2021-01-26 at 03:18 -0500, Wei Huang wrote:
>> New AMD CPUs have a change that checks #VMEXIT intercept on special SVM
>> instructions before checking their EAX against reserved memory region.
>> This change is indicated by CPUID_0x8000000A_EDX[28]. If it is 1, #VMEXIT
>> is triggered before #GP. KVM doesn't need to intercept and emulate #GP
>> faults as #GP is supposed to be triggered.
>>
>> Co-developed-by: Bandan Das <bsd@redhat.com>
>> Signed-off-by: Bandan Das <bsd@redhat.com>
>> Signed-off-by: Wei Huang <wei.huang2@amd.com>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>> ---
>>   arch/x86/include/asm/cpufeatures.h | 1 +
>>   arch/x86/kvm/svm/svm.c             | 3 +++
>>   2 files changed, 4 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index 84b887825f12..ea89d6fdd79a 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -337,6 +337,7 @@
>>   #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
>>   #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
>>   #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
>> +#define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
>>   
>>   /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
>>   #define X86_FEATURE_AVX512VBMI		(16*32+ 1) /* AVX512 Vector Bit Manipulation instructions*/
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index e5ca01e25e89..f9233c79265b 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1036,6 +1036,9 @@ static __init int svm_hardware_setup(void)
>>   		}
>>   	}
>>   
>> +	if (boot_cpu_has(X86_FEATURE_SVME_ADDR_CHK))
>> +		svm_gp_erratum_intercept = false;
>> +
> Again, I would make svm_gp_erratum_intercept a tri-state module param,
> and here if it is in 'auto' state do this.
> 

I will try to craft a param patch and see if it flies...

