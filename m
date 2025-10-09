Return-Path: <kvm+bounces-59675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CEB7BC7100
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 03:08:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6BE73E4E0D
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 01:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FB0E1A9F97;
	Thu,  9 Oct 2025 01:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cpsu6soK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65ED419D07A;
	Thu,  9 Oct 2025 01:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759972030; cv=none; b=Hu90+GsipYIPw2QW6YaNCrQThFUFdzfcDbwI5s4Eb3RAUgVsmSUIsdWCYxHaHwizRfZ6usSW+vcEivhUdlgGXlCGnVbxvjaA4GUj0QlGqcWBBmdtBulzPKEH8u5g1qgfX7hpfFOaToDDsvS9ZXRuy4134vahKTaw3FL/QxcJEKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759972030; c=relaxed/simple;
	bh=1CdwuT+kYcmte8eivy456G2ecK75wHvT2qHam+/7tKI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=a+WGCxnojG5f38ScFBOTqU3cgTEdlNDDz3rGl5fzzbDe2TN/R77EXp6JYlvyquV0HdIAcfHNi2ANpUwqdyvoo+XX0JAymQm9FKGDJQpGyrjArywRC3RRvV+UrSD3o1CUFngBAPD81br14dE4VF1x1wd5D0ACSAabNlRiiqbXzfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cpsu6soK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6FAC4CEE7;
	Thu,  9 Oct 2025 01:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759972028;
	bh=1CdwuT+kYcmte8eivy456G2ecK75wHvT2qHam+/7tKI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Cpsu6soKqutgxCtUfPezdkxx5CskZoUCgqzxXo1GLczYtT2CWVv8zYILvo1MH+poW
	 8DhXILNkc/IhfRwPBJ7pkQy0hiD+DaTrCdzXG6qb0D0NXeOCimbRprobtFWuTn47ho
	 tQbo9vk0bTVjq7sibNH0YszQlPI6Jcarcu66BF/sInizjAkBMDCmXfi46DTJc27HSW
	 hcP8a7f9wEppJoIJVEDXf2evkRhdga2TKzVhWETk+l1nHvvhF8r7ZY2NaJEr80vbqL
	 YSkN+7gJaSYfvUVuv4qhYaECiIXdJzyycgv5G4S97GOwlGR0oNXYlAJZEkpT9yJhuT
	 hJ49LeKwxzDEw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70F473A41017;
	Thu,  9 Oct 2025 01:06:58 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 0/8] Add SBI v3.0 PMU enhancements
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <175997201703.3661959.2204934721349838885.git-patchwork-notify@kernel.org>
Date: Thu, 09 Oct 2025 01:06:57 +0000
References: <20250909-pmu_event_info-v6-0-d8f80cacb884@rivosinc.com>
In-Reply-To: <20250909-pmu_event_info-v6-0-d8f80cacb884@rivosinc.com>
To: Atish Kumar Patra <atishp@rivosinc.com>
Cc: linux-riscv@lists.infradead.org, anup@brainfault.org, will@kernel.org,
 mark.rutland@arm.com, paul.walmsley@sifive.com, palmer@dabbelt.com,
 mchitale@ventanamicro.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, seanjc@google.com

Hello:

This series was applied to riscv/linux.git (for-next)
by Anup Patel <anup@brainfault.org>:

On Tue, 09 Sep 2025 00:03:19 -0700 you wrote:
> SBI v3.0 specification[1] added two new improvements to the PMU chaper.
> The SBI v3.0 specification is frozen and under public review phase as
> per the RISC-V International guidelines.
> 
> 1. Added an additional get_event_info function to query event availablity
> in bulk instead of individual SBI calls for each event. This helps in
> improving the boot time.
> 
> [...]

Here is the summary with links:
  - [v6,1/8] drivers/perf: riscv: Add SBI v3.0 flag
    https://git.kernel.org/riscv/c/8c8d0f002b76
  - [v6,2/8] drivers/perf: riscv: Add raw event v2 support
    https://git.kernel.org/riscv/c/656ef2ea30a9
  - [v6,3/8] RISC-V: KVM: Add support for Raw event v2
    https://git.kernel.org/riscv/c/190b74154299
  - [v6,4/8] drivers/perf: riscv: Implement PMU event info function
    https://git.kernel.org/riscv/c/adffbd06d003
  - [v6,5/8] drivers/perf: riscv: Export PMU event info function
    https://git.kernel.org/riscv/c/880fcc329e24
  - [v6,6/8] RISC-V: KVM: No need of explicit writable slot check
    https://git.kernel.org/riscv/c/41f4d0cc331a
  - [v6,7/8] RISC-V: KVM: Implement get event info function
    https://git.kernel.org/riscv/c/e309fd113b9f
  - [v6,8/8] RISC-V: KVM: Upgrade the supported SBI version to 3.0
    https://git.kernel.org/riscv/c/dbdadd943a27

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



