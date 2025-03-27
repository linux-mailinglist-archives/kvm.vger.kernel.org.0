Return-Path: <kvm+bounces-42097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E60BA72922
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 04:26:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D3183BCE1C
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 03:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C56F1DB12E;
	Thu, 27 Mar 2025 03:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hfRxvIVK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C222D1B0411;
	Thu, 27 Mar 2025 03:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743045854; cv=none; b=nogez1kovOc90ahY5yjipXkDn2VwZZx7o0wHmAnaaVcHDE7JuJ9yGzDeRH+Wcc//Po190a8jHKKb3O7gwgTJLd9Rls6IAD6k9CukPf24vd4wMsEc9jPuMZNlXZzyPn6MV848ojVt4FZJVF0+dKadwQviGeVDJ9gBd6Cuff3nVrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743045854; c=relaxed/simple;
	bh=s6pd1Oapn/Xfy41cHLXqSj8prrh5zDyVA8M/EDhHlgs=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=UxBBnZ+syhGBPp7dSbsTv6Jlr41KFR47d27QfozfXo8k8ovIdI7ECSaNUkZ7JYFcyHXjyCi1TSfj+C2Dh7nXd8yAYPz0s/pGfO1L4moogPhiAl4iRU++/JT7aCRhOhpG6I1PV7YyZ9zSC2heU8m3JolArNDOIenMTvExjSC52QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hfRxvIVK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA39C4CEE4;
	Thu, 27 Mar 2025 03:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743045854;
	bh=s6pd1Oapn/Xfy41cHLXqSj8prrh5zDyVA8M/EDhHlgs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=hfRxvIVKwgGJtyuPK+0oKDZSb1KxlnOVeIBJeZhSNGuI6H7h+9gUTo4PcGPhdxLz0
	 WtSiWr9hZkY/nCNREHOe0XclKw81ICoJoJOW2Ie4e8QLZXBm6S1ticvtHeEjrVShnh
	 pFF0aqqmo5X/DEUMTYiMD4zOUoq0QRSS0ea2cDhI5D+i0nORrbqk+5/pRH22wf8ht0
	 CCxPN0cHXLUKJfY2QO7p/89YsXkOQNN/y2FQXYbELDLqK+cg1Vjz/+/ywwg1/z+Stu
	 CfR5wuqZmO7whx31SbbxG/vh5bPozAWcx5ReazxhtNheknvmCyQBhyZHavbBCXnLfW
	 21MVAcUn/gYtQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33BEA380AAFD;
	Thu, 27 Mar 2025 03:24:52 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] riscv: KVM: Remove unnecessary vcpu kick
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <174304589076.1549280.903710261634215317.git-patchwork-notify@kernel.org>
Date: Thu, 27 Mar 2025 03:24:50 +0000
References: <20250221104538.2147-1-xiangwencheng@lanxincomputing.com>
In-Reply-To: <20250221104538.2147-1-xiangwencheng@lanxincomputing.com>
To: BillXiang <xiangwencheng@lanxincomputing.com>
Cc: linux-riscv@lists.infradead.org, anup@brainfault.org,
 ajones@ventanamicro.com, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, atishp@atishpatra.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 rkrcmar@ventanamicro.com

Hello:

This patch was applied to riscv/linux.git (for-next)
by Anup Patel <anup@brainfault.org>:

On Fri, 21 Feb 2025 18:45:38 +0800 you wrote:
> Remove the unnecessary kick to the vCPU after writing to the vs_file
> of IMSIC in kvm_riscv_vcpu_aia_imsic_inject.
> 
> For vCPUs that are running, writing to the vs_file directly forwards
> the interrupt as an MSI to them and does not need an extra kick.
> 
> For vCPUs that are descheduled after emulating WFI, KVM will enable
> the guest external interrupt for that vCPU in
> kvm_riscv_aia_wakeon_hgei. This means that writing to the vs_file
> will cause a guest external interrupt, which will cause KVM to wake
> up the vCPU in hgei_interrupt to handle the interrupt properly.
> 
> [...]

Here is the summary with links:
  - [v2] riscv: KVM: Remove unnecessary vcpu kick
    https://git.kernel.org/riscv/c/d252435aca44

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



