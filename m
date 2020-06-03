Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EFE1ED343
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 17:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgFCPYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 11:24:41 -0400
Received: from 8bytes.org ([81.169.241.247]:46066 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgFCPYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 11:24:39 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id A9A2028B; Wed,  3 Jun 2020 17:24:37 +0200 (CEST)
Date:   Wed, 3 Jun 2020 17:24:36 +0200
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
Subject: Re: [PATCH v3 38/75] x86/sev-es: Add SEV-ES Feature Detection
Message-ID: <20200603152436.GA17841@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-39-joro@8bytes.org>
 <20200520083916.GB1457@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520083916.GB1457@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 20, 2020 at 10:39:16AM +0200, Borislav Petkov wrote:
> On Tue, Apr 28, 2020 at 05:16:48PM +0200, Joerg Roedel wrote:
> > +bool sev_es_active(void)
> > +{
> > +	return !!(sev_status & MSR_AMD64_SEV_ES_ENABLED);
> > +}
> > +EXPORT_SYMBOL_GPL(sev_es_active);
> 
> I don't see this being used in modules anywhere in the patchset. Or am I
> missing something?

It is used in several places, for example do do_nmi() to conditionally
re-open the NMI window in SEV-ES guests. But there are other uses too,
like int sev_es_efi_map_ghcbs() or in sev_es_init_vc_handling() to opt
out if not running as an SEV-ES guest.


	Joerg

