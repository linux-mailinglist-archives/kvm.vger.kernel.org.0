Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8AC72EC32B
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 19:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbhAFSVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 13:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbhAFSVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 13:21:36 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAA3C061575
        for <kvm@vger.kernel.org>; Wed,  6 Jan 2021 10:20:56 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id k10so3175468wmi.3
        for <kvm@vger.kernel.org>; Wed, 06 Jan 2021 10:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QfbeWsTRTl5t+yoIzvqBpOs8fewM/q2gZY0NpUaJFJ0=;
        b=KKUyO72RiIV2lTc2BzL4v5d4Wax+ixJXUKre5AzfybcTMoRmqt/av+KsWYg2hS1AOz
         bdNdHofJ4C5gkVDP6zCjV599rXtajM8vLrMNdUkkE+MhYt+C53xiVcrKFbtTYDQ9yaDx
         ziEHTWDQ8VFx1wjOcQzj/gm2lQVSzB73a+dZcGTkjJovunCyJys/JafYbxqen0ZIdIkm
         Z0PE3ZlYdXju2PWwj/hWIn1EqAL69+pks3qupMz0qHbKAM/vAc5sboRCGhRI4R0hTTdt
         risWwGGAu6EGxvtOIh8Z8M5O4hlaiX9/xYLPmTDg7IgEDDFYPDUNUePWCLq0V46hhR1D
         fzog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QfbeWsTRTl5t+yoIzvqBpOs8fewM/q2gZY0NpUaJFJ0=;
        b=SVinKOU6SMxMJSorwrmoJ/YsUQAnMMW2ykVbcgqx4NtW1vtHDJ6pIGpLZUCT7htL0R
         S4odaNs1YYCR1iYQ4po/YjTS+PquvPDpTXM13gLZsmTozco0fnARNqxfrjEg6vRmPcn0
         F47ZTGCCVlkYKV7fLkOow5yreLRMnhU8bF1B3/8loW0dbp7cmubyi1eBmPKeNaArBO7K
         mBZzDi/Gav+3URi8SjuJ7zhKOplKsZFR3gHutRw75b8USToVOP5HyJ+TPEKKz2FtBG+f
         RZ2xDyeS1e2HlIhWi8yXaB0nkPXcYIHpN9+78utr7ZKW5jSy6OVMvVcc2Qz9UN40uP0r
         uvGw==
X-Gm-Message-State: AOAM533/OLPM7flUZjI77w4kfEW/E3KvG8Yi9gSRIlyWeSwToe3Q25Fq
        25XVi2ISGnkcisX4dM2kYU4=
X-Google-Smtp-Source: ABdhPJzTMCojHyc3I3zeK/plHO8a7afnD7azaRHN5Jwo51vHLO6QKkdnUWYGLJef50BbNkQxyfT6YA==
X-Received: by 2002:a05:600c:4e87:: with SMTP id f7mr325351wmq.163.1609957255178;
        Wed, 06 Jan 2021 10:20:55 -0800 (PST)
Received: from [192.168.1.36] (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id z21sm3853080wmk.20.2021.01.06.10.20.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 10:20:54 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH v2 02/24] target/mips/translate: Expose check_mips_64() to
 32-bit mode
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201215225757.764263-1-f4bug@amsat.org>
 <20201215225757.764263-3-f4bug@amsat.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <1f23c2f4-28b9-ac3b-356e-ea9cc0213690@amsat.org>
Date:   Wed, 6 Jan 2021 19:20:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201215225757.764263-3-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

ping for code review? :)

Due to the "Simplify ISA definitions"
https://www.mail-archive.com/qemu-devel@nongnu.org/msg770056.html
patch #3 is not necessary.

This is the last patch unreviewed.

On 12/15/20 11:57 PM, Philippe Mathieu-Daudé wrote:
> To allow compiling 64-bit specific translation code more
> generically (and removing #ifdef'ry), allow compiling
> check_mips_64() on 32-bit targets.
> If ever called on 32-bit, we obviously emit a reserved
> instruction exception.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate.h | 2 --
>  target/mips/translate.c | 8 +++-----
>  2 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/target/mips/translate.h b/target/mips/translate.h
> index a9eab69249f..942d803476c 100644
> --- a/target/mips/translate.h
> +++ b/target/mips/translate.h
> @@ -127,9 +127,7 @@ void generate_exception_err(DisasContext *ctx, int excp, int err);
>  void generate_exception_end(DisasContext *ctx, int excp);
>  void gen_reserved_instruction(DisasContext *ctx);
>  void check_insn(DisasContext *ctx, uint64_t flags);
> -#ifdef TARGET_MIPS64
>  void check_mips_64(DisasContext *ctx);
> -#endif
>  void check_cp1_enabled(DisasContext *ctx);
>  
>  void gen_base_offset_addr(DisasContext *ctx, TCGv addr, int base, int offset);
> diff --git a/target/mips/translate.c b/target/mips/translate.c
> index 5c62b32c6ae..af543d1f375 100644
> --- a/target/mips/translate.c
> +++ b/target/mips/translate.c
> @@ -2972,18 +2972,16 @@ static inline void check_ps(DisasContext *ctx)
>      check_cp1_64bitmode(ctx);
>  }
>  
> -#ifdef TARGET_MIPS64
>  /*
> - * This code generates a "reserved instruction" exception if 64-bit
> - * instructions are not enabled.
> + * This code generates a "reserved instruction" exception if cpu is not
> + * 64-bit or 64-bit instructions are not enabled.
>   */
>  void check_mips_64(DisasContext *ctx)
>  {
> -    if (unlikely(!(ctx->hflags & MIPS_HFLAG_64))) {
> +    if (unlikely((TARGET_LONG_BITS != 64) || !(ctx->hflags & MIPS_HFLAG_64))) {

Since TARGET_LONG_BITS is known at build time, this can be simplified
as:

if ((TARGET_LONG_BITS != 64) || unlikely!(ctx->hflags & MIPS_HFLAG_64)))

>          gen_reserved_instruction(ctx);
>      }
>  }
> -#endif
>  
>  #ifndef CONFIG_USER_ONLY
>  static inline void check_mvh(DisasContext *ctx)
> 
