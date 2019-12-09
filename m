Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDC411720A
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 17:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfLIQnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 11:43:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17102 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726342AbfLIQnC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Dec 2019 11:43:02 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB9GMIaq078543
        for <kvm@vger.kernel.org>; Mon, 9 Dec 2019 11:43:01 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wrtfqgx6g-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2019 11:43:01 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 9 Dec 2019 16:42:59 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 9 Dec 2019 16:42:55 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB9GgsRF51118158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Dec 2019 16:42:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C412DAE055;
        Mon,  9 Dec 2019 16:42:54 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CFB8AE053;
        Mon,  9 Dec 2019 16:42:54 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Dec 2019 16:42:54 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 6/9] s390x: css: stsch, enumeration test
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1575649588-6127-1-git-send-email-pmorel@linux.ibm.com>
 <1575649588-6127-7-git-send-email-pmorel@linux.ibm.com>
 <977b5622-4890-19b5-693a-ae0295fcb883@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Mon, 9 Dec 2019 17:42:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <977b5622-4890-19b5-693a-ae0295fcb883@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19120916-0012-0000-0000-0000037336D4
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120916-0013-0000-0000-000021AF0645
Message-Id: <5e76b341-1cb2-62bc-6fd7-260673d07bb9@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_04:2019-12-09,2019-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912090141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-09 12:52, Thomas Huth wrote:
> On 06/12/2019 17.26, Pierre Morel wrote:
>> First step for testing the channel subsystem is to enumerate the css and
>> retrieve the css devices.
>>
>> This tests the success of STSCH I/O instruction.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     |  1 +
>>   s390x/Makefile      |  2 ++
>>   s390x/css.c         | 82 +++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/unittests.cfg |  4 +++
>>   4 files changed, 89 insertions(+)
>>   create mode 100644 s390x/css.c
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index 6f19bb5..d37227b 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -82,6 +82,7 @@ struct pmcw {
>>   	uint8_t  chpid[8];
>>   	uint16_t flags2;
>>   };
>> +#define PMCW_CHANNEL_TYPE(pmcw) (pmcw->flags >> 21)
>>   
>>   struct schib {
>>   	struct pmcw pmcw;
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 3744372..9ebbb84 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -16,6 +16,7 @@ tests += $(TEST_DIR)/diag288.elf
>>   tests += $(TEST_DIR)/stsi.elf
>>   tests += $(TEST_DIR)/skrf.elf
>>   tests += $(TEST_DIR)/smp.elf
>> +tests += $(TEST_DIR)/css.elf
>>   tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>   
>>   all: directories test_cases test_cases_binary
>> @@ -50,6 +51,7 @@ cflatobjs += lib/s390x/sclp-console.o
>>   cflatobjs += lib/s390x/interrupt.o
>>   cflatobjs += lib/s390x/mmu.o
>>   cflatobjs += lib/s390x/smp.o
>> +cflatobjs += lib/s390x/css_dump.o
>>   
>>   OBJDIRS += lib/s390x
>>   
>> diff --git a/s390x/css.c b/s390x/css.c
>> new file mode 100644
>> index 0000000..3d4a986
>> --- /dev/null
>> +++ b/s390x/css.c
>> @@ -0,0 +1,82 @@
>> +/*
>> + * Channel Subsystem tests
>> + *
>> + * Copyright (c) 2019 IBM Corp
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + * This code is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2.
>> + */
>> +
>> +#include <libcflat.h>
>> +
>> +#include <css.h>
>> +
>> +#define SID_ONE		0x00010000
>> +
>> +static struct schib schib;
>> +
>> +static const char *Channel_type[4] = {
>> +	"I/O", "CHSC", "MSG", "EADM"
>> +};
>> +
>> +static int test_device_sid;
>> +
>> +static void test_enumerate(void)
>> +{
>> +	struct pmcw *pmcw = &schib.pmcw;
>> +	int scn;
>> +	int cc, i;
>> +	int found = 0;
>> +
>> +	for (scn = 0; scn < 0xffff; scn++) {
>> +		cc = stsch(scn|SID_ONE, &schib);
>> +		if (!cc && (pmcw->flags & PMCW_DNV)) {
>> +			report_info("SID %04x Type %s PIM %x", scn,
>> +				     Channel_type[PMCW_CHANNEL_TYPE(pmcw)],
>> +				     pmcw->pim);
>> +			for (i = 0; i < 8; i++)  {
>> +				if ((pmcw->pim << i) & 0x80) {
>> +					report_info("CHPID[%d]: %02x", i,
>> +						    pmcw->chpid[i]);
>> +					break;
>> +				}
>> +			}
>> +			found++;
>> +		}
>> +		if (cc == 3) /* cc = 3 means no more channel in CSS */
>> +			break;
>> +		if (found && !test_device_sid)
>> +			test_device_sid = scn|SID_ONE;
>> +	}
>> +	if (!found) {
>> +		report("Tested %d devices, none found", 0, scn);
>> +		return;
>> +	}
>> +	report("Tested %d devices, %d found", 1, scn, found);
> 
> I'm sorry, but since last Friday, you now have to swap the first two
> parameters of the report() function. (that was unfortunately necessary
> to fix an issue with Clang)
> 
>   Thomas
> 

grrr.   :)

OK, will do.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

