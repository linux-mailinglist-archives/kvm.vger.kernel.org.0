Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6702DB6F7
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 00:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbgLOXMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 18:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729007AbgLOXMN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 18:12:13 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974C1C0613D3
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:11:33 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id o11so21103279ote.4
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Lz1xbFKIWO9ONK28it2SNE/LQOKsuqwVt2zWkA8/kL4=;
        b=ca9lEI/qt2S4mVe5bgCP+yms7Hh5PKjFxuvO4LDtYP64XCgxbl3mdbAv/KFqnZXFTQ
         hPhlDv+UC9aGQwgoaSEIWqMfWRlAzOOH4Zyy/SNHs9WEivDO0Rj3AJ412xgdtc03e0ob
         IlpE5l1FsmSqCWMa97LhlkeqZCiF8dU26e18NgVRrwI/R+II6J1S+wJOslRL6LuN8vbb
         8jlIpV+tuUD95+by1N/Rtvtu8Cnph74/xomSjvn0hNdGEY9d2Y+K00ge2i9R4ZRMvr8/
         F45hiHA0fzfivmdTJEK+Gb+GtHtC+SGHb4JfEmGdDbxE1dChgRUenJ5LIsIoRiZiSwOA
         Ef1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lz1xbFKIWO9ONK28it2SNE/LQOKsuqwVt2zWkA8/kL4=;
        b=HsK08rHVFzxFZb/E96lp3HsFnZPUJD8YALcmp6AohhyxooOT65pVOXxdzVnJhgpJKE
         xThI3ngq7kdPreMzsHqXsdF/G/vwG0neyaIIIw2NUBL6JN8J11YApu8R6OOwxVIVc8vP
         pTrbOJDPzjYBBF3EmJjom+uVSK1ouHtbuQGwpE9feQaSrJ6qdvChtlgunfntSA4rJ2HS
         L9Ev1Wnrck9WMYrs9HG0Bh8JmneQP4cJitBfDtHpPodwelK+R7bj+mHqCLtZ1/qtQPMt
         IP4vc49iAGrvOIMEFNh3XgpKHSezB7Mx+nKGwpFX1nob/8RGNhiOmUtvmuIeeUUzZT7Y
         qUlg==
X-Gm-Message-State: AOAM532WrahJaQTwTjU1WRXnmXQ3O9ItAECWeV2L52qi0/DZ9vXDIpSe
        iXkz+6prZ+BWZU4cJC9hCbA+7Q==
X-Google-Smtp-Source: ABdhPJytM5CFdCIBe0hRP/2U/AJegRMLiiY11crEq9JgKyKpx8VdYNdsxHE+Y10SNkUnDPVrXDZA3g==
X-Received: by 2002:a9d:875:: with SMTP id 108mr24825618oty.164.1608073893067;
        Tue, 15 Dec 2020 15:11:33 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id z6sm83054ooz.17.2020.12.15.15.11.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 15:11:32 -0800 (PST)
Subject: Re: [PATCH v2 19/24] target/mips: Introduce decode tree bindings for
 MSA opcodes
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
 <20201215225757.764263-20-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <4bdacecb-b1c1-44a3-2482-c2f2d6d59d9f@linaro.org>
Date:   Tue, 15 Dec 2020 17:11:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201215225757.764263-20-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/20 4:57 PM, Philippe Mathieu-Daudé wrote:
> Introduce the 'mod-msa32' decodetree config for the 32-bit MSA ASE.
> 
> We decode the branch instructions, and all instructions based
> on the MSA opcode.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate.h         |  3 +++
>  target/mips/mod-msa32.decode    | 24 +++++++++++++++++++++
>  target/mips/mod-msa_translate.c | 37 ++++++++++++++++++++++++++++++++-
>  target/mips/translate.c         |  1 -
>  target/mips/meson.build         |  5 +++++
>  5 files changed, 68 insertions(+), 2 deletions(-)
>  create mode 100644 target/mips/mod-msa32.decode

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
