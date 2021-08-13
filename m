Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BD43EB499
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 13:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239802AbhHMLfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 07:35:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18342 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238157AbhHMLfD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 07:35:03 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DBYDVT150102;
        Fri, 13 Aug 2021 07:34:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=49qhHYSpUgDjtGU1yGfIrGECR86Ig9vBL6TsfU7zT3Q=;
 b=ONeaIcipHd2IfVWiJcAByZa8FpwGiLLfk15nGWQqsUJ9X/1Y49m+fW8VDq/+xMsS49kX
 lcKc7OltPCplSNoVuBsoSsMOVCiqLebI2r4B6fUgE12Boe57DXfdfDwU6nJPARVhS2j1
 OM/Vk4mfGX2agK3t1x5nsSPX+WjQTxqUmOcITMtfUqSzgGcRVa5Q/M7alaqjHpecu9Fq
 jWtSrDVZIHdErin7wpOwX5an/V2W2O55zfIIrXSr+MzttViA/nL30YCh2/r818dr4EY2
 5QgD8Q1TXx7drWXyyOOKLf99+r6YsYUGJm4Ab3lznT3/Gju0uSZWJZt6cjI72ABdN8rU 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad1ky413d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 07:34:36 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17DBYZ7w154910;
        Fri, 13 Aug 2021 07:34:35 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad1ky412f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 07:34:35 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17DBW1CM024366;
        Fri, 13 Aug 2021 11:34:33 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3abujqvtyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 11:34:32 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17DBVBRc45416722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 11:31:11 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30C98A406F;
        Fri, 13 Aug 2021 11:34:30 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEF0DA4062;
        Fri, 13 Aug 2021 11:34:29 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.158.198])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 Aug 2021 11:34:29 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 3/8] lib: s390x: Print addressing related
 exception information
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
References: <20210813073615.32837-1-frankja@linux.ibm.com>
 <20210813073615.32837-4-frankja@linux.ibm.com>
 <20210813104017.6e669d72@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <4c6682cc-f4b5-2a70-167c-00af4b333c2d@linux.ibm.com>
Date:   Fri, 13 Aug 2021 13:34:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210813104017.6e669d72@p-imbrenda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HzpFFfcMjZYPU4IoMS9rV2OOPJ3-LuUU
X-Proofpoint-ORIG-GUID: NzZkN8qssEoU9G-DLP2G6fGZQpeVhTTc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_03:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/13/21 10:40 AM, Claudio Imbrenda wrote:
> On Fri, 13 Aug 2021 07:36:10 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Right now we only get told the kind of program exception as well as
>> the PSW at the point where it happened.
>>
>> For addressing exceptions the PSW is not always enough so let's print
>> the TEID which contains the failing address and flags that tell us
>> more about the kind of address exception.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/asm/arch_def.h |  4 +++
>>  lib/s390x/interrupt.c    | 72
>> ++++++++++++++++++++++++++++++++++++++++ 2 files changed, 76
>> insertions(+)
>>
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index 4ca02c1d..39c5ba99 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -41,6 +41,10 @@ struct psw {
>>  	uint64_t	addr;
>>  };
>>  
>> +/* Let's ignore spaces we don't expect to use for now. */
>> +#define AS_PRIM				0
>> +#define AS_HOME				3
>> +
>>  #define PSW_MASK_EXT			0x0100000000000000UL
>>  #define PSW_MASK_IO			0x0200000000000000UL
>>  #define PSW_MASK_DAT			0x0400000000000000UL
>> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
>> index 01ded49d..1248bceb 100644
>> --- a/lib/s390x/interrupt.c
>> +++ b/lib/s390x/interrupt.c
>> @@ -12,6 +12,7 @@
>>  #include <sclp.h>
>>  #include <interrupt.h>
>>  #include <sie.h>
>> +#include <asm/page.h>
>>  
>>  static bool pgm_int_expected;
>>  static bool ext_int_expected;
>> @@ -126,6 +127,73 @@ static void fixup_pgm_int(struct stack_frame_int
>> *stack) /* suppressed/terminated/completed point already at the next
>> address */ }
>>  
>> +static void decode_pgm_prot(uint64_t teid)
> 
> it is actually more complicated than this.

