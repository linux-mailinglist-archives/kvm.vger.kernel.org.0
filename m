Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE1C352FBA
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 21:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbhDBT13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 15:27:29 -0400
Received: from mail.skyhub.de ([5.9.137.197]:57300 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhDBT12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 15:27:28 -0400
Received: from zn.tnic (p200300ec2f0a2000165287017d4f49d2.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:2000:1652:8701:7d4f:49d2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CDFAF1EC04C2;
        Fri,  2 Apr 2021 21:27:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617391645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=IPuT0LMZhVBaWy/dNRmMZkfsRP4bN2xbwyHxqNljGN4=;
        b=DKSiqGr30xWt95Fe9t+JUNWwhfybD7nq/haXE0zTVs2by8+BrT6ZXJ6RLH1gpsQ8CMhn1y
        iznm1s7/5DkhCTO9nEDJwbrP2+GyvORKs9JYFW7I+1+eYvNI2U7ObS3JX250mSJigWJHhZ
        1r7aCJDHyR4ABVT7cz0oFT+mFfuLdUQ=
Date:   Fri, 2 Apr 2021 21:27:31 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 05/13] X86/sev-es: move few helper functions in
 common file
Message-ID: <20210402192731.GM28499@zn.tnic>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-6-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324164424.28124-6-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 11:44:16AM -0500, Brijesh Singh wrote:
> The sev_es_terminate() and sev_es_{wr,rd}_ghcb_msr() helper functions
> in a common file so that it can be used by both the SEV-ES and SEV-SNP.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/boot/compressed/sev-common.c | 32 +++++++++++++++++++++++++++
>  arch/x86/boot/compressed/sev-es.c     | 22 ++----------------
>  arch/x86/kernel/sev-common-shared.c   | 31 ++++++++++++++++++++++++++
>  arch/x86/kernel/sev-es-shared.c       | 21 +++---------------
>  4 files changed, 68 insertions(+), 38 deletions(-)
>  create mode 100644 arch/x86/boot/compressed/sev-common.c
>  create mode 100644 arch/x86/kernel/sev-common-shared.c

Yeah, once you merge it all into sev.c and sev-shared.c, that patch is
not needed anymore.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
