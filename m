Return-Path: <kvm+bounces-23532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ECB9094A7B2
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 14:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0D9F1F22616
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 12:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 313341E6720;
	Wed,  7 Aug 2024 12:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hsBhmSI4"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C52F1E2101
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 12:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723033780; cv=none; b=mT7FwjZztwXD8OQorDUeqDcp978PZolWNXxbEbs8+vnc0R1puKz6QtF6PSbiHxUWuzM5bZH/dS3PKUqc54Ya5sIjrMqnhojBEUiCKxGlg0SB61AiBMPajWZ3dPXsCx/KSSakWIyQ/NtyqjhyNMPXjF+5sM3ttKaVFG6UpkpJR3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723033780; c=relaxed/simple;
	bh=Z0zMm43w+MYj5Grgp/er/kJIk82C2oNVsFls0PAJaKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ED4RAThEmrQVUKMp5ghHQdgjGQG7yk5GQL50Ke4hoSDQ+FwBN4/Z2ccViwBOprLgORLfo5EpB0UBsMwe2BozgKa5NnS+xj6ycvOGXErC/Wtb2NVdn1hw1btxtCQdP1EUNm3/4HcHFeJ+/KS477s0Azdlq05Uz70m12+QkYIQnwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hsBhmSI4; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 7 Aug 2024 14:29:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723033776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z0zMm43w+MYj5Grgp/er/kJIk82C2oNVsFls0PAJaKQ=;
	b=hsBhmSI4y354ryNLZarfoeANGr97NxwpKaq2Rj5ZNAnO54CwhDVfchb46pv7X8SHwFAeqC
	inJiTL1LoQBexWJZovJ5k0JDcHazCZBSNy1lZbZrtDyYNJ/4JYFV31i+WLstfknXuesm9G
	jOmAs79vHZzvf1VzqyN2T1CjbGTdpvY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Cade Richard <cade.richard@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [PATCH kvm-unit-tests] riscv: sbi: add dbcn write test
Message-ID: <20240807-ff37f5aa2c767c4b3b734cc0@orel>
References: <20240806-sbi-dbcn-write-test-v1-1-7f198bb55525@berkeley.edu>
 <20240807-2c3b28a78c80c6db80a80588@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807-2c3b28a78c80c6db80a80588@orel>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 07, 2024 at 01:36:33PM GMT, Andrew Jones wrote:
...
> I just tried 32-bit KVM and see that the DBCN write test fails the
> 'write success' test. That may be a KVM bug.
>

We can blame both KVM and kvmtool.

KVM sets sbiret.error to a0 and sbiret.value to a1 before exiting to
userspace[1]. I think that comes from thinking about how a real ecall
would set them. However, as this isn't an ecall, they should get set
directly by userspace, not through registers. Also, we should initialize
them to some known value before calling userspace, and zero is probably
the best choice.

kvmtool neglects to set sbiret.error to SBI_SUCCESS on a successful write.
QEMU does set it, so this failure shouldn't happen with QEMU, but I
haven't tried it.

Patching both KVM and kvmtool is best, as it would allow the test to pass
when running new KVM with old kvmtool and when running old KVM with new
kvmtool.

[1] arch/riscv/kvm/vcpu_sbi.c:130

Thanks,
drew

