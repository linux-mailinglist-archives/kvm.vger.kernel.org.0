Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA2E164269
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 11:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgBSKmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 05:42:17 -0500
Received: from 8bytes.org ([81.169.241.247]:54872 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgBSKmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 05:42:16 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id ED39936A; Wed, 19 Feb 2020 11:42:14 +0100 (CET)
Date:   Wed, 19 Feb 2020 11:42:13 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 23/62] x86/idt: Move IDT to data segment
Message-ID: <20200219104213.GJ22063@8bytes.org>
References: <20200212115516.GE20066@8bytes.org>
 <EEAC8672-C98F-45D0-9F2D-0802516C3908@amacapital.net>
 <879ace44-cee3-98aa-0dff-549b69355096@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <879ace44-cee3-98aa-0dff-549b69355096@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jürgen,

On Wed, Feb 12, 2020 at 05:28:21PM +0100, Jürgen Groß wrote:
> Xen-PV is clearing BSS as the very first action.

In the kernel image? Or in the ELF loader before jumping to the kernel
image?

Regards,

	Joerg
