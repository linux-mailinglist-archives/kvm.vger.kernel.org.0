Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9309F1D9ADF
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 17:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgESPMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 11:12:43 -0400
Received: from mga18.intel.com ([134.134.136.126]:50621 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728775AbgESPMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 11:12:43 -0400
IronPort-SDR: dcJ7P5+XWzqpOgDPAcXUAt116GMieokwr+YZsUQpbwQlISjYS5SCkA9UWn4ssDokauJAYdN/cy
 t2MZFvqKdqdA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 08:12:43 -0700
IronPort-SDR: HKo2/GA0KmwgNBM6wnjMvauWnf5GnBUMLwi059UT4U4krllDSIRdzPslzgoVCwRJEhrqTM96gl
 uGO1PZp4GbVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,410,1583222400"; 
   d="scan'208";a="282348276"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 19 May 2020 08:12:42 -0700
Date:   Tue, 19 May 2020 08:12:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com
Subject: Re: [PATCH v11 07/11] KVM: x86: Expose MSR_IA32_PERF_CAPABILITIES
 for LBR record format
Message-ID: <20200519151242.GA13603@linux.intel.com>
References: <20200514083054.62538-1-like.xu@linux.intel.com>
 <20200514083054.62538-8-like.xu@linux.intel.com>
 <20200519105335.GF279861@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519105335.GF279861@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 19, 2020 at 12:53:35PM +0200, Peter Zijlstra wrote:
> On Thu, May 14, 2020 at 04:30:50PM +0800, Like Xu wrote:
> > @@ -203,6 +206,12 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> >  		msr_info->data = pmu->global_ovf_ctrl;
> >  		return 0;
> > +	case MSR_IA32_PERF_CAPABILITIES:
> > +		if (!msr_info->host_initiated &&
> > +			!guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
> > +			return 1;
> 
> I know this is KVM code, so maybe they feel differently, but I find the
> above indentation massively confusing. Consider using: "set cino=:0(0"
> if you're a vim user.

I most definitely don't feel differently.  I would be strongly in favor of
making that pattern a checkpatch error.
