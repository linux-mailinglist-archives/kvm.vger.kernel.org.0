Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904883DA63F
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 16:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbhG2OXX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 10:23:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59112 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237230AbhG2OXW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 10:23:22 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TELIpL009812;
        Thu, 29 Jul 2021 10:23:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0wtuviCVVbDvRJSEfyU6j5ZKWYQlA32Ei9z0+u1374U=;
 b=L1hm800iGI2AciTmVTItC5HD5ZbBgFgcmJjc6bllSVrH6tzoRByneiWP3a27pXf7QGam
 u7xFlr5uZP3SbvNZt+ecvU18e49FJzP/GSI3E5ifGHPGwgF9GyFjHe79LP/REwHh7v/D
 TJDcDu+AR7/2+hfg0uU4OE5xOo9skz55/V0n1S5JCLg9iINfpPFJx1T4E3VtpLARNB1y
 fm8KM3lJZP3Qo7qqh4rWjYfY/eHJLLRkSiGSUdsRU6TNPdS0agRIHGb9dToOycgboqzs
 I4SxFI+WbALp3FerBYC9o1rxUnQ/0HxdhJGsNi/G+0JHKhbDeajjFAV4zvL1j9XpoLl+ 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a3shaamby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 10:23:18 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16TELOuY010534;
        Thu, 29 Jul 2021 10:23:18 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a3shaamb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 10:23:17 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16TEDHpx020370;
        Thu, 29 Jul 2021 14:23:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3a235kh5je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 14:23:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16TEND9F27197812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 14:23:13 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 682DEA4072;
        Thu, 29 Jul 2021 14:23:13 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2AD9FA405E;
        Thu, 29 Jul 2021 14:23:13 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.151])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 14:23:13 +0000 (GMT)
Date:   Thu, 29 Jul 2021 16:21:40 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 3/4] s390x: lib: sie: Add struct vm
 (de)initialization functions
Message-ID: <20210729162140.2475d3d6@p-imbrenda>
In-Reply-To: <20210729134803.183358-4-frankja@linux.ibm.com>
References: <20210729134803.183358-1-frankja@linux.ibm.com>
        <20210729134803.183358-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ODWtN_uCyyDiZZWDSalByXGI1NjFC22f
