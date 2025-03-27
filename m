Return-Path: <kvm+bounces-42096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC37AA72921
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 04:26:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21BAE189C580
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 03:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 313BF1AF0D6;
	Thu, 27 Mar 2025 03:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTuTnTgn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE181CEAD6
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 03:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743045850; cv=none; b=VwrJBWMLuaqsw+Mrao16O7XmMeFJ7cwIQwqbuqy6VhKbb+sf4yPaFv6UfhZSEY5lN2G/7zWk+ZQpfv0bd9jotmfOceif6xg51/KgLaMzNpjbMZxjerAhcXNAYG6OmUdZuI0uAqu+W8RBPj9EvIzIusCZNyMOc0/bu5mFhHnLerk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743045850; c=relaxed/simple;
	bh=hPKRazVrtA3SSh20Hc2+cwQp6Ty2W0f+p+nm17qHibw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=FIiUxJEjfir87Ygg6K5MBuEpBgRyWwOICKQBJdrYyyyjZULkkNhCoePIYS4DkRBN4wtPQBCWROPRUigx92t/a5dVJhuNI5L7oG2fDSn4ia+Y1E8/9GCeeFVhMNgxKtLBsHqWfnZ8J/wKwX/Nh3wjTgjuBxgvEUTTxTzP1P9lbL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTuTnTgn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21FE9C4CEDD;
	Thu, 27 Mar 2025 03:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743045850;
	bh=hPKRazVrtA3SSh20Hc2+cwQp6Ty2W0f+p+nm17qHibw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=bTuTnTgnOvh+MgtZTOeK2TIR88wiwvKKxbtcE3UfdlB5m4Fzbb3vVspvn8Oy61p+N
	 Ttyu3kBkgiyTUunl8K0rHpmag2mjgs6lRJn/+IraXunSF60i0U15/Nmz7+ze07ijIQ
	 9epftLsWuIlzVGjrNjUnSbSd744CsBbh/8lbfgLp5bZ4z3xftAkFXMPe6nPVdQdfDa
	 1YWkfMpbDJp2c9MTyQhEnkqMT25382QuWww2p+/hRhW10GqhIoyTs6RObnp53H0FnH
	 Qu0OQLD2WfGwPlltFVFPcvxLNgO/5V+hQGxZRFWnWNx2mhODouAr6QWNKhGBWvUvWu
	 aWSw+3QDpJsmA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADE12380AAFD;
	Thu, 27 Mar 2025 03:24:47 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] KVM/riscv fixes for 6.14 take #1
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <174304588624.1549280.15557437967851536574.git-patchwork-notify@kernel.org>
Date: Thu, 27 Mar 2025 03:24:46 +0000
References: <CAAhSdy0Wo4hQ=gnhpJGU-khA4g-0VkfkMECDjnAsq4Fg6xfWjw@mail.gmail.com>
In-Reply-To: <CAAhSdy0Wo4hQ=gnhpJGU-khA4g-0VkfkMECDjnAsq4Fg6xfWjw@mail.gmail.com>
To: Anup Patel <anup@brainfault.org>
Cc: linux-riscv@lists.infradead.org, pbonzini@redhat.com, palmer@dabbelt.com,
 palmer@rivosinc.com, atishp@atishpatra.org, atishp@rivosinc.com,
 ajones@ventanamicro.com, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org

Hello:

This pull request was applied to riscv/linux.git (for-next)
by Paolo Bonzini <pbonzini@redhat.com>:

On Fri, 21 Feb 2025 22:37:42 +0530 you wrote:
> Hi Paolo,
> 
> We have a bunch of SBI related fixes and one fix to remove
> a redundant vcpu kick for the 6.14 kernel.
> 
> Please pull.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] KVM/riscv fixes for 6.14 take #1
    https://git.kernel.org/riscv/c/e93d78e05abb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



