Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF0022CCB7
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 19:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgGXR6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 13:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726639AbgGXR6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 13:58:21 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8467FC0619D3;
        Fri, 24 Jul 2020 10:58:21 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id s23so7483589qtq.12;
        Fri, 24 Jul 2020 10:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nNxE3+XkF4L9QAdGaxowxMGCxg8LNIy3uR1pRcTBli8=;
        b=IRsMsqR//APDGVVqlwMqj9i8FEhPtdym9xLU/hrqoJFLeA28tM1yuiV39r1+Tewy1R
         OqhuvBQYpmn9x+80zP6rITJWNoEkQrrNjdoCTUa2CraEfVogjBBFVXSzVJ/fW/LoSP3n
         ThLDyUjFxsXJdDTf3KRzj0J6cZ009Ec8gzlxCNo+pf1zQusT5UH7mTwig6RD13VrihQQ
         dP+XUIIAy0uz2FP/4QiSXy1TAAVh6KjvJSJLVRS0+iicQ8cKzxezWKEFuURcrHa6QsW0
         rgZaL29YQsivXvFW/gR1d4OJMOEvG88XDu+S5/zGHmHGEzUo3C0uhJDk4xe/kLjkJ5Dl
         OxYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=nNxE3+XkF4L9QAdGaxowxMGCxg8LNIy3uR1pRcTBli8=;
        b=XbggV43azL5N2lVcVypFcVtbgsaMzaPaZViu37qNxbqUF0wTHRdV0YmAWMhuUWWcCV
         CzrABiWoDrfVS5nN2XgJ7qY9+BzG91kdPDWTISeSdOfSUh/Je8nLN2YwcasP1zw1GbQ5
         bN52o1BWAWtZizJbWeLHFTTyapkW62D6N1C9Rh9VyS7ZJJzHvU5Q4ZpjR+IoJ/rMY1xR
         H6BBE+aJkBd7pMtwRH/Tsjt0dRThXywYuQZequ/UGHF4cXuSiteNSBvG9+6IMpRUi3Hv
         zno3hJrJ5O/GwcJvagVJ4tQ/LNe6/a2W9Mg8GYRYW1uBeJbJ7H+TXlOfTDCZVza51C9I
         gVvQ==
X-Gm-Message-State: AOAM530piO2vcijFujgQNuXjbQhUaUWCRIksG/a6kHqpjHW+EPrMyOOu
        JMxs/cnAfC5x5kEfpuD2a44=
X-Google-Smtp-Source: ABdhPJwnUda8U9jPe6l5SaeP7NYrS9DsjuxSVrOKEOdJwPbzA+tWm03LJ6+gS8YFbvPWm+2sSJv0Jw==
X-Received: by 2002:ac8:1baf:: with SMTP id z44mr10871128qtj.129.1595613500705;
        Fri, 24 Jul 2020 10:58:20 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id a203sm7199153qkg.30.2020.07.24.10.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 10:58:20 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Fri, 24 Jul 2020 13:58:18 -0400
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v5 11/75] x86/boot/compressed/64: Disable red-zone usage
Message-ID: <20200724175818.GA732164@rani.riverdale.lan>
References: <20200724160336.5435-1-joro@8bytes.org>
 <20200724160336.5435-12-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200724160336.5435-12-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 24, 2020 at 06:02:32PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The x86-64 ABI defines a red-zone on the stack:
> 
>   The 128-byte area beyond the location pointed to by %rsp is considered
>   to be reserved and shall not be modified by signal or interrupt
>   handlers. Therefore, functions may use this area for temporary data
>   that is not needed across function calls. In particular, leaf
>   functions may use this area for their entire stack frame, rather than
>   adjusting the stack pointer in the prologue and epilogue. This area is
>   known as the red zone.
> 
> This is not compatible with exception handling, because the IRET frame
> written by the hardware at the stack pointer and the functions to handle
> the exception will overwrite the temporary variables of the interrupted
> function, causing undefined behavior. So disable red-zones for the
> pre-decompression boot code.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/boot/Makefile            | 2 +-
>  arch/x86/boot/compressed/Makefile | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
> index fe605205b4ce..4d6a16a47e9f 100644
> --- a/arch/x86/boot/Makefile
> +++ b/arch/x86/boot/Makefile
> @@ -66,7 +66,7 @@ targets += cpustr.h
>  
>  # ---------------------------------------------------------------------------
>  
> -KBUILD_CFLAGS	:= $(REALMODE_CFLAGS) -D_SETUP
> +KBUILD_CFLAGS	:= $(REALMODE_CFLAGS) -D_SETUP -mno-red-zone
>  KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
>  KBUILD_CFLAGS	+= $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
>  KBUILD_CFLAGS	+= -fno-asynchronous-unwind-tables

This change seems unnecessary? REALMODE_CFLAGS means it uses -m16, so
this isn't 64-bit code. [As an aside, we can drop the check for -m16
support in arch/x86/Makefile now that we've bumbed to 4.9]

> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index 5a828fde7a42..416f52ab39ec 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -32,7 +32,7 @@ KBUILD_CFLAGS := -m$(BITS) -O2
>  KBUILD_CFLAGS += -fno-strict-aliasing $(call cc-option, -fPIE, -fPIC)
>  KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
>  cflags-$(CONFIG_X86_32) := -march=i386
> -cflags-$(CONFIG_X86_64) := -mcmodel=small
> +cflags-$(CONFIG_X86_64) := -mcmodel=small -mno-red-zone
>  KBUILD_CFLAGS += $(cflags-y)
>  KBUILD_CFLAGS += -mno-mmx -mno-sse
>  KBUILD_CFLAGS += $(call cc-option,-ffreestanding)
> -- 
> 2.27.0
> 

This one is necessary.
