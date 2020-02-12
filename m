Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 315C715ABCD
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 16:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgBLPQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 10:16:17 -0500
Received: from 8bytes.org ([81.169.241.247]:54030 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728098AbgBLPQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 10:16:17 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 2C50A3D3; Wed, 12 Feb 2020 16:16:15 +0100 (CET)
Date:   Wed, 12 Feb 2020 16:16:13 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 35/62] x86/sev-es: Setup per-cpu GHCBs for the runtime
 handler
Message-ID: <20200212151613.GC22063@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
 <20200211135256.24617-36-joro@8bytes.org>
 <CALCETrWVYM_EQJYznNzPT0q2yYjUojCHYpHmdYoSCdqApitTrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWVYM_EQJYznNzPT0q2yYjUojCHYpHmdYoSCdqApitTrA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 02:46:11PM -0800, Andy Lutomirski wrote:
> On Tue, Feb 11, 2020 at 5:53 AM Joerg Roedel <joro@8bytes.org> wrote:
> > +/* Runtime GHCBs */
> > +static DEFINE_PER_CPU_DECRYPTED(struct ghcb, ghcb_page) __aligned(PAGE_SIZE);
> 
> Hmm.  This is a largeish amount of memory on large non-SEV-ES systems.
> Maybe store a pointer instead?  It would be even better if it could be
> DEFINE_PER_CPU like this but be discarded if we don't need it, but I
> don't think we have the infrastructure for that.

Yeah, discarding is not easily possible right now, but I changed it to
only store a pointer and allocating the pages only when running as an
SEV-ES guest.

Regards,

	Joerg
