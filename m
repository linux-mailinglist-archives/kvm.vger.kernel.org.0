Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 162C11BD59
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 20:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbfEMSqe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 14:46:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:56609 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727727AbfEMSqe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 14:46:34 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 May 2019 11:46:33 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga006.fm.intel.com with ESMTP; 13 May 2019 11:46:33 -0700
Date:   Mon, 13 May 2019 11:46:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com
Subject: Re: [KVM nVMX]: Check "load IA32_PERF_GLOBAL_CTRL" on vmentry of
 nested guests
Message-ID: <20190513184633.GE28561@linux.intel.com>
References: <20190424231724.2014-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424231724.2014-1-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 24, 2019 at 07:17:16PM -0400, Krish Sadhukhan wrote:
> Patch 1 through 7 add the necessary KVM code for checking and enabling
> "load IA32_PERF_GLOBAL_CTRL" VM-{exit,entry} controls.
> 
> Patch# 8 adds a unit test for the "load IA32_PERF_GLOBAL_CTRL" VM-exit
> control. I will send a separate patch for the unit test for
> "load IA32_PERF_GLOBAL_CTRL" VM-entry control.
> 
> 
> [PATCH 1/8][KVMnVMX]: Enable "load IA32_PERF_GLOBAL_CTRL" VM-exit control
> [PATCH 2/8][KVM nVMX]: Enable "load IA32_PERF_GLOBAL_CTRL" VM-entry
> [PATCH 3/8][KVM VMX]: Add a function to check reserved bits in
> [PATCH 4/8][KVM nVMX]: Check "load IA32_PERF_GLOBAL_CTRL" VM-exit control
> [PATCH 5/8][KVM nVMX]: Check "load IA32_PERF_GLOBAL_CTRL" VM-entry control
> [PATCH 6/8][KVM nVMX]: Load IA32_PERF_GLOBAL_CTRL MSR on vmentry of nested
> [PATCH 7/8][KVM nVMX]: Enable "load IA32_PERF_GLOBAL_CTRL VM-{entry,exit}
> [PATCH 8/8][KVM nVMX]: Test "load IA32_PERF_GLOBAL_CTRL" controls on vmentry

These subjects are wrong, should be:

  [PATCH n/8] KVM: nVMX: Blah blah blah

or something along those lines.  Wrapping the scope in square braces causes
the scope to be dropped when the patch is applied.  They're also different
from the diffstat, which is odd.

And nearly all of the patches are missing proper changelogs.

> 
>  arch/x86/include/asm/kvm_host.h  |  1 +
>  arch/x86/include/asm/msr-index.h |  7 +++++++
>  arch/x86/kvm/vmx/nested.c        | 19 +++++++++++++++++--
>  arch/x86/kvm/vmx/vmx.c           | 12 ++++++++++++
>  arch/x86/kvm/x86.c               | 20 ++++++++++++++++++++
>  5 files changed, 57 insertions(+), 2 deletions(-)
> 
> Krish Sadhukhan (7):
>       nVMX: Enable "load IA32_PERF_GLOBAL_CTRL" VM-exit control for nested guests
>       nVMX: Enable "load IA32_PERF_GLOBAL_CTRL" VM-entry control for nested guests
>       VMX: Add a function to check reserved bits in MSR_CORE_PERF_GLOBAL_CTRL
>       nVMX: Check "load IA32_PERF_GLOBAL_CTRL" VM-exit control on vmentry of nested guests
>       nVMX: Check "load IA32_PERF_GLOBAL_CTRL" VM-entry control on vmentry of nested guests
>       nVMX: Load IA32_PERF_GLOBAL_CTRL MSR on vmentry of nested guests
>       nVMX: Enable "load IA32_PERF_GLOBAL_CTRL VM-{entry,exit} controls
> 
>  x86/vmx_tests.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> Krish Sadhukhan (1):
>       nVMX: Test "load IA32_PERF_GLOBAL_CTRL" controls on vmentry of nested guests
> 
