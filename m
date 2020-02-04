Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7E215218D
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 21:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgBDUgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 15:36:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:11975 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727458AbgBDUgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 15:36:08 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 12:36:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,403,1574150400"; 
   d="scan'208";a="279168231"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Feb 2020 12:36:06 -0800
Date:   Tue, 4 Feb 2020 12:36:07 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Remove stale comment from
 nested_vmx_load_cr3()
Message-ID: <20200204203607.GB5663@linux.intel.com>
References: <20200204153259.16318-1-sean.j.christopherson@intel.com>
 <dcee13f5-f447-9ab4-4803-e3c4f42fb011@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcee13f5-f447-9ab4-4803-e3c4f42fb011@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 04, 2020 at 11:57:39AM -0800, Krish Sadhukhan wrote:
> 
> On 2/4/20 7:32 AM, Sean Christopherson wrote:
> >The blurb pertaining to the return value of nested_vmx_load_cr3() no
> >longer matches reality, remove it entirely as the behavior it is
> >attempting to document is quite obvious when reading the actual code.
> >
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >---
> >  arch/x86/kvm/vmx/nested.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> >diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> >index 7608924ee8c1..0c9b847f7a25 100644
> >--- a/arch/x86/kvm/vmx/nested.c
> >+++ b/arch/x86/kvm/vmx/nested.c
> >@@ -1076,8 +1076,6 @@ static bool nested_cr3_valid(struct kvm_vcpu *vcpu, unsigned long val)
> >  /*
> >   * Load guest's/host's cr3 at nested entry/exit. nested_ept is true if we are
> >   * emulating VM entry into a guest with EPT enabled.
> >- * Returns 0 on success, 1 on failure. Invalid state exit qualification code
> >- * is assigned to entry_failure_code on failure.
> >   */
> >  static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool nested_ept,
> >  			       u32 *entry_failure_code)
> 
> I think it's worth keeping the last part which is " Exit qualification code
> is assigned to entry_failure_code on failure." because "Entry Failure" and
> "Exit Qualification" might sound bit confusing until you actually look at
> the caller nested_vmx_enter_non_root_mode().

Hmm, something like this?

/*
 * Load guest's/host's cr3 at nested entry/exit.  @nested_ept is true if we are
 * emulating VM-Entry into a guest with EPT enabled.  On failure, the expected
 * Exit Qualification (for a VM-Entry consistency check VM-Exit) is assigned to
 * @entry_failure_code.
 */
