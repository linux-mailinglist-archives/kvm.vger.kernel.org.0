Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CC42FAB6F
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 21:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438005AbhARU1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 15:27:35 -0500
Received: from mail.skyhub.de ([5.9.137.197]:50038 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437991AbhARU07 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jan 2021 15:26:59 -0500
Received: from zn.tnic (p200300ec2f069f0062c4736095b963a8.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:9f00:62c4:7360:95b9:63a8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EF60D1EC0373;
        Mon, 18 Jan 2021 21:26:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1611001571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=/3T/wPUUuXmuK0dApHxGcmhzli0nOvNTA9zmajovjqI=;
        b=HC/c93OmasDjbhgPEOISRogzyZcMnzbQgTNo4UNIFG+IE1lJEKscJb/9zjZunVcruwl/nT
        nKZbWtIXj8bs4jeJRGcXGoZFgCu6a7r8yns4oDrDZOCikLLVu+NqL9DszenqzGxmGjg5ia
        wn4w2xbtxPXvkM1Bmc/D9xJp4BrRgWA=
Date:   Mon, 18 Jan 2021 21:26:11 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] x86/sev: Add AMD_SEV_ES_GUEST Kconfig for including
 SEV-ES support
Message-ID: <20210118202611.GH30090@zn.tnic>
References: <20210116002517.548769-1-seanjc@google.com>
 <d4deb3ba-5c72-f61c-5040-0571822297c6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d4deb3ba-5c72-f61c-5040-0571822297c6@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 06:59:38PM +0100, Paolo Bonzini wrote:
> On 16/01/21 01:25, Sean Christopherson wrote:
> > 
> > @@ -1527,12 +1527,14 @@ config AMD_MEM_ENCRYPT
> >  	select DYNAMIC_PHYSICAL_MASK
> >  	select ARCH_USE_MEMREMAP_PROT
> >  	select ARCH_HAS_FORCE_DMA_UNENCRYPTED
> > -	select INSTRUCTION_DECODER
> >  	help
> >  	  Say yes to enable support for the encryption of system memory.
> >  	  This requires an AMD processor that supports Secure Memory
> >  	  Encryption (SME).
> > +	  This also enables support for running as a Secure Encrypted
> > +	  Virtualization (SEV) guest.
> > +
> >  config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
> >  	bool "Activate AMD Secure Memory Encryption (SME) by default"
> >  	default y
> > @@ -1547,6 +1549,15 @@ config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
> >  	  If set to N, then the encryption of system memory can be
> >  	  activated with the mem_encrypt=on command line option.
> > +config AMD_SEV_ES_GUEST
> > +	bool "AMD Secure Encrypted Virtualization - Encrypted State (SEV-ES) Guest support"
> > +	depends on AMD_MEM_ENCRYPT
> > +	select INSTRUCTION_DECODER
> > +	help
> > +	  Enable support for running as a Secure Encrypted Virtualization -
> > +	  Encrypted State (SEV-ES) Guest.  This enables SEV-ES boot protocol
> > +	  changes, #VC handling, SEV-ES specific hypercalls, etc...
> > +
> 
> Queued, thanks.

Say, Paolo, why are you queuing a patch which goes through tip, if at all?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
