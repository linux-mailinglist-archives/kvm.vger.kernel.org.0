Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F46F2D35FD
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731119AbgLHWKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730552AbgLHWKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:10:30 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B46C0613CF
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 14:09:44 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id v85so219230oia.6
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 14:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0KbrxKtnPDSH8SVdj2wpe6Rfs00cjVA9d1JCosiF5Ak=;
        b=yUVzhWFQtWT+JxbJmxsNzbXW8IJCkyuzQ0vDkGrTDKLk6BbtmxvBYWa5Huhi5cTCJ6
         IfWP4xlJRbwdMkRnNu1o6nSH1kxhXmaA3b4AtWkBT24SqiyikcoCgxLQjEG5q0f/WqTi
         JFZtzZpUhfewsnWmaua9v4TwZSnYjEdAYsdZuNWR+a1BFQ/wk+ewxvZfqg2QgqXoTZqX
         +h9y2SMu7isivPscwHz7q9lVF6snLPJEp2pFYxvGF8Thplw2q4fyiS54hEqO1FMwlGDE
         dj+s0d7vlIEP1iFVcVct2OHL7l6+VLJfqod4AHSgT+/bVY0bNRYU3Q6QVVv6VnXi7HWM
         +bZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0KbrxKtnPDSH8SVdj2wpe6Rfs00cjVA9d1JCosiF5Ak=;
        b=oJZv1H3Bg1vgOQYTwvSFxK0AL/Yj+cEYQG0ew6Dqad7WjMOd3/hbKGi9o//ps0ePBq
         sLKxXaS0RGCkmKly4e2CFrSAH0vuXa7XulVnS+YGeh5N+ku9tRUlnYm3pzGe6i1gwaDg
         M8JBF70G7cTR85RQl2mXE3vFbKUILBbBlPOpRbxSjnkmTlgMY//2oQRAm1oEf7p9YT8V
         bZjYrWIVTeyH4uk71HTTnLm8J4IqIzYfCiWcj7Uqe0UEWB2WkXaBqEC3ESIwOw+xm0pX
         bZJWI2wrAoN96DQaQR1PY+RH3Clorn+HM2qeYJSFQ0pJpMRSh4u0st0ijYw8k0YXEoQm
         dFVQ==
X-Gm-Message-State: AOAM530xjvN7aOJtJXNxZLBvUsuEV2O0sey0/yPI5SzPYaejOEn2TZtf
        WznKFq1c32shZIo9kaBfxcRLEw==
X-Google-Smtp-Source: ABdhPJx/t25Z6RHBs5E4yjw12VMSZAzAQn3sf9zyr022JAZE8fy8360W6UhdGJNGOLNWHg63gkwo6g==
X-Received: by 2002:aca:60c4:: with SMTP id u187mr26076oib.42.1607465383552;
        Tue, 08 Dec 2020 14:09:43 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id v92sm13045otb.75.2020.12.08.14.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 14:09:42 -0800 (PST)
Subject: Re: [PATCH 12/19] target/mips: Rename helper.c as tlb_helper.c
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-13-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <cd601c53-216b-0c44-0dc0-3efac54ecb73@linaro.org>
Date:   Tue, 8 Dec 2020 16:09:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-13-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
> This file contains functions related to TLB management,
> rename it as 'tlb_helper.c'.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
> Maybe I missed some functions not TLB specific...
> ---
>  target/mips/{helper.c => tlb_helper.c} | 2 +-
>  target/mips/meson.build                | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>  rename target/mips/{helper.c => tlb_helper.c} (99%)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
