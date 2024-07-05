Return-Path: <kvm+bounces-21046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A6C8928734
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 12:56:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22BDE1F262A7
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 10:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33439149C50;
	Fri,  5 Jul 2024 10:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V6kXpq8C"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62053148853
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 10:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720176868; cv=none; b=pogSTs5D+7Wp+dW60ynZhkAYipt8wXa7jVYdey9vq4ue1pxhHdITON1GPOERvcL40tiN7x5b2Q5tp7wZVRSjMXxUv+bS0tJ6LTwLrFlDmNMNY+qSpSCgYIuJaVH1HZAkdiSQismVtBTsPVQWHZxrftAl4GeMPsq0lnFocDdWse8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720176868; c=relaxed/simple;
	bh=+NMBOakY4iPBWEAhletUzQH6id4fiJWnwU0/Cgxyhhg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VILeh/7oV4DECnJcW21nSG5SzjqFq6i+KjXGbwm3Y+IXWjBv1Je+XTS7lfFuVVNVs5v517p29eXaqLdmYgxY90Rv/C7yiJCxSyCXLiBHTKUcZA+A+d2jfKA4H+1Fmz3MU1Kzz6Iu+VASVRz/RNYb9ru2vWcWpWycJkNlHdMyDms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V6kXpq8C; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5238C116B1;
	Fri,  5 Jul 2024 10:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720176867;
	bh=+NMBOakY4iPBWEAhletUzQH6id4fiJWnwU0/Cgxyhhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6kXpq8C+INhwN5+qJ0lUyFfp6C1efxliLnY8OTJ+tpraMYOWdD3JsL+oT1syJ0NO
	 de049Ze4YT0n+Fp/kLsajw/Tp57y6Ps/hFWTWUHDjTSxNP2DI8dWq08wcGX6hXr2Ns
	 v93lq7yFjkxIOpWsyTSUbJ+m4oYFp7ZB/+v932Tz1AGR3mMX7Y2Hs6lKrGPQ4Qeu5T
	 jN6w0HXeg/hL3EKtZPivX3MLb+d1tCbtYJxYqUntaNUmRci/pQsWWdPMkzXYJDRcTr
	 O/+YY7e8EZctZ45imJRdgi5NnlQDrG7JjcvV3dsxh1hg6kaOjL2rROK7ytb0jRoYnk
	 50bq7F0+z8tzA==
From: Will Deacon <will@kernel.org>
To: julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH 0/3] Add RISC-V ISA extensions based on Linux-6.9
Date: Fri,  5 Jul 2024 11:54:16 +0100
Message-Id: <172017577880.496851.16044176986107595814.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240514054928.854419-1-apatel@ventanamicro.com>
References: <20240514054928.854419-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 14 May 2024 11:19:25 +0530, Anup Patel wrote:
> This series adds support for new ISA extensions based on Linux-6.9 namely:
> Ztso and Zacas.
> 
> These patches can also be found in the riscv_more_exts_round2_v1 branch
> at: https://github.com/avpatel/kvmtool.git
> 
> Anup Patel (3):
>   Sync-up headers with Linux-6.9 kernel
>   riscv: Add Ztso extensiona support
>   riscv: Add Zacas extensiona support
> 
> [...]

Applied to kvmtool (master), thanks!

[1/3] Sync-up headers with Linux-6.9 kernel
      https://git.kernel.org/will/kvmtool/c/85aaadf64649
[2/3] riscv: Add Ztso extensiona support
      https://git.kernel.org/will/kvmtool/c/a20adc64b4ea
[3/3] riscv: Add Zacas extensiona support
      https://git.kernel.org/will/kvmtool/c/32f810364df0

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

