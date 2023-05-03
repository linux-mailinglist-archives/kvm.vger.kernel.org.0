Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0211C6F5004
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 08:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjECGWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 02:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjECGW3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 02:22:29 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0D42680
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 23:22:27 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-2f55ffdbaedso2854132f8f.2
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 23:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683094946; x=1685686946;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=URVvd6LZkHtxztE8g0C8uujiBA12o3uEcBI+tRbKwIY=;
        b=HfADeA4Cotj+FkkvsK1OIGGVbNc+9gNdoGznpOL2zY7guFQETLuLPykVhzqxknojGG
         +o2SQYsePV59rozQgiWYDaqR3UcyJQmyFX8jt6h5xQCXRbkF/GrR1pntnRff9vRTXSwU
         iWY2A1usDvOpi9wC2G7yNhtSyXADakRblVHe5ZU3uaKLUoWD9PnT9ZnElom321S4CPJh
         0Xbb9/63admqUw4REGeWVcIrgGwTVd6Jg0Ofcefg08umkvICV3VEoNMAo04POz1MO4y9
         JLid3Isn8UJwT/KzoouMcktg8LZoVUmEM8KNAYH6BGeRDK9/XXxKe1qNqSwX5BAH3yQd
         Y35w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683094946; x=1685686946;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=URVvd6LZkHtxztE8g0C8uujiBA12o3uEcBI+tRbKwIY=;
        b=lE+XLG7jhtYt6Ryrb3dYa5kTgAaA8xomUA25KioW3z7NPOaqGg4cZU0H6d1x8QUk83
         ZQxSA+7sH6T341Iwwx6IRK/VjadWMWzod0W8hpsE0aoTerOFqzUQ6k0/EkNBUHyGCFNl
         OCCknyYgjWzJYEY9xPNDtc0xpIHQzdmaYshmymPw1l2bIMLVzVZWsux5neh7iiFBUOgJ
         SrABNUPB9lNEYeLBmU181eua3fHvGubzWmIA6yUfWarB15X5Ymd6TIOpQHHRGc2Sxrpd
         Y/rXvULeJPn7HTDUCKKioFd0MMLhinApLq8UJGMqgd5MUBuEy9ukU2F7hkL7XNDBOn5q
         xAag==
X-Gm-Message-State: AC+VfDwa+dDR0bf5y9EkTtU10t/R0/Wg2disFxJHSS9Kvgdj3uScXn4h
        4yw4iz1EekdXs0drmFrEHs0aeg==
X-Google-Smtp-Source: ACHHUZ5O6gAZXLMAlS3k1qLFGo4ahPMocavK5zggVezCtd3vD0bUxF7NCwl4tQcQ3yu4P9ENosihxA==
X-Received: by 2002:a5d:6dca:0:b0:306:29b6:b389 with SMTP id d10-20020a5d6dca000000b0030629b6b389mr6906507wrz.64.1683094945971;
        Tue, 02 May 2023 23:22:25 -0700 (PDT)
Received: from ?IPV6:2a02:c7c:74db:8d00:c01d:9d74:b630:9087? ([2a02:c7c:74db:8d00:c01d:9d74:b630:9087])
        by smtp.gmail.com with ESMTPSA id y4-20020adffa44000000b002f013fb708fsm33188926wrr.4.2023.05.02.23.22.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 23:22:25 -0700 (PDT)
Message-ID: <20e8f2ee-5612-251f-62b2-20ab75345d59@linaro.org>
Date:   Wed, 3 May 2023 07:22:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH RFC v2 7/9] target/loongarch: Implement
 kvm_arch_handle_exit
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn, "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        philmd@linaro.org, peter.maydell@linaro.org
References: <20230427072645.3368102-1-zhaotianrui@loongson.cn>
 <20230427072645.3368102-8-zhaotianrui@loongson.cn>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230427072645.3368102-8-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/23 08:26, Tianrui Zhao wrote:
> Implement kvm_arch_handle_exit for loongarch. In this
> function, the KVM_EXIT_LOONGARCH_IOCSR is handled,
> we read or write the iocsr address space by the addr,
> length and is_write argument in kvm_run.
> 
> Signed-off-by: Tianrui Zhao<zhaotianrui@loongson.cn>
> ---
>   target/loongarch/kvm.c        | 24 +++++++++++++++++++++++-
>   target/loongarch/trace-events |  1 +
>   2 files changed, 24 insertions(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
