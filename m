Return-Path: <kvm+bounces-59926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F3BEBBD5491
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 18:56:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 36BA61890F22
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 16:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DCAD299A96;
	Mon, 13 Oct 2025 16:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XrMsX32L"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773051F419B;
	Mon, 13 Oct 2025 16:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760374577; cv=none; b=M4pm8/uVWkglhKn15wc1nZgTBflON5WR5B9SIWRv7kMxzNSwBpGY6Pq3lWl31b8iSPV8QQ/pwm82sU8qFNPeSj+XefFOtLdWHpTD35rBvWcHsZTL1CP9E3Hh3BeEmJ9dhRmXGARF7R70Yv/pMh32PAkPO8Zlpre1tM7pAdzqi84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760374577; c=relaxed/simple;
	bh=KLfGOCVwkj6cLAhHYVXLE9hEZv8zCuONXlmlV9iauKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YmNU8qfrbVdNEf+ADeWYl9eB0ZMwmQzqD7G6KP0yPFOcMRSs6FB1hPcvKfAE2CmO65sHTFR9JnOw1jReUQp7KDJLq/kDvb8z6P6ELjAY5Q7iJ80w3OndKOhdRkXZbyrXRZnZYe0yeKihWLx4mVCh81iW4xEJ3VU0LUwVjrW8DZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XrMsX32L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88DBC4CEE7;
	Mon, 13 Oct 2025 16:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760374576;
	bh=KLfGOCVwkj6cLAhHYVXLE9hEZv8zCuONXlmlV9iauKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrMsX32LZTlMzKpNmGasGW0zCn3IU29cqzXBHQ+BAB2/YHt44WdwUqk/XY5YXaL2u
	 qp6cHXcmDxGNhEgQXv4ciVrn0eHYhG5rOrzfclI6rIl4mBduqg6XsSOPE/40hBkMVn
	 AMpZDvYsNEgfA2EiHsipBCRQ6Si+10CFGmths6l+i7NSy+oz3Gz8e5tjhrtD/eTy7C
	 8AbHeAxS62KiG/VhVlmf+RRw79qhTKHuhSKvn/eFemYpYRofxkKPT1zx/7tGs15/cx
	 VRuUL80jzyWhxSjCkpllz+RAxzIinuQEN72oiF9R8H7kYtYrp/cIU9rsOFgzl+gmxe
	 cKP2DWlNtWpOw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v8LqI-0000000DaV2-3qkd;
	Mon, 13 Oct 2025 16:56:15 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: nd <nd@arm.com>,
	oliver.upton@linux.dev,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	yuzenghui@huawei.com
Subject: Re: [PATCH] Documentation: KVM: Update GICv3 docs for GICv5 hosts
Date: Mon, 13 Oct 2025 17:56:12 +0100
Message-ID: <176037441181.969330.12749252247958777083.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251007154848.1640444-1-sascha.bischoff@arm.com>
References: <20251007154848.1640444-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Sascha.Bischoff@arm.com, nd@arm.com, oliver.upton@linux.dev, Joey.Gouly@arm.com, Suzuki.Poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 07 Oct 2025 15:48:54 +0000, Sascha Bischoff wrote:
> GICv5 hosts optionally include FEAT_GCIE_LEGACY, which allows them to
> execute GICv3-based VMs on GICv5 hardware. Update the GICv3
> documentation to reflect this now that GICv3 guests are supports on
> compatible GICv5 hosts.
> 
> 

Applied to fixes, thanks!

[1/1] Documentation: KVM: Update GICv3 docs for GICv5 hosts
      commit: 164ecbf73c3ea61455e07eefdad8050a7b569558

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



