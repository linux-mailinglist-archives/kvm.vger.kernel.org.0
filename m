Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F101C3E2B
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 17:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbgEDPJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 11:09:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:6395 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbgEDPJm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 11:09:42 -0400
IronPort-SDR: mrH34a4NnU41VrFjnViFVmgkQf7fPAexd4BPbF00rsihZ+WAUIvFav5VXV14fZ9zMHnIP6X21a
 RegijQLEwGFQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 08:09:40 -0700
IronPort-SDR: +rmv6oM9Pv2+DecJHTy97vzZ31ydYiRgTZbcySm3YCgNqSqKxSSFEMxXhiChVTaoJZbfkQKmq3
 NTqALnAojO8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,352,1583222400"; 
   d="scan'208";a="460696072"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 04 May 2020 08:09:40 -0700
Date:   Mon, 4 May 2020 08:09:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] KVM: x86: Misc anti-retpoline optimizations
Message-ID: <20200504150940.GB16949@linux.intel.com>
References: <20200502043234.12481-1-sean.j.christopherson@intel.com>
 <76c2fc30-58e3-4d90-4b66-85b6fb4741b5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76c2fc30-58e3-4d90-4b66-85b6fb4741b5@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 03:25:58PM +0200, Paolo Bonzini wrote:
> On 02/05/20 06:32, Sean Christopherson wrote:
> > A smattering of optimizations geared toward avoiding retpolines, though
> > IMO most of the patches are worthwhile changes irrespective of retpolines.
> > I can split this up into separate patches if desired, outside of the
> > obvious combos there are no dependencies.
> 
> Most of them are good stuff anyway, I agree.
> 
> Since I like to believe that static calls _are_ close, I queued these:
> 
>       KVM: x86: Save L1 TSC offset in 'struct kvm_vcpu_arch'
>       KVM: nVMX: Unconditionally validate CR3 during nested transitions
>       KVM: VMX: Add proper cache tracking for CR4
>       KVM: VMX: Add proper cache tracking for CR0
>       KVM: VMX: Move nested EPT out of kvm_x86_ops.get_tdp_level() hook
>       KVM: x86/mmu: Capture TDP level when updating CPUID
> 
> and I don't disagree with the DR6 one though it can be even improved a
> bit so I'll send a patch myself.

Sounds good, thanks!
