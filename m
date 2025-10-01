Return-Path: <kvm+bounces-59301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3E23BB0C29
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 16:44:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D15C27A2EB4
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 14:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98EFA2686A0;
	Wed,  1 Oct 2025 14:44:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2E9A25A2AE;
	Wed,  1 Oct 2025 14:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759329865; cv=none; b=CtTc/KpZAfwG0Dt+uYcHD2k6bgUPQCgS73aL06xxGmV4U7dDnU1s/UBAR49wwNa6GlCwuLtYhGPBJFj30f+ql2PJdIvKAevkRcblFbUiyXYzy+YuCNhuY660wLNGe+Cg67VpYXdzkdboQDvAqrzO8dQHLK78PaKHc17GlxKdusU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759329865; c=relaxed/simple;
	bh=1Lcqc85C00iYU4HRastdvLjqrHRP5c0EmvdBfz/P9i8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lg8iOviUzEjWc7vS2TVd0LzyUrWUa7B+2YjDuUmtDAsi4vmSHAG6P0Jv+yhNAxpNk+cOGjQ5YdViK4wMjr35y82mcrPk8DoDjxJZr91DYDfssQJFSNXsWiZmURmr940xN32xyuj5bq8/hKrNVqiu1LiBCbMTb+pI/rYMK/GA/70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E54A16F2;
	Wed,  1 Oct 2025 07:44:13 -0700 (PDT)
Received: from [10.57.0.204] (unknown [10.57.0.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 20E6F3F66E;
	Wed,  1 Oct 2025 07:44:14 -0700 (PDT)
Message-ID: <47a7bc06-9d44-42f8-88df-f6db3bc997bc@arm.com>
Date: Wed, 1 Oct 2025 15:44:11 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/43] arm64: RME: Define the user ABI
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20250820145606.180644-1-steven.price@arm.com>
 <20250820145606.180644-7-steven.price@arm.com> <86jz1eztz4.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86jz1eztz4.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/10/2025 13:28, Marc Zyngier wrote:
> On Wed, 20 Aug 2025 15:55:26 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> There is one (multiplexed) CAP which can be used to create, populate and
>> then activate the realm.
>>
>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> ---
>> Changes since v9:
>>  * Improvements to documentation.
>>  * Bump the magic number for KVM_CAP_ARM_RME to avoid conflicts.
>> Changes since v8:
>>  * Minor improvements to documentation following review.
>>  * Bump the magic numbers to avoid conflicts.
>> Changes since v7:
>>  * Add documentation of new ioctls
>>  * Bump the magic numbers to avoid conflicts
>> Changes since v6:
>>  * Rename some of the symbols to make their usage clearer and avoid
>>    repetition.
>> Changes from v5:
>>  * Actually expose the new VCPU capability (KVM_ARM_VCPU_REC) by bumping
>>    KVM_VCPU_MAX_FEATURES - note this also exposes KVM_ARM_VCPU_HAS_EL2!
>> ---
>>  Documentation/virt/kvm/api.rst    | 71 +++++++++++++++++++++++++++++++
>>  arch/arm64/include/uapi/asm/kvm.h | 49 +++++++++++++++++++++
>>  include/uapi/linux/kvm.h          | 10 +++++
>>  3 files changed, 130 insertions(+)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 6aa40ee05a4a..69c0a9eba6c5 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -3549,6 +3549,11 @@ Possible features:
>>  	  Depends on KVM_CAP_ARM_EL2_E2H0.
>>  	  KVM_ARM_VCPU_HAS_EL2 must also be set.
>>  
>> +	- KVM_ARM_VCPU_REC: Allocate a REC (Realm Execution Context) for this
>> +	  VCPU. This must be specified on all VCPUs created in a Realm VM.
>> +	  Depends on KVM_CAP_ARM_RME.
>> +	  Requires KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_REC).
>> +
>>  4.83 KVM_ARM_PREFERRED_TARGET
>>  -----------------------------
>>  
>> @@ -5122,6 +5127,7 @@ Recognised values for feature:
>>  
>>    =====      ===========================================
>>    arm64      KVM_ARM_VCPU_SVE (requires KVM_CAP_ARM_SVE)
>> +  arm64      KVM_ARM_VCPU_REC (requires KVM_CAP_ARM_RME)
>>    =====      ===========================================
>>  
>>  Finalizes the configuration of the specified vcpu feature.
>> @@ -6476,6 +6482,30 @@ the capability to be present.
>>  
>>  `flags` must currently be zero.
>>  
>> +4.144 KVM_ARM_VCPU_RMM_PSCI_COMPLETE
>> +------------------------------------
>> +
>> +:Capability: KVM_CAP_ARM_RME
>> +:Architectures: arm64
>> +:Type: vcpu ioctl
>> +:Parameters: struct kvm_arm_rmm_psci_complete (in)
>> +:Returns: 0 if successful, < 0 on error
>> +
>> +::
>> +
>> +  struct kvm_arm_rmm_psci_complete {
>> +	__u64 target_mpidr;
>> +	__u32 psci_status;
>> +	__u32 padding[3];
>> +  };
>> +
>> +Where PSCI functions are handled by user space, the RMM needs to be informed of
>> +the target of the operation using `target_mpidr`, along with the status
>> +(`psci_status`). The RMM v1.0 specification defines two functions that require
>> +this call: PSCI_CPU_ON and PSCI_AFFINITY_INFO.
>> +
>> +If the kernel is handling PSCI then this is done automatically and the VMM
>> +doesn't need to call this ioctl.
> 
> Why should userspace involved in this? Why can't this be a
> notification that the host delivers to the RMM when the vcpu is about
> to run?

