Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5962DB6F0
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 00:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgLOXL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 18:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgLOXKj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 18:10:39 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F20AC061793
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:09:59 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id 15so25276310oix.8
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KxqGV+AGNTcfF3zrazYtJ7eYwmIBbvEZbcQH4yg1ucc=;
        b=OMzErqkr+MJ0j1m6BUExYhdT+cWjx8CFEW1l83SZR8FPpCQR91xbKiCwmX+bq6c0a6
         fW18eMVXgMpNdc+EpNnvMQ9OM4Lpc1/FP+b4r5wgvhnQZAL8H4jpDtF5ACe0g7pCsVnY
         KGDkzhugFbOjJSi4c6fRPldO3EUccoxb5pWNkdysZH/WU62MoHUYJq5s2+iSODUqrVDS
         L3UOW2O3bjGRUZjWrlx4+Elit63ZuA1leAIp9IgOAF40A/86aJkbq4DZuCykHxdN3e8O
         w2UjgIG2smmLQH+mnVCU+BtlXgIxSMXEwtCfp02LQoDbQMRHkzHrXJyRiR6WVlra+CQj
         ttig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KxqGV+AGNTcfF3zrazYtJ7eYwmIBbvEZbcQH4yg1ucc=;
        b=AhmWjEkilAtXL2jWqPvTK+Kj7gySE9JeET8WW0YzxOfU7oat1yqzOfcWSXtivAqIvd
         x4JS/huZ4njEFRtKsUpeg7XFQ10Krr7Upx8WOuxyyMSjIx4P7qrrQYBmQ81X88iRHTqG
         0WQTBcMVFCz0cjPOlcKagfxPHbIGvE4C+CgnPCNlgeJvalvIqetWLzDsJkGYkfpgGlGC
         Jm+lZ8yvIWk/v6o8qMb6DgbtImYcCs8Iofd8tgGBI1xa74UBpNC2OFopOaob1T/ntjmG
         XwygGx0fr2SrmAwfn4EJk+yI3edgWMLuLRXYbDaNSmvZebzkM0RZVoT9ZvA6MfpC3tP4
         7o2w==
X-Gm-Message-State: AOAM530RIfvNIj2GU+7leGVUMfl0B1byKl85rkx9SppDXpsSXG9Z5NBL
        MHUv0UOiELbtuCKLbYhjUbSSGjqknQ+cZb54
X-Google-Smtp-Source: ABdhPJznkgL2tgml828BQ50Mi4XLxbwQr1VhGmLLDhS7LgYcUyRlVfJH5Dzer5/2+xH/Aq8fDUH4Jw==
X-Received: by 2002:a54:4413:: with SMTP id k19mr635066oiw.110.1608073798890;
        Tue, 15 Dec 2020 15:09:58 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id y84sm66894oig.36.2020.12.15.15.09.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 15:09:58 -0800 (PST)
Subject: Re: [PATCH v2 14/24] target/mips: Move msa_reset() to
 mod-msa_helper.c
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
 <20201215225757.764263-15-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <7b374223-9275-cfcf-6edf-c0c99ae0e971@linaro.org>
Date:   Tue, 15 Dec 2020 17:09:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201215225757.764263-15-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/20 4:57 PM, Philippe Mathieu-Daudé wrote:
> translate_init.c.inc mostly contains CPU definitions.
> msa_reset() doesn't belong here, move it with the MSA
> helpers.
> 
> One comment style is updated to avoid checkpatch.pl warning.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/internal.h       |  2 ++
>  target/mips/cpu.c            |  1 +
>  target/mips/mod-msa_helper.c | 36 ++++++++++++++++++++++++++++++++++++
>  target/mips/cpu-defs.c.inc   | 36 ------------------------------------
>  4 files changed, 39 insertions(+), 36 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
