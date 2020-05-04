Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A4D1C3815
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 13:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgEDL3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 07:29:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:60028 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbgEDL3E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 07:29:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 70BD8B03B;
        Mon,  4 May 2020 11:29:03 +0000 (UTC)
Date:   Mon, 4 May 2020 13:28:59 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Borislav Petkov <bp@alien8.de>
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
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 13/75] x86/boot/compressed/64: Add IDT Infrastructure
Message-ID: <20200504112859.GH8135@suse.de>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-14-joro@8bytes.org>
 <20200504105445.GE15046@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504105445.GE15046@zn.tnic>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 12:54:45PM +0200, Borislav Petkov wrote:
> On Tue, Apr 28, 2020 at 05:16:23PM +0200, Joerg Roedel wrote:
> > diff --git a/arch/x86/boot/compressed/idt_handlers_64.S b/arch/x86/boot/compressed/idt_handlers_64.S
> > new file mode 100644
> > index 000000000000..f86ea872d860
> > --- /dev/null
> > +++ b/arch/x86/boot/compressed/idt_handlers_64.S
> > @@ -0,0 +1,69 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Early IDT handler entry points
> > + *
> > + * Copyright (C) 2019 SUSE
> > + *
> > + * Author: Joerg Roedel <jroedel@suse.de>
> > + */
> > +
> > +#include <asm/segment.h>
> > +
> > +#include "../../entry/calling.h"
> 
> Leftover from something? Commenting it out doesn't break the build here.

Yes, probably a leftover from when I tried to use the PT_REGS macros
there. I'll remove it.


Thanks,

	Joerg

