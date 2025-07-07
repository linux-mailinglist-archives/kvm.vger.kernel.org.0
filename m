Return-Path: <kvm+bounces-51689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17030AFBA13
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 19:44:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 518D43B7727
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 17:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE2C92D8779;
	Mon,  7 Jul 2025 17:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i/Yg7aZ8"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D82325BEE5
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 17:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751910283; cv=none; b=oW4OsyCaRmgrQtGsoV6FEZrLgek0zuhNhVNBuTTKAOS2qSTxHJHDriiwF4BND9cZaa0ya0iQAK0ZNVTd0AUOn0qN9mI3VvakDAtm9iC4CmKpmqwImjAGGIle/c3rPUR0ucEkUZ76rswdhgHCOaMPLPTBSUGcQLlPKSphIMqFfd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751910283; c=relaxed/simple;
	bh=Z4N7YYE0TGBrDEbSJWXXS73BAcEH4T6haqOEU7WEqSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=clYEwLN1jHqh+M13IsGhhRnKqK2qe7CiUTRQJ0LERrycPF2PLNXFkkqdFG5E+73GdTJyo8+9Cvv5Mt+NOTGuZf7kmE6lAq2NeTqdyL7EFarbDAGBjYl71G1hDrY8SiCli7EYMWOXwCOUy34bjKASten+cj4NuQLg/W0hIaF+Kl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i/Yg7aZ8; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 7 Jul 2025 19:44:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751910267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bDUHijd7Ti9O17zyCdhODo2Lyk368Lrbom0BpvxiUD4=;
	b=i/Yg7aZ876/AQ5JodBsxWooLMdVJqSThZmfMA1OCDworQ2VnK/uDFy8dalHu62qiMbZByg
	ll0gEP/g1nQD9jhQg+V+UnwI+oqPYesg1m2Do+dJs0KCu//V2luZX12094ChwH/DaEiQL0
	uP89BFd2VAfNpUI8VzMPTIfxjcACVZ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jesse Taube <jesse@rivosinc.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, alexandru.elisei@arm.com, cleger@rivosinc.com, 
	jamestiotio@gmail.com, Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] riscv: Add kvmtool support
Message-ID: <20250707-cdad2acc36fb5c313042bd86@orel>
References: <20250704151254.100351-4-andrew.jones@linux.dev>
 <20250704151254.100351-6-andrew.jones@linux.dev>
 <CALSpo=YKMa142xhS8KSEenBLemaK6rqYKEd3FotQtCjpV5CciQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALSpo=YKMa142xhS8KSEenBLemaK6rqYKEd3FotQtCjpV5CciQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 07, 2025 at 08:28:30AM -0700, Jesse Taube wrote:
> On Fri, Jul 4, 2025 at 8:13 AM Andrew Jones <andrew.jones@linux.dev> wrote:
> >
> > arm/arm64 supports running tests with kvmtool as a first class citizen.
> > Most the code to do that is in the common scripts, so just add the riscv
> > specific bits needed to allow riscv to use kvmtool as a first class
> > citizen too.
> >
> > Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> 
> Reviewed-by: Jesse Taube <jesse@rivosinc.com>

Thanks!

...
> >  else
> > -    if [ "$arch" != "arm64" ] && [ "$arch" != "arm" ]; then
> > +    if [ "$arch" != "arm" ] && [ "$arch" != "arm64" ] &&
> > +       [ "$arch" != "riscv32" ] && [ "$arch" != "riscv64" ]; then
> 
> Are there plans to add i386 and x86_64 too?

I don't have plans myself, at least not right now, but I think it'd be
good to do it, so it'd be great if somebody would write the patch and
do the testing.

...
> > +       command="$(timeout_cmd) $kvmtool run"
> > +       if ( [ "$HOST" = "riscv64" ] && [ "$ARCH" = "riscv32" ] ) ||
> > +          ( [ "$HOST" = "riscv32" ] && [ "$ARCH" = "riscv64" ] ); then
> 
> Shouldn't there be a check like this on arm for when  [ "$HOST" =
> "arm" ] && [ "$ARCH" = "aarch64" ]?

arm kvm has been long deprecated and removed from Linux so we should
actually remove any references to HOST==arm throughout the framework
too, since it can't happen (any more).

Thanks,
drew

