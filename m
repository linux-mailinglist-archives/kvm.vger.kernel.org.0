Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88412F6365
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 15:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbhANOq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 09:46:28 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4970 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726259AbhANOq2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 09:46:28 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EEi3lG083160;
        Thu, 14 Jan 2021 09:45:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=oE51Pj+8KhuMhuuU6Ct3mQ3fx9Amv8F1ucAqfiJVZbs=;
 b=riIa8iNgZKk/dTiMGE33qD1VP5zZUdsLLTb+lA+GG9QCx9L6jwnBTgD7ifi61ULBrqqF
 Dyvwrh9RqLZK1ZQwBHEHZ4pRGrbzvxPq5PTuKPmhhBoNUfnuF81jKyACIEcdxpyoPJgT
 6nX0WDruEx0Xyv+wPrfKf5LHMfanTHrJPTJTO+ApapuFdKvX4GGX5JO0/TzZSRis2WwS
 iBDN6oWeT1v8t2qMUtqnsIofZudXvMoy7Tl8XnZ00izUYhL2p2urTnGAoqT17a1yia5q
 qhh3IKOJAMF2bOjWmSIAAs3dlWzD1Lfkym5FFNzBQcQeo1u+6LiUHm+FUqnka6pWifZc Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362qymg1c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 09:45:47 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10EEjlpA090900;
        Thu, 14 Jan 2021 09:45:47 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362qymg1ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 09:45:47 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EEPNqj021038;
        Thu, 14 Jan 2021 14:45:44 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 35y4483cdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 14:45:44 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EEjf1c30671208
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 14:45:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0EBDAE057;
        Thu, 14 Jan 2021 14:45:41 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57ABBAE053;
        Thu, 14 Jan 2021 14:45:41 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.11.88])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 14:45:41 +0000 (GMT)
Date:   Thu, 14 Jan 2021 14:47:33 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 3/9] s390x: SCLP feature checking
Message-ID: <20210114144733.3ec11445@ibm-vm>
In-Reply-To: <20210112132054.49756-4-frankja@linux.ibm.com>
References: <20210112132054.49756-1-frankja@linux.ibm.com>
        <20210112132054.49756-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_05:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 phishscore=0 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140085
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Jan 2021 08:20:48 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Availability of SIE is announced via a feature bit in a SCLP info CPU
> entry. Let's add a framework that allows us to easily check for such
> facilities.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  lib/s390x/io.c   |  1 +
>  lib/s390x/sclp.c | 25 +++++++++++++++++++++++++
>  lib/s390x/sclp.h | 13 ++++++++++++-
>  3 files changed, 38 insertions(+), 1 deletion(-)
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
> index 12916f5..06819a6 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -25,6 +25,7 @@ static uint64_t max_ram_size;
>  static uint64_t ram_size;
>  char _read_info[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
>  static ReadInfo *read_info;
> +struct sclp_facilities sclp_facilities;
>  
>  char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
>  static volatile bool sclp_busy;
> @@ -128,6 +129,30 @@ CPUEntry *sclp_get_cpu_entries(void)
>  	return (CPUEntry *)(_read_info + read_info->offset_cpu);
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
> +	cpu = sclp_get_cpu_entries();
> +	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
> +		/*
> +		 * The logic for only reading the facilities from the
> +		 * boot cpu comes from the kernel. I haven't yet
> found
> +		 * documentation that explains why this is necessary
> +		 * but I figure there's a reason behind doing it this
> +		 * way.
> +		 */
> +		if (cpu->address == cpu0_addr) {
> +			sclp_facilities.has_sief2 = cpu->feat_sief2;
> +			break;
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

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
