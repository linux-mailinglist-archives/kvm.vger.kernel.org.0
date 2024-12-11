Return-Path: <kvm+bounces-33529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D09699EDA5B
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 23:49:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 893B9167B71
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 22:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E7C71F2388;
	Wed, 11 Dec 2024 22:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VwuRZL7h"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6861DD885
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 22:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957333; cv=none; b=aGdiiA58pRow3x55FnBYFr+EYUwk58tzF+Ha7eueosHOoUu/qgztnbn3pU2rbxEX0ReolKi7YNVgpNM4CKOYstqp3HpFslHVf79fh/L/ZiiIaNLoqCZRMJq92mKsEIS4kOHxxJ9o8RxqeMNoT/tibks3cYlk0IRxCpEKhixozh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957333; c=relaxed/simple;
	bh=acGfeI0YRpuxvMx+0wvb7CKvqFMzbYj83Gfj/IHzt/k=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=A/OXOR3FyBHUD9l7QNbI+66C7GXeqiR1faGDB2khxxxpU4xHo+mWVxUaFYu8J3jXNgSacIXdCmuPQYswVk69N5ILy9QM/npIOoXoregzPNl/MGiyZZ65AdrJQ3ToUbLrADbrP177yfqKfAjswP0WrzgqZIW+u2nEdEOjW/msoJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VwuRZL7h; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730A8C4CED2;
	Wed, 11 Dec 2024 22:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733957332;
	bh=acGfeI0YRpuxvMx+0wvb7CKvqFMzbYj83Gfj/IHzt/k=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=VwuRZL7hzOzelB/yF7WX1leHtcROppgi4k6lZ6fqicnkU7BncIzoDDEEOPAOde8A7
	 Lxyru9MlWdNbyLM4GTzPITzxTkifOamHejip5xmdL85k4JKn/gDxNnc/I85mvofOYW
	 fH0cfkG5azyYUsqNw/Apj/TDLsbs8fQFkYM4kTx3xmKOTmMIfH8je8jg3twMmwIUAP
	 2blbqyanq5DQ5N64VwWNdMVf9oOIur9LpGOAAeRYqgKdAww1k9N4G/uJzlJ3rdWe0a
	 nEDhsz+NzK5G1KRsASDB2jUphDNrhABKG+SYCeP5Q26NCFAx/pOnyZauP4BdNvCibc
	 KMDaCK7MmZMNw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADCB7380A965;
	Wed, 11 Dec 2024 22:49:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] KVM/riscv changes for 6.13
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <173395734850.1729195.10005899360469788312.git-patchwork-notify@kernel.org>
Date: Wed, 11 Dec 2024 22:49:08 +0000
References: <CAAhSdy1iTNc5QG34ceebMzA137-pNGzTva33VQ83j-yMoaw8Fg@mail.gmail.com>
In-Reply-To: <CAAhSdy1iTNc5QG34ceebMzA137-pNGzTva33VQ83j-yMoaw8Fg@mail.gmail.com>
To: Anup Patel <anup@brainfault.org>
Cc: linux-riscv@lists.infradead.org, pbonzini@redhat.com, palmer@dabbelt.com,
 palmer@rivosinc.com, ajones@ventanamicro.com, atishp@atishpatra.org,
 atishp@rivosinc.com, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org

Hello:

This pull request was applied to riscv/linux.git (for-next)
by Paolo Bonzini <pbonzini@redhat.com>:

On Fri, 8 Nov 2024 17:07:34 +0530 you wrote:
> Hi Paolo,
> 
> We have the following KVM RISC-V changes for 6.13:
> 1) Accelerate KVM RISC-V when running as a guest
> 2) Perf support to collect KVM guest statistics from host side
> 
> In addition, the pointer masking support (Ssnpm and
> Smnpm) for KVM guest is going through the RISC-V tree.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] KVM/riscv changes for 6.13
    https://git.kernel.org/riscv/c/e3e0f9b7ae28

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



