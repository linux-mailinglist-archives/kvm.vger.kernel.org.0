Return-Path: <kvm+bounces-48809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53B3AAD3EDA
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:28:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9620F1721AE
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 16:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E66241C8C;
	Tue, 10 Jun 2025 16:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KFMK9Qrg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C105B241670;
	Tue, 10 Jun 2025 16:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749572879; cv=none; b=ITlcXgVfOlBb31ajHkRt8EVhEL1GNWw87M4NUgrlfedPlFF8huPhWvw2EG3Vt8g4cVEk4f6Q8VQNzjjMPNwPJVj/7SUCeAwogRZ7HxV8F+srFT0ad7rNKTQ+s/sPw5Aayxz4hMnjvtcBU3HLQ5ljR4yTrqA5m7CWMqmJajhibvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749572879; c=relaxed/simple;
	bh=M7AR7P2Hp2v576w27gcBYA1QJAA51vBNSHPVxtZiM1s=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=uyDe03wHJ1zGz97nMCwPFNsCGjD5WNFzTqC3nUSsiZ/zHY+D2TYzUSCAsUdLyNvTeiQk639Lld8WNyh46WhN0qaTqyQYmokC+lTE73v46jeGx9shlpuAYHTvVGNIFokQzVhOSz6RE5LZh+eacwa7EN9vOeEwwG85iALF6jZR4TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KFMK9Qrg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E8CC4CEED;
	Tue, 10 Jun 2025 16:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749572879;
	bh=M7AR7P2Hp2v576w27gcBYA1QJAA51vBNSHPVxtZiM1s=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=KFMK9QrgISSTDvxGudz6a85hexiOz9fN02iUkdTutBUXfp7ygyrWlMCX3ccpZPK2W
	 KyPJaujZxGXU/fxxfBo/GpgldljWm/oRCN+O6S47EHw+r0x70PqoUq9KAHaNbp2vgH
	 QQoBfMnMCwXLwDBYn3M1n3up7KpBSFu/QvhRU5FRX/3xQbnu3H7cvecri1C+npthOt
	 Su3nbFFwtWfwq+nxld3jUukygNRn8ezdtekIXeYAIcMcqDdHn8gI8LwuRS0QLfghMo
	 5vSD15iZiyo1+4z9QrEtDAAgTvZ8fD8H+kyKRr0AKuKh+U5M+miqArQa7nYKoSpz6g
	 +BSqSPYz8Jykg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EADC139D6540;
	Tue, 10 Jun 2025 16:28:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 0/6] KVM: lockdep improvements
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <174957290974.2454024.11071746229021073521.git-patchwork-notify@kernel.org>
Date: Tue, 10 Jun 2025 16:28:29 +0000
References: <20250512180407.659015-1-mlevitsk@redhat.com>
In-Reply-To: <20250512180407.659015-1-mlevitsk@redhat.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
 suzuki.poulose@arm.com, jingzhangos@google.com, hpa@zytor.com,
 sebott@redhat.com, lishusen2@huawei.com, longman@redhat.com,
 tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
 bhelgaas@google.com, bp@alien8.de, anup@brainfault.org, will@kernel.org,
 palmer@dabbelt.com, glider@google.com, kvmarm@lists.linux.dev,
 keisuke.nishimura@inria.fr, yuzenghui@huawei.com, peterz@infradead.org,
 atishp@atishpatra.org, joey.gouly@arm.com, x86@kernel.org, maz@kernel.org,
 seanjc@google.com, andre.przywara@arm.com, jiangkunkun@huawei.com,
 rdunlap@infradead.org, pbonzini@redhat.com, boqun.feng@gmail.com,
 catalin.marinas@arm.com, alex@ghiti.fr, linux-kernel@vger.kernel.org,
 dave.hansen@linux.intel.com, oliver.upton@linux.dev,
 kvm-riscv@lists.infradead.org, mingo@redhat.com, paul.walmsley@sifive.com,
 aou@eecs.berkeley.edu

Hello:

This series was applied to riscv/linux.git (fixes)
by Paolo Bonzini <pbonzini@redhat.com>:

On Mon, 12 May 2025 14:04:01 -0400 you wrote:
> This is	a continuation of my 'extract lock_all_vcpus/unlock_all_vcpus'
> patch series.
> 
> Implement the suggestion of using lockdep's "nest_lock" feature
> when locking all KVM vCPUs by adding mutex_trylock_nest_lock() and
> mutex_lock_killable_nest_lock() and use these functions	in the
> implementation of the
> kvm_trylock_all_vcpus()/kvm_lock_all_vcpus()/kvm_unlock_all_vcpus().
> 
> [...]

Here is the summary with links:
  - [v5,1/6] locking/mutex: implement mutex_trylock_nested
    https://git.kernel.org/riscv/c/c5b6ababd21a
  - [v5,2/6] locking/mutex: implement mutex_lock_killable_nest_lock
    https://git.kernel.org/riscv/c/fb49f07ba1d9
  - [v5,3/6] KVM: add kvm_lock_all_vcpus and kvm_trylock_all_vcpus
    https://git.kernel.org/riscv/c/e4a454ced74c
  - [v5,4/6] x86: KVM: SVM: use kvm_lock_all_vcpus instead of a custom implementation
    https://git.kernel.org/riscv/c/c560bc9286e6
  - [v5,5/6] KVM: arm64: use kvm_trylock_all_vcpus when locking all vCPUs
    https://git.kernel.org/riscv/c/b586c5d21954
  - [v5,6/6] RISC-V: KVM: use kvm_trylock_all_vcpus when locking all vCPUs
    https://git.kernel.org/riscv/c/8f56770d114b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



