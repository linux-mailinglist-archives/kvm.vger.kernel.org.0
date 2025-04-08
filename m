Return-Path: <kvm+bounces-42947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 09369A80FBD
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 17:22:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B1BF1894CBE
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 15:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAAED22CBE4;
	Tue,  8 Apr 2025 15:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xuIjBJRg"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE4622B8C5
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 15:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744125403; cv=none; b=tkn1+H5OsQEIfQGPIUTtBukcDHxVxcbHkmC8SCulQ9LQLzbFBF7Yh2NE7bm628tZtl8QHSytVif6S/dP5Xe04rWmY92Acti7B5t3fqV67WRMgzY8e7pkvcbbRZuoEkc/qM2PfqWYHPfljqg8/ODOJcbiBPec6abRTzupz2kB+Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744125403; c=relaxed/simple;
	bh=gX/HtAFsehz+4c62MBEPII8lHONvsSA4AAyW31gsemU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CE6a73wPNFWS6Q9SybR4tF7Zttonr/wcDu053EALhlsMrdg01xbK3+fCxVZay7xZE82krU2+8LmoNPkMSXQC+woOzkB0rxAXRFNtu33J1ZWTpPdptShKglwN6czlzElVfIYm6SGlVvRsX5E/r+ofqMBa8zTx4YZ380rqELfXyv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xuIjBJRg; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 8 Apr 2025 17:16:36 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744125399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wmc1pf0dMe1civmuPe4PR0IF2C08oxETmfh5prhw71Y=;
	b=xuIjBJRg3cgiIsPSc3jONNRS85OpGCFPuDO8OLg9NMBYHr9Es9LJHG35OsqYvsJ3iZKCr5
	3qYPBaImOWgXyfzgxJl1cAlw6uSfm5iuVos5BrEsWlqG/RPgXxxn6KNrAR0rfPB62u9iZz
	4TY6BPImiVgC4loEQvvTlHOiKsnHIHw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v4 0/5] arm64: Change the default QEMU CPU
 type to "max
Message-ID: <20250408-e5599f590076931ea514679c@orel>
References: <20250408132053.2397018-2-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408132053.2397018-2-jean-philippe@linaro.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 08, 2025 at 02:20:49PM +0100, Jean-Philippe Brucker wrote:
> This is v4 of the series that cleans up the configure flags and sets the
> default CPU type to "max" on arm64, in order to test the latest Arm
> features.
> 
> Since v3 [1] I renamed --qemu-cpu to --target-cpu, to prepare for other
> VMMs.
> 
> [1] https://lore.kernel.org/all/20250325160031.2390504-3-jean-philippe@linaro.org/
> 
> 
> Alexandru Elisei (3):
>   configure: arm64: Don't display 'aarch64' as the default architecture
>   configure: arm/arm64: Display the correct default processor
>   arm64: Implement the ./configure --processor option
> 
> Jean-Philippe Brucker (2):
>   configure: Add --target-cpu option
>   arm64: Use -cpu max as the default for TCG
> 
>  scripts/mkstandalone.sh |  3 ++-
>  arm/run                 | 15 ++++++-----
>  riscv/run               |  8 +++---
>  configure               | 55 +++++++++++++++++++++++++++++++++++------
>  arm/Makefile.arm        |  1 -
>  arm/Makefile.common     |  1 +
>  6 files changed, 63 insertions(+), 20 deletions(-)
> 
> -- 
> 2.49.0
>

Merged through arm/queue.

Thanks,
drew

