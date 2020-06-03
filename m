Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626A81ECC26
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 11:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgFCJGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 05:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgFCJGm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 05:06:42 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772C0C05BD43;
        Wed,  3 Jun 2020 02:06:41 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 7798D28B; Wed,  3 Jun 2020 11:06:39 +0200 (CEST)
Date:   Wed, 3 Jun 2020 11:06:37 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org, hpa@zytor.com,
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
Message-ID: <20200603090637.GA16171@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-14-joro@8bytes.org>
 <20200504105445.GE15046@zn.tnic>
 <20200504112859.GH8135@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504112859.GH8135@suse.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 01:28:59PM +0200, Joerg Roedel wrote:
> On Mon, May 04, 2020 at 12:54:45PM +0200, Borislav Petkov wrote:
> > On Tue, Apr 28, 2020 at 05:16:23PM +0200, Joerg Roedel wrote:
> > > +#include "../../entry/calling.h"
> > 
> > Leftover from something? Commenting it out doesn't break the build here.
> 
> Yes, probably a leftover from when I tried to use the PT_REGS macros
> there. I'll remove it.

Turns out this include is still needed to get ORIG_RAX defined. I'll
leave it in place.


	Joerg
