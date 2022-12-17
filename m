Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B81264FB75
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 19:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiLQSAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Dec 2022 13:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLQSAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Dec 2022 13:00:35 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1040113D18
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 10:00:34 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id gh17so13044973ejb.6
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 10:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ndLWuqAvCr/hGakOhPr7FEj9ImjoVuc+iQuTEZusliI=;
        b=LVJXXUAE3fxvSktcLLgo/S768tk26LF3SxfofL4k4/QlHqkdy5cpoGkRXcBboVvbFD
         qSUFd+tAbtMO5TP3I0oQuyBJ+o2f6MPX3EiM2Hx0ZZiSUQ+xSwVikoqKBDHVYtfwlsd8
         xqi5hcPFf/UwLpz6EgDqhr2uMoRhTJ/rGceXhgGhugowKFK1Yk8pZMis+GmkTJSva7tY
         TEH1hfMO41k/7WDYFxbJ3ldhlCpAZUHpdwRds8A8RpOTM8VuS9p+8qecohuGpND1MrzM
         BRQ9oMymWPRqH9oDLU/pFnVJoZhYGBW+kIdkQRN8PF1gNObJwCo3IYRox11CaVmF4U9+
         gStA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ndLWuqAvCr/hGakOhPr7FEj9ImjoVuc+iQuTEZusliI=;
        b=0Aa6s+TBDSv61tGjx+Q+SOeH7joMevk9E/vNRfMcB5LH9w2J92gKXKR5d4vuRYQG4v
         chs6zHL/Yx/ixixzddFzY1eB01PuYbfdEVuOEFAMgI2+5my/hXcN46DhTqdZNN7yIwcA
         BdBTC1O+kwX0QPkK7wt8/hdDn1zvZE6a2jIUr+cHIU1fJQfGaO0ltTLJA+K8SKhfQtcF
         K2JDLgmtEhwXqLJ+M8kI2Sv3kuhBlcA63jOuFPOSbDAAazC8pJeRTDJm4ZSxfHWoSHqR
         +7J6tPnIgsehhl2zjC8zNWgBbMOt+R95VrJiKtLZ5+wEr7AIWGgL8ISxHr5auz583j42
         oTQA==
X-Gm-Message-State: ANoB5pnZ3oIoHKekdyDCym1C27eUtheiJFJ/vx6sXgH+3DSUzey9HK7B
        RmclD1ZQsFSMWREDHQOBIocOxg==
X-Google-Smtp-Source: AA0mqf6YGT+U7xv4NsbHurOjK5ywmBrofBYwOxV17htJVQqhRlnzd22Do41Sk0Z1m+IMP+8TNvwbKw==
X-Received: by 2002:a17:907:1719:b0:7c0:f9ef:23a2 with SMTP id le25-20020a170907171900b007c0f9ef23a2mr51798333ejc.30.1671300032662;
        Sat, 17 Dec 2022 10:00:32 -0800 (PST)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id 21-20020a170906329500b0078d3f96d293sm2219532ejw.30.2022.12.17.10.00.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Dec 2022 10:00:31 -0800 (PST)
Message-ID: <0ba898f6-fcf5-e539-a6c6-ff665602fd9f@linaro.org>
Date:   Sat, 17 Dec 2022 19:00:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH v2 7/9] target/riscv/cpu: Restrict some sysemu-specific
 fields from CPUArchState
Content-Language: en-US
To:     qemu-devel@nongnu.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Bin Meng <bin.meng@windriver.com>, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, Greg Kurz <groug@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Bernhard Beschow <shentey@gmail.com>, qemu-riscv@nongnu.org,
        Song Gao <gaosong@loongson.cn>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Laurent Vivier <laurent@vivier.eu>,
        Alistair Francis <alistair.francis@wdc.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goate?= =?UTF-8?Q?r?= <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>
References: <20221217172907.8364-1-philmd@linaro.org>
 <20221217172907.8364-8-philmd@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221217172907.8364-8-philmd@linaro.org>
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

On 17/12/22 18:29, Philippe Mathieu-Daudé wrote:
> The 'hwaddr' type is only available / meaningful on system emulation.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/riscv/cpu.h | 17 ++++++++++-------
>   1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
> index 05fafebff7..71ea1bb411 100644
> --- a/target/riscv/cpu.h
> +++ b/target/riscv/cpu.h
> @@ -370,7 +370,7 @@ struct CPUArchState {
>       uint64_t menvcfg;
>       target_ulong senvcfg;
>       uint64_t henvcfg;
> -#endif
> +
>       target_ulong cur_pmmask;
>       target_ulong cur_pmbase;
>   
> @@ -388,6 +388,7 @@ struct CPUArchState {
>       uint64_t kvm_timer_compare;
>       uint64_t kvm_timer_state;
>       uint64_t kvm_timer_frequency;
> +#endif
>   };

Sorry this patch is not complete, as various of these fields are
in use in common emulation code (so build fails on linux-user) :/
