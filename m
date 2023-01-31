Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4777068362D
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 20:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjAaTLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 14:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjAaTLU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 14:11:20 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85FD59B6F
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 11:10:59 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id t7so6834599wrp.5
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 11:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LWQaPUHdvnU65mQKid3pXmNQLFqWKjlrZ1lOgMgLH+s=;
        b=KRhy5frvJMVHgXhqQrlHounxae4upCd0hrESJBpOq5WU1qL7Uzbhat0uhXVNpYQhTz
         b9qVSdLZ7CueM1UBOwhymX1jMWKQRypoS5c49CeHKgAAs0dE/qDA2mMfiuYW7kV7eqws
         ZKoyZjP0TA6ytqwMBYJJowiBgQrWiNRHmF+5aVU9vCeaXd1WYmsLVZAoKeT83z4U0lHX
         cWCyQO8vleafzBGlRQE+ooU7gCuD8T/cDGFxZizak+VXnZ6mQLG4TZUMrXCnh3rJFxaW
         kx7wJk4eKPBG5/kU4Qj+wA0ZtXg4vcfuLvbKiOeskhSuOjFGtXbeAxc6Rj7ywThFIYOE
         7AQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LWQaPUHdvnU65mQKid3pXmNQLFqWKjlrZ1lOgMgLH+s=;
        b=wss1x4LQ3Gry4JjBv0frg9KJnUcKZMoKWg9R+ADB6YQwl5rqr4istzVr1ASEkoMWqW
         XKj18WDzj+2OlpxjivuHJdsAsgnjrkukho5rLi1DvU/XntdCOZV7/2gql44lckaKzia+
         qIBHjfG4hmZgGGFTq4Z3WCUE+OEh0huYoE3e7tlJeGIfQYN2BsF7izUgdUobHcmwdY3q
         Ie9l+qcBftGcLFKZGfcY//V/44ABX3bpxE8/LCsTZY8w+fQTYRt/KGHj2yQ4UPmbNYD3
         Rb+MuS5FOQ9MtbnbQH0twd+NBAjdKS/+YPQ5Lkr1iepiaF47nMwSa7sNiHeB3da6tBiE
         k0jA==
X-Gm-Message-State: AO0yUKX0vG6eTQjWRzvJmxDH8Jo4Huz33NMoBweo+/2Pi7Q9JyARQiBt
        1pfc/v5zq30E3SQNggpzOjU4yw==
X-Google-Smtp-Source: AK7set8y+W5CT0CBXGADEv6jw70U8BiynRGR11vPErBj7/6RMyebIrDMuBfwqBhI7I+SzvnxeImg9A==
X-Received: by 2002:a5d:6b89:0:b0:2bf:b571:1f18 with SMTP id n9-20020a5d6b89000000b002bfb5711f18mr74635wrx.61.1675192255852;
        Tue, 31 Jan 2023 11:10:55 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id j9-20020a5d6189000000b002c285b4d2b5sm2516469wru.101.2023.01.31.11.10.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 11:10:55 -0800 (PST)
Message-ID: <ce9eb95b-bff6-c042-efbc-b42062d7cbf2@linaro.org>
Date:   Tue, 31 Jan 2023 20:10:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] .gitignore: Keep track of archived files as they are
 added to a new git repo
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Shuah Khan <shuah@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
        Wedson Almeida Filho <wedsonaf@google.com>,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Kees Cook <keescook@chromium.org>, Andrew Davis <afd@ti.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
References: <20230130090426.13864-1-likexu@tencent.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230130090426.13864-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/01/2023 10:04, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> With thousands of commits going into mainline each development cycle,
> the metadata .git folder size is gradually expanding (1GB+), and for some
> developers (most likely testers) who don't care about the lengthy git-log,
> they just use git-archive to distribute a certain version of code (~210MB)
> and rebuild git repository from anywhere for further code changes, e.g.
> 
>   $ git init && git add . -A
> 
> Then unfortunately, the file tracking metadata from the original git-repo
> using "git add -f" will also be lost, to the point where part of source
> files wrapped by git-archive may be accidentally cleaned up:
> 
>   $ git clean -nxdf
>   Would remove Documentation/devicetree/bindings/.yamllint

https://lore.kernel.org/all/20230127150225.18148-1-andriy.shevchenko@linux.intel.com/

Best regards,
Krzysztof

