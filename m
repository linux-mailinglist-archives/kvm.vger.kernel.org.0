Return-Path: <kvm+bounces-27768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A255998BB4A
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 13:36:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A9A51F226E2
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 11:36:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F37E1C2458;
	Tue,  1 Oct 2024 11:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m4ZEJ5v7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F08F1C2444
	for <kvm@vger.kernel.org>; Tue,  1 Oct 2024 11:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727782514; cv=none; b=E7HUffHmk4sjP4a2t6thrzOuVl+2w31/HYrN7pAC1oggXVBgTI4hIe++eg1Tfy+v6On4GBTH6A4A4ieZH8MWeRl7dZOb70U4DosAOca9ckiEiZ8/b7UAfYA0eLQ+19vYOGyCQxpxPnwxhRc7wDL0XIJK1Pof0sz9W1XQ2ijhi6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727782514; c=relaxed/simple;
	bh=10YhdOj8ol1a6n0A/twIEKygu8S/PkpyOPh1KoL/Tt0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=IyQipgiKVft8eiVb1ABb2tLSw6py5nBbyY5eyP7UV60R6uegrd/jS+a2cDAOuyJPfhhKRcKiMj/930/x+GeklvI0Lj8GvlzhpAOoyODcR6vA1j/Hj8u7Z8pINuVfcAvtCmRqJWqQ9lGi6S4Z+kFLvBKJCRZpLlg3i69B+zhc0Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m4ZEJ5v7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C631C4CECD;
	Tue,  1 Oct 2024 11:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727782514;
	bh=10YhdOj8ol1a6n0A/twIEKygu8S/PkpyOPh1KoL/Tt0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=m4ZEJ5v77pTy/yBTJE2k9VlW4mkdxnSLPsK4AcC82lEOpM6A68kJaLEoQu/NC0BxU
	 obq9H8uT//6Nl4oVbggUqjBlm5UmMOrtCnh7I25EYVG8cUro6/DX+ljgY1yf5dtYHO
	 //tiEjTuNwCSmvCvgbqlaOqSoh80XXZMehC6IdsvFUAQ/n5OUGylK9MPNbjUP/0IyY
	 9piwK1oEbUOpIlwitdd7oL/9gidKW2BfgszuSBBuqXund2m4Ek/J9pmIBgGiXWd/tK
	 OyRkBqw2lKmZAqEODcQD+acWeo4zFQj944sYU6uJ20th+CuYbi4wt3F6WQJfVdxGNk
	 eg9eRQbTLMtRg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70CA2380DBF7;
	Tue,  1 Oct 2024 11:35:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] RISC-V: KVM: Fix sbiret init before forwarding to userspace
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <172778251701.314421.6304053721280906896.git-patchwork-notify@kernel.org>
Date: Tue, 01 Oct 2024 11:35:17 +0000
References: <20240807154943.150540-2-ajones@ventanamicro.com>
In-Reply-To: <20240807154943.150540-2-ajones@ventanamicro.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, anup@brainfault.org, atishp@atishpatra.org,
 cade.richard@berkeley.edu, jamestiotio@gmail.com

Hello:

This patch was applied to riscv/linux.git (fixes)
by Anup Patel <anup@brainfault.org>:

On Wed,  7 Aug 2024 17:49:44 +0200 you wrote:
> When forwarding SBI calls to userspace ensure sbiret.error is
> initialized to SBI_ERR_NOT_SUPPORTED first, in case userspace
> neglects to set it to anything. If userspace neglects it then we
> can't be sure it did anything else either, so we just report it
> didn't do or try anything. Just init sbiret.value to zero, which is
> the preferred value to return when nothing special is specified.
> 
> [...]

Here is the summary with links:
  - RISC-V: KVM: Fix sbiret init before forwarding to userspace
    https://git.kernel.org/riscv/c/6b7b282e6bae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



