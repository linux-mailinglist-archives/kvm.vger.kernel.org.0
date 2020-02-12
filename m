Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D21A815A845
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 12:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgBLLuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 06:50:03 -0500
Received: from 8bytes.org ([81.169.241.247]:53722 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727279AbgBLLuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 06:50:03 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id EB26B4A6; Wed, 12 Feb 2020 12:50:00 +0100 (CET)
Date:   Wed, 12 Feb 2020 12:49:50 +0100
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
Subject: Re: [PATCH 19/62] x86/sev-es: Add support for handling IOIO
 exceptions
Message-ID: <20200212114949.GD20066@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
 <20200211135256.24617-20-joro@8bytes.org>
 <CALCETrWecBK7cqgLTB72mMYRs10R1e+rkZh9mnzRNJc0N=XU2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWecBK7cqgLTB72mMYRs10R1e+rkZh9mnzRNJc0N=XU2Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 02:28:06PM -0800, Andy Lutomirski wrote:
> On Tue, Feb 11, 2020 at 5:53 AM Joerg Roedel <joro@8bytes.org> wrote:
> It would be nice if this could reuse the existing in-kernel
> instruction decoder.  Is there some reason it can't?

It does, see patch 5, which makes the inat-tables generator script
suitable for pre-decompression boot code. Actually every
instruction-caused #VC exception will decode the instruction to get its
length.

Regards,

	Joerg
