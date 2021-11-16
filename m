Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A1B453AD0
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 21:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhKPUW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 15:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhKPUW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 15:22:27 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4316BC061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:19:30 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id n29so77041wra.11
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hMPomJZFY13K7tAKVfm9YLhauB0H1d36Rn3Wgp4Dl6M=;
        b=hUO+GaDJQMTExeq1pDunh1kWtWzfozweqYuE2gknjpDkF/ppfCfoNjkiNTS0IAMgXa
         /gzZxjoY3u4uaNDXEqEAp2g1oy4ycNYDXdG401Soed+3PEw+pyvMr83Yjmhsvp9lPDvJ
         7Qviq64fJy7sI8VDLUnxbxReYmVcAr6EkBhLPx4B0Oiw7/xJe7FDhaTycmB3q4AZBcME
         O/H1CIOoKDk8xEyRkR1JcIdzBvUAVLv3HuvMrNilIluuICF3bWtjakjf0hMQmarpuyT1
         ahYZpkMQ4CV/Mtx6tMwCgFnq6EcKa2iOYC5SjAu5su4X/cCoRhVkqmK9gEP+NB35/SIG
         VdrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hMPomJZFY13K7tAKVfm9YLhauB0H1d36Rn3Wgp4Dl6M=;
        b=zloGwDdc/KlFfnOcYYJuA+sk34FSuCG1ceCfkj0mHs+P3tuUlJXCUexlVlPyc9ybu6
         MOVG2LkcKTK5cIYeyak41xMvde422WYmpfaXD1g9Y8xsLiNsKkCLYShEz5cvWrNxG5lP
         c3z7RubOpMocDHJtSkzYJ8mZMNRjyPSVQP3x7GENPhY/xh88dE7Sv14Ju58lvlpEwFbI
         pVG9qSTNQFG3Ptp4DNIIkvzDHKrG2xLoXe/v2KEKICmVjEdvVkpojcwVsuBxSESKBtx+
         h60mhxsbBKErwL/+b1sOwR5PmVKr3J9ipclSokHalIcBc1dyIvaTyM8JbuyqSRZ9V/JF
         ITNw==
X-Gm-Message-State: AOAM532trIO7QMLnliOl5ltrtYQNOUnau0fsdlivcymwYxo16h7dgN1c
        dmP8cv7O7+bN6iVNm5s6uzT6CEKV2OZfYFAcuzc=
X-Google-Smtp-Source: ABdhPJwrid7kWuZi0Os4I48lNe2Tg9bUykZ63UCszaXLkydXpv4tCayDpavmdbyPCYcvWQSoVo550A==
X-Received: by 2002:adf:f947:: with SMTP id q7mr12558641wrr.260.1637093968902;
        Tue, 16 Nov 2021 12:19:28 -0800 (PST)
Received: from [192.168.8.105] (145.red-37-158-173.dynamicip.rima-tde.net. [37.158.173.145])
        by smtp.gmail.com with ESMTPSA id t8sm3197057wmn.44.2021.11.16.12.19.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 12:19:28 -0800 (PST)
Subject: Re: [PATCH-for-7.0] target/i386/kvm: Replace use of __u32 type
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     qemu-trivial@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
References: <20211116193955.2793171-1-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <a2628496-ff7a-e684-ee5e-93531790e998@linaro.org>
Date:   Tue, 16 Nov 2021 21:19:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211116193955.2793171-1-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 8:39 PM, Philippe Mathieu-Daudé wrote:
> QEMU coding style mandates to not use Linux kernel internal
> types for scalars types. Replace __u32 by uint32_t.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@redhat.com>
> ---
>   target/i386/kvm/kvm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
