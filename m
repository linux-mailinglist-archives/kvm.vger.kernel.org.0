Return-Path: <kvm+bounces-34939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6E18A080AA
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:40:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C53F516956C
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 19:40:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 471A61F8F01;
	Thu,  9 Jan 2025 19:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SeCHI4yW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682DA84039;
	Thu,  9 Jan 2025 19:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736451619; cv=none; b=sgFFqQ66ZLSwG8lq+ViH/hXfgKkSJUpvWhFijpTsTU4nvZ8miAn1r2Nu3/LE9MGvXdblFu6VBDw+aSGWPUBzGXw99082lpXBeSaC9mhRJgr08auNONVGXaCO031uIXzjs5L68pFyPSY3GKlnzXpAAkeRzMCp+RuhJ+YgAHuPjqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736451619; c=relaxed/simple;
	bh=i6ORmYJpmxaqhBl75JVy4C6c/8caHc3WyC29hPfgg8o=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=rwpAtxnOGjdqjRaMqSN8+9zdE4qU0MNdn8ExKEaYioM6763Gns7tONFWi9elRLOA+BIm6gwcXqTgdCGfpWhbyfF04uI4YJ/JEAsRbdpd7npYgMKZ27VCNeWyW1zYix/D2UORnekD0TaP3fN/exL1MZShAwp5GieV/cc9/PnMyLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SeCHI4yW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B86C4CED2;
	Thu,  9 Jan 2025 19:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736451619;
	bh=i6ORmYJpmxaqhBl75JVy4C6c/8caHc3WyC29hPfgg8o=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=SeCHI4yW0db6PRCP8Sjllp7pIAuAEmJDXVqTzsXvRtqLzT5b73kIiait1S/J1QpHr
	 8tbw/ZtSKzRjr2uJ4BYTvicr9jCSCDL0/wWFmwZNGl3AD+Z8LhP4pAI1VZdQcNKdVI
	 lTmEX4EMySPqaqI3gkVzdPcm6yVJUNwMdrdhVhSmVUNVvp5S6kcIZvNNYUrA1mLHPE
	 MS5w8G992B4tjPYn3LOO4S5IQvgU3tB03e24v11Nn0Jb66ON8gp0dXlgphW8UdnlZ9
	 UN8g04ZMSjU8aAx66ijYM+yvFKP1wbHBq1BFaR6iwiv/M3ZQzqXs4V+JaV0Zhe5XYF
	 LCey5mAY3dnTw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB212380A97F;
	Thu,  9 Jan 2025 19:40:41 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/8] Add SBI v3.0 PMU enhancements
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <173645164075.1490121.3552449186878140898.git-patchwork-notify@kernel.org>
Date: Thu, 09 Jan 2025 19:40:40 +0000
References: <20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com>
In-Reply-To: <20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com>
To: Atish Kumar Patra <atishp@rivosinc.com>
Cc: linux-riscv@lists.infradead.org, anup@brainfault.org, will@kernel.org,
 mark.rutland@arm.com, paul.walmsley@sifive.com, palmer@dabbelt.com,
 mchitale@ventanamicro.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, palmer@rivosinc.com, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org

Hello:

This series was applied to riscv/linux.git (fixes)
by Palmer Dabbelt <palmer@rivosinc.com>:

On Tue, 19 Nov 2024 12:29:48 -0800 you wrote:
> SBI v3.0 specification[1] added two new improvements to the PMU chaper.
> 
> 1. Added an additional get_event_info function to query event availablity
> in bulk instead of individual SBI calls for each event. This helps in
> improving the boot time.
> 
> 2. Raw event width allowed by the platform is widened to have 56 bits
> with RAW event v2 as per new clarification in the priv ISA[2].
> 
> [...]

Here is the summary with links:
  - [1/8] drivers/perf: riscv: Add SBI v3.0 flag
    (no matching commit)
  - [2/8] drivers/perf: riscv: Fix Platform firmware event data
    https://git.kernel.org/riscv/c/fc58db9aeb15
  - [3/8] drivers/perf: riscv: Add raw event v2 support
    (no matching commit)
  - [4/8] RISC-V: KVM: Add support for Raw event v2
    (no matching commit)
  - [5/8] drivers/perf: riscv: Implement PMU event info function
    (no matching commit)
  - [6/8] drivers/perf: riscv: Export PMU event info function
    (no matching commit)
  - [7/8] RISC-V: KVM: Implement get event info function
    (no matching commit)
  - [8/8] RISC-V: KVM: Upgrade the supported SBI version to 3.0
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



