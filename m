Return-Path: <kvm+bounces-72523-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wPbiH1PfpmlkYAAAu9opvQ
	(envelope-from <kvm+bounces-72523-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 14:17:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D029B1F00DC
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 14:17:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6933730B54EF
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 13:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C35423A8B;
	Tue,  3 Mar 2026 13:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QC7mxPU8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1183C347C6;
	Tue,  3 Mar 2026 13:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772543472; cv=none; b=eUdl1tTAyQE43lrbfKJ+kg6UqoM24oFCgtDP5S3Z4r84SRC9c8WC7tyN5KKYtyWJRMR5Pu/gOhzuF/GwbCl8vn8CmmD1Lkz/qiQJjDsBiyfvCMcmVMO3GFi77tqO6V8EkPIiaPC2qTJuA3uOYqUf1WvqXr7uZswB7Jm1Np+tNcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772543472; c=relaxed/simple;
	bh=4BMCfMG0xmMJRazWkyzqMGnmOOaf03oyyGgCFv2NmSY=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XLwc34S/1Hnxmlgu2Q5i8NEXuTTgjc5yHztZAQtBsf68jKVEGJHUZDgI3g+VnI7Lq5zEpT88vNpg7ms7BuluJHj2aJHqYZkO53ZyFw5xJlXS6Oac9To63iDyeh9huptlWwf48WKwR/D2e/0HXFgnvyAhGl2sxW00dJpqmDhGxq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QC7mxPU8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCEEC116C6;
	Tue,  3 Mar 2026 13:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772543471;
	bh=4BMCfMG0xmMJRazWkyzqMGnmOOaf03oyyGgCFv2NmSY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QC7mxPU8AQ9uRmeIfF3qdq8rHzsmSVgzhDtDE7gQyaqENSOIyAiGVyfXv2BcGJCzC
	 XzI7AFpCah0vaLAbdbkuEiV7s+nGGtX3MQDvSBOnYXCIydCwE9xx5hAx+peM6mYgzE
	 j9lMpEtdEOo68s2PgCFKizAgpUOwdoIpZZEOnbEmfpB1Ty36amVT3L0CKftdK9bjbj
	 gl1NKx+6uwT9bsrO5nFnVpugzAKv1HLzbjtPxAGBqljbQRK6OJWvEJcqI4VNUV9P5C
	 5Mh7K4nJyOt4ofs0Ieg5Di3GlmUmt031nPYOQKpWh/mEwFo7t4QOhseDCbsFZlDNGd
	 gN5o1l1YpX2eg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vxPWm-0000000FdFB-3a8B;
	Tue, 03 Mar 2026 13:11:09 +0000
Date: Tue, 03 Mar 2026 13:11:08 +0000
Message-ID: <86h5qx83df.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu
 <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH v12 06/46] arm64: RMI: Define the user ABI
In-Reply-To: <33053e22-6cc6-4d55-bc7f-01f873a15d28@arm.com>
References: <20251217101125.91098-1-steven.price@arm.com>
	<20251217101125.91098-7-steven.price@arm.com>
	<86tsuy8g0u.wl-maz@kernel.org>
	<33053e22-6cc6-4d55-bc7f-01f873a15d28@arm.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: steven.price@arm.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, james.morse@arm.com, oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com, tabba@google.com, linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com, gshan@redhat.com, sdonthineni@nvidia.com, alpergun@google.com, aneesh.kumar@kernel.org, fj0570is@fujitsu.com, vannapurve@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Queue-Id: D029B1F00DC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72523-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, 02 Mar 2026 15:23:44 +0000,
