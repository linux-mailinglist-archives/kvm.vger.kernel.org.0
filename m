Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1978154832
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 16:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbgBFPfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 10:35:47 -0500
Received: from mga17.intel.com ([192.55.52.151]:18676 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgBFPfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 10:35:47 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 07:35:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,410,1574150400"; 
   d="scan'208";a="404517225"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 06 Feb 2020 07:35:46 -0800
Date:   Thu, 6 Feb 2020 07:35:46 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linmiaohe <linmiaohe@huawei.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: nVMX: Fix some comment typos and coding style
Message-ID: <20200206153546.GB13067@linux.intel.com>
References: <1580956162-5609-1-git-send-email-linmiaohe@huawei.com>
 <87a75wgdd5.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a75wgdd5.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 06, 2020 at 12:32:38PM +0100, Vitaly Kuznetsov wrote:
> linmiaohe <linmiaohe@huawei.com> writes:
> 
> > From: Miaohe Lin <linmiaohe@huawei.com>
> >
> > Fix some typos in the comments. Also fix coding style.
> >
> > Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 2 +-
> >  arch/x86/kvm/vmx/nested.c       | 5 +++--
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 4dffbc10d3f8..8196a4a0df8b 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -782,7 +782,7 @@ struct kvm_vcpu_arch {
> >  
> >  	/*
> >  	 * Indicate whether the access faults on its page table in guest
> 
> Indicates?
> 
> > -	 * which is set when fix page fault and used to detect unhandeable
> > +	 * which is set when fix page fault and used to detect unhandleable
> >  	 * instruction.
> 
> I have to admit that shadow MMU in KVM is not my strong side but this
> comment reads weird, I'd appreciate if someone could suggest a better
> alternative.

	/* One off flag for a stupid corner case in shadow paging. */
> 
> >  	 */

	/*
	 * Indicates the guest is trying to write a gfn that contains one or
	 * more of the PTEs used to translate the write itself, i.e. the access
	 * is changing its own translation in the guest page tables.  KVM exits
	 * to userspace if emulation of the faulting instruction fails and this
	 * flag is set, as KVM cannot make forward progress.
	 *
	 * If emulation fails for a write to guest page tables, KVM unprotects
	 * (zaps) the shadow page for the target gfn and resumes the guest to
	 * retry the non-emulatable instruction (on hardware).  Unprotecting the
	 * gfn doesn't allow forward progress for a self-changing access because
	 * doing so also zaps the translation for the gfn, i.e. retrying the
	 * instruction will hit a !PRESENT fault, which results in a new shadow
	 * page and sends KVM back to square one.
	 */
> >  	bool write_fault_to_shadow_pgtable;
