Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1651D98B3
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 15:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgESN6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 09:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbgESN6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 09:58:30 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CC5C08C5C0;
        Tue, 19 May 2020 06:58:30 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id j3so13430458ilk.11;
        Tue, 19 May 2020 06:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n/gSlFWBQ3WxUydL0AG8RE+72oWOYudYm1JYvsV0Jus=;
        b=fIB4BbVzW7vbkqKGKgmfgtVqfdtPo/YxHVrbHEHcSalctsC8Z1P/ZiMcrHG884CH/T
         afZBfItuIrHPolRnpDDBn4+sdZVpYdBP5S8xbLo8cNmXYVc3M3DKaokQsaNWUl5Eee1q
         ohpVvVCyMv3GJPSnXR2UI5aTBr1vw6bJFKDym5a0inaHP2eR4oVmhV2+MmFLuWT7+8oA
         D6utLisJgmRj2Sw/p3vERjIrCk/Z+7QU6dsaBHzi6SVKJ0Ka+J/P8e2p3L9mlquNKTpN
         fOzkHLkJefEIFpPUiQ8deUjtHUVX0E6KZqO2L9VevMlZVippSZ+9Y+HHF0Wrewa+mmPP
         Qp9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n/gSlFWBQ3WxUydL0AG8RE+72oWOYudYm1JYvsV0Jus=;
        b=NAdPHPbRDwIlRe/KEE3/LzXWResaB/btLIcnYduWg7Om0Aozn48qZD2UqY10fkW6Qc
         +eiLtM0XRA+kqyj2hKSxTLsF2GuwiHLogP+EA2SWt6tDFQROkwuYirLFQUriHdXqI2rl
         2nyJHMiDptTkb2sRa45ANLIVBaO9shUwd+YMEYLcx8WqNp2mwP6LpGJZ3ZoW8EBTzkmT
         PqDAWJnISnVg2p+b8xtECB1366En336JtkBNGw4p9PdpXHFb2a/hdhF9t6yMf6kuJF6R
         RKu0UuGaRJOMIbyQBO7JUWRQl7LSIcG7xZ9FvRqx+RgJls8FaSATnlrCSdagZJEfTrjT
         x5ug==
X-Gm-Message-State: AOAM530OZJwlosqh/rQvG9fx/zBmi0z1yhbqpQneRO6xGUUSNdfqPZUT
        T4vtl7qSx5GLo7xDzfjrLzazpbZCAwAU6m1clg==
X-Google-Smtp-Source: ABdhPJyzDk5ro9RaDhHf25IEza5E1ffJM8beDQGW8MgdSO58MbiCno3wYKG45cNLis7uZ+kYFAz0+QOPkms+WREOc3I=
X-Received: by 2002:a92:8c4c:: with SMTP id o73mr21114094ild.172.1589896709896;
 Tue, 19 May 2020 06:58:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200428151725.31091-1-joro@8bytes.org> <20200428151725.31091-36-joro@8bytes.org>
In-Reply-To: <20200428151725.31091-36-joro@8bytes.org>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Tue, 19 May 2020 09:58:18 -0400
Message-ID: <CAMzpN2gfiBAeCV_1+9ogh42bMMuDW=qdwd7dYp49-=zY3kzBaA@mail.gmail.com>
Subject: Re: [PATCH v3 35/75] x86/head/64: Build k/head64.c with -fno-stack-protector
To:     Joerg Roedel <joro@8bytes.org>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <jroedel@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 11:28 AM Joerg Roedel <joro@8bytes.org> wrote:
>
> From: Joerg Roedel <jroedel@suse.de>
>
> The code inserted by the stack protector does not work in the early
> boot environment because it uses the GS segment, at least with memory
> encryption enabled. Make sure the early code is compiled without this
> feature enabled.
>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kernel/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index ba89cabe5fcf..1192de38fa56 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -35,6 +35,10 @@ ifdef CONFIG_FRAME_POINTER
>  OBJECT_FILES_NON_STANDARD_ftrace_$(BITS).o             := y
>  endif
>
> +# make sure head64.c is built without stack protector
> +nostackp := $(call cc-option, -fno-stack-protector)
> +CFLAGS_head64.o                := $(nostackp)
> +
>  # If instrumentation of this dir is enabled, boot hangs during first second.
>  # Probably could be more selective here, but note that files related to irqs,
>  # boot, dumpstack/stacktrace, etc are either non-interesting or can lead to

The proper fix would be to initialize MSR_GS_BASE earlier.

--
Brian Gerst
