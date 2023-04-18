Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145EC6E5BC7
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 10:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjDRINu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 04:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbjDRINs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 04:13:48 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B849210D
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 01:13:44 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-54ee0b73e08so450124177b3.0
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 01:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681805624; x=1684397624;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3JKwN/qUxYek6HEe26fUF9qyZjpVnYj6OMo0d05nX2Y=;
        b=oMfD3EQjqcMdTkSZQ6oDh7Usj+ieVjqF8Acqg14HdzrkyYkYfPwtilewmPmvBYTy5N
         loB2BAxUl8NlPytGmv9hNTs6v0Z6w/i1qPavfJZ2hrFdiTbUQb/DNepvGx1MS/MvEGTp
         Vav0oFkqXhd/BfjrbDAsIgZxHs6iKaE7Ve/7b2IxURncD4LWV4/FZO9G6b25Ned833SO
         gczcOR24bliuOgpCA4RIlFqw8mF5VkDHsF+Ctj39POWrl97kgz2wu2QHqebVIjjcL76A
         G5GqHn4kTezJwrpayrkFJxCkI/5W1KNBUz9F6cibHgLAYzkP4i5m/X2fW4LuwEoZyive
         Wyhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681805624; x=1684397624;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3JKwN/qUxYek6HEe26fUF9qyZjpVnYj6OMo0d05nX2Y=;
        b=hNJMxMQJgoMI7PHq6T/oswjKgHwlmYSXI/usefN9xcndNm3zgTo9y6f0qG7MrwMQel
         vfiyyPmfvxfjaUK0cV8BDEzJxQXM2DQUY8lpIsUUcOECgbfEhkdoNXYcLpwRLB34n+lQ
         rRfCYoaDET/ijbvjY+uWzaNhdP+anb5wbpgjx3i307emvjwrgJQ/DNWbzgFRJUppOtsE
         TjHWsTOnnb6lzwDBDf/gSsR8baOAFFdDdStyo31mIOJ57OsYA5UWcaAaX8N3GMPXvlfZ
         l+Eh44L7j8MKKWNCKZj1PPSj7UgwcKtsruTCYsfxfsoS0ndJw2EWSZx08xuvFbry/QQL
         +4kA==
X-Gm-Message-State: AAQBX9ctY3XaupJimRKXVgEdvl5E5VbgvuUjEVg/W6c8ZC5TKYqlqmPD
        nNknmk7d/hud3Ay5FloHLYPXYy5IAdQ9Wo6q9okILU3Y
X-Google-Smtp-Source: AKy350Z0ihD3eT6sNZ25pFrOgX+fuzUmkO5tAZbn8BgzFlqKqOxzw6cGJx/irxka6r6+/PfKira2Cg==
X-Received: by 2002:a0d:cb0a:0:b0:54f:b244:fef9 with SMTP id n10-20020a0dcb0a000000b0054fb244fef9mr19164921ywd.0.1681805623974;
        Tue, 18 Apr 2023 01:13:43 -0700 (PDT)
Received: from ?IPV6:2605:ef80:8079:8dd6:3f0f:2ab3:5c15:47fa? ([2605:ef80:8079:8dd6:3f0f:2ab3:5c15:47fa])
        by smtp.gmail.com with ESMTPSA id r13-20020a81760d000000b0054f9e622741sm3612302ywc.143.2023.04.18.01.13.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 01:13:43 -0700 (PDT)
Message-ID: <b9798442-3032-d0db-08d1-f2e24f2ecd6f@linaro.org>
Date:   Tue, 18 Apr 2023 10:13:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 02/17] target/riscv: Refactor vector-vector translation
 macro
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
 <20230417135821.609964-3-lawrence.hunter@codethink.co.uk>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230417135821.609964-3-lawrence.hunter@codethink.co.uk>
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
> From: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
> 
> Factor the non SEW-specific stuff out of `GEN_OPIVV_TRANS` into
> function `opivv_trans` (similar to `opivi_trans`). `opivv_trans` will be
> used in proceeding vector-crypto commits.
> 
> Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
> ---
>   target/riscv/insn_trans/trans_rvv.c.inc | 62 +++++++++++++------------
>   1 file changed, 32 insertions(+), 30 deletions(-)

Nice code movement, so

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


> 
> diff --git a/target/riscv/insn_trans/trans_rvv.c.inc b/target/riscv/insn_trans/trans_rvv.c.inc
> index f2e3d385152..4106bd69949 100644
> --- a/target/riscv/insn_trans/trans_rvv.c.inc
> +++ b/target/riscv/insn_trans/trans_rvv.c.inc
> @@ -1643,38 +1643,40 @@ GEN_OPIWX_WIDEN_TRANS(vwadd_wx)
>   GEN_OPIWX_WIDEN_TRANS(vwsubu_wx)
>   GEN_OPIWX_WIDEN_TRANS(vwsub_wx)
>   
> +static bool opivv_trans(uint32_t vd, uint32_t vs1, uint32_t vs2, uint32_t vm,
> +                        gen_helper_gvec_4_ptr *fn, DisasContext *s)
> +{
> +    uint32_t data = 0;
> +    TCGLabel *over = gen_new_label();
> +    tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
> +    tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);

Existing nit: the first brcondi is redundant with the second, since (unsigned)x >= 0 is 
always true.


r~
