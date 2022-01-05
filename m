Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6696485ACD
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 22:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244518AbiAEVg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 16:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbiAEVg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 16:36:57 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44A2C061245
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 13:36:57 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id q3so502647pfs.7
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 13:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7y6hmTrh+XpilH0JWrpkMEsCEa2s5PTiIKnfllY9V+w=;
        b=ef1mPGoiYNO9bFzHSdxkYWIA4OJvvdX+WlAqJ3S/pZ17k1gAJY/xEftfAw/jokvXVl
         f/g8KUxBfwLdQEtA8Fsn0mfS4H8yVSxLs2Hc/n61DxgQniR7DfJURYCVnGcK11vZ9qoF
         q4wioe8nPcgqy90aZQumTxwzZ8NuFFRKwn4LR4WC8j/ab/6/ZAm/GAbov3slaVyENPiz
         Hv2JvWb+VWqweOHiOw4OponRNQMQwuiZIswk0dnHjRKyCkdRG1sqlVTLrcFINBjGs01i
         CstWoBJtIBhXYcQxZAqEqnEoetLD2rV9KZfxjY/+4YAQhZvikB6Hm4lJjDiRpOjOffej
         DOdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7y6hmTrh+XpilH0JWrpkMEsCEa2s5PTiIKnfllY9V+w=;
        b=Yub0UcqJwChzv96hUmldqi5zCSR5PZbGe5Bm0IFxwie6UH9QVIBgjiMUuv2vba81m3
         bZC8324E1YyVXkwgchIykbBOrW2GZj/+Kg+7+gXeDZd1Fur3rub4FHtC9aI9z3qyWQfa
         b33BzS2jowqDSuy/JOfcGXduXVRSZT8f07VPucANdSauVuGG3/8gMbbp9nhbH3j9nKQm
         tNgWF5eEOyEiNcUSdL5kAYIKbE0qfYZUReuLNl60hVXhNu/P/3JUBkmx5uB7Q+XlAxV1
         j+EVkI3cEh/erUx5y24Wkf6SS+pnBMHQxHLqXFJ26byXZkwGwf3ZbpJEHy8+QbpKcfG4
         YzlQ==
X-Gm-Message-State: AOAM5325ckEPUMYxFz9E1PhlGuT/ZhwOqSlpUmwLRhxt9QtIzcoKvGkK
        KiKwm3u4+I8HNAZK7FsqLFSvtg==
X-Google-Smtp-Source: ABdhPJyJiWi/3oUbChjBti2/dNa8FFbEZUcSL4GV891fgGqCN7Z1FryDrxNwAE1UbtMDk5fFFtFtKA==
X-Received: by 2002:a05:6a00:2189:b0:4bc:3def:b662 with SMTP id h9-20020a056a00218900b004bc3defb662mr32971770pfi.5.1641418617023;
        Wed, 05 Jan 2022 13:36:57 -0800 (PST)
Received: from [192.168.1.13] (174-21-75-75.tukw.qwest.net. [174.21.75.75])
        by smtp.gmail.com with ESMTPSA id t126sm4538pgc.61.2022.01.05.13.36.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 13:36:56 -0800 (PST)
Subject: Re: [PATCH v2] hw/arm/virt: KVM: Enable PAuth when supported by the
 host
To:     Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com, Eric Auger <eric.auger@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20220103180507.2190429-1-maz@kernel.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <c5bedb8e-55e3-877f-31aa-92d59e5aba34@linaro.org>
Date:   Wed, 5 Jan 2022 13:36:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220103180507.2190429-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/3/22 10:05 AM, Marc Zyngier wrote:
> -        /*
> -         * KVM does not support modifications to this feature.
> -         * We have not registered the cpu properties when KVM
> -         * is in use, so the user will not be able to set them.
> -         */
> -        if (!kvm_enabled()) {
> -            arm_cpu_pauth_finalize(cpu, &local_err);
> -            if (local_err != NULL) {
> +	arm_cpu_pauth_finalize(cpu, &local_err);
> +	if (local_err != NULL) {
>                   error_propagate(errp, local_err);
>                   return;
> -            }
> -        }
> +	}

Looks like the indentation is off?

> +static bool kvm_arm_pauth_supported(void)
> +{
> +    return (kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
> +            kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC));
> +}

Do we really need to have them both set to play the game?  Given that the only thing that 
happens is that we disable whatever host support exists, can we have "pauth enabled" mean 
whatever subset the host has?


> @@ -521,6 +527,17 @@ bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>        */
>       struct kvm_vcpu_init init = { .target = -1, };
>   
> +    /*
> +     * Ask for Pointer Authentication if supported. We can't play the
> +     * SVE trick of synthetising the ID reg as KVM won't tell us

synthesizing

> +     * whether we have the architected or IMPDEF version of PAuth, so
> +     * we have to use the actual ID regs.
> +     */
> +    if (kvm_arm_pauth_supported()) {
> +        init.features[0] |= (1 << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
> +			     1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);

Align the two 1's.

Otherwise, it looks good.


r~
