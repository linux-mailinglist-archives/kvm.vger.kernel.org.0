Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08FF2D3764
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 01:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730366AbgLIAHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 19:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730241AbgLIAHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 19:07:08 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577A3C0613CF
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 16:06:28 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id k2so476474oic.13
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 16:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iLfF/auN5FqC6XsYYZYg7CT5IU2mXfpaFhjc8pnl7Gg=;
        b=O0NS3c3NweixraG3VE7iL7wYjawbit6h2j9uonlFjT7XYBQvm4CzsIVasM8QCQTjR+
         64o1NAviP+cW08O2w640tII1oveqWtbeVU1Zjxt2Jnlye9CGvBQN99IzguYZEU6G0vSf
         IceS5JosPHCj5MQwbH2+7ktR3ng9hCZNi2h46zH+0ZpwHr2qxZ2t/qbsBzMZbxaNGvWH
         NihX8CEaxBqWjeuteWspY634lMvpuvOWdJkTss9McldKY6c/p4FiJM2JGTXhU1P+378s
         svMWdzVSYJh85KniVYeXhTs3d/sPVzEzLaa4+Lx1gaCcm+KRkIL0Y8TDBnTNgbgvFCU7
         Ihgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iLfF/auN5FqC6XsYYZYg7CT5IU2mXfpaFhjc8pnl7Gg=;
        b=niuEB7YZNBON2dN/yrhbnkE6gBIXx8psdrllav/40lbCMFjNo22DRndTZfbIh0TEdV
         oTuiDc1TaI7oW6uJmyVsIGoH30euXYd42ixGMa1UsjQ0rV0PwpqVsSryX46PRz3A3H9r
         8zNIAUsZWo3ToxXhVm/5TDDXeW2dlL83ag6i4Y8CupGRR+41QgqLeInQDjmgcOwMfmrR
         s54EKjPvc3W8asSBLp4V5q8G1GpGMwyBzG6Hcydgele30e4Ur077wTmNV12f6+KDQsAq
         RIZIzcpGJuWnwK8hyfXguEQZUFGkJGSc4Iff9XtxBRcjyVizoQNuOyKAQx8ISZ/x0cAx
         1txw==
X-Gm-Message-State: AOAM53199Z4B1u00knjhpOdKzBiTsJYTxWFPY6q4Lxqh0eackpmFJbS1
        PfDMSuCo854BssMH0jBJcIWM1w==
X-Google-Smtp-Source: ABdhPJwS4kusTkUzvtisK6YutAeclGp/etspSFf37NpLEeeNYi+9pjzIcBmpewU1gA2GdwWlPTaUSg==
X-Received: by 2002:aca:5093:: with SMTP id e141mr23554oib.76.1607472387813;
        Tue, 08 Dec 2020 16:06:27 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id o63sm138636ooa.10.2020.12.08.16.06.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 16:06:27 -0800 (PST)
Subject: Re: [PATCH 17/17] target/mips: Use decode_msa32() generated from
 decodetree
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20201208003702.4088927-1-f4bug@amsat.org>
 <20201208003702.4088927-18-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <8e52d498-d82a-be10-ae77-d98900035132@linaro.org>
Date:   Tue, 8 Dec 2020 18:06:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201208003702.4088927-18-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 6:37 PM, Philippe Mathieu-Daudé wrote:
> Now that we can decode the MSA ASE opcodes with decode_msa32(),
> use it and remove the unreachable code.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/fpu_translate.h     | 10 ----------
>  target/mips/translate.h         |  2 --
>  target/mips/mod-msa_translate.c | 29 +----------------------------
>  target/mips/translate.c         | 31 ++++++++++---------------------
>  4 files changed, 11 insertions(+), 61 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

