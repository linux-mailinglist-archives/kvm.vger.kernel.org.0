Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3193B2DD343
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 15:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbgLQOuz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 09:50:55 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3366 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726488AbgLQOuz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 09:50:55 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BHEZ1Uc147752;
        Thu, 17 Dec 2020 09:50:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=09FCTrCT4NEtecZZpzJTOowP9D0oWQi0JSzKXFxhU6o=;
 b=id9IWrpTWPc/QzDCK5DMfX6c3UElRzJEJiCfxsVomLiX2aC8C2ttWmv8s763Oyw3d3YB
 dnVJF1QXmvnoT/iMSXsU9nXYYN2Osi+nIZIypzDZSyK9d2wiOBA3cK8JhnHLAzCMxoLe
 B4AMKkQLbdSha+6DfLYKBjyV5lS5n5+iPkGm2LjTtmXQI+1RvXZ8q2Ou7O9vTrnUqk6G
 88Aw/Ws/tF3+kkD1iACquFq8F3HulLluToXGUibDEmnc/4MvOmk7te1JdITyA7Xvr+3Z
 I90njCpoHwEmG4+LdXhiwHBUs/oHEKMQpVXUDPcC1HgDi6Jo5W1fNcgaphgXO9fDGFkn eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35g8x8rx0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 09:50:13 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BHEZ5J6147914;
        Thu, 17 Dec 2020 09:50:13 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35g8x8rwya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 09:50:13 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BHElAQp023572;
        Thu, 17 Dec 2020 14:50:10 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 35cng8g3a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 14:50:10 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BHEmqCV35520956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 14:48:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9179BA405C;
        Thu, 17 Dec 2020 14:48:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B3E4A4054;
        Thu, 17 Dec 2020 14:48:52 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.181.71])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Dec 2020 14:48:52 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20201211100039.63597-1-frankja@linux.ibm.com>
 <20201211100039.63597-3-frankja@linux.ibm.com>
 <20201217124722.0686a76d@ibm-vm>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/8] s390x: Consolidate sclp read info
