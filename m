Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C03221533F6
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 16:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbgBEPfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 10:35:09 -0500
Received: from mga04.intel.com ([192.55.52.120]:8220 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbgBEPfJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 10:35:09 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 07:35:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,406,1574150400"; 
   d="scan'208";a="431903663"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 05 Feb 2020 07:35:08 -0800
Date:   Wed, 5 Feb 2020 07:35:08 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 04/26] KVM: x86: Add a kvm_x86_ops hook to query
 virtualized MSR support
Message-ID: <20200205153508.GD4877@linux.intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
 <20200129234640.8147-5-sean.j.christopherson@intel.com>
 <87eev9ksqy.fsf@vitty.brq.redhat.com>
 <20200205145923.GC4877@linux.intel.com>
 <8736bpkqif.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8736bpkqif.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 05, 2020 at 04:22:48PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > On Wed, Feb 05, 2020 at 03:34:29PM +0100, Vitaly Kuznetsov wrote:
> >> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> >> 
> >> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> >
> > Stooooooop!  Everything from this point on is obsoleted by kvm_cpu_caps!
> >
> 
> Oops, this was only a week old series! Patches are rottening fast
> nowadays!

Sorry :-(

I dug deeper into the CPUID crud after posting this series because I really
didn't like the end result for vendor-specific leafs, and ended up coming
up with (IMO) a much more elegant solution.

https://lkml.kernel.org/r/20200201185218.24473-1-sean.j.christopherson@intel.com/

or on patchwork

https://patchwork.kernel.org/cover/11361361/
