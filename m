Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 230751F86D
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 18:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfEOQWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 12:22:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43896 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbfEOQWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 12:22:20 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B5ADF356DF;
        Wed, 15 May 2019 16:22:19 +0000 (UTC)
Received: from [10.40.205.57] (unknown [10.40.205.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 071865D71E;
        Wed, 15 May 2019 16:22:15 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 1/2] powerpc: Allow for a custom decr
 value to be specified to load on decr excp
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, thuth@redhat.com, dgibson@redhat.com
References: <20190515002801.20517-1-sjitindarsingh@gmail.com>
From:   Laurent Vivier <lvivier@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=lvivier@redhat.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <132d5cba-1b9e-0be9-848b-676848af7c48@redhat.com>
Date:   Wed, 15 May 2019 18:22:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515002801.20517-1-sjitindarsingh@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 15 May 2019 16:22:19 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/05/2019 02:28, Suraj Jitindar Singh wrote:
> Currently the handler for a decrementer exception will simply reload the
> maximum value (0x7FFFFFFF), which will take ~4 seconds to expire again.
> This means that if a vcpu cedes, it will be ~4 seconds between wakeups.
> 
> The h_cede_tm test is testing a known breakage when a guest cedes while
> suspended. To be sure we cede 500 times to check for the bug. However
> since it takes ~4 seconds to be woken up once we've ceded, we only get
> through ~20 iterations before we reach the 90 seconds timeout and the
> test appears to fail.
> 
> Add an option when registering the decrementer handler to specify the
> value which should be reloaded by the handler, allowing the timeout to be
> chosen.
> 
> Modify the spr test to use the max timeout to preserve existing
> behaviour.
> Modify the h_cede_tm test to use a 10ms timeout to ensure we can perform
> 500 iterations before hitting the 90 second time limit for a test.
> 
> This means the h_cede_tm test now succeeds rather than timing out.
> 
> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> 
> ---
> 
> V1 -> V2:
> - Make decr variables static
> - Load intial decr value in tm test to ensure known value present
> ---
>  lib/powerpc/handlers.c | 7 ++++---
>  powerpc/sprs.c         | 5 +++--
>  powerpc/tm.c           | 4 +++-
>  3 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/powerpc/handlers.c b/lib/powerpc/handlers.c
> index be8226a..c8721e0 100644
> --- a/lib/powerpc/handlers.c
> +++ b/lib/powerpc/handlers.c
> @@ -12,11 +12,12 @@
>  
>  /*
>   * Generic handler for decrementer exceptions (0x900)
> - * Just reset the decrementer back to its maximum value (0x7FFFFFFF)
> + * Just reset the decrementer back to the value specified when registering the
> + * handler
>   */
> -void dec_except_handler(struct pt_regs *regs __unused, void *data __unused)
> +void dec_except_handler(struct pt_regs *regs __unused, void *data)
>  {
> -	uint32_t dec = 0x7FFFFFFF;
> +	uint64_t dec = *((uint64_t *) data);
>  
>  	asm volatile ("mtdec %0" : : "r" (dec));
>  }
> diff --git a/powerpc/sprs.c b/powerpc/sprs.c
> index 6744bd8..0e2e1c9 100644
> --- a/powerpc/sprs.c
> +++ b/powerpc/sprs.c
> @@ -253,6 +253,7 @@ int main(int argc, char **argv)
>  		0x1234567890ABCDEFULL, 0xFEDCBA0987654321ULL,
>  		-1ULL,
>  	};
> +	static uint64_t decr = 0x7FFFFFFF; /* Max value */
>  
>  	for (i = 1; i < argc; i++) {
>  		if (!strcmp(argv[i], "-w")) {
> @@ -288,8 +289,8 @@ int main(int argc, char **argv)
>  		(void) getchar();
>  	} else {
>  		puts("Sleeping...\n");
> -		handle_exception(0x900, &dec_except_handler, NULL);
> -		asm volatile ("mtdec %0" : : "r" (0x3FFFFFFF));
> +		handle_exception(0x900, &dec_except_handler, &decr);
> +		asm volatile ("mtdec %0" : : "r" (decr));

why do you replace the 0x3FFFFFFF by decr which is 0x7FFFFFFF?

>  		hcall(H_CEDE);
>  	}
>  
> diff --git a/powerpc/tm.c b/powerpc/tm.c
> index bd56baa..c588985 100644
> --- a/powerpc/tm.c
> +++ b/powerpc/tm.c
> @@ -95,11 +95,13 @@ static bool enable_tm(void)
>  static void test_h_cede_tm(int argc, char **argv)
>  {
>  	int i;
> +	static uint64_t decr = 0x3FFFFF; /* ~10ms */
>  
>  	if (argc > 2)
>  		report_abort("Unsupported argument: '%s'", argv[2]);
>  
> -	handle_exception(0x900, &dec_except_handler, NULL);
> +	handle_exception(0x900, &dec_except_handler, &decr);
> +	asm volatile ("mtdec %0" : : "r" (decr));
>  
>  	if (!start_all_cpus(halt, 0))
>  		report_abort("Failed to start secondary cpus");
> 

Thanks,
Laurent
