Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB6D2CDC2D
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 18:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731529AbgLCRQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 12:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgLCRQI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 12:16:08 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642E8C061A4E
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 09:15:28 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id l207so35276oib.4
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 09:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tkX1L2NGLMB/axOms6Hhh7D4TuviErNIKjqsPIVDxBk=;
        b=C1xHSdLQP00hPDk3WCClzScsGR8VYRrh2I+wOSlTYqxyaC5nMQEn3u+xEh6P3kAgXI
         ESnfmetdTEJRYh4jwoRbYG/eBHjDzlqzk7USCnJ55doeXgfE9sOsLG65G8qOp5vF2kHb
         v/+J7ZNP6pEmsAh69I5PpT1MP3xF6Ma6eJCWd5Cvvs8Zb8QHi8nR6x9j3qeBcxIZroI0
         HQb5OK+SooRsT2WM/I7sENd81UonjJrCFYmHo/R+lS6oayBN6x3tGf+n7iB5CnDjtZPQ
         FbsiqL2UqfLdINztbmsShTBy1nXIICGaanfC/8myiLcGfaGEBbBSNXS9J6IrxHYBlDr4
         pmLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tkX1L2NGLMB/axOms6Hhh7D4TuviErNIKjqsPIVDxBk=;
        b=EI0KU8/frOSGqZ9u2ALvvfNv0eu58YPUPBySqfDH/5RUWLYjg0LUtJSNz0BRvt5Qen
         b6k9qhZW7kJ0+zdbWzxsm2SLaN0CDM17o9u10bilEDrDGXZWUAl7G32ihUZEBTfGLYyZ
         XLWvhTpR6oSzw4CnpiUKJaVDO0dlyC/3sa5+SN2UCttBiQv79rCN0URC2gZOYVgo+muf
         G0LIEStX8NWjOhq4K4xEuyTy+G8Fra/Q06gP4LLdC46Ot3OvlAegATEA5lZ9gYHFrhFG
         w++amIesEvvC+V+F4iL7feNWP7uJgWUi/CVevf+K9ti1jrGj6+7n3HKs46agcpVH2OMs
         R+Qg==
X-Gm-Message-State: AOAM531YW7/1metGLY+iLC24kdIN86khdVef1ESGJrQ7jWiqDygBbm1B
        QGn5t+oM3cmX0GG7JA9Tl79kFbMkUUb5kzIr
X-Google-Smtp-Source: ABdhPJydWoHFuhiXh2/cYdK26Y6Gy9BzSFapMm6g6xhz1JvrsmPp5owyC8Iq3BW/6Sr9pOR+dMTc2w==
X-Received: by 2002:aca:5fc2:: with SMTP id t185mr85405oib.113.1607015727868;
        Thu, 03 Dec 2020 09:15:27 -0800 (PST)
Received: from [172.24.51.127] (168.189-204-159.bestelclientes.com.mx. [189.204.159.168])
        by smtp.gmail.com with ESMTPSA id g82sm429160oib.38.2020.12.03.09.15.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 09:15:27 -0800 (PST)
Subject: Re: [PATCH 5/9] target/mips: Remove now unused ASE_MSA definition
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201202184415.1434484-1-f4bug@amsat.org>
 <20201202184415.1434484-6-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <b55b94f8-d0c8-2ac4-b9e6-3f39399be22c@linaro.org>
Date:   Thu, 3 Dec 2020 11:15:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201202184415.1434484-6-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/20 12:44 PM, Philippe Mathieu-Daudé wrote:
> We don't use ASE_MSA anymore (replaced by ase_msa_available()
> checking MSAP bit from CP0_Config3). Remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/mips-defs.h          | 1 -
>  target/mips/translate_init.c.inc | 8 ++++----
>  2 files changed, 4 insertions(+), 5 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

