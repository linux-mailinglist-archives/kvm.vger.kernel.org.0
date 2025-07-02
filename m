Return-Path: <kvm+bounces-51303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6D45AF5B6E
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 16:43:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 685524A4CF9
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 14:43:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75D0C3093AC;
	Wed,  2 Jul 2025 14:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tMB35wON"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011E72F5310
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 14:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751467418; cv=none; b=Y1Wx4D3eX4emski8Zw+xp0LoTP9MFyD6EP+zIgid8F+wTSerTzMTzujGEKaPwTk7s5AeWGU9aEzH1fOfimX55c1WIfGH7YIlb9TF3yaJm5vg6SOyKGQibPFrzxzcRSaj1zWB1SZUZaekzVqWxSh1Oe9Hwpj/3aSAvgjAK1AR2R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751467418; c=relaxed/simple;
	bh=43pDMyNOCKa79U0Do3mjd5FGHY7ZmX47Ylj4IJlRccU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vore+gOiIY7/SlJvJ8Q0fdiXsRbEluKjFZSEStyYMpSX3eGHfS6byJaxcTD9NUXqpMhqzWrSSKYBVztsH3VGdUKV/CNv1NoV3DdnzFwiE9m/eWxWoT9UNQn/el1zrtBLHSUNSECma8DlbjSlZ5nnvzLBGghheoHJAm6hBbS9z8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tMB35wON; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 2 Jul 2025 16:43:29 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751467413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hLpYSU2x8Yb+ms57gtIv5GTWsp2J7egzMbr/41MK58A=;
	b=tMB35wONgUnX/RY8EVbuddM+tRjah0aNJvRs+zfhzT1twzs8JGQJGtXLMmTRAO1CotFCXJ
	4VcTz0f1nBwFkYeTYEyrB10GABY5bd6THfn9xaZt8C1zEMT8JfEn9VnBUvNC1O5elFTtEm
	nYNAfSccXsd3E3EdauPmjNKdkCN5K+Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jesse Taube <jesse@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, Atish Patra <atish.patra@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	=?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, Himanshu Chauhan <hchauhan@ventanamicro.com>, 
	Charlie Jenkins <charlie@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v8] riscv: sbi: Add SBI Debug Triggers
 Extension tests
Message-ID: <20250702-398267de396e3a03f6d3982d@orel>
References: <20250701200047.1367077-1-jesse@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701200047.1367077-1-jesse@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 01, 2025 at 01:00:47PM -0700, Jesse Taube wrote:
> Add tests for the DBTR SBI extension.
> 
> Signed-off-by: Jesse Taube <jesse@rivosinc.com>
> Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
> Tested-by: Charlie Jenkins <charlie@rivosinc.com>

Merged. Thanks

