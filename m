Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B7F1AC2A7
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 15:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896337AbgDPNa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 09:30:57 -0400
Received: from 8bytes.org ([81.169.241.247]:36022 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896315AbgDPNax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 09:30:53 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id E492DED; Thu, 16 Apr 2020 15:30:46 +0200 (CEST)
Date:   Thu, 16 Apr 2020 15:30:45 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 12/70] x86/boot/compressed/64: Add IDT Infrastructure
Message-ID: <20200416133045.GA4290@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-13-joro@8bytes.org>
 <20200407022127.GA1048595@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407022127.GA1048595@rani.riverdale.lan>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Arvind,

On Mon, Apr 06, 2020 at 10:21:27PM -0400, Arvind Sankar wrote:
> On Thu, Mar 19, 2020 at 10:13:09AM +0100, Joerg Roedel wrote:
> > From: Joerg Roedel <jroedel@suse.de>
> > +/*
> > + * Reload GDT after relocation - The GDT at the non-relocated position
> > + * might be overwritten soon by the in-place decompression, so reload
> > + * GDT at the relocated address. The GDT is referenced by exception
> > + * handling and needs to be set up correctly.
> > + */
> > +	leaq	gdt(%rip), %rax
> > +	movq	%rax, gdt64+2(%rip)
> > +	lgdt	gdt64(%rip)
> > +
> >  /*
> >   * Clear BSS (stack is currently empty)
> >   */
> 
> Note that this is now done in mainline as of commit c98a76eabbb6e, just
> prior to jumping to .Lrelocated, so this can be dropped on the next
> rebase.

Thanks for the heads-up, I removed this hunk.

Regards,

	Joerg
