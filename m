Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3750B332282
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 11:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhCIKC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 05:02:59 -0500
Received: from 8bytes.org ([81.169.241.247]:58086 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229790AbhCIKCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 05:02:41 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id B07012E2; Tue,  9 Mar 2021 11:02:39 +0100 (CET)
Date:   Tue, 9 Mar 2021 11:02:36 +0100
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
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 6/7] x86/boot/compressed/64: Check SEV encryption in
 32-bit boot-path
Message-ID: <YEdHvAWaWv8YDiUB@8bytes.org>
References: <20210210102135.30667-1-joro@8bytes.org>
 <20210210102135.30667-7-joro@8bytes.org>
 <20210302194353.GH15469@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302194353.GH15469@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 02, 2021 at 08:43:53PM +0100, Borislav Petkov wrote:
> On Wed, Feb 10, 2021 at 11:21:34AM +0100, Joerg Roedel wrote:
> > +	/*
> > +	 * Store the sme_me_mask as an indicator that SEV is active. It will be
> > +	 * set again in startup_64().
> 
> So why bother? Or does something needs it before that?

This was actually a bug. The startup32_check_sev_cbit() needs something
to skip the check when SEV is not active. Therefore the value is set
here in sme_me_mask, but the function later checks sev_status.

I fixed it by setting sev_status to 1 here (indicates SEV is active).

Regards,

	Joerg
