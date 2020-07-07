Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B37216945
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 11:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgGGJkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 05:40:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbgGGJkW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 05:40:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 748922065F;
        Tue,  7 Jul 2020 09:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594114821;
        bh=ncpZrogq3J8lmjYVURRcrUwe28LiM7BV6dS0EhuvMYs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qpoN0vyZtStKSEGEbjrGotpdOhig7Flj630Ebfzd7XzgvP3pkzPdr9qyKetD14bjC
         4onI/J8co2fF4Z2iBwsMeP2PU5/c4EFBqjz7si14mxt7+zcBYu+BQbG+0UWT+0Vev/
         F/yBgirTg64y7+pXStMAUrnp05wefaOurTN5TDUg=
Date:   Tue, 7 Jul 2020 11:40:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Cathy Zhang <cathy.zhang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, ricardo.neri-calderon@linux.intel.com,
        kyung.min.park@intel.com, jpoimboe@redhat.com, ak@linux.intel.com,
        dave.hansen@intel.com, tony.luck@intel.com,
        ravi.v.shankar@intel.com
Subject: Re: [PATCH v2 2/4] x86/cpufeatures: Enumerate TSX suspend load
 address tracking instructions
Message-ID: <20200707094019.GA2639362@kroah.com>
References: <1594088183-7187-1-git-send-email-cathy.zhang@intel.com>
 <1594088183-7187-3-git-send-email-cathy.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594088183-7187-3-git-send-email-cathy.zhang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 07, 2020 at 10:16:21AM +0800, Cathy Zhang wrote:
> Intel TSX suspend load tracking instructions aim to give a way to
> choose which memory accesses do not need to be tracked in the TSX
> read set. Add TSX suspend load tracking CPUID feature flag TSXLDTRK
> for enumeration.
> 
> A processor supports Intel TSX suspend load address tracking if
> CPUID.0x07.0x0:EDX[16] is present. Two instructions XSUSLDTRK, XRESLDTRK
> are available when this feature is present.
> 
> The CPU feature flag is shown as "tsxldtrk" in /proc/cpuinfo.
> 
> Detailed information on the instructions and CPUID feature flag TSXLDTRK
> can be found in the latest Intel Architecture Instruction Set Extensions
> and Future Features Programming Reference and Intel 64 and IA-32
> Architectures Software Developer's Manual.
> 
> Signed-off-by: Kyung Min Park <kyung.min.park@intel.com>
> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index adf45cf..34b66d7 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -366,6 +366,7 @@
>  #define X86_FEATURE_MD_CLEAR		(18*32+10) /* VERW clears CPU buffers */
>  #define X86_FEATURE_TSX_FORCE_ABORT	(18*32+13) /* "" TSX_FORCE_ABORT */
>  #define X86_FEATURE_SERIALIZE		(18*32+14) /* SERIALIZE instruction */
> +#define X86_FEATURE_TSX_LDTRK           (18*32+16) /* TSX Suspend Load Address Tracking */

No tabs?

:(

