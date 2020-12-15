Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378562DAE8B
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 15:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgLOOH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 09:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbgLOOHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 09:07:47 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC17C06179C
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:07:06 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id q25so19412680otn.10
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bPt1r7O8pwmS+V4deEofXmXNttx/eGng+UvY0u/DvaU=;
        b=HW2+s1AptjiA+uSO/ZiWUvzG9sfmzSUwP8raqNuzezCYRhK4s9hrLlXBucpu8coHbQ
         6h/pmDqgJc6JUAzGaZp5PqC+rhEHShqx+fY63tV7qWC0BmgrNYPBeCCQB9EIdE1K5Xkg
         lOY9HWBJ04TzGnivEAcSlpwPBSmIziZcUbUHqyAk45uMgFS5hny0PFp4z/ouO0sH268N
         colnko22hSeiZFXBEpvVWr6w/wRxPQoEoawqCY4eU7yD/l/eSJdNhAs3vtXQWiND9Hy7
         L9b30osKNx6VVXllcvD+jd2oZ1d0byOUvq2NfGMOsUS++BNDzkOlURsfZD69AtpuXxNd
         OyYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bPt1r7O8pwmS+V4deEofXmXNttx/eGng+UvY0u/DvaU=;
        b=QFCgEhGxSMzdoNJ/lSlq68kiwCK8I0dbF8KBXtezUu2BgOcM+kvB8xyldjKgq00i/X
         MNECpJKkNfPGUmdS/6KfFE37Rzw4tHplUjx/Y3Cy+njPn7jUjesQ2OfE2KGCTXcRopf6
         eKcHBcVQmbiqe0wTuL5+2TKip2q42FEhh6NlGYw0AEmlUGsjKv2RxDp/l2Kpt/pvXhwt
         Fv0TlUGUXcfCL11vNsXmjdEuwuYdCdVA4y33W2Xk+qqtnxjN4Dy1GovP9MKZMT5OBpEQ
         r+oLwcqbwQqkbzNvv2zJHVEMvvqhIYRyun1WzPkfBuhr6qKX5y4EJnZA6HUMQeu9I2Ic
         yhrg==
X-Gm-Message-State: AOAM530EpQ80Y7f6G1IZ5+oCcS6EYouhGUPi6qhYZsYBJMNVKEuxkojE
        jAurivIharjtY5xAKXpiKtGsFA==
X-Google-Smtp-Source: ABdhPJxPxgxTM+IU27ZoUuAgT9LjWvXlzO+DCwdZt7KMBzlRGCHpL8/jf3LnYmQXZinbWiQjyl54qw==
X-Received: by 2002:a9d:b8e:: with SMTP id 14mr22973155oth.316.1608041225732;
        Tue, 15 Dec 2020 06:07:05 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id e12sm428518otp.25.2020.12.15.06.07.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 06:07:05 -0800 (PST)
Subject: Re: [PATCH v2 05/16] target/mips: Extract common helpers from
 helper.c to common_helper.c
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201214183739.500368-1-f4bug@amsat.org>
 <20201214183739.500368-6-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <c9164ee8-ef2a-269d-daf6-6e1efa5fc24e@linaro.org>
Date:   Tue, 15 Dec 2020 08:07:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201214183739.500368-6-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 12:37 PM, Philippe Mathieu-Daudé wrote:
> The rest of helper.c is TLB related. Extract the non TLB
> specific functions to a new file, so we can rename helper.c
> as tlb_helper.c in the next commit.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/internal.h |   2 +
>  target/mips/cpu.c      | 215 +++++++++++++++++++++++++++++++++++++++--
>  target/mips/helper.c   | 201 --------------------------------------
>  3 files changed, 211 insertions(+), 207 deletions(-)

Subject and comment need updating for cpu.c.  Otherwise,

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

