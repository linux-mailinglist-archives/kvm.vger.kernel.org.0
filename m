Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E70688504
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 18:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbjBBRC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 12:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbjBBRCf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 12:02:35 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0F05EF85
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 09:02:34 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id n13so2456675plf.11
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 09:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=25OMBhvzobX9Htf6nIvHkxSG+HgBD1Jh2RP3Tr+fZ4o=;
        b=YncBkj0gS+3gbyhm5/4AVS33n9ot8c9hNuRXQ/EBsgK54CnYPFHr/GAdPlcCMdqM7I
         uzyJFAD3CxXsVPehA5TNpyuo6PZVkuzFxXzosPitBMZmMNbhpPINTXlaxfPrtDx2bY/R
         BcwVwXwPJpAukMAZlED6owzYiw8ccV8Xf7fHAMBhooR2eHwRhpwP/3x0gWxR6Pdkj822
         iiIKnCeiAzoH5dicRKusP/B9Hi0xhFfUMPp0NjTNSgLjVJfN9TwhcwP7wB04wM9wKOC/
         zLbSyGSweg9ckKgNkPYS5t9NwXFUGyUnDAC6eFv+b0LS2lOK44Qwi3r/XHXh1e8dFq/9
         JPIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=25OMBhvzobX9Htf6nIvHkxSG+HgBD1Jh2RP3Tr+fZ4o=;
        b=BcY+ojipE8x68lThRe84j3OZ98/B5DZzfm2urfSCRVrCkHxLXmN27y3mEo804YXWT1
         eM4+CXIwfteVkT+vk6XuKu9cAMJ3AVnBr73GwWs9AhZEZRu6NjDw/elIz28NuiOC3el+
         SQRCJzCHn5zb9T2zBFzzLwdxZUz/yY/hcIfk0OLUgJsTNAh0GE5Pqd2KH/pG8/l5oYxL
         uK2L/zJ4od+QHvA5U8Ux9hK3FfIxvt91mwfxoeigPbF9r99hvUVuHKgAs9Xx0EwxkYj+
         22fFYloMNChZrPSPxrFjzxyEncQoS34pUr+zAmT6TMwL4d38RWk/sKjwMk2U9902ucav
         pgCA==
X-Gm-Message-State: AO0yUKUeVPT4AZGjiwRGTiGSZ59LrlglEuE1GW3B+Q8axYsjZWX3kuu5
        rzSYBgZDqj+CfgLe4lkaI6zfXg==
X-Google-Smtp-Source: AK7set/Ar8BgH5wCFNPhuwHL1+zq75+MnYHSpfu5sU+1sq8PoFfaJkgo0oJz0YJ7vLrjBV6hDUWDtg==
X-Received: by 2002:a17:902:c611:b0:196:35cf:3b08 with SMTP id r17-20020a170902c61100b0019635cf3b08mr6060969plr.36.1675357353725;
        Thu, 02 Feb 2023 09:02:33 -0800 (PST)
Received: from [192.168.50.194] (rrcs-173-197-98-118.west.biz.rr.com. [173.197.98.118])
        by smtp.gmail.com with ESMTPSA id g13-20020a170902d5cd00b00186b7443082sm1053090plh.195.2023.02.02.09.02.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 09:02:33 -0800 (PST)
Message-ID: <7da5cc9a-bf7d-a045-f253-bed4d7f2bf12@linaro.org>
Date:   Thu, 2 Feb 2023 07:02:29 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 35/39] crypto: Move SM4_SBOXWORD from target/riscv
Content-Language: en-US
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>,
        qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        Max Chou <max.chou@sifive.com>
References: <20230202124230.295997-1-lawrence.hunter@codethink.co.uk>
 <20230202124230.295997-36-lawrence.hunter@codethink.co.uk>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230202124230.295997-36-lawrence.hunter@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/2/23 02:42, Lawrence Hunter wrote:
> From: Max Chou <max.chou@sifive.com>
> 
>      - Share SM4_SBOXWORD between target/riscv and target/arm.
> 
> Signed-off-by: Max Chou <max.chou@sifive.com>
> Reviewed-by: Frank Chang <frank.chang@sifive.com>
> ---
>   include/crypto/sm4.h       |  7 +++++++
>   target/arm/crypto_helper.c | 10 ++--------
>   2 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/include/crypto/sm4.h b/include/crypto/sm4.h
> index 9bd3ebc62e..33478562a4 100644
> --- a/include/crypto/sm4.h
> +++ b/include/crypto/sm4.h
> @@ -1,6 +1,13 @@
>   #ifndef QEMU_SM4_H
>   #define QEMU_SM4_H
>   
> +#define SM4_SBOXWORD(WORD) ( \
> +    sm4_sbox[((WORD) >> 24) & 0xff] << 24 | \
> +    sm4_sbox[((WORD) >> 16) & 0xff] << 16 | \
> +    sm4_sbox[((WORD) >>  8) & 0xff] <<  8 | \
> +    sm4_sbox[((WORD) >>  0) & 0xff] <<  0   \
> +)
> +
>   extern const uint8_t sm4_sbox[256];

I think this would be better as an inline function, so that the types are clear.


r~

