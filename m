Return-Path: <kvm+bounces-72406-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2Mm1OULHpWnEFgAAu9opvQ
	(envelope-from <kvm+bounces-72406-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 18:22:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 04F061DDBB2
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 18:22:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AAF32305D531
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 17:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A88342B740;
	Mon,  2 Mar 2026 17:13:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AB7D305057;
	Mon,  2 Mar 2026 17:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772471629; cv=none; b=DyNmkbOSqQKuASAeNoT14pCeBjtnhZf8VDd5BafgZErR9OhaM32f/z1HbvckV+7nDrVQPARl6YLSWbmy++tWN6noJ6TYN4ul0f9qEU8xug939HjVpesIZzmvji9M/B7FaOgcaga05w2hk7SswpB7A4R58Nbo1AFghkVBNIEIagw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772471629; c=relaxed/simple;
	bh=LVqvSRjP7ZSJ1Lm3BhqTGs047xn5H2PMA0XEi+nJoAI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aiR7XQqkQgKD/moDbczh43Z6hcvjXUHG/8r/xTBmX4wjOAUEF4DPILgWMB+yGFp4msUQxFTrSR78h+pmaFR8OVwR4Uj3h+gkXad0WcciKukx9GLlT2XyTe2M+QfcewuR6dB42Kf1rGlX9I62Cy7GR5a4pqdaQpbb95CHXSKDsjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F4BC14BF;
	Mon,  2 Mar 2026 09:13:41 -0800 (PST)
Received: from [10.57.73.151] (unknown [10.57.73.151])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D56E03F73B;
	Mon,  2 Mar 2026 09:13:43 -0800 (PST)
Message-ID: <9d702666-72a8-43e4-8ab3-548d8154a529@arm.com>
Date: Mon, 2 Mar 2026 17:13:41 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 06/46] arm64: RMI: Define the user ABI
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20251217101125.91098-1-steven.price@arm.com>
 <20251217101125.91098-7-steven.price@arm.com> <86tsuy8g0u.wl-maz@kernel.org>
 <33053e22-6cc6-4d55-bc7f-01f873a15d28@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <33053e22-6cc6-4d55-bc7f-01f873a15d28@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 04F061DDBB2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72406-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[suzuki.poulose@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-0.908];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:email,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 02/03/2026 15:23, Steven Price wrote:
