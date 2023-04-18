Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9556E5BEE
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 10:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjDRIU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 04:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjDRIU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 04:20:58 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E03199A
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 01:20:56 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-555bc7f6746so3183937b3.6
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 01:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681806056; x=1684398056;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5GyMFZl1wvkS+TnY6IdvXKMmJjkXVXnzXl0IPbdtSiI=;
        b=VyS+AXgIbJRAAITc+1wjWDPt+iBcTlFa+2eZBbAkQLiiXYD0SHbpCG0EtcE9abPCw/
         LrQWELZrOJcqNCPLQkQlAbLctl24zrxy8T3eBaqjFJ7B8qJcdIAK7XHxg2l5idsRgHrN
         h1UjmOvPgyK2xvfoDhfUvw7wPv+xM14HBAHygnPmGl64pFq66qfJIjE3zHH0ydAy4qeP
         yqMeZG5jwS+qLUhFHW8c/nJEHZFI7k8nrnzvTyagHWXKp5Jw5ccHPQeNO10aJ3MY4/RO
         Ah1nwx6uQEME53uIcrtn0Rvg+vtGNEda+qwQFCU+IIfivMDWZAHn9yzr+AVRYe2Aeeb9
         lT/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681806056; x=1684398056;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5GyMFZl1wvkS+TnY6IdvXKMmJjkXVXnzXl0IPbdtSiI=;
        b=CqHgNnko8wlgi3rqgOZHT8CA+84+c96eWPsIJInWn/zJM7H85Fc7uGkkl56KSEaj2l
         TJnBXss+lddNhniKEDHnH9BzVbDv5sNwhM1GI3GE2j0e1FvDL4PNfHBDBvhm5njKHwFq
         Noqt/AqsK1hMo0dsippQyNYfJplevl2FDyHllhW4zui4PyLkdKFPHNGeq53x22TyMxZK
         j3qDpZZ3FgtJhEM+rjERUXHFKW5tvItasSfakVs1UU6V6LY0O4vru680rGsK3rdTCQxw
         Z0/6jM3LlgyBTIVfk0DK0wQPjDVDd31HyGmsNsmn4ka0gZSMpVVnw04shPy5Owgs1USH
         bFbQ==
X-Gm-Message-State: AAQBX9dpHmmvX6k3vx6BuVcov0EoOoAtajVgvlXDlqjvXtk9ho1Wzk63
        dLI0KpBD0f8YJvZukfGJIigBmA==
X-Google-Smtp-Source: AKy350bRsyXvhp3DLwM8KLxcmydqNy5oZRprfmunMHvXSkKaoI+PzuwyhKig723x6daLyfnwCSWtLQ==
X-Received: by 2002:a81:9114:0:b0:54f:92b3:5459 with SMTP id i20-20020a819114000000b0054f92b35459mr19079592ywg.6.1681806055175;
        Tue, 18 Apr 2023 01:20:55 -0700 (PDT)
Received: from ?IPV6:2605:ef80:8079:8dd6:3f0f:2ab3:5c15:47fa? ([2605:ef80:8079:8dd6:3f0f:2ab3:5c15:47fa])
        by smtp.gmail.com with ESMTPSA id b1-20020a25cb01000000b00b92579d3d7csm1075334ybg.52.2023.04.18.01.20.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 01:20:54 -0700 (PDT)
Message-ID: <d897900d-9429-34ad-284d-60008c500fcd@linaro.org>
Date:   Tue, 18 Apr 2023 10:20:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 08/17] qemu/host-utils.h: Add clz and ctz functions for
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
References: <20230417135821.609964-1-lawrence.hunter@codethink.co.uk>
 <20230417135821.609964-9-lawrence.hunter@codethink.co.uk>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230417135821.609964-9-lawrence.hunter@codethink.co.uk>
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
> From: Kiran Ostrolenk<kiran.ostrolenk@codethink.co.uk>
> 
> This is for use in the RISC-V vclz and vctz instructions (implemented in
> proceeding commit).
> 
> Signed-off-by: Kiran Ostrolenk<kiran.ostrolenk@codethink.co.uk>
> ---
>   include/qemu/host-utils.h | 54 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 54 insertions(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
