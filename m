Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA8964F642
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 01:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiLQA0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 19:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiLQA0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 19:26:32 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E158FF
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 16:26:31 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id h33so2824923pgm.9
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 16:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QUGIKvI5RD6g+0zL9jJpIZiqKf5JyREyunpyk6FTLX8=;
        b=lSFF89083LbFTgiYdF4F6NXy9DD+Nc0safShQ9bNUTO/mTIeOcG5jhmjzBj0tkYDuF
         u3LrNDjnXEQxrXCtP5sbEmcbTjw2Pfp9BfTNT2tyWAo1gYiUiXSDlOg7yBzdQKo8QKaR
         EexxABXsoR4bjWUgfkAfMPhpOF5OKokaAm71EQ5TdkFmATtfBibjqRRFuef1Cd4U5t4Y
         W4GiOIU+AnJeWnq3WOc5e/xti/fn0YIlZz+sFCimRWYMzNPbrQXJN3YhtHMMdmfREDA2
         yEexjisJTno0S1KKi2FSpbibIZcd1iiMxoVsti67ArorVegybojlVxRGIjFLKFUUj4kl
         6YBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QUGIKvI5RD6g+0zL9jJpIZiqKf5JyREyunpyk6FTLX8=;
        b=u/vAu03jHIzVXL8zic7IA61fkqw5biiSZ4rysyp6xK9rPkwz5ipuzYIBUciMZUYKli
         r3wYsO4E72yqh3ahFIvoxelya3PlRwBLb8MoaVoJlgTmBJM2H2wNFp74rLqtPkF4m/Fb
         oMOV5Bnr4VVc9JMRgoUT/fLIzHo9WGZfW5F4WQOh/Hy0P2nWwn/y28zhBBfoxoQMM8Ia
         v1NZQmCTx3lM0ggiBlRxpSzh3ZqS8q7VI9nLOITKPJOx3HlPnU3VWKYYoPIHV2geuA4w
         EO1+6DRk1TJRo8OpMTynkqIbOlxBRp0jbpR1k85Oy7GjeF+VKTuxdlTIAZMQRgqgQ8zF
         OQ1w==
X-Gm-Message-State: ANoB5pkD3Cv0YfVggsrATfjvMba7osrC355oaXojDoEBHcZhg4i3gvOK
        UWulGo6I7UdSfJTBiAAGU6h4bg==
X-Google-Smtp-Source: AA0mqf6d/DR1/W9rTpll6+Zi1WeQ0qYv20jKIJEnwKx+imxjYL9DxzGJTEPHyZ9clrCyeOwmDAbZ9w==
X-Received: by 2002:a62:6081:0:b0:572:24b7:af17 with SMTP id u123-20020a626081000000b0057224b7af17mr32214978pfb.10.1671236791061;
        Fri, 16 Dec 2022 16:26:31 -0800 (PST)
Received: from ?IPV6:2602:47:d48c:8101:c606:9489:98df:6a3b? ([2602:47:d48c:8101:c606:9489:98df:6a3b])
        by smtp.gmail.com with ESMTPSA id d15-20020aa797af000000b00577c70f00eesm2050283pfq.22.2022.12.16.16.26.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 16:26:30 -0800 (PST)
Message-ID: <c85303e7-22ee-9a14-f674-b541283661d2@linaro.org>
Date:   Fri, 16 Dec 2022 16:26:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 1/2] sysemu/kvm: Remove CONFIG_USER_ONLY guard
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20221216220738.7355-1-philmd@linaro.org>
 <20221216220738.7355-2-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20221216220738.7355-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/22 14:07, Philippe Mathieu-Daudé wrote:
> User emulation shouldn't really include this header; if included
> these declarations are guarded by CONFIG_KVM_IS_POSSIBLE.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   include/sysemu/kvm.h | 2 --
>   1 file changed, 2 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
