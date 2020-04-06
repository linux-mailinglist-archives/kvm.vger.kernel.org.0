Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A51319F5F2
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 14:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgDFMl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 08:41:29 -0400
Received: from mail.skyhub.de ([5.9.137.197]:34944 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728005AbgDFMl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 08:41:29 -0400
Received: from zn.tnic (p200300EC2F04F600C571FE02886A814C.dip0.t-ipconnect.de [IPv6:2003:ec:2f04:f600:c571:fe02:886a:814c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 89F001EC0C97;
        Mon,  6 Apr 2020 14:41:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1586176887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=PbaBekgCD+MeWyYk1vRkkQPU2yAt2/j+9avcpCI88LE=;
        b=UEY77Gv5ArFCMO1FwtAfGHdXL/PbVEHaPP5I4lJUZvrVz9+QQCPvHfTkWcEzm503GpFgue
        piAeGh2vlK1frRBdUfv6oqzgi1QgaCwpAEO+RIkfrXF6K6j6NVV4reEqzxS58IswwexQrJ
        LY4CL2BMrwv2smovKGngto6QUgLDOtU=
Date:   Mon, 6 Apr 2020 14:41:24 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 18/70] x86/boot/compressed/64: Add stage1 #VC handler
Message-ID: <20200406124123.GE2520@zn.tnic>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-19-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200319091407.1481-19-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 10:13:15AM +0100, Joerg Roedel wrote:
> diff --git a/arch/x86/boot/compressed/idt_handlers_64.S b/arch/x86/boot/compressed/idt_handlers_64.S
> index bfb3fc5aa144..67ddafab2943 100644
> --- a/arch/x86/boot/compressed/idt_handlers_64.S
> +++ b/arch/x86/boot/compressed/idt_handlers_64.S
> @@ -75,3 +75,7 @@ SYM_FUNC_END(\name)
>  	.code64
>  
>  EXCEPTION_HANDLER	boot_pf_handler do_boot_page_fault error_code=1
> +
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +EXCEPTION_HANDLER	boot_stage1_vc_handler vc_no_ghcb_handler error_code=1

Like the others
			boot_stage1_vc	do_boot_stage1_vc ...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
