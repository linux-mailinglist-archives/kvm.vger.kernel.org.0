Return-Path: <kvm+bounces-54354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AC300B1FC70
	for <lists+kvm@lfdr.de>; Sun, 10 Aug 2025 23:40:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 88A264E1BDF
	for <lists+kvm@lfdr.de>; Sun, 10 Aug 2025 21:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A45F29B224;
	Sun, 10 Aug 2025 21:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uv6lCp66"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5565429ACFD
	for <kvm@vger.kernel.org>; Sun, 10 Aug 2025 21:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754862030; cv=none; b=ol0yw/xlEsUwbzM4nVt8bYxfGhdFdDjxi7cKSxbmhcuUwHQa48L1Qzt/6tdtiutEyGUm+GZYw4f5KoDRwoG4dkWCHFtTndPN8/MAVGhfTBK+QEo6dK0+vOULiEJosEvIvxGR2vmvRzCq+1sYiQAaXz35t6s/3+SRKrR1TwJG2Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754862030; c=relaxed/simple;
	bh=Fijcsa/lBkF0yn2nOI1I1ALk4S3Ym5/9LXKLrjvgt4M=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=tQm7vIIThv1T8RPDO+P287kEqNRJGPZRg8f5NJ+klPtLzGTSDlVj6zm01crKKfQmi14O14rYuUd8uUzyR/maNTuCz5lgHHuwG5R+Hh22MFPypHkOE8hVgFiKB2/tzWx/DgXcvheTSQfS9yN+bOu0whAyexLe7V7ZFOUvyls2zvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uv6lCp66; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB85EC4CEEB;
	Sun, 10 Aug 2025 21:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754862029;
	bh=Fijcsa/lBkF0yn2nOI1I1ALk4S3Ym5/9LXKLrjvgt4M=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Uv6lCp66svp6z1/9IMgCByLzV5cnx+AfDqNGD1mYntQilkGFkXGWkPo8bcuhuT6t9
	 Wl4NHBITEOhqOY8omlGfspSMbQXkhLm8VnaWSNLsMe3BzTv9SeoOxqHtMMHztIbKM9
	 CiftrrHFRkJm2dqb+XlcF54SDDl9bjK2pwcqvec/i+jmUthJFd8W+T2/NXzXa2z02c
	 +f93TpkJNjjDhRxrBbo97SJFs0xiyeOua9gPrbO7pGJcRlaNYKSUdz+FmlnsbC5x78
	 BJDEF9ZKqpEauUnibMWf9E6fCOMmBcxbZUimUDvdjMzmzPumuN44gzxelt5RJ1+u7e
	 aFPPfjZNHuCvg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADCDE39D0C2B;
	Sun, 10 Aug 2025 21:40:43 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL v2] KVM/riscv changes for 6.17
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <175486204250.1221929.3641072096313977215.git-patchwork-notify@kernel.org>
Date: Sun, 10 Aug 2025 21:40:42 +0000
References: 
 <CAAhSdy1084USuM+k9T-AP7X_=s7x+WFv++U0PkjVojbPbjRCrw@mail.gmail.com>
In-Reply-To: 
 <CAAhSdy1084USuM+k9T-AP7X_=s7x+WFv++U0PkjVojbPbjRCrw@mail.gmail.com>
To: Anup Patel <anup@brainfault.org>
Cc: linux-riscv@lists.infradead.org, pbonzini@redhat.com, palmer@dabbelt.com,
 ajones@ventanamicro.com, atishp@rivosinc.com, atish.patra@linux.dev,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org

Hello:

This pull request was applied to riscv/linux.git (for-next)
by Paolo Bonzini <pbonzini@redhat.com>:

On Tue, 29 Jul 2025 17:04:22 +0530 you wrote:
> Hi Paolo,
> 
> We have the following KVM RISC-V changes for 6.17:
> 1) Enabled ring-based dirty memory tracking
> 2) Improved "perf kvm stat" to report interrupt events
> 3) Delegate illegal instruction trap to VS-mode
> 4) MMU related improvements for KVM RISC-V for the
>     upcoming nested virtualization support
> 
> [...]

Here is the summary with links:
  - [GIT,PULL,v2] KVM/riscv changes for 6.17
    https://git.kernel.org/riscv/c/65164fd0f6b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



