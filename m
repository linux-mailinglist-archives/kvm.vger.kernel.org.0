Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C386F3915
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 22:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjEAUUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 16:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbjEAUUL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 16:20:11 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5853D30F4
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 13:20:06 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f1cfed93e2so28534585e9.3
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 13:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682972405; x=1685564405;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lDI/20T1uPRoTlQGz3PG7IVp1dlrzIcikclK+BNrn4I=;
        b=sIfdTpfepArE8sU+4NTcy7xOvbZSf/dKemW7L8ciqw+ADmIAIdfVY09A5gWMdcAqIa
         f8rGwdhE+yELNnHDBZinJXVwAhyeZ00UJYIDJWdY113pLL27ph3TlpNIgVyb9EGPymiL
         uxMKe7WOwAc13vtMHss0uV5JMzgU2d+zn5g/Olu0rdbxdkYfwYe7RSiuRfeNUDAdxTiL
         8GonL3qL1Cmm7tBPpGdY0F9ZE8YcRntMFjMPS545gKIx9R5GlwBWbcsvz/cWkAf/aF/w
         9lgfW1ABFrSPSLQQJsnHuhaxOtRal6i2Q7Zi3YxlcUodG59RlYDzpf6Nd8VOXQjAvOeR
         G40g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682972405; x=1685564405;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lDI/20T1uPRoTlQGz3PG7IVp1dlrzIcikclK+BNrn4I=;
        b=E0xggL0d9DQdgc3ucZrvlNHDwD5nHo01S+Ik0Zse3N0ghYga+hzX8k5kQMOTAS/A4R
         Bu1+CG2aDNlPuLcrEhyhU+thHAOwT/IsBxSVdrgDi4r24BaN2FHAXZHPAb/iu38+38GW
         7MjaK1EWBU2AoTnx1kf9mYNgrdzYF5Bo/kgy0gxY72PhKYRExRrF1Mbbt7+V2kYUYSN5
         G4UA8aMRf9/1Bu/kp89k4vjbWdKToWdiGUqfXpSheH/vgMlaGfQa6lHP/ekdWxos4Zao
         sCKidp3EzS10wjbGaIOdrEwqEFjQYW3UyjXvlmtaNv0hHzulerJmjbGyj3WnNDauU3h0
         L3CQ==
X-Gm-Message-State: AC+VfDy+y2vEsgtOBxZf7K9B9MU/yGurdkEaEFWDLzgMaJSjO06Q0L67
        gatE4X4jS+VhHmeeO0yOZARpYD3fdjMmOkBsDSoE8g==
X-Google-Smtp-Source: ACHHUZ7GIF5nTiYKf2V07/in+UGAFPHkWwL0e1/1SwgFp/N3K/G6yGN5/97rm7s/+Dk8kHs3SY1QsA==
X-Received: by 2002:a1c:7502:0:b0:3ee:36f:3485 with SMTP id o2-20020a1c7502000000b003ee036f3485mr11398394wmc.8.1682972404738;
        Mon, 01 May 2023 13:20:04 -0700 (PDT)
Received: from ?IPV6:2a02:c7c:74db:8d00:eca5:8bcb:58d9:c940? ([2a02:c7c:74db:8d00:eca5:8bcb:58d9:c940])
        by smtp.gmail.com with ESMTPSA id bi26-20020a05600c3d9a00b003eddc6aa5fasm32890364wmb.39.2023.05.01.13.20.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 13:20:04 -0700 (PDT)
Message-ID: <e9d647a3-c98e-7ab8-9378-74ac2d867a28@linaro.org>
Date:   Mon, 1 May 2023 21:20:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 09/19] tcg: Add andcs and rotrs tcg gvec ops
Content-Language: en-US
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>,
        qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org
References: <20230428144757.57530-1-lawrence.hunter@codethink.co.uk>
 <20230428144757.57530-10-lawrence.hunter@codethink.co.uk>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230428144757.57530-10-lawrence.hunter@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/28/23 15:47, Lawrence Hunter wrote:
> From: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
> 
> This commit adds helper functions and tcg operation definitions for the andcs and rotrs instructions
> 
> Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
> ---
>   accel/tcg/tcg-runtime-gvec.c | 11 +++++++++++
>   accel/tcg/tcg-runtime.h      |  1 +
>   include/tcg/tcg-op-gvec.h    |  4 ++++
>   tcg/tcg-op-gvec.c            | 23 +++++++++++++++++++++++
>   4 files changed, 39 insertions(+)

Queued to tcg-next as two patches, and with alterations:

> +void tcg_gen_gvec_andcs(unsigned vece, uint32_t dofs, uint32_t aofs,
> +                        TCGv_i64 c, uint32_t oprsz, uint32_t maxsz)
> +{
> +    static GVecGen2s g = {
> +        .fni8 = tcg_gen_andc_i64,
> +        .fniv = tcg_gen_andc_vec,
> +        .fno = gen_helper_gvec_andcs,
> +        .prefer_i64 = TCG_TARGET_REG_BITS == 64,
> +        .vece = MO_64
> +    };
> +
> +    tcg_gen_dup_i64(vece, c, c);
> +    tcg_gen_gvec_2s(dofs, aofs, oprsz, maxsz, c, &g);
> +}

This needed a temporary.

> +void tcg_gen_gvec_rotrs(unsigned vece, uint32_t dofs, uint32_t aofs,
> +                        TCGv_i32 shift, uint32_t oprsz, uint32_t maxsz)
> +{
> +    TCGv_i32 tmp = tcg_temp_new_i32();
> +    tcg_gen_sub_i32(tmp, tcg_constant_i32(1 << (vece + 3)), shift);
> +    tcg_gen_gvec_rotls(vece, dofs, aofs, tmp, oprsz, maxsz);
> +}

This needed the rotation count to be masked (32 - 0 == 32 is illegal).
Simplified as (-shift & mask).


r~

