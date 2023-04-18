Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6C16E5BDB
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 10:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbjDRIR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 04:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjDRIR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 04:17:28 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7E31FF0
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 01:17:26 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-54fe82d8bf5so133731117b3.3
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 01:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681805846; x=1684397846;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZZS9txSmhZNZIb+aSAgPzICIN4/6Tb7j49J+eB7HPBo=;
        b=NT6Pd7FUSoJGX7uSSOlVdrV5KJj5/SfxaSvQZ0+vxVzBpbblezzjzqsvQcpXZDHJBx
         Lqsr4I/9qc6OhOjvFGTydwADkntCS9jqFdbzn5yGouKijhS9j/pUDAA8XjB9yA6OtMxp
         3aNm13jy1RCwSIPQzm6kqwS7/6Cw9n6mvR74FyZMD2YGHtFSsldXYLT21dKuYHtoJ2Pa
         KqPfTlAzlrK8jUNKAl4WJ2yuKniI8D4dWX7lDR10hnCm8K9sgGzLy5ZdoStN4Lvlu67J
         eV9tduu4jxtFmhRH7TB3LGiqlZMIja27T0g/MObhxsASP+SdzkShJMKAQenDI/ym1mQB
         fRbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681805846; x=1684397846;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZZS9txSmhZNZIb+aSAgPzICIN4/6Tb7j49J+eB7HPBo=;
        b=AfR9kGYTiQXOkk1J4NnXIHKFg+Z3iJ8EVZVc3TmLd4uwnmdEjcwsayEop5TpUlGUOy
         2vWQw1iPqIc310Wl4VS/SFhYgN8zcUJ5wudygTMvPYL+1LwjAAzIpNZ3rDggR3vn/EfD
         g+a5rgK9Ej3zO++RyreAfaFbh/QnU5ZW9v8u1ej6p0+Iw08IYC9PjkA77WISae3hoaiA
         rGTZosyfVf9TS2Cer2eULQoC/KovBeIDRjQ/tvYRo/YqePH9dCYsYEB4ebmY10DvEgi2
         REavfNcIMseQ/wnWHgSCKHNWDcJYXm99ME0jSmDp6zMw/mYoALpiyjz5NcF/bYG43Ha0
         +a2A==
X-Gm-Message-State: AAQBX9cJkB2Ve1p4ErXBuhczfRv3+zG+FJYqrF2pN0O5H/rNnmGlz3nN
        LWObWps+vHcRortxI08MfQjVRQ==
X-Google-Smtp-Source: AKy350ZaI1KzL6tYz+MoOv6CmK41eGTirgrWh7Txf5OXD5bWFPwMVDM/yO2CC5awOxRaXD0p64nyoA==
X-Received: by 2002:a81:a157:0:b0:543:439f:3b27 with SMTP id y84-20020a81a157000000b00543439f3b27mr17365423ywg.8.1681805846094;
        Tue, 18 Apr 2023 01:17:26 -0700 (PDT)
Received: from ?IPV6:2605:ef80:8079:8dd6:3f0f:2ab3:5c15:47fa? ([2605:ef80:8079:8dd6:3f0f:2ab3:5c15:47fa])
        by smtp.gmail.com with ESMTPSA id b3-20020a81bd03000000b00545a08184fesm3589508ywi.142.2023.04.18.01.17.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 01:17:25 -0700 (PDT)
Message-ID: <3e2bf588-98cd-1c63-9dbc-ddd97e7ac8ed@linaro.org>
Date:   Tue, 18 Apr 2023 10:16:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 04/17] target/riscv: Move vector translation checks
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
 <20230417135821.609964-5-lawrence.hunter@codethink.co.uk>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230417135821.609964-5-lawrence.hunter@codethink.co.uk>
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
> From: Nazar Kazakov<nazar.kazakov@codethink.co.uk>
> 
> Move the checks out of `do_opiv{v,x,i}_gvec{,_shift}` functions
> and into the corresponding macros. This enables the functions to be
> reused in proceeding commits without check duplication.
> 
> Signed-off-by: Nazar Kazakov<nazar.kazakov@codethink.co.uk>
> ---
>   target/riscv/insn_trans/trans_rvv.c.inc | 28 +++++++++++--------------
>   1 file changed, 12 insertions(+), 16 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
