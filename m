Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B56FBE98E2
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 10:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfJ3JJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 05:09:52 -0400
Received: from mga17.intel.com ([192.55.52.151]:8496 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfJ3JJw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 05:09:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Oct 2019 02:09:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,246,1569308400"; 
   d="scan'208";a="198621558"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 30 Oct 2019 02:09:51 -0700
Date:   Wed, 30 Oct 2019 02:09:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Reto Buerki <reet@codelabs.ch>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] KVM: x86: nVMX GUEST_CR3 bug fix, and then some...
Message-ID: <20191030090950.GA12481@linux.intel.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com>
 <8414d3e8-9a68-e817-de5a-3e9ca6dc85bb@codelabs.ch>
 <20191029150304.GA29542@nodbug.lucina.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191029150304.GA29542@nodbug.lucina.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 29, 2019 at 04:03:04PM +0100, Martin Lucina wrote:
> (Cc:s trimmed)
> 
> Hi,
> 
> On Monday, 30.09.2019 at 12:42, Reto Buerki wrote:
> > On 9/27/19 11:45 PM, Sean Christopherson wrote:
> > > Sean Christopherson (8):
> > >   KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter
> > >   KVM: VMX: Skip GUEST_CR3 VMREAD+VMWRITE if the VMCS is up-to-date
> > >   KVM: VMX: Consolidate to_vmx() usage in RFLAGS accessors
> > >   KVM: VMX: Optimize vmx_set_rflags() for unrestricted guest
> > >   KVM: x86: Add WARNs to detect out-of-bounds register indices
> > >   KVM: x86: Fold 'enum kvm_ex_reg' definitions into 'enum kvm_reg'
> > >   KVM: x86: Add helpers to test/mark reg availability and dirtiness
> > >   KVM: x86: Fold decache_cr3() into cache_reg()
> > > 
> > >  arch/x86/include/asm/kvm_host.h |  5 +-
> > >  arch/x86/kvm/kvm_cache_regs.h   | 67 +++++++++++++++++------
> > >  arch/x86/kvm/svm.c              |  5 --
> > >  arch/x86/kvm/vmx/nested.c       | 14 ++++-
> > >  arch/x86/kvm/vmx/vmx.c          | 94 ++++++++++++++++++---------------
> > >  arch/x86/kvm/x86.c              | 13 ++---
> > >  arch/x86/kvm/x86.h              |  6 +--
> > >  7 files changed, 123 insertions(+), 81 deletions(-)
> > 
> > Series:
> > Tested-by: Reto Buerki <reet@codelabs.ch>
> 
> Any chance of this series making it into 5.4? Unless I'm looking in the
> wrong place, I don't see the changes in either kvm.git or Linus' tree.

It's queued up in kvm.git for 5.5.  That being said, the first patch
should go into 5.4 (it's also tagged for stable).  The next round of KVM
fixes for 5.4 will probably be delayed due to KVM Forum.

Paolo?
