Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AEC6E5BFF
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 10:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjDRI3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 04:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDRI32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 04:29:28 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354381BD1
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 01:29:24 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id k39so6603902ybj.8
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 01:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681806563; x=1684398563;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7mX+Bj0jEr5PxvBnFl7R7rdC3vWOEW5rSv9fIGu4QTw=;
        b=Azmnl59q4fGlJi40PQlw4+Lk9GzAb6nL7rFONCkqttsCwA/S4OQsCjD6FTB2cmrPc6
         BuBvjgACDQJOFf3n0p3a9qQx65Z7ZNFJKYnyPrvBzr4nDCP7NF7Hn44V9IovAArxNek3
         RqHJs4KYBselLyjNiXHzFOvlxKy5GBeRxsDJUg7R/TL8qlFXBCrsY5akv4pteUFxOFS5
         4lkyL7aaUR0pLqryfBLjVJL0hcDuusNt2sE3i5bVj6Ns+vukkwto8v1/VdPoA9KLoXZ7
         hgbQwz6mRMGAexO5lom4QtUnTdATsE9ZNnUUQXxGWwge/UEtZx9SWm+tanMCUQA4fbMA
         lvSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681806563; x=1684398563;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7mX+Bj0jEr5PxvBnFl7R7rdC3vWOEW5rSv9fIGu4QTw=;
        b=UtsV3PVd+TUDJTJOxh7/l1VwOdEIMd/6SYABGQAwxiLbRDf8z37L0VTzzlyc1+wbrp
         uL3I7vrbty0ghawjYsJRT4gztjeR9KnbBlFjCI4CHOhXzHTTp35DWEGDl+gUGPvmdS57
         f9yijTgw+3UanZkhA/zyZ42ZjHsPD4/9dz93+SdmKerrTYhesS24Jz8AF9QNsXKWPq/q
         OJXTzkiULObhJxpg2uVCLlupmNFCUpptB3yyy1g5UUndwsEBuk3v2TbW0SQUUDoGkqWj
         WnoefxQhcWJx/wv80ME+JH/4v0lUay9CWgSwSFKLjdvB/Dc8AIi8LKQpVCWm8jK2l1+A
         E9xA==
X-Gm-Message-State: AAQBX9f3GzMf5gTgL9JY2TYpNfhQSCTkDbGW9RnNY73VYn+4eEluk7QG
        FZlMK+sKuEEJkKrWDYJp6RetTA==
X-Google-Smtp-Source: AKy350Zebgq93TLX0XQfVLljkqUahVOlLxnE9RM5CTTMuQ+jTKwWr+v2wV9nHWXaAWRQOa1YwxQ01g==
X-Received: by 2002:a25:6741:0:b0:b8f:5639:cb8a with SMTP id b62-20020a256741000000b00b8f5639cb8amr16931435ybc.9.1681806563318;
        Tue, 18 Apr 2023 01:29:23 -0700 (PDT)
Received: from ?IPV6:2605:ef80:8079:8dd6:3f0f:2ab3:5c15:47fa? ([2605:ef80:8079:8dd6:3f0f:2ab3:5c15:47fa])
        by smtp.gmail.com with ESMTPSA id 189-20020a8117c6000000b00545a08184b1sm3632502ywx.65.2023.04.18.01.29.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 01:29:22 -0700 (PDT)
Message-ID: <2f3af482-1dce-ff3b-47d3-db3142f4cc29@linaro.org>
Date:   Tue, 18 Apr 2023 10:29:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 09/17] target/riscv: Add Zvbb ISA extension support
Content-Language: en-US
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>,
        qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org, William Salmon <will.salmon@codethink.co.uk>
References: <20230417135821.609964-1-lawrence.hunter@codethink.co.uk>
 <20230417135821.609964-10-lawrence.hunter@codethink.co.uk>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230417135821.609964-10-lawrence.hunter@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/17/23 15:58, Lawrence Hunter wrote:
> diff --git a/accel/tcg/tcg-runtime-gvec.c b/accel/tcg/tcg-runtime-gvec.c
> index ac7d28c251e..322dcc0687f 100644
> --- a/accel/tcg/tcg-runtime-gvec.c
> +++ b/accel/tcg/tcg-runtime-gvec.c
> @@ -550,6 +550,17 @@ void HELPER(gvec_ands)(void *d, void *a, uint64_t b, uint32_t desc)
>       clear_high(d, oprsz, desc);
>   }
>   
> +void HELPER(gvec_andsc)(void *d, void *a, uint64_t b, uint32_t desc)
> +{
> +    intptr_t oprsz = simd_oprsz(desc);
> +    intptr_t i;
> +
> +    for (i = 0; i < oprsz; i += sizeof(uint64_t)) {
> +        *(uint64_t *)(d + i) = *(uint64_t *)(a + i) & ~b;
> +    }
> +    clear_high(d, oprsz, desc);
> +}
> +
>   void HELPER(gvec_xors)(void *d, void *a, uint64_t b, uint32_t desc)
>   {
>       intptr_t oprsz = simd_oprsz(desc);
> diff --git a/accel/tcg/tcg-runtime.h b/accel/tcg/tcg-runtime.h
> index e141a6ab242..d0862004831 100644
> --- a/accel/tcg/tcg-runtime.h
> +++ b/accel/tcg/tcg-runtime.h
> @@ -217,6 +217,7 @@ DEF_HELPER_FLAGS_4(gvec_nor, TCG_CALL_NO_RWG, void, ptr, ptr, ptr, i32)
>   DEF_HELPER_FLAGS_4(gvec_eqv, TCG_CALL_NO_RWG, void, ptr, ptr, ptr, i32)
>   
>   DEF_HELPER_FLAGS_4(gvec_ands, TCG_CALL_NO_RWG, void, ptr, ptr, i64, i32)
> +DEF_HELPER_FLAGS_4(gvec_andsc, TCG_CALL_NO_RWG, void, ptr, ptr, i64, i32)

The accel/tcg/ patch must be separate.
And I think "andcs" is the proper name.

> +static void tcg_gen_gvec_andsc(unsigned vece, uint32_t dofs, uint32_t aofs,
> +                               TCGv_i64 c, uint32_t oprsz, uint32_t maxsz)
> +{
> +    static GVecGen2s g = {
> +        .fni8 = tcg_gen_andc_i64,
> +        .fniv = tcg_gen_andc_vec,
> +        .fno = gen_helper_gvec_andsc,
> +        .prefer_i64 = TCG_TARGET_REG_BITS == 64,
> +    };
> +
> +    g.vece = vece;
> +
> +    tcg_gen_dup_i64(vece, c, c);
> +    tcg_gen_gvec_2s(dofs, aofs, oprsz, maxsz, c, &g);
> +}

This belongs in tcg-op-gvec.c.
The .vece member should be constant as MO_64.
See tcg_gen_gvec_ands from whence you copied this.

> +static void tcg_gen_gvec_rotrs(unsigned vece, uint32_t dofs, uint32_t aofs,
> +                               TCGv_i32 shift, uint32_t oprsz, uint32_t maxsz)
> +{
> +    TCGv_i32 tmp = tcg_temp_new_i32();
> +    tcg_gen_sub_i32(tmp, tcg_constant_i32(1 << (vece + 3)), shift);
> +    tcg_gen_gvec_rotls(vece, dofs, aofs, tmp, oprsz, maxsz);
> +}

This could plausibly go into tcg-op-gvec.c as well.
To be followed up by proper backend support (which was omitted before because there were 
no users).


r~

