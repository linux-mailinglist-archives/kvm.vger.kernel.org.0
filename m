Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFD5507F93
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 05:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359249AbiDTDZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 23:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359239AbiDTDZp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 23:25:45 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3932421E2C;
        Tue, 19 Apr 2022 20:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650424981; x=1681960981;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1AiC9VeveMPhro24gHqzjyeU34rUd2EVyr+r3itMve4=;
  b=iUfOVHrmqmBRjJ3bzkShScz8IUtZ5GaGCaxA7HbL6XPn9bfkhfvYSMvp
   UMozJuBSCJ3MxYW+xpcvTI48R1ahJvCLOMTYSmF1KN6VwNUwiQVjJCm08
   k4gx6wE+AoCcTfj/l1IT0sVmtnQ7t0mJSbY5nKg5oSuMJyZFPevHL0pNF
   8EbazH8M3gSoLoOPMy4E5QyytLJF9Ti+tUq1n/jaZWxVq+7QHrb8RLrs8
   qdUBdP9f5KTERxd0v4tRNBLtRKz4/gu1tHmwF+HBP3QB1V0FMwV07YTgx
   yvKJpLwnn7Fv4eVu3dfqrYyFcmhQuSJDze+xzi2gdlf2zfqmHmrZNGi+6
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="251234129"
X-IronPort-AV: E=Sophos;i="5.90,274,1643702400"; 
   d="scan'208";a="251234129"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 20:23:00 -0700
X-IronPort-AV: E=Sophos;i="5.90,274,1643702400"; 
   d="scan'208";a="727317671"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 20:22:55 -0700
Date:   Wed, 20 Apr 2022 11:22:51 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>
Subject: Re: [PATCH v9 8/9] KVM: x86: Allow userspace set maximum VCPU id for
 VM
Message-ID: <20220420032245.GA14083@gao-cwp>
References: <20220419154444.11888-1-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419154444.11888-1-guang.zeng@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 19, 2022 at 11:44:44PM +0800, Zeng Guang wrote:
>Introduce new max_vcpu_ids in KVM for x86 architecture. Userspace
>can assign maximum possible vcpu id for current VM session using
>KVM_CAP_MAX_VCPU_ID of KVM_ENABLE_CAP ioctl().
>
>This is done for x86 only because the sole use case is to guide
>memory allocation for PID-pointer table, a structure needed to
>enable VMX IPI.
>
>By default, max_vcpu_ids set as KVM_MAX_VCPU_IDS.
>
>Suggested-by: Sean Christopherson <seanjc@google.com>
>Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>---
> Documentation/virt/kvm/api.rst  | 18 ++++++++++++++++++
> arch/x86/include/asm/kvm_host.h |  6 ++++++
> arch/x86/kvm/x86.c              | 25 ++++++++++++++++++++++++-
> 3 files changed, 48 insertions(+), 1 deletion(-)
>
>diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>index d13fa6600467..0c6ad2d8bea0 100644
>--- a/Documentation/virt/kvm/api.rst
>+++ b/Documentation/virt/kvm/api.rst
>@@ -7136,6 +7136,24 @@ The valid bits in cap.args[0] are:
>                                     IA32_MISC_ENABLE[bit 18] is cleared.
> =================================== ============================================
> 
>+7.32 KVM_CAP_MAX_VCPU_ID
>+------------------------
>+
>+:Architectures: x86
>+:Target: VM
>+:Parameters: args[0] - maximum APIC ID value set for current VM
>+:Returns: 0 on success, -EINVAL if args[0] is beyond KVM_MAX_VCPU_IDS
>+          supported in KVM or if it has been settled.
>+
>+Userspace is able to calculate the limit to APIC ID values from designated CPU
>+topology. This capability allows userspace to specify maximum possible APIC ID
>+assigned for current VM session prior to the creation of vCPUs. By design, it
>+can set only once and doesn't accept change any more. KVM will manage memory
>+allocation of VM-scope structures which depends on the value of APIC ID.
>+
>+Calling KVM_CHECK_EXTENSION for this capability returns the value of maximum APIC
>+ID that KVM supports at runtime. It sets as KVM_MAX_VCPU_IDS by default.
>+
> 8. Other capabilities.
> ======================
> 
>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>index d23e80a56eb8..cdd14033988d 100644
>--- a/arch/x86/include/asm/kvm_host.h
>+++ b/arch/x86/include/asm/kvm_host.h
>@@ -1238,6 +1238,12 @@ struct kvm_arch {
> 	hpa_t	hv_root_tdp;
> 	spinlock_t hv_root_tdp_lock;
> #endif
>+	/*
>+	 * VM-scope maximum vCPU ID. Used to determine the size of structures
>+	 * that increase along with the maximum vCPU ID, in which case, using
>+	 * the global KVM_MAX_VCPU_IDS may lead to significant memory waste.
>+	 */
>+	u32 max_vcpu_ids;
> };
> 
> struct kvm_vm_stat {
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 277a0da8c290..744e88a71b63 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -4320,7 +4320,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> 		r = KVM_MAX_VCPUS;
> 		break;
> 	case KVM_CAP_MAX_VCPU_ID:
>-		r = KVM_MAX_VCPU_IDS;
>+		if (!kvm->arch.max_vcpu_ids)
>+			r = KVM_MAX_VCPU_IDS;
>+		else
>+			r = kvm->arch.max_vcpu_ids;
> 		break;
> 	case KVM_CAP_PV_MMU:	/* obsolete */
> 		r = 0;
>@@ -6064,6 +6067,20 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> 		}
> 		mutex_unlock(&kvm->lock);
> 		break;
>+	case KVM_CAP_MAX_VCPU_ID:
>+		r = -EINVAL;
>+		if (cap->args[0] > KVM_MAX_VCPU_IDS)
>+			break;
>+
>+		mutex_lock(&kvm->lock);
>+		if (kvm->arch.max_vcpu_ids == cap->args[0]) {
>+			r = 0;
>+		} else if (!kvm->arch.max_vcpu_ids) {
>+			kvm->arch.max_vcpu_ids = cap->args[0];
>+			r = 0;
>+		}
>+		mutex_unlock(&kvm->lock);
>+		break;

It would be better to have a kselftest to exercise this capability.
For example,
1. launch a VM.
2. set the max vCPU ID via KVM_CAP_MAX_VCPU_ID
3. read the max vCPU ID to check if the value written is returned.
4. create a vCPU which has apic id larger than the maximum.
5. try to change the max vCPU ID after set once.
...

This test can be the last patch of this series or posted separately.
