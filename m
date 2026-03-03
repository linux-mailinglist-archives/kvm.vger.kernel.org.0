Return-Path: <kvm+bounces-72522-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GNt9IH/cpmnRXwAAu9opvQ
	(envelope-from <kvm+bounces-72522-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 14:05:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 911451EFD74
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 14:05:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 33DE73015B9E
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 13:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C625423A6B;
	Tue,  3 Mar 2026 13:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="La3Sdtat"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D74342CA2;
	Tue,  3 Mar 2026 13:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772543089; cv=none; b=s2w4R4bUHbPq4RGCUqv/uZ/tJh6AgXE8GFC00b5YFf6ybTuKPbBLxB0ZmqMZNv8db16o6FvKBWCXblfM7gYv06OZDZ5A8//yqSE560YUwalvLS9o8p/cDi+JOHSVtWdDPEZZsJQ604Cr3MtQi+LpJQ3tJY5hZ9NGHGvz8aViwEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772543089; c=relaxed/simple;
	bh=IG6eXMcFbpNcVG8M+Dn2WriZnMl877owaXZzF3mype0=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cl+/3EzbEPD7B9UWDqYC2GvYMT50Pm94O0r8CLfElnFhZR9ssNFu+WfZFPEWTTwnqfvxNvzZKzS4nc/auFs9KAjRqA+W68KAmJVl21zhIGNDceNyJA/jzCVLUZA7zvkjEN61zt79EIaf35njwarv1wrx++pzt6P3gc0esI/Odbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=La3Sdtat; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD39C116C6;
	Tue,  3 Mar 2026 13:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772543088;
	bh=IG6eXMcFbpNcVG8M+Dn2WriZnMl877owaXZzF3mype0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=La3SdtatLBf9Taf20cBF0nQnwSNfJ4syGQDs1/zNPKFs7urUL4aVtwClyNJ4rwZ+k
	 dI2Y0vxzaO2BfBICJbg6NwDGKIm6tH2dgBl+IpdASu/sDuqJOMI6URcuGFX5fxUpu0
	 4mji7MordsO+8QJ31TWo1lAGt17Io86AptrK0JjortA5OGTaEbmYJH//uHGADTu1Qj
	 9c30aRw5mqjPWhvrzvPx9EgC4dgM+qMK3/fn7kWBIALsvZZO2yTXqG13pu7Qcfi9sM
	 EGuLorjTBZt5LzZe4M1MP9UbI9YVuez4NCGsPDWPnpUeXY6BaorjI9PgDrbw/gnz4u
	 gc8iiKnNtg9Uw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vxPQc-0000000Fd5P-0pn9;
	Tue, 03 Mar 2026 13:04:46 +0000
Date: Tue, 03 Mar 2026 13:04:45 +0000
Message-ID: <86ikbd83o2.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
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
Subject: Re: [PATCH v12 27/46] KVM: arm64: Handle Realm PSCI requests
In-Reply-To: <ec27e294-0bee-474a-a15b-6be20ee10cd4@arm.com>
References: <20251217101125.91098-1-steven.price@arm.com>
	<20251217101125.91098-28-steven.price@arm.com>
	<86pl5m89ub.wl-maz@kernel.org>
	<ec27e294-0bee-474a-a15b-6be20ee10cd4@arm.com>
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
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, steven.price@arm.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, james.morse@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com, tabba@google.com, linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com, gshan@redhat.com, sdonthineni@nvidia.com, alpergun@google.com, aneesh.kumar@kernel.org, fj0570is@fujitsu.com, vannapurve@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Queue-Id: 911451EFD74
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72522-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,arm.com:email]
X-Rspamd-Action: no action

