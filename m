Return-Path: <kvm+bounces-17189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 549AB8C2797
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 17:23:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 142C21F26848
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 15:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18FBE171658;
	Fri, 10 May 2024 15:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dAW3R3rq"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05D717109C
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 15:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715354630; cv=none; b=jY/EifyF4Yd3I3twD4ADm2Irdz4HguXqzJJYj1rDU6wTSbTYmV3gaqGxFRjuVjE4KO3P9qHnQqJeY59rEQSIXwaeN7y3d0gPYWDrYUwy8yd4Kah7AtPAHqrr2WSKaeTNRSvcm9J1APbciI4UwewbZpj07OdnPSOGoNqZnb+h52Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715354630; c=relaxed/simple;
	bh=ImhhldqhYifhnmrsEXBkHlokCaenUojeDZvoUmMFshc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=db8EvHryO1Z/Wv0Z7gqFoHcW8igmSqwNgMjKDl96AJ7pKPnG4N97YE9t0Zryth97ktfLLNfICWlMsVTGB9a2ep9MCnYm9WY9y+RMv0OthcbAgf7c6J7626mqEIhZKRmzVPkpSVfn7drdGcECtZPIaBwHRA/yPBo6AsXaHPr1yvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dAW3R3rq; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 10 May 2024 17:23:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1715354625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ImhhldqhYifhnmrsEXBkHlokCaenUojeDZvoUmMFshc=;
	b=dAW3R3rqTS0jgPVmtgVcGP86utcH9p1p81VImhTZ9jLlVnjg5xkJg16wM1rXHMYIKMf+ae
	ivobBGvWNywNCV1X6Gx8/zKRd4iJ6ueT2itcLz3z/31vaHF0fUDolINUF5kPs0z3F9ajP5
	dTKeS1ikdXY6A+jipxD0M7iTs44yhcM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, 
	alexandru.elisei@arm.com, joey.gouly@arm.com, steven.price@arm.com, james.morse@arm.com, 
	oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 00/33] Support for Arm Confidential
 Compute Architecture
Message-ID: <20240510-c7c63400b20593191a8d8fc3@orel>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 12, 2024 at 11:33:35AM GMT, Suzuki K Poulose wrote:
> This series adds support for running the kvm-unit-tests in the Arm CCA reference
> software architecture.
>

Queued patches 1-3 and 16-18 (modified 18 to drop references to realms
since it's independent of realms). Also fixed EFI compile errors with
"arm64: Expand SMCCC arguments and return values" and "arm: Detect FDT overlap
with uninitialised data"

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue?ref_type=heads

Thanks,
drew

