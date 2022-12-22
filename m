Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67101653CC3
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 09:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiLVIGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 03:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiLVIGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 03:06:35 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0336418B2E
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 00:06:34 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o15so842647wmr.4
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 00:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pFjyqbpnz02nXZRvchFyHNpd7pQiGZsTqk5Z7SiuaF8=;
        b=eW5xUV4UQsXhlD8Q8Octu9n9cPSq6Sm197N0qRQPhIU32SabSOxk+11LHzxdmlTo9A
         OVU2hDkwRQFwr9+WDXkpTLlMoZbd6om/HyGfMxHhvKGbdSembbwcfgNStVJruDNK5Otg
         EULwUIgjWAkH6FIEsPoRZBi8dziwTT3ZwaKCMvSECdjnynljneJdLRfFPJrp+h4CHqPL
         6C5c1Fr2bXfLXo1rtNaKM9/7bMcIhjqe0YKQpZwu2Ou4nx0rcC7OXqv+ehFdsl9xuewR
         /RieivbkjqEGpsjTaFHezkT05IIt1qLtq2w0VibL3LTfv0sw5g60Fx4AFYb6JlP+yxDW
         FRBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pFjyqbpnz02nXZRvchFyHNpd7pQiGZsTqk5Z7SiuaF8=;
        b=YUfNpeSfBiIzx9M/a5wNSH0kHBvVP/SQVah251kdvtfzNzXIt0ieiFB1rHA/Xi4yVX
         PgmuAWWaoEMaH0z0Laigpzj+09QTGL5UKJs4AaWquOTTJBWfl9s5UdbYLHzRcozZLHit
         AGk7QPYV5AJEvq99WQg+L+5CgL8odzwJ6rxO7NYLTquODba95v2M70hc0aUcAqAgosyT
         bZd6MkpnqclicixqXjRJ47FOhlvAibkB0M5Xsq3em2X6pY4sSZZQXdhm128Gn7lvzAcp
         /ePQZItGpjIMrDkemnImrGbh5mY2bG75n47tbzQGyPNvsibiPfWLAw3OnGztmLahW9JB
         k34Q==
X-Gm-Message-State: AFqh2kqf0lAIeNEZZP3rmilQ6Gx1+JRsomf4fzJUHKGzHtCp2Dni6xa8
        pymhwHQ5Rs8Nw2WbSwFtAKg+jA==
X-Google-Smtp-Source: AMrXdXs5goaEzrr0Isx4+zXUKVAdcbu6ZsaBdU2WK04IY4Zy0L0UiqvznqE6j5qNhocgTeWOOLDaIw==
X-Received: by 2002:a1c:4b03:0:b0:3d9:103d:9081 with SMTP id y3-20020a1c4b03000000b003d9103d9081mr2047772wma.28.1671696392616;
        Thu, 22 Dec 2022 00:06:32 -0800 (PST)
Received: from [192.168.30.216] ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id n41-20020a05600c3ba900b003d358beab9dsm46242wms.47.2022.12.22.00.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 00:06:32 -0800 (PST)
Message-ID: <947734cf-7790-fa14-cb48-b2b48cc54896@linaro.org>
Date:   Thu, 22 Dec 2022 09:06:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH v2] MIPS: remove support for trap and emulate KVM
Content-Language: en-US
To:     qemu-devel@nongnu.org
Cc:     libvir-list@redhat.com, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>
References: <20221221091718.71844-1-philmd@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221221091718.71844-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/12/22 10:17, Philippe Mathieu-Daudé wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> This support was limited to the Malta board, drop it.
> I do not have a machine that can run VZ KVM, so I am assuming
> that it works for -M malta as well.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
> Since Paolo's v1:
> 
> - Remove cpu_mips_kvm_um_phys_to_kseg0() declaration in "cpu.h"
> - Remove unused KVM_KSEG0_BASE/KVM_KSEG2_BASE definitions
> - Use USEG_LIMIT/KSEG0_BASE instead of magic values
> 
>         /* Check where the kernel has been linked */
>    -    if (!(kernel_entry & 0x80000000ll)) {
>    -        error_report("CONFIG_KVM_GUEST kernels are not supported");
>    +    if (kernel_entry <= USEG_LIMIT) {
>    +        error_report("Trap-and-Emul kernels (Linux CONFIG_KVM_GUEST)"
>    +                     " are not supported");
> 
>    -    env->CP0_EBase = (cs->cpu_index & 0x3FF) | (int32_t)0x80000000;
>    +    env->CP0_EBase = KSEG0_BASE | (cs->cpu_index & 0x3FF);
> ---
>   docs/about/deprecated.rst       |  9 -------
>   docs/about/removed-features.rst |  9 +++++++
>   hw/mips/malta.c                 | 46 +++++----------------------------
>   target/mips/cpu.c               |  7 +----
>   target/mips/cpu.h               |  3 ---
>   target/mips/internal.h          |  3 ---
>   target/mips/kvm.c               | 11 +-------
>   target/mips/sysemu/addr.c       | 17 ------------
>   target/mips/sysemu/physaddr.c   | 13 ----------
>   9 files changed, 18 insertions(+), 100 deletions(-)

Thanks, queued to mips-next.
