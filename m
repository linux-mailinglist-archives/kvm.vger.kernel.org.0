Return-Path: <kvm+bounces-23439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4BC3949917
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 22:29:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 72415B2553C
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 20:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E07F163AA7;
	Tue,  6 Aug 2024 20:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MsZlLR7x"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3E5154456;
	Tue,  6 Aug 2024 20:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722976132; cv=none; b=r9Nk4wLdLrX+Q8pxo6JvdOl7zdjJ+Sb4d3/5z5PkL93d9Dae3LhsnB+9e0VyYiSJn1na9pZU3KpkMXzPKfTa8d4LtObFFEoeVxCV5jV6/Fy9d3aZfwDOTw7CSlliFDrBl/nGoLVTwAexDwe9G7LR6z/MSyfDF21cCTdHQEvb+gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722976132; c=relaxed/simple;
	bh=Sl557BAwaHzbY08oPXeLgFTmCXhqWVHszOkVgq68tQo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=tYK3X5SY416/ptwLDnnaROoYoO6yflV1y2dPJvm3RkCNTNjjbThNWU2AAFshODoIw2phOHljJHvLtp1U2cxIdEh0/lLKAoi6PwcFPJgMcMYloyYpupL/8xOkyXgtWOg75k8Oq7yDSp4OY8HG1VVJXNwSOrbLOGEfEVEZhdIyFN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MsZlLR7x; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5786C32786;
	Tue,  6 Aug 2024 20:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722976131;
	bh=Sl557BAwaHzbY08oPXeLgFTmCXhqWVHszOkVgq68tQo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=MsZlLR7x/bg2NSn7c5K3+ZkAPMwNFrMK0IiALaass3WIKWSfKdXCVQcJ4ZpyO4OIj
	 eMfoKBrz3vj/fxW4Yeg/52DifwIOXvft708AmsgNNUJk96SntwPkyns9e5GslpGhcM
	 KpBnCeKNrTx7oTOzwVBZyEEkfxEu+rdOPlKx2walqhsXLpv31p/XiLdOAOuGyhW0uK
	 2Q5Lp58Nepz6rSGjDBXrNCXlCfnJBRp5Cl2k/Ez0cr7VBMb+f7XQMcX3SNelUGew4r
	 Ds5hoRFBvZZUJbPUqGJos9F+o8Uq7w8Rmzs0U+zqN+HN8jh6ynEL3V5YeZIzQK/gsp
	 AgMCbL5AT0jqA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AEF7239EF95A;
	Tue,  6 Aug 2024 20:28:51 +0000 (UTC)
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
 <172297613024.1692635.16557321392270733874.git-patchwork-notify@kernel.org>
Date: Tue, 06 Aug 2024 20:28:50 +0000
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
    (no matching commit)
  - [v8,2/5] dt-bindings: riscv: Add Svade and Svadu Entries
    (no matching commit)
  - [v8,3/5] RISC-V: KVM: Add Svade and Svadu Extensions Support for Guest/VM
    (no matching commit)
  - [v8,4/5] KVM: riscv: selftests: Fix compile error
    https://git.kernel.org/riscv/c/dd4a799bcc13
  - [v8,5/5] KVM: riscv: selftests: Add Svade and Svadu Extension to get-reg-list test
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



