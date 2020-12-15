Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82A42DB78F
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 01:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbgLPABF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 19:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727620AbgLOX1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 18:27:49 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD4AC0613D3
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:27:09 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id q25so21132530otn.10
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XDfoxJCCpDbacQkWnloypj9F6s2lXWwcFcK4re2HepI=;
        b=q8wH064EpTkJzoKWQzMSQwmzsM65PGf8escpU6wgiAU9CVaiA4TV1kavjCj+J3K53L
         CBQD1x7h1R0UvE0OMf6lq5si57r4RzNhUsQrnFknQ6eMdIfE8UqPZKdXrml8hD/cwO9x
         RCXSy5JRsVoPQ0QH2cFx7wkiu2HbJZzoTOuEk1FcAkIgciwr34SFdB1QkpEn0Y8dOcIX
         keRMdETquCmzdbxJvUkxzMGPQ03FNURl5XBUmALpRFdBYFPRm5pC6vKbUDCl8khvd1ww
         XKo8EZfM5KQwVFMjAhniZGj8qxkTrsNkujm5p7rgqnyDW08UO9uim+RHJmhhKE/uh9xS
         Ouuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XDfoxJCCpDbacQkWnloypj9F6s2lXWwcFcK4re2HepI=;
        b=tV1jJ4lLIIMmWmUXN3zyVB+hXk4NCh+9E5kLpcTQfEW1iHiNQliyD9kCBaG+6N0CYN
         uSEOLdj9VFAREBHDpqrCgibPypQJk+Kzkb6Is4Ku5muDqN5LTQ1MSSqj5/nQURX0vbrz
         UORssnv3pGHPNIVRxxXLApV5JdqXYkw38jY7fz4CuJelJLuGUnS7x+hs23MEwW53A4f1
         GVZcEYJj2rCCHlKX2i/dQ0KLCtPMnOgWIvz9aaR1t5jwpQjWE1A6Pk9UeYtmHqQVs6rI
         sHDJ6JniTOov85JhRYNZsnvY2hTUZ72FwVHGBxJTmkd3007hQZir39MVkYqLHMzxaHGS
         qNZQ==
X-Gm-Message-State: AOAM533uGIsSU85uROmS4n/y9XXGssqlxnja/7rbhNE5ot1T8blSDDIc
        K2+L9LCC2vBdOu4vl5dSbtLUww==
X-Google-Smtp-Source: ABdhPJzRI3fnkgdfxyjyzrdhHlG17t93aaLnhtz7zvNZO9ph+aw5cxo9ZYdM6sKY8823a+JNGEpUEQ==
X-Received: by 2002:a9d:170d:: with SMTP id i13mr24716551ota.106.1608074828660;
        Tue, 15 Dec 2020 15:27:08 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id z9sm127otj.67.2020.12.15.15.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 15:27:08 -0800 (PST)
Subject: Re: [PATCH v2 03/24] target/mips/cpu: Introduce isa_rel6_available()
 helper
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
 <20201215225757.764263-4-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <508441db-8748-1b55-5f39-e6a778c0bdc0@linaro.org>
Date:   Tue, 15 Dec 2020 17:27:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201215225757.764263-4-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/20 4:57 PM, Philippe Mathieu-Daudé wrote:
> +bool isa_rel6_available(const CPUMIPSState *env)
> +{
> +    if (TARGET_LONG_BITS == 64) {
> +        return cpu_supports_isa(env, ISA_MIPS64R6);
> +    }
> +    return cpu_supports_isa(env, ISA_MIPS32R6);
> +}

So... does qemu-system-mips64 support 32-bit cpus?

If so, this needs to be written

  if (TARGET_LONG_BITS == 64 && cpu_supports_isa(...)) {
    return true;
  }

Otherwise, this will return false for a mips32r6 cpu.


r~
