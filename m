Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292834E39AE
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 08:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237544AbiCVHdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 03:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237518AbiCVHdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 03:33:17 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8EC1CFCD;
        Tue, 22 Mar 2022 00:31:50 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id v4so14960610pjh.2;
        Tue, 22 Mar 2022 00:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=r4xA4YpWvDAW9lMA2GfpmJRYpPh3E38DjIkUV0HV+uY=;
        b=XNxhv4/i9m6xgW7eDDhyYG5Ouj06COWiugANv4Hkgo/bnHhuClzi/M1F8FtdhuUz1Z
         /H3sM5jaLVfiRLC/RbTSr2MQt4XDfMmPFlyOQ2bXzz/wIGD+kba5AY4rDD04iDgxk7S0
         WL+pt8MqZ22r8E9Y/WzOT3H84OufyyXg1FW8TJCB2VssakOsljaCIFdQZHDiklMp65cD
         EG3mxmqPc6YnxE+zmv+JY/wbwJeEhliVwN5Eu8oXvTj15G5tjOkdatnEjOZA41ygJCdr
         ZzqWfUrdxqcEyTQBWAcnr580fWrRaowZuJlqGQO4mY/jqp188491P3DmC9kikYcaYYGx
         0AlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=r4xA4YpWvDAW9lMA2GfpmJRYpPh3E38DjIkUV0HV+uY=;
        b=mnPvFZxGn86s33RQuh+Fcz9Yl3IMCHYJVKH54/1RSXju5fVsV/YOA3LnRhSXh/FwH/
         KVH6cmAP15A4vORabc+jyxh4/Nk+Yuuc6g/bIAi/+X0bfqnKtuNV/SmWTAUz/b2phn8r
         lCDZpgW7XuXX8UcFPSuUr4+FtlYMJlQfnG2a7TtJPtUVurZZeHP0z6Mr/Hl+7l01Csl0
         SUHY8haU6mYeJRFdQWzX1eMfF9igQTA9CEpsCdJjGxL1OOA+gcdnx9rSpjFL+dfzxFRy
         ai3Hw+x8kVS0RV8wA/1jGl77/dF0L0427pSiJeB9POXhHmEbdOAeU9OCQHzfeUhLo1Ix
         nm7w==
X-Gm-Message-State: AOAM533715zWRndaoS7zbx6CNL8NxDTabhZbyxEvvkmDAI1XMSibLvS6
        CoQAIjXkyfA37GflXHY14zE=
X-Google-Smtp-Source: ABdhPJw37CzyUc9LRpoPZhJ7Cqz1Vq5kO/UE+2fGyOYqk66Y101+bDEBftdrZmW6wzUiUmdiS8rH7w==
X-Received: by 2002:a17:902:f683:b0:153:ee22:18b7 with SMTP id l3-20020a170902f68300b00153ee2218b7mr16451640plg.159.1647934310027;
        Tue, 22 Mar 2022 00:31:50 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id t8-20020aa79468000000b004f764340d8bsm23806525pfq.92.2022.03.22.00.31.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 00:31:49 -0700 (PDT)
Message-ID: <7c3c082c-2cad-44ae-1b66-6b1ab73dc11e@gmail.com>
Date:   Tue, 22 Mar 2022 15:31:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 7/7] kvm: x86/cpuid: Fix Architectural Performance
 Monitoring support
Content-Language: en-US
To:     Sandipan Das <sandipan.das@amd.com>
Cc:     peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com,
        acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, namhyung@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        pbonzini@redhat.com, jmattson@google.com, eranian@google.com,
        ananth.narayan@amd.com, ravi.bangoria@amd.com,
        santosh.shukla@amd.com, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org, x86@kernel.org
References: <cover.1647498015.git.sandipan.das@amd.com>
 <bc58ac02d642ea1fcbd04a525046dfe978e9f323.1647498015.git.sandipan.das@amd.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <bc58ac02d642ea1fcbd04a525046dfe978e9f323.1647498015.git.sandipan.das@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/3/2022 2:28 pm, Sandipan Das wrote:
> CPUID 0xA provides information on Architectural Performance
> Monitoring features on some x86 processors. It advertises a
> PMU version which Qemu uses to determine the availability of
> additional MSRs to manage the PMCs.
> 
> Upon receiving a KVM_GET_SUPPORTED_CPUID ioctl request for
> the same, the kernel constructs return values based on the
> x86_pmu_capability irrespective of the vendor.
> 
> This CPUID function and additional MSRs are not supported on
> AMD processors. If PerfMonV2 is detected, the PMU version is
> set to 2 and guest startup breaks because of an attempt to
> access a non-existent MSR. Return zeros to avoid this.
> 
> Fixes: a6c06ed1a60a ("KVM: Expose the architectural performance monitoring CPUID leaf")
> Reported-by: Vasant Hegde <vasant.hegde@amd.com>

The new 0003 patch introduces this issue (and more kvm issues)
due to "x86_pmu.version = 2", so this is not a fix in the strictest sense.

Btw, do you need my effort to virtualize AMD PerfMonV2 ?

> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
> ---
>   arch/x86/kvm/cpuid.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b8f8d268d058..1d9ca5726167 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -865,6 +865,11 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   		union cpuid10_eax eax;
>   		union cpuid10_edx edx;
>   
> +		if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
> +			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> +			break;
> +		}
> +
>   		perf_get_x86_pmu_capability(&cap);
>   
>   		/*
