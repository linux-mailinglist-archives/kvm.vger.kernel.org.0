Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BF63E495B
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 17:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235885AbhHIP5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 11:57:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34458 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235642AbhHIP5w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 11:57:52 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179FrmBG142060;
        Mon, 9 Aug 2021 11:57:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ct2Ila10cJWPbMPU33amPEXJaz/mQhYJvriZAqQ4gMU=;
 b=S0f0kkb2njr0R3CBfgCZMW3w86+TV3YbjY98gFXMdg/ro0F2wPk9FbmQVdTN7jvyqu67
 OTP5OSoIWN+SdSzpg4AuNsOQCVeOuDhuYHUxmt7wCpWacubvEvPZmUZK2omeg9vizBm8
 3sPLoynO2KuSqmEzdwM6RN3V5/thQbg989I/84zHTyyY04QOC7N3JhhfsVeXym8dDviv
 JdVpqv+d+AHqYRDh3CoR0ZoxuhmRRCz0nPae2iJIR9pFKsQtAAeD+yqEkfhzbm78ZTRX
 A1h5s4y3F0UpJEC47Q8Ku1MO8zfMfSjSsllO8G6yu1eJ3cK319YjsYvasuWRNugIi+yk uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aam0m95am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 11:57:31 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 179Fuh0Y008825;
        Mon, 9 Aug 2021 11:57:31 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aam0m959s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 11:57:31 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 179Fm4wf000891;
        Mon, 9 Aug 2021 15:57:29 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3a9hehc8yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 15:57:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 179FsGcE56492364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 15:54:16 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3471AE05F;
        Mon,  9 Aug 2021 15:57:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B137AE058;
        Mon,  9 Aug 2021 15:57:25 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.151.189])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 15:57:25 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 3/4] s390x: topology: check the Perform
 Topology Function
To:     Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
 <1628498934-20735-4-git-send-email-pmorel@linux.ibm.com>
 <9590216d-9cfd-0725-e77a-9bd13f8a2d60@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <78450ffb-eff7-7525-41db-2f4e58b5411f@linux.ibm.com>
Date:   Mon, 9 Aug 2021 17:57:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <9590216d-9cfd-0725-e77a-9bd13f8a2d60@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -Z7fLa_e8iV7RglKyMCo5htaSKgc6n5m
X-Proofpoint-ORIG-GUID: X4A_KDokJfhgVQToGR1zitaJNRFcsBKp
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_05:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 bulkscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/9/21 12:12 PM, Janosch Frank wrote:
> On 8/9/21 10:48 AM, Pierre Morel wrote:
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
>>   s390x/topology.c    | 87 +++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/unittests.cfg |  3 ++
>>   3 files changed, 91 insertions(+)
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
>> +static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
> 
> We don't actually need that I made a mistake in stsi_get_fc().
> I'll comment in the other patch.

OK I saw.
thx

> 
>> +int machine_level;
>> +int mnest;
>> +
>> +#define PTF_HORIZONTAL	0
>> +#define PTF_VERTICAL	1
> 
> PTF_REQ_*

OK

> 
>> +#define PTF_CHECK	2> +
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
>> +	cc = ptf(PTF_CHECK, &rc)> +	report(cc == 0, "PTF check clear");
> 
> Please leave a \n after a report for readability.
OK

> 
>> +	cc = ptf(PTF_HORIZONTAL, &rc);
>> +	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED,
>> +	       "PTF horizontal already configured");
>> +	cc = ptf(PTF_VERTICAL, &rc);
>> +	report(cc == 2 && rc == PTF_ERR_NO_REASON,
>> +	       "PTF vertical non possible");
> 
> I've yet to look into your KVM/qemu code so I don't really understand
> what you're testing here and why we can expect to get those results.

In KVM please ignore the stupid patch 3 commented by Heiko and that will 
disappear.

It changes nothing to the first two patches.

OK, I will add some comments to explain what we await and why.

> 
> Maybe add a comment?
> Also what will happen if we start this test under LPAR or z/VM, will it
> fail?

The last one may fail, PTF would succeed AFAIU under LPAR.
For z/VM, no idea.


> 
>> +
>> +	report_prefix_pop();
>> +}
>> +
>> +int main(int argc, char *argv[])
>> +{
>> +	report_prefix_push("stsi");
> 
> Where did you copy that test from? :-)

:) yes cut and paste, I will change trhe prefix to "CPU Topology"

> 
>> +
>> +	if (!test_facility(11)) {
>> +		report_skip("Topology facility not present");
>> +		goto end;
>> +	}
>> +
>> +	report_info("Machine level %ld", stsi_get_fc(pagebuf));
>> +
>> +	test_ptf();
>> +end:
> 
> report_prefix_pop is missing here

Right.
will add.

> 
>> +	return report_summary();
>> +}
>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>> index 9e1802fd..0f84d279 100644
>> --- a/s390x/unittests.cfg
>> +++ b/s390x/unittests.cfg
>> @@ -109,3 +109,6 @@ file = edat.elf
>>   
>>   [mvpg-sie]
>>   file = mvpg-sie.elf
>> +
>> +[topology]
>> +file = topology.elf
>>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
