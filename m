Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC4895EC6
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 14:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730077AbfHTMfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 08:35:19 -0400
Received: from mga06.intel.com ([134.134.136.31]:26646 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730070AbfHTMfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 08:35:18 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 05:35:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,408,1559545200"; 
   d="scan'208";a="185901880"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Aug 2019 05:35:15 -0700
Date:   Tue, 20 Aug 2019 20:36:46 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com, alazar@bitdefender.com
Subject: Re: [PATCH RESEND v4 5/9] KVM: VMX: Add init/set/get functions for
 SPP
Message-ID: <20190820123646.GB4828@local-michael-cet-test.sh.intel.com>
References: <20190814070403.6588-1-weijiang.yang@intel.com>
 <20190814070403.6588-6-weijiang.yang@intel.com>
 <e235b490-0932-3ebf-dee0-f3359216ed9f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e235b490-0932-3ebf-dee0-f3359216ed9f@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 19, 2019 at 05:05:22PM +0200, Paolo Bonzini wrote:
> On 14/08/19 09:03, Yang Weijiang wrote:
> > +
> > +int kvm_mmu_get_subpages(struct kvm *kvm, struct kvm_subpage *spp_info,
> > +			 bool mmu_locked)
> > +{
> > +	u32 *access = spp_info->access_map;
> > +	gfn_t gfn = spp_info->base_gfn;
> > +	int npages = spp_info->npages;
> > +	struct kvm_memory_slot *slot;
> > +	int i;
> > +	int ret;
> > +
> > +	if (!kvm->arch.spp_active)
> > +	      return -ENODEV;
> > +
> > +	if (!mmu_locked)
> > +	      spin_lock(&kvm->mmu_lock);
> > +
> 
> Do not add this argument.  Just lock mmu_lock in the callers.
> 
> Paolo
OK, will remove it, thanks!
