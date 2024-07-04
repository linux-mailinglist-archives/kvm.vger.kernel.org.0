Return-Path: <kvm+bounces-20958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A21F49276E9
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 15:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 567F928206C
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 13:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEA101AED53;
	Thu,  4 Jul 2024 13:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TYcypi+6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1963B1A0AE5;
	Thu,  4 Jul 2024 13:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720098657; cv=none; b=OLqirINuO2Owrt/Up4LZw7m3DotNwcXn9t1pZe/oJQwHFepNwTOoK2xOTEkeh/bzd8JN/e7NYP+aTHLpnk6x1kNmLX2ZW/F6D0lkgRwXPjpqyU+UhrhCjGUTiq8vLJGbRfmnm/6Tb4gViToPdvgWnNmQQ9LM+KOq97Nbx1uoK00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720098657; c=relaxed/simple;
	bh=5Z/JhMWlZOiA4gMPtEvpcd72gMvcEm+EciKo2a/8g/0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Ovmca77DqbNzszTPyc8afsoBHFW60Ned404vvxieX3d7htXQ4aP1/USlG2ZUXqWc9CF4dBjNMMLj/3FPEWNmon+uHqVE2Mr8G61eqR9w1+i8LWkjpASdXkAyBSRyBoSXmn1gfGU8g/o3K6ZaWY5nmth411lbIEHy51WCXO0rt6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TYcypi+6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B8979C4AF07;
	Thu,  4 Jul 2024 13:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720098656;
	bh=5Z/JhMWlZOiA4gMPtEvpcd72gMvcEm+EciKo2a/8g/0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=TYcypi+6JnHBpY4lZ+cKwjZQXSNSWSdg1CMGaYgL6jNS/VWlfNA5H0c8BOxNzmE/u
	 Ken1JVEeKRQvpC6ysrZ/awEHnBd0sHH0w0KO0ZrLT4GH1l8K8HXt9ALEiY0w8sSGpe
	 bKNzYA+Bp+c+CmYrH/zsEsTx2bliYMnRwl/9AkaasfTTlfQ7KQ3kBCpaigfLMdi9WC
	 6MyCwml9mDKAv0Y8HSG8UgLHEtCm86vI4CstzqwIP61t18YHjL9iKipLL4ReikrbOg
	 TwXkGINP5tVXCLqEGHJ8QdsI6OgD9V9T/J3Wy/fHQlz4gh+U+GPISJKRe/o9aAjuVb
	 troCPvtdDExzg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A5FACC43332;
	Thu,  4 Jul 2024 13:10:56 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/3] Assorted fixes in RISC-V PMU driver
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <172009865667.17306.8198164921917389320.git-patchwork-notify@kernel.org>
Date: Thu, 04 Jul 2024 13:10:56 +0000
References: <20240628-misc_perf_fixes-v4-0-e01cfddcf035@rivosinc.com>
In-Reply-To: <20240628-misc_perf_fixes-v4-0-e01cfddcf035@rivosinc.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
 atishp@atishpatra.org, anup@brainfault.org, will@kernel.org,
 mark.rutland@arm.com, paul.walmsley@sifive.com, palmer@dabbelt.com,
 ajones@ventanamicro.com, conor.dooley@microchip.com,
 samuel.holland@sifive.com, palmer@rivosinc.com, alexghiti@rivosinc.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, garthlei@pku.edu.cn

Hello:

This series was applied to riscv/linux.git (fixes)
by Palmer Dabbelt <palmer@rivosinc.com>:

On Fri, 28 Jun 2024 00:51:40 -0700 you wrote:
> This series contains 3 fixes out of which the first one is a new fix
> for invalid event data reported in lkml[2]. The last two are v3 of Samuel's
> patch[1]. I added the RB/TB/Fixes tag and moved 1 unrelated change
> to its own patch. I also changed an error message in kvm vcpu_pmu from
> pr_err to pr_debug to avoid redundant failure error messages generated
> due to the boot time quering of events implemented in the patch[1]
> 
> [...]

Here is the summary with links:
  - [v4,1/3] drivers/perf: riscv: Do not update the event data if uptodate
    https://git.kernel.org/riscv/c/a3f24e83d11d
  - [v4,2/3] drivers/perf: riscv: Reset the counter to hpmevent mapping while starting cpus
    https://git.kernel.org/riscv/c/7dd646cf745c
  - [v4,3/3] perf: RISC-V: Check standard event availability
    https://git.kernel.org/riscv/c/16d3b1af0944

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



