Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E008A168357
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 17:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgBUQ3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 11:29:17 -0500
Received: from mga03.intel.com ([134.134.136.65]:17808 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbgBUQ3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 11:29:16 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2020 08:29:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,469,1574150400"; 
   d="scan'208";a="225259898"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 21 Feb 2020 08:29:15 -0800
Date:   Fri, 21 Feb 2020 08:29:15 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 26/61] KVM: x86: Introduce cpuid_entry_{get,has}()
 accessors
Message-ID: <20200221162915.GI12665@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-27-sean.j.christopherson@intel.com>
 <875zg0q6f3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875zg0q6f3.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 21, 2020 at 04:57:52PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > @@ -119,6 +113,40 @@ static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsi
> >  	}
> >  }
> >  
> > +static __always_inline u32 *cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
> > +						unsigned x86_feature)
> 
> It is just me who dislikes bare 'unsigned'?

I don't like it either.  I also don't like get yelled at by checkpatch.

I used "unsigned" here and throughout to be consistent with the existing
guest_cpuid_*() and x86_feature_cpuid() helpers in cpuid.h.

I will happily add a patch to change those to use "unsigned int" and
then also use "unsigned int" for the cpuid_entry_*() code.