I know it hurts to look at the spec :)

> 
> if you don't want to add all the possibilities because they are
> unlikely and/or not relevant, maybe add a comment

Will do!

> 
>> +{
>> +	/* Low-address protection exception, 100 */
>> +	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) &&
>> !test_bit_inv(61, &teid)) {
>> +		printf("Type: LAP\n");
>> +		return;
>> +	}
>> +
>> +	/* Instruction execution prevention, i.e. no-execute, 101 */
>> +	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) &&
>> test_bit_inv(61, &teid)) {
>> +		printf("Type: IEP\n");
>> +		return;
>> +	}
>> +
>> +	/* Standard DAT exception, 001 */
>> +	if (!test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) &&
>> test_bit_inv(61, &teid)) {
>> +		printf("Type: DAT\n");
>> +		return;
>> +	}
>> +}
>> +
>> +static void decode_teid(uint64_t teid)
>> +{
>> +	int asce_id = lc->trans_exc_id & 3;
>> +	bool dat = lc->pgm_old_psw.mask & PSW_MASK_DAT;
>> +
>> +	printf("Memory exception information:\n");
>> +	printf("TEID: %lx\n", teid);
>> +	printf("DAT: %s\n", dat ? "on" : "off");
>> +	printf("AS: %s\n", asce_id == AS_PRIM ? "Primary" : "Home");
>> +
>> +	if (lc->pgm_int_code == PGM_INT_CODE_PROTECTION)
>> +		decode_pgm_prot(teid);
>> +
>> +	/*
>> +	 * If teid bit 61 is off for these two exception the reported
>> +	 * address is unpredictable.
>> +	 */
>> +	if ((lc->pgm_int_code == PGM_INT_CODE_SECURE_STOR_ACCESS ||
>> +	     lc->pgm_int_code == PGM_INT_CODE_SECURE_STOR_VIOLATION)
>> &&
>> +	    !test_bit_inv(61, &teid)) {
>> +		printf("Address: %lx, unpredictable\n ", teid &
>> PAGE_MASK);
>> +		return;
>> +	}
>> +	printf("Address: %lx\n\n", teid & PAGE_MASK);
>> +}
>> +
>> +static void print_storage_exception_information(void)
>> +{
>> +	switch (lc->pgm_int_code) {
>> +	case PGM_INT_CODE_PROTECTION:
>> +	case PGM_INT_CODE_PAGE_TRANSLATION:
>> +	case PGM_INT_CODE_SEGMENT_TRANSLATION:
>> +	case PGM_INT_CODE_ASCE_TYPE:
>> +	case PGM_INT_CODE_REGION_FIRST_TRANS:
>> +	case PGM_INT_CODE_REGION_SECOND_TRANS:
>> +	case PGM_INT_CODE_REGION_THIRD_TRANS:
>> +	case PGM_INT_CODE_SECURE_STOR_ACCESS:
>> +	case PGM_INT_CODE_NON_SECURE_STOR_ACCESS:
>> +	case PGM_INT_CODE_SECURE_STOR_VIOLATION:
>> +		decode_teid(lc->trans_exc_id);
>> +		break;
>> +	default:
>> +		return;
>> +	}
>> +}
>> +
>>  static void print_int_regs(struct stack_frame_int *stack)
>>  {
>>  	printf("\n");
>> @@ -155,6 +223,10 @@ static void print_pgm_info(struct
>> stack_frame_int *stack) lc->pgm_int_code, stap(),
>> lc->pgm_old_psw.addr, lc->pgm_int_id); print_int_regs(stack);
>>  	dump_stack();
>> +
>> +	/* Dump stack doesn't end with a \n so we add it here
>> instead */
>> +	printf("\n");
>> +	print_storage_exception_information();
>>  	report_summary();
>>  	abort();
>>  }
> 

