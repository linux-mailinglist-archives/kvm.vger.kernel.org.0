Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2872D3598
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 22:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgLHVux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 16:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730199AbgLHVux (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 16:50:53 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F098C0613CF
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 13:50:13 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id f132so118060oib.12
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 13:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pxqZFKpCxt1YMmCRnRmZFTodNYlQR/RONK9lMwj2jVU=;
        b=zQsbgGjWu6V+B5JVuOMuDSb5iEFt9eGLaCETCMHJ4Y4LiwqkIM4bpvJpoyjgswnSvh
         VFNrxj3Enfx7IaHU3w3zhToIokBVbDMqBRo9UsibkOas7+y7WEghw7LpHZ3y+Gi2vYmn
         TgWdrwWsIrs09dxVpWdxQRFqSeqWDe0xmejWRYd08kcbT7b0y+KHP18wNQJnSI7Nq6RF
         cU4TeqKQpE/uP1aXL5YJ31MJfO9h2XyvTlmhpzWUsgDL3V4Q7u91W6Jgln4ookg2Hgeq
         nbEGvNE1/oggaTiREELMDLOux8IHwJF7WYXV8wS1prTkRdTg0t/QQL/t2EVPcwPISMq2
         uWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pxqZFKpCxt1YMmCRnRmZFTodNYlQR/RONK9lMwj2jVU=;
        b=XVjn13r7KGbCW/7pYBB5Skd+/XmiRy8QFsWhmEu2oYI1PSaTqANA/3YDAnkZulgubK
         or3/p6Aml0m4P+h2vl7ZNxMt87yWSFpqKtFdSYfAX+FTLBMaCIP1+7+/lu2eUdEu/ESC
         Xop32CiQl3TuaI+ObWADtYJnSoQi1rtHLom8qK/6uxEOrCwC86yQya5ch0w5djhWjREg
         t7EYX2nkdlCPbTNjufCq6AK94G0FHJJVNidtDYBazMUUgBjgp8nqeDMm3Y4A0hxMVOJd
         yWKUxLvNho0Cd5GeOAH0Q/DMCUjB7ORtLLpJ18EPw7/vilOSZGOlQupEd7AxPtGg4LP9
         VuSQ==
X-Gm-Message-State: AOAM532yhyXJ1O+MAvJrqWAas44OPd9AqqdDW/X1m++mD0aqKa0paot0
        emYmgt/H5JeHqZUdwo4JxJvP/Q==
X-Google-Smtp-Source: ABdhPJyOnKjKPWWhZgg3fUUBpi/TPH0TvxU3LEnX8ziNkxQYFhzUdC0YQlrp+RhoLJXoD77tBSCu6A==
X-Received: by 2002:aca:4c4f:: with SMTP id z76mr4460421oia.1.1607464212745;
        Tue, 08 Dec 2020 13:50:12 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id x20sm50652oov.33.2020.12.08.13.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 13:50:12 -0800 (PST)
Subject: Re: [PATCH 04/19] target/mips: Remove unused headers from
 cp0_helper.c
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-5-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <94c54de7-0a03-2f4e-122f-c921e772be7c@linaro.org>
Date:   Tue, 8 Dec 2020 15:50:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-5-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
> Remove unused headers and add missing "qemu/log.h" since
> qemu_log() is called.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/cp0_helper.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
