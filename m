Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975F56DB8CB
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 06:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjDHEYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Apr 2023 00:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDHEYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Apr 2023 00:24:39 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFA0C67E
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 21:24:39 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-62ddb232ddaso1449840b3a.1
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 21:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680927878;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j593s7gWeDImwOKXx47FgZ1t191b0kOaCv2VqBgzHfo=;
        b=k9GBKSXKT7Oqeif0J8TnFCdbLsTbdAuEXsJeo2UKt8wqoCQsbohQ3oeu58wWpV+0QL
         xKejlZX7sf/XwYJsgqKpxef526V/15kbytRHQUN5aSJq6KzYoYXtLLoQdnpebEy9/jIn
         z7fCnRRQb/YB3nzQmvyJXgWlb6wYckgMrxMC/nE8UR/Hp6Npf3OBwYzb9ZC5OxpaM9fn
         nCNZjdfVJ/6GuRjYWWVTVRxPT2y+7yaQ/rp6VyRBAAWus/YU1wdyoNJfVa9HnJaYAZQN
         IEsNySZHbQNQW4aQ7ikdoQ/oC7+DeG/7+tiaUVNThvxWFD31rbFDxWX08mCzukadis0N
         OgPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680927878;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j593s7gWeDImwOKXx47FgZ1t191b0kOaCv2VqBgzHfo=;
        b=MbyR1M7gIIOC26u+KjcxeeGy1J+TOifzyBsECOqlmo6cctt3ZWC0PfXePWoZ/zCg8y
         IgzOsfd3IElyLYdZ51qXx8fq1Ubfzua03sRFC5651zp2NUkQzmiiemNP9nbTVIfxjQSE
         jzDdT3z3t0iyhUgkXvdQUxTMUK6WMYp1WdzE+piD3bWstJaEiTOUxsp2x5iX7+1NEs8c
         rX6pREXtz1V3UUGaqOfMarXHUrpfu80e/Rwk7rtaQYqX7G1PHYq+Urxgg04w1FGI9MWr
         uCuPP540PbKISMFjq7H93tgaoZPDIpQbu9YnEWAcBUT1W74/h4xz51pjw4WtO3wLr7hJ
         JPwQ==
X-Gm-Message-State: AAQBX9cX7Afw+9Br98fNG3toFbEWyFBCPeZAT3UgZS5E9yP4rsN/i21Y
        3Cn5IXXDMD106YHY780goK9rpg==
X-Google-Smtp-Source: AKy350axqy+F7egmMNHrrI2nRruaffbZMGETFJrrdDbyzMdtw0m3ya0bC/uNqNM1CW+ziJnuj92u7A==
X-Received: by 2002:a05:6a00:140f:b0:627:e677:bc70 with SMTP id l15-20020a056a00140f00b00627e677bc70mr4360795pfu.14.1680927878651;
        Fri, 07 Apr 2023 21:24:38 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id x5-20020aa79185000000b0062ddcad2cbesm3904629pfa.145.2023.04.07.21.24.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 21:24:38 -0700 (PDT)
Message-ID: <85d3df01-97cb-d508-587b-4bfcad945bd1@linaro.org>
Date:   Fri, 7 Apr 2023 21:24:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 05/10] hw/arm/sbsa-ref: Include missing 'sysemu/kvm.h'
 header
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        Radoslaw Biernacki <rad@semihalf.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Leif Lindholm <quic_llindhol@quicinc.com>
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-6-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405160454.97436-6-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/23 09:04, Philippe Mathieu-Daudé wrote:
> "sysemu/kvm.h" is indirectly pulled in. Explicit its
> inclusion to avoid when refactoring include/:
> 
>    hw/arm/sbsa-ref.c:693:9: error: implicit declaration of function 'kvm_enabled' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
>      if (kvm_enabled()) {
>          ^
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   hw/arm/sbsa-ref.c | 1 +
>   1 file changed, 1 insertion(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
