Return-Path: <kvm+bounces-52995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E02B0C67B
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:36:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 042A917E5B2
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C45C32D3EFC;
	Mon, 21 Jul 2025 14:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rpAoRXNz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E9F298255
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 14:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753108563; cv=none; b=C5omzfi73Xfdjw7RwkblsURbVI55xKhWWR1wEB4OxDdb6rB731ZWpfxUObsXWYSXjTKZGu1QuLAdVZj4o0Gk8UZZDa/MmOgziNSoInLHBtmH98wcLNo47kzRA3/Eqr5Vsl6aH2Ycz8dN73vUo2JFgeJRE2YYKS4/t1naSDcwXfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753108563; c=relaxed/simple;
	bh=rlH7iw2AQ4NXWC3JEMs+IHGjz7Kw8qUdjjubzoZ/yWE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dMDGP56MkVX5j0/XxMgAYNSFSq1mYs4KQbAz10/8u6quhz7YPO9KPHoqnAZMd73m3SpCf0NoSrpLVlwQTZzQAviUk9GRHRH4iOuFHtZmzpP4eMHmSzlPDvo6HgISimT0CPU6ME8w0xBfTcquA+O2lEqWK03Xzim88zs0M5hU3HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rpAoRXNz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74848C4CEED;
	Mon, 21 Jul 2025 14:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753108562;
	bh=rlH7iw2AQ4NXWC3JEMs+IHGjz7Kw8qUdjjubzoZ/yWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpAoRXNzS09YtYZHmv7t6ur4sVnFAGYey4yvZZNy+N3c+Cs267M4vFZHbJRfXSeJP
	 VQzfbcRLbrNhSu55y0n+hGbt7iNguxAuZSE51oKaDnPNyoF1y8DT9oIqLIZ/JpS3yw
	 tGB6X+6fY6Lb15ziub0Lhi7qptkYmhobt5fz2ih5XV3IsapGth+AApjntNi1lt565/
	 ZwIyLWhi2nmxrx4xMCRAMgpN/KYDo4BgYT8A/RM8tTxWqGme0dGMhnW9PRtXUb0s3n
	 7e8f1hS1y35z7xQtnwWOAGwnNJ1PLyC5MQvpEgayZW3OYQUuy02Bk5muXjnnt1JOVp
	 oW3VBYre8phCQ==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org,
	Thomas Perale <thomas.perale@mind.be>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH kvmtool] vfio: include libgen.h (for musl compatibility)
Date: Mon, 21 Jul 2025 15:35:51 +0100
Message-Id: <175309922953.3722631.3586573998054640008.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250629202221.893360-1-thomas.perale@mind.be>
References: <20250629202221.893360-1-thomas.perale@mind.be>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sun, 29 Jun 2025 22:22:21 +0200, Thomas Perale wrote:
> Starting GCC14 'implicit-function-declaration' are treated as errors by
> default. When building kvmtool with musl libc, the following error
> occurs due to missing declaration of 'basename':
> 
> vfio/core.c:537:22: error: implicit declaration of function ‘basename’ [-Wimplicit-function-declaration]
>   537 |         group_name = basename(group_path);
>       |                      ^~~~~~~~
> vfio/core.c:537:22: warning: nested extern declaration of ‘basename’ [-Wnested-externs]
> vfio/core.c:537:20: error: assignment to ‘char *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
>   537 |         group_name = basename(group_path);
>       |                    ^
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] vfio: include libgen.h (for musl compatibility)
      https://git.kernel.org/will/kvmtool/c/ba6830eec0f5

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

