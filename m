Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DB12DB786
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 01:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbgLPAA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 19:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731172AbgLOXUL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 18:20:11 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34479C0611D0
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:19:31 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id s75so25308383oih.1
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BFk+RbFhUDPE+4uHD/EOO2rTkKk8eRA8B65xORGKwnM=;
        b=S7OgkjghOyLgLwUt+NoK3seQXXk1csS2SksfHSrRvdzfCNM5A0bxdMxOYMOFmNQQrB
         PhWFXN7dhroinkvX2vFDyReccMflmcg+oEzV3UwZM5L7/nURMiTQemZRScd+897ZV9ae
         5YKHUZFDHB1XplBMw9OFPcuCpK2kYHNF7DxsWkYy6zUuafN/8Njl3zeCS4N5IXRC/TSb
         w63pYXIhC4BKghvXCF5H45cOEQmMOLhJ/dh9rDMfyO68ctCnn0+bzf3viTiE976+Cd3w
         u8oTuaBpfqhrJP0y/imIEcQW+86PmIRmQhT9V5G3uxYnHC/dnUA5pNE9LmlIGuTL+kkC
         aCig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BFk+RbFhUDPE+4uHD/EOO2rTkKk8eRA8B65xORGKwnM=;
        b=L1EpDEwiNrOoRWL4cTEOvV1yQLhLLn3kOXZn32ZF4orH/wQ+DLoysmiOZdX1hZRgqG
         3ZFoLHmCOp7LpeSqwqHdmEpfnoryx73ZrJxE+Xd1kIPG6FVnjqIDjlOIZW5/HksUGR9j
         FrGPlwINMb6YiUhs+gpXrOZYtN1o7fiD6CZ7jldtCkLf4ZMUeieRC0vW+IHjYOM/Upai
         SKOl/eDYmDDCYKaBefhPuU0IIZYw85LsszdcE3if0EQDK9A7ybLVmlifkirJ23fJL2jB
         3H2DXhDz+JIk/uGUDK7dqkL/nGWhjmrxzct9GBOApQzA/lHlnkGh3iutMkEEq+hCYWvq
         4zxQ==
X-Gm-Message-State: AOAM533eRMsA0dOlfjVLi5IHqTDe8BS8F4f8Oi0B/0V4l7Um4TKtFE0O
        Ld062lc+Qf0fwGEuyl1jnJfcUw==
X-Google-Smtp-Source: ABdhPJxSkuob1gD8ovABSieDXdTsLywP6dtXReK4/D/YRFFSZUnjhgUyvGHzUTOimHUERWYgkeug2A==
X-Received: by 2002:aca:410:: with SMTP id 16mr607949oie.97.1608074370684;
        Tue, 15 Dec 2020 15:19:30 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id q18sm70807ood.35.2020.12.15.15.19.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 15:19:30 -0800 (PST)
Subject: Re: [PATCH v2 20/24] target/mips: Use decode_ase_msa() generated from
 decodetree
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
 <20201215225757.764263-21-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <efb56dcc-3322-075d-7f00-89ad9b045bb2@linaro.org>
Date:   Tue, 15 Dec 2020 17:15:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201215225757.764263-21-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/20 4:57 PM, Philippe Mathieu-Daudé wrote:
> Now that we can decode the MSA ASE opcodes with decode_msa32(),
> use it and remove the unreachable code.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate.h         | 12 ------------
>  target/mips/mod-msa_translate.c | 29 +----------------------------
>  target/mips/translate.c         | 31 ++++++++++---------------------
>  3 files changed, 11 insertions(+), 61 deletions(-)

Need an update to the comment after function name change?

Otherwise,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
