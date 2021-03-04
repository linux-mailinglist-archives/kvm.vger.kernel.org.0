Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBFD32D3D6
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 14:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241079AbhCDNDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 08:03:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54146 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241052AbhCDNDc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 08:03:32 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 124CXhYZ055349;
        Thu, 4 Mar 2021 08:02:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=KqDDaZ6KVWEaeI6UWx8zKV5tIXUbcDHkPDEhB7gPYoU=;
 b=oMsgJ5RUYTQqnf5gAxIQMzPTBb85g7NuIvS02E7UfDUBlI4yw0sqithzNeWIZusDa8wy
 BwsKNKY47coQYcQRTd3uQ2ycKPGIzK5gy9eyKyfibU2fZMR+i28UeIQLT6uMglROebOP
 4SlcvGEpPA3AXVcom3pgJRxfak3l9A+V0gW0d8EX+OPVm+g/3vdkjl2ANQcZDBCWwbud
 tKN9mkP/0Qr1nBiRfd1ELph3WgDEKuJonkndz6M5UDeJ3LKj1UDlER89YUt7w8siOW02
 Vizu41DShfC5LUtCFWZfsolRrf5Rde2BtO099fBZd2FAhvBuOr/E2AgIIRI3QimB3hGD bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 372yf195e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 08:02:51 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 124CnmSV130892;
        Thu, 4 Mar 2021 08:02:50 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 372yf195bx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 08:02:49 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 124ClXxI013189;
        Thu, 4 Mar 2021 13:02:47 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 36yj532e92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Mar 2021 13:02:47 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 124D2U8P33816958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Mar 2021 13:02:30 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92F6811C069;
        Thu,  4 Mar 2021 13:02:44 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3516811C052;
        Thu,  4 Mar 2021 13:02:44 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.10.194])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  4 Mar 2021 13:02:44 +0000 (GMT)
Date:   Thu, 4 Mar 2021 13:58:59 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        pmorel@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 3/7] s390x: Introduce and use
 CALL_INT_HANDLER macro
Message-ID: <20210304135859.1b8f7e25@ibm-vm>
In-Reply-To: <20210222085756.14396-4-frankja@linux.ibm.com>
References: <20210222085756.14396-1-frankja@linux.ibm.com>
        <20210222085756.14396-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-04_03:2021-03-03,2021-03-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103040059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Feb 2021 03:57:52 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> The ELF ABI dictates that we need to allocate 160 bytes of stack space
> for the C functions we're calling. Since we would need to do that for
> every interruption handler which, combined with the new stack argument
> being saved in GR2, makes cstart64.S look a bit messy.
> 
> So let's introduce the CALL_INT_HANDLER macro that handles all of
> that, calls the C interrupt handler and handles cleanup afterwards.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/cstart64.S | 28 +++++-----------------------
>  s390x/macros.S   | 17 +++++++++++++++++
>  2 files changed, 22 insertions(+), 23 deletions(-)
> 
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index 35d20293..666a9567 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -92,37 +92,19 @@ memsetxc:
>  
>  .section .text
>  pgm_int:
> -	SAVE_REGS_STACK
> -	lgr     %r2, %r15
> -	brasl	%r14, handle_pgm_int
> -	RESTORE_REGS_STACK
> -	lpswe	GEN_LC_PGM_OLD_PSW
> +	CALL_INT_HANDLER handle_pgm_int, GEN_LC_PGM_OLD_PSW
>  
>  ext_int:
> -	SAVE_REGS_STACK
> -	lgr     %r2, %r15
> -	brasl	%r14, handle_ext_int
> -	RESTORE_REGS_STACK
> -	lpswe	GEN_LC_EXT_OLD_PSW
> +	CALL_INT_HANDLER handle_ext_int, GEN_LC_EXT_OLD_PSW
>  
>  mcck_int:
> -	SAVE_REGS_STACK
> -	brasl	%r14, handle_mcck_int
> -	RESTORE_REGS_STACK
> -	lpswe	GEN_LC_MCCK_OLD_PSW
> +	CALL_INT_HANDLER handle_mcck_int, GEN_LC_MCCK_OLD_PSW
>  
>  io_int:
> -	SAVE_REGS_STACK
> -	lgr     %r2, %r15
> -	brasl	%r14, handle_io_int
> -	RESTORE_REGS_STACK
> -	lpswe	GEN_LC_IO_OLD_PSW
> +	CALL_INT_HANDLER handle_io_int, GEN_LC_IO_OLD_PSW
>  
>  svc_int:
> -	SAVE_REGS_STACK
> -	brasl	%r14, handle_svc_int
> -	RESTORE_REGS_STACK
> -	lpswe	GEN_LC_SVC_OLD_PSW
> +	CALL_INT_HANDLER handle_svc_int, GEN_LC_SVC_OLD_PSW
>  
>  	.align	8
>  initial_psw:
> diff --git a/s390x/macros.S b/s390x/macros.S
> index a7d62c6f..11f4397a 100644
> --- a/s390x/macros.S
> +++ b/s390x/macros.S
> @@ -11,6 +11,23 @@
>   *  David Hildenbrand <david@redhat.com>
>   */
>  #include <asm/asm-offsets.h>
> +/*
> + * Exception handler macro that saves registers on the stack,
> + * allocates stack space and calls the C handler function. Afterwards
> + * we re-load the registers and load the old PSW.
> + */
> +	.macro CALL_INT_HANDLER c_func, old_psw
> +	SAVE_REGS_STACK
> +	/* Save the stack address in GR2 which is the first function
> argument */
> +	lgr     %r2, %r15
> +	/* Allocate stack space for called C function, as specified
> in s390 ELF ABI */
> +	slgfi   %r15, 160
> +	brasl	%r14, \c_func
> +	algfi   %r15, 160
> +	RESTORE_REGS_STACK
> +	lpswe	\old_psw
> +	.endm
> +
>  	.macro SAVE_REGS
>  	/* save grs 0-15 */
>  	stmg	%r0, %r15, GEN_LC_SW_INT_GRS

