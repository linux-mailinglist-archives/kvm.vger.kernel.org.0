Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8258D327B71
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 11:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhCAKDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 05:03:11 -0500
Received: from mail.skyhub.de ([5.9.137.197]:44556 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234384AbhCAKBw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 05:01:52 -0500
Received: from zn.tnic (p200300ec2f03de00f5cdc1114f0af8a0.dip0.t-ipconnect.de [IPv6:2003:ec:2f03:de00:f5cd:c111:4f0a:f8a0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 91D1B1EC0419;
        Mon,  1 Mar 2021 11:00:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1614592857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=oqWj0M83AyNHIhti3sdU4rfm2PqN8axqw31RH2tZrFM=;
        b=Gd3d66Zba5ybpq5401nuJcieKJZsZZFgOsowheQCUJFaKxINOxEIsqWM8FIfW/DiC59Uv9
        f0L3rzjp51B+e/oXqyRLb56vbrQ5n/nEo7OyqkiFZiMvDKUaznpbh2iaKWMvgAdScgF4nJ
        zjTzrQB4kKlNdtEhXn5nKAxMSfNiDl0=
Date:   Mon, 1 Mar 2021 11:00:37 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <20210301100037.GA6699@zn.tnic>
References: <cover.1614590788.git.kai.huang@intel.com>
 <bbfc8c833a62e4b55220834320829df1e17aff41.1614590788.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bbfc8c833a62e4b55220834320829df1e17aff41.1614590788.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 01, 2021 at 10:44:29PM +1300, Kai Huang wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Add SGX1 and SGX2 feature flags, via CPUID.0x12.0x0.EAX, as scattered
> features, since adding a new leaf for only two bits would be wasteful.
> As part of virtualizing SGX, KVM will expose the SGX CPUID leafs to its
> guest, and to do so correctly needs to query hardware and kernel support
> for SGX1 and SGX2.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 2 ++
>  arch/x86/kernel/cpu/cpuid-deps.c   | 2 ++
>  arch/x86/kernel/cpu/scattered.c    | 2 ++
>  3 files changed, 6 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index cc96e26d69f7..9502c445a3e9 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -290,6 +290,8 @@
>  #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
>  #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
>  #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
> +#define X86_FEATURE_SGX1		(11*32+ 8) /* "" Basic SGX */
> +#define X86_FEATURE_SGX2        	(11*32+ 9) /* SGX Enclave Dynamic Memory Management (EDMM) */

"sgx1" is not gonna show in /proc/cpuinfo but "sgx2" will. Because...?

Also, you send a patchset once a week - not after two days. Please limit
your spamming.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
