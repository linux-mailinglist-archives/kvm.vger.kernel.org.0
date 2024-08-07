Return-Path: <kvm+bounces-23528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E687794A70A
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 13:36:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68D65B22780
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 11:36:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2852D1E3CA4;
	Wed,  7 Aug 2024 11:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BwZzZeKy"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18F31B86DB
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 11:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723030603; cv=none; b=HVzcIGlkNjnj3YcKc5VIHh/suS8wlduPVyLczoq477Yq5q8hu8dLbQgwra6IZ/eKgI+QjvX1IHskZdXdm/cv2zVTOdF851zGF4oZVH7V1MUTIngXJogbazOs9gB7A+mTU5EOHaSC2zt1QBOp49br4JXxRfffq2FRgPdHbBEwpwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723030603; c=relaxed/simple;
	bh=MIs+gv7rBTsc0LbEkyilDP/fIr2FHG8J3xY4FZp/PdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eR2VrVxTwgz7p9IjwKOIjEdBhvscWJ2q+nhzRqnMTuJiL5/gA7m3kW8cZrE3ewkIJVPnpfONTu3uhMLJ8uprMVQQ/Kd1LHZ8EtBdrJ4KIeQYQNhLWbNWiYy4tFHrDkLoXNscd4ryPKbJutc2JkuYZFFNxggzADb1yVXYxw2upvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BwZzZeKy; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 7 Aug 2024 13:36:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723030597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vVsKop0OmydFEaNh7SQvDrbJswAXEPpWLvYOGMEvabE=;
	b=BwZzZeKyaGX3IsgDGUxZieHy0HxIBu2Vx0KKlZl7An7NngLgI/6DS33aHda1FFLYKrDo11
	SXzwp0vQSH2684pzfQZygmJmfGLysDoS47qg5qF4HcxjFiIU0FFOinNqpi0O1dapsRQ8Md
	hs5I9p20gAAUuetiHUKsxbrIaKunGDo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Cade Richard <cade.richard@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [PATCH kvm-unit-tests] riscv: sbi: add dbcn write test
Message-ID: <20240807-2c3b28a78c80c6db80a80588@orel>
References: <20240806-sbi-dbcn-write-test-v1-1-7f198bb55525@berkeley.edu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806-sbi-dbcn-write-test-v1-1-7f198bb55525@berkeley.edu>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 06, 2024 at 10:51:54PM GMT, Cade Richard wrote:
> 
> 
> ---
> Added a unit test for the RISC-V SBI debug console write() and write_byte() functions. The output of the tests must be inspected manually to verify that the correct bytes are written. For write(), the expected output is 'DBCN_WRITE_TEST_STRING'. For write_byte(), the expected output is 'a'.
> 
> Signed-off-by: Cade Richard <cade.richard@berkeley.edu>
> ---
>  lib/riscv/asm/sbi.h |  7 ++++++
>  riscv/sbi.c         | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 73 insertions(+)
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index 73ab5438..47e91025 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -19,6 +19,7 @@ enum sbi_ext_id {
>  	SBI_EXT_TIME = 0x54494d45,
>  	SBI_EXT_HSM = 0x48534d,
>  	SBI_EXT_SRST = 0x53525354,
> +	SBI_EXT_DBCN = 0x4442434E,
>  };
>  
>  enum sbi_ext_base_fid {
> @@ -42,6 +43,12 @@ enum sbi_ext_time_fid {
>  	SBI_EXT_TIME_SET_TIMER = 0,
>  };
>  
> +enum sbi_ext_dbcn_fid {
> +	SBI_EXT_DBCN_CONSOLE_WRITE = 0,
> +	SBI_EXT_DBCN_CONSOLE_READ,
> +	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
> +};
> +
>  struct sbiret {
>  	long error;
>  	long value;
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 2438c497..61993f08 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -15,6 +15,10 @@
>  #include <asm/sbi.h>
>  #include <asm/smp.h>
>  #include <asm/timer.h>
> +#include <asm/io.h>
> +
> +#define DBCN_WRITE_TEST_STRING		"DBCN_WRITE_TEST_STRING\n"
> +#define DBCN_WRITE_BYTE_TEST_BYTE	(u8)'a'
>  
>  static void help(void)
>  {
> @@ -32,6 +36,11 @@ static struct sbiret __time_sbi_ecall(unsigned long stime_value)
>  	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
>  }
>  
> +static struct sbiret __dbcn_sbi_ecall(int fid, unsigned long arg0, unsigned long arg1, unsigned long arg2)
> +{
> +	return sbi_ecall(SBI_EXT_DBCN, fid, arg0, arg1, arg2, 0, 0, 0);
> +}
> +
>  static bool env_or_skip(const char *env)
>  {
>  	if (!getenv(env)) {
> @@ -248,6 +257,62 @@ static void check_time(void)
>  	report_prefix_pop();
>  }
>  
> +static void check_dbcn(void)
> +{
> +	

I still see whitespace issues, like this blank line here that has spaces,
which I pointed out before. And there are several more blank lines with
spaces too.

> +	struct sbiret ret;
> +	unsigned long num_bytes, base_addr_lo, base_addr_hi;
> +	int num_calls = 0;
> +	
> +	num_bytes = strlen(DBCN_WRITE_TEST_STRING);
> +	phys_addr_t p = virt_to_phys((void *)&DBCN_WRITE_TEST_STRING);
> +	base_addr_lo = (unsigned long)p;
> +	base_addr_hi = (unsigned long)(p >> __riscv_xlen);

This doesn't compile for 64-bit. We get

riscv/sbi.c: In function 'check_dbcn':
riscv/sbi.c:270:42: error: right shift count >= width of type [-Werror=shift-count-overflow]
  270 |         base_addr_hi = (unsigned long)(p >> __riscv_xlen);
      |                                          ^~
riscv/sbi.c:298:50: error: right shift count >= width of type [-Werror=shift-count-overflow]
  298 |                 base_addr_hi = (unsigned long)(p >> __riscv_xlen);
      |                                                  ^~
cc1: all warnings being treated as errors
make: *** [<builtin>: riscv/sbi.o] Error 1

So I guess you didn't test with 64-bit? You should at least test with
both 32-bit and 64-bit on QEMU, and, ideally, also test both on KVM and
also 64-bit EFI on QEMU.

I just tried 32-bit KVM and see that the DBCN write test fails the
'write success' test. That may be a KVM bug.

Thanks,
drew

