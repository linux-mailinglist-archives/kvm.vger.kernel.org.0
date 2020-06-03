Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3761ED1F3
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 16:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgFCOTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 10:19:16 -0400
Received: from 8bytes.org ([81.169.241.247]:45932 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgFCOTQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 10:19:16 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 206FC28B; Wed,  3 Jun 2020 16:19:14 +0200 (CEST)
Date:   Wed, 3 Jun 2020 16:19:12 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Borislav Petkov <bp@alien8.de>
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
Subject: Re: [PATCH v3 25/75] x86/sev-es: Add support for handling IOIO
 exceptions
Message-ID: <20200603141912.GA23071@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-26-joro@8bytes.org>
 <20200516075714.GC25771@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516075714.GC25771@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 16, 2020 at 09:57:14AM +0200, Borislav Petkov wrote:
> Just a reminder so that this doesn't get lost:
> 
> On Tue, Apr 28, 2020 at 05:16:35PM +0200, Joerg Roedel wrote:
> > +	if (exit_info_1 & IOIO_TYPE_STR) {
> > +		int df = (regs->flags & X86_EFLAGS_DF) ? -1 : 1;
> 
> ...

Thanks, this is fixed now.

