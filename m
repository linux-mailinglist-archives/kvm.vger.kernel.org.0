Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0CD3F2B86
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 13:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239377AbhHTLuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 07:50:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54340 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237633AbhHTLuQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Aug 2021 07:50:16 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17KBWgbo118461;
        Fri, 20 Aug 2021 07:49:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=hd2wkh16W6Rfdc0G5ODoTbKh6aOXi/CSmLbFq20Hz/M=;
 b=htSzcOCu94TrMMcwGcc+6uZP2Y8Z1yrSIrbNib475UgkII5H6YECBwZE02KCrz82F+3E
 tnTpgP1J5xlX2cMiziHFSyFvNvmbdrsEhytKF5INeAfPpaC4gqh3Y3/IMqGVuXwbmCIC
 K0JI6HaNbskN1/KYYkKvmmOx/LDeFYpGdhL/QfER5plgfo7O8myjJ6ZN8P7QgGg7TrEq
 O8mp3Q/cCmXmjEk/Zm2oPHU2vn65H6K4BhbqUpBy8/jFsafoSqQPM1VSrCqm2grutYXR
 LIFRUo5Siq6v7Y5UymT92wG8hQ5fY6XeH+2rtVR80fRJJ2JBjwhvRDW/CHgYoUBKhlvj Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aj6smfy9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 07:49:39 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17KBWgTL118462;
        Fri, 20 Aug 2021 07:49:38 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aj6smfy99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 07:49:38 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17KBgr4B028948;
        Fri, 20 Aug 2021 11:49:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3ae5f8gerv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 11:49:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17KBk2RT60883282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Aug 2021 11:46:02 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE283AE058;
        Fri, 20 Aug 2021 11:49:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CD20AE057;
        Fri, 20 Aug 2021 11:49:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.193])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Aug 2021 11:49:33 +0000 (GMT)
Date:   Fri, 20 Aug 2021 13:48:25 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/3] lib: s390x: Print addressing
 related exception information
Message-ID: <20210820134825.5b0c5063@p-imbrenda>
In-Reply-To: <20210820114000.166527-2-frankja@linux.ibm.com>
References: <20210820114000.166527-1-frankja@linux.ibm.com>
        <20210820114000.166527-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FY2fBWFIO2smQI7PuO9rIWL4MrGv3q3U
X-Proofpoint-ORIG-GUID: gpC4kfb_rZOfvZBYRSeaQ8CuXx68ExUE
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-20_03:2021-08-20,2021-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 phishscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108200062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Aug 2021 11:39:58 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Right now we only get told the kind of program exception as well as
> the PSW at the point where it happened.
> 
> For addressing exceptions the PSW is not always enough so let's print
> the TEID which contains the failing address and flags that tell us
> more about the kind of address exception.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

(but see a small nit below)

> ---
>  lib/s390x/asm/arch_def.h |  5 +++
>  lib/s390x/fault.c        | 76 ++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/fault.h        | 44 +++++++++++++++++++++++
>  lib/s390x/interrupt.c    | 29 +++++++++++++--
>  s390x/Makefile           |  1 +
>  5 files changed, 153 insertions(+), 2 deletions(-)
>  create mode 100644 lib/s390x/fault.c
>  create mode 100644 lib/s390x/fault.h
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 302ef1ff..ab5a9043 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -41,6 +41,11 @@ struct psw {
>  	uint64_t	addr;
>  };
>  
> +#define AS_PRIM				0
> +#define AS_ACCR				1
> +#define AS_SECN				2
> +#define AS_HOME				3
> +
>  #define PSW_MASK_EXT			0x0100000000000000UL
>  #define PSW_MASK_IO			0x0200000000000000UL
>  #define PSW_MASK_DAT			0x0400000000000000UL
> diff --git a/lib/s390x/fault.c b/lib/s390x/fault.c
> new file mode 100644
> index 00000000..fd1490e3
> --- /dev/null
> +++ b/lib/s390x/fault.c
> @@ -0,0 +1,76 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Library to decode addressing related exceptions
> + *
> + * Copyright 2021 IBM Corp.
> + *
> + * Authors:
> + *    Janosch Frank <frankja@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +#include <bitops.h>
> +#include <asm/arch_def.h>
> +#include <asm/page.h>
> +#include <fault.h>
> +
> +static struct lowcore *lc = (struct lowcore *)0x0;
> +
> +/* Decodes the protection exceptions we'll most likely see */
> +static void decode_pgm_prot(uint64_t teid)

I think this is also a "print_decode_pgm_prot", but it's static
so I guess we don't really care too much

