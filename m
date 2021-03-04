Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF41332D3D2
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 14:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241069AbhCDNDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 08:03:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11158 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241029AbhCDND3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 08:03:29 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 124CiBGF089450;
        Thu, 4 Mar 2021 08:02:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=X7G/uG3aEbl9jHXVzs22+ZQ+OPpxQ3A3sFa+wT1hZtQ=;
 b=QMn+X7NoJnEbf/QmJVe4gUdecrsAAJ+fYzXgQT0wsfj2id2gpo3hVCkdTqN89Q/S+yIL
 umExCxdR1/p9Kgr2DpY+TYVi33L9ba1x8WqktAg3i+2WDXTF5L3otwU1WuuzZp5otqda
 Nq96+NYicNi476KNeBXgnCC2y0r6zwyvppNmn7qabQqbf6iwNHm3nzFK3HE2Kqn8hFV9
 kcbeoaKj00idIRJyhn0JQia+NXeLehAy+nvUG7NMkzbfxEDsXWC3jMj7fpbxmW1hYCWo
 +hK4qiuBJUrAHGkePTSy4fdlB/fP7ZrKOhv2CBFya+YvnZZBk1SGjQfqqs90UfMH0bNV 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 372wmrc18m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 08:02:49 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 124CkbDH098912;
        Thu, 4 Mar 2021 08:02:48 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 372wmrc16w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 08:02:48 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 124ClkAP013654;
        Thu, 4 Mar 2021 13:02:45 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 36yj532e91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 13:02:45 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 124D2SaP38076898
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Mar 2021 13:02:28 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D40C11C04A;
        Thu,  4 Mar 2021 13:02:43 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B755911C058;
        Thu,  4 Mar 2021 13:02:42 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.10.194])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  4 Mar 2021 13:02:42 +0000 (GMT)
Date:   Thu, 4 Mar 2021 14:02:14 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        pmorel@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 4/7] s390x: Provide preliminary
 backtrace support
Message-ID: <20210304140214.7ff5eae3@ibm-vm>
In-Reply-To: <20210222085756.14396-5-frankja@linux.ibm.com>
References: <20210222085756.14396-1-frankja@linux.ibm.com>
        <20210222085756.14396-5-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-04_03:2021-03-03,2021-03-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 spamscore=0 bulkscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103040059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Feb 2021 03:57:53 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> After the stack changes we can finally use -mbackchain and have a
> working backtrace.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/stack.c | 20 ++++++++++++++------
>  s390x/Makefile    |  1 +
>  s390x/macros.S    |  5 +++++
>  3 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/s390x/stack.c b/lib/s390x/stack.c
> index 0fcd1afb..4cf80dae 100644
> --- a/lib/s390x/stack.c
> +++ b/lib/s390x/stack.c
> @@ -3,24 +3,32 @@
>   * s390x stack implementation
>   *
>   * Copyright (c) 2017 Red Hat Inc
> + * Copyright 2021 IBM Corp
>   *
>   * Authors:
>   *  Thomas Huth <thuth@redhat.com>
>   *  David Hildenbrand <david@redhat.com>
> + *  Janosch Frank <frankja@de.ibm.com>
>   */
>  #include <libcflat.h>
>  #include <stack.h>
> +#include <asm/arch_def.h>
>  
>  int backtrace_frame(const void *frame, const void **return_addrs,
> int max_depth) {
> -	printf("TODO: Implement backtrace_frame(%p, %p, %d)
> function!\n",
> -	       frame, return_addrs, max_depth);
> -	return 0;
> +	int depth = 0;
> +	struct stack_frame *stack = (struct stack_frame *)frame;
> +
> +	for (depth = 0; stack && depth < max_depth; depth++) {
> +		return_addrs[depth] = (void *)stack->grs[8];
> +		stack = stack->back_chain;
> +	}
> +
> +	return depth;
>  }
>  
>  int backtrace(const void **return_addrs, int max_depth)
>  {
> -	printf("TODO: Implement backtrace(%p, %d) function!\n",
> -	       return_addrs, max_depth);
> -	return 0;
> +	return backtrace_frame(__builtin_frame_address(0),
> +			       return_addrs, max_depth);
>  }
> diff --git a/s390x/Makefile b/s390x/Makefile
> index f3b0fccf..20bb5683 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -39,6 +39,7 @@ CFLAGS += -ffreestanding
>  CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/s390x -I lib
>  CFLAGS += -O2
>  CFLAGS += -march=zEC12
> +CFLAGS += -mbackchain
>  CFLAGS += -fno-delete-null-pointer-checks
>  LDFLAGS += -nostdlib -Wl,--build-id=none
>  
> diff --git a/s390x/macros.S b/s390x/macros.S
> index 11f4397a..d4f41ec4 100644
> --- a/s390x/macros.S
> +++ b/s390x/macros.S
> @@ -22,6 +22,11 @@
>  	lgr     %r2, %r15
>  	/* Allocate stack space for called C function, as specified
> in s390 ELF ABI */ slgfi   %r15, 160
> +	/*
> +	 * Save the address of the interrupt stack into the back
> chain
> +	 * of the called function.
> +	 */
> +	stg     %r2, STACK_FRAME_INT_BACKCHAIN(%r15)
>  	brasl	%r14, \c_func
>  	algfi   %r15, 160
>  	RESTORE_REGS_STACK

