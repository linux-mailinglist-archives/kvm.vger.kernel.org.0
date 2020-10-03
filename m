Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561BD282359
	for <lists+kvm@lfdr.de>; Sat,  3 Oct 2020 11:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbgJCJxh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 05:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgJCJxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Oct 2020 05:53:37 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2147C0613D0
        for <kvm@vger.kernel.org>; Sat,  3 Oct 2020 02:53:34 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id q21so3849199ota.8
        for <kvm@vger.kernel.org>; Sat, 03 Oct 2020 02:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=obIunJMCwuIctwMB9KHyMjEcZAsycYX2a/PARzklzgo=;
        b=e6AdNSF8ykaX1FRPeb0Av9rzGcI6O/WKjwfucJ0YWkM2PWqm4XXzoO8A7B/wgLAjgJ
         jwmVw7iegXUiPIuumoqUV+pbHwz5LqTgso0qHLSoAkMhPrcHl/EtqNa538JQbvcmsIee
         mYPulDS/O9ZsiGUJPi5FlBDl/N+8joV6u1R1gb2g14QDvj52ENpUkRvRi5Ka67umkufO
         8f/VJ5hNm8bl2RKyrR226RCuo5+kMTJ09UjHfrU26ZIIB+h/y311oK3EIPkKGRcD/yJW
         0U1v4jHJ0ovP3h+//HxR5TBDApmGa4/blsu4aium9WyQjaOM2muWO3c5v2VlxCUUkKGV
         bOnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=obIunJMCwuIctwMB9KHyMjEcZAsycYX2a/PARzklzgo=;
        b=OpKr/ufnNo971JIeEBRRornh/QL8LVyHvSdNovHre+CmYq7+OQEkjfd/RR6q62dN6B
         n2pY8CG+Rr8eZSeEFUhba3g8mGWuL+umSC2DksVZdCs/8xWonG7en1qcexMu6Ol5U0Zq
         v/FYBx33NoTmpfKjGf5XVCMCStTHrQoqCFbcu8QmVpZquTibSfFfG8rhg1gcrRQgovVH
         Chy4NK1fkDMhkpEtuajTPs1WXBhl06VTzWzE6Xxa3iOL6iVLa2harwXFTTcyGgV5l558
         g/hFDmtzoyDiyedo6RNtdeZNyOjPXud+NfPJYgtqwafqxlqt098OuKP2HFPW/XYN3Q9c
         pqIw==
X-Gm-Message-State: AOAM5322/p57gd8RWGRPCed5+Vq9QM/K4962EMaOZU2U5nSdq4WBH8jF
        6u8W22oSuc8HOA2kbH6d/0hTTA==
X-Google-Smtp-Source: ABdhPJzortVGd43nIZrKjIRjdtZc+WQ0B+CpSCY952bMMF8IDrxjYl/ZrH209h+EJ6RbncHWhg6Nog==
X-Received: by 2002:a9d:5509:: with SMTP id l9mr5179019oth.154.1601718814363;
        Sat, 03 Oct 2020 02:53:34 -0700 (PDT)
Received: from [10.10.73.179] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id c12sm1087623otm.61.2020.10.03.02.53.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2020 02:53:32 -0700 (PDT)
Subject: Re: [PATCH v4 11/12] target/arm: Reorder meson.build rules
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>
References: <20200929224355.1224017-1-philmd@redhat.com>
 <20200929224355.1224017-12-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <1328c0d8-be1d-1cbc-2c58-f17d078a1104@linaro.org>
Date:   Sat, 3 Oct 2020 04:53:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200929224355.1224017-12-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/29/20 5:43 PM, Philippe Mathieu-Daudé wrote:
> Reorder the rules to make this file easier to modify.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
> I prefer to not squash that with the previous patch,
> as it makes it harder to review.
> ---
>  target/arm/meson.build | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

