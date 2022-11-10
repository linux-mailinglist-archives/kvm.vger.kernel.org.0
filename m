Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD7E623CAF
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 08:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbiKJHcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 02:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbiKJHbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 02:31:55 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783EF32B82;
        Wed,  9 Nov 2022 23:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668065513; x=1699601513;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K4DExVACpt2lARFBBsyLRbh7EHo+YwPLCynabZeKIUc=;
  b=SR6T61f5Ot3dK2IU86mrDqzqV6tF4R6lOlNUT7aGnKENyhzAvENoDFKP
   zkPqsK/DBY01EaiBq41Y2BSxrMYv4lu+l8KZ7Nh37UfJP9wVRPpsVagkV
   N1gCmsGZUhq1W/lFX7AOiJXfP/+kC6+zA+1BpOQQkHzSgC+QYLfHbLsdp
   f8EhkmDrKIXpZ/ljJdCMcHr5gkZ3KOj22SLkMtyUgrMl9OI59+JS6rJou
   SpSG0MlMDGtUT04jdMgjQCBj8m/JvcOepdQnf0mIKY7zw+IPehiXGjRx7
   8WjZNvRJzpccv8GgWa/HgLNcI0yr2Je5HnQBvigr4Cp7hh5kWTROk9OJA
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="309952072"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="309952072"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 23:31:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="631556568"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="631556568"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga007.jf.intel.com with ESMTP; 09 Nov 2022 23:31:43 -0800
Message-ID: <ff0e8701d02ee161d064f92c8b742c2cc061bce0.camel@linux.intel.com>
Subject: Re: [PATCH 32/44] KVM: x86: Unify pr_fmt to use module name for all
 KVM modules
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Date:   Thu, 10 Nov 2022 15:31:42 +0800
In-Reply-To: <20221102231911.3107438-33-seanjc@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
         <20221102231911.3107438-33-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-11-02 at 23:18 +0000, Sean Christopherson wrote:
> Define pr_fmt using KBUILD_MODNAME for all KVM x86 code so that
> printks
> use consistent formatting across common x86, Intel, and AMD code.  In
> addition to providing consistent print formatting, using
> KBUILD_MODNAME,
> e.g. kvm_amd and kvm_intel, allows referencing SVM and VMX (and SEV
> and
> SGX and ...) as technologies without generating weird messages, and
> without causing naming conflicts with other kernel code, e.g. "SEV:
> ",
> "tdx: ", "sgx: " etc.. are all used by the kernel for non-KVM
> subsystems.
> 
> Opportunistically move away from printk() for prints that need to be
> modified anyways, e.g. to drop a manual "kvm: " prefix.
> 
> Opportunistically convert a few SGX WARNs that are similarly modified
> to
> WARN_ONCE; in the very unlikely event that the WARNs fire, odds are
> good
> that they would fire repeatedly and spam the kernel log without
> providing
> unique information in each print.
> 
> Note, defining pr_fmt yields undesirable results for code that uses
> KVM's
> printk wrappers, e.g. vcpu_unimpl().  But, that's a pre-existing
> problem
> as SVM/kvm_amd already defines a pr_fmt, and thankfully use of KVM's
> wrappers is relatively limited in KVM x86 code.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c            |  1 +
>  arch/x86/kvm/debugfs.c          |  2 ++
>  arch/x86/kvm/emulate.c          |  1 +
>  arch/x86/kvm/hyperv.c           |  1 +
>  arch/x86/kvm/i8254.c            |  4 ++--
>  arch/x86/kvm/i8259.c            |  4 +++-
>  arch/x86/kvm/ioapic.c           |  1 +
>  arch/x86/kvm/irq.c              |  1 +
>  arch/x86/kvm/irq_comm.c         |  7 +++---
>  arch/x86/kvm/kvm_onhyperv.c     |  1 +
>  arch/x86/kvm/lapic.c            |  8 +++----
>  arch/x86/kvm/mmu/mmu.c          |  6 ++---
>  arch/x86/kvm/mmu/page_track.c   |  1 +
>  arch/x86/kvm/mmu/spte.c         |  4 ++--
>  arch/x86/kvm/mmu/spte.h         |  4 ++--
>  arch/x86/kvm/mmu/tdp_iter.c     |  1 +
>  arch/x86/kvm/mmu/tdp_mmu.c      |  1 +
>  arch/x86/kvm/mtrr.c             |  1 +
>  arch/x86/kvm/pmu.c              |  1 +
>  arch/x86/kvm/smm.c              |  1 +
>  arch/x86/kvm/svm/avic.c         |  2 +-
>  arch/x86/kvm/svm/nested.c       |  2 +-
>  arch/x86/kvm/svm/pmu.c          |  2 ++
>  arch/x86/kvm/svm/sev.c          |  1 +
>  arch/x86/kvm/svm/svm.c          | 10 ++++-----
>  arch/x86/kvm/svm/svm_onhyperv.c |  1 +
>  arch/x86/kvm/svm/svm_onhyperv.h |  4 ++--
>  arch/x86/kvm/vmx/evmcs.c        |  1 +
>  arch/x86/kvm/vmx/evmcs.h        |  4 +---
>  arch/x86/kvm/vmx/nested.c       |  3 ++-
>  arch/x86/kvm/vmx/pmu_intel.c    |  5 +++--
>  arch/x86/kvm/vmx/posted_intr.c  |  2 ++
>  arch/x86/kvm/vmx/sgx.c          |  5 +++--
>  arch/x86/kvm/vmx/vmcs12.c       |  1 +
>  arch/x86/kvm/vmx/vmx.c          | 40 ++++++++++++++++---------------
> --
>  arch/x86/kvm/vmx/vmx_ops.h      |  4 ++--
>  arch/x86/kvm/x86.c              | 28 ++++++++++++-----------
>  arch/x86/kvm/xen.c              |  1 +
>  38 files changed, 97 insertions(+), 70 deletions(-)
> 
After this patch set, still find some printk()s left in arch/x86/kvm/*,
consider clean all of them up?

arch/x86/kvm/lapic.c:1215:		printk(KERN_ERR "TODO:
unsupported delivery mode %x\n",
arch/x86/kvm/lapic.c:1506:		printk(KERN_ERR "Local APIC
read with len = %x, "
arch/x86/kvm/lapic.c:2586:		printk(KERN_ERR "malloc apic
regs error for vcpu %x\n",
arch/x86/kvm/ioapic.h:95:		printk(KERN_EMERG "assertion
failed %s: %d: %s\n",	\
arch/x86/kvm/ioapic.c:614:		printk(KERN_WARNING "ioapic:
wrong length %d\n", len);
arch/x86/kvm/ioapic.c:641:		printk(KERN_WARNING "ioapic:
Unsupported size %d\n", len);
arch/x86/kvm/mmu/mmu.c:1652:			printk(KERN_ERR "%s: %p
%llx\n", __func__,
arch/x86/kvm/svm/svm.c:3450:		printk(KERN_ERR "%s: unexpected
exit_int_info 0x%x "
arch/x86/kvm/vmx/posted_intr.c:322:				printk(
KERN_INFO
arch/x86/kvm/vmx/posted_intr.c:343:			printk(KERN_INF
O "%s: failed to update PI IRTE\n",
arch/x86/kvm/vmx/vmx.c:6507:			printk(KERN_WARNING
"%s: Breaking out of NMI-blocked "
arch/x86/kvm/x86.c:13027:		printk(KERN_INFO "irq bypass
consumer (token %p) unregistration"

