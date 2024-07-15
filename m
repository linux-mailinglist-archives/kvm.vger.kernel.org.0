Return-Path: <kvm+bounces-21663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5157931D31
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 00:33:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14BC31C2141B
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 22:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4D9413C83D;
	Mon, 15 Jul 2024 22:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mDHVd44o"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216AE1CAB3
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 22:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721082818; cv=none; b=ifSfkEEPRrxQ/yY12sCGx5KaRBK0biAX8MQ/oDUtNM61CYRhStfsaoGRt+J5EJ3Ij2Q1RkmOLZIRJFCVDIBitRbyefCHwr9+HUdENMJOjeRA7eGsSFyQReHTCnwgM0ZWHqexi+gj9DIG7I48fC5/NkJQbm23ZjBR8udqmUfDFbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721082818; c=relaxed/simple;
	bh=4yjSR8v/2VJFkAHJsUxQKZKi6Fh5vT2lTDlLhcwFG2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pE/78nYMAcGe8sZDGeKG2+SYXr+yQAG/mon6Y623yTG2cWY/zq9KBpAn4WU19NMPut5ZB/h3fh2kf2Y56Cwo7F+2wngGFhN+UhTQNjUV5YYS6MU8SJFn7DJBC/Bl6gwChTTMQpfXuAelnVP8uXX6okD8Ir3owf31xB3s68sKGRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mDHVd44o; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: cade.richard@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721082814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=63KiSGp4IALElH/e2v9EfscLiX2ZeMrHzJF2quHd3CU=;
	b=mDHVd44oVFUEgFi1GL4+bUZV/1WWbuDd07m1MYFfOPvL40yQSOH4XaUkTTlLZXt80+boW4
	OOoqtMs4roPesfKp45zZNt0yFn9NcPOCe1UJfeGhcEsFRh+FIXbLEQIpqmMqfIEt+39t3o
	zD8Fjprh8rIvdk2FH321vZftgyreF+U=
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: kvm-riscv@lists.infradead.org
X-Envelope-To: atishp@rivosinc.com
X-Envelope-To: cade.richard@berkeley.edu
X-Envelope-To: jamestiotio@gmail.com
Date: Mon, 15 Jul 2024 17:33:29 -0500
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Cade Richard <cade.richard@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [PATCH kvm-unit-tests v2] riscv: sbi: debug console write tests
Message-ID: <20240715-d79b2446d8d2ef2751739652@orel>
References: <20240706-sbi-dbcn-write-tests-v2-1-a5dc6a749f4a@berkeley.edu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240706-sbi-dbcn-write-tests-v2-1-a5dc6a749f4a@berkeley.edu>
X-Migadu-Flow: FLOW_OUT

On Sat, Jul 06, 2024 at 04:55:46PM GMT, Cade Richard wrote:
>

Needs commit message

> 
> ---

Need to remove the above ---

