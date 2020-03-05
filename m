Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD20C17A8F8
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 16:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgCEPgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 10:36:25 -0500
Received: from mga12.intel.com ([192.55.52.136]:35096 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbgCEPgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 10:36:25 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 07:36:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,518,1574150400"; 
   d="scan'208";a="413554525"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 05 Mar 2020 07:36:23 -0800
Date:   Thu, 5 Mar 2020 07:36:23 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86: VMX: rename 'kvm_area' to 'vmxon_region'
Message-ID: <20200305153623.GA11500@linux.intel.com>
References: <20200305100123.1013667-1-vkuznets@redhat.com>
 <20200305100123.1013667-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305100123.1013667-2-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Super nit: can I convince you to use "KVM: VMX:" instead of "KVM: x86: VMX:"?

  $ glo | grep -e "KVM: x86: nVMX" -e "KVM: x86: VMX:" | wc -l
  8
  $ glo | grep -e "KVM: nVMX" -e "KVM: VMX:" | wc -l
  1032

I'm very conditioned to scan for "KVM: *VMX:", e.g. I was about to complain
that this used the wrong scope :-)   And in the event that Intel adds a new
technology I'd like to be able to use "KVM: Intel:" and "KVM: ***X:"
instead of "KVM: x86: Intel:" and "KVM: x86: Intel: ***X:" for code that is
common to Intel versus specific to a technology.

On Thu, Mar 05, 2020 at 11:01:22AM +0100, Vitaly Kuznetsov wrote:
> The name 'kvm_area' is misleading (as we have way too many areas which are
> KVM related), what alloc_kvm_area()/free_kvm_area() functions really do is
> allocate/free VMXON region for all CPUs. Rename accordingly.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

+1000

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
