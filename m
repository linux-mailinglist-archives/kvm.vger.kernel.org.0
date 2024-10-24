Return-Path: <kvm+bounces-29604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBA6B9ADF52
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 10:39:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 667031F23979
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 08:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 355651B0F17;
	Thu, 24 Oct 2024 08:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LWyQtjaS"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1DB16C6A1;
	Thu, 24 Oct 2024 08:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729759139; cv=none; b=lraQ+J1ffSa7sCoRwD0JZSUqmZBhT9yXUig+nAL1uhzfUU/WwD2Dg0fCkga1Dxy3Qjg0wa4/wZc+Psj45uuUD+c7hVaI/UIxDAy6bNKar1FXq4oPHAbgEH+RtTM+lTUcfX2zFZRXmakXIGAHmatc8qOPn6XzCXZPACJa+vEmQB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729759139; c=relaxed/simple;
	bh=Bs8F6cQWqLaLUPQc0y1nFiMC8Oib2Yljxn3OVZs2quI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WQ1PlClxJP2ld4ud8XpTivUy7YQ0VQUL8cU2RdhB7k8mX4GtVoaC3m4WyzUgLZzMT+apP6aZAarVKFuszuI9ftz/ahsV7BYFoKLZz/eNAn3RnIPY6Ep10TOqjpd7sgkrBwBU+bQaRUf6GJS1Tn0nCdAraxOf4S4w9Bnd3+FX3yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LWyQtjaS; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 24 Oct 2024 10:38:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729759135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7A7SSI40hPXOoNVasTXPi3W2hqog0qAqPQKBVOcc5W8=;
	b=LWyQtjaSFN8PSZnIMLn7qxaE4w4YSQZzifoc2B8ZTYKBm73KZn13CBkjYqVIaBDua0YJR3
	Nw4koRUvJJafhZcS9w8kGN2XeLunS+/uoYmAlsC0JKclJLJs5rbjO+1lHR+oMq6UrvgGKt
	z1GiV3cOFng4MgccmdxpXjIOl8tNPMU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
Cc: pbonzini@redhat.com, thuth@redhat.com, lvivier@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, atishp@rivosinc.com, 
	cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH v3 0/5] Support cross compiling with clang
Message-ID: <20241024-cecbb361d7e3f21c7053408b@orel>
References: <20240911091406.134240-7-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911091406.134240-7-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 11, 2024 at 11:14:07AM +0200, Andrew Jones wrote:
> Modify configure to allow --cc=clang and a cross-prefix to be specified
> together (as well as --cflags). This allows compiling with clang, but
> using cross binutils for everything else, including the linker. So far
> tested on riscv 32- and 64-bit and aarch64 (with some hacks to the code
> to get it to compile - which is why there's no gitlab-ci patch for aarch64
> in this series). I suspect it should work for other architectures too.
> 
> v3:
>  - Add README patch for cross-compiling, clang, and cross-clang [Nick]
>  - Add comment to the commenting-out of mstrict-align [Nick]
>  - Add the reason to ignore warnings vs. fix code to commit message of
>    patch2
>  - Picked up Nick's tags
> v2:
>  - fix building with clang and --config-efi by suppressing a warning
>  - added riscv clang efi build to CI
>  - picked up Thomas's tags
> 
> Andrew Jones (5):
>   riscv: Drop mstrict-align
>   Makefile: Prepare for clang EFI builds
>   configure: Support cross compiling with clang
>   riscv: gitlab-ci: Add clang build tests
>   README: Add cross and clang recipes
> 
>  .gitlab-ci.yml | 43 +++++++++++++++++++++++++++++++++++++++++++
>  Makefile       |  2 ++
>  README.md      | 22 ++++++++++++++++++++++
>  configure      | 11 ++++++++---
>  riscv/Makefile |  4 +++-
>  5 files changed, 78 insertions(+), 4 deletions(-)
> 
> -- 
> 2.46.0
>

Merged

Thanks,
drew

