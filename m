Return-Path: <kvm+bounces-45737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CE4CAAE60E
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 18:09:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DA613B02EF
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 16:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EB0D190057;
	Wed,  7 May 2025 16:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qnydbb3x"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D897328A705
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 16:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746633768; cv=none; b=BxsqiEmgu7PHjw1gHWDw9hwjLU2/MA0Q9/wbM6/NUMJvuFdd95H5hQ2lt6dSjK4wvtgB/alth8zV/5TDLinZMWdCVYZpOnt8hYwtADsnJ/RLMJ8vjj60AtqmHJ6o7ux36K+zecr2VIDx8JHlWNHtFDu0ExDb8LTKUm4aYME9kU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746633768; c=relaxed/simple;
	bh=pV3TiNt2PoCcUb95Y2dGMH+jY3Sq3CHb0L+xH3RIHdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cdcs2gt0Y7TbMkF9UVmuaPk5qcqjG5ECfUrZVvfaYGHiX+qX/xQWfGyrVZ3f326f3e7H8UKrwHLPFAP9I5zRsr+VgkUQueM/4YqbH4LBIzqygZw5RN0vXg2Awcij3ydESITxBBH18PdqyAJuJ2TOOSnoyVDr7npnu4h5WTYWMts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qnydbb3x; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 7 May 2025 18:02:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746633754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4sAt9jGqtjjuAu3AgUOHLrQORncUHd8FqoP4fvAA0kg=;
	b=qnydbb3xFdGbLQifmPErPW1DnOoiQgr2a2V28pycc4PkDj8V7yypsPLcvozd5Sq6E4YFjI
	bzWOadRjXBPASa/sWwBsVRH4CnEeWAtpDr7WRHM7m8DQM0gEbzoKVHTHFaphzKWAEAcnhO
	80z3pXFEcgz+TmwJjMBc0VLlEYYCE3g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 03/16] configure: Export TARGET
 unconditionally
Message-ID: <20250507-78bbc45f50ea8867b4fa7e74@orel>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-4-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507151256.167769-4-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, May 07, 2025 at 04:12:43PM +0100, Alexandru Elisei wrote:
> Only arm and arm64 are allowed to set --target to kvmtool; the rest of the
> architectures can only set --target to 'qemu', which is also the default.
> 
> Needed to make the changes necessary to add support for kvmtool to the test
> runner.
> 
> kvmtool also supports running the riscv tests, so it's not outside of the
> realm of the possibily for the riscv tests to get support for kvmtool.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  configure | 36 ++++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

