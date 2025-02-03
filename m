Return-Path: <kvm+bounces-37150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F2C86A26372
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 20:15:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 695B33A339A
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 19:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D55C6204C0C;
	Mon,  3 Feb 2025 19:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G7l6g2ZI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB07720E30A;
	Mon,  3 Feb 2025 19:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738610114; cv=none; b=ADsadY9YvyHns0VSn0WD8xLV/QHRWJKeSdnLYnh74q3x+XJeiSSSapsq/NWdnHdS3l3Iysa4JHwm5Batocr/uV+DByEg4+FF0ZJ9X72so5hnpzdqdVK6+Xwwx8vjUyVd7ZCPXhEwziY5li696zY2nFd9MaKH6Bzd8zPjFmQkPZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738610114; c=relaxed/simple;
	bh=LsOe7ZzlPhqEAOvTiMeWa8iiWUe9V2RCk8jcWcixhvI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=VawTZoKICWQqvx3qHfF+GI1VVcPluIFSHvzykGtZPMRmW6yzr+azAbv4Bwve6cQg7xPiEI7V0UQC5TU93Q9FT1mdAz/E9az4HbH3qKf+F7pbdwejkQdoK9UW+Q3UADiNpAt5psFTmYP/IboQHqEeyFpejrWtima+n02VpJs44W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G7l6g2ZI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68442C4CED2;
	Mon,  3 Feb 2025 19:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738610113;
	bh=LsOe7ZzlPhqEAOvTiMeWa8iiWUe9V2RCk8jcWcixhvI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=G7l6g2ZIizTNYrxkBbzlrHOv4+1Ln/d/XodEN9IIjNpde3v5XMCTHWxOixZzN9q8S
	 rN949faoH1AmsOIYguVjeAET/42q9AfHISAy4DRFQbEgHWCmSBiO+usYkZKWGdjuEc
	 aMQcBIql2D2qg7gA+RBA9RSmdWEwkbG4N1MdJNl2d9Oi/XsgVsIqSxEPtd0MwyVq7S
	 Ri2Te1NlEdebGxFUQQ9BBxdOCgHNEZMN3+9wi/ffVR0/mr+a7tjOtFCkp3Ji/v/6sF
	 AnmSnhQNv9bBphD2MWs1sV6pTXMH9eZXUNtFKd4EDmS8MTdZO0pDDD7PU5plQAIbCr
	 GFDVqeo3/KTzQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE0DC380AA67;
	Mon,  3 Feb 2025 19:15:41 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/4] RISC-V: KVM: Allow Svvptc/Zabha/Ziccrse exts for
 guests
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <173861014052.3409359.2500361473907016635.git-patchwork-notify@kernel.org>
Date: Mon, 03 Feb 2025 19:15:40 +0000
References: <cover.1732854096.git.zhouquan@iscas.ac.cn>
In-Reply-To: <cover.1732854096.git.zhouquan@iscas.ac.cn>
To: Quan Zhou <zhouquan@iscas.ac.cn>
Cc: linux-riscv@lists.infradead.org, anup@brainfault.org,
 ajones@ventanamicro.com, atishp@atishpatra.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org

Hello:

This series was applied to riscv/linux.git (fixes)
by Anup Patel <anup@brainfault.org>:

On Mon,  2 Dec 2024 11:21:26 +0800 you wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> Advertise Svvptc/Zabha/Ziccrse extensions to KVM guest
> when underlying host supports it.
> 
> ---
> Change since v1:
> - Arrange Svvptc in alphabetical order (Andrew)
> - Add Reviewed-by tags
> 
> [...]

Here is the summary with links:
  - [v2,1/4] RISC-V: KVM: Allow Svvptc extension for Guest/VM
    https://git.kernel.org/riscv/c/0f8915859716
  - [v2,2/4] RISC-V: KVM: Allow Zabha extension for Guest/VM
    https://git.kernel.org/riscv/c/679e132c0ae2
  - [v2,3/4] RISC-V: KVM: Allow Ziccrse extension for Guest/VM
    https://git.kernel.org/riscv/c/79be257b579e
  - [v2,4/4] KVM: riscv: selftests: Add Svvptc/Zabha/Ziccrse exts to get-reg-list test
    https://git.kernel.org/riscv/c/144dfe4017bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



