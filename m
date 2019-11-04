Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 496A9EEB6B
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 22:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbfKDVrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 16:47:42 -0500
Received: from mail.skyhub.de ([5.9.137.197]:47674 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729461AbfKDVrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 16:47:41 -0500
Received: from zn.tnic (p200300EC2F0AFA002D6457FFE0CB40E6.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:fa00:2d64:57ff:e0cb:40e6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8644B1EC068C;
        Mon,  4 Nov 2019 22:47:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1572904059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=wPRvSQgI8DD01H/5uwJTXGdMfNFer44SzSLi7KoHieI=;
        b=panHx+XxT1wW0qS/bUXFkU78ppfI+M3y5fnJ74FgnZ/ES1gcJ5iRWHAJgqjnAGv5qU4rch
        b429IcWjWAmtMZSFBYS7jnG/j4A+5vRPY/R3UobsTt76n0kooBoM+c6d5mSDVaKNX/l6rm
        yhVTO02fIe0VNRzMJgA3KfDWsb/44Nc=
Date:   Mon, 4 Nov 2019 22:47:34 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Moger, Babu" <Babu.Moger@amd.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] x86/Kconfig: Rename UMIP config parameter
Message-ID: <20191104214734.GB7862@zn.tnic>
References: <157290058655.2477.5193340480187879024.stgit@naples-babu.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <157290058655.2477.5193340480187879024.stgit@naples-babu.amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 04, 2019 at 08:50:51PM +0000, Moger, Babu wrote:
> AMD 2nd generation EPYC processors support the UMIP (User-Mode
> Instruction Prevention) feature. So, rename X86_INTEL_UMIP to
> generic X86_UMIP and modify the text to cover both Intel and AMD.
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
> v2:
>   Learned that for the hardware that support UMIP, we dont need to
>   emulate. Removed the emulation related code and just submitting
>   the config changes.
> 
>  arch/x86/Kconfig                         |    8 ++++----
>  arch/x86/include/asm/disabled-features.h |    2 +-
>  arch/x86/include/asm/umip.h              |    4 ++--
>  arch/x86/kernel/Makefile                 |    2 +-
>  4 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index d6e1faa28c58..821b7cebff31 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1880,13 +1880,13 @@ config X86_SMAP
>  
>  	  If unsure, say Y.
>  
> -config X86_INTEL_UMIP
> +config X86_UMIP
>  	def_bool y
> -	depends on CPU_SUP_INTEL
> -	prompt "Intel User Mode Instruction Prevention" if EXPERT
> +	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
		   ^^^

What's the dependency on X86 for?

Aren't the CPU_SUP_* things enough?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
