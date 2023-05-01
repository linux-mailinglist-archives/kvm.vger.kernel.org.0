Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9657B6F38CB
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 21:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjEAT5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 15:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbjEAT5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 15:57:06 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3983E40EC
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 12:56:27 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f19afc4fbfso28318475e9.2
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 12:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682970983; x=1685562983;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wv5FhFOIMCDMXLiBaFtFBk9ni6lxBGrmNWp+3EXPojc=;
        b=cJBKw//CBdR2Jvz0JITWnXzjc0ZPMUeA25eWp9sOj3AONqb6U62Cspae/LZWHHHE6z
         apytz6gAH+atr2D6sMC77w83u544VhwkFhZdpJXeU/PbwloN1pveWeKF3wr7s6hLTlIB
         8zWSFMnOpDs2W33B6dECcbuzdPt9SbkRrMNNHW1JO0oE50OJbwpr/B4ttAXvMdpB78pG
         dVMUrm961tcJXAseaXeUUgws6iepEOMnjle3IiWBXW7hDtc/iaZEfyg7xY9IK7iJBGu1
         PNqVa5B1ODDrpfXFK5er14uWW6S3L/z8aFvTmq/F5e4pqpi0fScWGCk4GIE6NCbuwcUy
         K3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682970983; x=1685562983;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wv5FhFOIMCDMXLiBaFtFBk9ni6lxBGrmNWp+3EXPojc=;
        b=DB+ERqIVsiqX2A2JvXX/+5m2W+oWJnSyM5FMYf8WqS/z5Y7mFsPU5QEwYTogo6p7kl
         KDPYY4KASPNymowK8/RGIDwRtFaxJTkUCl1CcSxrbsrvZ0Y1b+VrQimNph/M9xIlW/XB
         SLyw8lprZUUujAaxkyGk4BNJLTgDZTHnyu0aUfJXE10w4hf5ancZxwQ03pUplca0B7pe
         9foTKag2GHqOdUUSMyUTsOCh1Gnl5DzMxNNQQvmdeLKBY6OpdYUWAuLA+PTKJDMFmZW4
         4c7uHa5cvpq1r1wlrW3LYpoV5KB6+qI9pWlWmnQDe7nCDPEwvp0++JOqBVpjnvTvx/8o
         PwvA==
X-Gm-Message-State: AC+VfDwYLup79gXzic0hZqDvFb+p8zQ7J4SiL1W8VKVxIglrYe2HytsX
        AbgQWp3vRXSNKwdc/DLK7wNE4Q==
X-Google-Smtp-Source: ACHHUZ6VkHpsRHYu3R43FTk/xWOsrWQdecPeL1n+5NXFVNZFYJXUsbzgbu2fZODQB0RQUSGc9/bXVA==
X-Received: by 2002:a7b:c3c6:0:b0:3f0:7e63:e034 with SMTP id t6-20020a7bc3c6000000b003f07e63e034mr9823499wmj.29.1682970983058;
        Mon, 01 May 2023 12:56:23 -0700 (PDT)
Received: from ?IPV6:2a02:c7c:74db:8d00:eca5:8bcb:58d9:c940? ([2a02:c7c:74db:8d00:eca5:8bcb:58d9:c940])
        by smtp.gmail.com with ESMTPSA id p1-20020a05600c204100b003ef64affec7sm33280761wmg.22.2023.05.01.12.56.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 12:56:22 -0700 (PDT)
Message-ID: <bf1f3982-1848-2623-2d6b-55a249a286bb@linaro.org>
Date:   Mon, 1 May 2023 20:56:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 10/19] qemu/host-utils.h: Add clz and ctz functions for
 lower-bit integers
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
 <20230428144757.57530-11-lawrence.hunter@codethink.co.uk>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230428144757.57530-11-lawrence.hunter@codethink.co.uk>
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
> From: Kiran Ostrolenk<kiran.ostrolenk@codethink.co.uk>
> 
> This is for use in the RISC-V vclz and vctz instructions (implemented in
> proceeding commit).
> 
> Signed-off-by: Kiran Ostrolenk<kiran.ostrolenk@codethink.co.uk>
> Reviewed-by: Richard Henderson<richard.henderson@linaro.org>
> ---
>   include/qemu/host-utils.h | 54 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 54 insertions(+)

Queued to tcg-next.

r~
