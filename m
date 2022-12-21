Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F343A65353D
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 18:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234817AbiLURcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 12:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234976AbiLURbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 12:31:48 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD512229D
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 09:31:27 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so3040079pjj.2
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 09:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BzfXU+65m1+EuRocaydYDANlIZBnDelolaKGZVP6Sro=;
        b=Ojq2AzyZZPB49APxgJhBdY0AQ/VFQmDlWYseAVaEaUwGpHzd1tpAh6yUBLqjO5rBTm
         YnZ9dDjcln6owR8e1IRMEV0CQZXjMe/rpSPJ04yQZ1oQo3Zp2CYkeun9rNDZnU5Ul2iW
         bzrMgwoTmjPCcMTygO/gzFZ5ZdMO7y+YKfHpfjTQt71Garr1pZpI7Vly4TTzrtLTkUyK
         B0nrGSRn+rI2c9pn9jKdfeMqnEtyODI7o7HW2vJCtzCxxhYIhLauGhoWqZbry8HJK44x
         tOpupExfDgZBBC2DxIejtIFzIyPWhWHDFWK+Q/Sxn14d2m9RAgNk4+qN8C9Dsp7CU+DN
         a/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BzfXU+65m1+EuRocaydYDANlIZBnDelolaKGZVP6Sro=;
        b=x3ERO1ObpC2/RGD9ld7Zv8N09WtAQFERrc2m81XKSiqEGZffp9t27ODsiefSdiQjYv
         nDnhEKzGBdXxmNNtg33YdS9B/4YuEkS2xjaelt1smlYUy9SrDo4YyDK3I6M5aSBs9ZbA
         DgpnNe7+Pf3XQQkgU6lzpVQrcLQXXLBDOBXb98Qc7cljj0Sjeq8ymWyEZ9sJuvre0e78
         KIxfIuNjEH059qToGriOTSgtrOeL3rVx0r75H/YbAOtzNcQADzV/OSO974Gi9d9VrwpK
         sZEk8/jSKc4e78Hgn6KTg8vzAYAFf66PIWIj122xahc3wM128gloghhWPftVjnqmiuhJ
         IeUA==
X-Gm-Message-State: AFqh2kq24GbyQxVacsD+rj8eBwXo37sHQscy3RcEqHG2pzakHKzPcuxR
        aQPHVCRtXEBjmvm/d0BQtOTOOg==
X-Google-Smtp-Source: AMrXdXugapoMgWk4M/6C7lfr+TgWgmHh7i/yUmaPnnEB6/LHldceHX3DZ13bXLzQfl4QZY9Gy4aexA==
X-Received: by 2002:a17:90a:6aca:b0:223:9cfb:2f9e with SMTP id b10-20020a17090a6aca00b002239cfb2f9emr2948495pjm.22.1671643887404;
        Wed, 21 Dec 2022 09:31:27 -0800 (PST)
Received: from ?IPV6:2602:47:d48c:8101:e04c:516d:5698:abe8? ([2602:47:d48c:8101:e04c:516d:5698:abe8])
        by smtp.gmail.com with ESMTPSA id e7-20020a635007000000b0046b1dabf9a8sm10181611pgb.70.2022.12.21.09.31.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 09:31:26 -0800 (PST)
Message-ID: <f9a9c36d-61d6-2bd8-fe19-1e3585ae5fdd@linaro.org>
Date:   Wed, 21 Dec 2022 09:31:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2] MIPS: remove support for trap and emulate KVM
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     libvir-list@redhat.com, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>
References: <20221221091718.71844-1-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
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

On 12/21/22 01:17, Philippe Mathieu-Daudé wrote:
> From: Paolo Bonzini<pbonzini@redhat.com>
> 
> This support was limited to the Malta board, drop it.
> I do not have a machine that can run VZ KVM, so I am assuming
> that it works for -M malta as well.
> 
> Signed-off-by: Paolo Bonzini<pbonzini@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
