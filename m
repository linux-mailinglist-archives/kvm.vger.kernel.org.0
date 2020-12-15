Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7291E2DB78C
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 01:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbgLPABC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 19:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727701AbgLOXYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 18:24:23 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D70C061793
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:17:44 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id f132so25270252oib.12
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=is4tGvn1o1bqaWL/+p/iBKnhVDzDVqnbsJgyI3YJwcQ=;
        b=OMK4zMew/2i5KWpyEpvC3t7WhLib1buia6/v7Y17bcM4OCdCjXxGQGrL5iJzZQ1Bbt
         rwmcYlIklPZF4wyB70kn4uI2br6SIp6ZgcyED24xtUXXl9BF0Hf/XkSUbir3V13y4X7I
         qvbWg9Y1pFaNNUijj+DLtldb4U0yed9ct3cZgNGxki4qLBS7L4h4Z1mi5lIr59nDBGJQ
         x2Ruso9djdx7Svc6M/0+Q6CMzAH4XS+L4xWByc74a+mGfvpvl9qPKUshJn9gRRNFplj7
         xbtV781mmhv7WB2S1VBXHWspGVCfKro+j8pMppvrRx2wtsp9qbMjBwe+zFRiKtNBTFP9
         F/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=is4tGvn1o1bqaWL/+p/iBKnhVDzDVqnbsJgyI3YJwcQ=;
        b=hnsjFyLw2gs8ABCxNTQ9kE3y8I+3odZ8fO18x7dl/wbgqhmKJBs1Ho+vicd6MClLbB
         /Mprydpxf1y5nekaCuMsrYOwfqHZew3/hqw89mzosI4cKkvXXy8cJUMCxFdkpr/RZlRz
         EBuPHOe6+mToGFuLq6p5NmR4j8oY4pnXeqRqjYLQKTQQ9MYDJxHtcqmeQWizRH+FGDU7
         PmLH4rNjJ7UB7yg8broRghceIhMLnCM4/fy4635fm434zHzhpuyDcAp6N1hZYY2oP0CB
         L3Kv9w32GPUOizG9aQ7tDnipxjM8DFQcB3caXSYZzyDSTtZGsMzXblY/OoECI0FnVzFh
         cSSg==
X-Gm-Message-State: AOAM530DmZuKOVpUsX1sk5HxKbBQwLHqgNt2N+DRP0M0pnZTbAi4XTR1
        XC5HtybH9Ovt0LsG52ZlkhdSWQ==
X-Google-Smtp-Source: ABdhPJxgqmo7wq5zNRH1N61gyNPhcLl6an2GjcTTK4VuEfX+uNL3sThu2gPEa5F+hCgB9YelZyg73A==
X-Received: by 2002:aca:cd8d:: with SMTP id d135mr619707oig.143.1608074263991;
        Tue, 15 Dec 2020 15:17:43 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id o21sm2140otj.1.2020.12.15.15.17.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 15:17:43 -0800 (PST)
Subject: Re: [PATCH v2 21/24] target/mips: Extract LSA/DLSA translation
 generators
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
 <20201215225757.764263-22-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <f66367ac-e06f-8caa-6d57-ac20c327f0ec@linaro.org>
Date:   Tue, 15 Dec 2020 17:17:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201215225757.764263-22-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/20 4:57 PM, Philippe Mathieu-Daudé wrote:
> Extract gen_lsa() from translate.c and explode it as
> gen_LSA() and gen_DLSA().
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate.h            |  6 ++++
>  target/mips/translate.c            | 35 +++-----------------
>  target/mips/translate_addr_const.c | 52 ++++++++++++++++++++++++++++++
>  target/mips/meson.build            |  1 +
>  4 files changed, 63 insertions(+), 31 deletions(-)
>  create mode 100644 target/mips/translate_addr_const.c

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
