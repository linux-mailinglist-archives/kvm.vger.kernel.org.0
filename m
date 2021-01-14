Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8D02F6361
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 15:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbhANOqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 09:46:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59996 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726236AbhANOqX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 09:46:23 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EEUkFa080653;
        Thu, 14 Jan 2021 09:45:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=6dekjExW0qSfsxB7+e/37WLlNm/A5k0Wv4CSV6NMie4=;
 b=XEy6XvU38ncPj4gLbLra6iX5W5bDWHlYwvFYbkxaY99FdQTJcE0xK3LCZGbbz1kkojSY
 Ha8Y0Le6kz9G+1FWMuy+xFrz3cteBYxzDcK84EoPb9sjViIezb92vo56rTMWtKT5/F52
 ncUGJVbZTOhMDdZHk9KEPMDZ31IptxdFkNl8c6TwZB2I3Z4mVTmsKHit39eVY/s/mPEE
 HQ0DihRa02TmM21+oYE8onTD2WSHL+RbPBM41jJmdeb8KhIQJIYQkQjZBBCC0UV88yZ5
 w6qr0NeRdVMsb6TP5K/58+6Nw6K5b17EKAiYBC554ibnKNav42u1ZKK0ZELXZu82zSir Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362qsmgc4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 09:45:41 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10EEVW6I082716;
        Thu, 14 Jan 2021 09:45:40 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362qsmgc3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 09:45:40 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EEN9GN006549;
        Thu, 14 Jan 2021 14:45:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 35ydrde4j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 14:45:38 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EEjZaX46399750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 14:45:35 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEE33AE045;
        Thu, 14 Jan 2021 14:45:35 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51643AE04D;
        Thu, 14 Jan 2021 14:45:35 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.11.88])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 14:45:35 +0000 (GMT)
Date:   Thu, 14 Jan 2021 14:57:38 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 2/9] s390x: Consolidate sclp read info
Message-ID: <20210114145738.4de9f001@ibm-vm>
In-Reply-To: <20210112132054.49756-3-frankja@linux.ibm.com>
References: <20210112132054.49756-1-frankja@linux.ibm.com>
        <20210112132054.49756-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_04:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 clxscore=1015 spamscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Jan 2021 08:20:47 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's only read the information once and pass a pointer to it instead
