Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAA5220A05
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 12:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731145AbgGOKbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 06:31:25 -0400
Received: from [195.135.220.15] ([195.135.220.15]:56700 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1729086AbgGOKbY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 06:31:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 18B25B57B;
        Wed, 15 Jul 2020 10:31:26 +0000 (UTC)
Date:   Wed, 15 Jul 2020 12:31:20 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 63/75] x86/sev-es: Handle #DB Events
Message-ID: <20200715103120.GO16200@suse.de>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-64-joro@8bytes.org>
 <20200715084752.GD10769@hirez.programming.kicks-ass.net>
 <20200715091337.GI16200@suse.de>
 <20200715095136.GG10769@hirez.programming.kicks-ass.net>
 <20200715100808.GL16200@suse.de>
 <20200715101310.GJ10769@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715101310.GJ10769@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 15, 2020 at 12:13:10PM +0200, Peter Zijlstra wrote:
> On Wed, Jul 15, 2020 at 12:08:08PM +0200, Joerg Roedel wrote:
> > Right, but the handler calls into various other functions. I actually
> > started to annotate them all with noinstr, but that was a can of worms
> > when calling into generic kernel functions. And the only problem with
> > intrumentation in the #VC handler is the #VC-for-#DB exit-code, so I
> > decided to only handle this one with instrumentation forbidden and allow
> > it for the rest of the handler.
> 
> OK, then maybe change the comment to something like:
> 
>  /*
>   * Handle #DB before calling any !noinstr code to avoid
>   * recursive #DB.
>   */

Sounds good, will do.

Thanks,

	Joerg
