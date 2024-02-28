Return-Path: <kvm+bounces-10233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 974FE86AE2A
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 12:52:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 516B62968B5
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 11:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDEF11534ED;
	Wed, 28 Feb 2024 11:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SlEmAVBK"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CAA14F9D5
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 11:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709120878; cv=none; b=MDwQ6kDiHw6oedu8zSt+M23tj9lUJFep+oynGTBdJli22tVIbp1pMcCJnvoGEnbsVWnHPGrGxjWjWi/qKVXJfYMvRiJGzvkkscBXXpvyddz25ANCOjxDJn+gFZqvjDp46WaG0Rv8WXLPRtISyAo6Zzp8utHCRJjNVacYIUaLEw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709120878; c=relaxed/simple;
	bh=IcH9yAGfcYi+Z5zIn3bjDiPBTLFmfLMb7d7MbWHYpEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ijqiKr5IQDzJpyntSpNWKV3wNWf2sE+JXkjz4n/ayAEYuUy6oyUCswLgS8yadSQWNfOD7z7KE9K0q35ss40KNDJ2Q0LK96HsedhhqSWt/AEnk/r4ryinMLSKPIHMdBnvv0CDC7HbDeCeVA+ZnTsSJCn2N54gqR39pSScInHmqeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SlEmAVBK; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 28 Feb 2024 12:47:52 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709120874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Au6hwmd26uHWeon8xSbDYZG4pXatYbizYk+xmJMEcsA=;
	b=SlEmAVBKKFKRJDwYiU0Un070dqwwQCQ0bIWzjNGbgDc0nhtIdnyfPA9NvcEm5mYYQknXF1
	ngFKFTYiiJBUgc3i/1Fg6HU8LnJdaklbfb2W6uL0YOgljJGoh5SM0LFtKbRfkDGwM5R6+Y
	8jyGT86VTQzbB9HrOBvn6p4cv+mIg7Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 09/32] scripts: allow machine option to be
 specified in unittests.cfg
Message-ID: <20240228-386d106a6ef0bc0430edad1a@orel>
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-10-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226101218.1472843-10-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 26, 2024 at 08:11:55PM +1000, Nicholas Piggin wrote:
> This allows different machines with different requirements to be
> supported by run_tests.sh, similarly to how different accelerators
> are handled.
> 
> Acked-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  scripts/common.bash  |  8 ++++++--
>  scripts/runtime.bash | 16 ++++++++++++----
>  2 files changed, 18 insertions(+), 6 deletions(-)

Please also update the unittests.cfg documentation. Currently that
documentation lives in the header of each unittests.cfg file, but
we could maybe change each file to have a single line which points
at a single document.

Thanks,
drew

