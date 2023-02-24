Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD22F6A23DA
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 22:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjBXVfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 16:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjBXVfa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 16:35:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970F14DE15;
        Fri, 24 Feb 2023 13:35:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 190FE61984;
        Fri, 24 Feb 2023 21:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA3BC4339B;
        Fri, 24 Feb 2023 21:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677274525;
        bh=LjFkXpo9qYB9HCNNt42YfCkgi6CEc5o9gSRSRVQTv6k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J8H/ykZWUHHvqxio0xzsy9Ci7VatdClm5PrMK/O7vl4q3IP4xf+Q7jX/KBtkvLgkV
         dhBjtk0SAKa15FfH06Z9mvUlZrgYqP0fKZHyRkr16SGOHm8udbbKxJw9WYwjxeZESs
         yzMOYEMDxHv8pOCjpRDSjnz/efR5Le9gwt6OgCYWfT29xZUrrv94UQvi0wmthhTwtk
         pOAJvVz+886//jzrxiVChd49/9zWho7cTnAhmDjEtY39TS6mLZreDube9zCrK4+Dc9
         zbqDmNLAgqR+B4aJ8aYljJ7yo1QCayEQMFMkYtGcFIC4NLz27i/hPpFyH3YVH0k+N+
         8zLJv+s5vHo7g==
Date:   Fri, 24 Feb 2023 13:35:22 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kim Phillips <kim.phillips@amd.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 7/8] x86/cpu: Support AMD Automatic IBRS
Message-ID: <20230224213522.nofavod2jzhn22wp@treble>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
 <20230124163319.2277355-8-kim.phillips@amd.com>
 <20230224185257.o3mcmloei5zqu7wa@treble>
 <Y/knUC0s+rg6ef2r@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/knUC0s+rg6ef2r@zn.tnic>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023 at 10:08:32PM +0100, Borislav Petkov wrote:
> On Fri, Feb 24, 2023 at 10:52:57AM -0800, Josh Poimboeuf wrote:
> > Doesn't this only enable it on the boot CPU?
> 
> Whoops, you might be right.
> 
> Lemme fix it.
> 
> Thx!

BTW, I wasn't copied on the patch set, despite having dedicated years of
my life that file ;-)

Can we add bugs.c and friends to MAINTAINERS?

---8<---

From: Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH] MAINTAINERS: Add x86 hardware vulnerabilities section

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index eb6f650c6c0b..338dc7469f80 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22553,6 +22553,16 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/asm
 F:	arch/x86/entry/
 
+X86 HARDWARE VULNERABILITIES
+M:	Thomas Gleixner <tglx@linutronix.de>
+M:	Borislav Petkov <bp@alien8.de>
+M:	Peter Zijlstra <peterz@infradead.org>
+M:	Josh Poimboeuf <jpoimboe@kernel.org>
+S:	Maintained
+F:	Documentation/admin-guide/hw-vuln/
+F:	arch/x86/include/asm/nospec-branch.h
+F:	arch/x86/kernel/cpu/bugs.c
+
 X86 MCE INFRASTRUCTURE
 M:	Tony Luck <tony.luck@intel.com>
 M:	Borislav Petkov <bp@alien8.de>
-- 
2.39.1

