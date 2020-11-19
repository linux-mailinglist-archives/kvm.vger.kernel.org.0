Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783F12B8DF7
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 09:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgKSIwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 03:52:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52928 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbgKSIws (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Nov 2020 03:52:48 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ8YrfY181407;
        Thu, 19 Nov 2020 03:52:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pikt9JVq/zmSD0EwXfNCId2mlgMNNixYGjQoPw1EaAc=;
 b=YVUEL02sMJmSMByueSqhwmnnKPUKhnTo2r8ZYyahaPTlPUv9wbE4hFfOGHKInti94p1G
 1/z+By2tjq5jTFgnLc82mERdy3vWqmzzymDXYtz+/cMDpHn8DXGuCLQBRIvKyFC4vEy3
 zmJgIJcX/p+urAYchOnhBwUTnQ56p9ltlfXuvSI68p1B5uy5hJ6CZQzIYQ+y2VUAMTn4
 +gEEkcQQvkqSIX0HBZy6ACfXGrMnLm0FIQdGG/DbfOLulYxmPIBmRxc1VnEVkjzdlUDw
 ae28ImBf7uUihjtbLVVhm9969AKw4wsog7UaWL+XvjWD0UVCM3fgm6QVcECtnxqR1Kj+ Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34wg5t85fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 03:52:48 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AJ8aalF188843;
        Thu, 19 Nov 2020 03:52:48 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34wg5t85d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 03:52:48 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ8qOb1021436;
        Thu, 19 Nov 2020 08:52:45 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 34t6v8bdjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 08:52:45 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJ8qhJt5636686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 08:52:43 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6BDCAE055;
        Thu, 19 Nov 2020 08:52:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F9F3AE04D;
        Thu, 19 Nov 2020 08:52:42 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.72.189])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 19 Nov 2020 08:52:42 +0000 (GMT)
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com
References: <20201117154215.45855-1-frankja@linux.ibm.com>
 <20201117154215.45855-3-frankja@linux.ibm.com>
 <e1c4a7f0-21a1-1a4e-1f40-f5f2de9d138e@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 2/5] s390x: Consolidate sclp read info
Message-ID: <968879af-3dd2-56f4-def7-fc478b6f882d@linux.ibm.com>
Date:   Thu, 19 Nov 2020 09:52:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <e1c4a7f0-21a1-1a4e-1f40-f5f2de9d138e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_05:2020-11-17,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 mlxscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/19/20 9:41 AM, Thomas Huth wrote:
> On 17/11/2020 16.42, Janosch Frank wrote:
>> Let's only read the information once and pass a pointer to it instead
>> of calling sclp multiple times.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/io.c   |  1 +
>>  lib/s390x/sclp.c | 29 +++++++++++++++++++++++------
>>  lib/s390x/sclp.h |  3 +++
>>  lib/s390x/smp.c  | 23 +++++++++--------------
>>  4 files changed, 36 insertions(+), 20 deletions(-)
>>
>> diff --git a/lib/s390x/io.c b/lib/s390x/io.c
>> index c0f0bf7..e19a1f3 100644
>> --- a/lib/s390x/io.c
>> +++ b/lib/s390x/io.c
>> @@ -36,6 +36,7 @@ void setup(void)
>>  {
>>  	setup_args_progname(ipl_args);
>>  	setup_facilities();
>> +	sclp_read_info();
>>  	sclp_console_setup();
>>  	sclp_memory_setup();
>>  	smp_setup();
>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>> index 4054d0e..ea6324e 100644
>> --- a/lib/s390x/sclp.c
>> +++ b/lib/s390x/sclp.c
>> @@ -25,6 +25,8 @@ extern unsigned long stacktop;
>>  static uint64_t storage_increment_size;
>>  static uint64_t max_ram_size;
>>  static uint64_t ram_size;
>> +char _read_info[PAGE_SIZE] __attribute__((__aligned__(4096)));
>> +static ReadInfo *read_info;
>>  
>>  char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
>>  static volatile bool sclp_busy;
>> @@ -110,6 +112,22 @@ static void sclp_read_scp_info(ReadInfo *ri, int length)
>>  	report_abort("READ_SCP_INFO failed");
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
>> +	return read_info->entries_cpu;
>> +}
> [...]
>>  int smp_query_num_cpus(void)
>>  {
>> -	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
>> -	return info->nr_configured;
>> +	return sclp_get_cpu_num();
>>  }
> 
> You've changed from ->nr_configured to ->entries_cpu ... I assume that's ok?
> Worth to mention the change and rationale in the patch description?

Well, it's not so much a change of struct members than a change of
structs themselves. Looking at our QEMU implementation, both struct
members transport the same data so I don't see a problem there.

> 
>>  struct cpu *smp_cpu_from_addr(uint16_t addr)
>> @@ -245,22 +244,18 @@ extern uint64_t *stackptr;
>>  void smp_setup(void)
>>  {
>>  	int i = 0;
>> +	int num = smp_query_num_cpus();
>>  	unsigned short cpu0_addr = stap();
>> -	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
>> +	struct CPUEntry *entry = sclp_get_cpu_entries();
>>  
>> -	spin_lock(&lock);
>> -	sclp_mark_busy();
>> -	info->h.length = PAGE_SIZE;
>> -	sclp_service_call(SCLP_READ_CPU_INFO, cpu_info_buffer);
>> +	if (num > 1)
>> +		printf("SMP: Initializing, found %d cpus\n", num);
>>  
>> -	if (smp_query_num_cpus() > 1)
>> -		printf("SMP: Initializing, found %d cpus\n", info->nr_configured);
>> -
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
>>
> 
> What about smp_teardown()? It seems to use cpu_info_buffer->nr_configured,
> too, which is now likely not valid anymore?

Good catch, I forgot to remove the whole cpu info buffer.

> 
>  Thomas
> 

