Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FE72E76CA
	for <lists+kvm@lfdr.de>; Wed, 30 Dec 2020 08:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgL3HQT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Dec 2020 02:16:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgL3HQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Dec 2020 02:16:19 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606A9C06179B;
        Tue, 29 Dec 2020 23:15:39 -0800 (PST)
Received: from zn.tnic (p200300ec2f0ae90058345bc89b9c20d2.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:e900:5834:5bc8:9b9c:20d2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E869F1EC01E0;
        Wed, 30 Dec 2020 08:15:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1609312538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=m7erdCIKszJz06nljy/boxQcYlOItJn7Lccn/F6AG0E=;
        b=WQm6pea9Ag14tpilLtVxXkLhf59+Eog93W1nz6TGWe9i8lEmlBySCVCJh5kFVvbvMjwzXb
        nrakKwkpqLp7kt4wtgjLzCUF5Yb909c2WBWfpOX8Y8uzeyoDL8ajGtm/oj/Wm6g9WBU+sX
        mqcDomicDUv8xTQvcs1ZpnkTEUJkaiY=
Date:   Wed, 30 Dec 2020 08:15:41 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Babu Moger <babu.moger@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        fenghua.yu@intel.com, tony.luck@intel.com, wanpengli@tencent.com,
        kvm@vger.kernel.org, thomas.lendacky@amd.com, peterz@infradead.org,
        seanjc@google.com, joro@8bytes.org, x86@kernel.org,
        kyung.min.park@intel.com, linux-kernel@vger.kernel.org,
        krish.sadhukhan@oracle.com, hpa@zytor.com, mgross@linux.intel.com,
        vkuznets@redhat.com, kim.phillips@amd.com, wei.huang2@amd.com,
        jmattson@google.com
Subject: Re: [PATCH v2 1/2] x86/cpufeatures: Add the Virtual SPEC_CTRL feature
Message-ID: <20201230071541.GC22022@zn.tnic>
References: <160867624053.3471.7106539070175910424.stgit@bmoger-ubuntu>
 <160867629293.3471.18225691185459839634.stgit@bmoger-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <160867629293.3471.18225691185459839634.stgit@bmoger-ubuntu>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 22, 2020 at 04:31:32PM -0600, Babu Moger wrote:
> Newer AMD processors have a feature to virtualize the use of the
> SPEC_CTRL MSR. Presence of this feature is indicated via CPUID
> function 0x8000000A_EDX[20]: GuestSpecCtrl. When preset, the SPEC_CTRL
> MSR is automatically virtualized.
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index dad350d42ecf..aee4a924ecd7 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -335,6 +335,7 @@
>  #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
>  #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
>  #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
> +#define X86_FEATURE_V_SPEC_CTRL 	(15*32+20) /* Virtual SPEC_CTRL */
>  
>  /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
>  #define X86_FEATURE_AVX512VBMI		(16*32+ 1) /* AVX512 Vector Bit Manipulation instructions*/


I'm guessing this will go through the kvm tree so:

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
