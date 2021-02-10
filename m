Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04C23169D3
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 16:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhBJPNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 10:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbhBJPNJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 10:13:09 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE181C061786;
        Wed, 10 Feb 2021 07:12:28 -0800 (PST)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id B8FA83C2; Wed, 10 Feb 2021 16:12:26 +0100 (CET)
Date:   Wed, 10 Feb 2021 16:12:25 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     daniel.kiper@oracle.com, x86@kernel.org,
        Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/7] x86/seves: Support 32-bit boot path and other updates
Message-ID: <20210210151224.GC7302@8bytes.org>
References: <20210210102135.30667-1-joro@8bytes.org>
 <20210210145835.GE358613@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210145835.GE358613@fedora>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Konrad,

On Wed, Feb 10, 2021 at 09:58:35AM -0500, Konrad Rzeszutek Wilk wrote:
> What GRUB versions are we talking about (CC-ing Daniel Kiper, who owns
> GRUB).

I think this was about 32-bit GRUB builds used by distributions. I
personally tested it with a kernel which has EFI support disabled, in
this case the OVMF firmware will also boot into the startup_32 boot
path.

> By 'some firmware' we talking SeaBIOS?

No, SeaBIOS is not supported for SEV-ES, only OVMF has handling for #VC
so far.

Regards,

	Joerg