> Hi Marc,
> 
> On 02/03/2026 14:25, Marc Zyngier wrote:
>> On Wed, 17 Dec 2025 10:10:43 +0000,
>> Steven Price <steven.price@arm.com> wrote:
>>>
>>> There is one CAP which identified the presence of CCA, and two ioctls.
>>> One ioctl is used to populate memory and the other is used when user
>>> space is providing the PSCI implementation to identify the target of the
>>> operation.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> Changes since v11:
>>>   * Completely reworked to be more implicit. Rather than having explicit
>>>     CAP operations to progress the realm construction these operations
>>>     are done when needed (on populating and on first vCPU run).
>>>   * Populate and PSCI complete are promoted to proper ioctls.
>>> Changes since v10:
>>>   * Rename symbols from RME to RMI.
>>> Changes since v9:
>>>   * Improvements to documentation.
>>>   * Bump the magic number for KVM_CAP_ARM_RME to avoid conflicts.
>>> Changes since v8:
>>>   * Minor improvements to documentation following review.
>>>   * Bump the magic numbers to avoid conflicts.
>>> Changes since v7:
>>>   * Add documentation of new ioctls
>>>   * Bump the magic numbers to avoid conflicts
>>> Changes since v6:
>>>   * Rename some of the symbols to make their usage clearer and avoid
>>>     repetition.
>>> Changes from v5:
>>>   * Actually expose the new VCPU capability (KVM_ARM_VCPU_REC) by bumping
>>>     KVM_VCPU_MAX_FEATURES - note this also exposes KVM_ARM_VCPU_HAS_EL2!
>>> ---
>>>   Documentation/virt/kvm/api.rst | 57 ++++++++++++++++++++++++++++++++++
>>>   include/uapi/linux/kvm.h       | 23 ++++++++++++++
>>>   2 files changed, 80 insertions(+)
>>>
>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>>> index 01a3abef8abb..2d5dc7e48954 100644
>>> --- a/Documentation/virt/kvm/api.rst
>>> +++ b/Documentation/virt/kvm/api.rst
>>> @@ -6517,6 +6517,54 @@ the capability to be present.
>>>   
>>>   `flags` must currently be zero.
>>>   
>>> +4.144 KVM_ARM_VCPU_RMI_PSCI_COMPLETE
>>> +------------------------------------
>>> +
>>> +:Capability: KVM_CAP_ARM_RMI
>>> +:Architectures: arm64
>>> +:Type: vcpu ioctl
>>> +:Parameters: struct kvm_arm_rmi_psci_complete (in)
>>> +:Returns: 0 if successful, < 0 on error
>>> +
>>> +::
>>> +
>>> +  struct kvm_arm_rmi_psci_complete {
>>> +	__u64 target_mpidr;
>>> +	__u32 psci_status;
>>> +	__u32 padding[3];
>>> +  };
>>> +
>>> +Where PSCI functions are handled by user space, the RMM needs to be informed of
>>> +the target of the operation using `target_mpidr`, along with the status
>>> +(`psci_status`). The RMM v1.0 specification defines two functions that require
>>> +this call: PSCI_CPU_ON and PSCI_AFFINITY_INFO.
>>> +
>>> +If the kernel is handling PSCI then this is done automatically and the VMM
>>> +doesn't need to call this ioctl.
>>
>> Shouldn't we make handling of PSCI mandatory for VMMs that deal with
>> CCA? I suspect it would simplify the implementation significantly.
> 
> What do you mean by making it "mandatory for VMMs"? If you mean PSCI is
> always forwarded to user space then I don't think it's going to make
> much difference. Patch 27 handles the PSCI changes (72 lines added), and
> some of that is adding this uAPI for the VMM to handle it.
> 
> Removing the functionality to allow the VMM to handle it would obviously
> simplify things a bit (we can drop this uAPI), but I think the desire is
> to push this onto user space.
> 
>> What vcpu fd does this apply to? The vcpu calling the PSCI function?
>> Or the target? This is pretty important for PSCI_ON. My guess is that
>> this is setting the return value for the caller?
> 
> Yes the fd is the vcpu calling PSCI. As you say, this is for the return
> value to be set correctly.
> 
>> Assuming this is indeed for the caller, why do we have a different
>> flow from anything else that returns a result from a hypercall?
> 
> I'm not entirely sure what you are suggesting. Do you mean why are we
> not just writing to the GPRS that would contain the result? The issue
> here is that the RMM needs to know the PA of the target REC structure -
> this isn't a return to the guest, but information for the RMM itself to
> complete the PSCI call.
> 
> Ultimately even in the case where the VMM is handling PSCI, it's
> actually a combination of the VMM and the RMM - with the RMM validating
> the responses.
> 

More importantly, we have to make sure that the "RMI_PSCI_COMPLETE" is
invoked before both of the following:
   1. The "source" vCPU is run again
   2. More importantly the "target" vCPU is run.

The latter part makes it difficult to issue this RMI_PSCI_COMPLETE on
the way back from servicing the SMCCC call.

Suzuki


>>> +
>>> +4.145 KVM_ARM_RMI_POPULATE
>>> +--------------------------
>>> +
>>> +:Capability: KVM_CAP_ARM_RMI
>>> +:Architectures: arm64
>>> +:Type: vm ioctl
>>> +:Parameters: struct kvm_arm_rmi_populate (in)
>>> +:Returns: number of bytes populated, < 0 on error
>>> +
>>> +::
>>> +
>>> +  struct kvm_arm_rmi_populate {
>>> +	__u64 base;
>>> +	__u64 size;
>>> +	__u64 source_uaddr;
>>> +	__u32 flags;
>>> +	__u32 reserved;
>>> +  };
>>> +
>>> +Populate a region of protected address space by copying the data from the user
>>> +space pointer provided. This is only valid before any VCPUs have been run.
>>> +The ioctl might not populate the entire region and user space may have to
>>> +repeatedly call it (with updated pointers) to populate the entire region.
>>
>> size as a __u64 is odd, as the return value from the ioctl is a signed
>> int. This implies that you can't really report how many bytes you have
>> copied.  Some form of consistency wouldn't hurt.
> 
> Good spot. In practice this works because >2GB in one operation is
> highly unlikely to be processed in one go. But I guess I'll change this
> to have an output size argument. I guess I could make the kernel update
> all of base,size,source_uaddr which would simplify user space.
> 
> Thanks,
> Steve
> 


