Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111662D3596
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 22:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730164AbgLHVtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 16:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgLHVtr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 16:49:47 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47EAC0613D6
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 13:49:06 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id d27so198910oic.0
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 13:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N+xIHqu2+gRNiZKfWeew6jfBHxjpySrralGLj5BRwOw=;
        b=QUzV3ocabQNZmYipeyaTTZjVvE4B49fqvdxF9uSQmarRP546BlrG7CAPFHrpemRzKl
         jn6MQL5GvlyAIHCeO8/s9AY69UP4aqdm0mJXVnrUP3CsBUzjUOlDtjXAkdxVL/iR98M4
         KgiaW+vy9G8fBnyCfovTVU857yR3QqCo9pk2x1DjTSYkHkr1LIX0JRygJozF3YsX7wjJ
         9Z+7KG9YjlUU0KYxAjXylCsgfTmuetinUl6XLNVHtzf2T6cMbHnW2DHmedmPQAo2JwA/
         rCP3/mK6/ImYn9vjNtPypv8jrN+BJEt8b6+4Xnh489Phjb6avXbdVN3xMyV2E/cRzFNS
         guvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N+xIHqu2+gRNiZKfWeew6jfBHxjpySrralGLj5BRwOw=;
        b=Iz4hx0y4uXj7KFJwsyC64VVQG3dbr9qEfy1E6hDYpnechavm7W6pMacb2nJ60UdFXP
         YVAknjE++kZoMqAnAGFTjOK6yubf/vkjZCvazPuism0h+Co554DjgppuxoNZ+3LG+O95
         j/wXo7xeeiRzOzMAlAsJWGMi/K09l5Uae2tmFcZVID9hC+D3b4EI0orp5bH3vt09lFUf
         2IGZjFh9cjwALYRSRPDF2rtMwDodUtbKytx1DwVnPm0zLMESMauTotqYCdb+iayvLYUJ
         4eQqn2cxCcE0oZ+Cx9oyZ0VfBI/wYil9J/GXsmWJl81ZHi4Qg2c8/96P+E2IR+osMbzK
         w+XQ==
X-Gm-Message-State: AOAM530SZs7naEffKZNGNet0AfPzb6ChxNeqneN+C//bGfNymUwCQiQ7
        A6sShZZ0TZ2FVBoEVHPoSlCLRg==
X-Google-Smtp-Source: ABdhPJw7DajjHwECgxki4hidw33aMmAf2Yprs7V3t9hpev8RNtNV8+lt3MEsc0RCBZ7mRNqTZzLEDw==
X-Received: by 2002:a05:6808:650:: with SMTP id z16mr4351402oih.50.1607464146325;
        Tue, 08 Dec 2020 13:49:06 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id k3sm52714oor.19.2020.12.08.13.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 13:49:05 -0800 (PST)
Subject: Re: [PATCH 03/19] target/mips: Remove unused headers from
 fpu_helper.c
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-4-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <ebcbe6d1-5142-6a4a-5133-ad81ab2dabbf@linaro.org>
Date:   Tue, 8 Dec 2020 15:49:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-4-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/fpu_helper.c | 4 ----
>  1 file changed, 4 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
