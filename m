Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574792DAEAC
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 15:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbgLOOOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 09:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728893AbgLOONy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 09:13:54 -0500
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE3DC0617A6
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:13:08 -0800 (PST)
Received: by mail-oo1-xc42.google.com with SMTP id y14so1544531oom.10
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dVUkPoad/SeiPntSomVY//ORmqr7oRWlTnxdMN71LZw=;
        b=Z6z5Ql2aH2A4spzZewnw2EUAs0dF6N0tUnsp2c4vKIx9dRGeGEGVgWalwk96pLa2D2
         oxQyul7geTmfKgApp267oXYWFkbFrvo/YY4cr9u6zehnm0XPolYklanHpbX5I/qQtRtS
         NHaeVIwqdh63kFYAfaZkbprJYW/fGIZfH6GObwCzp9iiIzxKqMi+Xez6hWb1qizBd5gZ
         gMTEYh4vkGOjeTsycmzYv+6tPGcYk8y+8I2IpdhSRNCWN/H22vAfri+C8LOKHhJ2DCqx
         q0xyJMLSOYSMUn/78toPmdLux2sdVWiZZtDngOqGc1RwqqqEAPxXW0JnQodjnBgauUaH
         WDUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dVUkPoad/SeiPntSomVY//ORmqr7oRWlTnxdMN71LZw=;
        b=B7nIUSzQBIBHKMg0DmgDC6z2oJKAlIKUYBGo0rD8+s6Pv4qHfcZqBIGov4cSisxMI7
         /ItlmCN/SARUHCG37iKnJ2XLkyNeHyxBz+ggza0pEM6nHwcj9I5V/JRaSN8DcUiKpKhW
         tsSiwiFmyE/t04i6dzQvtwv37xvrV+a8+U+GiyDdBQiE2fkFA4rft09Oc6v9C6G5tOU9
         JhqSWLpnSjuf7g9JQ5hHWUtNYhaCwmSie8z9oxEAu2Rm4ZZxX1l3MqQc47UShQ0tzpqm
         JPdjZVDLvq5EdUIbfDnFNxpZXteumWo/Oy+orXhTcerRPQx/BSNMbU9dYAhG3af0xKg0
         p97g==
X-Gm-Message-State: AOAM533tg4mM0fUI9f/vErlbOdj06SVqryxnCy5QSK5mdNLk0is8viZA
        eIR5BpkKztJHT+m7jByhcKmlzA==
X-Google-Smtp-Source: ABdhPJx+b0rJsvQI91GxcXWQIypRaD2yivBz9fawA1lWHLh5IdX+3h1P5glRtLUnBAiJwiKMKfk6fQ==
X-Received: by 2002:a05:6820:30e:: with SMTP id l14mr4890962ooe.38.1608041587284;
        Tue, 15 Dec 2020 06:13:07 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id a24sm4665919oop.40.2020.12.15.06.13.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 06:13:06 -0800 (PST)
Subject: Re: [PATCH v2 14/16] target/mips: Declare generic FPU functions in
 'translate.h'
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201214183739.500368-1-f4bug@amsat.org>
 <20201214183739.500368-15-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <51090a30-44da-4371-6d63-3f4e7ac71a6e@linaro.org>
Date:   Tue, 15 Dec 2020 08:13:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201214183739.500368-15-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 12:37 PM, Philippe Mathieu-Daudé wrote:
> Some FPU translation functions / registers can be used by
> ISA / ASE / extensions out of the big translate.c file.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate.h |  7 +++++++
>  target/mips/translate.c | 12 ++++++------
>  2 files changed, 13 insertions(+), 6 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