This is only when PSCI is being handled by user space. If the kernel
(i.e KVM) is handling PSCI then indeed there's no user space involvement.

I'm not sure how we could avoid this when PSCI is being implemented in
user space. Or am I missing something?

>>  
>>  .. _kvm_run:
>>  
>> @@ -8662,6 +8692,47 @@ This capability indicate to the userspace whether a PFNMAP memory region
>>  can be safely mapped as cacheable. This relies on the presence of
>>  force write back (FWB) feature support on the hardware.
>>  
>> +7.44 KVM_CAP_ARM_RME
>> +--------------------
>> +
>> +:Architectures: arm64
>> +:Target: VM
>> +:Parameters: args[0] provides an action, args[1] points to a structure in
>> +             memory for the action.
>> +:Returns: 0 on success, negative value on error
>> +
>> +Used to configure and set up the memory for a Realm. The available actions are:
>> +
>> +================================= =============================================
>> + KVM_CAP_ARM_RME_CONFIG_REALM     Takes struct arm_rme_config as args[1] and
>> +                                  configures realm parameters prior to it being
>> +                                  created.
>> +
>> +                                  Options are ARM_RME_CONFIG_RPV to set the
>> +                                  "Realm Personalization Value" and
>> +                                  ARM_RME_CONFIG_HASH_ALGO to set the hash
>> +                                  algorithm.
>> +
>> + KVM_CAP_ARM_RME_CREATE_REALM     Request the RMM to create the realm. The
>> +                                  realm's configuration parameters must be set
>> +                                  first.
>> +
>> + KVM_CAP_ARM_RME_INIT_RIPAS_REALM Takes struct arm_rme_init_ripas as args[1]
>> +                                  and sets the RIPAS (Realm IPA State) to
>> +                                  RIPAS_RAM of a specified area of the realm's
>> +                                  IPA.
>> +
>> + KVM_CAP_ARM_RME_POPULATE_REALM   Takes struct arm_rme_populate_realm as
>> +                                  args[1] and populates a region of protected
>> +                                  address space by copying the data from the
>> +                                  shared alias.
>> +
>> + KVM_CAP_ARM_RME_ACTIVATE_REALM   Request the RMM to activate the realm. No
>> +                                  changes can be made to the Realm's populated
>> +                                  memory, IPA state, configuration parameters
>> +                                  or vCPU additions after this step.
>> +================================= =============================================
>> +
> 
> These are not capabilities, they are actions that the VMM may perform
> on a VM. You don't configure a VM using capabilities. You use it to
> buy into some behaviours, but that's all.
> 
> And then there is the semantic of this stuff. Why do I need something
> like KVM_CAP_ARM_RME_CREATE_REALM when I can just pass this as part of
> the VM type? Why do I need a new way to describe memory region when we
> already have memslots for that exact purpose?
> 
> Overall, you are leaking the RMM interface into userspace, and that's
> an absolute show-stopper. We have an API, it is not pretty, but it
> exists. We don't need another one that will be just as broken. If the
> RMM needs some impedance matching, that's the kernel's job.

