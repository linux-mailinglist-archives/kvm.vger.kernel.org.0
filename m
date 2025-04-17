Return-Path: <kvm+bounces-43583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20228A91FBB
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 16:32:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E97A7B38F3
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 14:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E5BC254AE2;
	Thu, 17 Apr 2025 14:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r9yuPtzX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507ED254B1F;
	Thu, 17 Apr 2025 14:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744900078; cv=none; b=UW/lHoUT/X8+Y7e8mqY3kLXnNWulJDPtJeMagAn8Jt4vaBQjugX2plNmpCsd6FvUplNANetDzrYasvcrFBuboMBvUKEhsQrYWb0XWQ9dx0Zv+DpOAEqJl4UFwzqB9ZGdK98lgZdptF1VTPl0mNRoLtwjXvDMOG/wAaE1mR2TSYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744900078; c=relaxed/simple;
	bh=Z0nqVRmElracuKJ+IEr+zuP2nu4VnZdh8I8JTg6e/Gk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VU2P4cwLbvsIxBol+mdOgrAli+ZR4nO76HUsNgX/qsx/i0yhmn9ylUmLr5pib3zPPfyjPOp0X10N8MrW27sggHZQfrLmP0HfXdhSac94/B18NMabOYbF82OOLrRfUwI5YC2o8CVV94PUPLVafjzwOEk9GOtyfg1y5DZK1R+Jf7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r9yuPtzX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C32C4CEEA;
	Thu, 17 Apr 2025 14:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744900077;
	bh=Z0nqVRmElracuKJ+IEr+zuP2nu4VnZdh8I8JTg6e/Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9yuPtzXeTpf0QMNfJQ6Aa2x0fGxfbV1TXiprIvM8E34cHm73dEiAN9ohfpOiMH2f
	 hdP5KEbQvcgawrMwXWrhH8QUmsLWzhJ76ZYj/324STy2m+iywTFLLk35DPUiCkl1t5
	 d18FpXhMnjYUqRr4bVc4QU97Guh83Ms5gpiILXj51akWJe6JHRQ75g1kGaknfJxF11
	 h34GqBNB92ydLnh+90XQTMzAerjtMxn5QWVm1eo1chWIO2G4TcE6lOdea7zVvrR2ll
	 sSHBGSvYjOmQiN4CvUnknuJFGZnw2JkDEm1Qn8dWhufrbdyMnbaFPC837pxS1MQgSE
	 UCgicmIdqjqcA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	kvm@vger.kernel.org,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool v2 0/9] arm: Drop support for 32-bit kvmtool
Date: Thu, 17 Apr 2025 15:27:29 +0100
Message-Id: <174489103378.1232014.1911897721206238271.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20250404165233.3205127-1-oliver.upton@linux.dev>
References: <20250404165233.3205127-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 04 Apr 2025 09:52:23 -0700, Oliver Upton wrote:
> v1: https://lore.kernel.org/kvmarm/20250325213939.2414498-1-oliver.upton@linux.dev/
> 
> v1 -> v2:
>  - Move headers under arm64/include/kvm similar to other arches (Alex)
> 
> Oliver Upton (9):
>   Drop support for 32-bit arm
>   arm64: Move arm64-only features into main directory
>   arm64: Combine kvm.c
>   arm64: Merge kvm-cpu.c
>   arm64: Combine kvm-config-arch.h
>   arm64: Move remaining kvm/* headers
>   arm64: Move asm headers
>   arm64: Rename top-level directory
>   arm64: Get rid of the 'arm-common' include directory
> 
> [...]

Applied to kvmtool (master), thanks!

[1/9] Drop support for 32-bit arm
      https://git.kernel.org/will/kvmtool/c/329fe56944fc
[2/9] arm64: Move arm64-only features into main directory
      https://git.kernel.org/will/kvmtool/c/518857543a4b
[3/9] arm64: Combine kvm.c
      https://git.kernel.org/will/kvmtool/c/14e8c4204d11
[4/9] arm64: Merge kvm-cpu.c
      https://git.kernel.org/will/kvmtool/c/65878da23508
[5/9] arm64: Combine kvm-config-arch.h
      https://git.kernel.org/will/kvmtool/c/71135783886f
[6/9] arm64: Move remaining kvm/* headers
      https://git.kernel.org/will/kvmtool/c/f8a539a99ef5
[7/9] arm64: Move asm headers
      https://git.kernel.org/will/kvmtool/c/4cd7b87ab292
[8/9] arm64: Rename top-level directory
      https://git.kernel.org/will/kvmtool/c/0a10c482b403
[9/9] arm64: Get rid of the 'arm-common' include directory
      https://git.kernel.org/will/kvmtool/c/d410d9a16f91

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

