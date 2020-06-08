Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09BD1F1B0B
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 16:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbgFHOeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 10:34:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33088 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729553AbgFHOeG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 10:34:06 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 058EXfC0064133;
        Mon, 8 Jun 2020 10:34:05 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g41dvkp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 10:34:05 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 058EXnvS064697;
        Mon, 8 Jun 2020 10:34:05 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g41dvkdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 10:34:04 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 058EVfXo018271;
        Mon, 8 Jun 2020 14:33:48 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 31g2s7spjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 14:33:48 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 058EXkci1901038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jun 2020 14:33:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17DD64203F;
        Mon,  8 Jun 2020 14:33:46 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC5BF42047;
        Mon,  8 Jun 2020 14:33:45 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.43.245])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Jun 2020 14:33:45 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v8 01/12] s390x: Use PSW bits definitions
 in cstart
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-2-git-send-email-pmorel@linux.ibm.com>
 <59f3dda9-6cd1-a3b4-5265-1a9fb2ff51ed@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <e03cb81c-30cc-7cbc-c3a8-cc863a5d0be1@linux.ibm.com>
Date:   Mon, 8 Jun 2020 16:33:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <59f3dda9-6cd1-a3b4-5265-1a9fb2ff51ed@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-08_13:2020-06-08,2020-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 malwarescore=0 impostorscore=0 clxscore=1015 mlxlogscore=999
 bulkscore=0 suspectscore=0 cotscore=-2147483648 priorityscore=1501
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006080109
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-08 10:43, Thomas Huth wrote:
> On 08/06/2020 10.12, Pierre Morel wrote:
>> This patch defines the PSW bits EA/BA used to initialize the PSW masks
>> for exceptions.
>>
>> Since some PSW mask definitions exist already in arch_def.h we add these
>> definitions there.
>> We move all PSW definitions together and protect assembler code against
>> C syntax.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/asm/arch_def.h | 15 +++++++++++----
>>   s390x/cstart64.S         | 15 ++++++++-------
>>   2 files changed, 19 insertions(+), 11 deletions(-)
>>
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index 1b3bb0c..5388114 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -10,15 +10,21 @@
>>   #ifndef _ASM_S390X_ARCH_DEF_H_
>>   #define _ASM_S390X_ARCH_DEF_H_
>>   
>> +#define PSW_MASK_EXT			0x0100000000000000UL
>> +#define PSW_MASK_DAT			0x0400000000000000UL
>> +#define PSW_MASK_SHORT_PSW		0x0008000000000000UL
>> +#define PSW_MASK_PSTATE			0x0001000000000000UL
>> +#define PSW_MASK_BA			0x0000000080000000UL
>> +#define PSW_MASK_EA			0x0000000100000000UL
>> +
>> +#define PSW_EXCEPTION_MASK	(PSW_MASK_EA | PSW_MASK_BA)
> 
> PSW_EXCEPTION_MASK sounds a little bit unfortunate - that term rather
> reminds me of something that disables some interrupts
> ... in case you
> respin, maybe rather use something like "PSW_EXC_ADDR_MODE" ?

EXCEPTIONS_PSW_MASK ?

a vote?

> Well, since nobody else complained yet, and the rest of the patch looks
> fine:
> 
> Acked-by: Thomas Huth <thuth@redhat.com>
> 

Thanks,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