So I'll admit the (ab)use of capabilities to set up the realm is a bit
of a hack. I initially did it this way to maintain some compatibility
with a prototype implementation, but it's taken until v10 for anyone to
express displeasure with the approach! It would of course be possible to
implement these are separate ioctls.

However, it seems we need to pin down the semantics before I do that
refactoring.

KVM_CAP_ARM_RME_CREATE_REALM
============================

The desire is that you can configure the aspects of the realm piecemeal
and then later trigger the SMC to the RMM. This avoids the need for a
big structure (which will grow with new features) containing all the
configuration. It also allows KVM_CAP_ARM_RME_CONFIG_REALM to validate
each configuration and provide immediate failure when a configuration
option is invalid.

Would you prefer ditching KVM_CAP_ARM_RME_CONFIG_REALM and passing a
structure of all the configuration options to
KVM_CAP_ARM_RME_CREATE_REALM? It would make identifying what part of an
invalid configuration is problematic harder. And we'd probably therefore
need to add a new discovery mechanism to find e.g. which hash algorithms
are supported.

KVM_CAP_ARM_RME_INIT_RIPAS_REALM
================================

This is a property that doesn't exist for a normal guest and as such the
VMM is going to have to do something extra to describe which areas of
RAM are protected and which are shared. I guess with the recent
guest_memfd changes it might be possible to pull that from the
guest_memfd instance(s). But note that it's entirely valid (from the CCA
perspective) to have both protected and shared regions that are not
backed at guest start. So setting the RIPAS to RAM (i.e. making an area
of memory protected) is independent of the guest_memfd backing status.

KVM_CAP_ARM_RME_POPULATE_REALM
==============================

This ties in with the above. This is effectively doing a data-preserving
conversion of shared to protected. We need some form of this to set the
initial data for the guest (boot loader/kernel image etc).

In this patch set this API is a little broken as it requires double
backing (both a valid VMA in the VMM and allocation in the guest_memfd).
My expectation was to replace this with a version that simply does an
in-place data-preserving conversion in guest_memfd. The only drawback is
that this requires a double memcpy() - KVM would need to copy the data
to a temporary buffer, and then the RMM would copy it back (after
dealing with memory encryption setup).

The alternative would be to provide a separate input buffer for
POPULATE_REALM. That could e.g. be a mmap()ed file, but that moves CCA
further away from a standard interface.

KVM_CAP_ARM_RME_ACTIVATE_REALM
==============================

This is easiest to drop - we could just do this step when the VMM first
tries to start a VCPU. The main benefits are:

 * It makes error reporting more obvious (you can tell the difference
between the RMM failing the activate and something else preventing a
VCPU entry).

 * It makes the KVM code slightly clearer because the state transition
is triggered by an obvious action from the VMM, and there's less
potential for races.


I agree it's a shame that the VMM can't just use the standard KVM
interface for realm guest setup. But there are some fundamental
differences between a normal guest and a realm guest. So the VMM will
need to be enlightened. Feel free to comment on the above if you have
suggestions on how the above API can be improved.

Thanks,
Steve


