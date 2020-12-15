Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C50C2DB78A
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 01:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbgLPABA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 19:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbgLOXXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 18:23:10 -0500
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097FEC0611E4
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:22:30 -0800 (PST)
Received: by mail-oo1-xc41.google.com with SMTP id x203so5279360ooa.9
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gAOqAEKgtDopVLswWnS4lG+9el5eIJssgOsRmeRbIUo=;
        b=MH2g5td4pqDww5l3EfNzZam2wJKmfUwjFNymXpkJbZGRAH/uH/ykE5xdFjo8mXnAgU
         PjhLcg6AsOVZBEnformDG73U4YwV96p2uafYeZ7KCmb291lNH18J1fKgoRq0CVc7sqtS
         yaS/MEcKO/0rDGIaDmJRxFr0Ji24h5wCXgx6OysuEaIT2dMNoGPWQHZJ3Rn7JlbUPbqV
         bk3Tl8gYwqeTfo/h322eW/RXYc8LZrbgJ1I1WX1A9S7PpyPhHJ/FNnnFW4/5SMD5rBKF
         OBosLg3R64DWSMGklX9ZRgkY1BsaGiQTiqi8vNbyJxGGM4miEm8JUq9vvG7yP4sVY8ni
         75FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gAOqAEKgtDopVLswWnS4lG+9el5eIJssgOsRmeRbIUo=;
        b=nmRB2fxPpPrRQIwI8j0+yHt/kVncSDycNRYk3GGgrTYkelDzdJplfMqDFWent4XFQ0
         QjWoMjSBZ2xMV5vv8ZqifYm/6kxZIlN9dfGGOL77g0n/41P1X+3EE0fGCvV1o6SfPiKo
         6/H2z7JLJlc41lz7Ca8kwB68fix7MycokvAgJSOnsJ7H3zQmQaiigysIJ6mPNbyvqmjU
         JngWTlqppPnc9dnegePBs0PnCr69mEvsd27sG1/QWVF2XR8UU+pI1qBFGB6ef/3yMMch
         teFl2PwIjYbDVdEzW814GhVlB3mI5o4Hko1usHA3BfmnTZYNm/nXMuT3fJBOaxxhmWcR
         ndzQ==
X-Gm-Message-State: AOAM5300U+UiuoyH5HveLYDn8855sFFFfvYxRXQoWthoS1uAWnZoZLwo
        yPHONvxr5JFzNxjXDXxc2YyuRA==
X-Google-Smtp-Source: ABdhPJyYb7BtNjIKViVJ3fa6Upa+QE4PTCFJtpOOi4c3nagi9JwrLGx0peUqXw4dYgEeA1nWZkEH7A==
X-Received: by 2002:a4a:c387:: with SMTP id u7mr19133338oop.89.1608074549489;
        Tue, 15 Dec 2020 15:22:29 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id v92sm91767otb.75.2020.12.15.15.22.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 15:22:28 -0800 (PST)
Subject: Re: [RFC PATCH v2 24/24] target/mips/mod-msa: Pass TCGCond argument
 to gen_check_zero_element()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
 <20201215225757.764263-25-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <0b151ab5-edb4-3cec-4c94-7f7dff43738c@linaro.org>
Date:   Tue, 15 Dec 2020 17:22:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201215225757.764263-25-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/20 4:57 PM, Philippe Mathieu-Daudé wrote:
> Simplify gen_check_zero_element() by passing the TCGCond
> argument along.
> 
> Suggested-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
> Maybe this can be named 'msa_translate.c' after all...
> ---
>  target/mips/mod-msa_translate.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
