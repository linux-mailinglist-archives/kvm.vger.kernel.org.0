Return-Path: <kvm+bounces-26977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65FBF979FBB
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 12:49:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 279B3281B15
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 10:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AFD4153BF7;
	Mon, 16 Sep 2024 10:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BgtwKofd"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0A334CC4
	for <kvm@vger.kernel.org>; Mon, 16 Sep 2024 10:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726483780; cv=none; b=hBksslylg0aqWC31IV14uA0TRA1OFwDb+tF1u/XEWMwTH1CxSW8DPlwwqztfJvcRy8bhoBNN0MNAizsriTKEopXW7EhAT2x8/KG4izBIfjB23O74ri4tY5y1ZiRG+zhi7Gu9i8r7dLF1j85fhs4PtqYNh0+zXu8Td8lJWJYTVhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726483780; c=relaxed/simple;
	bh=ZIYXuv9TSVxPUXezuYzN9LuEtV2g/BNvnOfcoM1zUDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FmZ4/HDS1ZW82vXmDgkFgc0bvLwMl1R1f8NAZT+HyPbeQgXfWy4i/JabIdNaZ7gu+s+Y7KaW64ufq5Hyvi4jvrUtKxztLY12hoWOS6qke4W20oyWcz99AX1kO66douD7Wwtj/Jl4hiRVb6ll+mPMesJMSsRKUV6ge7OgaebWBj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BgtwKofd; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 16 Sep 2024 12:49:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726483774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5KuVQSQRoC9T7WBszA2ChkvLeEk7Npao/uqvfMXevIA=;
	b=BgtwKofdytiCUIh2ajd7y+GqxOOXyYbCLvQog9RKN7bVrzVltrt6d+OrlTCPwLYtSZfuUZ
	LNHmVQahzztACbQ4EpIPhcc2vmmbW0v1rfVCZuEmPo0ghvmK4BA1fxyhQkgC32ubGUiN2q
	N7L7F2BJbzl33GfGUgnVdVck4ji9DCk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v4 3/3] riscv: sbi: Add tests for HSM
 extension
Message-ID: <20240916-cedb477964d0af321cea6bec@orel>
References: <20240915183459.52476-1-jamestiotio@gmail.com>
 <20240915183459.52476-4-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240915183459.52476-4-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 16, 2024 at 02:34:59AM GMT, James Raphael Tiovalen wrote:
...
> +static struct sbiret sbi_hart_suspend(uint32_t suspend_type, unsigned long resume_addr, unsigned long opaque)
> +{
> +	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_SUSPEND, suspend_type, resume_addr, opaque, 0, 0, 0);
> +}
> +

It's good to create these wrappers per the spec, i.e. use the parameter
name types from the spec to define the wrapper, but we should also
remember that if, like in this case, we force a parameter to be of a
certain type that we also add tests for when we use input outside the
expected range by using a "raw" ecall. See the last test of the DBCN
extension where we test a byte write with a word full of data to
ensure the SBI call does the right thing. We have to call sbi_ecall()
instead of sbi_dbcn_write_byte() to do that because sbi_dbcn_write_byte()
has been written to only accept uint8_t input.

So we'll need some sort of test for suspend where we pass a value
with high bits set for suspend_type when running the test on rv64.

Thanks,
drew

