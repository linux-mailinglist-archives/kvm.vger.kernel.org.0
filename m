Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8372DD381
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 16:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgLQPAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 10:00:45 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23902 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728143AbgLQPAo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 10:00:44 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BHErp6Z160207;
        Thu, 17 Dec 2020 10:00:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=EHDnpxx5ZCdiy8HQNWDYB5OBW5RM79I03jv+KSax9dQ=;
 b=kWnkgQsuNDI+EBK7QIXT1lpR933YhI45ll4/uvpBbRxUh26hLWywL9VQ6DhHFr8z4zRA
 MFR1Eg9zoqU16lBX+2KNCuKYzcUrNE+CCeVmDq4+GorEptsEPVNKzjs4vXKNbqr5PUCg
 2rIBS48pxto5BOw+jpjxjey3bWbfHTOcL7/MgxH3jCRSw4k+/pL8h6mVXoLL0blzyfM1
 s6S1/dJcf1FUwe7dx91dFMdw+UakzqBRsuB3NKvErAoabGxRh8Z76GPx8OvC3vCaFV93
 NnymA+JV7AKnZztmhe7nEOJWGLYhKKA1afcdsAioUgrL3Tpbeju9Cgw5H7zN27YpiNaU qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35g9gdg42s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 10:00:03 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BHEuCj9165653;
        Thu, 17 Dec 2020 10:00:03 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35g9gdg413-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 10:00:02 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BHEvCGq030877;
        Thu, 17 Dec 2020 15:00:01 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 35cng8g3sw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 15:00:01 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BHEwhxL39387438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 14:58:43 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 405B6A4060;
        Thu, 17 Dec 2020 14:58:43 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4ADEA4054;
        Thu, 17 Dec 2020 14:58:42 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.12.102])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Dec 2020 14:58:42 +0000 (GMT)
Date:   Thu, 17 Dec 2020 15:58:26 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 7/8] s390x: Add diag318 intercept test
Message-ID: <20201217155826.33c7bef1@ibm-vm>
In-Reply-To: <20201211100039.63597-8-frankja@linux.ibm.com>
References: <20201211100039.63597-1-frankja@linux.ibm.com>
        <20201211100039.63597-8-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_09:2020-12-15,2020-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 spamscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Dec 2020 05:00:38 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Not much to test except for the privilege and specification
> exceptions.

This patch looks fine. But I wonder what is it doing in this series?
The series is about SIE testing, and this seems to be an unrelated
improvement in an existing testcase?

anyway, looks good to me

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  lib/s390x/sclp.c  |  2 ++
>  lib/s390x/sclp.h  |  6 +++++-
>  s390x/intercept.c | 19 +++++++++++++++++++
>  3 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index cf6ea7c..0001993 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -138,6 +138,8 @@ void sclp_facilities_setup(void)
>  
>  	assert(read_info);
>  
> +	sclp_facilities.has_diag318 = read_info->byte_134_diag318;
> +
>  	cpu = (void *)read_info + read_info->offset_cpu;
>  	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
>  		if (cpu->address == cpu0_addr) {
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 6c86037..58f8e54 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -105,7 +105,8 @@ extern struct sclp_facilities sclp_facilities;
>  
>  struct sclp_facilities {
>  	uint64_t has_sief2 : 1;
> -	uint64_t : 63;
> +	uint64_t has_diag318 : 1;
> +	uint64_t : 62;
>  };
>  
>  typedef struct ReadInfo {
> @@ -130,6 +131,9 @@ typedef struct ReadInfo {
>      uint16_t highest_cpu;
>      uint8_t  _reserved5[124 - 122];     /* 122-123 */
>      uint32_t hmfai;
> +    uint8_t reserved7[134 - 128];
> +    uint8_t byte_134_diag318 : 1;
> +    uint8_t : 7;
>      struct CPUEntry entries[0];
>  } __attribute__((packed)) ReadInfo;
>  
> diff --git a/s390x/intercept.c b/s390x/intercept.c
> index cde2f5f..86e57e1 100644
> --- a/s390x/intercept.c
> +++ b/s390x/intercept.c
> @@ -8,6 +8,7 @@
>   *  Thomas Huth <thuth@redhat.com>
>   */
>  #include <libcflat.h>
> +#include <sclp.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/interrupt.h>
>  #include <asm/page.h>
> @@ -152,6 +153,23 @@ static void test_testblock(void)
>  	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
>  }
>  
> +static void test_diag318(void)
> +{
> +	expect_pgm_int();
> +	enter_pstate();
> +	asm volatile("diag %0,0,0x318\n" : : "d" (0x42));
> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +
> +	if (!sclp_facilities.has_diag318)
> +		expect_pgm_int();
> +
> +	asm volatile("diag %0,0,0x318\n" : : "d" (0x42));
> +
> +	if (!sclp_facilities.has_diag318)
> +		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +
> +}
> +
>  struct {
>  	const char *name;
>  	void (*func)(void);
> @@ -162,6 +180,7 @@ struct {
>  	{ "stap", test_stap, false },
>  	{ "stidp", test_stidp, false },
>  	{ "testblock", test_testblock, false },
> +	{ "diag318", test_diag318, false },
>  	{ NULL, NULL, false }
>  };
>  

