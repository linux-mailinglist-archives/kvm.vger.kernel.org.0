Return-Path: <kvm+bounces-19416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1B62904C88
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 09:16:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2FFC1C22B9C
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 07:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71D2E167270;
	Wed, 12 Jun 2024 07:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T6OIPsFO"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E333EA66
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 07:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718176604; cv=none; b=iCqdWp8MqeNZFUEjsokBbi8pL1EV0OPNJ+4ipto9pZfB3mtFrAK8njvPFf7wZLFRSF8VscSS5Y9I4Pemhe4dwQFNSHyOCmICeKYmHLd9cUYo0dL+VP6zt+Pr286AsE+tWqHJzwzRbUzIX+FKpltX0jmD0XHcwSHRllp1D6gRjmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718176604; c=relaxed/simple;
	bh=pqdphX73erOQorSDCDxeyZFJzasthTIdZKhwq/R7rmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ri5SexTuZd2wvjfbe2yuw86m19Yd/dAZjlCIu9ch+oD455EgCPormcvnWiSUAkNjkTqqBvOX1SAJZPo+39lOB+r+lZfBGLhu2KrOkKJylebEg+pvGRmbH3ZaMkrxSeeeNcuSuHoOePTkBs+VE5Rv9t0y9gqc6tCUX8apuEM6Vjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T6OIPsFO; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: npiggin@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718176600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HHB/lYVyp77gev3X+Spg1bAYCcC3JHUd82+j9ExIkfI=;
	b=T6OIPsFOXMYRNCAJuz6xX2hI+M4U0kJnhGxH3oUL4xlpquC0ysCPZ702s0XnDA5vf2IYte
	mSGh6DBq5eOnxD8ylbk7sPjqxCu7wFQLKyFkHjVhxFICVkY+IbFj7fpDGgfligKPXitLSy
	J3HlfKfp4vO5VbEuL+IuBoFGsv+3Xvk=
X-Envelope-To: thuth@redhat.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: mhartmay@linux.ibm.com
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linuxppc-dev@lists.ozlabs.org
X-Envelope-To: kvm-riscv@lists.infradead.org
X-Envelope-To: linux-s390@vger.kernel.org
Date: Wed, 12 Jun 2024 09:16:36 +0200
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org, 
	Marc Hartmayer <mhartmay@linux.ibm.com>, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] build: retain intermediate .aux.o targets
Message-ID: <20240612-39939298ecbc2ba78479a2f2@orel>
References: <20240612044234.212156-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612044234.212156-1-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 12, 2024 at 02:42:32PM GMT, Nicholas Piggin wrote:
> arm, powerpc, riscv, build .aux.o targets with implicit pattern rules
> in dependency chains that cause them to be made as intermediate files,
> which get removed when make finishes. This results in unnecessary
> partial rebuilds. If make is run again, this time the .aux.o targets
> are not intermediate, possibly due to being made via different
> dependencies.
> 
> Adding .aux.o files to .PRECIOUS prevents them being removed and solves
> the rebuild problem.
> 
> s390x does not have the problem because .SECONDARY prevents dependancies
> from being built as intermediate. However the same change is made for
> s390x, for consistency.
> 
> Suggested-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arm/Makefile.common     | 2 +-
>  powerpc/Makefile.common | 2 +-
>  riscv/Makefile          | 2 +-
>  s390x/Makefile          | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
>

Acked-by: Andrew Jones <andrew.jones@linux.dev>

