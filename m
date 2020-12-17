Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE922DD409
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 16:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgLQPV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 10:21:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12380 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727303AbgLQPV5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 10:21:57 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BHF3wfN155121;
        Thu, 17 Dec 2020 10:21:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QtbAqu+6+qfQrzkcKzEmjj4L3cuesCVMLvH1Asg238A=;
 b=pyQ7ddWKBLGK6WtdJIYvPn0xRBy3UI6cON3hJ1oQinDYfqpBykdHssZLsIOiVjZOTb1l
 fY/KePYysQuJgnO/GeqAGUqBJfHf5hzODTr0efF2CGzmjhlyQ2NtWSF3zt9/+W1lLijq
 qwdZFRdrDAVOkkhk96fmGXumUr2P20W5ORS1emOdhMXNvtODUxGkqaY7QIvrw6Xx9p5s
 bTp35LASYfYBzM6VcJjmLliej57nUCG8nQmAQPfFYQnMv0JuWr2aziNSzHagZel3C9Qs
 Y0L5fM/HN5JlOmZRm+xTUIBaJs5CWcnymwfCx9Wbd1ddYMYsL95WuDn0h1GtpO1Y9jwj cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35g8prah8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 10:21:16 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BHF6mJC178761;
        Thu, 17 Dec 2020 10:21:16 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35g8prah6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 10:21:16 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BHF7Sbd015438;
        Thu, 17 Dec 2020 15:21:13 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 35cng85g64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 15:21:13 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BHFLApE23855396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 15:21:10 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68C1042041;
        Thu, 17 Dec 2020 15:21:10 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E87CA42047;
        Thu, 17 Dec 2020 15:21:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.181.71])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Dec 2020 15:21:09 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 3/8] s390x: SCLP feature checking
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20201211100039.63597-1-frankja@linux.ibm.com>
 <20201211100039.63597-4-frankja@linux.ibm.com>
 <20201217131837.5946c853@ibm-vm>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <14a2d6ab-7f9b-86cd-26ca-0c83385f62ca@linux.ibm.com>
Date:   Thu, 17 Dec 2020 16:21:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201217131837.5946c853@ibm-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_09:2020-12-15,2020-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 impostorscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/20 1:18 PM, Claudio Imbrenda wrote:
> On Fri, 11 Dec 2020 05:00:34 -0500
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Availability of SIE is announced via a feature bit in a SCLP info CPU
>> entry. Let's add a framework that allows us to easily check for such
>> facilities.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> ---
>>  lib/s390x/io.c   |  1 +
>>  lib/s390x/sclp.c | 19 +++++++++++++++++++
>>  lib/s390x/sclp.h | 13 ++++++++++++-
>>  3 files changed, 32 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/s390x/io.c b/lib/s390x/io.c
>> index 6a1da63..ef9f59e 100644
>> --- a/lib/s390x/io.c
>> +++ b/lib/s390x/io.c
>> @@ -35,6 +35,7 @@ void setup(void)
>>  	setup_args_progname(ipl_args);
>>  	setup_facilities();
>>  	sclp_read_info();
>> +	sclp_facilities_setup();
>>  	sclp_console_setup();
>>  	sclp_memory_setup();
>>  	smp_setup();
>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>> index bf1d9c0..cf6ea7c 100644
>> --- a/lib/s390x/sclp.c
>> +++ b/lib/s390x/sclp.c
>> @@ -9,6 +9,7 @@
>>   */
>>  
>>  #include <libcflat.h>
>> +#include <bitops.h>
> 
> you add this include, but it seems you are not actually using it?

Leftover from last version

> 
>>  #include <asm/page.h>
>>  #include <asm/arch_def.h>
>>  #include <asm/interrupt.h>
>> @@ -25,6 +26,7 @@ static uint64_t max_ram_size;
>>  static uint64_t ram_size;
>>  char _read_info[PAGE_SIZE] __attribute__((__aligned__(4096)));
>>  static ReadInfo *read_info;
>> +struct sclp_facilities sclp_facilities;
>>  
>>  char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
>>  static volatile bool sclp_busy;
>> @@ -128,6 +130,23 @@ CPUEntry *sclp_get_cpu_entries(void)
>>  	return (void *)read_info + read_info->offset_cpu;
>>  }
>>  
>> +void sclp_facilities_setup(void)
>> +{
>> +	unsigned short cpu0_addr = stap();
>> +	CPUEntry *cpu;
>> +	int i;
>> +
>> +	assert(read_info);
>> +
>> +	cpu = (void *)read_info + read_info->offset_cpu;
> 
> another void* arithmetic. consider using well-defined constructs, like
> 
> cpu = (CPUEntry *)(_read_info + read_info->offset_cpu);
> 
>> +	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
>> +		if (cpu->address == cpu0_addr) {
>> +			sclp_facilities.has_sief2 = cpu->feat_sief2;
>> +			break;
> 
> this only checks CPU 0. I wonder if you shouldn't check all CPUs? Or if
> we assume that all CPUs have the same facilities, isn't it enough to
> check the first CPU in the list? (i.e. avoid the loop)

This is the way.

Thomas already asked me that. I had a look what the kernel does and
that's what they are doing. QEMU writes the same feature bits to all
cpus and I haven't found an explanation for that code yet but I figured
there might (have) be(en) one.

> 
>> +		}
>> +	}
>> +}
>> +
>>  /* Perform service call. Return 0 on success, non-zero otherwise. */
>>  int sclp_service_call(unsigned int command, void *sccb)
>>  {
>> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
>> index acd86d5..6c86037 100644
>> --- a/lib/s390x/sclp.h
>> +++ b/lib/s390x/sclp.h
>> @@ -92,12 +92,22 @@ typedef struct SCCBHeader {
>>  typedef struct CPUEntry {
>>      uint8_t address;
>>      uint8_t reserved0;
>> -    uint8_t features[SCCB_CPU_FEATURE_LEN];
>> +    uint8_t : 4;
>> +    uint8_t feat_sief2 : 1;
>> +    uint8_t : 3;
>> +    uint8_t features_res2 [SCCB_CPU_FEATURE_LEN - 1];
>>      uint8_t reserved2[6];
>>      uint8_t type;
>>      uint8_t reserved1;
>>  } __attribute__((packed)) CPUEntry;
>>  
>> +extern struct sclp_facilities sclp_facilities;
>> +
>> +struct sclp_facilities {
>> +	uint64_t has_sief2 : 1;
>> +	uint64_t : 63;
>> +};
>> +
>>  typedef struct ReadInfo {
>>      SCCBHeader h;
>>      uint16_t rnmax;
>> @@ -271,6 +281,7 @@ void sclp_print(const char *str);
>>  void sclp_read_info(void);
>>  int sclp_get_cpu_num(void);
>>  CPUEntry *sclp_get_cpu_entries(void);
>> +void sclp_facilities_setup(void);
>>  int sclp_service_call(unsigned int command, void *sccb);
>>  void sclp_memory_setup(void);
>>  uint64_t get_ram_size(void);
> 

