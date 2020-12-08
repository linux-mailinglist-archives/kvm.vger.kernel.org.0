Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536382D358B
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 22:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbgLHVs0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 16:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728138AbgLHVs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 16:48:26 -0500
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0CCC0613CF
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 13:47:46 -0800 (PST)
Received: by mail-oo1-xc43.google.com with SMTP id i18so2347412ooh.5
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 13:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tRBPhLC+NGfiAmS7m8yNwXRy/3gRpYucgLpHNvGofpU=;
        b=B0YiqWusVn0IWVNiLos72WOSPHE7fUE/SOfmAAQsvoTXLuXPE2VWbse+DaNvC1ymDo
         rn+UrFJ48Gj1vTrBJAWgOxaNABr+6YqJ6U5J2e+5mUSXc8igysfKjiDSF6DC5s6isJIk
         glHlDXPUfXWfWE4m9zIQCxIOuiqi75w1wVLDvS24Vn/teK42B5Tvx3Gkr1nm4nQmNiHe
         VdlIx3hx/X/ROEMqJOhwZLzzPLLocLFK7swjQgFVD6zXkQV73ErYdS8MTNKT38PaSg4f
         yHzddvyEfIkMshUDRK1+L9XlHCh3Y7nQ7fiOKbaOyylK6gaaLDvVpg9IGLL7dGuDcr8n
         SLLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tRBPhLC+NGfiAmS7m8yNwXRy/3gRpYucgLpHNvGofpU=;
        b=aJ36+GgS7rAF7RJCUI70r7DCGZenIlYHBpbry+pYYgxpPmehLCAHKFQMGnjdEGtTvp
         V7XwjxNmAXi/iAN9sUytXxRFo7GqyTud7yRDfxDNY4vTClzEnrEt8O/n1kXWA1ySx241
         9cGGgmJKT2NOo59QiHeFv5B0LKomI0hXdZLjHk1x0XK3eHFasjzdu65LQQEXdpoQ5Xua
         HfJRr7vwmvBi9y6+GOjiHOnmvcOT+LSs5+UD0LFAOc/+XfsYB9zDQlrZ82kdI7S8YDQM
         hOM9I08yY8aLhqFYzy6+2/1bebZUT4iht9cJWMbM36zDWhT0gvR81VqL+0gpLHPwp/uK
         HbRw==
X-Gm-Message-State: AOAM53390QA7H/C61s46NRN8iYkt+075klQ1v/hWbn16xTgtaBj+Iyk1
        6FlM6tKODjXyy/NWwAc+qozd4PlMa9dlwuiA
X-Google-Smtp-Source: ABdhPJwuXdEIcaHz6j/HiK1O8PUcxirP96fQtjoialThuORemN3i62AcO8Zo2bfHm4zF8QedoiYqjA==
X-Received: by 2002:a4a:dc1:: with SMTP id 184mr29178oob.40.1607464065889;
        Tue, 08 Dec 2020 13:47:45 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id 11sm1761oty.65.2020.12.08.13.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 13:47:45 -0800 (PST)
Subject: Re: [PATCH 02/19] target/mips: Remove unused headers from translate.c
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-3-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <93623a8b-638e-856b-815c-cfdcf3db3c17@linaro.org>
Date:   Tue, 8 Dec 2020 15:47:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-3-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate.c | 2 --
>  1 file changed, 2 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
