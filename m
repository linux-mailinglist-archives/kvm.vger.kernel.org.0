Return-Path: <kvm+bounces-50698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9291CAE862F
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:21:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B95173B3281
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 14:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B1F264618;
	Wed, 25 Jun 2025 14:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E7GJaO4R"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FF278F54;
	Wed, 25 Jun 2025 14:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750861180; cv=none; b=QHqe8Nd2LNXKAOTpL1EhjGKkz3+yTICaqQD9AahlpGxXq5bvpFmlI+V/iNmNVuN7HepZM7PT/CEX1LIyf5j9SVnHpV0TSNIMq74XflicXd+iBN9DKYnCCkKpjN4JusyxCZht9klR/sx5rnwbornifSFfxcqbdP5d+igtziL6BHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750861180; c=relaxed/simple;
	bh=g4ArFd+mq5NzwEmHH7H82HIytBCVh2j1tA+eOOIjQ3E=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=QmR0ke49ig0eMamiqnRT2bvzndyZPW8juUeE5N53AG7IykTaGAdrjvBUBAlnm4d/F12y/V/Q0OXyu1TL8PtYUO3K6JLgosBIpPFIIqHOaewxB41+wZFEbN9dKaaA9TeUqJID8abjFKi/q6LUx+o7eUZYEGW/I/aOe0nngzbEYbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E7GJaO4R; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CE9C4CEEA;
	Wed, 25 Jun 2025 14:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750861179;
	bh=g4ArFd+mq5NzwEmHH7H82HIytBCVh2j1tA+eOOIjQ3E=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=E7GJaO4RctEbyOoOCUvcBAsNztHOzSfPvfS43x5dBuK5XgD8KEseQCXN0hiA6zIsO
	 0cG9p2RXIeXJwQExX9t4tEhJ02NomZgciueU9iSh2vH24/8e1CHxktmLMNGwHMUfIt
	 lkIt/IDQV+GpYVEPJJHG8CbXJjbUd/IKHzMXEDNcsc1tJoUn/oSqCr7UTuaHKzdKTF
	 BHfAbu8PB2p7M0Ks2v9CCsywliMON+syXXGBZoIrLaqDpFzrGgrvFIqqucr29k9ozM
	 qJU44MeQeqTj9ilwi9H7Nz+Ow7KSLrc/fpNKCKwjZg211h6mNSUUhZP/58fkhkcDRD
	 RUcCeRV80mnDw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADDB53A40FCB;
	Wed, 25 Jun 2025 14:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 0/3] Move duplicated instructions macros into
 asm/insn.h
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <175086120650.493996.14965405389031258218.git-patchwork-notify@kernel.org>
Date: Wed, 25 Jun 2025 14:20:06 +0000
References: 
 <20250620-dev-alex-insn_duplicate_v5_manual-v5-0-d865dc9ad180@rivosinc.com>
In-Reply-To: 
 <20250620-dev-alex-insn_duplicate_v5_manual-v5-0-d865dc9ad180@rivosinc.com>
To: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: linux-riscv@lists.infradead.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 anup@brainfault.org, atish.patra@linux.dev, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, philmd@linaro.org,
 ajones@ventanamicro.com

Hello:

This series was applied to riscv/linux.git (for-next)
by Palmer Dabbelt <palmer@dabbelt.com>:

On Fri, 20 Jun 2025 20:21:56 +0000 you wrote:
> The instructions parsing macros were duplicated and one of them had different
> implementations, which is error prone.
> 
> So let's consolidate those macros in asm/insn.h.
> 
> v1: https://lore.kernel.org/linux-riscv/20250422082545.450453-1-alexghiti@rivosinc.com/
> v2: https://lore.kernel.org/linux-riscv/20250508082215.88658-1-alexghiti@rivosinc.com/
> v3: https://lore.kernel.org/linux-riscv/20250508125202.108613-1-alexghiti@rivosinc.com/
> v4: https://lore.kernel.org/linux-riscv/20250516140805.282770-1-alexghiti@rivosinc.com/
> 
> [...]

Here is the summary with links:
  - [v5,1/3] riscv: Fix typo EXRACT -> EXTRACT
    https://git.kernel.org/riscv/c/e2d02461b2e2
  - [v5,2/3] riscv: Strengthen duplicate and inconsistent definition of RV_X()
    https://git.kernel.org/riscv/c/771c94605d50
  - [v5,3/3] riscv: Move all duplicate insn parsing macros into asm/insn.h
    https://git.kernel.org/riscv/c/38b566b84cf6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



