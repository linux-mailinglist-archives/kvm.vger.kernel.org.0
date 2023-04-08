Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05EB76DB8D0
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 06:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjDHEZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Apr 2023 00:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDHEZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Apr 2023 00:25:13 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55458CA22
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 21:25:11 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id c3so764691pjg.1
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 21:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680927911;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hW/VSf7Q3/d56s71eq7R7lxXfgNg9+7clCwmfbVpN/Y=;
        b=AD0MsyTBfV0voztSlaCjS4/i8WtfCkzfpKBNK/v6C6M8jjO/kXSKCc0dYSUPMWO3/c
         mioyBcuh9dbN5ZUB4ifq0fkuqnxYXzP4KyuHu1SdBKyT3uSi3f1bxld3EEtOXumjKsrD
         UM0RuTSzyddlVlfnRFuKOYnPHAfUeu7YYbuqoc9sU7sBzUg3Mli9fq3oBFUfoZZE1gAZ
         DcaFqJU9Zw/bmGDE0gGhdAekfTlGITjw9XkE6+dYDbfIl2O2IwqTPC/l3yo+rBcoet8u
         7hWl8wsCBXfi3VcPWH1UcC+diy5cURNzdIot8UWAyQSObeTmkpMzbUhezy0KAgQ7Z4of
         5CIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680927911;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hW/VSf7Q3/d56s71eq7R7lxXfgNg9+7clCwmfbVpN/Y=;
        b=KOkqdkrEhpmpZHuLpYTs3R13jSuB1dFPLUAd4XnELPwQON5lQ+nU1fUt1fKVsbxZWj
         s4/35cSU+nik/20iVO6MrsNt75BL9ZMzU+PNWyAYB59rtr/WgedjnW3t53QjHeHX5C5p
         Ym2LtKAcpGVfz/5gexLJAu4yk/N8WLMo7rm9uFK3o8oB3EpuN8JYK7BX57pQ232NOoNs
         KCmfNiRnchK3yJdAdQ6XhTlob7EckYDS+Rrobe4txcuAJKVf3ROJZwKYiZ5H4bPwU6cr
         TaPDMUwj9+Rts9ynv/rbCJ+6pnAt9fO+EQGXoxCL1f7U5tjarGXtwwSZm8d6wRqXsElA
         avSg==
X-Gm-Message-State: AAQBX9eSe2sS90o8FGc34vMMZCPa0bwCfIXY+zyRPZd+FlOIRGgc8Wi2
        wH+Dp1Tg2Hs6J1L3sibZaci/Dg==
X-Google-Smtp-Source: AKy350ZUbQYkpHgjHTHqWPoCLiXyBP/r0ksrikXsadVUUJ0Z9+D+HwacqU3D1RBcoFMeI9Y1KRfWMw==
X-Received: by 2002:a17:90b:1c91:b0:22b:b832:d32 with SMTP id oo17-20020a17090b1c9100b0022bb8320d32mr5197335pjb.9.1680927910856;
        Fri, 07 Apr 2023 21:25:10 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id gd22-20020a17090b0fd600b002465ff5d829sm1432776pjb.13.2023.04.07.21.25.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 21:25:10 -0700 (PDT)
Message-ID: <ef9c1261-2f9c-0f22-b502-56b5f9c52618@linaro.org>
Date:   Fri, 7 Apr 2023 21:25:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 06/10] target/arm: Reduce QMP header pressure by not
 including 'kvm_arm.h'
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-7-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405160454.97436-7-philmd@linaro.org>
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
> We only need "sysemu/kvm.h" for kvm_enabled() and "cpu.h"
> for the QOM type definitions (TYPE_ARM_CPU). Avoid including
> the heavy "kvm_arm.h" header.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   target/arm/arm-qmp-cmds.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