> of calling sclp multiple times.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Acked-by: Thomas Huth <thuth@redhat.com>
> ---
>  lib/s390x/io.c   |  1 +
>  lib/s390x/sclp.c | 31 +++++++++++++++++++++++++------
>  lib/s390x/sclp.h |  3 +++
>  lib/s390x/smp.c  | 27 +++++++++++----------------
>  4 files changed, 40 insertions(+), 22 deletions(-)
> 
> diff --git a/lib/s390x/io.c b/lib/s390x/io.c
> index 1ff0589..6a1da63 100644
> --- a/lib/s390x/io.c
> +++ b/lib/s390x/io.c
> @@ -34,6 +34,7 @@ void setup(void)
>  {
>  	setup_args_progname(ipl_args);
>  	setup_facilities();
> +	sclp_read_info();
>  	sclp_console_setup();
>  	sclp_memory_setup();
>  	smp_setup();
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index 08a4813..12916f5 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -23,6 +23,8 @@ extern unsigned long stacktop;
>  static uint64_t storage_increment_size;
>  static uint64_t max_ram_size;
>  static uint64_t ram_size;
> +char _read_info[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
> +static ReadInfo *read_info;
>  
>  char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
>  static volatile bool sclp_busy;
> @@ -108,6 +110,24 @@ static void sclp_read_scp_info(ReadInfo *ri, int
> length) report_abort("READ_SCP_INFO failed");
>  }
>  
> +void sclp_read_info(void)
> +{
> +	sclp_read_scp_info((void *)_read_info, SCCB_SIZE);
> +	read_info = (ReadInfo *)_read_info;
> +}
> +
> +int sclp_get_cpu_num(void)
> +{
> +	assert(read_info);
> +	return read_info->entries_cpu;
> +}
> +
> +CPUEntry *sclp_get_cpu_entries(void)
> +{
> +	assert(read_info);
> +	return (CPUEntry *)(_read_info + read_info->offset_cpu);
> +}
> +
>  /* Perform service call. Return 0 on success, non-zero otherwise. */
>  int sclp_service_call(unsigned int command, void *sccb)
>  {
> @@ -125,23 +145,22 @@ int sclp_service_call(unsigned int command,
> void *sccb) 
>  void sclp_memory_setup(void)
>  {
> -	ReadInfo *ri = (void *)_sccb;
>  	uint64_t rnmax, rnsize;
>  	int cc;
>  
> -	sclp_read_scp_info(ri, SCCB_SIZE);
> +	assert(read_info);
>  
>  	/* calculate the storage increment size */
> -	rnsize = ri->rnsize;
> +	rnsize = read_info->rnsize;
>  	if (!rnsize) {
> -		rnsize = ri->rnsize2;
> +		rnsize = read_info->rnsize2;
>  	}
>  	storage_increment_size = rnsize << 20;
>  
>  	/* calculate the maximum memory size */
> -	rnmax = ri->rnmax;
> +	rnmax = read_info->rnmax;
>  	if (!rnmax) {
> -		rnmax = ri->rnmax2;
> +		rnmax = read_info->rnmax2;
>  	}
>  	max_ram_size = rnmax * storage_increment_size;
>  
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 9a6aad0..acd86d5 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -268,6 +268,9 @@ void sclp_wait_busy(void);
>  void sclp_mark_busy(void);
>  void sclp_console_setup(void);
>  void sclp_print(const char *str);
> +void sclp_read_info(void);
> +int sclp_get_cpu_num(void);
> +CPUEntry *sclp_get_cpu_entries(void);
>  int sclp_service_call(unsigned int command, void *sccb);
>  void sclp_memory_setup(void);
>  uint64_t get_ram_size(void);
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index c4f02dc..dfcfd28 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -23,7 +23,6 @@
>  #include "smp.h"
>  #include "sclp.h"
>  
> -static char cpu_info_buffer[PAGE_SIZE]
> __attribute__((__aligned__(4096))); static struct cpu *cpus;
>  static struct cpu *cpu0;
>  static struct spinlock lock;
> @@ -32,8 +31,7 @@ extern void smp_cpu_setup_state(void);
>  
>  int smp_query_num_cpus(void)
>  {
> -	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
> -	return info->nr_configured;
> +	return sclp_get_cpu_num();
>  }
>  
>  struct cpu *smp_cpu_from_addr(uint16_t addr)
> @@ -226,10 +224,10 @@ void smp_teardown(void)
>  {
>  	int i = 0;
>  	uint16_t this_cpu = stap();
> -	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
> +	int num = smp_query_num_cpus();
>  
>  	spin_lock(&lock);
> -	for (; i < info->nr_configured; i++) {
> +	for (; i < num; i++) {
>  		if (cpus[i].active &&
>  		    cpus[i].addr != this_cpu) {
>  			sigp_retry(cpus[i].addr, SIGP_STOP, 0, NULL);
> @@ -243,22 +241,19 @@ extern uint64_t *stackptr;
>  void smp_setup(void)
>  {
>  	int i = 0;
> +	int num = smp_query_num_cpus();
>  	unsigned short cpu0_addr = stap();
> -	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
> +	struct CPUEntry *entry = sclp_get_cpu_entries();
>  
>  	spin_lock(&lock);
> -	sclp_mark_busy();
> -	info->h.length = PAGE_SIZE;
> -	sclp_service_call(SCLP_READ_CPU_INFO, cpu_info_buffer);
> +	if (num > 1)
> +		printf("SMP: Initializing, found %d cpus\n", num);
>  
> -	if (smp_query_num_cpus() > 1)
> -		printf("SMP: Initializing, found %d cpus\n",
> info->nr_configured); -
> -	cpus = calloc(info->nr_configured, sizeof(cpus));
> -	for (i = 0; i < info->nr_configured; i++) {
> -		cpus[i].addr = info->entries[i].address;
> +	cpus = calloc(num, sizeof(cpus));
> +	for (i = 0; i < num; i++) {
> +		cpus[i].addr = entry[i].address;
>  		cpus[i].active = false;
> -		if (info->entries[i].address == cpu0_addr) {
> +		if (entry[i].address == cpu0_addr) {
>  			cpu0 = &cpus[i];
>  			cpu0->stack = stackptr;
>  			cpu0->lowcore = (void *)0;

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
