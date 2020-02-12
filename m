Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC6E15AD61
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 17:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgBLQ2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 11:28:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:21720 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726728AbgBLQ2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 11:28:17 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Feb 2020 08:28:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,433,1574150400"; 
   d="scan'208";a="237752817"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 12 Feb 2020 08:28:16 -0800
Date:   Wed, 12 Feb 2020 08:28:16 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] KVM: x86/mmu: Rename kvm_mmu->get_cr3() to
 ->get_guest_cr3_or_eptp()
Message-ID: <20200212162816.GB15617@linux.intel.com>
References: <20200207173747.6243-1-sean.j.christopherson@intel.com>
 <20200207173747.6243-7-sean.j.christopherson@intel.com>
 <1424348b-7f09-513a-960b-6d15ac3a9ae4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1424348b-7f09-513a-960b-6d15ac3a9ae4@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 01:00:59PM +0100, Paolo Bonzini wrote:
> On 07/02/20 18:37, Sean Christopherson wrote:
> > Rename kvm_mmu->get_cr3() to call out that it is retrieving a guest
> > value, as opposed to kvm_mmu->set_cr3(), which sets a host value, and to
> > note that it will return L1's EPTP when nested EPT is in use.  Hopefully
> > the new name will also make it more obvious that L1's nested_cr3 is
> > returned in SVM's nested NPT case.
> > 
> > No functional change intended.
> 
> Should we call it "get_pgd", since that is how Linux calls the top-level
> directory?  I always get confused by PUD/PMD, but as long as we only
> keep one /p.d/ moniker it should be fine.

Heh, I have the exact same sentiment.  get_pgd() works for me.
