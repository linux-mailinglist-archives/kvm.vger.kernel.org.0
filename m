Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA62D98BB
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 19:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389526AbfJPRtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 13:49:45 -0400
Received: from mga07.intel.com ([134.134.136.100]:18831 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727508AbfJPRto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 13:49:44 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 10:49:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,304,1566889200"; 
   d="scan'208";a="186223699"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 16 Oct 2019 10:49:43 -0700
Date:   Wed, 16 Oct 2019 10:49:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Derek Yerger <derek@djy.llc>, kvm@vger.kernel.org,
        "Bonzini, Paolo" <pbonzini@redhat.com>
Subject: Re: PROBLEM: Regression of MMU causing guest VM application errors
Message-ID: <20191016174943.GG5866@linux.intel.com>
References: <1e525b08-6204-3238-5d56-513f82f1d7fb@djy.llc>
 <20191016112857.293a197d@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016112857.293a197d@x1.home>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 16, 2019 at 11:28:57AM -0600, Alex Williamson wrote:
> On Wed, 16 Oct 2019 00:49:51 -0400
> Derek Yerger <derek@djy.llc> wrote:
> 
> > In at least Linux 5.2.7 via Fedora, up to 5.2.18, guest OS applications 
> > repeatedly crash with segfaults. The problem does not occur on 5.1.16.
> > 
> > System is running Fedora 29 with kernel 5.2.18. Guest OS is Windows 10 with an 
> > AMD Radeon 540 GPU passthrough. When on 5.2.7 or 5.2.18, specific windows 
> > applications frequently and repeatedly crash, throwing exceptions in random 
> > libraries. Going back to 5.1.16, the issue does not occur.
> > 
> > The host system is unaffected by the regression.
> > 
> > Keywords: kvm mmu pci passthrough vfio vfio-pci amdgpu
> > 
> > Possibly related: Unmerged [PATCH] KVM: x86/MMU: Zap all when removing memslot 
> > if VM has assigned device
> 
> That was never merged because it was superseded by:
> 
> d012a06ab1d2 Revert "KVM: x86/mmu: Zap only the relevant pages when removing a memslot"
> 
> That revert also induced this commit:
> 
> 002c5f73c508 KVM: x86/mmu: Reintroduce fast invalidate/zap for flushing memslot
> 
> Both of these were merged to stable, showing up in 5.2.11 and 5.2.16
> respectively, so seeing these sorts of issues might be considered a
> known issue on 5.2.7, but not 5.2.18 afaik.  Do you have a specific
> test that reliably reproduces the issue?  Thanks,

Also, does the failure reproduce on on 5.2.1 - 5.2.6?  The memslot debacle
exists on all flavors of 5.2.x, if the errors showed up in 5.2.7 then they
are being caused by something else.
