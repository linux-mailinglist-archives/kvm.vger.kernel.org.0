Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E69E254956
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 17:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgH0P1C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 11:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbgH0P1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 11:27:01 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B8DC061264;
        Thu, 27 Aug 2020 08:27:00 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id k18so4785170qtm.10;
        Thu, 27 Aug 2020 08:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=7UREsbmmfUl6uKDuaxhy7wo7SSoNjIwrrnq3Cb8sDVE=;
        b=rwaezHLBXo3AhAay1MBvcv8LFx6RGX0pQZUAqP91NiIsN5xJ99bIZpRhFZQnC8mXgZ
         x1mVX1lr8PvGkgQvM7aSdscLvx7BXQwAucX6azU+yG1DXfZdVCag/9aYwO27qzXnAIex
         Bwi1yfimf0VV4GYNzsuR7IfoQttvs0hckYkyJAVu2i7tgbTNAWYNbc4SyJAzzLvfiKko
         ALxulrR5llewc3WOi0rv3owL6qeLVtj3+9O37nMZqNLBupHAXmQZr2+ucCHZbm0UXYNc
         JfXcdA4RMo9CdOv9/bI7NRBp4IcipfzSmTR7Jmu1bVh380K3IF9Wob24gmuwHHEXtoN+
         CCUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=7UREsbmmfUl6uKDuaxhy7wo7SSoNjIwrrnq3Cb8sDVE=;
        b=Onr6O89a79tan63JjhWPFmMm2dNnXbUCIIMBn6nMzM/bBewck427eIDKS8QCm9QQ1a
         5K2g56YhXovTVi/c+GnfFVkwsEyLFW5i3PK+CyJ8a/hE6diOrG+qGZTrQFfUGZGmNROi
         5UPjGbR6ENrSbQDBHOdHqQVk9Ja5T41kb+gk5NhG8pRH2PONtKPZHQZfbd/mzsNgTZyj
         65e2MTsXHd8noF1izlYhEO7/Kn2qTxqcpjpJmHBTZhFxHQrUlC3lpxixrsT8aW6j6Y6F
         5PuNDpGlVXqpvca9TOHA688nO/srAnI55e3oAr6FtC6uIDQcOstq9z61yTJ0u6PpzMPE
         pWmA==
X-Gm-Message-State: AOAM531aaMJ2Wl/RyV8MsZeHkIPZmYLcpHi59DqyMfpnIVsnVxADxVRq
        AQrxxPMEhEDbkEX9QHwVL55PsKWlp2I=
X-Google-Smtp-Source: ABdhPJznEyF0mZAogiSFgjmdI6X+tyx1xA88jTcbKW6mRF+XTymMpK8jWQDvlZ+RBBtCcslMP15KFA==
X-Received: by 2002:ac8:4248:: with SMTP id r8mr18734289qtm.218.1598542019916;
        Thu, 27 Aug 2020 08:26:59 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id d17sm1950504qkj.96.2020.08.27.08.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 08:26:59 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Thu, 27 Aug 2020 11:26:57 -0400
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
Subject: Re: [PATCH v6 13/76] x86/boot/compressed/64: Add IDT Infrastructure
Message-ID: <20200827152657.GA669574@rani.riverdale.lan>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-14-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200824085511.7553-14-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 10:54:08AM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Add code needed to setup an IDT in the early pre-decompression
> boot-code. The IDT is loaded first in startup_64, which is after
> EfiExitBootServices() has been called, and later reloaded when the
> kernel image has been relocated to the end of the decompression area.
> 
> This allows to setup different IDT handlers before and after the
> relocation.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> Link: https://lore.kernel.org/r/20200724160336.5435-13-joro@8bytes.org
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index 9e46729cf162..260c7940f960 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -33,6 +33,7 @@
>  #include <asm/processor-flags.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/bootparam.h>
> +#include <asm/desc_defs.h>
>  #include "pgtable.h"
>  
>  /*
> @@ -415,6 +416,10 @@ SYM_CODE_START(startup_64)
>  
>  .Lon_kernel_cs:
>  
> +	pushq	%rsi
> +	call	load_stage1_idt
> +	popq	%rsi
> +

Do we need the functions later in the series or could this just use lidt
directly?

Is there any risk of exceptions getting triggered during the move of the
compressed kernel, before the stage2 reload?

>  
> +SYM_DATA_START(boot_idt_desc)
> +	.word	boot_idt_end - boot_idt

I think this should be boot_idt_end - boot_idt - 1, right?
  The limit value is expressed in bytes and is added to the base address
  to get the address of the last valid byte. A limit value of 0 results
  in exactly 1 valid byte. Because IDT entries are always eight bytes
  long, the limit should always be one less than an integral multiple of
  eight (that is, 8N – 1).

> +	.quad	0
> +SYM_DATA_END(boot_idt_desc)
> +	.balign 8
> +SYM_DATA_START(boot_idt)
> +	.rept	BOOT_IDT_ENTRIES
> +	.quad	0
> +	.quad	0
> +	.endr
> +SYM_DATA_END_LABEL(boot_idt, SYM_L_GLOBAL, boot_idt_end)
> +
