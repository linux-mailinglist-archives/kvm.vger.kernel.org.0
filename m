Return-Path: <kvm+bounces-42099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C2D3A72936
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 04:29:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E9663BD585
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 03:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15DD81EF387;
	Thu, 27 Mar 2025 03:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QwD9Oer0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB281EF364
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 03:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743045869; cv=none; b=TUiEh0Z8Lz3yBrh0qArfrZbTS87aKrjr7lYjX7hptljkDsRH0TJyDwWgcXXgQBdOr/SWi7fe1TYV06SVemtHGP0YneHQVNuGq7dOhNkT0esUtVi5bolPNTjgazTYPh7y3BEDpY22q2wc2E4AlKScrb3+nWnIM4JW75RcR51POq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743045869; c=relaxed/simple;
	bh=GMWGFlfqXsIrDR5aUMYGk61kFRdCVSidy91sgsWSi0A=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=GCRCGPYpEB0nc+DcV5832JoarLjLRqmBS5BR+Y1/sUybYp1zXFOB5HGF+DWyE5WoCdrzs2bwSLOaHcJQ2ebPXF8TI3kNz1ys5JDDYo4oD70oZOuLRtvsS9dA2f3hJLbqJpw0PL1BnBD3hcTvmgmWE4Ow9YUhFzItUrIawfhBMsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QwD9Oer0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D112C4CEDD;
	Thu, 27 Mar 2025 03:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743045869;
	bh=GMWGFlfqXsIrDR5aUMYGk61kFRdCVSidy91sgsWSi0A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=QwD9Oer0sNtwY2gMQPv8ziVxIeWCDyZx7MLkWbceo6hRAL3VqSSeLN6TJJHub3M1q
	 1+jCUY31MUE7mkMXcUZjhUPa4qMe3HGWPaej9dgx8NXQvfUXm5uwWPHVn0bAR/zTVz
	 /9gJPJuW1j4JM2poQpyb7BTY4RfAB/prFyfJIR1uYzTOhLjcRm7FytaoHSlZsdVyNu
	 +E0lO6UxifCwUettv3IBzCOtLStwIrjA17dKqdi/hhw+eXFsxEKeas0fugjkPqUQdn
	 zN1xDPRwJMWvUreFAsOLH+7iAP5q5NmqldUP+1uM9scVk9iM6tw/tOBSp1m/hysSer
	 dFmpZElY6Cspg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADBD7380AAFD;
	Thu, 27 Mar 2025 03:25:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] riscv: Remove duplicate CLINT_TIMER selections
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <174304590525.1549280.12521028074935026513.git-patchwork-notify@kernel.org>
Date: Thu, 27 Mar 2025 03:25:05 +0000
References: <448dba3309fe341f4095b227b75ae5fc6b05f51a.1733242214.git.geert+renesas@glider.be>
In-Reply-To: <448dba3309fe341f4095b227b75ae5fc6b05f51a.1733242214.git.geert+renesas@glider.be>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: linux-riscv@lists.infradead.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, dlemoal@kernel.org,
 anup@brainfault.org, atishp@atishpatra.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org

Hello:

This patch was applied to riscv/linux.git (for-next)
by Alexandre Ghiti <alexghiti@rivosinc.com>:

On Tue,  3 Dec 2024 17:15:53 +0100 you wrote:
> Since commit f862bbf4cdca696e ("riscv: Allow NOMMU kernels to run in
> S-mode") in v6.10, CLINT_TIMER is selected by the main RISCV symbol when
> RISCV_M_MODE is enabled.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  arch/riscv/Kconfig.socs | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - riscv: Remove duplicate CLINT_TIMER selections
    https://git.kernel.org/riscv/c/72770690e02c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