Message-ID: <36133ccd-3dc2-bc9a-9c83-376a31e98454@linux.ibm.com>
Date:   Thu, 17 Dec 2020 15:48:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201217124722.0686a76d@ibm-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_09:2020-12-15,2020-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501 spamscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/20 12:47 PM, Claudio Imbrenda wrote:
> On Fri, 11 Dec 2020 05:00:33 -0500
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Let's only read the information once and pass a pointer to it instead
>> of calling sclp multiple times.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  lib/s390x/io.c   |  1 +
>>  lib/s390x/sclp.c | 31 +++++++++++++++++++++++++------
>>  lib/s390x/sclp.h |  3 +++
>>  lib/s390x/smp.c  | 27 +++++++++++----------------
>>  4 files changed, 40 insertions(+), 22 deletions(-)
>>
>> diff --git a/lib/s390x/io.c b/lib/s390x/io.c
>> index 1ff0589..6a1da63 100644
>> --- a/lib/s390x/io.c
>> +++ b/lib/s390x/io.c
>> @@ -34,6 +34,7 @@ void setup(void)
>>  {
>>  	setup_args_progname(ipl_args);
>>  	setup_facilities();
>> +	sclp_read_info();
>>  	sclp_console_setup();
>>  	sclp_memory_setup();
>>  	smp_setup();
>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>> index 08a4813..bf1d9c0 100644
>> --- a/lib/s390x/sclp.c
>> +++ b/lib/s390x/sclp.c
>> @@ -23,6 +23,8 @@ extern unsigned long stacktop;
>>  static uint64_t storage_increment_size;
>>  static uint64_t max_ram_size;
>>  static uint64_t ram_size;
>> +char _read_info[PAGE_SIZE] __attribute__((__aligned__(4096)));
> 
> why not __aligned__((PAGE_SIZE)) ?

Because aligned is not defined as a compiler attribute in the lib AFAIK.
I can of course use PAGE_SIZE though.

> 
>> +static ReadInfo *read_info;
> 
> I wonder if a union would be cleaner? although later on you check if
> the pointer is NULL to see if the information is there, so I guess it
> can stay

I'm rather wondering if we want to replace that with an allocation,
these PAGE_SIZE arrays are just looking strange.

Let me put that on my TODO list for next year...

> 
>>  
>>  char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
>>  static volatile bool sclp_busy;
>> @@ -108,6 +110,24 @@ static void sclp_read_scp_info(ReadInfo *ri, int
>> length) report_abort("READ_SCP_INFO failed");
>>  }
>>  
>> +void sclp_read_info(void)
>> +{
>> +	sclp_read_scp_info((void *)_read_info, SCCB_SIZE);
>> +	read_info = (ReadInfo *)_read_info;
>> +}
>> +
>> +int sclp_get_cpu_num(void)
>> +{
>> +	assert(read_info);
>> +	return read_info->entries_cpu;
>> +}
>> +
>> +CPUEntry *sclp_get_cpu_entries(void)
>> +{
>> +	assert(read_info);
>> +	return (void *)read_info + read_info->offset_cpu;
> 
> are you doing arithmetic on a void pointer? please don't, it's ugly and
> against the specs. moreover you do have a char pointer...
> 
> why not:
> return (CPUEntry *)(_read_info + read_info->offset_cpu);

I seem to be one of those crazy persons who actually like void pointers.
Your suggestion looks good too, I'll replace my code with it.

> 
>> +}
>> +
>>  /* Perform service call. Return 0 on success, non-zero otherwise. */
>>  int sclp_service_call(unsigned int command, void *sccb)
>>  {
>> @@ -125,23 +145,22 @@ int sclp_service_call(unsigned int command,
>> void *sccb) 
>>  void sclp_memory_setup(void)
>>  {
>> -	ReadInfo *ri = (void *)_sccb;
>>  	uint64_t rnmax, rnsize;
>>  	int cc;
>>  
>> -	sclp_read_scp_info(ri, SCCB_SIZE);
>> +	assert(read_info);
>>  
>>  	/* calculate the storage increment size */
>> -	rnsize = ri->rnsize;
>> +	rnsize = read_info->rnsize;
>>  	if (!rnsize) {
>> -		rnsize = ri->rnsize2;
>> +		rnsize = read_info->rnsize2;
>>  	}
>>  	storage_increment_size = rnsize << 20;
>>  
>>  	/* calculate the maximum memory size */
>> -	rnmax = ri->rnmax;
>> +	rnmax = read_info->rnmax;
>>  	if (!rnmax) {
>> -		rnmax = ri->rnmax2;
>> +		rnmax = read_info->rnmax2;
>>  	}
>>  	max_ram_size = rnmax * storage_increment_size;
>>  
>> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
>> index 9a6aad0..acd86d5 100644
>> --- a/lib/s390x/sclp.h
>> +++ b/lib/s390x/sclp.h
>> @@ -268,6 +268,9 @@ void sclp_wait_busy(void);
>>  void sclp_mark_busy(void);
>>  void sclp_console_setup(void);
>>  void sclp_print(const char *str);
>> +void sclp_read_info(void);
>> +int sclp_get_cpu_num(void);
>> +CPUEntry *sclp_get_cpu_entries(void);
>>  int sclp_service_call(unsigned int command, void *sccb);
>>  void sclp_memory_setup(void);
>>  uint64_t get_ram_size(void);
>> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
>> index c4f02dc..dfcfd28 100644
>> --- a/lib/s390x/smp.c
>> +++ b/lib/s390x/smp.c
>> @@ -23,7 +23,6 @@
>>  #include "smp.h"
>>  #include "sclp.h"
>>  
>> -static char cpu_info_buffer[PAGE_SIZE]
>> __attribute__((__aligned__(4096))); static struct cpu *cpus;
>>  static struct cpu *cpu0;
>>  static struct spinlock lock;
>> @@ -32,8 +31,7 @@ extern void smp_cpu_setup_state(void);
>>  
>>  int smp_query_num_cpus(void)
>>  {
>> -	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
>> -	return info->nr_configured;
>> +	return sclp_get_cpu_num();
>>  }
>>  
>>  struct cpu *smp_cpu_from_addr(uint16_t addr)
>> @@ -226,10 +224,10 @@ void smp_teardown(void)
>>  {
>>  	int i = 0;
>>  	uint16_t this_cpu = stap();
>> -	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
>> +	int num = smp_query_num_cpus();
>>  
>>  	spin_lock(&lock);
>> -	for (; i < info->nr_configured; i++) {
>> +	for (; i < num; i++) {
>>  		if (cpus[i].active &&
>>  		    cpus[i].addr != this_cpu) {
>>  			sigp_retry(cpus[i].addr, SIGP_STOP, 0, NULL);
>> @@ -243,22 +241,19 @@ extern uint64_t *stackptr;
>>  void smp_setup(void)
>>  {
>>  	int i = 0;
>> +	int num = smp_query_num_cpus();
>>  	unsigned short cpu0_addr = stap();
>> -	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
>> +	struct CPUEntry *entry = sclp_get_cpu_entries();
>>  
>>  	spin_lock(&lock);
>> -	sclp_mark_busy();
>> -	info->h.length = PAGE_SIZE;
>> -	sclp_service_call(SCLP_READ_CPU_INFO, cpu_info_buffer);
>> +	if (num > 1)
>> +		printf("SMP: Initializing, found %d cpus\n", num);
>>  
>> -	if (smp_query_num_cpus() > 1)
>> -		printf("SMP: Initializing, found %d cpus\n",
>> info->nr_configured); -
>> -	cpus = calloc(info->nr_configured, sizeof(cpus));
>> -	for (i = 0; i < info->nr_configured; i++) {
>> -		cpus[i].addr = info->entries[i].address;
>> +	cpus = calloc(num, sizeof(cpus));
>> +	for (i = 0; i < num; i++) {
>> +		cpus[i].addr = entry[i].address;
>>  		cpus[i].active = false;
>> -		if (info->entries[i].address == cpu0_addr) {
>> +		if (entry[i].address == cpu0_addr) {
>>  			cpu0 = &cpus[i];
>>  			cpu0->stack = stackptr;
>>  			cpu0->lowcore = (void *)0;
> 

