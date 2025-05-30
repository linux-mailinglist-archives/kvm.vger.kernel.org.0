Return-Path: <kvm+bounces-48079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F016EAC881C
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 08:04:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DBE44E2EA2
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 06:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AA621F875C;
	Fri, 30 May 2025 06:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KwCSC3mc"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342F91EF09C
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 06:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748585043; cv=none; b=EL3GvgA/IyuLhOA516ZSce5CPNx0IrvpSF0fv6ojmfV6l3aieyNPKzFYQFdOgFS6JsUAhw3MvDWK8+sKC16gEjtdHxrZkSeAewSDxX+d77QqyKPhIeZfN40h/wvhcdWipzQHlHF91fsO22mIxhXvAl0oc/N2pf+vd0/EgoLFG5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748585043; c=relaxed/simple;
	bh=Mr5ab+RNAEooPaLWh/kq0l7aF/f2frfB3WGbkt1h4xs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d1KSAxoN2dE9WUAL2YSjUbcDe1Vw+VggxUVa4U9ylPb/q4saqfslMkavmBlzjRYg5KfW89Iz/cAo7wZYsHr/TQGrAuIYS1DaNTpMzzxjpwx4HYGeHIjMgTEpayh4ZntGYE/8E4T3IotRIhyN9PZN1htFJfleGrlsGvLXF0BVrEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KwCSC3mc; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 30 May 2025 08:03:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748585039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kt+Vc3qTvvhvRuKl8DLuOB5hRxkIZdLx7zBcCNyOWIg=;
	b=KwCSC3mc9hChL91h8ijG31sFo6JZLkOHVU3kPqunRa9nvZkRj9H/0XekGqrcYFI8mMTOXx
	74DS+TacKbnBgQ57OMcvSQ3yCBOT18ruxjWgXZ40tWNPnWyApnUZEyw3Xde839qzuQPDpx
	/dKeHpvhzaPHRVmJGD1AfWNgR1Pj3zQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Nico =?utf-8?B?QsO2aHI=?= <nrb@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 01/16] lib: Add and use static_assert()
 convenience wrappers
Message-ID: <20250530-02c84c0db9cd2199b2cf6d28@orel>
References: <20250529221929.3807680-1-seanjc@google.com>
 <20250529221929.3807680-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250529221929.3807680-2-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, May 29, 2025 at 03:19:14PM -0700, Sean Christopherson wrote:
> Add static_assert() to wrap _Static_assert() with stringification of the
> tested expression as the assert message.  In most cases, the failed
> expression is far more helpful than a human-generated message (usually
> because the developer is forced to add _something_ for the message).
> 
> For API consistency, provide a double-underscore variant for specifying a
> custom message.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  lib/riscv/asm/isa.h      | 4 +++-
>  lib/s390x/asm/arch_def.h | 6 ++++--
>  lib/s390x/fault.c        | 3 ++-
>  lib/util.h               | 3 +++
>  x86/lam.c                | 4 ++--
>  5 files changed, 14 insertions(+), 6 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

