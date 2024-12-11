Return-Path: <kvm+bounces-33526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 541F99EDA00
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 23:36:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6F822814A9
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 22:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 996441F2C39;
	Wed, 11 Dec 2024 22:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+b5rokY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00F6203D5C
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 22:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733956360; cv=none; b=UFGHS1b5dg+94wn2x9+X1aFsWz5N/r+Tu62kL4OdKyvxuMb2EPUS7e8rFQtoJ42LiW7jNdsCZTA/5yiHepkuR4NG4cRuN7Fn61u7x2qk509BuTZ1NR/yw6rpPj69ukbgHfx+77ts+MevgRhj73jj82u5Das6Ps57C+HrrCKFSwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733956360; c=relaxed/simple;
	bh=jp4Hkfu9jwxRbaUjCfVLhfbjcNqPwXBnLrsEXVYRfdA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=galmo+vKJUKht1ko6ePhQJAzHVGkTzJwJQc7ysi3KYM9jLlEFzbp9u18NnwNJLCtLnpW/78EiSV7XN5qXmGsEiZ4+W92xbFV+AWeTCSp0+YHryb7jnQWzg8Dt4YMJjTNzC0coaSMV08mU4aH+dzIGrjUJiWorMajYSczZUx70pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+b5rokY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F3DC4AF0F;
	Wed, 11 Dec 2024 22:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733956360;
	bh=jp4Hkfu9jwxRbaUjCfVLhfbjcNqPwXBnLrsEXVYRfdA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=b+b5rokYnQRfbPzTwJMTXZQG+EHiJjJGg1+IUOPGp/n0Wvx+ijSowiC9UHhxhBpxy
	 DZ8iD0RuWsgcRECVKgBTOlopvKBqcJoSBIo66KDkddUjm3X9HkKQx8TGNZm5iKacJA
	 T1dT/D4yM2CcTfsmISse0USBHWmqNQ/rn/1skaJcebMKvv1WVqq8kIlNhxylUEubwE
	 chfTOUNXXWA0rRMo2zBnws4AjNRn1PnnYvDHTktKDQJXrqpBgKIVkvcPnLwYXAgRWh
	 Dy0pSrtJy3l3/deM0PTrS7Ca8pgE3JM5+8uZSgt35aKVogl+Ht06F3d7xwIL8ePENC
	 EkbRgOLSfHoyQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70FE3380A965;
	Wed, 11 Dec 2024 22:32:57 +0000 (UTC)
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
 <173395637624.1729195.9518811719329670075.git-patchwork-notify@kernel.org>
Date: Wed, 11 Dec 2024 22:32:56 +0000
References: <CAAhSdy1iTNc5QG34ceebMzA137-pNGzTva33VQ83j-yMoaw8Fg@mail.gmail.com>
In-Reply-To: <CAAhSdy1iTNc5QG34ceebMzA137-pNGzTva33VQ83j-yMoaw8Fg@mail.gmail.com>
To: Anup Patel <anup@brainfault.org>
Cc: linux-riscv@lists.infradead.org, pbonzini@redhat.com, palmer@dabbelt.com,
 palmer@rivosinc.com, ajones@ventanamicro.com, atishp@atishpatra.org,
 atishp@rivosinc.com, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org

Hello:

This pull request was applied to riscv/linux.git (fixes)
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



