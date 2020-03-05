Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B8D17AB3E
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 18:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgCERMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 12:12:05 -0500
Received: from mga05.intel.com ([192.55.52.43]:19713 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgCERME (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 12:12:04 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 09:12:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,518,1574150400"; 
   d="scan'208";a="264040974"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 05 Mar 2020 09:12:04 -0800
Date:   Thu, 5 Mar 2020 09:12:04 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pu Wen <puwen@hygon.cn>
Subject: Re: [PATCH v2 0/7] KVM: x86: CPUID emulation and tracing fixes
Message-ID: <20200305171204.GI11500@linux.intel.com>
References: <20200305013437.8578-1-sean.j.christopherson@intel.com>
 <6071310f-dd4b-6a6d-5578-7b6f72a9b1be@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6071310f-dd4b-6a6d-5578-7b6f72a9b1be@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 05, 2020 at 05:42:59PM +0100, Paolo Bonzini wrote:
> On 05/03/20 02:34, Sean Christopherson wrote:
> > 
> > In theory, everything up to the refactoring is non-controversial, i.e. we
> > can bikeshed the refactoring without delaying the bug fixes.
> 
> Even the refactoring itself is much less controversial.  I queued
> everything, there's always time to unqueue.

Looks like the build-time assertions don't play nice with older versions of
gcc :-(

config: x86_64-randconfig-s2-20200305 (attached as .config)
compiler: gcc-4.9 (Debian 4.9.2-10+deb8u1) 4.9.2
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   In file included from include/linux/export.h:43:0,
                    from include/linux/linkage.h:7,
                    from include/linux/preempt.h:10,
                    from include/linux/hardirq.h:5,
                    from include/linux/kvm_host.h:7,
                    from arch/x86/kvm/emulate.c:21:
   arch/x86/kvm/emulate.c: In function 'em_cpuid':
>> include/linux/compiler.h:350:38: error: call to '__compiletime_assert_3957' declared with attribute error: BUILD_BUG_ON failed: X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx != *(u32 *)"Auth" || X86EMUL_CPUID_VENDOR_AuthenticAMD_edx != *(u32 *)"enti" || X86EMUL_CPUID_VENDOR_AuthenticAMD_ecx != *(u32 *)"cAMD"
     _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)

