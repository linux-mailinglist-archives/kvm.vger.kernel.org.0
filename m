Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88C7258ECD
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 15:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgIANAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 09:00:38 -0400
Received: from 8bytes.org ([81.169.241.247]:40302 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727943AbgIANAD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 09:00:03 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 06AD2391; Tue,  1 Sep 2020 14:59:23 +0200 (CEST)
Date:   Tue, 1 Sep 2020 14:59:22 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 42/76] x86/sev-es: Setup early #VC handler
Message-ID: <20200901125922.GC22385@8bytes.org>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-43-joro@8bytes.org>
 <20200831094541.GD27517@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831094541.GD27517@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 31, 2020 at 11:45:41AM +0200, Borislav Petkov wrote:
> On Mon, Aug 24, 2020 at 10:54:37AM +0200, Joerg Roedel wrote:
> > +#ifdef CONFIG_AMD_MEM_ENCRYPT
> > +	/* VMM Communication Exception */
> > +	handler = fixup_pointer(vc_no_ghcb, physbase);
> > +	set_early_idt_handler(idt, X86_TRAP_VC, handler);
> 
> This function is used only once AFAICT - you might just as well add its
> three-lined body here and save yourself the function definition and
> ifdeffery above...

True, but having a separate function might be handy when support for #VE
and #HV is developed. Those might also need to setup their early
handlers here, no?

Regards,

	Joerg
