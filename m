Return-Path: <kvm+bounces-14006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCD4F89E0E3
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 19:00:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09E331C22778
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 17:00:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E0D115538F;
	Tue,  9 Apr 2024 16:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qVJCzl/m"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0C6153BDD
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 16:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712681984; cv=none; b=BlOfG1FyWFEWpGunskoVYK655iNzODuaxUoJCJTws4o2pbYgt6t5pIgvWaRvl7QVDNt1C1GPVMRxNpcV8L7phH+a3MPBOHP93JVgUPIqj6s/dzZyq0aPDuRgRvJI34o+v6yuw+z05m6a7/m49NVu881pTXZR/CFx2jXj4oPNwb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712681984; c=relaxed/simple;
	bh=zxj+m9uMsWHojQBAsH190jnkLbX6wC8zhHYhmqQ6Bfk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D95TZI288LbVB1M2azoDtL92h6vOXbjNAH2YyYT0kvUaXtQ0344R3ISXAbPR5TSahkj++WD831L7NaS8K/Xgq5T0trfwfjb4IjVlYIK0751M4vApiq02vjnU3b+sGYycxvAf1GA+n71qr+FabQKwbFwFDzlQsb/JW0yFHx/0YR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qVJCzl/m; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A2FC43394;
	Tue,  9 Apr 2024 16:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712681984;
	bh=zxj+m9uMsWHojQBAsH190jnkLbX6wC8zhHYhmqQ6Bfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVJCzl/mfIeGrVNW+vrhy/fgbGL6HjYHBI8WNd7Zupk/NhWjT2kbNfvWVA22X9DBs
	 1Yxu7L5Ba+l1whgMGyxFtDwUYTwFID+StfHwGluFZwB5o/cvtSWz9CMP3NfunL38Uc
	 h6kngUylFNS3DL/uVKKmZI49QOwOqCHAx7gCg1y4qkbAtma0HhplKNX37bUrBrYbpF
	 6rF/r/SyMmDiqybUKOjGsziH6XxSol9KRGzvYZ/L97wag1kZJ1IgYyKlbZZbk01GGM
	 p3l01WeMhmztPUHx3v5WLusgmZE1NXc7KIzEI3sMm2ojV1jwxmvfFHxBRjTK4H94Fh
	 0z1VKD95Xkcxg==
From: Will Deacon <will@kernel.org>
To: julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH v2 00/10] More ISA extensions
Date: Tue,  9 Apr 2024 17:59:33 +0100
Message-Id: <171267491912.3164891.14888329040291157885.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240325153141.6816-1-apatel@ventanamicro.com>
References: <20240325153141.6816-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 25 Mar 2024 21:01:31 +0530, Anup Patel wrote:
> This series adds support more ISA extensions namely: Zbc, scalar crypto,
> vector crypto, Zfh[min], Zihintntl, Zvfh[min], and Zfa. The series also
> adds a command-line option to disable SBI STA extension for Guest/VM.
> 
> These patches can also be found in the riscv_more_exts_v2 branch at:
> https://github.com/avpatel/kvmtool.git
> 
> [...]

Applied to kvmtool (master), thanks!

[01/10] Sync-up headers with Linux-6.8 for KVM RISC-V
        https://git.kernel.org/will/kvmtool/c/9968468141fc
[02/10] kvmtool: Fix absence of __packed definition
        https://git.kernel.org/will/kvmtool/c/f8c9614c4696
[03/10] riscv: Add Zbc extension support
        https://git.kernel.org/will/kvmtool/c/8b4cc7051393
[04/10] riscv: Add scalar crypto extensions support
        https://git.kernel.org/will/kvmtool/c/d9052a965a22
[05/10] riscv: Add vector crypto extensions support
        https://git.kernel.org/will/kvmtool/c/65b58f723ec3
[06/10] riscv: Add Zfh[min] extensions support
        https://git.kernel.org/will/kvmtool/c/bd7f13c1a19f
[07/10] riscv: Add Zihintntl extension support
        https://git.kernel.org/will/kvmtool/c/fce2865286b5
[08/10] riscv: Add Zvfh[min] extensions support
        https://git.kernel.org/will/kvmtool/c/5a64c1eadf79
[09/10] riscv: Add Zfa extensiona support
        https://git.kernel.org/will/kvmtool/c/9cf213d609bc
[10/10] riscv: Allow disabling SBI STA extension for Guest
        https://git.kernel.org/will/kvmtool/c/d38c8f76ebe2

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

