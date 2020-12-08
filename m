Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F172D364D
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731455AbgLHWbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729034AbgLHWbJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:31:09 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698F7C0613D6
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 14:30:23 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id s2so305870oij.2
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 14:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2yI4VHuGJabs7ooQuq5prMjs6mJCDCBvKCDGtTApf90=;
        b=GIKd+Xz5dUZW4BACDCrTg8k9AoR3hGyQv95jeI0sj2LszcmegbtY7VOAPvpvlFPBV4
         eMFTGTvLZ4SmXF7wB9ss3Yb6YSQJmaPPK5vUSIiEcGc9PIT80SPDhiD3EzZYrU8gltqA
         P11ZrVP2eS2Oe6fSn5r0Px4QAoLlkF8yjgGb4XrrcLvDv2DQkTIsfmqtBeoSx6Y66e8g
         0EO86c0njocYB/aH4m3P+w+kSZeHcAlkoq7hA/gq9PLfWvvzo3KugBIJJQcJNrDsZ3Ys
         hZW18r18mbi12BPOqeJDD7/Q13Nlr3HHjZdkpiLDJw7Mc2EARFOl9PGwQWJfvDR7SneX
         8TwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2yI4VHuGJabs7ooQuq5prMjs6mJCDCBvKCDGtTApf90=;
        b=MTtBbfTRpuo/k7ufrG6WxsZbKn6V3+ttgVEIjC5hLOOKrCLQwaIiaGy2X6/BbmAsIB
         7j4uw8WDxJFRV5Qq5RgG6KDtXMUsViTFXKAFpUmprHL6FgfvzMgU0lPY2b4YdstTKt7V
         de5O2uPiCL/fWKhlUhX83RDFSXYmXNGYChvBoKC6HmR/Yuefm+7cdzLQcc+9bxCulnwg
         q9eS37+TNODNR0E+rf1xH48oUEei01JA6Eu6nWei28XtPvO0/WGKOBAR67FepytuLkHJ
         Ev4xFAgF/rblFuFdrlNfFbjvUFSMG8pGueDDUGTJPhXgGo34bLArnT+i+O2JRjBpmFDI
         koDQ==
X-Gm-Message-State: AOAM531Xt86JAHkkPOaGMECXRqSWt4E/PSCE5DF8YOGsHcdRQHmip9On
        /cqi2C5oocLAslzP3MJesmi0JQ==
X-Google-Smtp-Source: ABdhPJzWPK4dKug6Hg8z2BjFoQ7ubgZPPLYDWDmujFKKY4nSu09XAekU5vYsXWdF6Gd1Ok4LMZf0gQ==
X-Received: by 2002:aca:d841:: with SMTP id p62mr87833oig.38.1607466622877;
        Tue, 08 Dec 2020 14:30:22 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id o6sm81671oon.7.2020.12.08.14.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 14:30:22 -0800 (PST)
Subject: Re: [PATCH 17/19] target/mips: Rename translate_init.c as cpu-defs.c
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-18-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <56eefa47-f95a-087e-54d2-05135d2c506d@linaro.org>
Date:   Tue, 8 Dec 2020 16:30:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-18-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
> This file is not TCG specific, contains CPU definitions
> and is consumed by cpu.c. Rename it as such.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
> cpu-defs.c still contains fpu_init()/mvp_init()/msa_reset().
> They are moved out in different series (already posted).

After the other functions are moved, then this file may be compiled separately?

Or... why is mips_cpu_list moved?  I guess it wouldn't be able to be separately
compiled, because of the ARRAY_SIZE.


r~
