Return-Path: <kvm+bounces-27766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 888C498BB45
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 13:35:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF6C61C23643
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 11:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B2211C1AD1;
	Tue,  1 Oct 2024 11:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iFwht7Mb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A211C1750;
	Tue,  1 Oct 2024 11:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727782511; cv=none; b=GcHqfPLiS+ZqFxFyd6wYRCW7sItN6CWLJfGljc5uydXsWeWsIVr+AH0QGri4DuedESpJaFl20pau55S2qAW05VU0mqmNMOeT33kQ+2QCv2e/Of6oatFTuM1D2pYd4koI+6Xu9zU4sntPVffpWMol1Xz610ReTYaOIGto0ForFh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727782511; c=relaxed/simple;
	bh=11ixGMiy4P5OEvKM+IS3Ql37oz30zYU1wmZDtstmxAo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=DhPgfWNu9qO7+44KUm17mcZbTeJ6/EBco/W/mindyyag2Fv2sMRAH9XLNacN80l0oV2irue2sVAtg5RxboDAWOa8LJBpNtH2PP3XWYOjYqEET7Fc6Oo8LPSoqObYyA2FuLK9u4VljcHLTp6pT/kAl66WFLkFhLvd4n5vn7kkxd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iFwht7Mb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566F5C4CECE;
	Tue,  1 Oct 2024 11:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727782511;
	bh=11ixGMiy4P5OEvKM+IS3Ql37oz30zYU1wmZDtstmxAo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=iFwht7MbXQlFvMtvfhQJJmjjjbBnN1fMUwVS79nG/JzTESaSbzCZ8IV1mO97NJeVO
	 uPZwP7SuJl1E/2sJaIhNZqIm3A0/8+LBu/GOm0o+h3cYNrul8XNO/3z0WpTxPT5wgT
	 ctQxhlbiePJUmWrbj6aCaOpAQzK5b6U7uhkr0nIFoZ78/RIPzU5Mw5/x92+hwbezMT
	 rmUeeCMDpukng9rWXPITx6zfHDksBrHi2SLbWZQQMqPKukUt2i2spv4jHN1xujBOJN
	 pKLbhHiPfPn5inrvvZR6fDsU/ODN7S6/J4dSx+gK+/LtsLfrh7P3DRhKVtYnywu+bb
	 Yrkzvi6jw/vMg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADEB3380DBF7;
	Tue,  1 Oct 2024 11:35:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/2] KVM: Coalesced IO cleanup and test
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <172778251450.314421.17878360494032462055.git-patchwork-notify@kernel.org>
Date: Tue, 01 Oct 2024 11:35:14 +0000
References: <20240828181446.652474-1-seanjc@google.com>
In-Reply-To: <20240828181446.652474-1-seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-riscv@lists.infradead.org, pbonzini@redhat.com,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, ilstam@amazon.com,
 maz@kernel.org, oliver.upton@linux.dev, anup@brainfault.org, paul@xen.org

Hello:

This series was applied to riscv/linux.git (fixes)
by Sean Christopherson <seanjc@google.com>:

On Wed, 28 Aug 2024 11:14:44 -0700 you wrote:
> Add a regression test for the bug fixed by commit 92f6d4130497 ("KVM:
> Fix coalesced_mmio_has_room() to avoid premature userspace exit"), and
> then do additional clean up on the offending KVM code.  I wrote the test
> mainly so that I was confident I actually understood Ilias' fix.
> 
> This applies on the aforementioned commit, which is sitting in
> kvm-x86/generic.
> 
> [...]

Here is the summary with links:
  - [v2,1/2] KVM: selftests: Add a test for coalesced MMIO (and PIO on x86)
    https://git.kernel.org/riscv/c/215b3cb7a84f
  - [v2,2/2] KVM: Clean up coalesced MMIO ring full check
    https://git.kernel.org/riscv/c/e027ba1b83ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



