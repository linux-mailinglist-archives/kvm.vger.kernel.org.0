Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B9D3A66A6
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 14:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbhFNMfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 08:35:11 -0400
Received: from 8bytes.org ([81.169.241.247]:44400 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232809AbhFNMfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 08:35:10 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 05EE12DA; Mon, 14 Jun 2021 14:33:05 +0200 (CEST)
Date:   Mon, 14 Jun 2021 14:33:04 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Eric Biederman <ebiederm@xmission.com>, x86@kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 0/2] x86: Disable kexec for SEV-ES guests
Message-ID: <YMdMgCAIYN4zOX4N@8bytes.org>
References: <20210603132233.10004-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603132233.10004-1-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gentle ping.

On Thu, Jun 03, 2021 at 03:22:31PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Changes v1->v2:
> 
> 	- Rebased to v5.13-rc4
> 	- Add the check also to the kexec_file_load system call
> 
> Original cover letter:
> 
> Hi,
> 
> two small patches to disable kexec on x86 when running as an SEV-ES
> guest. Trying to kexec a new kernel would fail anyway because there is
> no mechanism yet to hand over the APs from the old to the new kernel.
> Supporting this needs changes in the Hypervisor and the guest kernel
> as well.
> 
> This code is currently being work on, but disable kexec in SEV-ES
> guests until it is ready.
> 
> Please review.
> 
> Regards,
> 
> 	Joerg
> 
> Joerg Roedel (2):
>   kexec: Allow architecture code to opt-out at runtime
>   x86/kexec/64: Forbid kexec when running as an SEV-ES guest
> 
>  arch/x86/kernel/machine_kexec_64.c |  8 ++++++++
>  include/linux/kexec.h              |  1 +
>  kernel/kexec.c                     | 14 ++++++++++++++
>  kernel/kexec_file.c                |  9 +++++++++
>  4 files changed, 32 insertions(+)
> 
> -- 
> 2.31.1
