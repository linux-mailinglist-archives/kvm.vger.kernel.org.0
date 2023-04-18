Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7441B6E5BDF
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 10:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjDRISq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 04:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjDRISp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 04:18:45 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28858199A
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 01:18:44 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-54fa9da5e5bso247360797b3.1
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 01:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681805923; x=1684397923;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gQy922CFoQ2WCO5fbnhnFTYLRkzcnGkYrwYRZZCh+AQ=;
        b=PbqFxjjyiS2qvT2ds6oCxuLs0Oz5RVGln6zKIgofZPaFWVlEB+c0y7ph07iJEh98+a
         mb2tP2ZUPO1TIrQ8nKB4ZU3reDOfCI0ThYnvJrbFNP5U4ktxrCTF9FYRQWZIGzkwOjBX
         FM3PKWJAnPHRj2W2XVf87rTEu9hGce4MbFJBbDKADsiRDy7zaWcYv3BgHBevN39KSroa
         OBb25Sa3hFekGfhaLmvewruAkzSxWTB7F3VYUjYDDVt6nfJLolZY6mP/M2HZSC/YmmT5
         GobJElastYnLiCFANaNLz2c7RLtc5xqbhcficlMV2cM2tlFO+2RCfzP0/a+0ZurNTf3l
         b65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681805923; x=1684397923;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gQy922CFoQ2WCO5fbnhnFTYLRkzcnGkYrwYRZZCh+AQ=;
        b=JeIHohifZir7zAagq0gUuTi4ON3Y/gZxGq2tjA6mmxG19DqneoUl3xLY+0dPbMx7dh
         BKmvlxAX791AgUtVchhNKAGqsQxw7rLBhCs9Oy7kzGcHF9JfbnJkjW2fO58gv2IfCH4O
         UGweBbGxnnJO90+IR6jJN9bb5aXOWxKzR+/NgQrReA0fxPvVboNvj7hTq2TWnh4FIyd8
         fx3NfwX7RMErZbdDQJln+u1LusD0P04SjqqYUCA5UvpZaRFV5sdwaKKCQD075ldLkZzg
         1/b1dEDUpDt8rOB7ddmqpsC0BKSFlfrJEvS3wgeV1Poo0f6jV22AmAn2wskesrJVo+sQ
         23OQ==
X-Gm-Message-State: AAQBX9dsD2F0+8D9pyIz5a6OBeiJmqBXO96ZCuF4w2R0dhBd8PLMiZK8
        6DePIwHz2huZejbjr+Icm5a3cQ==
X-Google-Smtp-Source: AKy350Y1LcPjcj+nW4iqZoKroo/cpx4ZtzHlztsEmkuSvwTwtkZeS692/L8v1SAJn+jTPTWjvCP3cw==
X-Received: by 2002:a0d:e686:0:b0:54f:179:cef2 with SMTP id p128-20020a0de686000000b0054f0179cef2mr18222812ywe.19.1681805922678;
        Tue, 18 Apr 2023 01:18:42 -0700 (PDT)
Received: from ?IPV6:2605:ef80:8079:8dd6:3f0f:2ab3:5c15:47fa? ([2605:ef80:8079:8dd6:3f0f:2ab3:5c15:47fa])
        by smtp.gmail.com with ESMTPSA id bg20-20020a05690c031400b0054c0118bdb1sm3627446ywb.60.2023.04.18.01.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 01:18:42 -0700 (PDT)
Message-ID: <bd4ab670-290b-c6e0-daf4-0e5761168ce4@linaro.org>
Date:   Tue, 18 Apr 2023 10:18:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 05/17] target/riscv: Refactor translation of
 vector-widening instruction
Content-Language: en-US
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>,
        qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org
References: <20230417135821.609964-1-lawrence.hunter@codethink.co.uk>
 <20230417135821.609964-6-lawrence.hunter@codethink.co.uk>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230417135821.609964-6-lawrence.hunter@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/17/23 15:58, Lawrence Hunter wrote:
> From: Dickon Hood<dickon.hood@codethink.co.uk>
> 
> Zvbb (implemented in later commit) has a widening instruction, which
> requires an extra check on the enabled extensions.  Refactor
> GEN_OPIVX_WIDEN_TRANS() to take a check function to avoid reimplementing
> it.
> 
> Signed-off-by: Dickon Hood<dickon.hood@codethink.co.uk>
> ---
>   target/riscv/insn_trans/trans_rvv.c.inc | 52 +++++++++++--------------
>   1 file changed, 23 insertions(+), 29 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
