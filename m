Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A12559A5C0
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 20:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349974AbiHSSqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 14:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350211AbiHSSqJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 14:46:09 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B10C4DB3C
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 11:46:08 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id d23so2837676lfl.13
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 11:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=jK40RXGDRPOTytfHjHl5rauDT3xxxYnRso/4al/XGPU=;
        b=T9DCS3cTH/nuB+1YeHhuvdjoHJ20yGJASVAmlYK1a2NT+2JtnuVb5zZd8NB6JQyOIB
         pviTc4Am0++P1lWZBkAqxmj32emKAVZa5V5ET50kE/fgsLMgTKxbQwnHrQjX6neu7A3S
         GgkAejd5H5Bp2cRPRJ/hsgo5yAXTjuXTyzTT6kSbcs5IWeOQzBtpGIfjxWgoDy8+7hMN
         RbSZ4yUVPvHm5yMosjsHxmQH39BVMSY/fAptFkb4WnwIkHGdXX9NcMXd1nfRKMnvB/RL
         9Nyd1UdEYFexM4rTVDXmKiJdAn7QfRjyb9xJ+wQFcPRl0AQtsiwZPS8zN299tdnf+e80
         czgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=jK40RXGDRPOTytfHjHl5rauDT3xxxYnRso/4al/XGPU=;
        b=k/tZkFtcudOHUe/5kYg+xPUqIgerHMRYiqR03lO/l5wlEf5H80r3MYN9lidOWqTLIW
         HHI88y10rLCy660kTXFVJTqhcCTJjdnaBIRnu89nxqykWEPnXudi8KT5nUfqUuwehxtm
         QWGHUeSc+tDJLYhp5xaJnoIPJMAXXrkP1KRiplcoGREuq8FNR9vgkrFXx3JnXw+atRwg
         faBXi9iwWxLsXES7/kyhMlV5IETRdQVFDnFS0bPsA8BI4ywABi59Ha6wvxphUm9k6H8I
         m0stljk9W56ICySwC7t/WwDxGnDrIl93ZvivMjif9NraZNiqM4Fu2JXF9MA1ItUY7qr7
         1gwA==
X-Gm-Message-State: ACgBeo0kLUYFLVMIfWi1Xwxznb0NKZ7Mr9J/hH1CU2rhg+/jSw7sECuC
        SdzCK5dRQjPCz+yInD/o0/iVRTFuztbIxpglSlE/8g==
X-Google-Smtp-Source: AA6agR4KumF285qiswcOzjSXUb8EYq6mkaWU+FOOy10Y2YwtDP8AXxfnFuUHUpAcljWMs+qp107a7uNYbeeSFqPzU7o=
X-Received: by 2002:a05:6512:b01:b0:48b:a065:2a8b with SMTP id
 w1-20020a0565120b0100b0048ba0652a8bmr2719340lfu.401.1660934766166; Fri, 19
 Aug 2022 11:46:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220819170053.2686006-1-ndesaulniers@google.com>
In-Reply-To: <20220819170053.2686006-1-ndesaulniers@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 19 Aug 2022 11:45:54 -0700
Message-ID: <CAKwvOd=sDbV-aKvroQTdOvW6C32TW20fr4xT0S4-E=fKeS=aWg@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: eradicate CC_HAS_ASM_GOTO
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-um@lists.infradead.org,
        kvm@vger.kernel.org, llvm@lists.linux.dev,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 19, 2022 at 10:01 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> diff --git a/arch/x86/include/asm/rmwcc.h b/arch/x86/include/asm/rmwcc.h
> index 8a9eba191516..c82f1b334207 100644
> --- a/arch/x86/include/asm/rmwcc.h
> +++ b/arch/x86/include/asm/rmwcc.h
> @@ -11,9 +11,7 @@
>
>  #define __CLOBBERS_MEM(clb...) "memory", ## clb
>
> -#if !defined(__GCC_ASM_FLAG_OUTPUTS__) && defined(CONFIG_CC_HAS_ASM_GOTO)
> -
> -/* Use asm goto */
> +#ifndef __GCC_ASM_FLAG_OUTPUTS__
>
>  #define __GEN_RMWcc(fullop, _var, cc, clobbers, ...)                   \
>  ({                                                                     \
> @@ -27,21 +25,6 @@ cc_label:    c = true;                                               \
>         c;                                                              \
>  })
>
> -#else /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CONFIG_CC_HAS_ASM_GOTO) */
> -
> -/* Use flags output or a set instruction */
> -
> -#define __GEN_RMWcc(fullop, _var, cc, clobbers, ...)                   \
> -({                                                                     \
> -       bool c;                                                         \
> -       asm volatile (fullop CC_SET(cc)                                 \
> -                       : [var] "+m" (_var), CC_OUT(cc) (c)             \
> -                       : __VA_ARGS__ : clobbers);                      \
> -       c;                                                              \
> -})
> -
> -#endif /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CONFIG_CC_HAS_ASM_GOTO) */
> -

^ probably don't want to remove the terminal endif. Will respin based
on feedback from Masahiro + Alexei.


-- 
Thanks,
~Nick Desaulniers
