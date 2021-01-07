Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685092ED6B4
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 19:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbhAGS3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 13:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbhAGS3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 13:29:50 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73C8C0612F4
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 10:29:09 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id r7so6597448wrc.5
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 10:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8Sp6xnppzP63IJbAIlt4s8+XoPyS9MrOwigW3DBOc8I=;
        b=S7ik/Bsh9MCt+12Vz8XDQY7mHbub+gCil64G4Me/IB1twAMh14V1kAgW8VGgBf0aMh
         ns1ZjoBnuavYSe3vk3HO+zACS54EOTyjV02HEQpaXrFwDnd9Av+Lia6o2UhskyB9SHEW
         s2y7JJSKO23pjoK6nmFQKIisxhUwTtfysLcGoDN0ziS72EsCqvYlYH9Xt0gNzeepkjm5
         hxvnqH3oVLbz4VT3+TtNScCk1RhFbk2Ltjegkme6asFObBySsSKlQTJimoYn8Ey53oJ5
         /gmRo8IFfaucWjfiAr0Xp4K2c+4KxF5qyH+FbfyAghb2VLrIyFjzl2COu11XkDdUBOFa
         0Q5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8Sp6xnppzP63IJbAIlt4s8+XoPyS9MrOwigW3DBOc8I=;
        b=Cv0kHPe1exlFfON1TuoyJYaD7B3hCPUc+SiQ1nur4xXncKPI1+L1d7zB6yNYNao2Wr
         rbLKP2QfUBmHOY7qm4GFdamsGdbvilAQJ4OJP5cxv4uyjYaultmDtudWdV9UBgtPwadT
         PnAXos4WnuUNH73irXgaRuQ3Na5zs0rkXAG6oVwq8zD6/mOmiMlMFVZmRERLS43NEwea
         h6fM7vKaXUiqA+AxkX9Uch/sZhVa3tbZZW9hyN5Ga7kx8hxM9Z6T9VGMr/X95UltsmZx
         9xQPZRIgv9j1obAs/0SRHtaOLODrT9cYNbDy2MciKmq8c8O82918TafsiUKuOoqA+UA6
         Z3XQ==
X-Gm-Message-State: AOAM53330nTskz54CctVnK+70HiJLTktrTOEbqVOvrN/ohVztgoboG9K
        a2AHUqPUdPbQgRotdqS60Q4=
X-Google-Smtp-Source: ABdhPJxekrwZ2/W2aMw3OGWtNJHP+lJH2vA4UWYZ5PyH45sm1AhVQRw0qxRPP/MyYy7h5SZRwPfHxQ==
X-Received: by 2002:adf:a495:: with SMTP id g21mr10729866wrb.198.1610044148765;
        Thu, 07 Jan 2021 10:29:08 -0800 (PST)
Received: from [192.168.1.36] (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id w17sm8472022wmk.12.2021.01.07.10.29.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 10:29:07 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH v2 00/24] target/mips: Convert MSA ASE to decodetree
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201215225757.764263-1-f4bug@amsat.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <a4a92c8d-21d5-5300-bef7-2ee3129e6a13@amsat.org>
Date:   Thu, 7 Jan 2021 19:29:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/20 11:57 PM, Philippe Mathieu-Daudé wrote:
> Philippe Mathieu-Daudé (24):
>   target/mips/translate: Extract decode_opc_legacy() from decode_opc()
>   target/mips/translate: Expose check_mips_64() to 32-bit mode
>   target/mips/cpu: Introduce isa_rel6_available() helper
>   target/mips: Introduce ase_msa_available() helper
>   target/mips: Simplify msa_reset()
>   target/mips: Use CP0_Config3 to set MIPS_HFLAG_MSA
>   target/mips: Simplify MSA TCG logic
>   target/mips: Remove now unused ASE_MSA definition
>   target/mips: Alias MSA vector registers on FPU scalar registers
>   target/mips: Extract msa_translate_init() from mips_tcg_init()
>   target/mips: Remove CPUMIPSState* argument from gen_msa*() methods
>   target/mips: Explode gen_msa_branch() as gen_msa_BxZ_V/BxZ()
>   target/mips: Rename msa_helper.c as mod-msa_helper.c
>   target/mips: Move msa_reset() to mod-msa_helper.c
>   target/mips: Extract MSA helpers from op_helper.c
>   target/mips: Extract MSA helper definitions
>   target/mips: Declare gen_msa/_branch() in 'translate.h'
>   target/mips: Extract MSA translation routines
>   target/mips: Introduce decode tree bindings for MSA opcodes
>   target/mips: Use decode_ase_msa() generated from decodetree
>   target/mips: Extract LSA/DLSA translation generators
>   target/mips: Introduce decodetree helpers for MSA LSA/DLSA opcodes
>   target/mips: Introduce decodetree helpers for Release6 LSA/DLSA
>     opcodes
>   target/mips/mod-msa: Pass TCGCond argument to gen_check_zero_element()

Thanks, series queued to mips-next
(without patch #3 "Introduce isa_rel6_available helper").
