Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5BA2669FF
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 23:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbgIKVVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 17:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgIKVVh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 17:21:37 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C1AC061757;
        Fri, 11 Sep 2020 14:21:36 -0700 (PDT)
Received: from zn.tnic (p200300ec2f162200706a91c2aab828ed.dip0.t-ipconnect.de [IPv6:2003:ec:2f16:2200:706a:91c2:aab8:28ed])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 37B7A1EC052C;
        Fri, 11 Sep 2020 23:21:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1599859295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=RXKxtTNE1sfEbjZWGIJ9JVpHfKlp4NqW6mziweAb2E4=;
        b=qHVGLiualmBBCPjV5btyG+6dhoz82EQPwJRNr7mOP0vvdcuT+0tshQQ0/MsLCJp6ZS2cgV
        azDYTfPvMyFiVMhS780Z8WmzU6XKiNI7r5x63L0pvfKrWvLtR/UvyTvA64DAe+oVxTKnzV
        suUplI6Ypf8LsNiZO/sw6CzXr2eqE94=
Date:   Fri, 11 Sep 2020 23:21:31 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH 1/4 v3] x86: AMD: Replace numeric value for SME CPUID
 leaf with a #define
Message-ID: <20200911212131.GB4110@zn.tnic>
References: <20200911192601.9591-1-krish.sadhukhan@oracle.com>
 <20200911192601.9591-2-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200911192601.9591-2-krish.sadhukhan@oracle.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 11, 2020 at 07:25:58PM +0000, Krish Sadhukhan wrote:

<-- patches need commit message.

...

> diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
> index 62b137c3c97a..033c112e03fc 100644
> --- a/arch/x86/kernel/cpu/scattered.c
> +++ b/arch/x86/kernel/cpu/scattered.c
> @@ -39,8 +39,8 @@ static const struct cpuid_bit cpuid_bits[] = {
>  	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
>  	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
>  	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
> -	{ X86_FEATURE_SME,		CPUID_EAX,  0, 0x8000001f, 0 },
> -	{ X86_FEATURE_SEV,		CPUID_EAX,  1, 0x8000001f, 0 },
> +	{ X86_FEATURE_SME,		CPUID_EAX,  0, CPUID_AMD_SME, 0 },
> +	{ X86_FEATURE_SEV,		CPUID_EAX,  1, CPUID_AMD_SME, 0 },

So this one gets a name and all the others above don't?

This fact should've given you a hint that there's no need for naming
CPUID leafs - it is easier to grep CPU manuals by the values so you can
drop this patch.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
