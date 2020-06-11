Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDB51F6580
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 12:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgFKKOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 06:14:14 -0400
Received: from 8bytes.org ([81.169.241.247]:47180 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726693AbgFKKON (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 06:14:13 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 00D2B869; Thu, 11 Jun 2020 12:14:10 +0200 (CEST)
Date:   Thu, 11 Jun 2020 12:14:09 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [PATCH v3 42/75] x86/sev-es: Setup GHCB based boot #VC handler
Message-ID: <20200611101409.GC32093@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-43-joro@8bytes.org>
 <20200520192230.GK1457@zn.tnic>
 <20200604120749.GC30945@8bytes.org>
 <20200604153021.GC2246@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604153021.GC2246@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 04, 2020 at 05:30:27PM +0200, Borislav Petkov wrote:
> Hmmkay, I see vc_no_ghcb doing
> 
> call    do_vc_no_ghcb
> 
> and that's setup in early_idt_setup().
> 
> vc_boot_ghcb(), OTOH, is called by do_early_exception() only so that one
> could be called handle_vc_boot_ghcb(), no? I.e., I don't see it being an
> IDT entry point.

Right, I renamed it to handle_vc_boot_ghcb().


	Joerg

