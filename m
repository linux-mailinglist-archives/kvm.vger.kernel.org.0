Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A133E48AB
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 17:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235525AbhHIPZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 11:25:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45404 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235588AbhHIPZ0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 11:25:26 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179F4QlS184481;
        Mon, 9 Aug 2021 11:25:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=92CSMFWIHVvbAZhW6mbS9BPDXlq2dgOMjfcK6Kplj80=;
 b=iQmO+PiwE34MfB6dEHltxjD0i/5OUr4jPOkayDM8HKCxyBGMRT33tZf4VSsvUvN3FE0k
 +gt8S4ywzapPad8dCEEn66mD8JSrLb5VJNYJ0l4u6aZRSHILqqZsqFSNflLej6+nnyGD
 mW6Py7+CK6YeoqXl3ramN89UXETz91WHGYKX4kaihyW4WQvxCMLeZOAi5n773+xiV/na
 /ZtMUfRrB8gbruc26hyphnKh6qYIYA5EvUdPu9LYwZeRHh3PX9lc1NFp813kWlbZWJyf
 ZfyP0yZ4Qp9DSnyaHxuFagnL7vVbx4EgCyvqCEy1evJFlJgxWAV7zE+jOllwj9+x+0sJ fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aa7n0burx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 11:25:05 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 179F4dWs185808;
        Mon, 9 Aug 2021 11:25:04 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aa7n0buqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 11:25:04 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 179FCE3r030665;
        Mon, 9 Aug 2021 15:25:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3a9ht8uqws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 15:25:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 179FOxRU47448464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 15:24:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C18EAE0F6;
        Mon,  9 Aug 2021 15:24:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DEE2AE0ED;
        Mon,  9 Aug 2021 15:24:59 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.151.189])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 15:24:58 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 3/4] s390x: topology: check the Perform
 Topology Function
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        david@redhat.com
References: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
 <1628498934-20735-4-git-send-email-pmorel@linux.ibm.com>
 <20210809120306.6bd78354@p-imbrenda>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <0af6723f-f8b6-18cf-73ef-535cc818468b@linux.ibm.com>
Date:   Mon, 9 Aug 2021 17:24:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809120306.6bd78354@p-imbrenda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eQGFMXCB-6nk3Y-3A4TVHNqQmXEIfNdq
X-Proofpoint-ORIG-GUID: 6wYcjCt-0eU0VpOFcZGSTsTIoU7Ui0c9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_05:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108090111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/9/21 12:03 PM, Claudio Imbrenda wrote:
> On Mon,  9 Aug 2021 10:48:53 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We check the PTF instruction.
>>
>> - We do not expect to support vertical polarization.
>>
>> - We do not expect the Modified Topology Change Report to be
>> pending or not at the moment the first PTF instruction with
>> PTF_CHECK function code is done as some code already did run
>> a polarization change may have occur.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/Makefile      |  1 +
>>   s390x/topology.c    | 87
>> +++++++++++++++++++++++++++++++++++++++++++++ s390x/unittests.cfg |
>> 3 ++ 3 files changed, 91 insertions(+)
>>   create mode 100644 s390x/topology.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 6565561b..c82b7dbf 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -24,6 +24,7 @@ tests += $(TEST_DIR)/mvpg.elf
>>   tests += $(TEST_DIR)/uv-host.elf
>>   tests += $(TEST_DIR)/edat.elf
>>   tests += $(TEST_DIR)/mvpg-sie.elf
>> +tests += $(TEST_DIR)/topology.elf
>>   
>>   tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>   ifneq ($(HOST_KEY_DOCUMENT),)
>> diff --git a/s390x/topology.c b/s390x/topology.c
>> new file mode 100644
>> index 00000000..4146189a
>> --- /dev/null
>> +++ b/s390x/topology.c
>> @@ -0,0 +1,87 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * CPU Topology
>> + *
>> + * Copyright (c) 2021 IBM Corp
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + */
>> +
>> +#include <libcflat.h>
>> +#include <asm/page.h>
>> +#include <asm/asm-offsets.h>
>> +#include <asm/interrupt.h>
>> +#include <asm/facility.h>
>> +#include <smp.h>
>> +#include <sclp.h>
>> +
>> +static uint8_t pagebuf[PAGE_SIZE * 2]
>> __attribute__((aligned(PAGE_SIZE * 2))); +int machine_level;
>> +int mnest;
>> +
>> +#define PTF_HORIZONTAL	0
>> +#define PTF_VERTICAL	1
>> +#define PTF_CHECK	2
>> +
>> +#define PTF_ERR_NO_REASON	0
>> +#define PTF_ERR_ALRDY_POLARIZED	1
>> +#define PTF_ERR_IN_PROGRESS	2
>> +
>> +static int ptf(unsigned long fc, unsigned long *rc)
>> +{
>> +	int cc;
>> +
>> +	asm volatile(
>> +		"       .insn   rre,0xb9a20000,%1,%1\n"
> 
> I know you copied this from the kernel, but the second argument is not
> really there according to the PoP, so maybe it's better to have this
> instead?
> 
> 	.insn   rre,0xb9a20000,%1,0\n

OK, thanks.

> 
>> +		"       ipm     %0\n"
>> +		"       srl     %0,28\n"
>> +		: "=d" (cc), "+d" (fc)
>> +		: "d" (fc)
>> +		: "cc");
>> +
>> +	*rc = fc >> 8;
>> +	return cc;
>> +}
>> +
>> +static void test_ptf(void)
>> +{
>> +	unsigned long rc;
>> +	int cc;
>> +
>> +	report_prefix_push("Topology Report pending");
>> +	/*
>> +	 * At this moment the topology may already have changed
>> +	 * since the VM has been started.
>> +	 * However, we can test if a second PTF instruction
>> +	 * reports that the topology did not change since the
>> +	 * preceding PFT instruction.
>> +	 */
>> +	ptf(PTF_CHECK, &rc);
>> +	cc = ptf(PTF_CHECK, &rc);
>> +	report(cc == 0, "PTF check clear");
>> +	cc = ptf(PTF_HORIZONTAL, &rc);
>> +	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED,
>> +	       "PTF horizontal already configured");
>> +	cc = ptf(PTF_VERTICAL, &rc);
>> +	report(cc == 2 && rc == PTF_ERR_NO_REASON,
>> +	       "PTF vertical non possible");
> 
> *not possible

Oh yes :)

> 
>> +
>> +	report_prefix_pop();
>> +}
>> +
>> +int main(int argc, char *argv[])
>> +{
>> +	report_prefix_push("stsi");
> 
> should this really be "stsi" ?

No, I think CPU-Topology should be better.




-- 
Pierre Morel
IBM Lab Boeblingen
