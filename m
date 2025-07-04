Return-Path: <kvm+bounces-51565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C155AF8C76
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:47:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29372189FBA7
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 219EF2E425B;
	Fri,  4 Jul 2025 08:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="urgOd1aZ"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ECB2882A3
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 08:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751618526; cv=none; b=iGy/UFsZ8PjVZb2nOWrZLOfNdNdMmXmq8n1jG7kjGNxDVFEKHyCpdb/rysNW/oxJqFxsWR4vK9oqHtX5Sf5kQspX6kCCIb87pgMk13RuJLymIMgMkyioTLkJPjkmSlwGn1azdquh9oNaGshEq3vxcYg/GT7gyDrEwdkPCkGuaWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751618526; c=relaxed/simple;
	bh=l+Iq4K1uoyGqCoRNhi5p2zA2usy7g3Wf+XI25md6eEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LApmjdUGgz/w1o9Bl3mJ07HRqu7qjwGDt6VavMQSCB+YGbXahT0i1eiIgEBdaRwlnRuiVhUPJ8+YddXwK8dljFYwa+dLwQnqnlLLl5gHLLho4VKvUa7WARDXGCMIgHiwnhvFPrDDwleWtfqfsfJzaVrLSr9RGdMFXF07UaQmvSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=urgOd1aZ; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 4 Jul 2025 10:41:57 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751618521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3PnaSGtLpzW5dir2K2BrEyMD5UpUXb/WyC+H8PujG7Q=;
	b=urgOd1aZHEwU+HOxLQWi5GvXP2k5P56SbDD8NDOc49RcISR8mr1EFZbcesPVRdbN1m7oAh
	kUPg88LuxHtjy2dAyNloPJXePywzyt89TRKSuW8cK4SqhYp1NAMI2dsOwHn9bbuihdkScS
	hMJrMblwswPleTxW+/PJzf6Xl6mDONM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com, shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 00/13] arm/arm64: Add kvmtool to the
 runner script
Message-ID: <20250704-ca0e2f54c803b35428c13e0d@orel>
References: <20250625154813.27254-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625154813.27254-1-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 25, 2025 at 04:48:00PM +0100, Alexandru Elisei wrote:
> v3 can be found here [1]. Based on top of the series that add qemu_params and
> test_args [2].
> 
> To goal is to allow the user to do:
> 
> $ ./configure --target=kvmtool
> $ make clean && make
> $ ./run_tests.sh
> 
> to run all the tests automatically with kvmtool.
> 
> Reasons to use kvmtool:
> 
> * kvmtool is smaller and a lot easier to modify compared to qemu, which
> means developers may prefer it when adding or prototyping new features to
> KVM, and being able to run all the tests reliably and automatically is very
> useful.
> 
> * kvmtool is faster to run the tests (a couple of times faster on
> my rockpro64), making for a quick turnaround. But do keep in mind that not
> all tests work on kvmtool because of missing features compared to qemu.
> 
> * kvmtool does things differently than qemu: different memory layout,
> different uart, PMU emulation is disabled by default, etc. This makes it a
> good testing vehicule for kvm-unit-tests itself.
>

Merged. Thanks

