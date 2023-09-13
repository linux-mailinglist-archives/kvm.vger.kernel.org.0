Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E9879E2DC
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 11:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239168AbjIMJCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 05:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236929AbjIMJCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 05:02:18 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30521993
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:02:14 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3ff7d73a6feso69207325e9.1
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694595733; x=1695200533; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xe6MqFGK/ptUu+T86YHQkfsfUOxtldvwwlNPM1pFiTI=;
        b=xOLVZhJdUxzEWfUQsdSVbRzzQ/1D4FAMQAis9S7ZOLJgDmK1XUmUOsoJ2UQeDEkkTB
         4M+gCUfvMAzwOle2lLHoao+xQUNy4iQ2QgCbtKuJ76WqUMC9lVvPaU6/hv16z8gl60wL
         EmpULGq5nUQYRznRVWlaKqkBCGW9GUMp6jJpkS7nfMhkUUQJ7ZxCJG8cd+OE117WSvDH
         FT6w5v6ep7S4/uEJxTK6mdduAHRdYqrDOgYcdH5wYE0x1QVfVRwo2gPxdBCbNW0ccc7x
         b1Hv1qJiVFapj005pklokwYTsBb8yNyK0vkAbhIU05KEa1Px8MG1RS6BCLBRo2SxOB4S
         6C+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694595733; x=1695200533;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xe6MqFGK/ptUu+T86YHQkfsfUOxtldvwwlNPM1pFiTI=;
        b=aKgWt+k61E43CiypdWrT4+v8sxy6PxYzOQVB7Ous+RXlsk+lhHOmypcB7IWiY+whhJ
         1RkrWBp8tAUbFjUecVxgdxthsJDD976z+iuXzHDmDFy8ltCTUg7XWf8i2AGbe0fd9bJQ
         k/tg/q0tPzTa7gpy9lXKZ9gkX/eznRF1WbEj2Vi2+WMq1Va9u+ry9C32dFq+HRfwbqHe
         Wz0WIHm+Ilolmx40dhzixlnbEnhklnOcEvZybtO15Ex/cWscae2Mjm6CEbvfYbw0wJRB
         HInJzwtXQkbSvoVdbZE1t4yaAxtQdgGJz9clLsumeAM7RFGcXpgVBQiHthJc6Jk0JmKf
         1E1w==
X-Gm-Message-State: AOJu0YyKRDXp7sZqWvSUQMO2Oad5aQSX0Mf5JWOv1gkAmsg0u5AuuTbZ
        OfF96ti9Iu1wWNQYwdYDPAmrqw==
X-Google-Smtp-Source: AGHT+IE6yyLIhYgsfFaQXW0eEC/aUhEtR8RrznU/yaYwzA3qd8pvyYQIuLDFOKRx9JhVmh92Z0EAPA==
X-Received: by 2002:a05:600c:2802:b0:401:6800:703c with SMTP id m2-20020a05600c280200b004016800703cmr1494028wmb.21.1694595733164;
        Wed, 13 Sep 2023 02:02:13 -0700 (PDT)
Received: from [192.168.69.115] (176-131-211-241.abo.bbox.fr. [176.131.211.241])
        by smtp.gmail.com with ESMTPSA id f18-20020a7bcd12000000b00402f7e473b7sm1402592wmj.15.2023.09.13.02.02.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Sep 2023 02:02:12 -0700 (PDT)
Message-ID: <361eaa5e-67d4-bce0-679b-8faf6cb5ce32@linaro.org>
Date:   Wed, 13 Sep 2023 11:02:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [RFC PATCH v4 2/3] target/i386: Restrict system-specific features
 from user emulation
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>
References: <20230911211317.28773-1-philmd@linaro.org>
 <20230911211317.28773-3-philmd@linaro.org>
 <c33130ec-661a-a1ed-c285-eeaa52365358@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <c33130ec-661a-a1ed-c285-eeaa52365358@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/23 16:05, Paolo Bonzini wrote:
> On 9/11/23 23:13, Philippe Mathieu-Daudé wrote:
>>   /*
>>    * Only for builtin_x86_defs models initialized with 
>> x86_register_cpudef_types.
>>    */
>> @@ -6163,6 +6195,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t 
>> index, uint32_t count,
>>               }
>>               *edx = env->features[FEAT_7_0_EDX]; /* Feature flags */
>> +#ifndef CONFIG_USER_ONLY
>>               /*
>>                * SGX cannot be emulated in software.  If hardware does 
>> not
>>                * support enabling SGX and/or SGX flexible launch control,
>> @@ -6181,6 +6214,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t 
>> index, uint32_t count,
>>                       CPUID_7_0_ECX_SGX_LC))) {
>>                   *ecx &= ~CPUID_7_0_ECX_SGX_LC;
>>               }
>> +#endif
> 
> This can use a variant of x86_cpu_get_supported_cpuid that returns a 
> single register; or it can be rewritten to use x86_cpu_get_supported_cpuid.

Great suggestion, thanks!

> In general, a lot of checks for accel_uses_host_cpuid() are unnecessary, 
> and the code can be modified to not depend on either KVM or HVF.

OK.
