Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2882D25153E
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 11:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbgHYJWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 05:22:30 -0400
Received: from 8bytes.org ([81.169.241.247]:39304 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728377AbgHYJW3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 05:22:29 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 840D829A; Tue, 25 Aug 2020 11:22:27 +0200 (CEST)
Date:   Tue, 25 Aug 2020 11:22:24 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
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
Subject: Re: [PATCH v6 02/76] KVM: SVM: Add GHCB definitions
Message-ID: <20200825092224.GF3319@8bytes.org>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-3-joro@8bytes.org>
 <20200824104451.GA4732@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824104451.GA4732@zn.tnic>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 12:44:51PM +0200, Borislav Petkov wrote:
> On Mon, Aug 24, 2020 at 10:53:57AM +0200, Joerg Roedel wrote:
> >  static inline void __unused_size_checks(void)
> >  {
> > -	BUILD_BUG_ON(sizeof(struct vmcb_save_area) != 0x298);
> > +	BUILD_BUG_ON(sizeof(struct vmcb_save_area) != 1032);
> >  	BUILD_BUG_ON(sizeof(struct vmcb_control_area) != 256);
> > +	BUILD_BUG_ON(sizeof(struct ghcb) != 4096);
> 
> Could those naked numbers be proper, meaningfully named defines?

I don't think so, if I look at the history of these checks their whole
purpose seems to be to alert the developer/maintainer when their size
changes and that they might not fit on the stack anymore. But that is
taken care of in patch 1.

Regards,

	Joerg
