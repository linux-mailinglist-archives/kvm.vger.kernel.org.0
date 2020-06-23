Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5332056CA
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 18:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732155AbgFWQKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 12:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728472AbgFWQKW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 12:10:22 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235E4C061573;
        Tue, 23 Jun 2020 09:10:22 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0d47007938aef930b6c4fb.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:4700:7938:aef9:30b6:c4fb])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 445861EC0390;
        Tue, 23 Jun 2020 18:10:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1592928618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gRvNeLgnj5EUYtezLWiSTfwu1q6G/wPTT9fdfyj9xYQ=;
        b=HF6CnrExk3oqYwLL7mzTIOKSsMDwnWe7KIL7Waj5xzeGYvsheaQPN2zwe3L4v9bRqaYG4p
        EbVI8ncLyIZjl4G5EBxgSjDAQS4/izgGnmNmB6re445rstGW+hSsroF+PmiaIEAQ7DwxNc
        u/r/VHsDr5fc86TkEBe6YgmjNWYfxXI=
Date:   Tue, 23 Jun 2020 18:10:10 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Mike Stunes <mstunes@vmware.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Juergen Gross <JGross@suse.com>,
        Jiri Slaby <jslaby@suse.cz>, Kees Cook <keescook@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: Should SEV-ES #VC use IST? (Re: [PATCH] Allow RDTSC and RDTSCP
 from userspace)
Message-ID: <20200623161010.GE32590@zn.tnic>
References: <20200623104559.GA4817@hirez.programming.kicks-ass.net>
 <20200623111107.GG31822@suse.de>
 <20200623111443.GC4817@hirez.programming.kicks-ass.net>
 <20200623114324.GA14101@suse.de>
 <20200623115014.GE4817@hirez.programming.kicks-ass.net>
 <20200623121237.GC14101@suse.de>
 <20200623130322.GH4817@hirez.programming.kicks-ass.net>
 <20200623144940.GE14101@suse.de>
 <20200623151607.GJ4817@hirez.programming.kicks-ass.net>
 <fe0af2c8-92c8-8d66-e9f3-5a50d64837e5@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fe0af2c8-92c8-8d66-e9f3-5a50d64837e5@citrix.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 04:32:22PM +0100, Andrew Cooper wrote:
> MSR_MCG_STATUS.MCIP, and yes - any #MC before that point will
> immediately Shutdown.  Any #MC between that point and IRET will clobber
> its IST stack and end up sad.

Well, at some point we should simply accept that we're living a little
on the edge. That is, until we get IRET with a mask of to-reenable
vectors which has #MC, NMI and whatever else vectors. It would be even
better if that mask were configurable.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
