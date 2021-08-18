Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA7F3F00FE
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 11:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhHRJy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 05:54:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46286 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232797AbhHRJyW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 05:54:22 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17I9X3Yk038099;
        Wed, 18 Aug 2021 05:53:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fEIAiqsDSA0A3TD7pdD75X7ZnKBbo/poGUH0nr7+SLg=;
 b=hFAFCUxe+OXTGk85GCLrakoX9+VeknCQNfkWZLvJ/tjkEyKTmz+SSDlWF1pSRCOTUSCA
 nHtPZjayokm5l6OyqYH2nYoFZRd0PcGlCfdRhK2Tb6jdD96RxSAc6Qb7I2NAggtOSAX5
 D2UAQM+vwggbjK/FbEYYbX0o5EL2SRfJGzDBnQlKZO9MtOG7CwV+5rotCfScA8bLSBmH
 Bc6L508W5soHmTItdpGWazXMrlBsSUZIR3Rla3JAOkczaxnbtEOAF2kg3QZdPbQSONA3
 x7RuS803i8VnvBBJK+rZCP1+URmcAw4FSOG0mE71eV3jBW6bOmY4qBLDdtYQbI3lEVwZ qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agg0a0r8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 05:53:46 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17I9igct081307;
        Wed, 18 Aug 2021 05:53:46 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agg0a0r7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 05:53:45 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17I9qDZ6018895;
        Wed, 18 Aug 2021 09:53:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3ae5f8dfbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 09:53:43 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17I9rfqK53477822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 09:53:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF726A405C;
        Wed, 18 Aug 2021 09:53:40 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90457A4060;
        Wed, 18 Aug 2021 09:53:40 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.174.181])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 09:53:40 +0000 (GMT)
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210813073615.32837-1-frankja@linux.ibm.com>
 <20210813073615.32837-4-frankja@linux.ibm.com>
 <1f99e6f8-27d1-7e4a-f706-12912e84f6f4@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 3/8] lib: s390x: Print addressing related
 exception information
Message-ID: <4e5c1696-894a-e102-299b-d85e4ccac5ec@linux.ibm.com>
Date:   Wed, 18 Aug 2021 11:53:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1f99e6f8-27d1-7e4a-f706-12912e84f6f4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sF9P5U4ax8ZProke2NI8_pU12PDHLfQo
X-Proofpoint-GUID: h39PxjCtEBMirA506r_uyxLOyaeyOE3B
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_03:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 spamscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108180059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/18/21 11:12 AM, Thomas Huth wrote:
> On 13/08/2021 09.36, Janosch Frank wrote:
>> Right now we only get told the kind of program exception as well as
>> the PSW at the point where it happened.
>>
>> For addressing exceptions the PSW is not always enough so let's print
>> the TEID which contains the failing address and flags that tell us
>> more about the kind of address exception.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/asm/arch_def.h |  4 +++
>>   lib/s390x/interrupt.c    | 72 ++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 76 insertions(+)
>>
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index 4ca02c1d..39c5ba99 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -41,6 +41,10 @@ struct psw {
>>   	uint64_t	addr;
>>   };
>>   
>> +/* Let's ignore spaces we don't expect to use for now. */
>> +#define AS_PRIM				0
>> +#define AS_HOME				3
>> +
>>   #define PSW_MASK_EXT			0x0100000000000000UL
>>   #define PSW_MASK_IO			0x0200000000000000UL
>>   #define PSW_MASK_DAT			0x0400000000000000UL
>> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
>> index 01ded49d..1248bceb 100644
>> --- a/lib/s390x/interrupt.c
>> +++ b/lib/s390x/interrupt.c
>> @@ -12,6 +12,7 @@
>>   #include <sclp.h>
>>   #include <interrupt.h>
>>   #include <sie.h>
>> +#include <asm/page.h>
>>   
>>   static bool pgm_int_expected;
>>   static bool ext_int_expected;
>> @@ -126,6 +127,73 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
>>   	/* suppressed/terminated/completed point already at the next address */
>>   }
>>   
>> +static void decode_pgm_prot(uint64_t teid)
>> +{
>> +	/* Low-address protection exception, 100 */
>> +	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && !test_bit_inv(61, &teid)) {
> 
> Likely just a matter of taste, but I'd prefer something like:
> 
> 	if ((teid & 0x8c) == 0x80) {

The POP states these as bits when you have a look at the ESOP section
and I'd like to keep it the same here for easier comparison.

The test_bits() are as explicit as it gets and I value that.

> 
>> +		printf("Type: LAP\n");
>> +		return;
>> +	}
>> +
>> +	/* Instruction execution prevention, i.e. no-execute, 101 */
>> +	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && test_bit_inv(61, &teid)) {
>> +		printf("Type: IEP\n");
>> +		return;
>> +	}
>> +
>> +	/* Standard DAT exception, 001 */
>> +	if (!test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && test_bit_inv(61, &teid)) {
>> +		printf("Type: DAT\n");
>> +		return;
>> +	}
> 
> What about 010 (key controlled protection) and 011 (access-list controlled 
> protection)? Even if we do not trigger those yet, it might make sense to add 
> them right from the start, too?

If I do that then I can start a whole new file "fault.c" and move these
changes there (which I'll do now anyway). My intentions were a small
change that covers 90% of our current exceptions (especially PV
exceptions) to make my life easier in LPAR.

If people add skey/ar code they can also add the decoding here, no? :-)

> 
>> +}
>> +
>> +static void decode_teid(uint64_t teid)
>> +{
>> +	int asce_id = lc->trans_exc_id & 3;
> 
> Why are you referencing the lc->trans_exc_id here again? It's already passed 
> as "teid" parameter.

Forgot to remove that

> 
>> +	bool dat = lc->pgm_old_psw.mask & PSW_MASK_DAT;
>> +
>> +	printf("Memory exception information:\n");
>> +	printf("TEID: %lx\n", teid);
>> +	printf("DAT: %s\n", dat ? "on" : "off");
>> +	printf("AS: %s\n", asce_id == AS_PRIM ? "Primary" : "Home");
> 
> Could "secondary" or "AR" mode really never happen here? I'd rather like to 
> see a switch-case statement here that is able to print all four modes, just 
> to avoid confusion.

Right now we ONLY use primary space.

> 
>> +	if (lc->pgm_int_code == PGM_INT_CODE_PROTECTION)
>> +		decode_pgm_prot(teid);
>> +
>> +	/*
>> +	 * If teid bit 61 is off for these two exception the reported
>> +	 * address is unpredictable.
>> +	 */
>> +	if ((lc->pgm_int_code == PGM_INT_CODE_SECURE_STOR_ACCESS ||
>> +	     lc->pgm_int_code == PGM_INT_CODE_SECURE_STOR_VIOLATION) &&
>> +	    !test_bit_inv(61, &teid)) {
>> +		printf("Address: %lx, unpredictable\n ", teid & PAGE_MASK);
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
> 
> I think you could drop that default case.

Yes

> 
>> +	}
>> +}
>> +
>>   static void print_int_regs(struct stack_frame_int *stack)
>>   {
>>   	printf("\n");
>> @@ -155,6 +223,10 @@ static void print_pgm_info(struct stack_frame_int *stack)
>>   	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr, lc->pgm_int_id);
>>   	print_int_regs(stack);
>>   	dump_stack();
>> +
>> +	/* Dump stack doesn't end with a \n so we add it here instead */
>> +	printf("\n");
>> +	print_storage_exception_information();
>>   	report_summary();
>>   	abort();
>>   }
>>
> 

