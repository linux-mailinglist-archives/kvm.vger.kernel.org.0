Return-Path: <kvm+bounces-23539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3F2894A8BB
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 15:38:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93711289C9D
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 13:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B6F1EB4AB;
	Wed,  7 Aug 2024 13:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pLU2YMe5"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658EE1EA0BD
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 13:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723037856; cv=none; b=A0phHyrI31NyvQH2P46+jmZurACWZqotb37kdvgX37ed9Jlb/OSvzeOZMyrMv1Ev605HY3tZ+bXgKxiaX/FmU8jxjCcK3MLGQ5vZkNxY0IWj0bcxaXqa9FD26+e0KUGy2xRKQKnrJ9cgV8/Gpm3xC0alhnsx+BJmw7tmv3h+Pm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723037856; c=relaxed/simple;
	bh=qyYYXG8AxRFE385WH+UD7NQeSp23Lo0OioXOj4bYBXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fb5nFGIRb0QU7FzfuvSbCAmTa59eZUnkTgw4UNHz0WrOlZzP9yjo87X9HVhOFYkH/YRbJH6k+maKM1RkXELOUQiBvchpbDRwWIz+1l1vIVPEJjgs85ZZUqg07XmsjX3tm6OR+oyH1e0Y3bJjxqhG6u/uowkq7gC9yA4IvCeFjWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pLU2YMe5; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 7 Aug 2024 15:37:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723037851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gzZlMHCGBd8gte8AROWIY1x10F2pNq24yteI3+EiPiI=;
	b=pLU2YMe5lpwVtk8N/4Ev8JhT637eVF+11koDVIezJVZ7yDnmJpw3ueL3HkH0FAJMopf1ZD
	JG0FvTRwGJH7bQAHhtwv7WjthZWpZXvtRtSnNfDunsQvLaDxqQxY8jRTpe0M9FTqDSIKdt
	pb0y7vq4QC2bA/V2Z8sskje13P+pMJI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Cade Richard <cade.richard@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [PATCH kvm-unit-tests] riscv: sbi: add dbcn write test
Message-ID: <20240807-bb9135bb41297039b3b7e135@orel>
References: <20240806-sbi-dbcn-write-test-v1-1-7f198bb55525@berkeley.edu>
 <20240807-2c3b28a78c80c6db80a80588@orel>
 <20240807-ff37f5aa2c767c4b3b734cc0@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807-ff37f5aa2c767c4b3b734cc0@orel>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 07, 2024 at 02:29:31PM GMT, Andrew Jones wrote:
> On Wed, Aug 07, 2024 at 01:36:33PM GMT, Andrew Jones wrote:
> ...
> > I just tried 32-bit KVM and see that the DBCN write test fails the
> > 'write success' test. That may be a KVM bug.
> >
> 
> We can blame both KVM and kvmtool.
> 
> KVM sets sbiret.error to a0 and sbiret.value to a1 before exiting to
> userspace[1]. I think that comes from thinking about how a real ecall
> would set them. However, as this isn't an ecall, they should get set
> directly by userspace, not through registers. Also, we should initialize
> them to some known value before calling userspace, and zero is probably
> the best choice.

Thinking about this some more and discussing it with Anup, the best
choice for sbiret.error is to initialize it to SBI_ERR_NOT_SUPPORTED.
Doing that won't allow the test to pass with old kvmtool, but that's
OK. I'll send a KVM patch for that and the kvmtool patch.

Thanks,
drew

> 
> kvmtool neglects to set sbiret.error to SBI_SUCCESS on a successful write.
> QEMU does set it, so this failure shouldn't happen with QEMU, but I
> haven't tried it.
> 
> Patching both KVM and kvmtool is best, as it would allow the test to pass
> when running new KVM with old kvmtool and when running old KVM with new
> kvmtool.
> 
> [1] arch/riscv/kvm/vcpu_sbi.c:130
> 
> Thanks,
> drew
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

