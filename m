Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A66470CBE
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 22:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344526AbhLJV4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 16:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237557AbhLJV4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 16:56:23 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DAFC061746;
        Fri, 10 Dec 2021 13:52:47 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id x10so16644971edd.5;
        Fri, 10 Dec 2021 13:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=totQZcpaydQwZWUaIQSbhLvVQW6W+s66JWBl127PfuU=;
        b=mb/BNCqDgsGJJQ+Q+CJpurIUCfjdXROtvt3nJcQhj9mU6gXyLDgfoiqaE5yXA2Du6m
         OYmMAxzWz3mI2zEqmUWySec9kiqWJ8HjpCt853YINZDX7LWOjB4V8t6U3PzlNule0sYI
         atVZTWV8K48rQzTvkaad4tzbAaSdk+ZYK32NWgZeSjF0iD2gtht3pV9l+FcLr81DupP+
         i55V2sCVurhti5P4GzE2Q3FXNJGXb3u0kRsmDvVzXabCfoK77Vue6A9a78gbxnwO2/ZY
         KXJ8lDmFVwG9DNmvwD39ZV1NHAaA2JUqvaKa/B0eetpXVtfaECbP7V9HgvvbjOxvWpK/
         Lctg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=totQZcpaydQwZWUaIQSbhLvVQW6W+s66JWBl127PfuU=;
        b=0w1rt4H3dpFIH2fyQvnqhuH2V9M1SN/3OxFb50snyoOJRJwf0Wniph4rvwD6yGqbR8
         tbx8CpOKVVGVC4ZdB9QG7+f0pSCRZCK1iPxc+ibTjiCisRu7wpa7L3iQVEAVO7BCq1Fq
         giZO7tSfczyV5MgRBaYNye2o2beOLfQZKe12ALD9sIB0ETWjegyu6IhQVPiu+oDFJOes
         bVhQxbuct1eg8FiIEZU08zwW32VKnUTEfByt1C0wbFUY43B6sflS9rqIGtoG7fhVAvzN
         EAYK9jfI9JhqM7UegVYT5OTC4a/OPoC6K2x5UFlBW0u3TEJCCQIDDGdA9lFKvTRzsmZ6
         ID8A==
X-Gm-Message-State: AOAM532TgZsSR+VxW35dPnrIcNyKzSHNWntfmidnEAw17U2VcHbSFNaY
        clZ2e2vJM5NZyEHn1eJ65zgETb/t3Oo=
X-Google-Smtp-Source: ABdhPJzsuLqVYXLvVJfniyixYNpxt7HvcdYEFpq/qoAsvX4ZaHom2mFafx1wLnQs6IgMhZn1EPbTWw==
X-Received: by 2002:a05:6402:1e90:: with SMTP id f16mr41936202edf.91.1639173166087;
        Fri, 10 Dec 2021 13:52:46 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id e26sm2144335edr.82.2021.12.10.13.52.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 13:52:45 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <cfed8876-332a-569b-2bad-7e1789f139e2@redhat.com>
Date:   Fri, 10 Dec 2021 22:52:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 19/19] kvm: x86: Add AMX CPUIDs support
Content-Language: en-US
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-20-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211208000359.2853257-20-yang.zhong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 01:03, Yang Zhong wrote:
> @@ -914,7 +918,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   		break;
>   	/* Intel PT */
>   	case 0x14:
> -		if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT)) {
> +		if ((function == 0x14 && !kvm_cpu_cap_has(X86_FEATURE_INTEL_PT)) ||
> +		    (function == 0x1d && !kvm_cpu_cap_has(X86_FEATURE_AMX_TILE))) {

This hunk is wrong.

>   			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>   			break;
>   		}
> @@ -924,6 +929,11 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   				goto out;
>   		}
>   		break;
> +	/* Intel AMX TILE */
> +	case 0x1d:
> +		if (!kvm_cpu_cap_has(X86_FEATURE_AMX_TILE))
> +			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> +		break;

This also needs a loop similar to the one in case 0x14; so the "break" 
goes inside the "if" and then you have

                 for (i = 1, max_idx = entry->eax; i <= max_idx; ++i) {
                         if (!do_host_cpuid(array, function, i))
                                 goto out;
                 }


Same for 0x1e, which also needs to be marked conditional.

Paolo
