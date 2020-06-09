Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B941F3EBE
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 17:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbgFIPBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 11:01:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37688 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725948AbgFIPBJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Jun 2020 11:01:09 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 059EdlHu043597;
        Tue, 9 Jun 2020 11:01:07 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31j4un91a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 11:01:07 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 059Eejdx047951;
        Tue, 9 Jun 2020 11:01:05 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31j4un918v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 11:01:05 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 059EtHla019747;
        Tue, 9 Jun 2020 15:01:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 31g2s7x5m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 15:01:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 059Exj4s50331948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jun 2020 14:59:45 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B97FD4C04E;
        Tue,  9 Jun 2020 15:01:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B7AB4C046;
        Tue,  9 Jun 2020 15:01:01 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.16.61])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Jun 2020 15:01:01 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v8 09/12] s390x: Library resources for CSS
 tests
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-10-git-send-email-pmorel@linux.ibm.com>
 <ef5e71b6-9c4d-ac3f-7946-f67db73d740b@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <17e5ccdd-f2b2-00bd-4ee2-c0a0b78a669a@linux.ibm.com>
Date:   Tue, 9 Jun 2020 17:01:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <ef5e71b6-9c4d-ac3f-7946-f67db73d740b@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-09_06:2020-06-09,2020-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 cotscore=-2147483648 mlxlogscore=999 priorityscore=1501 bulkscore=0
 phishscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006090107
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-09 09:09, Thomas Huth wrote:
> On 08/06/2020 10.12, Pierre Morel wrote:
>> Provide some definitions and library routines that can be used by

...snip...

>> +static inline int ssch(unsigned long schid, struct orb *addr)
>> +{
>> +	register long long reg1 asm("1") = schid;
>> +	int cc;
>> +
>> +	asm volatile(
>> +		"	ssch	0(%2)\n"
>> +		"	ipm	%0\n"
>> +		"	srl	%0,28\n"
>> +		: "=d" (cc)
>> +		: "d" (reg1), "a" (addr), "m" (*addr)
> 
> Hmm... What's the "m" (*addr) here good for? %3 is not used in the
> assembly code?

addr is %2
"m" (*addr) means memory pointed by addr is read

> 
>> +		: "cc", "memory");
> 
> Why "memory" ? Can this instruction also change the orb?

The orb not but this instruction modifies memory as follow:
orb -> ccw -> data

The CCW can be a READ or a WRITE instruction and the data my be anywhere 
in memory (<2G)

A compiler memory barrier is need to avoid write instructions started 
before the SSCH instruction to occur after for a write
and memory read made after the instruction to be executed before for a read.


> 
>> +	return cc;
>> +}
>> +
>> +static inline int stsch(unsigned long schid, struct schib *addr)
>> +{
>> +	register unsigned long reg1 asm ("1") = schid;
>> +	int cc;
>> +
>> +	asm volatile(
>> +		"	stsch	0(%3)\n"
>> +		"	ipm	%0\n"
>> +		"	srl	%0,28"
>> +		: "=d" (cc), "=m" (*addr)
>> +		: "d" (reg1), "a" (addr)
>> +		: "cc");
> 
> I'm surprised that this does not use "memory" in the clobber list ... I
> guess that's what the "=m" (*addr) is good for?

Yes the "=m" (*addr) is there to specify that the SCHIB pointed to by 
addr will be modified.


> 
>> +	return cc;
>> +}
>> +
>> +static inline int msch(unsigned long schid, struct schib *addr)
>> +{
>> +	register unsigned long reg1 asm ("1") = schid;
>> +	int cc;
>> +
>> +	asm volatile(
>> +		"	msch	0(%3)\n"
>> +		"	ipm	%0\n"
>> +		"	srl	%0,28"
>> +		: "=d" (cc), "=m" (*addr)
>> +		: "d" (reg1), "a" (addr)
> 
> I'm not an expert with these IO instructions, but this looks wrong to me
> ... Is MSCH reading or writing the SCHIB data?

MSCH is reading the SCHIB data in memory.


> 

...snip...

>> +/* Debug functions */
>> +char *dump_pmcw_flags(uint16_t f);
>> +char *dump_scsw_flags(uint32_t f);
>> +
>> +void dump_scsw(struct scsw *);
>> +void dump_irb(struct irb *irbp);
>> +void dump_schib(struct schib *sch);
>> +struct ccw1 *dump_ccw(struct ccw1 *cp);
>> +void dump_irb(struct irb *irbp);
>> +void dump_pmcw(struct pmcw *p);
>> +void dump_orb(struct orb *op);
> 
> In the patch description, you said that DEBUG_CSS needs to be defined
> for these - but now DEBUG_CSS is not used in this header... does the
> patch description need to be changed?

Yes, thanks, will do.
I removed it because it seems not useful to me.

> 
>> +int css_enumerate(void);
>> +#define MAX_ENABLE_RETRIES      5
>> +int css_enable(int schid);
>> +
>> +#endif
>> diff --git a/lib/s390x/css_dump.c b/lib/s390x/css_dump.c
>> new file mode 100644
>> index 0000000..0c2b64e
>> --- /dev/null
>> +++ b/lib/s390x/css_dump.c
>> @@ -0,0 +1,153 @@
>> +/*
>> + * Channel subsystem structures dumping
>> + *
>> + * Copyright (c) 2020 IBM Corp.
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + * This code is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2.
> 
> In the header you used "or any later version" - here it's version 2
> only. Maybe you want to standardize one one of the two flavors?

Yes, I will choose the shortest one, v2 only, as it seems to be the most 
used in kvm-unit-test.

Thanks for the review.
Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
