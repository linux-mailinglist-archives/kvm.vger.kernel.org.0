Return-Path: <kvm+bounces-50840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 622DAAEA214
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 17:13:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF4956A263D
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 15:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA9B82EBBBC;
	Thu, 26 Jun 2025 14:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hdcm05Qg"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393FD2EACE3
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 14:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750949925; cv=none; b=pfPTVCs+58gtHb9ZK/tEJs/tM8kdv6OlYsmWJMTeo9NQEyyxuHB7I9weU8V+yH8K1aGRI4dd8tizKp8Vt9ls7lc/r9XhrOYxJG5KsO43mSSNv26rZYZDqsyAtL5DfTIDgJMNccPgsTOY+4GOJDJDt3DSdvgKQUjqHyG++IdkTTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750949925; c=relaxed/simple;
	bh=vaZ/wVKOO9ojZRN/4yT7HwIlbkw23fQlbABMb7bbVK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PSTth/4RAk8A9FmunIvBbB5dsHCnQhIHuKxj5tfSOodX/kH2UBQc7up2KqEyZAPiBDS9X+tuAEHNIq5NkN135crnTRtAultDBCo5hf6WLgowYWUs3AS+gJb1ZCHEmpKP2+S8VqSYW6x27Yf3JMHI3UksfBx2AUYGvWvaLU9EedI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hdcm05Qg; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 26 Jun 2025 16:58:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750949911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vOuqCH7ZkoqL6Tmn+B/nDaPgtnCP16MSLY5lnskHQ2I=;
	b=Hdcm05Qg5nhxSkz6prIahnkUcmTzr4XBzlqKZwTKI+O0waJiu8QBcOqtbuiiz7N3zgVQTI
	aT89w1gTaPPCYyF2OYUY7oikqbtLehQyk8wEXK6m4nhEacEyITBn1wp8BWDeLgZ2Y+f5cN
	ZieXTzWrL6MSbpDr3Cw5IfxXCLqc7GE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, pbonzini@redhat.com, 
	eric.auger@redhat.com, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, david@redhat.com, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 0/2] scripts: extra_params rework
Message-ID: <20250626-b638cf6a9cc5fa8b21da8418@orel>
References: <20250625154354.27015-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625154354.27015-1-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 25, 2025 at 04:43:52PM +0100, Alexandru Elisei wrote:
> This series was split from the series that adds support to use kvmtool when
> using the scripts to run the tests [1]. kvmtool will be supported only for arm
> and arm64, as they are the only architectures that compile the tests to run with
> kvmtool.
> 
> The justification for these changes is to be able to introduce
> kvmtool_params for kvmtool specific command line options, and to make a
> clear distinction between the qemu options and the kvmtool options. This is
> why qemu_params was added as a replacement for extra_params. extra_params
> was kept for compatibility purposes for user's custom test definitions.
> 
> To avoid duplication of the arguments that are passed to a test's main()
> function, test_args has been split from qemu_params. The same test_args
> will be used by both qemu and kvmtool.
> 
> [1] https://lore.kernel.org/kvm/20250507151256.167769-1-alexandru.elisei@arm.com/
> 
> Alexandru Elisei (2):
>   scripts: unittests.cfg: Rename 'extra_params' to 'qemu_params'
>   scripts: Add 'test_args' test definition parameter
> 
>  arm/unittests.cfg     |  94 ++++++++++++++----------
>  docs/unittests.txt    |  30 +++++---
>  powerpc/unittests.cfg |  21 +++---
>  riscv/unittests.cfg   |   2 +-
>  s390x/unittests.cfg   |  53 +++++++-------
>  scripts/common.bash   |  16 +++--
>  scripts/runtime.bash  |  24 ++++---
>  x86/unittests.cfg     | 164 ++++++++++++++++++++++++------------------
>  8 files changed, 237 insertions(+), 167 deletions(-)
> 
> 
> base-commit: 507612326c9417b6330b91f7931678a4c6866395
> -- 
> 2.50.0
>

This is already reviewed by me, but in order to encourage other arch
maintainers to also ack, then I'll state

ACK for arm and riscv

again.

Thanks,
drew

