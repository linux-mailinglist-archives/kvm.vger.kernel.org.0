Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D311F75C5
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 11:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgFLJMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jun 2020 05:12:17 -0400
Received: from 8bytes.org ([81.169.241.247]:47472 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgFLJMR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jun 2020 05:12:17 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 845443AA; Fri, 12 Jun 2020 11:12:14 +0200 (CEST)
Date:   Fri, 12 Jun 2020 11:12:11 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
Subject: Re: [PATCH v3 64/75] x86/sev-es: Cache CPUID results for improved
 performance
Message-ID: <20200612091210.GA3701@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-65-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-65-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:17:14PM +0200, Joerg Roedel wrote:
> From: Mike Stunes <mstunes@vmware.com>
> 
> To avoid a future VMEXIT for a subsequent CPUID function, cache the
> results returned by CPUID into an xarray.
> 
>  [tl: coding standard changes, register zero extension]
> 
> Signed-off-by: Mike Stunes <mstunes@vmware.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> [ jroedel@suse.de: - Wrapped cache handling into vc_handle_cpuid_cached()
>                    - Used lower_32_bits() where applicable
> 		   - Moved cache_index out of struct es_em_ctxt ]
> Co-developed-by: Joerg Roedel <jroedel@suse.de>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kernel/sev-es-shared.c |  12 ++--
>  arch/x86/kernel/sev-es.c        | 119 +++++++++++++++++++++++++++++++-
>  2 files changed, 124 insertions(+), 7 deletions(-)

Okay, following the discussion, I am dropping this patch for now. We can
revisit CPUID caching later when we have a better justification.

Regards,

	Joerg
