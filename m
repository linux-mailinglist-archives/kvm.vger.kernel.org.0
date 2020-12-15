Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624F32DAE87
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 15:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgLOOGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 09:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgLOOGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 09:06:35 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD6CC0617A7
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:05:55 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id 9so16257916oiq.3
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sF5MqK4yxd9gDJ0iX5slLKtyZ6EKixC9fgB+YXtc2dk=;
        b=oMqXJtOwgpkEv3jAmMh9mvWAKKuW+kre0fOiqr4U1JaQonzU//HA9TtT3V4ocbKqs4
         ryJhp8EesYy2SlzCKgCmW5MAaNujYOfx1Z459yAFitQQb94w7PYySZKqGpPUlA1tFIVS
         a1oQ1PaahYhAC5Xuvrgrath/Y/IGnlnp1/AI6argTrGsr1t148nP3xoPElfzoG1HE9KM
         ilmFUTjRyUHApXMSToFOC79yY3yyNBw9uXZ2S6BLKFIcll/rQtS38JC1zA9HJhpkM7+1
         npR3geazLj1Cv7mlqhFQQu6TKI4ljojRiTRZFpjOTDRFujohjMvxlBN7ilc6o9z5B1kW
         4dDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sF5MqK4yxd9gDJ0iX5slLKtyZ6EKixC9fgB+YXtc2dk=;
        b=gubHyJTTOqCLGaVsqsko8TVI5JMTiRzA/sFZs4unnAhF4qG9T67S9fkCGQAvVNt5Wf
         6enGc21j+S1ZsyhbJwptoxAVHI8epILrjGn7Ut19W5i0z+si5LcjO0hv1SGNW8OuUBl2
         2ohFL/niFa1A39jNY/hTvvuoYX5pZJp5lYPI65Q60sED16GoEFc9JP0IpX16BxbvzIxJ
         cjLz2Egy05UzzKb6yFwcPULdSYCBYrwAninXNMl0XeESj+dkJSbZFggdO3tejr1RrH0o
         /yqNwp1aqRin7BKKbz9eBHQkX3UOBrI+bMp/tfXmnQEjNwmCD3bDiAj00APMVCCRQzeY
         //Og==
X-Gm-Message-State: AOAM531x8ZWUR0ckeubqZAB8dxW3hZfhvWTQxYZr7udGMvePDLehLPKK
        XoOWpX04wN+ZI8TDFfrptswELLRyct0tklhR
X-Google-Smtp-Source: ABdhPJwGyo0ebi1PtpjkY3UEX+D+pWBmfOuIapdRwZ2HL5QN2jdZP2U/wv3hHEfKsrPIKJdMOiTAuA==
X-Received: by 2002:aca:4f47:: with SMTP id d68mr21718103oib.135.1608041154730;
        Tue, 15 Dec 2020 06:05:54 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id u24sm19515otj.27.2020.12.15.06.05.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 06:05:53 -0800 (PST)
Subject: Re: [PATCH v2 04/16] target/mips: Remove consecutive CONFIG_USER_ONLY
 ifdefs
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201214183739.500368-1-f4bug@amsat.org>
 <20201214183739.500368-5-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <1a39c10c-4bc0-3468-e781-727b6d23710a@linaro.org>
Date:   Tue, 15 Dec 2020 08:05:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201214183739.500368-5-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 12:37 PM, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/helper.c | 2 --
>  1 file changed, 2 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

