Return-Path: <kvm+bounces-66310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8246ECCEEAD
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 09:13:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2CBB6302A957
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 08:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634142E1730;
	Fri, 19 Dec 2025 08:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GNMrOCy8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789C72E88A1
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 08:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766131990; cv=none; b=qwONcl+gXMCllSFm9Nbe1KIDH4VuxWsg0xn388GVmC2lMSgDBCw6So4x4CFlR7uAlmbGMbMAns6R7HsuulUHbbDeRMlAt8xHvuIKN5qHMjCWhlYQCp72AsAHzBbWJ8djENAzUTh2rrYm4tc7PvyBENaLR96dcCnK3wJmrj0ZSFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766131990; c=relaxed/simple;
	bh=0McNF3HTg1uqzq/OAoF2HQ2uw2feE5NG+K3Uv59eW6E=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=V/SNU+E3LUpGp5zzD8PKQjvTskKL9Rn51HOMx4ERdb7a66MBs4NUmUAAxB9bWLw2By32cAKjoAg5lpe+nZtbCxu4IZ0MLD+Z1hkdRcbtqB6LoXtW+/bMVduDnNpRgnrUsCMZzCgAdE4B2/ral711hhSPvtwPFqCq2SDrsNA8KHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GNMrOCy8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02541C16AAE;
	Fri, 19 Dec 2025 08:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766131990;
	bh=0McNF3HTg1uqzq/OAoF2HQ2uw2feE5NG+K3Uv59eW6E=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=GNMrOCy8f2un7W21yh9qohZjnM/WmI/ZGzfH8nAMZ0EtjjQ8vFg2/fmN2++GNXZ4B
	 XbI1vqg4aP6Ztfq85SbRsc2TRPZNQCRLk6Bhq1f00gd0fthZNms+4UqyIU4ByF0I5z
	 ulQjgbEyKTq2eJFiOJSanFrsP/RhMXQrGVt1jYrqNNdFcjz+ZDYZ46LTvaOgdD4EF5
	 +XbXg8VACZDp2zvBIK+mbZydYJpAeyo8H5mLGhmfkTJEdh/BANeoltz1oDJNB/7Ehi
	 n5wI6baAuZMRZiqhUDbzLZitffjwg5fsLCWq3CugrcMg7cJnlD0r9BW4dmbHlgl8XN
	 W4oPWGrtyI6lA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3B98D380AA50;
	Fri, 19 Dec 2025 08:10:00 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] KVM/riscv changes for 6.19
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <176613179881.3684357.5605042777950548364.git-patchwork-notify@kernel.org>
Date: Fri, 19 Dec 2025 08:09:58 +0000
References: 
 <CAAhSdy3C7zxovYDZJvzpuCytRmdBrGwgLF2MtOMzP7vFVm4ohQ@mail.gmail.com>
In-Reply-To: 
 <CAAhSdy3C7zxovYDZJvzpuCytRmdBrGwgLF2MtOMzP7vFVm4ohQ@mail.gmail.com>
To: Anup Patel <anup@brainfault.org>
Cc: linux-riscv@lists.infradead.org, pbonzini@redhat.com, palmer@dabbelt.com,
 pjw@kernel.org, ajones@ventanamicro.com, atish.patra@linux.dev,
 atishp@rivosinc.com, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org

Hello:

This pull request was applied to riscv/linux.git (fixes)
by Paolo Bonzini <pbonzini@redhat.com>:

On Fri, 28 Nov 2025 16:39:20 +0530 you wrote:
> Hi Paolo,
> 
> We have the following KVM RISC-V changes for 6.19:
> 1) SBI MPXY support for KVM guest
> 2) New KVM_EXIT_FAIL_ENTRY_NO_VSFILE
> 3) Enable dirty logging gradually in small chunks
> 4) Fix guest page fault within HLV* instructions
> 5) Flush VS-stage TLB after VCPU migration for Andes cores
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] KVM/riscv changes for 6.19
    https://git.kernel.org/riscv/c/63a9b0bc65d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



