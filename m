Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD161054FD
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 16:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKUPCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 10:02:06 -0500
Received: from mga03.intel.com ([134.134.136.65]:15440 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbfKUPCF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 10:02:05 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 07:02:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,226,1571727600"; 
   d="scan'208";a="205093248"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga008.fm.intel.com with ESMTP; 21 Nov 2019 07:02:03 -0800
Date:   Thu, 21 Nov 2019 23:04:00 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
Subject: Re: [PATCH v7 6/9] vmx: spp: Set up SPP paging table at
 vmentry/vmexit
Message-ID: <20191121150400.GF17169@local-michael-cet-test>
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-7-weijiang.yang@intel.com>
 <b67b07bf-7051-7dbc-2911-9268d72f0b70@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b67b07bf-7051-7dbc-2911-9268d72f0b70@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 21, 2019 at 11:32:22AM +0100, Paolo Bonzini wrote:
> On 19/11/19 09:49, Yang Weijiang wrote:
> > @@ -5400,6 +5434,10 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
> >  		r = vcpu->arch.mmu->page_fault(vcpu, cr2,
> >  					       lower_32_bits(error_code),
> >  					       false);
> > +
> > +		if (vcpu->run->exit_reason == KVM_EXIT_SPP)
> > +			return 0;
> > +
> 
> Instead of this, please add a RET_PF_USERSPACE case to the RET_PF_* enum
> in mmu.c.
OK, will add it, thank you!
> 
> Paolo
