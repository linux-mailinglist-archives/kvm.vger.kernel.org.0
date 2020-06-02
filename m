Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C861EBF47
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 17:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgFBPqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 11:46:18 -0400
Received: from mail.skyhub.de ([5.9.137.197]:47778 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgFBPqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 11:46:17 -0400
Received: from zn.tnic (p200300ec2f0bbb004c909b752ca088bd.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:bb00:4c90:9b75:2ca0:88bd])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 303AB1EC02AD;
        Tue,  2 Jun 2020 17:46:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1591112776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=aqTOey7lAwfFOOz0eCqZ1k0RUPC1agJXCDXNB7/wiy0=;
        b=IanehJAf2DVbBOdtt56W8cK/KgxhHEC6KyZdpOQTRY40yZZQTanJL347jcXvB8KRRfjWKT
        NXAdY3KM27iCMQ9b0+UuFgpLlEVSkPMbjz8+bRo6Q3/x/QCEUd3sRyGaeqNpePiAGmL3SY
        cpwTYnKqZ6NdOJLRlQwcDmFA7VCfZwU=
Date:   Tue, 2 Jun 2020 17:46:11 +0200
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
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 70/75] x86/head/64: Setup TSS early for secondary CPUs
Message-ID: <20200602154611.GC11634@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-71-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-71-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:17:20PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The #VC exception will trigger very early in head_64.S, when the first
> CPUID instruction is executed. When secondary CPUs boot, they already
> load the real system IDT, which has the #VC handler configured to be
> using an IST stack. IST stacks require a TSS to be loaded, to set up the
> TSS early for bringing up the secondary CPUs. Use the RW version of
> early, until cpu_init() switches to the RO mapping.

I think you wanna say "Use the read-write version of the per-CPU TSS struct
early." here.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
