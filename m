Return-Path: <kvm+bounces-37151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 638A4A2637B
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 20:17:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 029E93A4AB2
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 19:16:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A8E20B20E;
	Mon,  3 Feb 2025 19:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SwiVodep"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0139020FA9B;
	Mon,  3 Feb 2025 19:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738610123; cv=none; b=u2zPTNLOj8DCYaHpdqtQr7eIy5ddax3R5SEdM5V4TcAtgeyTcJgAQp03wGLD7xBmdnO5eZs2qQToVk9RftElw6XvKOTGZZJEqNJdYED7h0wm/EZuSoTjUkKNgAj34DfZTR32WgziHWz7MSkh/o6o9zQJftZrv7skz2hS5pt14TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738610123; c=relaxed/simple;
	bh=x4p1X9nOXxuhn4jEPid5fzjCvgZ4D3ZQU2ymjtjqU9E=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=mZ3fwM0dNXS2bOaKj39X+DJAFtD0mknAK6JOjiGC5m2sWo0r7IDwBqjS2GWHfIAnL1HzEzy0yX/9ZcUWgjLMrfa6dLGEQdH5gkIdrcuFEen5EGu1fUFVK8SJZE4/reqmzzd3vgMBXIqW+9bRC9gpgilVZm8gM3vpHHWwCtjD3lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SwiVodep; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CCFC4CEE3;
	Mon,  3 Feb 2025 19:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738610122;
	bh=x4p1X9nOXxuhn4jEPid5fzjCvgZ4D3ZQU2ymjtjqU9E=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=SwiVodep/1/nWnRpopWbBGkkYwgqp6zjbivmPprSBDK7KEzSCdK2xq2o+52mpu2gS
	 3zr7qNPdshAge0rXr1UkK0d0mAXUpI6C5KURLWQlqmy5xPSQEXP2peKrPfu9dENBeF
	 q+QHs8EZaSp7fpT9t6Vgp36iZU34R/kSW4Mkw6R0EhsAK+RCRciPYLnz7OBuILt8Am
	 ETjGYMXis2V0Vs6zUv5LGIP2vjtDlRM79Qr7rsaQ6x+eaH1FGxqQd3r8aZDTQ/nUCD
	 B5QbsGm5nrDJVkFPaDDVc5Opb0m7VLr6fZRFl30v+USNqmOxNibUohAJO9AxpoXhrl
	 2uh4Gek08nD7w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33FB5380AA67;
	Mon,  3 Feb 2025 19:15:51 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/3] Collect guest/host statistics during the redirected
 traps
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <173861014984.3409359.10285498075782232366.git-patchwork-notify@kernel.org>
Date: Mon, 03 Feb 2025 19:15:49 +0000
References: <20241224-kvm_guest_stat-v2-0-08a77ac36b02@rivosinc.com>
In-Reply-To: <20241224-kvm_guest_stat-v2-0-08a77ac36b02@rivosinc.com>
To: Atish Kumar Patra <atishp@rivosinc.com>
Cc: linux-riscv@lists.infradead.org, anup@brainfault.org,
 atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, zhouquan@iscas.ac.cn

Hello:

This series was applied to riscv/linux.git (fixes)
by Anup Patel <anup@brainfault.org>:

On Tue, 24 Dec 2024 13:04:52 -0800 you wrote:
> As discussed in the patch[1], this series adds the host statistics for
> traps that are redirected to the guest. Since there are 1-1 mapping for
> firmware counters as well, this series enables those so that the guest
> can collect information about these exits via perf if required.
> 
> I have included the patch[1] as well in this series as it has not been
> applied and there will be likely conflicts while merging both.
> 
> [...]

Here is the summary with links:
  - [v2,1/3] RISC-V: KVM: Redirect instruction access fault trap to guest
    https://git.kernel.org/riscv/c/51c58956732b
  - [v2,2/3] RISC-V: KVM: Update firmware counters for various events
    https://git.kernel.org/riscv/c/2f15b5eaff79
  - [v2,3/3] RISC-V: KVM: Add new exit statstics for redirected traps
    https://git.kernel.org/riscv/c/af79caa83f6a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



