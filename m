Return-Path: <kvm+bounces-31489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7903D9C417C
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 16:07:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 13D15B22B27
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 15:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE9D19E83E;
	Mon, 11 Nov 2024 15:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XbAHAQhv"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EA9136E21
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 15:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731337642; cv=none; b=jg4LHXXoZtmJ6VcxuNeimIYKI5ava23akaSCmIqBMmTq3fz74WhGdrnn/4nu5R4m7YJAxFpgwqOiekChuoOg7bt00ZZbavOUSLwz78B4IvE+GWvwk5gYbwZoJmsolp/bpo6NF6U7E/7CCWXZU5imQPhgoZojxg0tFZgnWgY938M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731337642; c=relaxed/simple;
	bh=r3uJoxzHshbZDgJec7sOExMeyVzbcmVrYaBUu4IRekE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NL6FXxarOWKUZuSl0wnm9A/F7M53uus7hmQdyXfhkgv6g50S/GAfIG8hdbe+A0hLp++s3fP3apM40Cfi4onosPMkIl9p5MQtU3zPkHETuyIknfTl2ezzqA5315fg7T08A4P3vVD8y+2wejmXrYYZ/2KK/uFpBkF/GF10AYla9dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XbAHAQhv; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 11 Nov 2024 16:07:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731337637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mojA56Dbs3BbEjW7QTAxR6TQYwog456aRw4qURikXAU=;
	b=XbAHAQhvOHbNfO0MhQxBwQKTOymXPG5RmIoGdcjvH5cEFy59J/xFoh4hlbkT5gLL+AUrKd
	voICGQPtERYvdwh3ry9KUCDNa834fNx28/b5IyQm2ccp4YsPc+C22dXMz/uup8dvFdMsh7
	B+epK/HtgNCRI83uTUghBnNwBKIlXj0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: cade.richard@gmail.com, atishp@rivosinc.com, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH v2 0/3] riscv: sbi: Add IPI tests
Message-ID: <20241111-d7f4cf595cfcace50f5d52ab@orel>
References: <20241106113814.42992-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106113814.42992-5-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 06, 2024 at 12:38:15PM +0100, Andrew Jones wrote:
> Repost Cade's IPI test patch[1] with all the changes pointed out in the
> last review and more.
> 
> Based-on: https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi
> 
> [1] https://lore.kernel.org/all/20240826065106.20281-1-cade.richard@berkeley.edu/
> 
> v2:
>  - Rebased on latest riscv/sbi
>  - Improved ipi done checking by introducing cpumask_equal
>  - Added a patch for another IPI test case
> 
> 
> Andrew Jones (2):
>   riscv: Add sbi_send_ipi_broadcast
>   riscv: sbi: Add two in hart_mask IPI test
> 
> Cade Richard (1):
>   riscv: sbi: Add IPI extension tests
> 
>  lib/cpumask.h       |  13 ++++
>  lib/riscv/asm/sbi.h |   1 +
>  lib/riscv/sbi.c     |   7 +-
>  riscv/sbi.c         | 184 +++++++++++++++++++++++++++++++++++++++++++-
>  riscv/unittests.cfg |   1 +
>  5 files changed, 203 insertions(+), 3 deletions(-)
> 
> -- 
> 2.47.0
>

Merged through riscv/sbi.

Thanks,
drew

