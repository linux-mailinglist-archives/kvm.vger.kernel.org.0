Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3AA81054EA
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 15:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfKUOzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 09:55:42 -0500
Received: from mga04.intel.com ([192.55.52.120]:33658 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbfKUOzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 09:55:42 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 06:55:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,226,1571727600"; 
   d="scan'208";a="197263750"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga007.jf.intel.com with ESMTP; 21 Nov 2019 06:55:39 -0800
Date:   Thu, 21 Nov 2019 22:57:36 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
Subject: Re: [PATCH v7 3/9] mmu: spp: Add SPP Table setup functions
Message-ID: <20191121145736.GD17169@local-michael-cet-test>
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-4-weijiang.yang@intel.com>
 <6898c9fe-6cd7-8820-78c0-9fc4969b48f1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6898c9fe-6cd7-8820-78c0-9fc4969b48f1@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 21, 2019 at 11:32:19AM +0100, Paolo Bonzini wrote:
> On 19/11/19 09:49, Yang Weijiang wrote:
> > +			if (old_spte != spp_spte) {
> > +				spp_spte_set(iter.sptep, spp_spte);
> > +				//kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> > +				kvm_flush_remote_tlbs(vcpu->kvm);
> > +			}
> 
> Please do not leave commented code in the middle of the series.

Oops, I should have removed them, thanks for pointing it out.
> Paolo
