Return-Path: <kvm+bounces-51294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A33AEAF593D
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 15:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 027631C21BC0
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 13:33:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C825253F35;
	Wed,  2 Jul 2025 13:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="njUl/S1J"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F741288505
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 13:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751462659; cv=none; b=MGDxJu7Z9xGuJSMAOPPCO+NmF/LVABkF1g1/9IHsLXa49hmKyaGBOCpTLGeKSBqXvNV4vMRRjjLzFT1NH7Wv0DKq+ZjymzH7cDZB4Eaf0yjbc/FhxWZMkhu0WRSMN3mhOy/ZUxc1y1f7DkdS5gu9T+6K8CLtUfmq4ma2MANNu3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751462659; c=relaxed/simple;
	bh=5EiOjds2vB+gMgLQ7AStKRdExlaGgzg2mi5kPwaDXMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nQvVkV/aZ099bHvfWWcIMos35DMzIaCh8sfEoqn3Ak9En6CLgX1Jut8Z3oscuxCYYCvSuRS62tUjfca22p36LOKCams+XyR4714mMfbSZxSeCcUp9MQECr2K/jJyDwuQTSlxol1lk67NDPgZkxu+fUJo0M/71+4zBw18EQYS1h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=njUl/S1J; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 2 Jul 2025 15:23:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751462643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NawVbpSzRrmU/5OP7w4Gd875xIZHo3tZ7VQMBiyqhsU=;
	b=njUl/S1J5KSb4kx5muBTkGIWSbXrroDfp86PXT14WPw5N7Hu/x/hpj7G9kte4LDcww6tj1
	sLFenV29ksanu71IRWzpzXNj3kRSc4qywDU4NFLZJM7H9cWGJsHjGlArX7DoAw9afh/IVk
	ghR3vKM0KttIIQr6AY6akrhIyQ1vgu4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, pbonzini@redhat.com, 
	eric.auger@redhat.com, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, david@redhat.com, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 0/2] scripts: extra_params rework
Message-ID: <20250702-4e182ba58316d478d49a1ee3@orel>
References: <20250625154354.27015-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625154354.27015-1-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Paolo, Thomas, and others,

Can I get an ack on this? I'd like to merge it.

Thanks,
drew

On Wed, Jun 25, 2025 at 04:43:52PM +0100, Alexandru Elisei wrote:
> This series was split from the series that adds support to use kvmtool when
> using the scripts to run the tests [1]. kvmtool will be supported only for arm
> and arm64, as they are the only architectures that compile the tests to run with
> kvmtool.
> 
> The justification for these changes is to be able to introduce
> kvmtool_params for kvmtool specific command line options, and to make a
> clear distinction between the qemu options and the kvmtool options. This is
> why qemu_params was added as a replacement for extra_params. extra_params
> was kept for compatibility purposes for user's custom test definitions.
> 
> To avoid duplication of the arguments that are passed to a test's main()
> function, test_args has been split from qemu_params. The same test_args
> will be used by both qemu and kvmtool.
> 
> [1] https://lore.kernel.org/kvm/20250507151256.167769-1-alexandru.elisei@arm.com/
> 
> Alexandru Elisei (2):
>   scripts: unittests.cfg: Rename 'extra_params' to 'qemu_params'
>   scripts: Add 'test_args' test definition parameter
> 
>  arm/unittests.cfg     |  94 ++++++++++++++----------
>  docs/unittests.txt    |  30 +++++---
>  powerpc/unittests.cfg |  21 +++---
>  riscv/unittests.cfg   |   2 +-
>  s390x/unittests.cfg   |  53 +++++++-------
>  scripts/common.bash   |  16 +++--
>  scripts/runtime.bash  |  24 ++++---
>  x86/unittests.cfg     | 164 ++++++++++++++++++++++++------------------
>  8 files changed, 237 insertions(+), 167 deletions(-)
> 
> 
> base-commit: 507612326c9417b6330b91f7931678a4c6866395
> -- 
> 2.50.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

