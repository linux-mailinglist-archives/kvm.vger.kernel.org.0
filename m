Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A512559A9
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 13:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbgH1LzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 07:55:17 -0400
Received: from 8bytes.org ([81.169.241.247]:39806 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726904AbgH1LzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 07:55:05 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id B517C2E1; Fri, 28 Aug 2020 13:54:59 +0200 (CEST)
Date:   Fri, 28 Aug 2020 13:54:57 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Joerg Roedel <jroedel@suse.de>,
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
Message-ID: <20200828115457.GB13881@8bytes.org>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-3-joro@8bytes.org>
 <20200824104451.GA4732@zn.tnic>
 <20200825092224.GF3319@8bytes.org>
 <20200825110446.GC12107@zn.tnic>
 <20200827160113.GA721088@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827160113.GA721088@rani.riverdale.lan>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 27, 2020 at 12:01:13PM -0400, Arvind Sankar wrote:
> Wouldn't we rather just remove the checks?

I think that's a different topic to be discussed with the KVM
maintainers.  For now I will add defines for the magic numbers.

Regards,

	Joerg
