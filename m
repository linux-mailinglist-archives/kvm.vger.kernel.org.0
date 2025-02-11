Return-Path: <kvm+bounces-37844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6C0FA30ADA
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:56:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7370D16790F
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 11:56:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 190C71FAC26;
	Tue, 11 Feb 2025 11:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eRzqGU/P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424281EEA38
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 11:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739274976; cv=none; b=XU++fhcja7U6iFXmoWJO9sVKhDcnhVA3J9qNCettLjogZpOMTzbwkBdib5dzj2y9/bZ9NsFFzzltPzrPXSm0m5IykgDgI96quQeaUQNQuJQMhhqq31w2XW38IogMFI6C45HyiSl52PICMHFD7dsDMxocrok5LhTKTg9J+wELHQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739274976; c=relaxed/simple;
	bh=xQFncEgm4QJRIBcVzR93emAbbAi8gnk+uobjJ7Y5FtM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p1A6JdcYt1RN1G7nIbuWolEkJs37KEikfACeMt9ROB3tE452/NcapYWanPzJehVSbRtr6FVaV5LHsnwTdCv0+zqVjKUfB1d/+7Fj3E3dCkP2RsChi/s1dal4qCj8CnQtlZPGPVerSG7CX838R3+vMAzncGsi5G8Zefvi4SpCwrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eRzqGU/P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92948C4CEE7;
	Tue, 11 Feb 2025 11:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739274975;
	bh=xQFncEgm4QJRIBcVzR93emAbbAi8gnk+uobjJ7Y5FtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRzqGU/PQIxfEkivwenbNB8hMvE//41JrqzmZl6+XhV1N3zim8tIYr9IdKQ/1nznj
	 kr+1rZKA/8x4JdEtcbVQipqiERGUab6or9NiTt4/gBTnLUWYyPsvfUBENpvgEdTZlm
	 sQWuqb8VXVkXylJFL9skuGw3eaKbdzLvKsaJVOSF4srxyn8tjkGep6r85lwHVCnI9/
	 FOAq8HGTizW+UqSGf/RJSE/FyZgXl+s3YKTtzkNvY6NMSRkU/xD/JNEvvSrph7aAj7
	 l9C/CjAjTc11izWd+2TczK6Uug2va6YF6ZKJYiKakBEWzO/LxTNsKINsXiCDk6E5c/
	 yUt1itSqrjkNg==
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
Subject: Re: [kvmtool PATCH 0/6] Add RISC-V ISA extensions based on Linux-6.13
Date: Tue, 11 Feb 2025 11:56:07 +0000
Message-Id: <173927413245.2100000.2379153198496895736.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20250127132424.339957-1-apatel@ventanamicro.com>
References: <20250127132424.339957-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 27 Jan 2025 18:54:18 +0530, Anup Patel wrote:
> This series adds support for new ISA extensions based on Linux-6.13
> namely: Svade, Svadu, Smnpm, and Ssnpm.
> 
> These patches can also be found in the riscv_more_exts_round5_v1 branch
> at: https://github.com/avpatel/kvmtool.git
> 
> Anup Patel (6):
>   Sync-up headers with Linux-6.13 kernel
>   Add __KERNEL_DIV_ROUND_UP() macro
>   riscv: Add Svade extension support
>   riscv: Add Svadu extension support
>   riscv: Add Smnpm extension support
>   riscv: Add Ssnpm extension support
> 
> [...]

Applied to kvmtool (master), thanks!

[1/6] Sync-up headers with Linux-6.13 kernel
      https://git.kernel.org/will/kvmtool/c/4b2cc0660ef3
[2/6] Add __KERNEL_DIV_ROUND_UP() macro
      https://git.kernel.org/will/kvmtool/c/66567918472f
[3/6] riscv: Add Svade extension support
      https://git.kernel.org/will/kvmtool/c/f8ed03217263
[4/6] riscv: Add Svadu extension support
      https://git.kernel.org/will/kvmtool/c/521b1b676e5c
[5/6] riscv: Add Smnpm extension support
      https://git.kernel.org/will/kvmtool/c/4489348c961b
[6/6] riscv: Add Ssnpm extension support
      https://git.kernel.org/will/kvmtool/c/e48563f5c4a4

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

