Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642583923E4
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 02:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbhE0AvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 20:51:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:32733 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232229AbhE0AvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 20:51:09 -0400
IronPort-SDR: iP/2AfnEmJXFj0bLt30Sb8JAGVX8s1b51+DJftFF1ERTEC+p2bM4J6MdLpzEwn94XmD5qA0Dyh
 Q7SgYRUyTnOg==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="263823024"
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="263823024"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 17:49:12 -0700
IronPort-SDR: catWLoIPb5eWn29l+PLW8YiXoXjGwVc9Nj+GWek6I+RT58XPlURLdg/Vyfl6EZA0AJHCs5fhn8
 9zKB4A3tWpxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="472249464"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.22])
  by FMSMGA003.fm.intel.com with ESMTP; 26 May 2021 17:49:09 -0700
Date:   Thu, 27 May 2021 08:49:08 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH] KVM: X86: Use kvm_get_linear_rip() in single-step and
 #DB/#BP interception
Message-ID: <20210527004908.4pyrz3kxy74hh7sy@yy-desk-7060>
References: <20210526063828.1173-1-yuan.yao@linux.intel.com>
 <YK5gsUVi2AJkt0uu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YK5gsUVi2AJkt0uu@google.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021 at 02:52:33PM +0000, Sean Christopherson wrote:
> On Wed, May 26, 2021, Yuan Yao wrote:
> > From: Yuan Yao <yuan.yao@intel.com>
> > 
> > The kvm_get_linear_rip() handles x86/long mode cases well and has
> > better readability, __kvm_set_rflags() also use the paired
> > fucntion kvm_is_linear_rip() to check the vcpu->arch.singlestep_rip
>   ^^^^^^^^
>   function
> 
> Please run checkpatch before submitting in the future, it will catch some of
> these misspellings.

Sorry for this mistake, I will take care next time.

> 
> > set in kvm_arch_vcpu_ioctl_set_guest_debug(), so change the
> > "CS.BASE + RIP" code in kvm_arch_vcpu_ioctl_set_guest_debug() and
> > handle_exception_nmi() to this one.
> > 
> > Signed-off-by: Yuan Yao <yuan.yao@intel.com>
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
