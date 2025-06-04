Return-Path: <kvm+bounces-48411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30C78ACE057
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 16:33:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 918D0189A722
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 14:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE23029116F;
	Wed,  4 Jun 2025 14:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IHnAE5oA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD99E291147;
	Wed,  4 Jun 2025 14:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749047556; cv=none; b=AD8V6UCOEC+UOzKkT0Cwz5QW+a8kcKw6HMqda39JClPOv8oPCzsWRqSdNUbbJ/KK85b4G6O+FQnDoKbJQj7FPDLhFVhT9RWKtnORDkdYvO+4AgCdOeXwwKsnwQtFDPPxP4cL3hW12vU27Wru65j4yNYD+CcFBFuUrA7J7tr2AxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749047556; c=relaxed/simple;
	bh=IpQmYI+LTEk5yMKcHxOS33hPu3ZQ3xuwoEnpYV5S2GQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=mNHMEOmxsVtva3E+xNVn0Pvd7S2T5XKCvydgS3MXsPce8u1atARncww+2xAHzuhHZ75rWLptc41Fr7HoNkRwn9GrYrGr/pgBkBNGUaHJd0/RWYCTDj/8f1Ca2poOZNO/Z2xV2cTdmfSWqeBRROVeEdek9tABo3l3MHdqxQWvMBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IHnAE5oA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEC8C4CEE4;
	Wed,  4 Jun 2025 14:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749047556;
	bh=IpQmYI+LTEk5yMKcHxOS33hPu3ZQ3xuwoEnpYV5S2GQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=IHnAE5oAkhaMg8Xz2BVRmid2SlXHCYmWFOTvl2MkkUd2zSFmGViznKr4cBAUM9XY6
	 v2PalVivCpTgoVuTnskBKwAMAk0oJAdtROJl9v9FY8cjvLqtqc7Ssb731gr14aJQKZ
	 XfZ8tw2HriFIoH2TmNjeAL7Ap0xPNGCLIVV5ga8agxLQCYY3JhkYF27JRo0SO7WjS3
	 F311JuD5dJQ4NgOFXAQ/2OWpJqlmWj91Nt6xpDGzkmqtCgEYfwPeyQzePQd9P7hxgN
	 GrgVJ7t8A4VOnukMwl1RBD/k4PSWjjWqSxXug9ECLcwlHwflZ7TtZ1it8d91D8ovc+
	 18rye+BqC1QMg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADCC738111E5;
	Wed,  4 Jun 2025 14:33:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/3] Move duplicated instructions macros into
 asm/insn.h
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <174904758848.2309006.5543819811010216908.git-patchwork-notify@kernel.org>
Date: Wed, 04 Jun 2025 14:33:08 +0000
References: <20250516140805.282770-1-alexghiti@rivosinc.com>
In-Reply-To: <20250516140805.282770-1-alexghiti@rivosinc.com>
To: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: linux-riscv@lists.infradead.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, alex@ghiti.fr, anup@brainfault.org,
 atishp@atishpatra.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org

Hello:

This series was applied to riscv/linux.git (for-next)
by Alexandre Ghiti <alexghiti@rivosinc.com>:

On Fri, 16 May 2025 16:08:02 +0200 you wrote:
> The instructions parsing macros were duplicated and one of them had different
> implementations, which is error prone.
> 
> So let's consolidate those macros in asm/insn.h.
> 
> v1: https://lore.kernel.org/linux-riscv/20250422082545.450453-1-alexghiti@rivosinc.com/
> v2: https://lore.kernel.org/linux-riscv/20250508082215.88658-1-alexghiti@rivosinc.com/
> v3: https://lore.kernel.org/linux-riscv/20250508125202.108613-1-alexghiti@rivosinc.com/
> 
> [...]

Here is the summary with links:
  - [v4,1/3] riscv: Fix typo EXRACT -> EXTRACT
    https://git.kernel.org/riscv/c/00542578d2fd
  - [v4,2/3] riscv: Strengthen duplicate and inconsistent definition of RV_X()
    https://git.kernel.org/riscv/c/9908f88a651e
  - [v4,3/3] riscv: Move all duplicate insn parsing macros into asm/insn.h
    https://git.kernel.org/riscv/c/4f8d6dc47e46

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



