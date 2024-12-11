Return-Path: <kvm+bounces-33524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AAA949ED9CF
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 23:33:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0681F1663D1
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 22:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 222861F37BE;
	Wed, 11 Dec 2024 22:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tydqQ+z9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A751F37CC;
	Wed, 11 Dec 2024 22:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733956339; cv=none; b=RxppTEsmt8cX8iI+yboyCwEdtnlmCqDFI2joT/QR9RgMBwFcm38hNAAjxsMraawF+2XqJH1IU6LBCchSeXOOQ5be1yjh1oNtmPN5UZG3tg9KjR0LzA9d7b9BjyP4eItWnTQ9+/Uef5JzQt81jbtr+6eN8cixdC9mJw1q+hNlVM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733956339; c=relaxed/simple;
	bh=FYl5IF1xeB37ngsUbCx+/Kpy7r9qTtKr20+KIGXrOb8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=QKO4/HBS4kxCIQnvDj1z4Vv1aT4S8HTOvsz4EmTx0Tu0pMjuhMoU06jpddWmgcCskV85+09VqyYflxsAf/xgCCR5mJ2J74c1ty3C2pbXdc1HVR1ht93W5rWhQxp+KeuJQktlYI04YZqq/UtCBtVaK94Bethw9l4be8tkvLoApr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tydqQ+z9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D44C4CED3;
	Wed, 11 Dec 2024 22:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733956338;
	bh=FYl5IF1xeB37ngsUbCx+/Kpy7r9qTtKr20+KIGXrOb8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=tydqQ+z9Dkc3NAH6mMGRBaGgg2CIMNMA6zMwA9v6e5VQxCkCIRdDWcFgMpFs8tKII
	 Q3FpbdUZjalVezQB87ujOUgolmwubdSTmeMMcArB+wG690Xhx5siiFL2KpW99gJmwm
	 jnsJ4/0h9UG7BQ8OdZjqQ/aKG695kePySm0vDOiirdVfMc7R1f5YY/knKgkeNjNRxb
	 mQIJYBGAnFM1BJqfq4C3G/kJ1ZG+xAZ9f4uECEsIe+8GMClTfadTHN4O2r1xOtpcmO
	 pGF4KVaSvOlXriKtHyqpY75VBlWBBRs1vuCKvOpldJGV1uIgM5wmRP6PAjk9DlBorq
	 qFQHrufWJR6SA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EC12D380A965;
	Wed, 11 Dec 2024 22:32:35 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 0/2] riscv: Add perf support to collect KVM guest
 statistics from host side
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <173395635475.1729195.2011997217327179366.git-patchwork-notify@kernel.org>
Date: Wed, 11 Dec 2024 22:32:34 +0000
References: <cover.1728980031.git.zhouquan@iscas.ac.cn>
In-Reply-To: <cover.1728980031.git.zhouquan@iscas.ac.cn>
To: Quan Zhou <zhouquan@iscas.ac.cn>
Cc: linux-riscv@lists.infradead.org, anup@brainfault.org,
 ajones@ventanamicro.com, atishp@atishpatra.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, mark.rutland@arm.com,
 alexander.shishkin@linux.intel.com, jolsa@kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-perf-users@vger.kernel.org

Hello:

This series was applied to riscv/linux.git (fixes)
by Anup Patel <anup@brainfault.org>:

On Tue, 15 Oct 2024 16:42:18 +0800 you wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> Add basic guest support to RISC-V perf, enabling it to distinguish
> whether PMU interrupts occur in the host or the guest, and then
> collect some basic guest information from the host side
> (guest os callchain is not supported for now).
> 
> [...]

Here is the summary with links:
  - [v5,1/2] riscv: perf: add guest vs host distinction
    https://git.kernel.org/riscv/c/5bb5ccb3e8d8
  - [v5,2/2] riscv: KVM: add basic support for host vs guest profiling
    https://git.kernel.org/riscv/c/eded6754f398

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



