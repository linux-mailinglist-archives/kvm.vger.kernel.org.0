Return-Path: <kvm+bounces-72678-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yP2FO9QgqGlQoQAAu9opvQ
	(envelope-from <kvm+bounces-72678-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 13:08:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A8CE71FF7F3
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 13:08:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 954FB301A7D4
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 12:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC7C3A4536;
	Wed,  4 Mar 2026 12:08:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0166E3451AE;
	Wed,  4 Mar 2026 12:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772626119; cv=none; b=ugXQVJgcZyf+TNam3RC4DwBD3zAzKZOPt1agznY3TgB78UcXiCVY8pLx4FJyzszuAh8UPn5091iVjIXa1HqP0J90vZlHc2QzZiy6Bos3fZEkIHRvJ2EWHvh/PhGviWPnCtzggWztwpw7xJZ5IckVoGfj3qPNfWMOJDh6dpKQLOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772626119; c=relaxed/simple;
	bh=p8/jmC0wH90dMSW4LEuylFzVA8sOV4ndHvTedy3JGag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bnjD2XEeDi4ltcTlVWdRm2MuJYxbELOB9jhgq6JsSlIFGS5Pt1iiNZa5eqAO5eGDCWDPesCfU+cb1x2TPc5CwNNHOQcb5jB4HR3LQijRXwJqZSeS6sgl1oLnnqWVC0obUWDkdNulr/hmHSsWX/yQzu+RCpN+C2hmYLJMwR7NYLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C588D339;
	Wed,  4 Mar 2026 04:08:30 -0800 (PST)
Received: from [10.57.56.227] (unknown [10.57.56.227])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A4E73F836;
	Wed,  4 Mar 2026 04:08:32 -0800 (PST)
Message-ID: <25a22155-50d1-4a85-8ccd-755fee803066@arm.com>
Date: Wed, 4 Mar 2026 12:08:30 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 06/46] arm64: RMI: Define the user ABI
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
References: <20251217101125.91098-1-steven.price@arm.com>
 <20251217101125.91098-7-steven.price@arm.com> <86tsuy8g0u.wl-maz@kernel.org>
 <33053e22-6cc6-4d55-bc7f-01f873a15d28@arm.com> <86h5qx83df.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86h5qx83df.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A8CE71FF7F3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72678-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[steven.price@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-0.989];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 03/03/2026 13:11, Marc Zyngier wrote:
> On Mon, 02 Mar 2026 15:23:44 +0000,
> Steven Price <steven.price@arm.com> wrote:
>>
>> Hi Marc,
>>
>> On 02/03/2026 14:25, Marc Zyngier wrote:
>>> On Wed, 17 Dec 2025 10:10:43 +0000,
>>> Steven Price <steven.price@arm.com> wrote:
>>>>
>>>> There is one CAP which identified the presence of CCA, and two ioctls.
>>>> One ioctl is used to populate memory and the other is used when user
>>>> space is providing the PSCI implementation to identify the target of the
>>>> operation.
>>>>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>> ---
>>>> Changes since v11:
>>>>  * Completely reworked to be more implicit. Rather than having explicit
>>>>    CAP operations to progress the realm construction these operations
>>>>    are done when needed (on populating and on first vCPU run).
>>>>  * Populate and PSCI complete are promoted to proper ioctls.
>>>> Changes since v10:
>>>>  * Rename symbols from RME to RMI.
>>>> Changes since v9:
>>>>  * Improvements to documentation.
>>>>  * Bump the magic number for KVM_CAP_ARM_RME to avoid conflicts.
>>>> Changes since v8:
>>>>  * Minor improvements to documentation following review.
>>>>  * Bump the magic numbers to avoid conflicts.
>>>> Changes since v7:
>>>>  * Add documentation of new ioctls
>>>>  * Bump the magic numbers to avoid conflicts
>>>> Changes since v6:
>>>>  * Rename some of the symbols to make their usage clearer and avoid
>>>>    repetition.
>>>> Changes from v5:
>>>>  * Actually expose the new VCPU capability (KVM_ARM_VCPU_REC) by bumping
>>>>    KVM_VCPU_MAX_FEATURES - note this also exposes KVM_ARM_VCPU_HAS_EL2!
>>>> ---
>>>>  Documentation/virt/kvm/api.rst | 57 ++++++++++++++++++++++++++++++++++
>>>>  include/uapi/linux/kvm.h       | 23 ++++++++++++++
>>>>  2 files changed, 80 insertions(+)
>>>>
>>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>>>> index 01a3abef8abb..2d5dc7e48954 100644
>>>> --- a/Documentation/virt/kvm/api.rst
>>>> +++ b/Documentation/virt/kvm/api.rst
>>>> @@ -6517,6 +6517,54 @@ the capability to be present.
>>>>  
>>>>  `flags` must currently be zero.
>>>>  
>>>> +4.144 KVM_ARM_VCPU_RMI_PSCI_COMPLETE
>>>> +------------------------------------
>>>> +
>>>> +:Capability: KVM_CAP_ARM_RMI
>>>> +:Architectures: arm64
>>>> +:Type: vcpu ioctl
>>>> +:Parameters: struct kvm_arm_rmi_psci_complete (in)
>>>> +:Returns: 0 if successful, < 0 on error
>>>> +
>>>> +::
>>>> +
>>>> +  struct kvm_arm_rmi_psci_complete {
>>>> +	__u64 target_mpidr;
>>>> +	__u32 psci_status;
>>>> +	__u32 padding[3];
>>>> +  };
>>>> +
>>>> +Where PSCI functions are handled by user space, the RMM needs to be informed of
>>>> +the target of the operation using `target_mpidr`, along with the status
>>>> +(`psci_status`). The RMM v1.0 specification defines two functions that require
>>>> +this call: PSCI_CPU_ON and PSCI_AFFINITY_INFO.
>>>> +
>>>> +If the kernel is handling PSCI then this is done automatically and the VMM
>>>> +doesn't need to call this ioctl.
>>>
>>> Shouldn't we make handling of PSCI mandatory for VMMs that deal with
>>> CCA? I suspect it would simplify the implementation significantly.
>>
>> What do you mean by making it "mandatory for VMMs"? If you mean PSCI is
>> always forwarded to user space then I don't think it's going to make
>> much difference. Patch 27 handles the PSCI changes (72 lines added), and
>> some of that is adding this uAPI for the VMM to handle it.
>>
>> Removing the functionality to allow the VMM to handle it would obviously
>> simplify things a bit (we can drop this uAPI), but I think the desire is
>> to push this onto user space.
> 
> And that's what I'm asking for. I do not want this to be optional. CCA
> should implies PSCI in userspace, and that's it.
> 
>>
>>> What vcpu fd does this apply to? The vcpu calling the PSCI function?
>>> Or the target? This is pretty important for PSCI_ON. My guess is that
>>> this is setting the return value for the caller?
>>
>> Yes the fd is the vcpu calling PSCI. As you say, this is for the return
>> value to be set correctly.
> 
> Another question is why do we need the ioctl at all? Why can't it be
> done on the first run of the target vcpu? If no PSCI call was issued
> to run it, then the run fails.

