Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B568415330C
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgBEOc1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:32:27 -0500
Received: from mga03.intel.com ([134.134.136.65]:59183 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbgBEOc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 09:32:27 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 06:32:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,405,1574150400"; 
   d="scan'208";a="231728469"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 05 Feb 2020 06:32:26 -0800
Date:   Wed, 5 Feb 2020 06:32:26 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 01/26] KVM: x86: Remove superfluous brackets from case
 statement
Message-ID: <20200205143226.GA4877@linux.intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
 <20200129234640.8147-2-sean.j.christopherson@intel.com>
 <87mu9xkszb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mu9xkszb.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 05, 2020 at 03:29:28PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Remove unnecessary brackets from a case statement that unintentionally
> > encapsulates unrelated case statements in the same switch statement.
> > While technically legal and functionally correct syntax, the brackets
> > are visually confusing and potentially dangerous, e.g. the last of the
> > encapsulated case statements has an undocumented fall-through that isn't
> > flagged by compilers due the encapsulation.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/x86.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 7e3f1d937224..24597526b5de 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5260,7 +5260,7 @@ static void kvm_init_msr_list(void)
> >  				 !intel_pt_validate_hw_cap(PT_CAP_single_range_output)))
> >  				continue;
> >  			break;
> > -		case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B: {
> > +		case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
> >  			if (!kvm_x86_ops->pt_supported() ||
> >  				msrs_to_save_all[i] - MSR_IA32_RTIT_ADDR0_A >=
> >  				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
> > @@ -5275,7 +5275,7 @@ static void kvm_init_msr_list(void)
> >  			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
> >  			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
> >  				continue;
> > -		}
> > +			break;
> >  		default:
> >  			break;
> >  		}
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks for the review(s), but don't bother reviewing the rest of this
series.  Most of it is superseded by the kvm_cpu_caps mega-series, and
I'll spin the MSR patches into their own series.
