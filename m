Return-Path: <kvm+bounces-26492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03FA4974F27
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 11:59:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1B1F1F25D39
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 09:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CE40224F6;
	Wed, 11 Sep 2024 09:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bq467N7x"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6A414A606
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 09:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726048733; cv=none; b=ZGwvm/YcRqR+MLyUqBr6TJ844rzbc4LMDet4y0nokhh8vfnRtcCm9BT/JrcvG6+FG/L4meIBhfi4r2Bx+lCCpwFjMVPP9vdGNu7CcI3OgFArGeKDPIVEeKpguckgIeMbIE6H0smqCeONSL2s+vBJ8S2A6Q7zaaErFJcYpByxKQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726048733; c=relaxed/simple;
	bh=i7gw4Uat6UX+1sGVuAw4SIefJi8Y27trcHIE5Hh8t0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B+G+UzYjxrL83RxtFLl8GD90RJ3nhFJOy/DrP4APeS2CAT2rBFmdQr2OvNfRt2ZMB157uLncXkOfZco6vU8fb+QC8KIppNKjedO/G6bWyUKsgYb47DbXt8k6h/lrH18X5oSHn8TODf6f5+cV3jzg/VeeXShTBS+6Gf/cFZn+amQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bq467N7x; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 11 Sep 2024 11:58:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726048728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K01nEv3wlhzsqk8tmkQ/Xu39VTClHpx8JJ1tXw2uK8k=;
	b=Bq467N7x00+zAhNfy5nY5sz5EkF11Q+yVh9sM+wu8pfPAvgccoYqubS66IiMzL3rph8cKV
	gZl3K8ssjeBG+YAYXefVwhRWyPPqrzqyydmXswWS1+YWazPwhtH1+sfw2yRBVgC4LL/jqt
	RZgwwWFCdv1Q2WG9H9M9HXGd3VTuH8E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH 0/2] riscv: sbi: Clean up multiple report
 prefix popping
Message-ID: <20240911-f1f2d6285391edffc5b63331@orel>
References: <20240910150842.156949-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910150842.156949-1-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 10, 2024 at 11:08:40PM GMT, James Raphael Tiovalen wrote:
> The first patch of this series adds a helper method to clear multiple
> prefixes at once. The second patch then uses this new helper method to
> tidy up the report prefix pops in the RISC-V SBI tests.
> 
> James Raphael Tiovalen (2):
>   lib/report: Add helper method to clear multiple prefixes
>   riscv: sbi: Tidy up report prefix pops
> 
>  lib/libcflat.h |  1 +
>  lib/report.c   | 21 +++++++++++++++------
>  riscv/sbi.c    | 17 +++++------------
>  3 files changed, 21 insertions(+), 18 deletions(-)
> 
> --
> 2.43.0
>

Looks good to me. There are no longer any double pops in riscv. Out of
curiosity, I checked the other architectures. arm and ppc both had one
instance of double pop, x86 didn't have any, but s390x had several. We
can leave the adoption of popn to the respective maintainer's preferences
though.

Applied to riscv/sbi, https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi

Thanks,
drew

