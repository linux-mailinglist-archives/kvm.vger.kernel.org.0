Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D00B01983A3
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 20:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgC3Sr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 14:47:27 -0400
Received: from mga18.intel.com ([134.134.136.126]:18138 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgC3Sr1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 14:47:27 -0400
IronPort-SDR: qGY1OdV7FU9paGotflJTMqwdFSk84g9mtKI0s2B11t94iVbaxXpSvHwUMNeinQINVWZ8xnQ+g/
 WwEC4+HHjEpA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 11:47:26 -0700
IronPort-SDR: 0Z2oSJtqJrNNiTkIQfCPafvTts0FQ3C+G5PgCK1dvDyfYmwvnEDLVJeoTPzJjKzECCMUTGo33b
 AAwIBN9OO4Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="395221248"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 30 Mar 2020 11:47:26 -0700
Date:   Mon, 30 Mar 2020 11:47:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Junaid Shahid <junaids@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/3] KVM: x86: introduce kvm_mmu_invalidate_gva
Message-ID: <20200330184726.GJ24988@linux.intel.com>
References: <20200326093516.24215-1-pbonzini@redhat.com>
 <20200326093516.24215-2-pbonzini@redhat.com>
 <20200328182631.GQ8104@linux.intel.com>
 <2a1f9477-c289-592e-25ff-f22a37044457@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a1f9477-c289-592e-25ff-f22a37044457@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 30, 2020 at 12:45:34PM +0200, Paolo Bonzini wrote:
> On 28/03/20 19:26, Sean Christopherson wrote:
> >> +	if (mmu != &vcpu->arch.guest_mmu) {
> > Doesn't need to be addressed here, but this is not the first time in this
> > series (the large TLB flushing series) that I've struggled to parse
> > "guest_mmu".  Would it make sense to rename it something like nested_tdp_mmu
> > or l2_tdp_mmu?
> > 
> > A bit ugly, but it'd be nice to avoid the mental challenge of remembering
> > that guest_mmu is in play if and only if nested TDP is enabled.
> 
> No, it's not ugly at all.  My vote would be for shadow_tdp_mmu.

Works for me.  My vote is for anything other than guest_mmu :-)
