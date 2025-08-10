Return-Path: <kvm+bounces-54353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 43E90B1FC2F
	for <lists+kvm@lfdr.de>; Sun, 10 Aug 2025 23:13:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E3E837AB280
	for <lists+kvm@lfdr.de>; Sun, 10 Aug 2025 21:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04A6222A4EE;
	Sun, 10 Aug 2025 21:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fyWQ5ooo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CDB227586
	for <kvm@vger.kernel.org>; Sun, 10 Aug 2025 21:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754860329; cv=none; b=cjJP+cOSLctYK51En+duHBwIF7qiYIbxbnu3DUtdK0VLdvOE7gZJPWhfZalVM919x2060qoXXbrWydjovoWqUwlSWmVY2waWAOg7axw8/pmHA36n2GoSCg9IwIzfvLZxk3V7PNm8MhQ2m8h/VXF+Ro13t1jeMcBC+ZvI03PRVIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754860329; c=relaxed/simple;
	bh=ZK22F6C/xwxn3px53k7HK2LnPgcM6+IW6mZjmVw4kFw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=WVh+jlgkA2s+5wCt3bUyUMBv5B2fiwz0C2oghYAey36Au2LbKlpQsdrjnWOFtdj/sdec24BtTKAJNxOLyyqbCi3U7YYvbwOEnMEzq8FSPYndC065WNh+gxsCx45r7Q95Jsp+t8S0uflV18wkQ2Cj2ER94eMdTfuAlzt9EKr5dLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fyWQ5ooo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCEBC4CEEB;
	Sun, 10 Aug 2025 21:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754860328;
	bh=ZK22F6C/xwxn3px53k7HK2LnPgcM6+IW6mZjmVw4kFw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=fyWQ5oooRC6wI8X6P+yvMFj5P/hHuuEVXFYqiAdDrROsJheOK+FCl0ax8qRBG0MH4
	 wTrPfy9PBKTT7rnR1tiCIf5OOSsKxtMA0op0F4VLfQaXvJRDoyfgB0+0jdrEVkk3N+
	 Uwi0TrWouz0jNcmgr8YcfIOnnLQ4IkGuLZo1gAbYetV+005FVY9eAFmDmerFVEb2RO
	 71OS0WbF/mxSum4TUKSSGI/49849ZjfpsYtQimD7ozCY6NF4+DosiaTC22axlmheAD
	 1q2CjvngKZUm3HTxftih68jHazWm2QfgTnFoBmDCTO0octJRac1ZYnAgW6vFQZqbbQ
	 Z07Y65Rmub+Qg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70C3939D0C2B;
	Sun, 10 Aug 2025 21:12:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL v2] KVM/riscv changes for 6.17
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <175486034099.1221929.4746664358148231967.git-patchwork-notify@kernel.org>
Date: Sun, 10 Aug 2025 21:12:20 +0000
References: 
 <CAAhSdy1084USuM+k9T-AP7X_=s7x+WFv++U0PkjVojbPbjRCrw@mail.gmail.com>
In-Reply-To: 
 <CAAhSdy1084USuM+k9T-AP7X_=s7x+WFv++U0PkjVojbPbjRCrw@mail.gmail.com>
To: Anup Patel <anup@brainfault.org>
Cc: linux-riscv@lists.infradead.org, pbonzini@redhat.com, palmer@dabbelt.com,
 ajones@ventanamicro.com, atishp@rivosinc.com, atish.patra@linux.dev,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org

Hello:

This pull request was applied to riscv/linux.git (fixes)
by Paolo Bonzini <pbonzini@redhat.com>:

On Tue, 29 Jul 2025 17:04:22 +0530 you wrote:
> Hi Paolo,
> 
> We have the following KVM RISC-V changes for 6.17:
> 1) Enabled ring-based dirty memory tracking
> 2) Improved "perf kvm stat" to report interrupt events
> 3) Delegate illegal instruction trap to VS-mode
> 4) MMU related improvements for KVM RISC-V for the
>     upcoming nested virtualization support
> 
> [...]

Here is the summary with links:
  - [GIT,PULL,v2] KVM/riscv changes for 6.17
    https://git.kernel.org/riscv/c/65164fd0f6b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



