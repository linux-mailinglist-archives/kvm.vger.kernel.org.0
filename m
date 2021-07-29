Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA993DA671
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 16:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbhG2OcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 10:32:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25448 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234206AbhG2OcN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 10:32:13 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TES2jG091430;
        Thu, 29 Jul 2021 10:32:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=oC4dWGYHakHTktOJPIBzNcD5xbPcnDPRM1S288H3HDs=;
 b=hoSpDWzqnNFZNeAP2/oSjEmQB4g4K/ojFalIjSHrO5pZ/8vmAH3z0sZ5juTplO2hRHcq
 bamXpasAfyp8oHqZgOVP4hznNsoWuSWwoFw8jRSEZB377nesSKOy4F7/Fpf7yBhjN6sY
 bCPtBYAYdvVY5AqT1RUl8kV58MGbtjt4yaGqgNHPXTu469d7Oc6uBBid4oyCDzVeKw3I
 77EIbjyWhqqr2x+xPo4FHZPC0QZju37XtLGgDWamfJg+JlTuK/5zB01aix44xGpmxgNT
 fVWtr8T8yPNJeuCVDOTI6Gmtn8l6AgclSlS8F2CGSZ5YQwUCxIirPVMrK2/I7N1q6MLt Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3wfttf1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 10:32:10 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16TETCl6096054;
        Thu, 29 Jul 2021 10:32:10 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3wfttf05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 10:32:09 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16TEDI6X024989;
        Thu, 29 Jul 2021 14:32:07 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3a235kh5qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 14:32:07 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16TEW4gu11403684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 14:32:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 984B211C086;
        Thu, 29 Jul 2021 14:32:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C4DC11C07B;
        Thu, 29 Jul 2021 14:32:04 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.155.135])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 14:32:04 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 3/4] s390x: lib: sie: Add struct vm
 (de)initialization functions
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
References: <20210729134803.183358-1-frankja@linux.ibm.com>
 <20210729134803.183358-4-frankja@linux.ibm.com>
 <20210729162140.2475d3d6@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <35b0a125-3430-0765-2bf6-e6e889fc5d36@linux.ibm.com>
