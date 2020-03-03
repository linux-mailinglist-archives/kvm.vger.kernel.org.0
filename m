Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD95177AC0
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 16:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730096AbgCCPmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 10:42:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:36306 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728899AbgCCPmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 10:42:51 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 07:42:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="287020798"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Mar 2020 07:42:50 -0800
Date:   Tue, 3 Mar 2020 07:42:50 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>, Bandan Das <bsd@redhat.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86: clear stale x86_emulate_ctxt->intercept
 value
Message-ID: <20200303154250.GE1439@linux.intel.com>
References: <20200303143316.834912-1-vkuznets@redhat.com>
 <20200303143316.834912-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303143316.834912-2-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 03, 2020 at 03:33:15PM +0100, Vitaly Kuznetsov wrote:
> Commit c44b4c6ab80e ("KVM: emulate: clean up initializations in
> init_decode_cache") reduced the number of fields cleared by
> init_decode_cache() claiming that they are being cleared elsewhere,
> 'intercept', however, seems to be left uncleared in some cases.
> 
> The issue I'm observing manifests itself as following:
> after commit 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest
> mode") Hyper-V guests on KVM stopped booting with:
> 
>  kvm_nested_vmexit:    rip fffff802987d6169 reason EPT_VIOLATION info1 181
>     info2 0 int_info 0 int_info_err 0
>  kvm_page_fault:       address febd0000 error_code 181
>  kvm_emulate_insn:     0:fffff802987d6169: f3 a5
>  kvm_emulate_insn:     0:fffff802987d6169: f3 a5 FAIL
>  kvm_inj_exception:    #UD (0x0)
> 
> Fixes: c44b4c6ab80e ("KVM: emulate: clean up initializations in init_decode_cache")
> Fixes: 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest mode")
> Cc: stable@vger.kernel.org
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
