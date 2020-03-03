Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE48A177B3F
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 16:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbgCCP4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 10:56:50 -0500
Received: from mga04.intel.com ([192.55.52.120]:12464 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728924AbgCCP4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 10:56:50 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 07:56:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="233659216"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 03 Mar 2020 07:56:49 -0800
Date:   Tue, 3 Mar 2020 07:56:49 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2 50/66] KVM: x86: Override host CPUID results with
 kvm_cpu_caps
Message-ID: <20200303155649.GH1439@linux.intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
 <20200302235709.27467-51-sean.j.christopherson@intel.com>
 <8ec995c8-5fc4-eb6c-716b-3f18a05c3f77@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ec995c8-5fc4-eb6c-716b-3f18a05c3f77@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 03, 2020 at 04:22:48PM +0100, Paolo Bonzini wrote:
> On 03/03/20 00:56, Sean Christopherson wrote:
> > Override CPUID entries with kvm_cpu_caps during KVM_GET_SUPPORTED_CPUID
> > instead of masking the host CPUID result, which is redundant now that
> > the host CPUID is incorporated into kvm_cpu_caps at runtime.
> > 
> > No functional change intended.
> > 
> > Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> The UMIP adjustment is now redundant in vmx_set_supported_cpuid, it's
> done in the next patch but it makes more sense to remove it here (so the
> next patch only moves code from set_supported_cpuid to set_cpu_caps).

Works for me.
