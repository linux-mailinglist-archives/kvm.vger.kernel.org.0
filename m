Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D69B61873D6
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 21:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732500AbgCPUKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 16:10:35 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:47001 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732436AbgCPUKf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 16:10:35 -0400
Received: by mail-pl1-f195.google.com with SMTP id r3so457296pls.13
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 13:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MY8MkhaDCZV5A/K6qiTfn+gJM+K/rUxU8elb3vMFzUw=;
        b=IsbDbkXVyyfep+K7aPqVt5aCvcdTj3M22CRGivPVGEmT3RYBYmRUSkUMAKDOSoBrWb
         M3BcPZi75ckrZa7mQL0siEnco9vQsyRub/WJ/+5fXmJYckwgZQvpG1OIMw0uDHNg63Es
         Cd4p1EIhzPFLFSUK/ZCK0fSXv/sntjuiFCfBD0i+hp1Yk8qt1DyGP5Hf/0zLw4Bo724n
         rQSHuoh7KDnRQEV5hf7GJwMcORrF0SpAFP5W3YMEXFMLbRlXvWwqM/MU92G34L14jCeJ
         6rCJhVW3ySuh3w/5ley49fbfMu/MXognqfrPoG692mmTcexlDH4PJwWG4k4L544TONBz
         6rEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MY8MkhaDCZV5A/K6qiTfn+gJM+K/rUxU8elb3vMFzUw=;
        b=f9iTZWTKiF9VMn6fKZM8Esd0FijovGQqF1REAvAl1I/3u4Cp1m0MFsjVOgg5STSoXt
         kN1LV5u3NwRDsTcHAUrc+HuArvg5f3G3yU7c/lQGFt30ZsOpK7XVG6sNIKJiyPJG4JBl
         uz3lX8sRd3ARMM0g9nCpL5q4O7wiOgLc5T0VtEoX8MxTihz5G+BFSBTeiIjF3OGEl3lM
         MerAfpndQJ36lXaMuNeIeDpFWmFUCfum1z3jZ7BV/1fvtOnaYWdoIKCcvdbPhZY13BQC
         +M+Jo2Wn/xfCAaLmmsVp5TSE/0/rjBC03nQxxZ99RM4ANrrOhADCgazgI6b+Hd3a3slR
         xEsA==
X-Gm-Message-State: ANhLgQ338cxsJeWcHDj1rG8g/y/RsP5kzIY19jij5UC2YIEPSZmiTxbo
        md/sSI/fCFpM8K+N1cWBWQbNlQ==
X-Google-Smtp-Source: ADFU+vsfOpkbA5/KzKZmtYtj2u6FDMGO7fkFq2kdP+aaQsvpZBgdbHmRSI6nkzzTrUNnSe2NEzBlng==
X-Received: by 2002:a17:90a:a417:: with SMTP id y23mr1249051pjp.184.1584389434398;
        Mon, 16 Mar 2020 13:10:34 -0700 (PDT)
Received: from [192.168.1.11] (97-126-123-70.tukw.qwest.net. [97.126.123.70])
        by smtp.gmail.com with ESMTPSA id m9sm329171pga.92.2020.03.16.13.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 13:10:33 -0700 (PDT)
Subject: Re: [PATCH v3 07/19] target/arm: Make cpu_register() available for
 other files
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eric Auger <eric.auger@redhat.com>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-8-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <78359d38-4fde-7cda-a4e0-d36f1fb8d166@linaro.org>
Date:   Mon, 16 Mar 2020 13:10:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200316160634.3386-8-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 9:06 AM, Philippe Mathieu-Daudé wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> Make cpu_register() (renamed to arm_cpu_register()) available
> from internals.h so we can register CPUs also from other files
> in the future.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Message-ID: <20190921150420.30743-2-thuth@redhat.com>
> [PMD: Split Thomas's patch in two: set_feature (earlier), cpu_register]
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  target/arm/cpu-qom.h |  9 ++++++++-
>  target/arm/cpu.c     | 10 ++--------
>  target/arm/cpu64.c   |  8 +-------
>  3 files changed, 11 insertions(+), 16 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
