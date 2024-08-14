Return-Path: <kvm+bounces-24122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0223195185D
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 12:08:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8337282B35
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 057A219FA81;
	Wed, 14 Aug 2024 10:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bPEvpgQ0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2996C19F461;
	Wed, 14 Aug 2024 10:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723630087; cv=none; b=d2Z9CQkhH47qaQUDWl9r3PBKaUletlvm53cCaLLfxRVs+7bLryfj97VF9afbEAW8+Q/zJazqtUz8u8eCpnYZc/ZKRrYOJeqeWpa3EqSuauoTgqDuI+Ngu5RQfpA0MvOOZRZDWDw5bINCet48gpKftr3dQR4nWln6bgx2V5OdowA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723630087; c=relaxed/simple;
	bh=/O+zco5tN5jy0KvDNjb92RKBNcmlhfZAvjQ/8bbSy3I=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=lW2+p0Xxdtbi7owCUmygvbzj+T4fq6wwpn85SgeGIxQj4YGesC5LFoefJPk5QirQ2ko8Pm/oZY1CZLykX/ej6iAhS5lsbEeZv0u4Zg9EF33cBOMmad0PQ6ltz3F0olD6csGrzY1fC/POHWyVLB2lC/Xo7gE2bOj6u6ubyL1/yvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bPEvpgQ0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5892C32786;
	Wed, 14 Aug 2024 10:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723630086;
	bh=/O+zco5tN5jy0KvDNjb92RKBNcmlhfZAvjQ/8bbSy3I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bPEvpgQ0U+fkLwmsWNq84kZCSmMgiX1pYeIlgBLGk46mtxYwVQGTEfs7Rvzyy0SUn
	 WRLiMfYE1GuNYh+IBsVPhz3ySdOpoj4lMueIrzdBIHkGqj9BHlZIw2+VDeseKoR1W8
	 Pjg07EtK951Im6IRvgcZuLPHQF9ZlDPGS5rlC9gKnG4XH7CwrabeCnPdG1JSktFem4
	 SqU5NhSExUiwCEWQJ10L73fMhbC1dSOlyXBLIoaPAysokoXDYqeYcTUetNeB1IySwn
	 01lJmqhRDvpK2wlJ3sTvqZ10WIYbk25MbCojER4duDhQxP0d/oKXBm2UqSL//4S1HE
	 +2mB363qtWoEQ==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1seAvE-003cdg-Ba;
	Wed, 14 Aug 2024 11:08:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 14 Aug 2024 11:08:03 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu
 <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>,
 Przemyslaw Gaj <pgaj@cadence.com>
Subject: Re: [PATCH v3 14/18] KVM: arm64: nv: Add SW walker for AT S1
 emulation
In-Reply-To: <20240813100540.1955263-15-maz@kernel.org>
References: <20240813100540.1955263-1-maz@kernel.org>
 <20240813100540.1955263-15-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <256756ebb8440e1f2a4d90dc0608879f@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2024-08-13 11:05, Marc Zyngier wrote:
> In order to plug the brokenness of our current AT implementation,
> we need a SW walker that is going to... err.. walk the S1 tables
> and tell us what it finds.
> 
> Of course, it builds on top of our S2 walker, and share similar
> concepts. The beauty of it is that since it uses kvm_read_guest(),
> it is able to bring back pages that have been otherwise evicted.
> 
> This is then plugged in the two AT S1 emulation functions as
> a "slow path" fallback. I'm not sure it is that slow, but hey.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/at.c | 607 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 605 insertions(+), 2 deletions(-)

[...]

> +static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
> +{
> +	bool perm_fail, ur, uw, ux, pr, pw, px;
> +	struct s1_walk_result wr = {};
> +	struct s1_walk_info wi = {};
> +	int ret, idx;
> +
> +	ret = setup_s1_walk(vcpu, op, &wi, &wr, vaddr);
> +	if (ret)
> +		goto compute_par;
> +
> +	if (wr.level == S1_MMU_DISABLED)
> +		goto compute_par;
> +
> +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> +
> +	ret = walk_s1(vcpu, &wi, &wr, vaddr);
> +
> +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +
> +	if (ret)
> +		goto compute_par;
> +
> +	/* FIXME: revisit when adding indirect permission support */
> +	/* AArch64.S1DirectBasePermissions() */
> +	if (wi.regime != TR_EL2) {
> +		switch (FIELD_GET(PTE_USER | PTE_RDONLY, wr.desc)) {
> +		case 0b00:
> +			pr = pw = true;
> +			ur = uw = false;
> +			break;
> +		case 0b01:
> +			pr = pw = ur = uw = true;
> +			break;
> +		case 0b10:
> +			pr = true;
> +			pw = ur = uw = false;
> +			break;
> +		case 0b11:
> +			pr = ur = true;
> +			pw = uw = false;
> +			break;
> +		}
> +
> +		switch (wr.APTable) {
> +		case 0b00:
> +			break;
> +		case 0b01:
> +			ur = uw = false;
> +			break;
> +		case 0b10:
> +			pw = uw = false;
> +			break;
> +		case 0b11:
> +			pw = ur = uw = false;
> +			break;
> +		}
> +
> +		/* We don't use px for anything yet, but hey... */
> +		px = !((wr.desc & PTE_PXN) || wr.PXNTable || pw);

Annoying (but so far harmless) bug here: the last term should be 'uw',
and not 'pw'. It is a *userspace* writable permission that disables
privileged execution. 'pw' would only make sense if with WXN, and
that has nothing to do with AT at all.

I've fixed that locally.

         M.
-- 
Jazz is not dead. It just smells funny...

