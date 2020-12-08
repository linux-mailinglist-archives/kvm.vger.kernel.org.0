Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0842D368C
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730994AbgLHWzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731551AbgLHWzE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:55:04 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C77BC06179C
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 14:54:24 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id a109so397510otc.1
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 14:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PQ8ql5JUVC6dDLQWe3hHTJeK/OrlyGwzOEs5LugB9as=;
        b=GKn1nqrg3ha9+tv0CV+TdGJJ80fUWApNsdnmiz2+MYkAsGjsR1Qrtc2/QpWxgIHf8b
         ydu5T3IsWzvc7edu21DRjxzB+OuD4jtTg5kByMhQk05FYWmP/AfZpEIAMPZHET8lI0ra
         g95w2aaMvphHJPdPoyUD5IIJHEeBpxH1BNiQOPON8P3Ag9yuwBfaFF9/lFaSBCvaiLYG
         iwbvMCVNlYtZzBWytqcRJ23id/9AQEW4D1t5uONqbKSO+qiJ3ZNLaWW7RFQNKUVMezo5
         LXRCvN2OIIWgLyHT8FLgWnuNQK/2MPJGTR4ejOHFP6RstoANdwygzvJwgZKkNRFdz6U5
         26lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PQ8ql5JUVC6dDLQWe3hHTJeK/OrlyGwzOEs5LugB9as=;
        b=AYeirfzKBqk6pni9ufpDXJHsUCruYCL5c6uMFdKPDWMFbcqoqZ3NmzJ0/uwD1L6jQk
         teDe7eUqoRX8iovLrcK7KxsW61fAXQMk59SdAKoKH12A4CIcnd76l8b2vRQJ2JI94kj/
         nbbs65ED4HHUPovgLc4hMEi8pz3IN/VwhvWhqd86r1w4e7xhY0O08jq3j6wExkyLgr4M
         r6KgshsmctB0prezWH+1TLKC+DyRRhaZ/lINdOXekPQHT55GNHka6uzYLkCtJ4FYy1ok
         N8YnYyy5aTZTBaInZREWeRx816KW919KFZmGNF47PKhu2VJx6Enqba/JcnnyN7cpg34O
         aMTg==
X-Gm-Message-State: AOAM533Vw9BxRNeH69dh/MrJ42GTKCa1JZDIFg17B0LSVXlHzLBoITO1
        aLR090W5My65oYdDaI6U0vlQ+xfzPBJ9hlXt
X-Google-Smtp-Source: ABdhPJzjEMaGTRjRaBYyPFnaqrmG1o5Q8LUDpZn8vFrLey65GlYioSgf3+H73zXziPZ2BVVeDv8rLw==
X-Received: by 2002:a9d:8e2:: with SMTP id 89mr274281otf.215.1607468063553;
        Tue, 08 Dec 2020 14:54:23 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id b82sm42405oif.49.2020.12.08.14.54.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 14:54:22 -0800 (PST)
Subject: Re: [PATCH 6/7] target/mips: Declare generic FPU functions in
 'fpu_translate.h'
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org
References: <20201207235539.4070364-1-f4bug@amsat.org>
 <20201207235539.4070364-7-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <23c1eb1b-31de-abdd-26ec-be0142d73eaf@linaro.org>
Date:   Tue, 8 Dec 2020 16:54:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201207235539.4070364-7-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 5:55 PM, Philippe Mathieu-Daudé wrote:
> Some FPU translation functions / registers can be used by
> ISA / ASE / extensions out of the big translate.c file.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/fpu_translate.h | 25 +++++++++++++++++++++++++
>  target/mips/translate.c     | 14 ++++++++------
>  2 files changed, 33 insertions(+), 6 deletions(-)
>  create mode 100644 target/mips/fpu_translate.h

Is there a good reason for not putting these in translate.h?


r~
