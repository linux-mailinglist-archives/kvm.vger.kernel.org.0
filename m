Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09D11ADE96
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 15:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbgDQNkF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 09:40:05 -0400
Received: from 8bytes.org ([81.169.241.247]:36194 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730601AbgDQNkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 09:40:05 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 01A40342; Fri, 17 Apr 2020 15:40:02 +0200 (CEST)
Date:   Fri, 17 Apr 2020 15:39:59 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>, Joerg Roedel <jroedel@suse.de>,
        x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
Subject: Re: [PATCH 05/70] x86/insn: Make inat-tables.c suitable for
 pre-decompression code
Message-ID: <20200417133959.GE21900@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-6-joro@8bytes.org>
 <20200325153945.GD27261@zn.tnic>
 <20200327120232.c8e455ca100dc0d96e4ddc43@kernel.org>
 <20200416152406.GB4290@8bytes.org>
 <20200417215000.47141001f80005f41153d22e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417215000.47141001f80005f41153d22e@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 17, 2020 at 09:50:00PM +0900, Masami Hiramatsu wrote:
> On Thu, 16 Apr 2020 17:24:06 +0200
> Joerg Roedel <joro@8bytes.org> wrote:

> Ah, I got it. So you intended to port the instruction decoder to
> pre-decompression boot code, correct?

Right, it is needed there to decode instructions which cause #VC
exceptions when running as an SEV-ES guest.

> > The call-site is added with the patch that includes the
> > instruction decoder into the pre-decompression code. If possible I'd
> > like to keep those things separate, as both patches are already pretty
> > big by themselfes (and they do different things, in different parts of
> > the code).
> 
> OK, if you will send v2, please CC both to me.

Will do, I added you to the cc-list for future posts of this series.


Regards,

	Joerg
