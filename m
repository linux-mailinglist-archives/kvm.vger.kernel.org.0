Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4A578F669
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 02:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347947AbjIAAgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 20:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233963AbjIAAgf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 20:36:35 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBA4E4F
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 17:36:32 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-26d49cf1811so981314a91.0
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 17:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693528592; x=1694133392; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jG6ZCPZiU9m+IO+qPr5q8Xh7kOdEhSQ//hb0yLOiMcg=;
        b=VJpySOPx6Ltn/eD2BxazXCV6oaXOR1o1vBlbqLAQi8O/glxvM8lnPXyuHchEEJIqpt
         c/ULbZBFAgTV9ZhoWf7mMqFT6MgNLTSUpmtSiw0YowtRNnaLBIioFIyiXIL8fzF2ULC3
         dDqNu4I1EHJH78OhVheQzYoDaL59q5eT0aZ6ug8nAzb5YWs73HFtiqMNF7/NBiUlIoNz
         wBPDt0FvC0qZQfJT1W9ztXMdAN7rboJyYTKfWg+ARzVgaIXfCPEuN4cWSuNANGK3ID+A
         qvW5Kdk7M/LXB2D4weY0SUkecO07eCTjfAb9BxAq7iYz5VICwnA4gjcIBY+dPkGNmU+/
         HEcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693528592; x=1694133392;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jG6ZCPZiU9m+IO+qPr5q8Xh7kOdEhSQ//hb0yLOiMcg=;
        b=Zg9dPS88WTEmo18tUJETTk0qSegyJmPSqfuIn13anuM+KKpD2xhnReXlbz+aGQeEX7
         Ls0rXPTAaLb+ZqyWbqzbnhik2H2Pi88IPqNe8aPLo40T4lZ+G7nQb9OraXWDhbm5LKIt
         inIsTLkyO80aUhl2EnwBZSdB4/diUMLNd0362fCfSdTz04z/WsrOHF4aYTJ99+lze2Pb
         lRHfpwITz0gDRrCwyZZWc1fBUrdEm0Pi5juQUm36FFq0qv2xc28sai5NmheQmbJVHW0E
         zSAIZAO7oBgFR7YFEacbYrrUqnkI2bdjq1W5y+g6vBf7PR55Lka9jNZP9qvjhZ3TBiAf
         zxgw==
X-Gm-Message-State: AOJu0YyxXDcNtXbDqgAWUqdiS8+gyzdk2qx7zzCoAYv0Tp2lLSLB5LGn
        lA/NTyMWFcCPgqnr38Bsm/gCE84MkoinUILGCvg=
X-Google-Smtp-Source: AGHT+IGks/9QnTWTqH9/IwKnrpQme5JKpmjQJnyjOajqJkxRfMivGUwaU6cXgMWhc2k8VbSIx7Xr6A==
X-Received: by 2002:a17:90a:c688:b0:269:3771:7342 with SMTP id n8-20020a17090ac68800b0026937717342mr911835pjt.18.1693528592332;
        Thu, 31 Aug 2023 17:36:32 -0700 (PDT)
Received: from [192.168.0.4] ([71.212.131.115])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902c20c00b001b8b1f6619asm1790758pll.75.2023.08.31.17.36.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Aug 2023 17:36:31 -0700 (PDT)
Message-ID: <4129dd8d-a626-d138-47fb-0cbb8f6ad4f4@linaro.org>
Date:   Thu, 31 Aug 2023 17:36:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] arm64: Restore trapless ptimer access
Content-Language: en-US
To:     Colton Lewis <coltonlewis@google.com>, qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        qemu-trivial@nongnu.org, qemu-stable <qemu-stable@nongnu.org>
References: <20230831190052.129045-1-coltonlewis@google.com>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230831190052.129045-1-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/31/23 12:00, Colton Lewis wrote:
> Due to recent KVM changes, QEMU is setting a ptimer offset resulting
> in unintended trap and emulate access and a consequent performance
> hit. Filter out the PTIMER_CNT register to restore trapless ptimer
> access.
> 
> Quoting Andrew Jones:
> 
> Simply reading the CNT register and writing back the same value is
> enough to set an offset, since the timer will have certainly moved
> past whatever value was read by the time it's written.  QEMU
> frequently saves and restores all registers in the get-reg-list array,
> unless they've been explicitly filtered out (with Linux commit
> 680232a94c12, KVM_REG_ARM_PTIMER_CNT is now in the array). So, to
> restore trapless ptimer accesses, we need a QEMU patch to filter out
> the register.
> 
> See
> https://lore.kernel.org/kvmarm/gsntttsonus5.fsf@coltonlewis-kvm.c.googlers.com/T/#m0770023762a821db2a3f0dd0a7dc6aa54e0d0da9
> for additional context.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Cc: qemu-stable@nongnu.org
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>



r~

> ---
>   target/arm/kvm64.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index 4d904a1d11..2dd46e0a99 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -672,6 +672,7 @@ typedef struct CPRegStateLevel {
>    */
>   static const CPRegStateLevel non_runtime_cpregs[] = {
>       { KVM_REG_ARM_TIMER_CNT, KVM_PUT_FULL_STATE },
> +    { KVM_REG_ARM_PTIMER_CNT, KVM_PUT_FULL_STATE },
>   };
>   
>   int kvm_arm_cpreg_level(uint64_t regidx)

