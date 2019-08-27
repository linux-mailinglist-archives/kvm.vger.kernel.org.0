Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF8419F621
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 00:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfH0W1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 18:27:15 -0400
Received: from mga07.intel.com ([134.134.136.100]:59462 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbfH0W1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 18:27:15 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 15:27:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="264441178"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 27 Aug 2019 15:27:14 -0700
Date:   Tue, 27 Aug 2019 15:27:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/2] KVM: nVMX: add tracepoints for nested VM-Enter
 failures
Message-ID: <20190827222714.GL27459@linux.intel.com>
References: <20190711155830.15178-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711155830.15178-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping.

On Thu, Jul 11, 2019 at 08:58:28AM -0700, Sean Christopherson wrote:
> Debugging VM-Enter failures has been the bane of my existence for years.
> Seeing KVM's VMCS dump format pop up on a console triggers a Pavlovian
> response of swear words and sighs.  As KVM's coverage of VM-Enter checks
> improve, so too do the odds of being able to triage/debug a KVM (or any
> other hypervisor) bug by running the bad KVM build as an L1 guest.
> 
> Improve support for using KVM to debug a buggy VMM by adding tracepoints
> to capture the basic gist of a VM-Enter failure so that extracting said
> information from KVM doesn't require attaching a debugger or modifying
> L0 KVM to manually log failures.
> 
> The captured information is by no means complete or perfect, e.g. I'd
> love to capture *exactly* why a consistency check failed, but logging
> that level of detail would require invasive code changes and might even
> act as a deterrent to adding more checks in KVM.
> 
> v3: Fix a minor snafu in the v2 rebase, and re-rebase to kvm/next
>     (a45ff5994c9c, "Merge tag 'kvm-arm-for-5.3'...")
> 
> v2: Rebase to kvm/queue.
> 
> Sean Christopherson (2):
>   KVM: nVMX: add tracepoint for failed nested VM-Enter
>   KVM: nVMX: trace nested VM-Enter failures detected by H/W
> 
>  arch/x86/include/asm/vmx.h |  14 ++
>  arch/x86/kvm/trace.h       |  22 +++
>  arch/x86/kvm/vmx/nested.c  | 269 ++++++++++++++++++++-----------------
>  arch/x86/kvm/x86.c         |   1 +
>  4 files changed, 179 insertions(+), 127 deletions(-)
> 
> -- 
> 2.22.0
> 
