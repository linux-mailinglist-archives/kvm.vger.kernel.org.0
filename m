Return-Path: <kvm+bounces-40005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90670A4D8E9
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:42:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A15D3B1EFD
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92A221FF1AC;
	Tue,  4 Mar 2025 09:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BMQVtuGn"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC27B1FF1A3
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 09:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080864; cv=none; b=S+aM+Itsr2ijKc6LYkrfnX+ZOP08i4SqTMlQlgW5U4FnjGpPto2Ooj12K8ila5PaYGZYhgLc0zGz50+goyrvb9D161GBG5W+in6OskZ1+2INR6QBIPMp583wBBskHaJDSEgOp/M6NoeJ8lOQ5vXIRiYRvl3Zljh6pX61igryhx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080864; c=relaxed/simple;
	bh=xYm5s2ePkod5bE6NNXUsKQoWoVuD8de3ddOIqdhzafE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iRynYX+CdGR5xELONf3m80uBsTw3vLCp/xQDHBl/tF/pFkZROd4iqhU7DWmga0+s2PC3LjHFuFNPU80ty5rPqkXZoPkNWg0KEggOVV0pzENjPOoqPbETKgDzy3yYuF0B3ueAW/LA0sk5giGEqu0S8Ux5Xt5ozt2umqz4kNY7Fm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BMQVtuGn; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 4 Mar 2025 10:34:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741080860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=worB1FoktgRE3NIeCNzUiNXuDPq4XDgN3dL+ixmnZFY=;
	b=BMQVtuGnkazKxprpslLgXTU0amugiiM0JQIx2OfseFn0VR1dQulPOQXNDaEnfcOTAH9/wE
	vmu5SO60UeZfT4FdRQSTgiSCIG43W0u7LAO43aabdXDVGzbGMV+7ktEwD+yDsBej3I8aWg
	3qB8f8gTUlbx6/0v1erhuc7m88AIA20=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v3 0/2] Add support for SBI FWFT extension
 testing
Message-ID: <20250304-5e0b7b5bf691d3ba97621388@orel>
References: <20250128141543.1338677-1-cleger@rivosinc.com>
 <20250129-4e54cccfa2abab6dba9a608b@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250129-4e54cccfa2abab6dba9a608b@orel>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 29, 2025 at 03:18:24PM +0100, Andrew Jones wrote:
> On Tue, Jan 28, 2025 at 03:15:40PM +0100, Clément Léger wrote:
> > This series adds a minimal set of tests for the FWFT extension. Reserved
> > range as well as misaligned exception delegation. A commit coming from
> > the SSE tests series is also included in this series to add -deps
> > makefile notation.
> > 
> > ---
> > 
> > V3:
> >  - Rebase on top of andrew/riscv/sbi
> >  - Use sbiret_report_error()
> >  - Add helpers for MISALIGNED_EXC_DELEG fwft set/get
> >  - Add a comment on misaligned trap handling
> > 
> > V2:
> >  - Added fwft_{get/set}_raw() to test invalid > 32 bits ids
> >  - Added test for invalid flags/value > 32 bits
> >  - Added test for lock feature
> >  - Use and enum for FWFT functions
> >  - Replace hardcoded 1 << with BIT()
> >  - Fix fwft_get/set return value
> >  - Split set/get tests for reserved ranges
> >  - Added push/pop to arch -c option
> >  - Remove leftover of manual probing code
> > 
> > Clément Léger (2):
> >   riscv: Add "-deps" handling for tests
> >   riscv: Add tests for SBI FWFT extension
> > 
> >  riscv/Makefile      |   8 +-
> >  lib/riscv/asm/sbi.h |  34 ++++++++
> >  riscv/sbi-fwft.c    | 190 ++++++++++++++++++++++++++++++++++++++++++++
> >  riscv/sbi.c         |   3 +
> >  4 files changed, 232 insertions(+), 3 deletions(-)
> >  create mode 100644 riscv/sbi-fwft.c
> > 
> > -- 
> > 2.47.1
> >
> 
> Applied to riscv/sbi
> 
> https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi
>

Merged.

Thanks,
drew

