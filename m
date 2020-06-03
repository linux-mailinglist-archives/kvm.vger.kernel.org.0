Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A471ECDBF
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 12:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbgFCKlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 06:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgFCKlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 06:41:00 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A33BC08C5C0;
        Wed,  3 Jun 2020 03:41:00 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id AEA5728B; Wed,  3 Jun 2020 12:40:56 +0200 (CEST)
Date:   Wed, 3 Jun 2020 12:40:55 +0200
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
Subject: Re: [PATCH v3 24/75] x86/boot/compressed/64: Unmap GHCB page before
 booting the kernel
Message-ID: <20200603104055.GB20099@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-25-joro@8bytes.org>
 <20200513111340.GD4025@zn.tnic>
 <20200513113011.GG18353@8bytes.org>
 <20200513114633.GE4025@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513114633.GE4025@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 13, 2020 at 01:46:33PM +0200, Borislav Petkov wrote:
> On Wed, May 13, 2020 at 01:30:11PM +0200, Joerg Roedel wrote:
> > Yeah, I had this this way in v2, but changed it upon you request[1] :)
> 
> Yeah, I was wondering why this isn't a separate function - you like them
> so much. :-P
> 
> > [1] https://lore.kernel.org/lkml/20200402114941.GA9352@zn.tnic/
> 
> But that one didn't have the ghcb_fault check. Maybe it was being added
> later... :)

Yes, it was :)

I changed it back, first in the patch adding the page-fault handler and
also updated this patch.


	Joerg
