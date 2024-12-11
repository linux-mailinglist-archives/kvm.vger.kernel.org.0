Return-Path: <kvm+bounces-33523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9957D9ED9C7
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 23:32:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F16B1662BB
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 22:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E858C1D8A0B;
	Wed, 11 Dec 2024 22:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RDlVokYh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3D51F2388;
	Wed, 11 Dec 2024 22:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733956336; cv=none; b=ZtLHmRUgiZvriMOTkBfiOH7TgvdZGiWRUIbPDKcyYn0VG65K91o7HQQxC/bHIHn8Q7VHmth65zwTfKxrLU8KsVdAksoT3zzTOZ5qJbkbOGzyHbZYMG8GmPXIzGtljwbjHzn+GWkq7LmULVE9xSYrUeK2HWqamU5um2p2eD6PZQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733956336; c=relaxed/simple;
	bh=awhd+qYBZdWAIqJRcAxRI8ocm3yOwTpT8RsZsQR3PAk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=G1EaeKvyRhfSYJi7Pb85jVFOfDe8pu2XBz0gHAQLraL0a3IMQx2Z/cY++zvDCT0QYE1iB1pdC80Mbn6SwvuydRVpASunaspLiFNmErwzm2H6yX/hXZAY/VmB49qv/AbhaTeF4ZYDn1WNlY7wmR5wXRCfT1Wb6CDemf9jMmiW4Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RDlVokYh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BF6C4CED2;
	Wed, 11 Dec 2024 22:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733956335;
	bh=awhd+qYBZdWAIqJRcAxRI8ocm3yOwTpT8RsZsQR3PAk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=RDlVokYh0l4AVx9EUxhtB7Pl4dZihyS9aPE4663P+x5ykYHBIc9Ir1CrrdeDXtzsp
	 iwQwrJx/XOQMKP3c7yqhem1/iuE6FN0OUfXvl0ipFE42Hhea+t+EqAkvqFCjYqNGyR
	 KCZnki4f6Pqba1ciquWr69X8whEgMReywX3iFv3/dpNSOczT8LePmK+pmflbCq86BK
	 nCkOguK4Mf3Xb9+0/gJTuirhA9N+uawZaztOziKAnOUhyHKobudckD0JSnzr7HFzyD
	 vvd0EPNUT6ie9EfVyom9Ue5ajs3C2ICsPvYKbY2faMDnnksBMPkcVWSVZTbwLPQ4Os
	 N4V4Z9+pQUc0g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 34141380A965;
	Wed, 11 Dec 2024 22:32:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v8 0/5] Add Svade and Svadu Extensions Support
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <173395635176.1729195.3092998721998204770.git-patchwork-notify@kernel.org>
Date: Wed, 11 Dec 2024 22:32:31 +0000
References: <20240726084931.28924-1-yongxuan.wang@sifive.com>
In-Reply-To: <20240726084931.28924-1-yongxuan.wang@sifive.com>
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, greentime.hu@sifive.com,
 vincent.chen@sifive.com, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu

Hello:

This series was applied to riscv/linux.git (fixes)
by Anup Patel <anup@brainfault.org>:

On Fri, 26 Jul 2024 16:49:25 +0800 you wrote:
> Svade and Svadu extensions represent two schemes for managing the PTE A/D
> bit. When the PTE A/D bits need to be set, Svade extension intdicates that
> a related page fault will be raised. In contrast, the Svadu extension
> supports hardware updating of PTE A/D bits. This series enables Svade and
> Svadu extensions for both host and guest OS.
> 
> Regrading the mailing thread[1], we have 4 possible combinations of
> these extensions in the device tree, the default hardware behavior for
> these possibilities are:
> 1) Neither Svade nor Svadu present in DT => It is technically
>    unknown whether the platform uses Svade or Svadu. Supervisor
>    software should be prepared to handle either hardware updating
>    of the PTE A/D bits or page faults when they need updated.
> 2) Only Svade present in DT => Supervisor must assume Svade to be
>    always enabled.
> 3) Only Svadu present in DT => Supervisor must assume Svadu to be
>    always enabled.
> 4) Both Svade and Svadu present in DT => Supervisor must assume
>    Svadu turned-off at boot time. To use Svadu, supervisor must
>    explicitly enable it using the SBI FWFT extension.
> 
> [...]

Here is the summary with links:
  - [v8,1/5] RISC-V: Add Svade and Svadu Extensions Support
    https://git.kernel.org/riscv/c/94a7734d0967
  - [v8,2/5] dt-bindings: riscv: Add Svade and Svadu Entries
    https://git.kernel.org/riscv/c/b8d481671703
  - [v8,3/5] RISC-V: KVM: Add Svade and Svadu Extensions Support for Guest/VM
    https://git.kernel.org/riscv/c/97eccf7db4f2
  - [v8,4/5] KVM: riscv: selftests: Fix compile error
    (no matching commit)
  - [v8,5/5] KVM: riscv: selftests: Add Svade and Svadu Extension to get-reg-list test
    https://git.kernel.org/riscv/c/c74bfe4ffe8c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



