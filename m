Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D54B2DAE85
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 15:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgLOOGc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 09:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgLOOGS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 09:06:18 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C0FC0617A6
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:05:38 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id s75so23420922oih.1
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VSRvCLif/VkHTYroZqEOAGuvTQPetTsTqUTNTy/jVkM=;
        b=jrjvLjX2n581qSAqun5wgJAuTyM2sX/yweYKkNiZNP4ZXeXZ5ZxJ0WEdfTrKCYNlTl
         MACsREBonOcktvmQhuOIIvIA4bg7IdbmIqwGqX0Iz41NIkhWgvJphs9G5dfsc2H0WWMS
         ZLiJqGSA695Q/P0mLYohhsiPNUfjdyTg7bXwBkI++0qyPNM7SiXtOuDPq6pfvDTptmD5
         vqotmogVwyH1mVqe149MBv6EAzxysWPg5AjbwMxZ2QDHDNZUonEbnHtCUI/+KZiSD+mm
         +bEKUzflQlrT/83+LtzMqdD1Xfa+QXBIrBh9QGw40kDaaOYb8yFYgmgqyxhy60Fq7U2Z
         DsQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VSRvCLif/VkHTYroZqEOAGuvTQPetTsTqUTNTy/jVkM=;
        b=Qec3kD+4ceyPQoInjnyy7T8n2YEMQAnXFbutXKBug0TNbIQrhGcmZuEQoDIKW6MA0o
         Z6oy4eKNRld6BnImT4xQniAQoqMBI8wIx7/JHoXyoBvJfD8oqMEQqn7MdoIq5GNZkOn2
         bn6tKL4gSpr1FR3CtN1m83zMq9fLlUAvXmc3sdEbeHeahfyYytBdSauw9WQfzHzxC+1e
         GKgBicUblIowJaqUqQtppr5X+dy4vvSTPl3+tD3bDJV7FgZJ1vBbou0LeYYODAkM+C3h
         tknaEiHcWC8ipIUj4kaHufbZlseEWAFJ6PJ0AozSuj/fUsAxcDGRxiLSjI72kJwsQsMO
         tqLQ==
X-Gm-Message-State: AOAM533clskUVKPGWXqoKzVD7SWpLmVW5gzagP4wpCAHXnejxPvPxFft
        kRfG+XxirLycQnPPUFiqhnAkjQ==
X-Google-Smtp-Source: ABdhPJxarFw7t8qWVR5d6DyLSUnCvKtPx9VtvA9+047G+Poi4o/XHjpYAX40w4SXIuYyrMQvWd87nw==
X-Received: by 2002:aca:61c5:: with SMTP id v188mr21574182oib.66.1608041138156;
        Tue, 15 Dec 2020 06:05:38 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id 8sm438153otq.18.2020.12.15.06.05.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 06:05:37 -0800 (PST)
Subject: Re: [PATCH v2 03/16] target/mips: Add !CONFIG_USER_ONLY comment after
 #endif
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201214183739.500368-1-f4bug@amsat.org>
 <20201214183739.500368-4-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <f004fbf0-b46b-52c6-3890-9f4aae402698@linaro.org>
Date:   Tue, 15 Dec 2020 08:05:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201214183739.500368-4-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 12:37 PM, Philippe Mathieu-Daudé wrote:
> To help understand ifdef'ry, add comment after #endif.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/helper.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

