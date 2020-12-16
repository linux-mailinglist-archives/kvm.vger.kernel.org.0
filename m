Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E597B2DBF0F
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 11:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgLPK4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 05:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgLPK4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 05:56:04 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FE7C061794
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 02:55:24 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id r7so22739853wrc.5
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 02:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q6tJxJvk5A7h0pQGeGrow1/29+Yel8mvO8oSdG6hhNw=;
        b=QSEi6Y1GVGnXfUIxafMtZeZ4fqdChHpacHu2TTwv8DhhXZQvGdqncjVB+OSFf0LnYE
         +5XGma0cKTMHl/2E+ypd8tjy2zrenSSbg4mPte3IYg1B1EGcr8SDg+BxD/9qcCzN9XLL
         Zy42X4XwxLn7nkMCSZzeml8kou0ys2tICSJg5p8wGbdUzTA/pO3gGz8qq1F1sSctMOoi
         ytz2uDozWa61dfJ+0RM4z5neKbJZUH62oA5ovC4QjmfjEE2wSAkuVq2EOuZ6ewGjdh0m
         +LnudVPhJ67OnV9b5AoaeLDO5XCP8jEzK60ce9i85emze7pmaYjt7UikDmhsfHQoCUCS
         nmTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:cc:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q6tJxJvk5A7h0pQGeGrow1/29+Yel8mvO8oSdG6hhNw=;
        b=KE7vHEBipV+K2A3IERcY0uVx0r7LtYS+smFdDF6vaRiZeIYAkUoIF2nqiVlm8PeI9I
         3X8aP7PVGFvq+Ia65d0uOMcWM1//PDUazjYzh7XVS7kghek8nHW8QvBQj9pZ+YOrJx9E
         EO1U7L0Ud62zgBxulgLD95A1dW7O2y9QvVZrRr2REsgsfcfH9WsFAOSc1Dfv96cdCqCV
         Z9PJ/0b6oBNAUzqDMfJohQBTvP1OE+ej8rUMTO8I12CR4+EBaIIf8AJGrcWl4jtgvUFY
         nJRVFPb6ASsNwl8GhdkoryLYNefg91DzxbLQTk3s0RkBGTC/jPRukJabpVOraVjaAXIP
         XzQA==
X-Gm-Message-State: AOAM531X7ooGvRYmVlChBnTd1+0kQs/N+2k3OcFv6+8iJGboOv1+S9so
        LId2XTGOpCkWcTvVlUruHEGkX0pWNj8pqQ==
X-Google-Smtp-Source: ABdhPJxoMPnOCncEvtoBbbFdv3KzwRLhGLnbQMa/J34kg1/IUfC3Bjl+OX4GzUX3DuOFGisWwL+IGw==
X-Received: by 2002:adf:8342:: with SMTP id 60mr38242089wrd.140.1608116122727;
        Wed, 16 Dec 2020 02:55:22 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id m2sm2138273wml.34.2020.12.16.02.55.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 02:55:21 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH v2 03/24] target/mips/cpu: Introduce isa_rel6_available()
 helper
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Aurelien Jarno <aurelien@aurel32.net>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org
References: <20201215225757.764263-1-f4bug@amsat.org>
 <20201215225757.764263-4-f4bug@amsat.org>
 <508441db-8748-1b55-5f39-e6a778c0bdc0@linaro.org>
 <40e8df0f-01ab-6693-785b-257b8d3144bf@amsat.org>
Message-ID: <47f9920e-38de-448c-b471-ba3e3a1f5c3b@amsat.org>
Date:   Wed, 16 Dec 2020 11:55:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <40e8df0f-01ab-6693-785b-257b8d3144bf@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/20 12:48 AM, Philippe Mathieu-Daudé wrote:
> On 12/16/20 12:27 AM, Richard Henderson wrote:
>> On 12/15/20 4:57 PM, Philippe Mathieu-Daudé wrote:
>>> +bool isa_rel6_available(const CPUMIPSState *env)
>>> +{
>>> +    if (TARGET_LONG_BITS == 64) {
>>> +        return cpu_supports_isa(env, ISA_MIPS64R6);
>>> +    }
>>> +    return cpu_supports_isa(env, ISA_MIPS32R6);
>>> +}
>>
>> So... does qemu-system-mips64 support 32-bit cpus?
> 
> Well... TBH I never tested it :S It looks the TCG code
> is compiled with 64-bit TL registers, the machine address
> space is 64-bit regardless the CPU, and I see various
> #ifdef MIPS64 code that look dubious with 32-bit CPU.

I don't think 32-bit CPUs on 64-bit build currently work
well, see:

382     env->CP0_Status = (MIPS_HFLAG_UM << CP0St_KSU);
383 # ifdef TARGET_MIPS64
384     /* Enable 64-bit register mode.  */
385     env->CP0_Status |= (1 << CP0St_PX);
386 # endif
387 # ifdef TARGET_ABI_MIPSN64
388     /* Enable 64-bit address mode.  */
389     env->CP0_Status |= (1 << CP0St_UX);
390 # endif
391     /*
392      * Enable access to the CPUNum, SYNCI_Step, CC, and CCRes RDHWR
393      * hardware registers.
394      */
395     env->CP0_HWREna |= 0x0000000F;
396     if (env->CP0_Config1 & (1 << CP0C1_FP)) {
397         env->CP0_Status |= (1 << CP0St_CU1);
398     }
399     if (env->CP0_Config3 & (1 << CP0C3_DSPP)) {
400         env->CP0_Status |= (1 << CP0St_MX);
401     }
402 # if defined(TARGET_MIPS64)
403     /* For MIPS64, init FR bit to 1 if FPU unit is there and bit is
writable. */
404     if ((env->CP0_Config1 & (1 << CP0C1_FP)) &&
405         (env->CP0_Status_rw_bitmask & (1 << CP0St_FR))) {
406         env->CP0_Status |= (1 << CP0St_FR);
407     }
408 # endif

Or:

1018 void helper_mtc0_pwsize(CPUMIPSState *env, target_ulong arg1)
1019 {
1020 #if defined(TARGET_MIPS64)
1021     env->CP0_PWSize = arg1 & 0x3F7FFFFFFFULL;
1022 #else
1023     env->CP0_PWSize = arg1 & 0x3FFFFFFF;
1024 #endif
1025 }

1038 void helper_mtc0_pwctl(CPUMIPSState *env, target_ulong arg1)
1039 {
1040 #if defined(TARGET_MIPS64)
1041     /* PWEn = 0. Hardware page table walking is not implemented. */
1042     env->CP0_PWCtl = (env->CP0_PWCtl & 0x000000C0) | (arg1 &
0x5C00003F);
1043 #else
1044     env->CP0_PWCtl = (arg1 & 0x800000FF);
1045 #endif
1046 }
