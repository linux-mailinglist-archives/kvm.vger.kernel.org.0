Return-Path: <kvm+bounces-41748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 524AAA6C9CF
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 11:49:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E9B4173BC4
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 10:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C00A31FC107;
	Sat, 22 Mar 2025 10:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gNaOjZ57"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1066D73451
	for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 10:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742640498; cv=none; b=tY3obz6jLzRqr2v+n226GQX6Aca1F6bJfAHfH0hhMmx2XuVzsEl4q/Hn8KducEVhuYswB00oWGBKw9oCEkgjIsQ7aRIdWZQrtKyGGx/8nXXfO1Y92AZWCFWAIWgsPdX3iboYj00Xc4RPt7VbbrHaOsbeREj9OH3EPgK+dmHgAJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742640498; c=relaxed/simple;
	bh=E2b6hjEIOzJItYPZJkkRSLcT1zRYfKN2K9AK7m5cW9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ITCESl0WsDr6p8Ma85s9huTnRhQnx1caTOcZ1k8CO9x6OjVp4qwX4IzQjoY8hwUIYWCndFF4/b94NrjMic0B65i8HfkrQYsfR7QcCQUjTGN+TSej306TpDCXDl1cCF4wS5xmpFnep1m/afIOuEvHjPPdb8iFrPNEKTTj8LY/28U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gNaOjZ57; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 22 Mar 2025 11:48:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742640490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wn29wkw4lJ/HX1M//ZeuBjOJOnyNbjZGKoW8F3SeT1k=;
	b=gNaOjZ57KCDZqbczOlJuy4EEgJoLoj/bylPO/xONqr/ejg0ZBzySrWwn3khY9DYLXHEbGv
	cIT/Mq6pGckDYELvzSP/wjJho4IdF50nsnc8RNU7DjHDwpYcQBRvZDVXH/eIAG4dNhUEfW
	czdjr94Kmt2IjnNn7IZ2skxbkov9dGs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Akshay Behl <akshaybehl231@gmail.com>
Cc: kvm@vger.kernel.org, cleger@rivosinc.com, atishp@rivosinc.com
Subject: Re: [RFC kvm-unit-tests PATCH v2] riscv: Refactoring sbi fwft tests
Message-ID: <20250322-143746817169ae3eca096cb8@orel>
References: <20250313075845.411130-1-akshaybehl231@gmail.com>
 <20250313171223.551383-1-akshaybehl231@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313171223.551383-1-akshaybehl231@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 13, 2025 at 10:42:23PM +0530, Akshay Behl wrote:
> This patch refactors the current sbi fwft tests
> (pte_ad_hw_updating, misaligned_exc_deleg)
> 
> v2:
>  - Made env_or_skip and env_enabled methods shared by adding
>    them to sbi-tests.h
>  - Used env_enabled check instead of env_or_skip for
>    platform support
>  - Added the reset to 0/1 test back for pte_ad_hw_updating
>  - Made other suggested changes
> 
> Signed-off-by: Akshay Behl <akshaybehl231@gmail.com>
> ---
>  riscv/sbi-tests.h | 22 ++++++++++++++++++++++
>  riscv/sbi-fwft.c  | 38 +++++++++++++++++++++++++++-----------
>  riscv/sbi.c       | 17 -----------------
>  3 files changed, 49 insertions(+), 28 deletions(-)

Merged.

Thanks,
drew

