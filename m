Return-Path: <kvm+bounces-38614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F15C7A3CD49
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 00:18:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E614F3B96D0
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 23:17:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 846E625E457;
	Wed, 19 Feb 2025 23:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rWjIol6+"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D11125D528
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 23:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740007074; cv=none; b=L6f/iTvFrDjZSde9X9S4eq9d1bxP5peQFkiCEP0I+Amwj4OOTN5SKNIvp1Lx3hR10KIS0S4nWt4n/LLNij6eqQFYPEzjhjVFiaOMwJ/ohyKhend15q4JF0hQ3C710tdTM5bdQWD7lgZf7z1e2NrpJtbqXB52QJhtvL+NrDWBjVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740007074; c=relaxed/simple;
	bh=2l4MT9KNgjL8E97mVYkyRyBP7H9RJx3qMJcP4uoxO+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EkRbqf+2cWPQkqDhymnF8qnE1WJIsPIbvZlRgHi5ybWDPBooSi/+7/paDsR8gIIxsS9W5QriqIGtYZpGbUqUAN2BqKUrbU/WwUA3W8Zl34XOWoVqjklbmkgNmZoaIBrP847v0HLwcqkyns2js7Yc35jFTs5naWXsIzjdyEkcNN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rWjIol6+; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 19 Feb 2025 15:17:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740007060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2HYNXCOG+wz0Fdaw+JzO32UazAyTjP8oMfGb/KMbtPQ=;
	b=rWjIol6+9So8K9A93M3qdYQy57XhJ6qTjdt3sJPKEgVbKEBQ6+SFT8I5y3AI88ntH3Y7AN
	S1MvjMiuGAuZovKk/UGMRVbTxEJMYFvuoXKaypfdQX3MlIhdZxluwsIVrJQ/7uSzsFQyuF
	Hobudgns7BwfXvj1wNR9P6T7YBKmfMM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 00/14] KVM: arm64: NV userspace ABI
Message-ID: <Z7Zmi0WAkudX5h0h@linux.dev>
References: <20250215173816.3767330-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250215173816.3767330-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Feb 15, 2025 at 05:38:02PM +0000, Marc Zyngier wrote:
> Since the previous incarnation of the ABI was proved to be subtly
> wrong, I have reworked it to be more in line with the current way KVM
> operates.
> 
> No more late NV-specific adjustment nor writable ID_AA64MMFR0_EL1.VH.
> The NV configuration is now entirely selected from the vcpu flags.
> I've preserved the KVM_ARM_VCPU_EL2 flag which enables NV with VHE,
> and added KVM_ARM_VCPU_EL2_E2H0 which alters the NV behaviour to only
> allow nVHE guests without recursive NV support.
> 
> This series is actually very little new code. The bulk of it is
> converting the feature downgrade to be per-idreg, essentially going
> back to the state before 44241f34fac96 ("KVM: arm64: nv: Use accessors
> for modifying ID registers"), only slightly modernised. This then
> becomes part of the reset value computing.
> 
> The rest is simply what you'd expect in terms of being able to write
> the ID_AA64MMFR4_EL1.NV_frac field, making the correct bits RES0 when
> needed, probing for capabilities and handling the init flags.
> 
> Patches on top of -rc2, with the integration branch at the usual
> location.

This all looks reasonable to me. NV won't be ready for the limelight
this time around so unless someone shouts I plan on taking the first 12
patches of this series in 6.15.

Thanks,
Oliver

