Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1AAD177ADA
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 16:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbgCCPoz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 10:44:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:1498 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729325AbgCCPoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 10:44:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 07:44:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="228953508"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 03 Mar 2020 07:44:53 -0800
Date:   Tue, 3 Mar 2020 07:44:53 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2 36/66] KVM: x86: Handle GBPAGE CPUID adjustment for
 EPT in VMX code
Message-ID: <20200303154453.GF1439@linux.intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
 <20200302235709.27467-37-sean.j.christopherson@intel.com>
 <90df7276-e586-9082-3d80-6b45e0fb4670@redhat.com>
 <20200303153550.GC1439@linux.intel.com>
 <c789abc9-9687-82ae-d133-bd3a6d838ca5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c789abc9-9687-82ae-d133-bd3a6d838ca5@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 03, 2020 at 04:40:32PM +0100, Paolo Bonzini wrote:
> On 03/03/20 16:35, Sean Christopherson wrote:
> > Oof, that took me a long time to process.  You're saying that KVM can
> > allow the guest to use GBPAGES when shadow paging is enabled because KVM
> > can effectively emulate GBPAGES.  And IIUC, you're also saying that
> > cpuid.GBPAGES should never be influenced by EPT restrictions.
> > 
> > That all makes sense.
> 
> Yes, exactly.

I'll tack that on to the front of the series.  Should it be tagged Fixes?
Feels like a fix, but is also more than a bit scary.
