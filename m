Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28783229460
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 11:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbgGVJEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 05:04:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:57108 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728360AbgGVJEr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 05:04:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 75BEDAF16;
        Wed, 22 Jul 2020 09:04:52 +0000 (UTC)
Date:   Wed, 22 Jul 2020 11:04:42 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Erdem Aktas <erdemaktas@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 00/75] x86: SEV-ES Guest Support
Message-ID: <20200722090442.GI6132@suse.de>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200715092456.GE10769@hirez.programming.kicks-ass.net>
 <20200715093426.GK16200@suse.de>
 <20200715095556.GI10769@hirez.programming.kicks-ass.net>
 <20200715101034.GM16200@suse.de>
 <CAAYXXYxJf8sr6fvbZK=t6o_to4Ov_yvZ91Hf6ZqQ-_i-HKO2VA@mail.gmail.com>
 <20200721124957.GD6132@suse.de>
 <CAAYXXYwVV_g8pGL52W9vxkgdNxg1dNKq_OBsXKZ_QizdXiTx2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAYXXYwVV_g8pGL52W9vxkgdNxg1dNKq_OBsXKZ_QizdXiTx2g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Erdem,

On Tue, Jul 21, 2020 at 09:48:51AM -0700, Erdem Aktas wrote:
> Yes, I am using OVMF with SEV-ES (sev-es-v12 patches applied). I am
> running Ubuntu 18.04 distro. My grub target is x86_64-efi. I also
> tried installing the grub-efi-amd64 package. In all cases, the grub is
> running in 64bit but enters the startup_32 in 32 bit mode. I think
> there should be a 32bit #VC handler just something very similar in the
> OVMF patches to handle the cpuid when the CPU is still in 32bit mode.
> As it is now, it will be a huge problem to support different distro images.
> I wonder if I am the only one having this problem.

I havn't heard from anyone else that the startup_32 boot-path is being
used for SEV-ES. What OVMF binary do you use for your guest?

In general it is not that difficult to support that boot-path too, but
I'd like to keep that as a future addition, as the patch-set is already
quite large. In the startup_32 path there is already a GDT set up, so
whats needed is an IDT and a 32-bit #VC handler using the MRS-based
protocol (and hoping that there will only be CPUID intercepts until it
reaches long-mode).

Regards,

	Joerg

