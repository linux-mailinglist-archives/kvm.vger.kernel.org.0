Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97652DAEB2
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 15:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgLOOPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 09:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728893AbgLOOPC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 09:15:02 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BF7C06179C
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:14:22 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id j20so14969197otq.5
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mxSP3kFM7PYG2X3Xvc5Q+8/V1v1oyvnId/RXHuZQRWo=;
        b=fV2YmI952lufK9e+eyVRtJZmjiCdyZNvvFXsyOcyQfQD/h/JT49wroGtIZoJp9uD89
         G8Gi32FXD3KByJuQ6qegR6W+NdaRGHXbrVQ9unZoEp5tMeEpV3FwaaoPNhnoO+qTangi
         SJeQkONy7qqGt69XoCWaL2TQkeJaCFkfr3+IW7PKSsrM2ZLC1HMeurFrVB0L+dtlFxWk
         xrBqkN0Xgl2sVw8kdZ/JSpdwC3bEa8iZndymKbfTqXj3ZaafDrV83jxYXMjWrL/j/r8w
         tRwsfm4LeJfX6ktDH7MP8SaOz75CYRJbLGvnEOWP6gAQZH5i2ccp2nlrABwWo9liftQE
         ATRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mxSP3kFM7PYG2X3Xvc5Q+8/V1v1oyvnId/RXHuZQRWo=;
        b=diwqNZ4chwK/Bet595knbayGiSWWw4EVH8JE/X7CD6Xs3uMNy0eLXOpUCBtshL95fS
         ZUEpwsPak45sfMJf3sPhxlF//fHamZyZZW5HEwcuyRiMO4PEDBCNWoUV/aU7YTiRTIOi
         bHnm++6qW5hlsEWnX4EzPuA6bRkFYGPSfH/2ByUtsKqx6WcujPaGu0JKa/3VsQbUnE8z
         sLAwtKfgTX7XKFiZzLNAzq75HI65XJ5BuKstsNHp69GCG75oRF3s6XUGmdPUPEUqaCC7
         LN3LfKEZY5lui9A0UrcqR5SsevAZXf3hI8naDVBgLU56CWflQkQ+XbRfaFYDVxodob4l
         Bj/Q==
X-Gm-Message-State: AOAM530MLyudxymBuOfqrA8KQY9jQT0XfZKyV3rDXxE3DcN9O7oQSYRr
        P9NpTgP7VZ5PHL4XPEnpwAILAQ==
X-Google-Smtp-Source: ABdhPJxPVdLqgoucY7TCXjLsFxLSkdajXZ5cb1t/Q0TlwVl6oVZI05fXJy+pkozxqeqMRL46/egGqQ==
X-Received: by 2002:a9d:590c:: with SMTP id t12mr22974744oth.308.1608041660340;
        Tue, 15 Dec 2020 06:14:20 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id p4sm5102367oib.24.2020.12.15.06.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 06:14:19 -0800 (PST)
Subject: Re: [PATCH v2 15/16] target/mips: Extract FPU specific definitions to
 translate.h
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201214183739.500368-1-f4bug@amsat.org>
 <20201214183739.500368-16-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <14fc4112-a7da-0665-4009-ae3c6e8dbbe3@linaro.org>
Date:   Tue, 15 Dec 2020 08:14:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201214183739.500368-16-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 12:37 PM, Philippe Mathieu-Daudé wrote:
> Extract FPU specific definitions that can be used by
> ISA / ASE / extensions to translate.h header.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate.h | 71 +++++++++++++++++++++++++++++++++++++++++
>  target/mips/translate.c | 70 ----------------------------------------
>  2 files changed, 71 insertions(+), 70 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