On Tue, 03 Mar 2026 09:26:31 +0000,
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> 
> On 02/03/2026 16:39, Marc Zyngier wrote:
> > On Wed, 17 Dec 2025 10:11:04 +0000,
> > Steven Price <steven.price@arm.com> wrote:
> >> 
> >> The RMM needs to be informed of the target REC when a PSCI call is made
> >> with an MPIDR argument. Expose an ioctl to the userspace in case the PSCI
> >> is handled by it.
> >> 
> >> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> >> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> >> Signed-off-by: Steven Price <steven.price@arm.com>
> >> Reviewed-by: Gavin Shan <gshan@redhat.com>
> >> ---
> >> Changes since v11:
> >>   * RMM->RMI renaming.
> >> Changes since v6:
> >>   * Use vcpu_is_rec() rather than kvm_is_realm(vcpu->kvm).
> >>   * Minor renaming/formatting fixes.
> >> ---
> >>   arch/arm64/include/asm/kvm_rmi.h |  3 +++
> >>   arch/arm64/kvm/arm.c             | 25 +++++++++++++++++++++++++
> >>   arch/arm64/kvm/psci.c            | 30 ++++++++++++++++++++++++++++++
> >>   arch/arm64/kvm/rmi.c             | 14 ++++++++++++++
> >>   4 files changed, 72 insertions(+)
> >> 
> >> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> >> index bfe6428eaf16..77da297ca09d 100644
> >> --- a/arch/arm64/include/asm/kvm_rmi.h
> >> +++ b/arch/arm64/include/asm/kvm_rmi.h
> >> @@ -118,6 +118,9 @@ int realm_map_non_secure(struct realm *realm,
> >>   			 kvm_pfn_t pfn,
> >>   			 unsigned long size,
> >>   			 struct kvm_mmu_memory_cache *memcache);
> >> +int realm_psci_complete(struct kvm_vcpu *source,
> >> +			struct kvm_vcpu *target,
> >> +			unsigned long status);
> >>     static inline bool kvm_realm_is_private_address(struct realm
> >> *realm,
> >>   						unsigned long addr)
> >> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> >> index 06070bc47ee3..fb04d032504e 100644
> >> --- a/arch/arm64/kvm/arm.c
> >> +++ b/arch/arm64/kvm/arm.c
> >> @@ -1797,6 +1797,22 @@ static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
> >>   	return __kvm_arm_vcpu_set_events(vcpu, events);
> >>   }
> >>   +static int kvm_arm_vcpu_rmi_psci_complete(struct kvm_vcpu *vcpu,
> >> +					  struct kvm_arm_rmi_psci_complete *arg)
> >> +{
> >> +	struct kvm_vcpu *target = kvm_mpidr_to_vcpu(vcpu->kvm, arg->target_mpidr);
> >> +
> >> +	if (!target)
> >> +		return -EINVAL;
> >> +
> >> +	/*
> >> +	 * RMM v1.0 only supports PSCI_RET_SUCCESS or PSCI_RET_DENIED
> >> +	 * for the status. But, let us leave it to the RMM to filter
> >> +	 * for making this future proof.
> >> +	 */
> >> +	return realm_psci_complete(vcpu, target, arg->psci_status);
> >> +}
> >> +
> >>   long kvm_arch_vcpu_ioctl(struct file *filp,
> >>   			 unsigned int ioctl, unsigned long arg)
> >>   {
> >> @@ -1925,6 +1941,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> >>     		return kvm_arm_vcpu_finalize(vcpu, what);
> >>   	}
> >> +	case KVM_ARM_VCPU_RMI_PSCI_COMPLETE: {
> >> +		struct kvm_arm_rmi_psci_complete req;
> >> +
> >> +		if (!vcpu_is_rec(vcpu))
> >> +			return -EPERM;
> > 
> > Same remark as for the other ioctl: EPERM is not quite describing the
> > problem.
> > 
> >> +		if (copy_from_user(&req, argp, sizeof(req)))
> >> +			return -EFAULT;
> >> +		return kvm_arm_vcpu_rmi_psci_complete(vcpu, &req);
> >> +	}
> >>   	default:
> >>   		r = -EINVAL;
> >>   	}
> >> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> >> index 3b5dbe9a0a0e..a68f3c1878a5 100644
> >> --- a/arch/arm64/kvm/psci.c
> >> +++ b/arch/arm64/kvm/psci.c
> >> @@ -103,6 +103,12 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> >>     	reset_state->reset = true;
> >>   	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> >> +	/*
> >> +	 * Make sure we issue PSCI_COMPLETE before the VCPU can be
> >> +	 * scheduled.
> >> +	 */
> >> +	if (vcpu_is_rec(vcpu))
> >> +		realm_psci_complete(source_vcpu, vcpu, PSCI_RET_SUCCESS);
> >> 
> > 
> > I really think in-kernel PSCI should be for NS VMs only. The whole
> > reason for moving to userspace support was to stop adding features to
> > an already complex infrastructure, and CCA is exactly the sort of
> > things we want userspace to deal with.
> 
> Agreed. How would you like us to enforce this ? Should we always exit
> to the VMM, even if it hasn't requested the handling ? (I guess it is
> fine and in the worst case VMM could exit, it being buggy)

My current train of though is that a CCA VM always routes PSCI to
userspace, no configuration needed. That's part of the contract.

Now, I'm pretty sure we should *also* get rid of the ioctl that
establishes the relationship between MPIDR and REC. I can't see why
this can't be done at the point where the vcpu runs for the first
time, just like this is done for the first CPU.

Thanks,

	M.

-- 
Without deviation from the norm, progress is not possible.

