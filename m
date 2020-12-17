Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDFD2DD370
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 15:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgLQO70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 09:59:26 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60320 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728154AbgLQO7Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 09:59:25 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BHEWfSc061203;
        Thu, 17 Dec 2020 09:58:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=hMVqXsMbV72gTCLKlkgVQqze+XWyrCCihhAwm0uQ/0U=;
 b=mZKQfkaL2BriAB47ee2YeWWErVM5s+EAVp6J9EjxF009z+xZRCpUKaJG9qaqCPWV0q+p
 nLYMHFlDJqYelOvf0xF9kZp5pOWKjXKhJhlonUjUTFayu3Wmxy6kHY+erNCPkc8r4sB+
 wogQg0E37V+6iSmxMo56Wn1m+5HXUeoR9NGhMJVJCfvKThTXk5Xlk7eog0c9DLv/TjxA
 IxfzOaxdPDRqL0FFNOHCTp1ozpIM1tS28BQ5QQv1bWvbjeJQMwNmDgn9sP1r6WADafgt
 POLQzg3wl6d0hQBcBgz6ZSwzennGd8X4clgR8kwxcdCwkDgvzgIeASGooEjCBNIJTUcB Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35g841u22a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 09:58:45 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BHEWpl2062040;
        Thu, 17 Dec 2020 09:58:44 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35g841u21c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 09:58:44 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BHEwNJh002263;
        Thu, 17 Dec 2020 14:58:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 35d310ajms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 14:58:42 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BHEwdkE37683638
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 14:58:39 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11F94A405C;
        Thu, 17 Dec 2020 14:58:39 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC6A0A405F;
        Thu, 17 Dec 2020 14:58:38 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.12.102])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Dec 2020 14:58:38 +0000 (GMT)
Date:   Thu, 17 Dec 2020 13:18:37 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 3/8] s390x: SCLP feature checking
Message-ID: <20201217131837.5946c853@ibm-vm>
In-Reply-To: <20201211100039.63597-4-frankja@linux.ibm.com>
References: <20201211100039.63597-1-frankja@linux.ibm.com>
        <20201211100039.63597-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_09:2020-12-15,2020-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Dec 2020 05:00:34 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Availability of SIE is announced via a feature bit in a SCLP info CPU
> entry. Let's add a framework that allows us to easily check for such
> facilities.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  lib/s390x/io.c   |  1 +
>  lib/s390x/sclp.c | 19 +++++++++++++++++++
>  lib/s390x/sclp.h | 13 ++++++++++++-
>  3 files changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/io.c b/lib/s390x/io.c
> index 6a1da63..ef9f59e 100644
> --- a/lib/s390x/io.c
> +++ b/lib/s390x/io.c
> @@ -35,6 +35,7 @@ void setup(void)
>  	setup_args_progname(ipl_args);
>  	setup_facilities();
>  	sclp_read_info();
> +	sclp_facilities_setup();
>  	sclp_console_setup();
>  	sclp_memory_setup();
>  	smp_setup();
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index bf1d9c0..cf6ea7c 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -9,6 +9,7 @@
>   */
>  
>  #include <libcflat.h>
> +#include <bitops.h>

you add this include, but it seems you are not actually using it?

>  #include <asm/page.h>
>  #include <asm/arch_def.h>
>  #include <asm/interrupt.h>
> @@ -25,6 +26,7 @@ static uint64_t max_ram_size;
>  static uint64_t ram_size;
>  char _read_info[PAGE_SIZE] __attribute__((__aligned__(4096)));
>  static ReadInfo *read_info;
> +struct sclp_facilities sclp_facilities;
>  
>  char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
>  static volatile bool sclp_busy;
> @@ -128,6 +130,23 @@ CPUEntry *sclp_get_cpu_entries(void)
>  	return (void *)read_info + read_info->offset_cpu;
>  }
>  
> +void sclp_facilities_setup(void)
> +{
> +	unsigned short cpu0_addr = stap();
> +	CPUEntry *cpu;
> +	int i;
> +
> +	assert(read_info);
> +
> +	cpu = (void *)read_info + read_info->offset_cpu;

another void* arithmetic. consider using well-defined constructs, like

cpu = (CPUEntry *)(_read_info + read_info->offset_cpu);

> +	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
> +		if (cpu->address == cpu0_addr) {
> +			sclp_facilities.has_sief2 = cpu->feat_sief2;
> +			break;

this only checks CPU 0. I wonder if you shouldn't check all CPUs? Or if
we assume that all CPUs have the same facilities, isn't it enough to
check the first CPU in the list? (i.e. avoid the loop)

> +		}
> +	}
> +}
> +
>  /* Perform service call. Return 0 on success, non-zero otherwise. */
>  int sclp_service_call(unsigned int command, void *sccb)
>  {
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index acd86d5..6c86037 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -92,12 +92,22 @@ typedef struct SCCBHeader {
>  typedef struct CPUEntry {
>      uint8_t address;
>      uint8_t reserved0;
> -    uint8_t features[SCCB_CPU_FEATURE_LEN];
> +    uint8_t : 4;
> +    uint8_t feat_sief2 : 1;
> +    uint8_t : 3;
> +    uint8_t features_res2 [SCCB_CPU_FEATURE_LEN - 1];
>      uint8_t reserved2[6];
>      uint8_t type;
>      uint8_t reserved1;
>  } __attribute__((packed)) CPUEntry;
>  
> +extern struct sclp_facilities sclp_facilities;
> +
> +struct sclp_facilities {
> +	uint64_t has_sief2 : 1;
> +	uint64_t : 63;
> +};
> +
>  typedef struct ReadInfo {
>      SCCBHeader h;
>      uint16_t rnmax;
> @@ -271,6 +281,7 @@ void sclp_print(const char *str);
>  void sclp_read_info(void);
>  int sclp_get_cpu_num(void);
>  CPUEntry *sclp_get_cpu_entries(void);
> +void sclp_facilities_setup(void);
>  int sclp_service_call(unsigned int command, void *sccb);
>  void sclp_memory_setup(void);
>  uint64_t get_ram_size(void);

