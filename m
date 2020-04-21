Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62121B1B0D
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 03:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgDUBFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 21:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725989AbgDUBFD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Apr 2020 21:05:03 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6253C061A0E;
        Mon, 20 Apr 2020 18:05:01 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id k8so1213810ejv.3;
        Mon, 20 Apr 2020 18:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t8z5VWgZjAeVfvVL0BHA/W6t+TdOdX0ymrvMNRwoeHU=;
        b=fnBot7Fca5TUmQ+L/rzFjjgDHgWyUpL6VYXI3UIDIxDcBP3XiNLfj1Nx9+mgYro9E8
         nOzgZqN3ff21PyjfYlwWFvZ/SwF90ECV1p10n/SHiVSwYLkIqkgl3cnWutvLcN0DIVvA
         TO3s9vVb1oQnnCvYdRxldq2yl2Y5BucmZzJpg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t8z5VWgZjAeVfvVL0BHA/W6t+TdOdX0ymrvMNRwoeHU=;
        b=ZwndWgB8B9Aph+vKnxRyMtNz/l6EUVhYrwvTk6S4N8BZT5p6llZYXane+zfhbZJDlG
         yhIfePTZhenv41kv7GjxBwKTrw3bIikfOaX7ZN000vESplaYfVA6yVQAeZGcpaY59Ujf
         sM2ad4DPQbyLshI2X2dJsN62fH7DJkP+Ua3A6XDH+6wwYjrr0N3AXk7pWL/MuZAsdWw/
         Ky4yU6JfOWg3YctYjWDNfrU6j+WxNuuOyfIXcZ7ktoxEq6TSPG0/J0oS51zOT/T3Wzjx
         hFK4aXys1juENvLQ6XRNFcXwOJwVht+wscu2hWlHMMbQ13AnKQBQZsyFpVZJE8yZWIPJ
         2jcg==
X-Gm-Message-State: AGi0PuYf2XttAzUB4048X/4RThhk52QOtPi3CIIJubrLyfiDCPxX2mFg
        bgVkz9kM9G7Tx3BjwaMFKdL0SIFNZ05ZIQ03Obs=
X-Google-Smtp-Source: APiQypJ9RQ8Y7J3lsg/SXPX3NDFzgPc/25FyFFqsjHr5dq96MspGxBWOZgQtwUEIsHMU5TVbe4X9G0cCfOVIHxGNmF0=
X-Received: by 2002:a17:907:2155:: with SMTP id rk21mr19400529ejb.163.1587431100366;
 Mon, 20 Apr 2020 18:05:00 -0700 (PDT)
MIME-Version: 1.0
References: <a5945463f86c984151962a475a3ee56a2893e85d.1587407777.git.christophe.leroy@c-s.fr>
 <bb0a6081f7b95ee64ca20f92483e5b9661cbacb2.1587407777.git.christophe.leroy@c-s.fr>
In-Reply-To: <bb0a6081f7b95ee64ca20f92483e5b9661cbacb2.1587407777.git.christophe.leroy@c-s.fr>
From:   Joel Stanley <joel@jms.id.au>
Date:   Tue, 21 Apr 2020 01:04:48 +0000
Message-ID: <CACPK8Xf+h378ddF_YakTT++gv_Zx-raBqg54VkKPS3=qe6193Q@mail.gmail.com>
Subject: Re: [PATCH 5/5] powerpc: Remove _ALIGN_UP(), _ALIGN_DOWN() and _ALIGN()
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Apr 2020 at 18:39, Christophe Leroy <christophe.leroy@c-s.fr> wrote:
>
> These three powerpc macros have been replaced by
> equivalent generic macros and are not used anymore.
>
> Remove them.
>
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Reviewed-By: Joel Stanley <joel@jms.id.au>

riscv has a copy of these too that could probably be removed:

arch/riscv/include/asm/page.h:#define _ALIGN_UP(addr, size)
(((addr)+((size)-1))&(~((size)-1)))
arch/riscv/include/asm/page.h:#define _ALIGN(addr, size)
_ALIGN_UP(addr, size)



> ---
>  arch/powerpc/include/asm/page.h | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
> index 3ee8df0f66e0..a63fe6f3a0ff 100644
> --- a/arch/powerpc/include/asm/page.h
> +++ b/arch/powerpc/include/asm/page.h
> @@ -249,13 +249,6 @@ static inline bool pfn_valid(unsigned long pfn)
>  #include <asm/page_32.h>
>  #endif
>
> -/* align addr on a size boundary - adjust address up/down if needed */
> -#define _ALIGN_UP(addr, size)   __ALIGN_KERNEL(addr, size)
> -#define _ALIGN_DOWN(addr, size)        ((addr)&(~((typeof(addr))(size)-1)))
> -
> -/* align addr on a size boundary - adjust address up if needed */
> -#define _ALIGN(addr,size)     _ALIGN_UP(addr,size)
> -
>  /*
>   * Don't compare things with KERNELBASE or PAGE_OFFSET to test for
>   * "kernelness", use is_kernel_addr() - it should do what you want.
> --
> 2.25.0
>
