Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D149339F7CB
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 15:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhFHN1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 09:27:48 -0400
Received: from 8bytes.org ([81.169.241.247]:43072 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231162AbhFHN1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 09:27:47 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 8A7F3386; Tue,  8 Jun 2021 15:25:53 +0200 (CEST)
Date:   Tue, 8 Jun 2021 15:25:51 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 4/7] x86/sev-es: Run #VC handler in plain IRQ state
Message-ID: <YL9v38J0JC5FrZnM@8bytes.org>
References: <20210608095439.12668-1-joro@8bytes.org>
 <20210608095439.12668-5-joro@8bytes.org>
 <YL9bd2hx/y9oD6x/@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL9bd2hx/y9oD6x/@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On Tue, Jun 08, 2021 at 01:58:47PM +0200, Peter Zijlstra wrote:
> So #VC cannot happen with IRQs disabled?
> 
> 	raw_spin_lock_irq(&my_lock);
> 	<#VC>
> 		raw_spin_lock_irqsave(&my_lock); // whoopsie
> 
> Every exception that can happen with IRQs disabled must be NMI like.
> 
> Again, what you seem to want is to split the handler in a from-user and
> from-kernel way, just like we did with #DB and MCE. See how
> exc_debug_user() is IRQ-like and can send signals, while
> exc_debug_kernel() is NMI like and can not.

You are right, thanks for pointing this out. I replaced that patch by
one implementing the split in a from-user and from-kernel part. Initial
testing looks good, will send it out later this week.

Thanks,

	Joerg