X-Proofpoint-GUID: 3v4mojOp8NVJ7FL90U0pOt1LcFDEFDbA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 suspectscore=0 mlxscore=0 spamscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Jul 2021 13:48:02 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Before I start copying the same code over and over lets move this into
> the library.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/sie.c  | 30 ++++++++++++++++++++++++++++++
>  lib/s390x/sie.h  |  3 +++
>  s390x/mvpg-sie.c | 18 ++----------------
>  s390x/sie.c      | 19 +++----------------
>  4 files changed, 38 insertions(+), 32 deletions(-)
> 
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index 9107519f..ec0c4867 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -11,6 +11,9 @@
>  #include <asm/barrier.h>
>  #include <libcflat.h>
>  #include <sie.h>
> +#include <asm/page.h>
> +#include <libcflat.h>
> +#include <alloc_page.h>
>  
>  static bool validity_expected;
>  static uint16_t vir;
> @@ -39,3 +42,30 @@ void sie_handle_validity(struct vm *vm)
>  		report_abort("VALIDITY: %x", vir);
>  	validity_expected = false;
>  }
> +
> +/* Initializes the struct vm members like the SIE control block. */
> +void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t
> guest_mem_len) +{
> +	vm->sblk = alloc_page();
> +	memset(vm->sblk, 0, PAGE_SIZE);

you can skip the memset, the page allocator always zeroes the page,
unless you explicitly pass FLAG_DONTZERO

regardless of that:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> +	vm->sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
> +	vm->sblk->ihcpu = 0xffff;
> +	vm->sblk->prefix = 0;
> +
> +	/* Guest memory chunks are always 1MB */
> +	assert(!(guest_mem_len & ~HPAGE_MASK));
> +	/* Currently MSO/MSL is the easiest option */
> +	vm->sblk->mso = (uint64_t)guest_mem;
> +	vm->sblk->msl = (uint64_t)guest_mem + ((guest_mem_len - 1) &
> HPAGE_MASK); +
> +	/* CRYCB needs to be in the first 2GB */
> +	vm->crycb = alloc_pages_flags(0, AREA_DMA31);
> +	vm->sblk->crycbd = (uint32_t)(uintptr_t)vm->crycb;
> +}
> +
> +/* Frees the memory that was gathered on initialization */
> +void sie_guest_destroy(struct vm *vm)
> +{
> +	free_page(vm->crycb);
> +	free_page(vm->sblk);
> +}
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index 7ff98d2d..946bd164 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -190,6 +190,7 @@ struct vm_save_area {
>  struct vm {
>  	struct kvm_s390_sie_block *sblk;
>  	struct vm_save_area save_area;
> +	uint8_t *crycb;				/* Crypto
> Control Block */ /* Ptr to first guest page */
>  	uint8_t *guest_mem;
>  };
> @@ -200,5 +201,7 @@ extern void sie64a(struct kvm_s390_sie_block
> *sblk, struct vm_save_area *save_ar void sie_expect_validity(void);
>  void sie_check_validity(uint16_t vir_exp);
>  void sie_handle_validity(struct vm *vm);
> +void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t
> guest_mem_len); +void sie_guest_destroy(struct vm *vm);
>  
>  #endif /* _S390X_SIE_H_ */
> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
> index 2ac91eec..71ae4f88 100644
> --- a/s390x/mvpg-sie.c
> +++ b/s390x/mvpg-sie.c
> @@ -110,22 +110,7 @@ static void setup_guest(void)
>  	/* The first two pages are the lowcore */
>  	guest_instr = guest + PAGE_SIZE * 2;
>  
> -	vm.sblk = alloc_page();
> -
> -	vm.sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
> -	vm.sblk->prefix = 0;
> -	/*
> -	 * Pageable guest with the same ASCE as the test programm,
> but
> -	 * the guest memory 0x0 is offset to start at the allocated
> -	 * guest pages and end after 1MB.
> -	 *
> -	 * It's not pretty but faster and easier than managing guest
> ASCEs.
> -	 */
> -	vm.sblk->mso = (u64)guest;
> -	vm.sblk->msl = (u64)guest;
> -	vm.sblk->ihcpu = 0xffff;
> -
> -	vm.sblk->crycbd = (uint64_t)alloc_page();
> +	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
>  
>  	vm.sblk->gpsw.addr = PAGE_SIZE * 4;
>  	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
> @@ -150,6 +135,7 @@ int main(void)
>  	setup_guest();
>  	test_mvpg();
>  	test_mvpg_pei();
> +	sie_guest_destroy(&vm);
>  
>  done:
>  	report_prefix_pop();
> diff --git a/s390x/sie.c b/s390x/sie.c
> index 5c798a9e..9cb9b055 100644
> --- a/s390x/sie.c
> +++ b/s390x/sie.c
> @@ -84,22 +84,7 @@ static void setup_guest(void)
>  	/* The first two pages are the lowcore */
>  	guest_instr = guest + PAGE_SIZE * 2;
>  
> -	vm.sblk = alloc_page();
> -
> -	vm.sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
> -	vm.sblk->prefix = 0;
> -	/*
> -	 * Pageable guest with the same ASCE as the test programm,
> but
> -	 * the guest memory 0x0 is offset to start at the allocated
> -	 * guest pages and end after 1MB.
> -	 *
> -	 * It's not pretty but faster and easier than managing guest
> ASCEs.
> -	 */
> -	vm.sblk->mso = (u64)guest;
> -	vm.sblk->msl = (u64)guest;
> -	vm.sblk->ihcpu = 0xffff;
> -
> -	vm.sblk->crycbd = (uint64_t)alloc_page();
> +	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
>  }
>  
>  int main(void)
> @@ -112,6 +97,8 @@ int main(void)
>  
>  	setup_guest();
>  	test_diags();
> +	sie_guest_destroy(&vm);
> +
>  done:
>  	report_prefix_pop();
>  	return report_summary();

