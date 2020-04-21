Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A941B2DA5
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 19:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgDURBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 13:01:52 -0400
Received: from mga05.intel.com ([192.55.52.43]:49478 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbgDURBv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 13:01:51 -0400
IronPort-SDR: 7nG4+BdcQ/rZd8BNrrWtVqrlg+r2W7GqyH/C/xnVFXo19BmjqXt5vh0YpC7XJPG44VoMiUBZlR
 fhcvyT1aIfjA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 10:01:51 -0700
IronPort-SDR: JtAUKfagxhvnf6AeQdYCiYQHiytb1Ad1qH2Qc5H1zIiAWkeoNgIYSUjMVw3HhK35dcMoSzrcYS
 9QhyvugUmYhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="247220823"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 21 Apr 2020 10:01:51 -0700
Date:   Tue, 21 Apr 2020 10:01:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v3 0/2] KVM: VMX: Unionize vcpu_vmx.exit_reason
Message-ID: <20200421170150.GA16486@linux.intel.com>
References: <20200421075328.14458-1-sean.j.christopherson@intel.com>
 <bcf9cbba-6cce-f10b-da94-232403a3f7f6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcf9cbba-6cce-f10b-da94-232403a3f7f6@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 21, 2020 at 06:19:15PM +0200, Paolo Bonzini wrote:
> On 21/04/20 09:53, Sean Christopherson wrote:
> > Minor fixup patch for a mishandled conflict between the vmcs.INTR_INFO
> > caching series and the union series, plus the actual unionization patch
> > rebased onto kvm/queue, commit 604e8bba0dc5 ("KVM: Remove redundant ...").
> > 
> > Sean Christopherson (2):
> >   KVM: nVMX: Drop a redundant call to vmx_get_intr_info()
> >   KVM: VMX: Convert vcpu_vmx.exit_reason to a union
> > 
> >  arch/x86/kvm/vmx/nested.c | 39 ++++++++++++++---------
> >  arch/x86/kvm/vmx/vmx.c    | 65 ++++++++++++++++++++-------------------
> >  arch/x86/kvm/vmx/vmx.h    | 25 ++++++++++++++-
> >  3 files changed, 83 insertions(+), 46 deletions(-)
> > 
> 
> Thanks, I queued patch 1.  I am not too enthusiastic about patch 2, but
> when SGX comes around it may be a better idea.

And maybe it'll grow on you by the time I figure out how to send a pull
request ;-).
