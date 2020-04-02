Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01A2819C4AA
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 16:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388750AbgDBOrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 10:47:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52134 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726927AbgDBOrw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 10:47:52 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 032EYZth030058
        for <kvm@vger.kernel.org>; Thu, 2 Apr 2020 10:47:51 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 301yfhyxsu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 10:47:51 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 2 Apr 2020 15:47:32 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 2 Apr 2020 15:47:30 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 032EljaQ59441374
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Apr 2020 14:47:45 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A41D742041;
        Thu,  2 Apr 2020 14:47:45 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 203814204F;
        Thu,  2 Apr 2020 14:47:45 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.6.23])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Apr 2020 14:47:45 +0000 (GMT)
Subject: Re: [kvm-unit-tests v2] s390x/smp: add minimal test for sigp sense
 running status
To:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <20200402110250.63677-1-borntraeger@de.ibm.com>
 <b1766baa-ca91-b1b4-c9e4-653ae4257cea@linux.ibm.com>
 <7ad39b82-171c-5ffa-a10c-1dd04358f6c2@de.ibm.com>
 <c252805d-a396-bebe-a4c1-77521adf598f@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Thu, 2 Apr 2020 16:47:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <c252805d-a396-bebe-a4c1-77521adf598f@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20040214-0016-0000-0000-000002FCFF19
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040214-0017-0000-0000-00003360C9D7
Message-Id: <c76d018e-9a70-06c0-a1be-aa6c4a76d27a@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-02_05:2020-04-02,2020-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004020128
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02.04.20 15:41, Janosch Frank wrote:
> On 4/2/20 2:29 PM, Christian Borntraeger wrote:
>>
>>
>> On 02.04.20 14:18, Janosch Frank wrote:
>>> On 4/2/20 1:02 PM, Christian Borntraeger wrote:
>>>> make sure that sigp sense running status returns a sane value for
>>>
>>> s/m/M/
>>>
>>>> stopped CPUs. To avoid potential races with the stop being processed we
>>>> wait until sense running status is first 0.
>>>
>>> ENOPARSE "...is first 0?"
>>
>> Yes,  what about "....smp_sense_running_status returns false." ?
> 
> sure, or "returns 0"
> "is first 0" just doesn't parse :)
> 
>>
>>>
>>>>
>>>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>> ---
>>>>  lib/s390x/smp.c |  2 +-
>>>>  lib/s390x/smp.h |  2 +-
>>>>  s390x/smp.c     | 13 +++++++++++++
>>>>  3 files changed, 15 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
>>>> index 5ed8b7b..492cb05 100644
>>>> --- a/lib/s390x/smp.c
>>>> +++ b/lib/s390x/smp.c
>>>> @@ -58,7 +58,7 @@ bool smp_cpu_stopped(uint16_t addr)
>>>>  	return !!(status & (SIGP_STATUS_CHECK_STOP|SIGP_STATUS_STOPPED));
>>>>  }
>>>>  
>>>> -bool smp_cpu_running(uint16_t addr)
>>>> +bool smp_sense_running_status(uint16_t addr)
>>>>  {
>>>>  	if (sigp(addr, SIGP_SENSE_RUNNING, 0, NULL) != SIGP_CC_STATUS_STORED)
>>>>  		return true;
>>>> diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
>>>> index a8b98c0..639ec92 100644
>>>> --- a/lib/s390x/smp.h
>>>> +++ b/lib/s390x/smp.h
>>>> @@ -40,7 +40,7 @@ struct cpu_status {
>>>>  int smp_query_num_cpus(void);
>>>>  struct cpu *smp_cpu_from_addr(uint16_t addr);
>>>>  bool smp_cpu_stopped(uint16_t addr);
>>>> -bool smp_cpu_running(uint16_t addr);
>>>> +bool smp_sense_running_status(uint16_t addr);
>>>
>>> That's completely unrelated to the test
>>
>> Right but this name seems to better reflect what the function does. Because this is not
>> the oppositite of cpu_stopped.
> 
> I'm pondering if we want to split that out.

A single patch for just 2 lines? I dont know.
> 
>>>
>>>>  int smp_cpu_restart(uint16_t addr);
>>>>  int smp_cpu_start(uint16_t addr, struct psw psw);
>>>>  int smp_cpu_stop(uint16_t addr);
>>>> diff --git a/s390x/smp.c b/s390x/smp.c
>>>> index 79cdc1f..b4b1ff2 100644
>>>> --- a/s390x/smp.c
>>>> +++ b/s390x/smp.c
>>>> @@ -210,6 +210,18 @@ static void test_emcall(void)
>>>>  	report_prefix_pop();
>>>>  }
>>>>  
>>>> +static void test_sense_running(void)
>>>> +{
>>>> +	report_prefix_push("sense_running");
>>>> +	/* make sure CPU is stopped */
>>>> +	smp_cpu_stop(1);
>>>> +	/* wait for stop to succeed. */
>>>> +	while(smp_sense_running_status(1));
>>>> +	report(!smp_sense_running_status(1), "CPU1 sense claims not running");
>>>
>>> That's basically true anyway after the loop, no?
>>
>> Yes, but  you get no "positive" message in the more verbose output variants
>> without a report statement.
> 
> report(true, "CPU1 sense claims not running");
> That's also possible, but I leave that up to you.

I do not care, both variants are fine. Whatever you or David prefer. 

