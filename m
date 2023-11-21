Return-Path: <kvm+bounces-2195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C859F7F3279
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 16:39:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D6A9282B80
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 15:39:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B94585810D;
	Tue, 21 Nov 2023 15:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lsaeHPu8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F231495EF
	for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 15:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EECC433C8;
	Tue, 21 Nov 2023 15:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700581148;
	bh=IN/uvvzabSkp6r7ZshAtgqcudg983ZUmrd/gHRxFo5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lsaeHPu8G5UbC8AQYiszVgHGInJFDgQb49sKI/ppEf+urdFFVK7K2TCBI3GMwptAj
	 BuZsvt3xOZc0El8GFFeaBCWpSAYNkWDf9Yt+FxjRGAYt+hO9hpGJjsNKeOBSGeoISm
	 fh9HMeH5DegkFt45ekqRzhbgVMyBUXQVRtWDtqlQ2Sngd+tRgYUEcTIUbqf/hQfYQz
	 FrVpfP68rHkbTrq7KDORh/X+hpeKaISKOiiQGGsOyx3YBU2Z8YTM8YNsQuC9P7oOOa
	 kn2+vYmEg2lsOK53rQsmPqU3J0LRzhTa6CK0V093na7pmypotOm5C0QRDwJJRi9t/f
	 FCukRg5x7K0fQ==
From: Will Deacon <will@kernel.org>
To: maz@kernel.org,
	Anup Patel <apatel@ventanamicro.com>,
	julien.thierry.kdev@gmail.com
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Anup Patel <anup@brainfault.org>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@atishpatra.org>
Subject: Re: [kvmtool PATCH v3 0/6] RISC-V AIA irqchip and Svnapot support
Date: Tue, 21 Nov 2023 15:39:00 +0000
Message-Id: <170058078885.653754.8772378567684754603.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20231118132847.758785-1-apatel@ventanamicro.com>
References: <20231118132847.758785-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sat, 18 Nov 2023 18:58:41 +0530, Anup Patel wrote:
> The latest KVM in Linux-6.5 has support for:
> 1) Svnapot ISA extension support
> 2) AIA in-kernel irqchip support
> 
> This series adds corresponding changes in KVMTOOL to use the above
> mentioned features for Guest/VM.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/6] Sync-up header with Linux-6.6 for KVM RISC-V
      https://git.kernel.org/will/kvmtool/c/26c85896bc3a
[2/6] riscv: Add Svnapot extension support
      https://git.kernel.org/will/kvmtool/c/56e2d678f578
[3/6] riscv: Make irqchip support pluggable
      https://git.kernel.org/will/kvmtool/c/0dff350174f8
[4/6] riscv: Add IRQFD support for in-kernel AIA irqchip
      https://git.kernel.org/will/kvmtool/c/17aab306ad14
[5/6] riscv: Use AIA in-kernel irqchip whenever KVM RISC-V supports
      https://git.kernel.org/will/kvmtool/c/328f0879eeae
[6/6] riscv: Fix guest/init linkage for multilib toolchain
      https://git.kernel.org/will/kvmtool/c/095773e707ae

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

