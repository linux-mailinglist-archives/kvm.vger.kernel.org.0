Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C9768A311
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 20:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbjBCTc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 14:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbjBCTcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 14:32:55 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5481C7E4
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 11:32:54 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o13so6036526pjg.2
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 11:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dG0a8fJBCT/Oaur9MGeYdEB1XYw6nwH+l+QzxE964iI=;
        b=fn1GB6fVdaKh2PYPg8aH7Zug/cFJYp68g4zB8JsZTTGE1PAtqEERttXZVF9TY+Mz+z
         I+L6QKLO2rUe2ft4ifJZVRb9KNaeEM3DpL+v/KPJHD2lQw9/YBIXBcjiy7buTDhaMFpL
         FNJyIO5iyX/Xn2gO/V7UjRLeNAvUgFzXk6jYleR810oqYfg26mgRju/1N/vq0oYWwI2w
         GHng8Ef3/4w91vTLsvR3jzpSv1XAdJItYdukwnSA1ziBnxgPgQljJZgOCsa8bACB86gO
         Xiaxje3++N13730nwIXQuF4E+7od/i5lPXVFpask+9U/V2LSO9X6HSeTXA7Q3Ok+lzfX
         9M1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dG0a8fJBCT/Oaur9MGeYdEB1XYw6nwH+l+QzxE964iI=;
        b=axkQBiaR2D4h0DaDGagB8pEWD78s5tiT6Z8Ke+d53nMBy1/JNwPyDw4Knq4WZeE+OH
         VlYNCfnGxbA56+oECTK2Jd2b3EZvLg6jBss+O/oo0i1l/PRVjNFetAztS+N6ByJaWS/f
         CBGBqhl8NwJUgDBIKXGGLi+YfK1mm6eO7fawyjEJkRAlaKSaF5rpeSfOFWQnl5/3zSdA
         9YHhX6OSqP4Z1IfuSXIM+JcO5NpfFoP7Cr6Kba8edyvrZ+WLY/PooLBDq13pvKtR1ck0
         yQ2zLsIQG6BsldbkJhusfW5H6wu9k4fu68cgCm4mnFMAYxRZ1oKGRCDs/xIYlSIMsJv2
         figg==
X-Gm-Message-State: AO0yUKUzLZs5jzpXDTczQeHsd3Ve3QkNzKcCjF7xehC+/hpalMwQAa8l
        FqnTLztKmESexHci97xczT/ThQ==
X-Google-Smtp-Source: AK7set+bAmc++WLp5hJK/bVWIDHIpNinMBH1F5myAUsPiaTB3eqAeNT8R8FZIO5TwEewSZgd87Jm5A==
X-Received: by 2002:a17:902:f30c:b0:196:6215:8857 with SMTP id c12-20020a170902f30c00b0019662158857mr8311999ple.22.1675452774299;
        Fri, 03 Feb 2023 11:32:54 -0800 (PST)
Received: from [192.168.50.177] (rrcs-173-197-98-118.west.biz.rr.com. [173.197.98.118])
        by smtp.gmail.com with ESMTPSA id je6-20020a170903264600b001899c2a0ae0sm834759plb.40.2023.02.03.11.32.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 11:32:53 -0800 (PST)
Message-ID: <30a154d5-7a11-4a65-c847-c8ebff8242b5@linaro.org>
Date:   Fri, 3 Feb 2023 09:32:48 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5 1/3] arm/virt: don't try to spell out the accelerator
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
References: <20230203134433.31513-1-cohuck@redhat.com>
 <20230203134433.31513-2-cohuck@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230203134433.31513-2-cohuck@redhat.com>
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

On 2/3/23 03:44, Cornelia Huck wrote:
> Just use current_accel_name() directly.
> 
> Signed-off-by: Cornelia Huck<cohuck@redhat.com>
> ---
>   hw/arm/virt.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
