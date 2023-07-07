Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161DA74ABAF
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 09:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjGGHQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 03:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjGGHQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 03:16:54 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F851BF4
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 00:16:51 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id 006d021491bc7-5634db21a58so1102891eaf.0
        for <kvm@vger.kernel.org>; Fri, 07 Jul 2023 00:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688714210; x=1691306210;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zv9gIjS82L5+OWY0+arteaIf4C3sR4crycr5MrZ+BUM=;
        b=AIPYH9ivrxNo/SisRpzbXbNoIge2+BjNO7ocSHZoC3BDV3AMf+ETHpbvWJhJnhnOYi
         tzuiDksOQMWb/uzUvwFscyJldHj8TAB+yIv0wRXS/dSOamj8S8SZ70x42d29F7gUKgji
         gMxZptHCEstADgK4+/+ffLd6RMBTGADond2lis9+UyNUhuTZEcEuF44MAIbZRO4Wj04T
         A6uUnIaFyC/p4Ia0Nt4MSFneZVQgCoHsUyykpDbNvhwjBjmafNB7n1T4FAJawFDiUBUl
         pSvQFqlKXbnfgYA5Myct3BgBAtjmSo2GRIlyNN3EUkDhh+yZ/bhDhA7B4udkFBOhTuVd
         28Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688714210; x=1691306210;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zv9gIjS82L5+OWY0+arteaIf4C3sR4crycr5MrZ+BUM=;
        b=ZbmRY4cFer5ZYZ9u5dA60VFUWlqCxK8Y40fQsqQBGJEf5v0/LiwgIPuiUlaa93VCRD
         lzRFRgCf/krMDFg5kb7/KPmtA6RhTP7FOrhCZyrGYDKzYFXNc6TJBcOmSsRaswOkHKYA
         wM0ROnntLo+wJ8K1onzwpcPirIDhjlAbDZhznXNrwxEpqFl5EDBxnlGOlzrpGek/7KTO
         Wi2Fhmh6A4AB8CuqCFVy/tJbr7/pQUDwOsjP1fUX/1VU30/SbsOBP7NHl+AsWCqi+u5D
         5qHQN6UfIdyHq+WsHcLqIAZ+oAn0nTlLbI9Mc6K4WU1GPThQkJKDjezeJWGUlKZoe/ZZ
         DYDw==
X-Gm-Message-State: ABy/qLaNaYIlCSo5OJ2PILhLy58nZlXKfeQ9LxtToaSdpMwi28AZ9AFf
        IcWtCfwUSqb7l7GgY8FlJDPq9w==
X-Google-Smtp-Source: APBJJlG4lud8+n8QUDPhrJlFA0hLEMwvNl/6xyDqQa5sqZ9WgCFMbPzW0buVWpAJkn7U3gJYTBA9JQ==
X-Received: by 2002:a4a:4110:0:b0:563:53fa:324f with SMTP id x16-20020a4a4110000000b0056353fa324fmr3581280ooa.6.1688714210659;
        Fri, 07 Jul 2023 00:16:50 -0700 (PDT)
Received: from [192.168.68.107] (201-69-66-19.dial-up.telesp.net.br. [201.69.66.19])
        by smtp.gmail.com with ESMTPSA id x22-20020a4ab916000000b0056082ad01desm1278956ooo.14.2023.07.07.00.16.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jul 2023 00:16:50 -0700 (PDT)
Message-ID: <fdd959fc-6630-99fe-d5ef-4b6b73998b9c@ventanamicro.com>
Date:   Fri, 7 Jul 2023 04:16:46 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] target/riscv KVM_RISCV_SET_TIMER macro is not configured
 correctly
Content-Language: en-US
To:     "yang.zhang" <gaoshanliukou@163.com>, qemu-devel@nongnu.org
Cc:     qemu-riscv@nongnu.org, palmer@dabbelt.com,
        alistair.francis@wdc.com, bin.meng@windriver.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        zhiwei_liu@linux.alibaba.com,
        "yang.zhang" <yang.zhang@hexintek.com>
References: <20230707032306.4606-1-gaoshanliukou@163.com>
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <20230707032306.4606-1-gaoshanliukou@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/7/23 00:23, yang.zhang wrote:
> From: "yang.zhang" <yang.zhang@hexintek.com>
> 
> Should set/get riscv all reg timer,i.e, time/compare/frequency/state.

Nice catch.

The reason why this went under the radar for 18 months is because kvm.c is using
an external 'time' variable.

> 
> Signed-off-by:Yang Zhang <yang.zhang@hexintek.com>
> Resolves: https://gitlab.com/qemu-project/qemu/-/issues/1688
> ---

Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>

>   target/riscv/kvm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 30f21453d6..0c567f668c 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -99,7 +99,7 @@ static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type,
>   
>   #define KVM_RISCV_SET_TIMER(cs, env, name, reg) \
>       do { \
> -        int ret = kvm_set_one_reg(cs, RISCV_TIMER_REG(env, time), &reg); \
> +        int ret = kvm_set_one_reg(cs, RISCV_TIMER_REG(env, name), &reg); \
>           if (ret) { \
>               abort(); \
>           } \
