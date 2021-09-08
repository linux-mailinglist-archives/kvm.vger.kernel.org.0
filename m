Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8088D4040A9
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 23:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbhIHVun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 17:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbhIHVul (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 17:50:41 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56A4C061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 14:49:33 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id v123so3226424pfb.11
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 14:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LnzqC9iRJCpiV0TnW0+MmXgaqurvwVKvgA2Wfkav3Xw=;
        b=Drv7Mu2qksoljTc0LQFO3YOZsvYOIA9YNNsqr7xZ1OmhOxdrxOf8ATkQRBYFd4YEZA
         4rTwfJmbwfyYZzo8e6noXA3gksUSC6R+KtcrSywszGmc+Gpd66+guXARXbJ8okJWoWQ7
         9ioBRGd6hEqtYE59p2sliVVUarhmMzV5YG1HkxIhAf6fkoTewT9qwlpef4hFn7+2PfSB
         Gg3n0HoKgF/4DwPYUyuhPiA+iXiSZtIyfr/X4orpq9UwG6dfBax1/39XhlMbdPya+o10
         oZN9bMRsehXxxUHWPPNc6fqGCi1htULCtjVfTax3/b2DC48j0vpsuaOoT1/MZwRIbTAM
         SFJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LnzqC9iRJCpiV0TnW0+MmXgaqurvwVKvgA2Wfkav3Xw=;
        b=6IUG6uBR/g8rnNnKPBrKQLgtQNzcnbJvzEX8EakkHbWRSafuDmDbmyTfiakErb4yHq
         FugvUByOmLJWrnTeo12IPzN4oyTuEhJ1N5Zag3JQ3DxVCnPl5OJvjDvyGW7Lk1E0BX38
         VjJvm1hBXyzkmf98COBNxOwEMqdz2Nmi6CeqNHhvJdQJUV6luzyfW7S+uNhPLSbH29Je
         XZejeGPPAmdzxXrvFc+YzRXy/0ZE8YxjmsS9focFHn24oI+xmpMWUbpneppsWM733gu6
         bfEzhTXgKdJEZUkEQmU/u5gT5DSFmUhnRlb88B4O4C1eVEkY5JQgSMwdUslFabeY/SqL
         QBHQ==
X-Gm-Message-State: AOAM531WwWGzN8euh6OWwFUw0cgFtmmUztEQ7K+pL75mO1gyArIRsyFW
        Jv6J57p8jHxH8EpDoTncIkzjTA==
X-Google-Smtp-Source: ABdhPJzpWIZXTEF0Ap6GGAWEttaLb05fRYqJUCnQMQGmmBoXh731XWcTQ43c4S0gaJl2puBVa9IgIA==
X-Received: by 2002:a63:4b4c:: with SMTP id k12mr274510pgl.172.1631137773018;
        Wed, 08 Sep 2021 14:49:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p24sm146493pfh.136.2021.09.08.14.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 14:49:32 -0700 (PDT)
Date:   Wed, 8 Sep 2021 21:49:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Bill Wendling <morbo@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/5] x86: realmode: mark
 exec_in_big_real_mode as noinline
Message-ID: <YTkv6HXYEGnDe56h@google.com>
References: <20210825222604.2659360-1-morbo@google.com>
 <20210908204541.3632269-1-morbo@google.com>
 <20210908204541.3632269-3-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908204541.3632269-3-morbo@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 08, 2021, Bill Wendling wrote:
> exec_in_big_real_mode() uses inline asm that has labels. Clang decides

_global_ labels.  Inlining functions with local labels, including asm goto labels,
is not problematic, the issue is specific to labels that must be unique for a
given compilation unit.

> that it can inline this function, which causes the assembler to complain
> about duplicate symbols. Mark the function as "noinline" to prevent
> this.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  x86/realmode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/realmode.c b/x86/realmode.c
> index b4fa603..07a477f 100644
> --- a/x86/realmode.c
> +++ b/x86/realmode.c
> @@ -178,7 +178,7 @@ static inline void init_inregs(struct regs *regs)
>  		inregs.esp = (unsigned long)&tmp_stack.top;
>  }
>  
> -static void exec_in_big_real_mode(struct insn_desc *insn)
> +static __attribute__((noinline)) void exec_in_big_real_mode(struct insn_desc *insn)

Forgot to use the new define in this patch :-)

>  {
>  	unsigned long tmp;
>  	static struct regs save;
> -- 
> 2.33.0.309.g3052b89438-goog
> 
