Return-Path: <kvm+bounces-42098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EFDC7A7292F
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 04:27:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE20E189D40A
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 03:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A50DF1DB15B;
	Thu, 27 Mar 2025 03:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQJgvNz2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9EB1DD88D;
	Thu, 27 Mar 2025 03:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743045856; cv=none; b=WJkcPxqK7PiuFt47xsTcp6y+gD+jDiNheBhyZ/3/xp4nAU9ynhuQJ3Tq5RJFRlOdKDxzUj618N2Nq0629+WeivR4b3ynragZRSPOBWNeLjH91vBZqYaoFFkAUhOrqTPZaLG6ZZPvfe+Z9HwhDZPMKYiPpseNM+oHc5MWG8x4IcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743045856; c=relaxed/simple;
	bh=pfieFhDpfQvLevcNm0LMhPf+5kEs/vR8/60fuGlDo/s=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=MWUg3KC+vpb1mA2mEiAl4uNTPWKWYvxFKF0chFltxnu2w383NExy1+bR3Xj+QRhy2YAe0k/GEWZZeWI4aOOS679ec0igJEtGP4U/n0xYSzEBw3615VqdbqZ4OE1EMAvxeQx0B3phwyiIumUnWSASxbfiWrITtdisW7638jDoWbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQJgvNz2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE74C4CEDD;
	Thu, 27 Mar 2025 03:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743045856;
	bh=pfieFhDpfQvLevcNm0LMhPf+5kEs/vR8/60fuGlDo/s=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=UQJgvNz2l0z8fqtCdNnyUvqSjVoXL9wFCHHbvvPzybzC9+Gmf923AguCn+7ATs1dB
	 /l2CeBHujWK+xvCJN0M2aMdsKhViozJInjMMHMHuTHdemgu0HYqp/81iWGeZDsLvzd
	 rbyEySOqo0DaqGftGgf/4lE5qQCtgsvJfySatQPTo3xdKaI0+H3NF/GPTdd12tdB4i
	 IkHxpZ5h25C8oY/cPYvhAaPf+y26NAdF9cjddpEqLLo0nWxloMQ5npTdW/W8dkCepw
	 Jeb7lHih+Mj6k6AsS5KBshhrXBx4thVfrpsR6pUdWrEOLVPz8IvjinOfuk6M3fNFAf
	 cIwI8TWsAgfcQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADFB4380AAFD;
	Thu, 27 Mar 2025 03:24:53 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/7] KVM: x86: nVMX IRQ fix and VM teardown cleanups
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <174304589224.1549280.1623157194395422949.git-patchwork-notify@kernel.org>
Date: Thu, 27 Mar 2025 03:24:52 +0000
References: <20250224235542.2562848-1-seanjc@google.com>
In-Reply-To: <20250224235542.2562848-1-seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-riscv@lists.infradead.org, maz@kernel.org, oliver.upton@linux.dev,
 zhaotianrui@loongson.cn, maobibo@loongson.cn, chenhuacai@kernel.org,
 maddy@linux.ibm.com, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, borntraeger@linux.ibm.com,
 frankja@linux.ibm.com, imbrenda@linux.ibm.com, pbonzini@redhat.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, aaronlewis@google.com, jmattson@google.com,
 yan.y.zhao@intel.com, rick.p.edgecombe@intel.com, kai.huang@intel.com,
 isaku.yamahata@intel.com

Hello:

This series was applied to riscv/linux.git (for-next)
by Paolo Bonzini <pbonzini@redhat.com>:

On Mon, 24 Feb 2025 15:55:35 -0800 you wrote:
> This was _supposed_ to be a tiny one-off patch to fix a nVMX bug where KVM
> fails to detect that, after nested VM-Exit, L1 has a pending IRQ (or NMI).
> But because x86's nested teardown flows are garbage (KVM simply forces a
> nested VM-Exit to put the vCPU back into L1), that simple fix snowballed.
> 
> The immediate issue is that checking for a pending interrupt accesses the
> legacy PIC, and x86's kvm_arch_destroy_vm() currently frees the PIC before
> destroying vCPUs, i.e. checking for IRQs during the forced nested VM-Exit
> results in a NULL pointer deref (or use-after-free if KVM didn't nullify
> the PIC pointer).  That's patch 1.
> 
> [...]

Here is the summary with links:
  - [1/7] KVM: x86: Free vCPUs before freeing VM state
    https://git.kernel.org/riscv/c/17bcd7144263
  - [2/7] KVM: nVMX: Process events on nested VM-Exit if injectable IRQ or NMI is pending
    https://git.kernel.org/riscv/c/982caaa11504
  - [3/7] KVM: Assert that a destroyed/freed vCPU is no longer visible
    (no matching commit)
  - [4/7] KVM: x86: Don't load/put vCPU when unloading its MMU during teardown
    (no matching commit)
  - [5/7] KVM: x86: Unload MMUs during vCPU destruction, not before
    (no matching commit)
  - [6/7] KVM: x86: Fold guts of kvm_arch_sync_events() into kvm_arch_pre_destroy_vm()
    (no matching commit)
  - [7/7] KVM: Drop kvm_arch_sync_events() now that all implementations are nops
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



