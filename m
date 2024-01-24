Return-Path: <kvm+bounces-6825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FC3D83A6A6
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 11:22:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC5A928BC8F
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 10:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6817B18E20;
	Wed, 24 Jan 2024 10:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q2M4WHig"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12D318E10
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 10:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706091715; cv=none; b=Zmuk+RQs8P0xeHQ5q3pLA0znYS4yr8FCd/XsuSEl47hvX7vbTVoLs3dJwJwe5pNIt96CspJOJ5mVGFpDY+zA8bSAfF/lHNVj9mz0GIbVC7rf3VWt+Welw1zlcgrii4SDt6D/0E8IIsBzc/2SKTRcfVRmJ2ubo24VmE5wfF3tW6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706091715; c=relaxed/simple;
	bh=DW/Zid75nYtAKL864xbUfrtgy+MkZ3LvxRolt5C62pk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gaMJjLhXm8awsfY5Zxt7+oDiRAgKBSu6AYukhDslWPdg8ZbgMWExweuNpCyEYhaS1KMnppcshvfl5cmco9LT4QmOx4WKBNNXLyD5geLIzcJlxkIXSy4QT35GduFIl3qZNjBI6m17TjI3G6S5FlsrQBSsXd+O/ClTjNSpRd9oyWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q2M4WHig; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 24 Jan 2024 11:21:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706091710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GM3MEUQ3Kcjrz3xfmFPpbVxXKjMf8RlianzQLfEQ6uM=;
	b=q2M4WHigQ+FLzqB91oFm8be1nTm6wKGHOqfi+PSeFtHmMFGbHoNanUMG11IuBB/Ayo2qer
	gpuikqTlSiaFs4wxy410Vfi6uhKv9cH0elo9iyL9Jifl7TgmOpd6TQ2fuk50aPiaMxn6Rl
	JOduEAUF+J7TMkE5KqrlHvpigXognrk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev, ajones@ventanamicro.com, anup@brainfault.org, 
	atishp@atishpatra.org, pbonzini@redhat.com, alexandru.elisei@arm.com, 
	eric.auger@redhat.com
Subject: Re: Re: [kvm-unit-tests PATCH 23/24] gitlab-ci: Add riscv64 tests
Message-ID: <20240124-6b0edbeb8659415cd18d809d@orel>
References: <20240124071815.6898-26-andrew.jones@linux.dev>
 <20240124071815.6898-49-andrew.jones@linux.dev>
 <283af7cb-33fa-4486-a038-0c5a2235ffd5@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <283af7cb-33fa-4486-a038-0c5a2235ffd5@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 24, 2024 at 10:45:29AM +0100, Thomas Huth wrote:
> On 24/01/2024 08.18, Andrew Jones wrote:
> > Add build/run tests for riscv64. We would also add riscv32, but Fedora
> > doesn't package what we need for that.
> > 
> > Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> > ---
> >   .gitlab-ci.yml | 16 ++++++++++++++++
> >   1 file changed, 16 insertions(+)
> > 
> > diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> > index 273ec9a7224b..f3ec551a50f2 100644
> > --- a/.gitlab-ci.yml
> > +++ b/.gitlab-ci.yml
> > @@ -87,6 +87,22 @@ build-ppc64le:
> >        | tee results.txt
> >    - if grep -q FAIL results.txt ; then exit 1 ; fi
> > +# build-riscv32:
> > +# Fedora doesn't package a riscv32 compiler for QEMU. Oh, well.
> > +
> > +build-riscv64:
> > + extends: .intree_template
> > + script:
> > + - dnf install -y qemu-system-riscv gcc-riscv64-linux-gnu
> > + - ./configure --arch=riscv64 --cross-prefix=riscv64-linux-gnu-
> > + - make -j2
> > + - printf "FOO=foo\nBAR=bar\nBAZ=baz\nMVENDORID=0\n" >test-env
> > + - ACCEL=tcg KVM_UNIT_TESTS_ENV=test-env ./run_tests.sh
> > +      selftest
> > +      sbi
> > +      | tee results.txt
> > + - if grep -q FAIL results.txt ; then exit 1 ; fi
> 
> IIRC it's better to make sure that at least one test passed:
> 
>   - grep -q PASS results.txt && ! grep -q FAIL results.txt
> 
> Otherwise all tests could be SKIP which indicates that something went wrong,
> too.

Yeah, for sure the basic selftests should pass.

> We're using the check for PASS for some tests in the gitlab-ci.yml file, but
> not for all ... we should maybe update the remaining ones to use that,
> too...

Yup, almost all of them are the FAIL pattern which I copy+pasted. If
I respin this series I'll change riscv now, but since I think we should
change the other ones in a separate patch, then we could change riscv at
the same time as the rest.

Thanks,
drew

