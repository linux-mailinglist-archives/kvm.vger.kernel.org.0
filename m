Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13A72CF1F3
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 17:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730687AbgLDQbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 11:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730660AbgLDQbb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 11:31:31 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676D4C0613D1
        for <kvm@vger.kernel.org>; Fri,  4 Dec 2020 08:30:51 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id y74so6716268oia.11
        for <kvm@vger.kernel.org>; Fri, 04 Dec 2020 08:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VulumupbWFfWXY5OG6YthXh9X7KfotRO1X3TG0cLq5o=;
        b=y5+pU2Jvlzjp42IYGpCP5qNRKGaODc6PcyZDCsxpgzVzZoLBcLml1Y0Li6BA6hK0W3
         fEcBJHIvtHyqaA/hlF3pt/rs11mg8N+3//4LSG2UHbY2VxiygaUMPs2LRdBIwDwhF2o8
         OjHV+5FJO7l9M7/jPQWmhDR3Y4oJE125p6gMEXYmIe5mY+SFlt/qwQ3xBvzY45zby4e0
         y4+ynES5l/P5qMMun3Sl0iEiJD6Q5wPxFW709tAQncrXVO12luIyQgBo146H92preROa
         Wg01yVycanWot+GE7o+zgFtBUhod9h+HKlQ7T9oBjsvMSUgq+76npYKdt54XGG54tb2Y
         zIjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VulumupbWFfWXY5OG6YthXh9X7KfotRO1X3TG0cLq5o=;
        b=IJdWWN45ew3fMnOzVvVRzIVj6ShmhwU6XAOrNYMuvZs+LAFDMAKna5J8/tMIYcwBEr
         5T9O6bTp51uva/gJZeqIMH1UiKBouC4qD5LYv0qiTdh8lVj8vUm4T+04QCtW3w89WKUZ
         dGq7+duT/7cYgZZifdBY7F6m8OaGYDBQGC3U8jy8XPa1fVak9J9gSLZg7iOwh0FbGqHb
         lDNW7QkdmQimcHSIB8u5DCIsjlbAVPwVyWafZFzkS7K7kcNFgK8q9SMC9DWWVxt9nace
         pKubfQIEXlySPqkt1lnOgM5U13NCwvKyHBVTvDpQAMeEoGeTkSgM3llqDRk3fH7Ma1/9
         WLCg==
X-Gm-Message-State: AOAM532Pc4Up9o8iaGZgcmlbohwFMVtBkrJR1xhA/zTKNggOtuZ/E4Ap
        rfUJHWhZx8Wf6ufiRVf/buu6KCURdHFSVKWG
X-Google-Smtp-Source: ABdhPJz16+QuenQnBN9dbsIK53H8feE252gDEsotvffzRl1Vg/apyHPKCzhHZVvg1Kj8aYfG69L7JQ==
X-Received: by 2002:aca:fd84:: with SMTP id b126mr2202995oii.85.1607099450853;
        Fri, 04 Dec 2020 08:30:50 -0800 (PST)
Received: from [172.24.51.127] (168.189-204-159.bestelclientes.com.mx. [189.204.159.168])
        by smtp.gmail.com with ESMTPSA id z188sm732654oia.32.2020.12.04.08.30.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 08:30:50 -0800 (PST)
Subject: Re: [PATCH 7/9] target/mips: Extract msa_translate_init() from
 mips_tcg_init()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201202184415.1434484-1-f4bug@amsat.org>
 <20201202184415.1434484-8-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <9a103671-d4e7-bcff-c600-931655efbd2b@linaro.org>
Date:   Fri, 4 Dec 2020 10:30:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201202184415.1434484-8-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/20 12:44 PM, Philippe Mathieu-Daudé wrote:
> Extract the logic initialization of the MSA registers from
> the generic initialization.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate.c | 35 ++++++++++++++++++++---------------
>  1 file changed, 20 insertions(+), 15 deletions(-)

Why?

> -        fpu_f64[i] = tcg_global_mem_new_i64(cpu_env, off, msaregnames[i * 2]);
> +        fpu_f64[i] = tcg_global_mem_new_i64(cpu_env, off, fregnames[i]);

Maybe fold this back to the previous patch?


r~
