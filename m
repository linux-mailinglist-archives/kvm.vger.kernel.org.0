Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB4D357FF6
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 11:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhDHJws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 05:52:48 -0400
Received: from mail.skyhub.de ([5.9.137.197]:53936 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230351AbhDHJwr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 05:52:47 -0400
Received: from zn.tnic (p200300ec2f095000c11580856fe05acf.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:5000:c115:8085:6fe0:5acf])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BAD521EC04AD;
        Thu,  8 Apr 2021 11:52:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617875555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Z1sdOTVzGcgzlBOFqani/UNpSK+Merm6hbxo6XIHoVM=;
        b=qS1+yuAPGSm16cn8yg2PvuG2My9jMZaPmlj6amHud2tby9gRr+NJQpTqWcEAsfdaMtFEx/
        0KfpUGOqCixocwu6CybMMhZYqZP+fEqhTNs77ShAU+tb37rVDA1W2lAaJGh/GGzPtcN/vq
        AdTsMmKrfKss7Ca5bDn0p/F9AFIzWFE=
Date:   Thu, 8 Apr 2021 11:52:35 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFCv1 2/7] x86/kvm: Introduce KVM memory protection feature
Message-ID: <20210408095235.GH10192@zn.tnic>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
 <20210402152645.26680-3-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210402152645.26680-3-kirill.shutemov@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 02, 2021 at 06:26:40PM +0300, Kirill A. Shutemov wrote:
> Provide basic helpers, KVM_FEATURE, CPUID flag and a hypercall.
> 
> Host side doesn't provide the feature yet, so it is a dead code for now.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  arch/x86/include/asm/cpufeatures.h   |  1 +
>  arch/x86/include/asm/kvm_para.h      |  5 +++++
>  arch/x86/include/uapi/asm/kvm_para.h |  3 ++-
>  arch/x86/kernel/kvm.c                | 18 ++++++++++++++++++
>  include/uapi/linux/kvm_para.h        |  3 ++-
>  5 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 84b887825f12..5b6f23e6edc4 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -238,6 +238,7 @@
>  #define X86_FEATURE_VMW_VMMCALL		( 8*32+19) /* "" VMware prefers VMMCALL hypercall instruction */
>  #define X86_FEATURE_SEV_ES		( 8*32+20) /* AMD Secure Encrypted Virtualization - Encrypted State */
>  #define X86_FEATURE_VM_PAGE_FLUSH	( 8*32+21) /* "" VM Page Flush MSR is supported */
> +#define X86_FEATURE_KVM_MEM_PROTECTED	( 8*32+22) /* KVM memory protection extenstion */
										    ^^^^^^^^^^
What's that feature bit for?

Also, use a spellchecker pls: "extenstion".

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
