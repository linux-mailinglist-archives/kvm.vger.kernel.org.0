Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3E92CF1F4
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 17:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgLDQcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 11:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbgLDQb7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 11:31:59 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752C6C061A4F
        for <kvm@vger.kernel.org>; Fri,  4 Dec 2020 08:31:13 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id y74so6717812oia.11
        for <kvm@vger.kernel.org>; Fri, 04 Dec 2020 08:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oVQ8Jyij3kwsUSz347eZLqyy7mOWb110oe/eMlr98uE=;
        b=tTfy1CQ5SaUdqr+ddvk86+k3Ffp0BuJSM8Dz2DoAUGIo9hFES2jhPu/2QX17w6at9M
         nuN9hiPm2P/NFkxhh1Jj93rZ5UGkNun/Gqy/M4Z75SsAuA/HNuG+XUcfHuiZYpSV6f4s
         PMSzk/YIQWld3kcej8SYIWS3FE6+XytmeCv+S6254prp8pWom6Mzoi8sXrDzroNrLf8+
         yf9erVL3RMGiBPVNp6Xn5VWAHMz2G4I2STSmKOX1hnQOHaDXFHk3prTLmRGw5OaWQUKo
         NkBm44dtmbzyvT7ZxfFiwq5opJDADzV01ugHHqhUEmElooiD13O3nCjAykKwq6aVjgbq
         Gu0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oVQ8Jyij3kwsUSz347eZLqyy7mOWb110oe/eMlr98uE=;
        b=PKixx7LV7WnA4ERl3xkqZBiiy704fJMsy8ua7xXSMqKLc1Hxdaoy6vxE0Lk+/mzhOx
         q2VbTqiKJl3hAb4EjXy3aXBGXxPmEigqfo/rUr5HkUDU6kJPaS0sq4TJI2m3cVwCvctW
         1t+DOT3bbZggrh8Y8XbYC8k049hwsyOGqcEqD4DqZpMPNphpO8kDWBfpHiUw1H3h5Cl4
         luObvOtG3Nh56G8TgR4FUr/0+QLt/Py88N2TuXLousjsDobSfa2yZaEFRlkNo7hisq+M
         fTpehZQ7DlIQ6Wfe+6tALlc6BMSGWM/S44ftblWZ9NgBLueFBDb6S0hxSVgjGyREwSxv
         Pewg==
X-Gm-Message-State: AOAM530HnfmVPtAAuV22bVBAbFfefSDTKliYPV1s0OW8ydXUoKRzrtMC
        8LCLW59rklQ6pV2N5IeJ6OSfaQ==
X-Google-Smtp-Source: ABdhPJyzvqk46X2qIGncv4g+/pu4QXgdfdzaYNMEhkVBj/wJpZ/FACiTkQhbSHWkDLL3ShUnKl6zdQ==
X-Received: by 2002:aca:6287:: with SMTP id w129mr3744994oib.82.1607099472937;
        Fri, 04 Dec 2020 08:31:12 -0800 (PST)
Received: from [172.24.51.127] (168.189-204-159.bestelclientes.com.mx. [189.204.159.168])
        by smtp.gmail.com with ESMTPSA id n3sm726000oif.42.2020.12.04.08.31.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 08:31:12 -0800 (PST)
Subject: Re: [PATCH 8/9] target/mips: Remove CPUMIPSState* argument from
 gen_msa*() methods
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201202184415.1434484-1-f4bug@amsat.org>
 <20201202184415.1434484-9-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <ed037c91-4dd1-8171-fbe0-32717af0ce97@linaro.org>
Date:   Fri, 4 Dec 2020 10:31:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201202184415.1434484-9-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/20 12:44 PM, Philippe Mathieu-Daudé wrote:
> The gen_msa*() methods don't use the "CPUMIPSState *env"
> argument. Remove it to simplify.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate.c | 57 ++++++++++++++++++++---------------------
>  1 file changed, 28 insertions(+), 29 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
