Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3436F38DC
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 21:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbjEAT5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 15:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbjEAT4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 15:56:44 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C324F3C3B
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 12:56:11 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f1950f5628so27701375e9.3
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 12:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682970968; x=1685562968;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oCmDelAvzu1+Vnd99VHxz3y8P4JPL4FfVA1xysdMRwM=;
        b=X6Yp71ysWsN+j7pW3heuqFHvslSV11e81qTf0H7/9eEs0hGQj3opvaoWoLAkZnmpFj
         BShdtqbRnUsiVbVOnnpBJmpwDGnDyYBrW2mhW8Qzfywe9F4nQkrUYBaSO8FfAMhAr+Fm
         rv9RjFpTqoErVDBm+ler8Bx4sgUQ47WLzztwKSVkY6VFx0n+bbyt3hbruLR/U+/+AQx2
         CJhBMULRawlurynW1n3bwe2TIOt+qeod3oRB+LKvR+i+UcEA7+5cJQ8gyrWXXo+TKO/b
         sM1lByf2g1eZJBmiGwAvDWAvDF+XifFFAYgFR7VdchN/kyw12bHEYVbnJUJ7FDjlGNcm
         x9Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682970968; x=1685562968;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oCmDelAvzu1+Vnd99VHxz3y8P4JPL4FfVA1xysdMRwM=;
        b=kEjleQVZEEFnjDcrej13NqxjXHK/p23Q5YRRw2TFeWuktrcd3FL9iRY2J1jmtNG/Ss
         my7ebLhbxG98POWza/BKlAlsn4NNX27VxCMTzplUPV/VAmpCqRKCSi5PaAzrRgKjiOrM
         MBNvqM+T4ok+j8tPJOoNhBLBZljQd1aAFaDTjNOCXaa5tH+D7lKlwBr8iDANIhXQRCxY
         DJwcHb1AzjiTi62FQDceUooYpjvEUzD58KSiuQK5MEjpOaD0F0/YyhqLCeA0cNbfTYrG
         GGnZslf4o1ohrb9DRPQ5Cc3ig/Lkmjwmlb+u6g3eQacMXuO8IngpNZxD+sQYm6nr8duc
         TIuQ==
X-Gm-Message-State: AC+VfDzvKz2aVUGRtktB39O3QQptRXmR3r5c2bgOIH5vFekxqyNJGhcq
        1zd8kGFxTaETYSdxUu1gmGAkfg==
X-Google-Smtp-Source: ACHHUZ7PzWFmCCm6NKahCtGO48djunTzYbc6ldKoH+9nW3//Z1SzOfyg/XFN/df2X/OC5AbR0nfyKw==
X-Received: by 2002:a05:600c:378e:b0:3f0:a9b1:81e0 with SMTP id o14-20020a05600c378e00b003f0a9b181e0mr11383602wmr.19.1682970968562;
        Mon, 01 May 2023 12:56:08 -0700 (PDT)
Received: from ?IPV6:2a02:c7c:74db:8d00:eca5:8bcb:58d9:c940? ([2a02:c7c:74db:8d00:eca5:8bcb:58d9:c940])
        by smtp.gmail.com with ESMTPSA id c16-20020a05600c0ad000b003f198dfbbfcsm27447015wmr.19.2023.05.01.12.56.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 12:56:08 -0700 (PDT)
Message-ID: <0b9a1b74-a4a3-5268-0200-60e9b8343a79@linaro.org>
Date:   Mon, 1 May 2023 20:56:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 08/19] qemu/bitops.h: Limit rotate amounts
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
 <20230428144757.57530-9-lawrence.hunter@codethink.co.uk>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230428144757.57530-9-lawrence.hunter@codethink.co.uk>
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
> From: Dickon Hood<dickon.hood@codethink.co.uk>
> 
> Rotates have been fixed up to only allow for reasonable rotate amounts
> (ie, no rotates >7 on an 8b value etc.)  This fixes a problem with riscv
> vector rotate instructions.
> 
> Signed-off-by: Dickon Hood<dickon.hood@codethink.co.uk>
> Reviewed-by: Richard Henderson<richard.henderson@linaro.org>
> ---
>   include/qemu/bitops.h | 24 ++++++++++++++++--------
>   1 file changed, 16 insertions(+), 8 deletions(-)

Queued to tcg-next.


r~
