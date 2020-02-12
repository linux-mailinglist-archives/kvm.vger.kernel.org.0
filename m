Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC39215A8FE
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 13:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgBLMVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 07:21:07 -0500
Received: from 8bytes.org ([81.169.241.247]:53784 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbgBLMVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 07:21:07 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 97CAE20E; Wed, 12 Feb 2020 13:21:05 +0100 (CET)
Date:   Wed, 12 Feb 2020 13:20:52 +0100
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
Subject: Re: [PATCH 25/62] x86/head/64: Install boot GDT
Message-ID: <20200212122052.GF20066@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
 <20200211135256.24617-26-joro@8bytes.org>
 <CALCETrWryvrGoPD5zOVxVs3pk+WFfb287NV46Zw7Gz7FtNAHag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWryvrGoPD5zOVxVs3pk+WFfb287NV46Zw7Gz7FtNAHag@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 02:29:24PM -0800, Andy Lutomirski wrote:
> On Tue, Feb 11, 2020 at 5:53 AM Joerg Roedel <joro@8bytes.org> wrote:
> > +       /* GDT loaded - switch to __KERNEL_CS so IRET works reliably */
> > +       pushq   $__KERNEL_CS
> > +       leaq    .Lon_kernel_cs(%rip), %rax
> > +       pushq   %rax
> > +       lretq
> > +
> > +.Lon_kernel_cs:
> > +       UNWIND_HINT_EMPTY
> 
> I would suggest fixing at least SS as well.

You are right, that is cleaner. Initialized DS, ES, and SS to
__KERNEL_DS here too.

Regards,

	Joerg