So my concern is the ordering of operations for PSCI_CPU_ON. As things
stand the RMM needs to know the MPIDR mapping to look up the REC object
before either VCPU runs again.

If we do this on the first run of the target VCPU, then how is the VMM
to tell that the target VCPU has executed "long enough" that it is safe
to do the return on the initial VCPU? Since the VCPUs are different
threads this becomes tricky. Options I can see are:

a) The VMM has to wait for the target VCPU to exit - we'd probably want
to trigger an artificial early exit in this case to unblock things.

b) The kernel blocks the initial VCPU from running until the target VCPU
has completed this "first run" logic. I think waiting in the kernel is
probably problematic, so this implies return some sort of "retry later"
response to the VMM.

c) The kernel handles the "PSCI_COMPLETE" dance on whichever VCPU runs
first, blocking the other until the dance is complete. A disadvantage
here is that behaviour can differ (in error conditions) depending on
which VCPU thread wins the race.

All these options also involve the kernel keeping track of the PSCI
sequence, in particular:

1. Tracking that the exit was due to a PSCI_CPU_ON.

2. Treating attempting to run the target VCPU as an implicit success
return from the PSCI call.

3. Recognising the next run on the initial VCPU as containing the PSCI
result - if 2, above, has happened then the kernel will need to handle
this (by killing the guest).

TLDR; Yes this is possible but I don't think it's pretty, and I'm not
convinced it's an improved uAPI.

Of course the above all assumes that the RMM can't just track things
internally. My preference is to kill RMI_PSCI_COMPLETE altogether, but
I'm not sure how possible that is within the context of the RMM.

>>
>>> Assuming this is indeed for the caller, why do we have a different
>>> flow from anything else that returns a result from a hypercall?
>>
>> I'm not entirely sure what you are suggesting. Do you mean why are we
>> not just writing to the GPRS that would contain the result? The issue
>> here is that the RMM needs to know the PA of the target REC structure -
>> this isn't a return to the guest, but information for the RMM itself to
>> complete the PSCI call.
> 
> PSCI is a SMC call. SMC calls are routed to userspace as such. For odd
> reasons, the RMM treats PSCI differently from any other SMC call.
> 
> That seems a very bizarre behaviour to me.

The RMM generally treats SMC specially. We have the RSI_HOST_CALL as a
proxy for "general SMC-like" behaviour which is forwarded to the VMM. I
believe the intention here is to ensure that SMCs (from the realm guest)
are handled by a trusted agent (i.e. the RMM). PSCI is a corner case
because it requires some coordination and buy-in from the VMM.

I'm not sure I fully understand the security pros and cons of the design
here and what impact it would have if PSCI was well trusted.

Thanks,
Steve

>>
>> Ultimately even in the case where the VMM is handling PSCI, it's
>> actually a combination of the VMM and the RMM - with the RMM validating
>> the responses.
> 
> I don't see why PSCI is singled out here, irrespective of the tracking
> that the RMM wants to do.
> 
> 	M.
> 


