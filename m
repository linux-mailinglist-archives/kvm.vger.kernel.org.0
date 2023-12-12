Return-Path: <kvm+bounces-4153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2068580E502
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 08:46:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4FBBB21081
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 07:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8452E1772F;
	Tue, 12 Dec 2023 07:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JJ5m893b"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DA0AB
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 23:45:50 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702367148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4aVyArr4iBcQIn6ftXAQ5A1fU+TBT6rJSv2AUIRJ094=;
	b=JJ5m893bvN7KpZawSKxVUyRSeox/2AhxnTpU34dTlp2NnicR03SzizG3mDSHWh5DAGFJEU
	sHJbHyWwTNgPpHaHQSuumBIq/4Uwi42ZDTxFoMI4Kx3ZIs23IZvfAIQBN2Bpr25mdaEx32
	1WRSLi/p2pWhCOlKUxFf4KRb7UpN4qo=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	vdonnefort@google.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 0/5] KVM: arm64: vgic fixes for 6.7
Date: Tue, 12 Dec 2023 07:45:36 +0000
Message-ID: <170236713184.438197.11882636144565219983.b4-ty@linux.dev>
In-Reply-To: <20231207151201.3028710-1-maz@kernel.org>
References: <20231207151201.3028710-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 7 Dec 2023 15:11:56 +0000, Marc Zyngier wrote:
> It appears that under some cirumstances, the lifetime of a vcpu
> doesn't correctly align with that of the structure describing the
> redistributor associated with that vcpu. That's not great.
> 
> Fixing it is, unfortunately, not as trivial as it appears as the
> required locking gets in the way.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/5] KVM: arm64: vgic: Simplify kvm_vgic_destroy()
      https://git.kernel.org/kvmarm/kvmarm/c/01ad29d224ff
[2/5] KVM: arm64: vgic: Add a non-locking primitive for kvm_vgic_vcpu_destroy()
      https://git.kernel.org/kvmarm/kvmarm/c/d26b9cb33c2d
[3/5] KVM: arm64: vgic: Force vcpu vgic teardown on vcpu destroy
      https://git.kernel.org/kvmarm/kvmarm/c/02e3858f08fa
[4/5] KVM: arm64: vgic: Ensure that slots_lock is held in vgic_register_all_redist_iodevs()
      https://git.kernel.org/kvmarm/kvmarm/c/6bef365e310a
[5/5] KVM: Convert comment into an assertion in kvm_io_bus_register_dev()
      https://git.kernel.org/kvmarm/kvmarm/c/b1a39a718db4

--
Best,
Oliver

