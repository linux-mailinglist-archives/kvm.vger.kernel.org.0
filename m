Return-Path: <kvm+bounces-27767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6420B98BB49
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 13:35:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E0A52B227E6
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 11:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CD561C1AC2;
	Tue,  1 Oct 2024 11:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="os0je07S"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E5E1C232C;
	Tue,  1 Oct 2024 11:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727782513; cv=none; b=TWWTcy3VRQxtslHAmNEZGzahfKsENkpWk8PsmflsgH0M875j4dx6o3IrBU9Ec0/9WrqgBxfnP8Wo9OgB3FttAHdzqeceWxZnOH1zPaSLsSvIvUpLt7DrG2FhTQFLPmMW096cmTe1S1knW/s1SBSULJ4AV/CeyMc0oa05xbXEToM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727782513; c=relaxed/simple;
	bh=pBM/wRL+lfqLhqTemX0sqxKvvLKDtdNuxSbpmzXLsPo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Yes5BtVj2KIrbLuV1OlKLnKm+YXcx3Mm6KLgD/BO3YmIG8zqfXjdnI/QqESVSUNTmashthPfIQfFApknDNaWV/lnEcbX0P2eIlAfyz8ZhTytEIUgW4+coJBjQgCtxD9//OU5rY3EhY0z61i6juK76AmZ668r9BnYo705nlNElJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=os0je07S; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992EAC4CED4;
	Tue,  1 Oct 2024 11:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727782512;
	bh=pBM/wRL+lfqLhqTemX0sqxKvvLKDtdNuxSbpmzXLsPo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=os0je07SN2Twab2iTA8ds5jr5JW69ruk1XqE3xb887+DUhf0QhosCpCTIvz2a5+TK
	 Ppw83M5V7LN7ldTX3hdVnSbmVQ5lU6mpfyexuwL+RARDfnO3u4btb6l7EDgFMD2aJ5
	 4tI1ECVeFf4dcugk3dcrFa5EnYLtPuYlTxiEQ+n9kBdtvSFAqVNPyFJu7oNhV3zIie
	 j6gm9qzNsy4z8phLxWGFRq3Q+TMYPSJfxipRmEWoMZDeWukP8fs4lB2S3YGAs4XIO1
	 Doxoc2jxb3CvAHA6e1pDj6RBg88fMwtHzDgwOwBawIBoy9Q43He/7u9et/aTvHXxft
	 8ehcGc3P0bn0g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB832380DBF7;
	Tue,  1 Oct 2024 11:35:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] Fixes for KVM PMU trap/emulation
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <172778251574.314421.15171056255748157228.git-patchwork-notify@kernel.org>
Date: Tue, 01 Oct 2024 11:35:15 +0000
References: <20240816-kvm_pmu_fixes-v1-0-cdfce386dd93@rivosinc.com>
In-Reply-To: <20240816-kvm_pmu_fixes-v1-0-cdfce386dd93@rivosinc.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-riscv@lists.infradead.org, anup@brainfault.org,
 atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, ajones@ventanamicro.com, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org

Hello:

This series was applied to riscv/linux.git (fixes)
by Anup Patel <anup@brainfault.org>:

On Fri, 16 Aug 2024 00:08:07 -0700 you wrote:
> This series contains two small fixes to improve the KVM PMU trap/emulation
> code. The issue can be observed if SBI PMU is disabled or forced the kvm
> to use hpmcounter31.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
> Atish Patra (2):
>       RISC-V: KVM: Allow legacy PMU access from guest
>       RISC-V: KVM: Fix to allow hpmcounter31 from the guest
> 
> [...]

Here is the summary with links:
  - [1/2] RISC-V: KVM: Allow legacy PMU access from guest
    https://git.kernel.org/riscv/c/7d1ffc8b087e
  - [2/2] RISC-V: KVM: Fix to allow hpmcounter31 from the guest
    https://git.kernel.org/riscv/c/5aa09297a3dc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



