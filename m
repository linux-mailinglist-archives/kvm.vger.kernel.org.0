Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3ED32DAE8C
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 15:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbgLOOIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 09:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbgLOOIW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 09:08:22 -0500
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB89C0617A7
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:07:41 -0800 (PST)
Received: by mail-oo1-xc44.google.com with SMTP id k9so4838436oop.6
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u7ecJ/OaL9vDMLfBCx/xo1qgzc6LeG3GlbWoP5APu40=;
        b=mGzhSUQLfPYi5ludRDAJfzrd3F80RRkT4Br46z3UgoP0tMDMnO7AZIdbT4qUyRXbUq
         Qnu/978eqSLKsZZEx0ofvds8oZzFMgduXwxBJpZWKnszKxqcfDu91Iaa09sgtSzK5Zma
         vmrojHRFlr2yVF3Ow+TX9NfL0Xmykmu6Zzsm/k5jJ3Av/x3SAykY3LBIi7ktnLF726Bx
         5qoS9QktzpESvQB9WYEFip9BSoBUf11ltKAGTKtkDrPv47oKAJxXaUKlJNyTkVwm4FaW
         xBl+szbtfqpzmBXmDCPRE4ULcEjqHObbbcoCmQZXoxJTjwzBexMW/1BZidZ3muIJproH
         6MuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u7ecJ/OaL9vDMLfBCx/xo1qgzc6LeG3GlbWoP5APu40=;
        b=YMrXHZhizXj+nS0v6c+hE7zGQeZdzVRZDB0uOWnWy7jJvgzLXC97JRIoTyTkH09vVM
         p5XtHfZy/N6AlkHut7sRG5rmU1PYkOR701zSI4O1tAJgdIl5ESPljwsDf484U4gTVSYs
         DVIyXcp1H8YM+SmliGWCLFbttwE/I7au4GYOiJxnuo4+Yj+zHP+kGVyskkYzdliXPRtO
         1YlwYOqMgEEpgcR/Kbl2EGsh+Am0Q3oWj/hS8NxNhAGM+IIGgiIdAKQPP7re8hJMCj67
         O3BS+0k4G45/lvsgGfLypkEAby2ZP5RWfN+m5u+r0TSHs2iybJs+2l+Q1JkmNx5guuWE
         Fdvw==
X-Gm-Message-State: AOAM531xLZstt8VHQHPi3SiSYFzviM8sBbvY/YBDlpTJ2+A+3smGtOXP
        PQnQVjbPwdULiHmW8cY6QClDNw==
X-Google-Smtp-Source: ABdhPJzqDolymJzOA9ZqD1WZ3tPEa0n1hmB2njhH3GVWa/FSengIEnahfoWKMlzOnISUMzCWVjFbZg==
X-Received: by 2002:a4a:aac4:: with SMTP id e4mr22491184oon.2.1608041261240;
        Tue, 15 Dec 2020 06:07:41 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id o17sm429076otp.30.2020.12.15.06.07.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 06:07:40 -0800 (PST)
Subject: Re: [PATCH v2 09/16] target/mips: Rename translate_init.c as
 cpu-defs.c
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201214183739.500368-1-f4bug@amsat.org>
 <20201214183739.500368-10-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <70289ed3-5350-58e0-2c54-3da61c201d22@linaro.org>
Date:   Tue, 15 Dec 2020 08:07:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201214183739.500368-10-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 12:37 PM, Philippe Mathieu-Daudé wrote:
> This file is not TCG specific, contains CPU definitions
> and is consumed by cpu.c. Rename it as such.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/cpu.c                                    | 2 +-
>  target/mips/{translate_init.c.inc => cpu-defs.c.inc} | 0
>  2 files changed, 1 insertion(+), 1 deletion(-)
>  rename target/mips/{translate_init.c.inc => cpu-defs.c.inc} (100%)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