> Signed-off-by: Cade Richard <cade.richard@berkeley.edu>
> ---
> Changes in v2:
> - Added prefix pop to exit dbcn tests
> - Link to v1: https://lore.kernel.org/r/20240706-sbi-dbcn-write-tests-v1-1-b754e51699f8@berkeley.edu
> ---
>  lib/riscv/asm/sbi.h |  7 +++++++
>  riscv/sbi.c         | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 67 insertions(+)
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index d82a384d..c5fa84ae 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -18,6 +18,7 @@ enum sbi_ext_id {
>  	SBI_EXT_BASE = 0x10,
>  	SBI_EXT_HSM = 0x48534d,
>  	SBI_EXT_SRST = 0x53525354,
> +	SBI_EXT_DBCN = 0x4442434E,
>  };
>  
>  enum sbi_ext_base_fid {
> @@ -37,6 +38,12 @@ enum sbi_ext_hsm_fid {
>  	SBI_EXT_HSM_HART_SUSPEND,
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
> index 762e9711..18646842 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -7,6 +7,10 @@
>  #include <libcflat.h>
>  #include <stdlib.h>
>  #include <asm/sbi.h>
> +#include <asm/io.h>
> +
> +#define DBCN_WRITE_TEST_STRING		"DBCN_WRITE_TEST_STRING\n"
> +#define DBCN_WRITE_BYTE_TEST_BYTE	(u8)'a'
>  
>  static void help(void)
>  {
> @@ -19,6 +23,11 @@ static struct sbiret __base_sbi_ecall(int fid, unsigned long arg0)
>  	return sbi_ecall(SBI_EXT_BASE, fid, arg0, 0, 0, 0, 0, 0);
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
> @@ -112,6 +121,56 @@ static void check_base(void)
>  	report_prefix_pop();
>  }
>  
> +static void check_dbcn(void)
> +{
> +	

Stray blank line here

> +	struct sbiret ret;
> +	unsigned long num_bytes, base_addr_lo, base_addr_hi;
> +
> +	report_prefix_push("dbcn");
> +	
> +	ret = __base_sbi_ecall(SBI_EXT_BASE_PROBE_EXT, SBI_EXT_DBCN);
> +	if (!ret.value) {
> +		report_skip("DBCN extension unavailable");
> +		report_prefix_pop();
> +		return;
> +	}

We should provide a

 long sbi_probe(int ext)
 {
     struct sbiret ret;

     ret = sbi_ecall(SBI_EXT_BASE_PROBE_EXT, ext, 0, 0, 0, 0, 0, 0);
     assert(!ret.error);

     return ret.value;
 }

in lib/riscv/sbi.c and use that everywhere we need to do checks like
these.

> +
> +	report_prefix_push("write");
> +
> +	num_bytes = strlen(DBCN_WRITE_TEST_STRING);
> +	base_addr_hi = 0x0;

We shouldn't assume that the high part of the address is zero. We
can set it to whatever the high part of virt_to_phys(...) is.

> +	base_addr_lo = virt_to_phys((void *) &DBCN_WRITE_TEST_STRING);
                                            ^ remove this space
> +
> +	do {
> +		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, num_bytes, base_addr_lo, base_addr_hi);
> +		num_bytes -= ret.value;
> +		base_addr_lo += ret.value;
> +	} while (num_bytes != 0 && ret.error == SBI_SUCCESS) ;
                                                            ^ remove this
							    space
add a blank line here

> +	report(SBI_SUCCESS == ret.error, "write success");

nit: write this as 'ret.error == SBI_SUCCESS'

> +	report(ret.value == num_bytes, "correct number of bytes written");

ret.value may not be num_bytes since we may have issued more than one
SBI call and ret.value is only whatever the last call wrote. This check
isn't actually necessary since we have the SBI_SUCCESS check already
and we can't get SBI_SUCCESS without num_bytes == 0. It may be interesting
to know how many SBI calls were made (for successful writes and failed
writes). We could add a counter to the loop and then a report_info here.

> +
> +	// Bytes are read from memory and written to the console

Use /* */ as described in the kernel's coding style documentation.

> +	if (env_or_skip("INVALID_READ_ADDR")) {
> +		base_addr_lo = strtol(getenv("INVALID_READ_ADDR"), NULL, 0);
> +		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, num_bytes, base_addr_lo, base_addr_hi);

num_bytes is likely zero right now so it may not matter what the address
is. The user specified address doesn't have to be 32-bit only so it should
also set hi.

> +		report(ret.error == SBI_ERR_INVALID_PARAM, "invalid parameter: address");
> +	};
         ^ unnecessary ;
> +
> +	report_prefix_pop();
> +	
> +	report_prefix_push("write_byte");
> +
> +	puts("DBCN_WRITE TEST CHAR: ");
> +	ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE_BYTE, (u8)DBCN_WRITE_BYTE_TEST_BYTE, 0, 0);
                                                                ^ this
					           cast isn't necessary
> +	puts("\n");
> +	report(ret.error == SBI_SUCCESS, "write success");
> +	report(ret.value == 0, "expected ret.value");
> +
> +	report_prefix_pop();
> +	report_prefix_pop();

We should add a comment somewhere pointing out that there's also a read
function, but there's no easy way to test that. If we're optimistic that
we'll eventually come up with a way, then the comment can contain a TODO
tag.

> +}
> +
>  int main(int argc, char **argv)
>  {
>  
> @@ -122,6 +181,7 @@ int main(int argc, char **argv)
>  
>  	report_prefix_push("sbi");
>  	check_base();
> +	check_dbcn();
>  
>  	return report_summary();
>  }
> 
> ---
> base-commit: 40e1fd76ffc80b1d43214e31a023aaf087ece987
> change-id: 20240706-sbi-dbcn-write-tests-42289f1391ed
> 
> Best regards,
> -- 
> Cade Richard <cade.richard@berkeley.edu>
>

Thanks,
drew