Steven Price <steven.price@arm.com> wrote:
> 
> Hi Marc,
> 
> On 02/03/2026 14:25, Marc Zyngier wrote:
> > On Wed, 17 Dec 2025 10:10:43 +0000,
> > Steven Price <steven.price@arm.com> wrote:
> >>
> >> There is one CAP which identified the presence of CCA, and two ioctls.
> >> One ioctl is used to populate memory and the other is used when user
> >> space is providing the PSCI implementation to identify the target of the
> >> operation.
> >>
> >> Signed-off-by: Steven Price <steven.price@arm.com>
> >> ---
> >> Changes since v11:
> >>  * Completely reworked to be more implicit. Rather than having explicit
> >>    CAP operations to progress the realm construction these operations
> >>    are done when needed (on populating and on first vCPU run).
> >>  * Populate and PSCI complete are promoted to proper ioctls.
> >> Changes since v10:
> >>  * Rename symbols from RME to RMI.
> >> Changes since v9:
> >>  * Improvements to documentation.
> >>  * Bump the magic number for KVM_CAP_ARM_RME to avoid conflicts.
> >> Changes since v8:
> >>  * Minor improvements to documentation following review.
> >>  * Bump the magic numbers to avoid conflicts.
> >> Changes since v7:
> >>  * Add documentation of new ioctls
> >>  * Bump the magic numbers to avoid conflicts
> >> Changes since v6:
> >>  * Rename some of the symbols to make their usage clearer and avoid
> >>    repetition.
> >> Changes from v5:
> >>  * Actually expose the new VCPU capability (KVM_ARM_VCPU_REC) by bumping
> >>    KVM_VCPU_MAX_FEATURES - note this also exposes KVM_ARM_VCPU_HAS_EL2!
> >> ---
> >>  Documentation/virt/kvm/api.rst | 57 ++++++++++++++++++++++++++++++++++
> >>  include/uapi/linux/kvm.h       | 23 ++++++++++++++
> >>  2 files changed, 80 insertions(+)
> >>
> >> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> >> index 01a3abef8abb..2d5dc7e48954 100644
> >> --- a/Documentation/virt/kvm/api.rst
> >> +++ b/Documentation/virt/kvm/api.rst
> >> @@ -6517,6 +6517,54 @@ the capability to be present.
> >>  
> >>  `flags` must currently be zero.
> >>  
> >> +4.144 KVM_ARM_VCPU_RMI_PSCI_COMPLETE
> >> +------------------------------------
> >> +
> >> +:Capability: KVM_CAP_ARM_RMI
> >> +:Architectures: arm64
> >> +:Type: vcpu ioctl
> >> +:Parameters: struct kvm_arm_rmi_psci_complete (in)
> >> +:Returns: 0 if successful, < 0 on error
> >> +
> >> +::
> >> +
> >> +  struct kvm_arm_rmi_psci_complete {
> >> +	__u64 target_mpidr;
> >> +	__u32 psci_status;
> >> +	__u32 padding[3];
> >> +  };
> >> +
> >> +Where PSCI functions are handled by user space, the RMM needs to be informed of
> >> +the target of the operation using `target_mpidr`, along with the status
> >> +(`psci_status`). The RMM v1.0 specification defines two functions that require
> >> +this call: PSCI_CPU_ON and PSCI_AFFINITY_INFO.
> >> +
> >> +If the kernel is handling PSCI then this is done automatically and the VMM
> >> +doesn't need to call this ioctl.
> > 
> > Shouldn't we make handling of PSCI mandatory for VMMs that deal with
> > CCA? I suspect it would simplify the implementation significantly.
> 
> What do you mean by making it "mandatory for VMMs"? If you mean PSCI is
> always forwarded to user space then I don't think it's going to make
> much difference. Patch 27 handles the PSCI changes (72 lines added), and
> some of that is adding this uAPI for the VMM to handle it.
>
> Removing the functionality to allow the VMM to handle it would obviously
> simplify things a bit (we can drop this uAPI), but I think the desire is
> to push this onto user space.

And that's what I'm asking for. I do not want this to be optional. CCA
should implies PSCI in userspace, and that's it.

> 
> > What vcpu fd does this apply to? The vcpu calling the PSCI function?
> > Or the target? This is pretty important for PSCI_ON. My guess is that
> > this is setting the return value for the caller?
> 
> Yes the fd is the vcpu calling PSCI. As you say, this is for the return
> value to be set correctly.

Another question is why do we need the ioctl at all? Why can't it be
done on the first run of the target vcpu? If no PSCI call was issued
to run it, then the run fails.

> 
> > Assuming this is indeed for the caller, why do we have a different
> > flow from anything else that returns a result from a hypercall?
> 
> I'm not entirely sure what you are suggesting. Do you mean why are we
> not just writing to the GPRS that would contain the result? The issue
> here is that the RMM needs to know the PA of the target REC structure -
> this isn't a return to the guest, but information for the RMM itself to
> complete the PSCI call.

PSCI is a SMC call. SMC calls are routed to userspace as such. For odd
reasons, the RMM treats PSCI differently from any other SMC call.

That seems a very bizarre behaviour to me.

> 
> Ultimately even in the case where the VMM is handling PSCI, it's
> actually a combination of the VMM and the RMM - with the RMM validating
> the responses.

I don't see why PSCI is singled out here, irrespective of the tracking
that the RMM wants to do.

	M.

-- 
Without deviation from the norm, progress is not possible.