> +{
> +	if (prot_is_lap(teid)) {
> +		printf("Type: LAP\n");
> +		return;
> +	}
> +
> +	if (prot_is_iep(teid)) {
> +		printf("Type: IEP\n");
> +		return;
> +	}
> +
> +	if (prot_is_datp(teid)) {
> +		printf("Type: DAT\n");
> +		return;
> +	}
> +}
> +
> +void print_decode_teid(uint64_t teid)
> +{
> +	int asce_id = teid & 3;
> +	bool dat = lc->pgm_old_psw.mask & PSW_MASK_DAT;
> +
> +	printf("Memory exception information:\n");
> +	printf("DAT: %s\n", dat ? "on" : "off");
> +
> +	printf("AS: ");
> +	switch (asce_id) {
> +	case AS_PRIM:
> +		printf("Primary\n");
> +		break;
> +	case AS_ACCR:
> +		printf("Access Register\n");
> +		break;
> +	case AS_SECN:
> +		printf("Secondary\n");
> +		break;
> +	case AS_HOME:
> +		printf("Home\n");
> +		break;
> +	}
> +
> +	if (lc->pgm_int_code == PGM_INT_CODE_PROTECTION)
> +		decode_pgm_prot(teid);
> +
> +	/*
> +	 * If teid bit 61 is off for these two exception the reported
> +	 * address is unpredictable.
> +	 */
> +	if ((lc->pgm_int_code == PGM_INT_CODE_SECURE_STOR_ACCESS ||
> +	     lc->pgm_int_code == PGM_INT_CODE_SECURE_STOR_VIOLATION) &&
> +	    !test_bit_inv(61, &teid)) {
> +		printf("Address: %lx, unpredictable\n ", teid & PAGE_MASK);
> +		return;
> +	}
> +	printf("TEID: %lx\n", teid);
> +	printf("Address: %lx\n\n", teid & PAGE_MASK);
> +}
> diff --git a/lib/s390x/fault.h b/lib/s390x/fault.h
> new file mode 100644
> index 00000000..726da2f0
> --- /dev/null
> +++ b/lib/s390x/fault.h
> @@ -0,0 +1,44 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Headers for fault.c
> + *
> + * Copyright 2021 IBM Corp.
> + *
> + * Authors:
> + *    Janosch Frank <frankja@linux.ibm.com>
> + */
> +#ifndef _S390X_FAULT_H_
> +#define _S390X_FAULT_H_
> +
> +#include <bitops.h>
> +
> +/* Instruction execution prevention, i.e. no-execute, 101 */
> +static inline bool prot_is_iep(uint64_t teid)
> +{
> +	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && test_bit_inv(61, &teid))
> +		return true;
> +
> +	return false;
> +}
> +
> +/* Standard DAT exception, 001 */
> +static inline bool prot_is_datp(uint64_t teid)
> +{
> +	if (!test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && test_bit_inv(61, &teid))
> +		return true;
> +
> +	return false;
> +}
> +
> +/* Low-address protection exception, 100 */
> +static inline bool prot_is_lap(uint64_t teid)
> +{
> +	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && !test_bit_inv(61, &teid))
> +		return true;
> +
> +	return false;
> +}
> +
> +void print_decode_teid(uint64_t teid);
> +
> +#endif /* _S390X_FAULT_H_ */
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 01ded49d..721e6758 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -12,6 +12,8 @@
>  #include <sclp.h>
>  #include <interrupt.h>
>  #include <sie.h>
> +#include <fault.h>
> +#include <asm/page.h>
>  
>  static bool pgm_int_expected;
>  static bool ext_int_expected;
> @@ -76,8 +78,7 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
>  		break;
>  	case PGM_INT_CODE_PROTECTION:
>  		/* Handling for iep.c test case. */
> -		if (lc->trans_exc_id & 0x80UL && lc->trans_exc_id & 0x04UL &&
> -		    !(lc->trans_exc_id & 0x08UL))
> +		if (prot_is_iep(lc->trans_exc_id))
>  			/*
>  			 * We branched to the instruction that caused
>  			 * the exception so we can use the return
> @@ -126,6 +127,26 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
>  	/* suppressed/terminated/completed point already at the next address */
>  }
>  
> +static void print_storage_exception_information(void)
> +{
> +	switch (lc->pgm_int_code) {
> +	case PGM_INT_CODE_PROTECTION:
> +	case PGM_INT_CODE_PAGE_TRANSLATION:
> +	case PGM_INT_CODE_SEGMENT_TRANSLATION:
> +	case PGM_INT_CODE_ASCE_TYPE:
> +	case PGM_INT_CODE_REGION_FIRST_TRANS:
> +	case PGM_INT_CODE_REGION_SECOND_TRANS:
> +	case PGM_INT_CODE_REGION_THIRD_TRANS:
> +	case PGM_INT_CODE_SECURE_STOR_ACCESS:
> +	case PGM_INT_CODE_NON_SECURE_STOR_ACCESS:
> +	case PGM_INT_CODE_SECURE_STOR_VIOLATION:
> +		print_decode_teid(lc->trans_exc_id);
> +		break;
> +	default:
> +		return;
> +	}
> +}
> +
>  static void print_int_regs(struct stack_frame_int *stack)
>  {
>  	printf("\n");
> @@ -155,6 +176,10 @@ static void print_pgm_info(struct stack_frame_int *stack)
>  	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr, lc->pgm_int_id);
>  	print_int_regs(stack);
>  	dump_stack();
> +
> +	/* Dump stack doesn't end with a \n so we add it here instead */
> +	printf("\n");
> +	print_storage_exception_information();
>  	report_summary();
>  	abort();
>  }
> diff --git a/s390x/Makefile b/s390x/Makefile
> index ef8041a6..5d1a33a0 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -72,6 +72,7 @@ cflatobjs += lib/s390x/css_lib.o
>  cflatobjs += lib/s390x/malloc_io.o
>  cflatobjs += lib/s390x/uv.o
>  cflatobjs += lib/s390x/sie.o
> +cflatobjs += lib/s390x/fault.o
>  
>  OBJDIRS += lib/s390x
>  

