Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDCFD15A860
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 12:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgBLLz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 06:55:27 -0500
Received: from 8bytes.org ([81.169.241.247]:53756 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgBLLz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 06:55:27 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id AF9E120E; Wed, 12 Feb 2020 12:55:25 +0100 (CET)
Date:   Wed, 12 Feb 2020 12:55:16 +0100
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
Subject: Re: [PATCH 23/62] x86/idt: Move IDT to data segment
Message-ID: <20200212115516.GE20066@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
 <20200211135256.24617-24-joro@8bytes.org>
 <CALCETrXswGgGoNaZigboUn3-amTyCY2Ft_JaMMvXchLDDkhJfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXswGgGoNaZigboUn3-amTyCY2Ft_JaMMvXchLDDkhJfw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 02:41:25PM -0800, Andy Lutomirski wrote:
> On Tue, Feb 11, 2020 at 5:53 AM Joerg Roedel <joro@8bytes.org> wrote:
> >
> > From: Joerg Roedel <jroedel@suse.de>
> >
> > With SEV-ES, exception handling is needed very early, even before the
> > kernel has cleared the bss segment. In order to prevent clearing the
> > currently used IDT, move the IDT to the data segment.
> 
> Ugh.  At the very least this needs a comment in the code.

Yes, right, added a comment for that.

> I had a patch to fix the kernel ELF loader to clear BSS, which would
> fix this problem once and for all, but it didn't work due to the messy
> way that the decompressor handles memory.  I never got around to
> fixing this, sadly.

Aren't there other ways of booting (Xen-PV?) which don't use the kernel
ELF loader?

Regards,

	Joerg
