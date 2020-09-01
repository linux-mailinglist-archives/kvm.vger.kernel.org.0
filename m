Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC68258DF2
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 14:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgIAMKZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 08:10:25 -0400
Received: from 8bytes.org ([81.169.241.247]:40220 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727903AbgIAMKK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 08:10:10 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 8132A391; Tue,  1 Sep 2020 14:09:57 +0200 (CEST)
Date:   Tue, 1 Sep 2020 14:09:56 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>,
        Kees Cook <keescook@chromium.org>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 31/76] x86/head/64: Setup MSR_GS_BASE before calling
 into C code
Message-ID: <20200901120956.GA22385@8bytes.org>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-32-joro@8bytes.org>
 <20200828181346.GB19342@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200828181346.GB19342@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 28, 2020 at 08:13:46PM +0200, Borislav Petkov wrote:
> On Mon, Aug 24, 2020 at 10:54:26AM +0200, Joerg Roedel wrote:
> > +	movl	$MSR_GS_BASE,%ecx
> 
> I'm confused: is this missing those three lines:
> 
>         movl    initial_gs(%rip),%eax
>         movl    initial_gs+4(%rip),%edx
>         wrmsr
> 
> as it is done in secondary_startup_64 ?

No, it is a leftover from before I moved the MSR write into
startup_64_setup_env(). I removed it, thanks for catching this.

Regards,

	Joerg

