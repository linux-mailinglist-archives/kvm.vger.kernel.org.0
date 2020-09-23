Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F04A275E84
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 19:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgIWRWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 13:22:40 -0400
Received: from mga18.intel.com ([134.134.136.126]:41755 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgIWRWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 13:22:40 -0400
IronPort-SDR: clazLmNpC80XBkV+L1OG/LTBc3tMUcTBN0jFp+RFy7QCBse2I3ObVoWnwALZZXYfGQOxQ5xER+
 9lcWbT2NSAug==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="148705771"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="148705771"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 10:22:39 -0700
IronPort-SDR: 9/Qgj7wxNMkAbQSYB26lYLmfcjioX6/YkrHYu8bAzf7aATYsLXTW1xb7kuFeEuw1tZNCwcmMkU
 hR1XYi3Y/V1Q==
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="511731904"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 10:22:38 -0700
Date:   Wed, 23 Sep 2020 10:22:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] KVM: VMX: Add a helper and macros to reduce
 boilerplate for sec exec ctls
Message-ID: <20200923172237.GA32044@linux.intel.com>
References: <20200923165048.20486-1-sean.j.christopherson@intel.com>
 <20200923165048.20486-5-sean.j.christopherson@intel.com>
 <784480fd-3aeb-6c08-30f9-ac474bb23b6c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <784480fd-3aeb-6c08-30f9-ac474bb23b6c@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 23, 2020 at 07:20:17PM +0200, Paolo Bonzini wrote:
> On 23/09/20 18:50, Sean Christopherson wrote:
> > Add a helper function and several wrapping macros to consolidate the
> > copy-paste code in vmx_compute_secondary_exec_control() for adjusting
> > controls that are dependent on guest CPUID bits.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 128 +++++++++++++----------------------------
> >  1 file changed, 41 insertions(+), 87 deletions(-)
> 
> The diffstat is enticing but the code a little less so...  Can you just
> add documentation above vmx_adjust_secondary_exec_control that explains
> the how/why?

Ya, I'd be more than happy to add a big comment.
