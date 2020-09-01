Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF434258E66
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 14:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgIAMQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 08:16:32 -0400
Received: from 8bytes.org ([81.169.241.247]:40262 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728036AbgIAMNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 08:13:54 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id AB1D6391; Tue,  1 Sep 2020 14:13:52 +0200 (CEST)
Date:   Tue, 1 Sep 2020 14:13:51 +0200
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
Subject: Re: [PATCH v6 36/76] x86/head/64: Load IDT earlier
Message-ID: <20200901121351.GB22385@8bytes.org>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-37-joro@8bytes.org>
 <20200829102405.GA29091@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200829102405.GA29091@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 29, 2020 at 12:24:05PM +0200, Borislav Petkov wrote:
> On Mon, Aug 24, 2020 at 10:54:31AM +0200, Joerg Roedel wrote:
> > @@ -385,3 +386,25 @@ void __init alloc_intr_gate(unsigned int n, const void *addr)
> >  	if (!WARN_ON(test_and_set_bit(n, system_vectors)))
> >  		set_intr_gate(n, addr);
> >  }
> > +
> > +void __init early_idt_setup_early_handler(unsigned long physaddr)
> 
> I wonder if you could drop one of the "early"es:
> 
> idt_setup_early_handler()
> 
> for example looks ok to me. Or
> 
> early_setup_idt_handler()
> 
> if you wanna have "early" as prefix...

Yeah, makes sense. I settled with the second version.


Thanks,

	Joerg
