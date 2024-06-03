Return-Path: <kvm+bounces-18599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 121B88D7C17
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 09:00:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43E0E1C219C8
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 07:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82CFD28DD1;
	Mon,  3 Jun 2024 07:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UlfO50L3"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A172E414
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 07:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717398010; cv=none; b=ulxvciAeADC22Wh8AxShDGZTvA1qX8O9yt+yP0yAwfQYl8A0/64nWEIzJ98dIx1Cqf6lr1GJqGfil8MViCg4SpU0kj6eFBpDWeDJcbz5008C0mV3yONC8Dd20Z0ymWGSmq0uH/CUxuZpc202pi98A+WgczHQ3fZqpvZbvVHSsBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717398010; c=relaxed/simple;
	bh=/Rt2wMwvRA0dVhlzBZGIdJuY1gMBvdNywxhtRQHvQjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VvjYhpv8oa7hkZY0ehJvkoR05iN6CB/jER6JB+nBobYf1/Y89PZEjC7VBwgOTyQ9cNbC8iCG2fKn8veYRmxS1k3YJWnEtpj+FQE5hco2kTv5i3Cv00HRBbpcxvSmiXSy8E8AEDfPNfXAg+TjWXRlg1Hy7AYmASpNkWUTrj3n+ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UlfO50L3; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: npiggin@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717398005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7hcC6Pz4VgHldWXSbuY3yv0FZ/+WkDjAFZr+qUgvOfA=;
	b=UlfO50L3XHjLg8+UpStphjyk+VT9+HwAp1+1nC8x2x0ZsiktAp7BmbrniRjAOTiHZoTiZz
	pYA4TftXe2OaswWp7YbMrnUWtsLler+T/MrLkf4KIBi1v1E9CHJP6MaTt6oPcR5hvseEgy
	8ZmZVvKbnFtkQgibI2IMdr38vVsMU20=
X-Envelope-To: thuth@redhat.com
X-Envelope-To: kvm@vger.kernel.org
Date: Mon, 3 Jun 2024 09:00:03 +0200
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 3/4] build: Make build output pretty
Message-ID: <20240603-581d9d0f3d497d69c6a4007b@orel>
References: <20240602122559.118345-1-npiggin@gmail.com>
 <20240602122559.118345-4-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240602122559.118345-4-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jun 02, 2024 at 10:25:57PM GMT, Nicholas Piggin wrote:
> Unless make V=1 is specified, silence make recipe echoing and print
> an abbreviated line for major build steps.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  Makefile                | 14 ++++++++++++++
>  arm/Makefile.common     |  7 +++++++
>  powerpc/Makefile.common | 11 +++++++----
>  riscv/Makefile          |  5 +++++
>  s390x/Makefile          | 18 +++++++++++++++++-
>  scripts/mkstandalone.sh |  2 +-
>  x86/Makefile.common     |  5 +++++
>  7 files changed, 56 insertions(+), 6 deletions(-)

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

