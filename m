Return-Path: <kvm+bounces-56851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E565B44962
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 00:18:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41D71A032B8
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 22:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B952E88B6;
	Thu,  4 Sep 2025 22:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nX3Gfj2k"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943B72E7BD9
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 22:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757024278; cv=none; b=EdFCexs3jFgB5OD6f0zLHl4PSOJwsdBuNCD+OKt2mTPCHjV7fHjyoYmI6KD0vFZ7RTTjlkYQpABfYzfX86C7b5miTm+Mlh+swxzR14sP/5lApO9f8/lcr15KGESWGd+5jocMF9hnncg/HKAMMx8uXBUGJNbZ4t3qVUweAA5S4mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757024278; c=relaxed/simple;
	bh=jam4VHvwmH6aZNgBBfdAO4/tQS0KYgMFLTCwrR5VePM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EGd5eogPLDnYLwqd7yIaPwH3gA3H8QYD2TtG5WMqVOOroc86dGaIMdcN78h+GVjN/LLSPEGbtjnCLqSlT93c1gLHU715WWyUIhsjeId+TZ6SvP3upXfgT4GAPEaCwhaxftoIBALM77OAzVU3ymvH6Vu1O1plELAzGqeckQDeEUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nX3Gfj2k; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 4 Sep 2025 17:17:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757024273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o98fAs74wpnvUXiwkAwDMwEWd/kcAqQMte0bpKFWiko=;
	b=nX3Gfj2kXRPfwQPEE27HiGhKaiOTA2/FgvfCJQFGs2CNZFx6nKfXeTl23LM8r9fItUjWQ9
	km5GJHPMic9N0hMauKs4e00TzxLT8YX7boXNr9ZmUQRYJxOUCNaUwHcnj/drwvOv9tPHYZ
	UwPKMdShiZO79KhHcts3puW/P9EYAhg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Joel Stanley <joel@jms.id.au>
Cc: kvm-riscv@lists.infradead.org, Nicholas Piggin <npiggin@gmail.com>, 
	Buildroot Mailing List <buildroot@buildroot.org>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests] riscv build failure
Message-ID: <20250904-11ba6fa251f914016170c0e4@orel>
References: <CACPK8XddfiKcS_-pYwG5b7i8pwh7ea-QDA=fwZgkP245Ad9ECQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACPK8XddfiKcS_-pYwG5b7i8pwh7ea-QDA=fwZgkP245Ad9ECQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Sep 04, 2025 at 08:57:54AM +0930, Joel Stanley wrote:
> I'm building kvm-unit-tests as part of buildroot and hitting a build
> failure. It looks like there's a missing dependency on
> riscv/sbi-asm.S, as building that manually fixes the issue. Triggering
> buildroot again (several times) doesn't resolve the issue so it
> doesn't look like a race condition.
> 
> I can't reproduce with a normal cross compile on my machine. Buildroot
> uses make -C, in case that makes a difference.
> 
> The build steps look like this:
> 
> bzcat /localdev/jms/buildroot/dl/kvm-unit-tests/kvm-unit-tests-v2025-06-05.tar.bz2
> | /localdev/jms/buildroot/output-riscv-rvv/host/bin/tar
> --strip-components=1 -C
> /localdev/jms/buildroot/output-riscv-rvv/build/kvm-unit-tests-2025-06-05
>   -xf -
> cd /localdev/jms/buildroot/output-riscv-rvv/build/kvm-unit-tests-2025-06-05
> && ./configure --disable-werror --arch="riscv64" --processor=""
> --endian="little"
> --cross-prefix="/localdev/jms/buildroot/output-riscv-rvv/host/bin/riscv64-buildroot-linux-gnu-"
> GIT_DIR=. PATH="/localdev/jms/buildroot/output-riscv-rvv/host/bin:/localdev/jms/buildroot/output-riscv-rvv/host/sbin:/home/jms/.local/bin:/home/jms/bin:/home/jms/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
> /usr/bin/make -j385  -C
> /localdev/jms/buildroot/output-riscv-rvv/build/kvm-unit-tests-2025-06-05
> standalone

I applied similar steps but couldn't reproduce this. It also looks like we
have a dependency because configuring with '--cc=/path/to/mygcc', where
mygcc is

   #!/bin/bash
   for x in $@; do
       if [[ $x =~ sbi-asm ]] && ! [[ $x =~ sbi-asm-offsets ]]; then
           sleep 5
           break
       fi
   done
   /path/to/riscv64-linux-gnu-gcc $@

stalls the build 5 seconds when compiling sbi-asm.S but doesn't reproduce
the issue. That said, running make with -d shows that riscv/sbi-asm.o is
an implicit prerequisite, although so are other files. I'm using
GNU Make 4.4.1. Which version are you using?

Also, while the steps above shouldn't cause problems, they are a bit odd
 * '--endian' only applies to ppc64
 * -j385 is quite large and specific. Typicall -j$(nproc) is recommended.
 * No need for '-C "$PWD"'

Thanks,
drew

