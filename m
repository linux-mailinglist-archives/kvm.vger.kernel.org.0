Return-Path: <kvm+bounces-72378-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aDdoKlijpWngCwAAu9opvQ
	(envelope-from <kvm+bounces-72378-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 15:48:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AC0C61DB24E
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 15:48:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AF7393036062
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 14:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52D1A401491;
	Mon,  2 Mar 2026 14:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bQnl2Efj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8460E3FFAD2;
	Mon,  2 Mar 2026 14:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772462457; cv=none; b=FeaY3VdcThMVODyrQq3PQFBNs2od1qLazCyFrP/7k4LFUYo/aO9yOoAoSVPXzfv07nbLS7WGXwPFmIl2rtlM35CbzaIqZeq84n4dZUAsqF+F9VjSU64HsML2mEBRGqcdvHHmzCYvSM/TvszEUSDu4y3SaYgBotJJjbbqY6jJHgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772462457; c=relaxed/simple;
	bh=0BX32rikMvdKmXC/ZetcwR4NQo3eeiBaEA6cl/8/jL4=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cvJiO9cwbniwLYIc4oaEKE23DXeWQ1ma8r8vvp4GFtqpIKTjTHIggRT7qoVFEpuGYeIcniWXR2mhwwiBbgNeOF2LHI5/nZded0sKVrKnVfOXCz9MWIgzLnT+YD4t6NiaxIMnRBCZnfW1EtOycRNmyP20pRugz2nUv/gk2VqUe1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bQnl2Efj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD32C2BC87;
	Mon,  2 Mar 2026 14:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772462457;
	bh=0BX32rikMvdKmXC/ZetcwR4NQo3eeiBaEA6cl/8/jL4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bQnl2EfjARf61qvvtmuKW2BmsdeY+7kF/+PPxOJsE6Ua/U1JITg9L3KPIwlNhwF/k
	 prOm/v6D06rZ1UjUkTyOzW4CzXAbKppBTYmZ6/K3VLID1KROqhErHkbriTPSwoQNwS
	 McRg5FPUb/rTUdi7rHTYU0G3IN4JcFE98+RQBolSjxGAaCAPztGb+7Hj8M47Jy2Wm2
	 D+aegsuvJmrguzO+2AaAYCEZc/pdl7Cb2v/fhvcreFmjJzztvguK4a+gM4h7NmtjNg
	 kb2ttvq8Niyg0hX3in9bZa4Oqksy/II0DgpIAmLaz8/Z37RreUvXo4/DIgNNEWuBt5
	 1kKmMX+xxPrmQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vx4S6-0000000FHIR-37Cg;
	Mon, 02 Mar 2026 14:40:54 +0000
Date: Mon, 02 Mar 2026 14:40:54 +0000
Message-ID: <86seai8fbd.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
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
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH v12 11/46] arm64: RMI: Activate realm on first VCPU run
In-Reply-To: <20251217101125.91098-12-steven.price@arm.com>
References: <20251217101125.91098-1-steven.price@arm.com>
	<20251217101125.91098-12-steven.price@arm.com>
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
X-Rspamd-Queue-Id: AC0C61DB24E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72378-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, 17 Dec 2025 10:10:48 +0000,
Steven Price <steven.price@arm.com> wrote:
> 
> When a VCPU migrates to another physical CPU check

To another physical CPU?

That's not what kvm_arch_vcpu_run_pid_change() tracks. It really is
limited to a new PID being associated to the vpcu thread. Which is
indeed the case when the vpcu runs for the first time, but that's
about it.

If you need to track the physical CPU, we have some tracking for it in
vcpu_load(), but that'd need some rework.

> if this is the first
> time the guest has run, and if so activate the realm.
> 
> Before the realm can be activated it must first be created, this is a
> stub in this patch and will be filled in by a later patch.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> New patch for v12
> ---
>  arch/arm64/include/asm/kvm_rmi.h |  1 +
>  arch/arm64/kvm/arm.c             |  6 +++++
>  arch/arm64/kvm/rmi.c             | 42 ++++++++++++++++++++++++++++++++
>  3 files changed, 49 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index cb7350f8a01a..e4534af06d96 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -69,6 +69,7 @@ void kvm_init_rmi(void);
>  u32 kvm_realm_ipa_limit(void);
>  
>  int kvm_init_realm_vm(struct kvm *kvm);
> +int kvm_activate_realm(struct kvm *kvm);
>  void kvm_destroy_realm(struct kvm *kvm);
>  void kvm_realm_destroy_rtts(struct kvm *kvm);
>  
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 941d1bec8e77..542df37b9e82 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -951,6 +951,12 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>  			return ret;
>  	}
>  
> +	if (kvm_is_realm(vcpu->kvm)) {
> +		ret = kvm_activate_realm(kvm);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	mutex_lock(&kvm->arch.config_lock);
>  	set_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags);
>  	mutex_unlock(&kvm->arch.config_lock);
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index e57e8b7eafa9..98929382c365 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -223,6 +223,48 @@ void kvm_realm_destroy_rtts(struct kvm *kvm)
>  	WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
>  }
>  
> +static int realm_ensure_created(struct kvm *kvm)
> +{
> +	/* Provided in later patch */
> +	return -ENXIO;
> +}
> +
> +int kvm_activate_realm(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	int ret;
> +
> +	if (!kvm_is_realm(kvm))
> +		return -ENXIO;

nit: you already checked for this in caller.

> +
> +	if (kvm_realm_state(kvm) == REALM_STATE_ACTIVE)
> +		return 0;

You probably also want to return early once the realm has been marked
as dead -- it shouldn't be able to be a zombie and die twice.

> +
> +	guard(mutex)(&kvm->arch.config_lock);
> +	/* Check again with the lock held */
> +	if (kvm_realm_state(kvm) == REALM_STATE_ACTIVE)
> +		return 0;
> +
> +	ret = realm_ensure_created(kvm);
> +	if (ret)
> +		return ret;
> +
> +	/* Mark state as dead in case we fail */
> +	WRITE_ONCE(realm->state, REALM_STATE_DEAD);
> +
> +	if (!irqchip_in_kernel(kvm)) {
> +		/* Userspace irqchip not yet supported with realms */
> +		return -EOPNOTSUPP;
> +	}
> +
> +	ret = rmi_realm_activate(virt_to_phys(realm->rd));
> +	if (ret)
> +		return -ENXIO;
> +
> +	WRITE_ONCE(realm->state, REALM_STATE_ACTIVE);
> +	return 0;
> +}
> +
>  void kvm_destroy_realm(struct kvm *kvm)
>  {
>  	struct realm *realm = &kvm->arch.realm;

Thanks,

	M.

-- 
Without deviation from the norm, progress is not possible.

