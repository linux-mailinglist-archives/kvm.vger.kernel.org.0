Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128672D3684
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731514AbgLHWya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729455AbgLHWya (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:54:30 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C662C0613CF
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 14:53:50 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id j12so361980ota.7
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 14:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+MTowHTwHlTml8/iPoRSaOL/Y+tLwUXRr6m65X+52IY=;
        b=cmUnCR9OfByQykzKCGSRD7gy/a+7cS0hgIK26ajqXmYZ45Rsi2LTW4UhIO3XyHMoa2
         YNctGFYUcUvkM5aXexwgvtLHCjZEEpJnMUH8GqT9QY0jKFdFhzIM+9pNaGwXdzxqV5iI
         /DoqdP61BbmiSU03iTUxNm99jh5J/Jo/hWyCl6t9o+MpyPkTREF2YXERCLkc7Yk6tI0L
         0h/9VgA/jjSRWjeCIQ8kXPCoZa29rP+1c1fLHSOhYtZWAcwa7IJe2MaXf8DzdmMTygp5
         l8IHlv6Agj4gAIAlWjenYFjuv240MiSSiH8tdsxQetuX9m1AR3nNULEFzFMahHEGcYwv
         x4Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+MTowHTwHlTml8/iPoRSaOL/Y+tLwUXRr6m65X+52IY=;
        b=Se4mP3M9E243wE+aN2cUHFm2pCCcZ6HUdWrNd7xhzpSdWmIhXoWeOl1OIff995UatS
         V7P/YYXyQdzeVM6W82Ty+4a1dNjESSvNIK8RlfG+SjbjqCzsNDaxvtdzF+DQ9oLUKTpi
         iiX4LFYTkO2soJNDpD2OqObhwdbnrqPCUih1mRx75unINItgXq60CJE23uVntF42BRrD
         brK5dvYpXFUiit/zCZcPrW1oXjcRtIQFmI5Cn1ais1IS2UaG5Tlnf7x6WVDYVlX0LHq4
         Blc1ZdcAAV53EOWNozj/xFBkS1tz4DtSC42Cqw5l/nQGwec8QjBPS394qqOa6JqE3thS
         FZ4g==
X-Gm-Message-State: AOAM5330qqcU0IQ30mORggcndmF8c1aLYTOF+RGunaGDrYsRZ+0q2O5R
        ESl05yzMiiEeY9bPAD4CrQWHQqY3fYVrgjKm
X-Google-Smtp-Source: ABdhPJyZmdBqRzd11Np1LvV707p56CpX6aTQgJe+CFjOWwN/REk0GlGeGshBI4eSum1lXOHqyRgMiA==
X-Received: by 2002:a9d:2043:: with SMTP id n61mr299770ota.254.1607468029166;
        Tue, 08 Dec 2020 14:53:49 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id t19sm47807otp.36.2020.12.08.14.53.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 14:53:48 -0800 (PST)
Subject: Re: [PATCH 2/7] target/mips/translate: Add declarations for generic
 code
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org
References: <20201207235539.4070364-1-f4bug@amsat.org>
 <20201207235539.4070364-3-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <e710d5aa-19d4-e2be-9dab-eb0fd94ec6b1@linaro.org>
Date:   Tue, 8 Dec 2020 16:53:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201207235539.4070364-3-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 5:55 PM, Philippe Mathieu-Daudé wrote:
> Some CPU translation functions / registers / macros and
> definitions can be used by ISA / ASE / extensions out of
> the big translate.c file. Declare them in "translate.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate.h | 33 ++++++++++++++++++++++++++++++++
>  target/mips/translate.c | 42 ++++++++++++-----------------------------
>  2 files changed, 45 insertions(+), 30 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

