Return-Path: <kvm+bounces-56994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ABEBB4982B
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 20:22:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 441C93A7FE7
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 18:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AFC930F94C;
	Mon,  8 Sep 2025 18:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xjNF0IBL"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E45E4A1E
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 18:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757355729; cv=none; b=atnzpJBNwzb3DE2jOxtjvKFX4qGg+W/JfC5q+/pRL9Yierul04Ybt6PyGsuRtaC/rat34bThxrLJYlM4h5J7wyYaRZLXu2LDq6alcMtSKQZ8H/cgISK2cgOly6UBiahkeXK2VJNQ8t2Ul8suuyqwHZ0YZm/RuWlJVS0b6D0k57U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757355729; c=relaxed/simple;
	bh=ym5TIfe18O8Nm5JVfIg5hJvPat8Rbw6KqK/SFQhZ8+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rYkP3JfPOdLXrWmPLB4CrXAdBBjKPKopV/irU7xIoqeHfiP7Yy36vUxtn3WE0PLqMUdMCD5YOPVMBbw/fVcWY3bFMT+7L3CkVf/6oV8f/0G1ogD9CwgRa3Vc0WHH/3yqeRnD/KM2IozI8WyMd7hcgrcSedANVEYXP1hW7mCsags=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xjNF0IBL; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 8 Sep 2025 13:22:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757355725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9BwobCK5UVhY5V+X/GkI4hjg0zbTCriLejOr/R4m5d0=;
	b=xjNF0IBLAwhqTVX0AULJIs/57tdFsvnGs5WKPa9uR30vgFyLJxHlwzTZOM4lG5HsWvK2UO
	rEn/Ue60PhQ3dKewTpqKFw3/dyRkLI3Upka9k2+7oCQN3KGF94q6ZF4kCoVvKf4C2MTBAE
	JWNfkUkIRJsiN0lZD7JidjdcWiMwWn0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, Shaoqin Huang <shahuang@redhat.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Thomas Huth <thuth@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	kvm-riscv@lists.infradead.org, Joel Stanley <joel@jms.id.au>
Subject: Re: [PATCH 1/2] build: work around secondary expansion limitation
 with some Make versions
Message-ID: <20250908-8ebb10e1e917a5befd6b5f44@orel>
References: <20250908010618.440178-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908010618.440178-1-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

Missing the kvm-unit-tests prefix and, for this patch, the riscv prefix.

On Mon, Sep 08, 2025 at 11:06:17AM +1000, Nicholas Piggin wrote:
> GNU Make 4.2.1 as shipped in Ubuntu 20.04 has a problem with secondary
> expansion and variable names containing the '/' character. Make 4.3 and
> 4.4 don't have the problem.
> 
> Instead of using the variable name from riscv/sbi-deps and matching it
> from the riscv/sbi.* target name, name the variable sbi-deps and match
> it by stripping the riscv/ directory name off the riscv/sbi.* target
> name.
> 
> Reported-by: Joel Stanley <joel@jms.id.au>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  riscv/Makefile | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>

Added the riscv prefix while merging.

Thanks,
drew

