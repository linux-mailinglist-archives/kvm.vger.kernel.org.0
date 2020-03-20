Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B9318DB1E
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgCTWYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:24:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:55792 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgCTWYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:24:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 53C68ABC7;
        Fri, 20 Mar 2020 22:24:30 +0000 (UTC)
Date:   Fri, 20 Mar 2020 23:24:27 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     David Rientjes <rientjes@google.com>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 23/70] x86/sev-es: Add support for handling IOIO
 exceptions
Message-ID: <20200320222427.GG611@suse.de>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-24-joro@8bytes.org>
 <alpine.DEB.2.21.2003201402100.205664@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2003201402100.205664@chino.kir.corp.google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 20, 2020 at 02:03:17PM -0700, David Rientjes wrote:
> On Thu, 19 Mar 2020, Joerg Roedel wrote:
> > +	if (exit_info_1 & IOIO_TYPE_STR) {
> > +		int df = (regs->flags & X86_EFLAGS_DF) ? -1 : 1;
> >		[ ... ]
> > +		if (!(exit_info_1 & IOIO_TYPE_IN)) {
> > +			ret = vc_insn_string_read(ctxt,
> > +					       (void *)(es_base + regs->si),
> > +					       ghcb->shared_buffer, io_bytes,
> > +					       exit_info_2, df);
> 
> The last argument to vc_insn_string_read() is "bool backwards" which in 
> this case it appears will always be true?

Right, thanks, good catch, I'll fix this. Seems to be a leftover from a
previous version.

Regards,

	Joerg

