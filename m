Return-Path: <kvm+bounces-51751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 02B11AFC670
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 11:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC7FB7B2E5C
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 08:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D6EA29B224;
	Tue,  8 Jul 2025 09:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cdRGwi3q"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B94A932
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 09:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751965238; cv=none; b=gb6YapnRBYQVToKhS5tJAyxvpRSoL4NcCY5BjSEjS6V7dLcuGFbZdyTyboyvTNGB/U3GL8JcLAe1RiQ01OTrDt1NSsbGS6cRdqKdOxaMw3Qwxh3JGS1Kl8IqXsJD1F+FO3XhFCB3l7LXDVepR+IIs+l0T50E626TMt1NKtMH9UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751965238; c=relaxed/simple;
	bh=Mw08V3r1vtYutAOvt3AQFC8ELsnBU/W7g2ucGWynMSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xy6WjDPHgXjNNFUY6kqDa8iCm3iOCi8D1pwejZlMzx6NawNM5E081Ynw9ARNYbGJDO7qj0cam+3xkVUJpd8YtVNqafdQGxPIjp2HwZ6JSjWtMUAsEGJ0QoOgklH54qedwwz2XL9SHyYb3uOCibnBXLTr0aGBJ6QGDegSJiPGRuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cdRGwi3q; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 8 Jul 2025 11:00:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751965224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AYV9Gt6GV7S1sBDMLX2bVdkgins9MvusBmTdZ9RaebQ=;
	b=cdRGwi3qrP6mufrMy4fWWBHQ3HqGIRKNF1wDZrd7mXiTELg0s6uKYWkcTWzAMTdOw/5BB2
	FlsHBIPnat+nXZ7FlUjM9MZ2wZZ4BRrDDP7IVwzglgU9jZbAuMsUJgMjTQFkj+Q6JGFYjQ
	xelBn8V3G41a0ravrFO21HNn58EtrWg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org
Cc: alexandru.elisei@arm.com, cleger@rivosinc.com, jesse@rivosinc.com, 
	jamestiotio@gmail.com, Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH 0/2] riscv: Add kvmtool support
Message-ID: <20250708-5524f73ffad755512205adc5@orel>
References: <20250704151254.100351-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704151254.100351-4-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 04, 2025 at 05:12:55PM +0200, Andrew Jones wrote:
> The first patch is for arm's scripts. It adds a check that I found
> useful on the riscv side. The second patch enables riscv to use
> kvmtool too.
> 
> Andrew Jones (2):
>   arm/arm64: Ensure proper host arch with kvmtool
>   riscv: Add kvmtool support
> 
>  README.md     |   7 ++--
>  arm/run       |   5 +++
>  configure     |  12 ++++--
>  riscv/efi/run |   6 +++
>  riscv/run     | 110 +++++++++++++++++++++++++++++++++++---------------
>  5 files changed, 101 insertions(+), 39 deletions(-)
> 
> -- 
> 2.49.0

Merged.


