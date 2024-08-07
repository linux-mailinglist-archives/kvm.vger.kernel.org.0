Return-Path: <kvm+bounces-23483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D47394A1EC
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 09:43:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC4C81F21733
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 07:43:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34D661C7B77;
	Wed,  7 Aug 2024 07:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GK2asJNx"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBB722EE5
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 07:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723016607; cv=none; b=VNzoxyzlt+izvCAC+3yR40sMTZ4h0bkUGA3UI2RYbyoNziNt/4ES7xP+UebHPDDiakssGMAqGt67CL5T1YcWzP9jPNtpgObdXV2H1FPk6dQaJDAMyKrVPUTq9VJR9ArLylm7MURY8htGVbW+zPWWVDGFEwrBCk1reGL5nK1W5SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723016607; c=relaxed/simple;
	bh=p7LMmmzU1+cu3gDb4BNR5usgoqOn0JF56mNQORorlg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=egbq/expjOtrIiAaXBB3rQRX4wk6WOEQ6kGawZ2NbhtUZ/VkXGR6QUZg8Y/T/grR6RD1K7jBaHMSZbje6nIXrup0kICUpDe4fQ0TtPq4iqa185e95PAE/jsXppIUwwxLIRnCW/8ZzMsA1LMcudxOOy8WV3ufr1MiCLiabZPiBbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GK2asJNx; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 7 Aug 2024 09:43:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723016602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TXckcsmB40wwGZbeI2/syEiQW03ulJWzQIsf9BnqUys=;
	b=GK2asJNxCDWRfr2biYpW3iPq8nNX52MfjS54NIXaiSF8SYme7MBu/5ZijowLFkgaFA1VBd
	kGcrozU51h/YaHuFd6GTGiVmRJ4veVZfA4zyRRKInCj2JXcT8xw07V1p8OchFOr5Xoyx4h
	56U9O8VgZdInVasP4hm9um5QLEAGN+g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Cade Richard <cade.richard@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [PATCH kvm-unit-tests] riscv: sbi: add dbcn write test
Message-ID: <20240807-e5f14146934e63558f473337@orel>
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

not sure why this --- above is here, it'll remove the commit text from the
commit. Also not sure where the changelog went. We want the changelog, but
we want it under the --- below your sign-off.

> Added a unit test for the RISC-V SBI debug console write() and write_byte() functions. The output of the tests must be inspected manually to verify that the correct bytes are written. For write(), the expected output is 'DBCN_WRITE_TEST_STRING'. For write_byte(), the expected output is 'a'.

Need to wrap lines at 74 chars.

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

The includes are currently in alphabetic order. Let's keep them that way.

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

What happened to the comment about the read test?

> +static void check_dbcn(void)
> +{
> +	
> +	struct sbiret ret;
> +	unsigned long num_bytes, base_addr_lo, base_addr_hi;
> +	int num_calls = 0;
> +	
> +	num_bytes = strlen(DBCN_WRITE_TEST_STRING);
> +	phys_addr_t p = virt_to_phys((void *)&DBCN_WRITE_TEST_STRING);

Put p's declaration with the rest above.

> +	base_addr_lo = (unsigned long)p;
> +	base_addr_hi = (unsigned long)(p >> __riscv_xlen);
> +
> +	report_prefix_push("dbcn");
> +	
> +	ret = __base_sbi_ecall(SBI_EXT_BASE_PROBE_EXT, SBI_EXT_DBCN);
> +	if (!ret.value) {
> +		report_skip("DBCN extension unavailable");
> +		report_prefix_pop();
> +		return;
> +	}

The report skip should be the first thing you do, i.e. the virt_to_phys
stuff should be below it.

> +
> +	report_prefix_push("write");
> +
> +	do {
> +		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, num_bytes, base_addr_lo, base_addr_hi);
> +		num_bytes -= ret.value;
> +		base_addr_lo += ret.value;

We should increment the physical address and then split it again into lo
and hi since lo could have been zero (only high addresses) or lo may
have started nonzero but then wrapped since we were close the 4G boundary.

> +		num_calls++;
> +	} while (num_bytes != 0 && ret.error == SBI_SUCCESS) ;
> +	report(ret.error == SBI_SUCCESS, "write success");
> +	report_info("%d sbi calls made", num_calls);
> +	
> +	/*
> +		Bytes are read from memory and written to the console

There should be a '*' on each line of a comment block. Doesn't checkpatch
complain about that?

> +	*/
> +	if (env_or_skip("INVALID_READ_ADDR")) {
> +		phys_addr_t p = strtoull(getenv("INVALID_READ_ADDR"), NULL, 0);

Don't shadow p, you can use the same one again.

> +		base_addr_lo = (unsigned long)p;
> +		base_addr_hi = (unsigned long)(p >> __riscv_xlen);
> +		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, 1, base_addr_lo, base_addr_hi);
> +		report(ret.error == SBI_ERR_INVALID_PARAM, "invalid parameter: address");
> +	};
> +
> +	report_prefix_pop();
> +	
> +	report_prefix_push("write_byte");
> +
> +	puts("DBCN_WRITE TEST CHAR: ");
> +	ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE_BYTE, (u8)DBCN_WRITE_BYTE_TEST_BYTE, 0, 0);
> +	puts("\n");
> +	report(ret.error == SBI_SUCCESS, "write success");
> +	report(ret.value == 0, "expected ret.value");
> +
> +	report_prefix_pop();
> +}
> +
>  int main(int argc, char **argv)
>  {
>  
> @@ -259,6 +324,7 @@ int main(int argc, char **argv)
>  	report_prefix_push("sbi");
>  	check_base();
>  	check_time();
> +	check_dbcn();
>  
>  	return report_summary();
>  }
> 
> ---
> base-commit: 1878b4b663fd50b87de7ba2b1c90614e2703542f
> change-id: 20240806-sbi-dbcn-write-test-70d305d511cf
> 
> Best regards,
> -- 
> Cade Richard <cade.richard@berkeley.edu>
>

Thanks,
drew

