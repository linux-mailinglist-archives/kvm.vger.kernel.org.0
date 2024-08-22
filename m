Return-Path: <kvm+bounces-24806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 55C3195AC5A
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 06:05:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D1E40B21804
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 04:05:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72BB037165;
	Thu, 22 Aug 2024 04:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JFj5BQt9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AEEB1B970;
	Thu, 22 Aug 2024 04:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724299495; cv=none; b=BwLqTyAWsG8EUBY8w0IYdicozm7vLmeb/q0uXXlURIL8y5Lkqq8tajl66uPHUObmfZBWJS+2XOENaMV44o6inWeX1HRqutarMgklnXzwi4zv4cxaYIV2Y5+Mrhi9JyWPF4SaG5yo0AnVmz+G8NxBB0jcy7DqhAKFv2UM4XMYhQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724299495; c=relaxed/simple;
	bh=tbe4FZUkzz+iVMQdUiF9BG9MZYXNRR57xKnKHiajJZc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=RWpESdh3hlouej7aiE7YGkqpWD7ygmIUqy+sS+/7yEyNiWo53SvJs+jPmzxz+ySLhikibAo1Oa35C6EJlPEke9RxcS4HO0LbNZvNje8udyNP7On4tY9+ilMtNCdakO375zcxu/GcXc8VMDhxL//c8Zyz010yi7lbfkwSIow2rZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JFj5BQt9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72061C4AF09;
	Thu, 22 Aug 2024 04:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724299495;
	bh=tbe4FZUkzz+iVMQdUiF9BG9MZYXNRR57xKnKHiajJZc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=JFj5BQt989BcieRka9JzUyKpbJpUE0ShZUw/SCgbsDVG7uHs3xVHiYDmFXJm5PNz7
	 VhpYE3iW91v6e88TQuGd+3ftgW2HnMcU2GKmTfT/aKjGkg0Q+ry4tRQ8W96s0a/9XU
	 KOpvr2PyR/0YUnJEIQ9MeeIJ46O+IDZil9a6/PWmL5BV5anmL5ZbQLFCHYPhdGOqIf
	 rB60oYFxM69i+IUGKwVXS4BEnSaRnk98pDx7HFyRuOwM7kXyz97CkLOMvyqbyWvria
	 WR/cvPhETy/rvHHTBBEBa7RrEn9okX+M8/jxpqD8JLlcTxTK6a38nLqDivtIawDoPO
	 W4tkDpgsMWNdw==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v4 18/43] arm64: RME: Handle realm enter/exit
In-Reply-To: <20240821153844.60084-19-steven.price@arm.com>
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-19-steven.price@arm.com>
Date: Thu, 22 Aug 2024 09:34:44 +0530
Message-ID: <yq5a34mx2of7.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

....

> +static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct realm *realm = &kvm->arch.realm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long base = rec->run->exit.ripas_base;
> +	unsigned long top = rec->run->exit.ripas_top;
> +	unsigned long ripas = rec->run->exit.ripas_value & 1;
> +	unsigned long top_ipa;
> +	int ret = -EINVAL;
> +
> +	if (realm_is_addr_protected(realm, base) &&
> +	    realm_is_addr_protected(realm, top - 1)) {
> +		kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
> +					   kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
> +		write_lock(&kvm->mmu_lock);
> +		ret = realm_set_ipa_state(vcpu, base, top, ripas, &top_ipa);
> +		write_unlock(&kvm->mmu_lock);
> +	}
> +
> +	WARN(ret && ret != -ENOMEM,
> +	     "Unable to satisfy SET_IPAS for %#lx - %#lx, ripas: %#lx\n",
> +	     base, top, ripas);
> +
> +	/* Exit to VMM to complete the change */
> +	kvm_prepare_memory_fault_exit(vcpu, base, top_ipa - base, false, false,
> +				      ripas == 1);
> +
> +	return 0;
> +}
> +

arch/arm64/kvm/rme-exit.c:100:6: warning: variable 'top_ipa' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
        if (realm_is_addr_protected(realm, base) &&
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arch/arm64/kvm/rme-exit.c:114:44: note: uninitialized use occurs here
        kvm_prepare_memory_fault_exit(vcpu, base, top_ipa - base, false, false,
                                                  ^~~~~~~

-aneesh

