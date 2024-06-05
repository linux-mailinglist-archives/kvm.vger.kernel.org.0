Return-Path: <kvm+bounces-18877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 822C28FC963
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 12:50:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 36BAC1F251DE
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 10:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4456A191487;
	Wed,  5 Jun 2024 10:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P1ny9vIG"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4832418FC71
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 10:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717584598; cv=none; b=c2nzIu0695YnxPoRptNtX+vFAtIbMBle4erOxL/yVRczXvxd7ExlW6p/QP9Y2H+XXn8EwvcdvJS+9jmBh73zlZrxSsC0RbVUX2A6ebBISBzVsxdTgBFHrabmT4g79Ax6FANodUnk9xOFRptz9Y+piwk7ngqLAFEDi2AGlwEaNe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717584598; c=relaxed/simple;
	bh=xReU1FDa4QbV6+T5B23QG8o2WaATg8kVr+FIaX8znVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QyMnnxL6dviIY7hES1E8larQa5u2+XnVFgGt1fyGqL3505hWW9mZFPfhEHDBk/c9ukbVsv2906ci+fVsbSTfxnKdZHKpATeww0haC+SLajexw/oroEtrvL3YPuaWkFEYTbFZuH8MtpxtG5R2qdA+qHDpLZf7+SkYYF8+bnPnsGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P1ny9vIG; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: mhartmay@linux.ibm.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717584594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2wCCcgUt0x4WK9hVG44VFudmuNLd/ma85vNNzbGnObY=;
	b=P1ny9vIGyynSa/SXBH56M+bZWxuEctcUMbE11htm71YvONWKSIIIEopMc/sDB3DjGL6dTp
	Tf3p+27Sx8XFH51k65WYxAMkCu234oxIYZu/cy8nEcwOtb6QkxMYdATok+w4+/YXTb9ulh
	kZPUUdh8OaOsY1tqY0XMxt537yeyLyo=
X-Envelope-To: npiggin@gmail.com
X-Envelope-To: thuth@redhat.com
X-Envelope-To: kvm@vger.kernel.org
Date: Wed, 5 Jun 2024 12:49:52 +0200
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Marc Hartmayer <mhartmay@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, Thomas Huth <thuth@redhat.com>, 
	kvm@vger.kernel.org
Subject: Re: [RFC kvm-unit-tests PATCH] build: fix .aux.o target building
Message-ID: <20240605-0835475e3d8128f1f4e11013@orel>
References: <20240605081623.8765-1-npiggin@gmail.com>
 <87cyovekmh.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87cyovekmh.fsf@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 05, 2024 at 12:42:30PM GMT, Marc Hartmayer wrote:
> On Wed, Jun 05, 2024 at 06:16 PM +1000, Nicholas Piggin <npiggin@gmail.com> wrote:
> > Here's another oddity I ran into with the build system. Try run make
> > twice. With arm64 and ppc64, the first time it removes some intermediate
> > files and the second causes another rebuild of several files. After
> > that it's fine. s390x seems to follow a similar pattern but does not
> > suffer from the problem. Also, the .PRECIOUS directive is not preventing
> > them from being deleted inthe first place. So... that probably means I
> > haven't understood it properly and the fix may not be correct, but it
> > does appear to DTRT... Anybody with some good Makefile knowledge might
> > have a better idea.
> >
> 
> $ make clean -j &>/dev/null && make -d
> …
> Successfully remade target file 'all'.
> Removing intermediate files...
> rm powerpc/emulator.aux.o powerpc/tm.aux.o powerpc/spapr_hcall.aux.o powerpc/interrupts.aux.o powerpc/selftest.aux.o powerpc/smp.aux.o powerpc/selftest-migration.aux.o powerpc/spapr_vpa.aux.o powerpc/sprs.aux.o powerpc/rtas.aux.o powerpc/memory-verify.aux.o
> 
> So an easier fix would be to add %.aux.o to .PRECIOUS (but that’s probably still not clean).
> 
> .PRECIOUS: %.o %.aux.o

Just using .PRECIOUS is fine by me.

Thanks,
drew

> 
> Fixed the issue (I’ve tested on ppc64 only).
> 
> >
> >
> -- 
> Kind regards / Beste Grüße
>    Marc Hartmayer
> 
> IBM Deutschland Research & Development GmbH
> Vorsitzender des Aufsichtsrats: Wolfgang Wendt
> Geschäftsführung: David Faller
> Sitz der Gesellschaft: Böblingen
> Registergericht: Amtsgericht Stuttgart, HRB 243294

