Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D8B2F6363
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 15:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbhANOqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 09:46:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24672 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726259AbhANOqZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 09:46:25 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EEUmm4080749;
        Thu, 14 Jan 2021 09:45:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=bI9zEC/sNpkMifgPA+dpVL+YmmV9uHf6XFVl02HyY4E=;
 b=jsjeiBDp1x/R4ZMM21HQcgnSoJSPKbR2EF80igR2tve0dW8Qe4aEqtvTn0pSrA9unobr
 NFut6Hm/5eCIiMIm2zuoO1krWSD/vuL6xeVyLQVBXXbDe5cTh9BnyDHcj8GXasMrai+a
 dc0RwiO+b8Dgrism5HFFMzry2M8x8fa5MB0fOBF4G389UKApB4cBuz9HeRgmA1l3IAM6
 8wTNND0jLTh5EFh6WIb7LLABxYna8ENbL8LY9gVj5l+ojKTSd9Wx3nmH40YmyQskU4zI
 73Nug3+R/1wQqoqZmVOutJ990sKdX8gBoK2YjPD2VIHuE2rVDFKqKYSV1ShPmd9tVMie tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362qsmgc5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 09:45:43 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10EEVMOc081923;
        Thu, 14 Jan 2021 09:45:43 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362qsmgc50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 09:45:43 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EEMXMS004526;
        Thu, 14 Jan 2021 14:45:41 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 35y448ehuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 14:45:41 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EEjcOk35848648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 14:45:38 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7523AE051;
        Thu, 14 Jan 2021 14:45:38 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B73BAE04D;
        Thu, 14 Jan 2021 14:45:38 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.11.88])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 14:45:38 +0000 (GMT)
Date:   Thu, 14 Jan 2021 14:55:19 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 1/9] s390x: Add test_bit to library
Message-ID: <20210114145519.32a509c0@ibm-vm>
In-Reply-To: <20210112132054.49756-2-frankja@linux.ibm.com>
References: <20210112132054.49756-1-frankja@linux.ibm.com>
        <20210112132054.49756-2-frankja@linux.ibm.com>
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

On Tue, 12 Jan 2021 08:20:46 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Query/feature bits are commonly tested via MSB bit numbers on
> s390. Let's add test bit functions, so we don't need to copy code to
> test query bits.
> 
> The test_bit code has been taken from the kernel since most s390x KVM
> unit test developers are used to them.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  lib/s390x/asm/bitops.h   | 26 ++++++++++++++++++++++++++
>  lib/s390x/asm/facility.h |  3 ++-
>  s390x/uv-guest.c         |  6 +++---
>  3 files changed, 31 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/s390x/asm/bitops.h b/lib/s390x/asm/bitops.h
> index e7cdda9..792881e 100644
> --- a/lib/s390x/asm/bitops.h
> +++ b/lib/s390x/asm/bitops.h
> @@ -1,3 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + *    Bitops taken from the kernel as most developers are already
> used
> + *    to them.
> + *
> + *    Copyright IBM Corp. 1999,2013
> + *
> + *    Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>,
> + *
> + */
>  #ifndef _ASMS390X_BITOPS_H_
>  #define _ASMS390X_BITOPS_H_
>  
> @@ -7,4 +17,20 @@
>  
>  #define BITS_PER_LONG	64
>  
> +static inline bool test_bit(unsigned long nr,
> +			    const volatile unsigned long *ptr)
> +{
> +	const volatile unsigned char *addr;
> +
> +	addr = ((const volatile unsigned char *)ptr);
> +	addr += (nr ^ (BITS_PER_LONG - 8)) >> 3;
> +	return (*addr >> (nr & 7)) & 1;
> +}
> +
> +static inline bool test_bit_inv(unsigned long nr,
> +				const volatile unsigned long *ptr)
> +{
> +	return test_bit(nr ^ (BITS_PER_LONG - 1), ptr);
> +}
> +
>  #endif
> diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
> index 7828cf8..95d4a15 100644
> --- a/lib/s390x/asm/facility.h
> +++ b/lib/s390x/asm/facility.h
> @@ -11,13 +11,14 @@
>  #include <libcflat.h>
>  #include <asm/facility.h>
>  #include <asm/arch_def.h>
> +#include <bitops.h>
>  
>  #define NB_STFL_DOUBLEWORDS 32
>  extern uint64_t stfl_doublewords[];
>  
>  static inline bool test_facility(int nr)
>  {
> -	return stfl_doublewords[nr / 64] & (0x8000000000000000UL >>
> (nr % 64));
> +	return test_bit_inv(nr, stfl_doublewords);
>  }
>  
>  static inline void stfl(void)
> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> index bc947ab..e51b85e 100644
> --- a/s390x/uv-guest.c
> +++ b/s390x/uv-guest.c
> @@ -75,11 +75,11 @@ static void test_query(void)
>  	 * Ultravisor version and are expected to always be available
>  	 * because they are basic building blocks.
>  	 */
> -	report(uvcb.inst_calls_list[0] & (1UL << (63 -
> BIT_UVC_CMD_QUI)),
> +	report(test_bit_inv(BIT_UVC_CMD_QUI,
> &uvcb.inst_calls_list[0]), "query indicated");
> -	report(uvcb.inst_calls_list[0] & (1UL << (63 -
> BIT_UVC_CMD_SET_SHARED_ACCESS)),
> +	report(test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS,
> &uvcb.inst_calls_list[0]), "share indicated");
> -	report(uvcb.inst_calls_list[0] & (1UL << (63 -
> BIT_UVC_CMD_REMOVE_SHARED_ACCESS)),
> +	report(test_bit_inv(BIT_UVC_CMD_REMOVE_SHARED_ACCESS,
> &uvcb.inst_calls_list[0]), "unshare indicated");
>  	report_prefix_pop();
>  }

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
