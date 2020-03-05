Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7D217AA0F
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 17:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgCEQED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 11:04:03 -0500
Received: from mga06.intel.com ([134.134.136.31]:42946 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgCEQED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 11:04:03 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 08:04:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,518,1574150400"; 
   d="scan'208";a="439544115"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 05 Mar 2020 08:04:01 -0800
Date:   Thu, 5 Mar 2020 08:04:01 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix warning due to implicit truncation on
 32-bit KVM
Message-ID: <20200305160401.GF11500@linux.intel.com>
References: <20200305002422.20968-1-sean.j.christopherson@intel.com>
 <87wo7zcea3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo7zcea3.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 05, 2020 at 11:00:20AM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Explicitly cast the integer literal to an unsigned long when stuffing a
> > non-canonical value into the host virtual address during private memslot
> > deletion.  The explicit cast fixes a warning that gets promoted to an
> > error when running with KVM's newfangled -Werror setting.
> >
> >   arch/x86/kvm/x86.c:9739:9: error: large integer implicitly truncated
> >   to unsigned type [-Werror=overflow]
> >
> > Fixes: a3e967c0b87d3 ("KVM: Terminate memslot walks via used_slots"
> 
> Missing ')'

Hrm, surprised checkpatch didn't catch that.
