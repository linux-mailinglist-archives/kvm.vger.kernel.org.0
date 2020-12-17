Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F752DD489
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 16:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgLQPqJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 10:46:09 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51394 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728131AbgLQPqI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 10:46:08 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BHFWkHO105623;
        Thu, 17 Dec 2020 10:45:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SrSnq+Lrp7lcCITWSoGuDUVXJL8pnv1ZhaLX/A4f3Ls=;
 b=ZbHeRtrglZO7HSyskmLWJSZgLaQeHLxc6HmPNZLplQPijqabufQ3iZZAXypFyDR2JNIq
 njSjGpSA3MhLWRsgloNVZ0uEL94cwYA6At6F2IdF57MsVuMPam5XB5JqjEGHZUxwhP0q
 jHlFPjU+vpAmfAdV7440sSKQBu9/WPGa/NtW3Lahg5+70g/NGfrqZsD3C/ZI3NNl8am7
 dcAYUtP+Qlt88r1JMUqiciPKAcHzfIamhczV6ulaU7p24rXMdb3PpOqeccxbF57b3RvV
 +IZCIxUwowniSFqW4B6rGuTB/SWcvXgFbwmPJXnYkNedcRIW5ai5H2FJWFesvqsRnQTK yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35g8prb92a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 10:45:27 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BHFWwIG106940;
        Thu, 17 Dec 2020 10:45:27 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35g8prb91b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 10:45:27 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BHFSDGu015195;
        Thu, 17 Dec 2020 15:45:25 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 35fbp5hjdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 15:45:25 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BHFjMnE35651930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 15:45:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EA7E42049;
        Thu, 17 Dec 2020 15:45:22 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C16E84203F;
        Thu, 17 Dec 2020 15:45:21 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.181.71])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Dec 2020 15:45:21 +0000 (GMT)
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201211100039.63597-1-frankja@linux.ibm.com>
 <20201211100039.63597-6-frankja@linux.ibm.com>
 <0bb4934a-23b6-bf4f-2742-3892c17c81d0@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 5/8] s390x: sie: Add SIE to lib
Message-ID: <365acc5e-0f57-ed9e-cee3-b321827fd2b6@linux.ibm.com>
Date:   Thu, 17 Dec 2020 16:45:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <0bb4934a-23b6-bf4f-2742-3892c17c81d0@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_10:2020-12-15,2020-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 impostorscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/20 10:37 AM, Thomas Huth wrote:
> On 11/12/2020 11.00, Janosch Frank wrote:
>> This commit adds the definition of the SIE control block struct and
>> the assembly to execute SIE and save/restore guest registers.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/asm-offsets.c  |  13 +++
>>  lib/s390x/asm/arch_def.h |   7 ++
>>  lib/s390x/interrupt.c    |   7 ++
>>  lib/s390x/sie.h          | 197 +++++++++++++++++++++++++++++++++++++++
>>  s390x/asm/lib.S          |  56 +++++++++++
>>  5 files changed, 280 insertions(+)
>>  create mode 100644 lib/s390x/sie.h
>>
>> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
>> index ee94ed3..35697de 100644
>> --- a/lib/s390x/asm-offsets.c
>> +++ b/lib/s390x/asm-offsets.c
>> @@ -8,6 +8,7 @@
>>  #include <libcflat.h>
>>  #include <kbuild.h>
>>  #include <asm/arch_def.h>
>> +#include <sie.h>
>>  
>>  int main(void)
>>  {
>> @@ -69,6 +70,18 @@ int main(void)
>>  	OFFSET(GEN_LC_ARS_SA, lowcore, ars_sa);
>>  	OFFSET(GEN_LC_CRS_SA, lowcore, crs_sa);
>>  	OFFSET(GEN_LC_PGM_INT_TDB, lowcore, pgm_int_tdb);
>> +	OFFSET(__SF_GPRS, stack_frame, gprs);
>> +	OFFSET(__SF_SIE_CONTROL, stack_frame, empty1[0]);
>> +	OFFSET(__SF_SIE_SAVEAREA, stack_frame, empty1[1]);
>> +	OFFSET(__SF_SIE_REASON, stack_frame, empty1[2]);
>> +	OFFSET(__SF_SIE_FLAGS, stack_frame, empty1[3]);
>> +	OFFSET(SIE_SAVEAREA_HOST_GRS, vm_save_area, host.grs[0]);
>> +	OFFSET(SIE_SAVEAREA_HOST_FPRS, vm_save_area, host.fprs[0]);
>> +	OFFSET(SIE_SAVEAREA_HOST_FPC, vm_save_area, host.fpc);
>> +	OFFSET(SIE_SAVEAREA_GUEST_GRS, vm_save_area, guest.grs[0]);
>> +	OFFSET(SIE_SAVEAREA_GUEST_FPRS, vm_save_area, guest.fprs[0]);
>> +	OFFSET(SIE_SAVEAREA_GUEST_FPC, vm_save_area, guest.fpc);
>> +
>>  
>>  	return 0;
>>  }
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index f3ab830..5a13cf2 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -8,6 +8,13 @@
>>  #ifndef _ASM_S390X_ARCH_DEF_H_
>>  #define _ASM_S390X_ARCH_DEF_H_
>>  
>> +struct stack_frame {
>> +	unsigned long back_chain;
>> +	unsigned long empty1[5];
>> +	unsigned long gprs[10];
>> +	unsigned int  empty2[8];
> 
> I think you can drop empty2 ?

Since I don't need to allocate it I could also remove the gprs. We only
use empty1 right now as far as I know.

> 
>> +};
>> +
>>  struct psw {
>>  	uint64_t	mask;
>>  	uint64_t	addr;
>> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
>> index bac8862..3858096 100644
>> --- a/lib/s390x/interrupt.c
>> +++ b/lib/s390x/interrupt.c
>> @@ -11,6 +11,7 @@
>>  #include <asm/barrier.h>
>>  #include <sclp.h>
>>  #include <interrupt.h>
>> +#include <sie.h>
>>  
>>  static bool pgm_int_expected;
>>  static bool ext_int_expected;
>> @@ -57,6 +58,12 @@ void register_pgm_cleanup_func(void (*f)(void))
>>  
>>  static void fixup_pgm_int(void)
>>  {
>> +	/* If we have an error on SIE we directly move to sie_exit */
>> +	if (lc->pgm_old_psw.addr >= (uint64_t)&sie_entry &&
>> +	    lc->pgm_old_psw.addr <= (uint64_t)&sie_entry + 10) {
> 
> Can you please explain that "magic" number 10 in the comment?

I think using sie_exit would make more sense than explaining that
sie_entry + 10 bytes is the location of sie_exit.


> 
>> +		lc->pgm_old_psw.addr = (uint64_t)&sie_exit;
>> +	}
>> +
>>  	switch (lc->pgm_int_code) {
>>  	case PGM_INT_CODE_PRIVILEGED_OPERATION:
>>  		/* Normal operation is in supervisor state, so this exception
>> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
>> new file mode 100644
>> index 0000000..b00bdf4
>> --- /dev/null
>> +++ b/lib/s390x/sie.h
> [...]
>> +extern u64 sie_entry;
>> +extern u64 sie_exit;
> 
> Maybe better:
> 
> extern uint16_t sie_entry[];
> extern uint16_t sie_exit[];
> 
> ?
> 
> Or even:
> 
> extern void sie_entry();
> extern void sie_exit();

Definitely better since I don't return values in sie_exit anymore (I
used to before).

> 
> ?
> 
>  Thomas
> 

