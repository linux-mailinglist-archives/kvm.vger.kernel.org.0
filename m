Return-Path: <kvm+bounces-30871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E2B869BE10B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:34:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 81441B254DF
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D23F4199921;
	Wed,  6 Nov 2024 08:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HQ35r9h3"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EB2199243
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 08:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730882090; cv=none; b=SLZkRxeHzhExg1u9Ve2+zomxC58SlJldQbDMXMqiFSpt1k0Ye3itTNqvrLOzhrIi3IskB/+7cwMNBWhJHGmZM+zG8QQgpSnpHfNFBAoXW2WG4HiJemMYT3deaHln1Vzb8gvbz2RT3ttx7ZbXx1vm94SfrZNKBEPY/wI1Zp2FHIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730882090; c=relaxed/simple;
	bh=AgHOUucXYCDeZU9Z+uMqYKAJ/q20z/s+1V106OF3Tcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zk8oKeo16RamHRkdSYX/VYhqyVPscvl5Rwvbvn36P8KU3DRgcgTEmfIzO7XHMuLaCkk/5QofrNBZNqAYbhvuk1PPI4isn6cyM8ZsT6r1ukZ7zD+5BYSGskjKXDIKYLLZhmhdQkPIsdkMM+GXfXG1o7Q0RM8e8Z2T/L9Q6/PQDlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HQ35r9h3; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 6 Nov 2024 09:34:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730882085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AgHOUucXYCDeZU9Z+uMqYKAJ/q20z/s+1V106OF3Tcw=;
	b=HQ35r9h3lDf4uNebwEXk3Js8p8PM1dx+qhdFtaB/0yBx2aETap4XwcVcZIBcFN4oub3/kc
	Fta5AGKcRolxCGX7TDIqZq/oCQnI1gMAanMvUPt8dG7mnlVzXm6L0JSHQ5pXf3n/QGfwlm
	OHeAfSfHbwdH/k94aCcrkII8JKtqGU4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH 2/2] riscv: sbi: Improve spec version test
Message-ID: <20241106-279caf8ceef5bb9e4005d1d5@orel>
References: <20240911113338.156844-4-andrew.jones@linux.dev>
 <20240911113338.156844-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911113338.156844-6-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 11, 2024 at 01:33:41PM +0200, Andrew Jones wrote:
> SBI spec version states that bit 31 must be zero and doesn't say
> anything about bits greater than 31 (for rv64). Check that bit
> 31 is zero and assume all other bits are UNKNOWN, so mask them
> off before testing.

The spec has changed for the 3.0 release to also require bits 32 and up to
be zero for rv64. I'll send another version of this patch.

Thanks,
drew