Date:   Thu, 29 Jul 2021 16:32:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210729162140.2475d3d6@p-imbrenda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lMOzCCrU64H57C0vQuh0KEQudN0hTu8Y
X-Proofpoint-GUID: TJmlcFa04eqOtMDcA5avhxhBUGH5-Rp1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/29/21 4:21 PM, Claudio Imbrenda wrote:
> On Thu, 29 Jul 2021 13:48:02 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Before I start copying the same code over and over lets move this into
>> the library.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/sie.c  | 30 ++++++++++++++++++++++++++++++
>>  lib/s390x/sie.h  |  3 +++
>>  s390x/mvpg-sie.c | 18 ++----------------
>>  s390x/sie.c      | 19 +++----------------
>>  4 files changed, 38 insertions(+), 32 deletions(-)
>>
>> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
>> index 9107519f..ec0c4867 100644
>> --- a/lib/s390x/sie.c
>> +++ b/lib/s390x/sie.c
>> @@ -11,6 +11,9 @@
>>  #include <asm/barrier.h>
>>  #include <libcflat.h>
>>  #include <sie.h>
>> +#include <asm/page.h>
>> +#include <libcflat.h>
>> +#include <alloc_page.h>
>>  
>>  static bool validity_expected;
>>  static uint16_t vir;
>> @@ -39,3 +42,30 @@ void sie_handle_validity(struct vm *vm)
>>  		report_abort("VALIDITY: %x", vir);
>>  	validity_expected = false;
>>  }
>> +
>> +/* Initializes the struct vm members like the SIE control block. */
>> +void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t
>> guest_mem_len) +{
>> +	vm->sblk = alloc_page();
>> +	memset(vm->sblk, 0, PAGE_SIZE);
> 
> you can skip the memset, the page allocator always zeroes the page,
> unless you explicitly pass FLAG_DONTZERO

Yeah I thought as much but I still like to have that explicitly for ease
of mind.

> 
> regardless of that:
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Thanks

> 
>> +	vm->sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
>> +	vm->sblk->ihcpu = 0xffff;
>> +	vm->sblk->prefix = 0;
>> +
>> +	/* Guest memory chunks are always 1MB */
>> +	assert(!(guest_mem_len & ~HPAGE_MASK));
>> +	/* Currently MSO/MSL is the easiest option */
>> +	vm->sblk->mso = (uint64_t)guest_mem;
>> +	vm->sblk->msl = (uint64_t)guest_mem + ((guest_mem_len - 1) &
>> HPAGE_MASK); +
>> +	/* CRYCB needs to be in the first 2GB */
>> +	vm->crycb = alloc_pages_flags(0, AREA_DMA31);
>> +	vm->sblk->crycbd = (uint32_t)(uintptr_t)vm->crycb;
>> +}
>> +
>> +/* Frees the memory that was gathered on initialization */
>> +void sie_guest_destroy(struct vm *vm)
>> +{
>> +	free_page(vm->crycb);
>> +	free_page(vm->sblk);
>> +}
>> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
>> index 7ff98d2d..946bd164 100644
>> --- a/lib/s390x/sie.h
>> +++ b/lib/s390x/sie.h
>> @@ -190,6 +190,7 @@ struct vm_save_area {
>>  struct vm {
>>  	struct kvm_s390_sie_block *sblk;
>>  	struct vm_save_area save_area;
>> +	uint8_t *crycb;				/* Crypto
>> Control Block */ /* Ptr to first guest page */
>>  	uint8_t *guest_mem;
>>  };
>> @@ -200,5 +201,7 @@ extern void sie64a(struct kvm_s390_sie_block
>> *sblk, struct vm_save_area *save_ar void sie_expect_validity(void);
>>  void sie_check_validity(uint16_t vir_exp);
>>  void sie_handle_validity(struct vm *vm);
>> +void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t
>> guest_mem_len); +void sie_guest_destroy(struct vm *vm);
>>  
>>  #endif /* _S390X_SIE_H_ */
>> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
>> index 2ac91eec..71ae4f88 100644
>> --- a/s390x/mvpg-sie.c
>> +++ b/s390x/mvpg-sie.c
>> @@ -110,22 +110,7 @@ static void setup_guest(void)
>>  	/* The first two pages are the lowcore */
>>  	guest_instr = guest + PAGE_SIZE * 2;
>>  
>> -	vm.sblk = alloc_page();
>> -
>> -	vm.sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
>> -	vm.sblk->prefix = 0;
>> -	/*
>> -	 * Pageable guest with the same ASCE as the test programm,
>> but
>> -	 * the guest memory 0x0 is offset to start at the allocated
>> -	 * guest pages and end after 1MB.
>> -	 *
>> -	 * It's not pretty but faster and easier than managing guest
>> ASCEs.
>> -	 */
>> -	vm.sblk->mso = (u64)guest;
>> -	vm.sblk->msl = (u64)guest;
>> -	vm.sblk->ihcpu = 0xffff;
>> -
>> -	vm.sblk->crycbd = (uint64_t)alloc_page();
>> +	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
>>  
>>  	vm.sblk->gpsw.addr = PAGE_SIZE * 4;
>>  	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
>> @@ -150,6 +135,7 @@ int main(void)
>>  	setup_guest();
>>  	test_mvpg();
>>  	test_mvpg_pei();
>> +	sie_guest_destroy(&vm);
>>  
>>  done:
>>  	report_prefix_pop();
>> diff --git a/s390x/sie.c b/s390x/sie.c
>> index 5c798a9e..9cb9b055 100644
>> --- a/s390x/sie.c
>> +++ b/s390x/sie.c
>> @@ -84,22 +84,7 @@ static void setup_guest(void)
>>  	/* The first two pages are the lowcore */
>>  	guest_instr = guest + PAGE_SIZE * 2;
>>  
>> -	vm.sblk = alloc_page();
>> -
>> -	vm.sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
>> -	vm.sblk->prefix = 0;
>> -	/*
>> -	 * Pageable guest with the same ASCE as the test programm,
>> but
>> -	 * the guest memory 0x0 is offset to start at the allocated
>> -	 * guest pages and end after 1MB.
>> -	 *
>> -	 * It's not pretty but faster and easier than managing guest
>> ASCEs.
>> -	 */
>> -	vm.sblk->mso = (u64)guest;
>> -	vm.sblk->msl = (u64)guest;
>> -	vm.sblk->ihcpu = 0xffff;
>> -
>> -	vm.sblk->crycbd = (uint64_t)alloc_page();
>> +	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
>>  }
>>  
>>  int main(void)
>> @@ -112,6 +97,8 @@ int main(void)
>>  
>>  	setup_guest();
>>  	test_diags();
>> +	sie_guest_destroy(&vm);
>> +
>>  done:
>>  	report_prefix_pop();
>>  	return report_summary();
> 

