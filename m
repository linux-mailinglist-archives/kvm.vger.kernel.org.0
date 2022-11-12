Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC21626738
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 06:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbiKLFvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 00:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiKLFvv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 00:51:51 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F98F24BFD
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 21:51:50 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id v17so5864328plo.1
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 21:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zyx2Y7UFHTqZ5ZNwS2MOdB+00oBk0ui1AeJ7YenU1xU=;
        b=B4X44trHHUsdpIAZesqWqwZu6+k0JmAyvc3rwn2fPCNGpSC+M++r4diqPDnOR3tmDK
         MOC6RQt5igMJMl1KgHheIFrU2jVFXdgPN6ZYWEiSIjAe+4O1jNHHvTzBuWyLF/yfULYy
         SkPwNzjF416VsA3Q1nDzmAmQ/DiYYYREVMWmrIlRoc2oL6lKNt+chp069Q1hwdmngnNj
         YW2YYifHSRGRCEmPkircESxKyzCsuO8z0ppd/4JvkzfFtbJxFd5/KxksBJ9TAf0uLZ9Q
         7kuhkAeuKohNIO7eIFI48bfFGoEDA741Lo1xZ1qoeL5LOBFZqOgdZ7LxcZdffy8+Nfzi
         2mgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zyx2Y7UFHTqZ5ZNwS2MOdB+00oBk0ui1AeJ7YenU1xU=;
        b=LLpsWCucRlFuF4j9lIy3oI4SvNb7QHL5fMV/nF/J+7i5BM0JMTSRcA8P6em3mC1pEd
         K/wGLGKGQzm5PlT7dHHk14FHCr4a2scgs7WPMS7pxH2U7QXxCjj/bWn2xnZHy3ziFi8z
         xq4zUM89gbWGQ8YJv2IC54R/OoFGwXEWmIdCyDJRrq6npAGFYU8q1yuom4wMKQuZerWk
         Ibr37SG8EB9BWv05RqYGhIwcT0g33pFIBg87axRAc08mOm2escHuOiau0LlixwD+X4Aa
         oiiiEKGnrAJlnepZe4fkJ0F8xLln7LTIjp1+W2V2RS6GNGQPtyOIMNrjbwYDEAUFvZxF
         hxbg==
X-Gm-Message-State: ANoB5pnzEGOkKVRhVOwrUHfiVeMNIYz74f0bb+SScKAL1HYvDU1/ngok
        dEwfsbmM32CsJVeiQLve1j8+Zg==
X-Google-Smtp-Source: AA0mqf6728td7W5odT18nRyDWrbnvK8oARIIPyaBzYaIXXAH/6EyLaHMmEATyt/6pPq/zbFrCUOxaQ==
X-Received: by 2002:a17:902:c142:b0:188:55f5:972f with SMTP id 2-20020a170902c14200b0018855f5972fmr5637133plj.148.1668232309564;
        Fri, 11 Nov 2022 21:51:49 -0800 (PST)
Received: from ?IPV6:2001:44b8:2176:c800:8228:b676:fb42:ee07? (2001-44b8-2176-c800-8228-b676-fb42-ee07.static.ipv6.internode.on.net. [2001:44b8:2176:c800:8228:b676:fb42:ee07])
        by smtp.gmail.com with ESMTPSA id v1-20020a17090a7c0100b001f94d25bfabsm5678563pjf.28.2022.11.11.21.51.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 21:51:48 -0800 (PST)
Message-ID: <84aa1c9e-ee2f-5368-0b32-4e3a32a6bbeb@linaro.org>
Date:   Sat, 12 Nov 2022 15:51:42 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5 15/20] hw/i386: update vapic_write to use MemTxAttrs
Content-Language: en-US
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc:     f4bug@amsat.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
References: <20221111182535.64844-1-alex.bennee@linaro.org>
 <20221111182535.64844-16-alex.bennee@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20221111182535.64844-16-alex.bennee@linaro.org>
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

On 11/12/22 04:25, Alex Bennée wrote:
> This allows us to drop the current_cpu hack and properly model an
> invalid access to the vapic.
> 
> Signed-off-by: Alex Bennée<alex.bennee@linaro.org>
> ---
>   hw/i386/kvmvapic.c | 19 +++++++++++--------
>   1 file changed, 11 insertions(+), 8 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
