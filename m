Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24FC642D9DA
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 15:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhJNNM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 09:12:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13368 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230010AbhJNNMz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 09:12:55 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19EBQrei014847;
        Thu, 14 Oct 2021 09:10:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=HJcuhQqtA533qlF20rRHWY2AM9HiwhDDNbqBZYCZANc=;
 b=i50cHL/lRnDrgiGvxKgWEunSAGw2EVr+DHqkcrTejQVHCHuBu+2kNCfqf3gYDz4O0kyK
 tkynnWl7as4S7NA3dNxDTEzVA5yBm2jDKXpQu87ba5RaS+0UF9327TJuoaFmXTxNptc5
 WROwWTYClbTlxJ5Mix2125H/D7X7IlH6YtbIjC6y3jp2dShdASv7LlatNIw+wvhgDDk2
 dTObXwSsNtY6xenVSLuRcA+9RG5s4C3swnB8U1H0PQTll6oIww6q8twEJpxECx1uvZf0
 H89e0xyGldOVSxrCiFOCJ31MWNaJPFyaE4MsMJUNcAlXtFaFysY+YhvefarQtHvVtfht AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnnvgtpnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 09:10:49 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19EBjaFZ028795;
        Thu, 14 Oct 2021 09:10:49 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnnvgtpmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 09:10:49 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ED1VT5029162;
        Thu, 14 Oct 2021 13:10:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3bk2qa5eth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 13:10:47 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ED54ba29491510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Oct 2021 13:05:04 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95A5442041;
        Thu, 14 Oct 2021 13:10:44 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F48B4205C;
        Thu, 14 Oct 2021 13:10:44 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.174])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Oct 2021 13:10:44 +0000 (GMT)
Date:   Thu, 14 Oct 2021 15:09:25 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 2/3] lib: s390x: snippet.h: Add a few
 constants that will make our life easier
Message-ID: <20211014150925.13013d00@p-imbrenda>
In-Reply-To: <20211014125107.2877-3-frankja@linux.ibm.com>
References: <20211014125107.2877-1-frankja@linux.ibm.com>
        <20211014125107.2877-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rHGlx_uniCXzcxiKp1ojD6hwGc5PBkld
X-Proofpoint-ORIG-GUID: jqoYEJQv11kC_XIdP45lIQ0oceX0Qk1c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_07,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110140084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Oct 2021 12:51:06 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The variable names for the snippet objects are of gigantic length so
> let's define a few macros to make them easier to read.
> 
> Also add a standard PSW which should be used to start the snippet.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/snippet.h | 34 ++++++++++++++++++++++++++++++++++
>  s390x/mvpg-sie.c    | 13 ++++++-------
>  2 files changed, 40 insertions(+), 7 deletions(-)
>  create mode 100644 lib/s390x/snippet.h
> 
> diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
> new file mode 100644
> index 00000000..8e4765f8
> --- /dev/null
> +++ b/lib/s390x/snippet.h
> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Snippet definitions
> + *
> + * Copyright IBM Corp. 2021
> + * Author: Janosch Frank <frankja@linux.ibm.com>
> + */
> +
> +#ifndef _S390X_SNIPPET_H_
> +#define _S390X_SNIPPET_H_
> +
> +/* This macro cuts down the length of the pointers to snippets */
> +#define SNIPPET_NAME_START(type, file) \
> +	_binary_s390x_snippets_##type##_##file##_gbin_start
> +#define SNIPPET_NAME_END(type, file) \
> +	_binary_s390x_snippets_##type##_##file##_gbin_end
> +
> +/* Returns the length of the snippet */
> +#define SNIPPET_LEN(type, file) \
> +	((uintptr_t)SNIPPET_NAME_END(type, file) - (uintptr_t)SNIPPET_NAME_START(type, file))
> +
> +/*
> + * C snippet instructions start at 0x4000 due to the prefix and the
> + * stack being before that. ASM snippets don't strictly need a stack
> + * but keeping the starting address the same means less code.
> + */
> +#define SNIPPET_ENTRY_ADDR 0x4000
> +
> +/* Standard entry PSWs for snippets which can simply be copied into the guest PSW */
> +static const struct psw snippet_psw = {
> +	.mask = PSW_MASK_64,
> +	.addr = SNIPPET_ENTRY_ADDR,
> +};
> +#endif
> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
> index 5adcec1e..d526069d 100644
> --- a/s390x/mvpg-sie.c
> +++ b/s390x/mvpg-sie.c
> @@ -19,6 +19,7 @@
>  #include <vm.h>
>  #include <sclp.h>
>  #include <sie.h>
> +#include <snippet.h>
>  
>  static u8 *guest;
>  static struct vm vm;
> @@ -27,8 +28,8 @@ static uint8_t *src;
>  static uint8_t *dst;
>  static uint8_t *cmp;
>  
> -extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_start[];
> -extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_end[];
> +extern const char SNIPPET_NAME_START(c, mvpg_snippet)[];
> +extern const char SNIPPET_NAME_END(c, mvpg_snippet)[];
>  int binary_size;
>  
>  static void test_mvpg_pei(void)
> @@ -77,10 +78,9 @@ static void test_mvpg_pei(void)
>  
>  static void test_mvpg(void)
>  {
> -	int binary_size = ((uintptr_t)_binary_s390x_snippets_c_mvpg_snippet_gbin_end -
> -			   (uintptr_t)_binary_s390x_snippets_c_mvpg_snippet_gbin_start);
> +	int binary_size = SNIPPET_LEN(c, mvpg_snippet);
>  
> -	memcpy(guest, _binary_s390x_snippets_c_mvpg_snippet_gbin_start, binary_size);
> +	memcpy(guest, SNIPPET_NAME_START(c, mvpg_snippet), binary_size);
>  	memset(src, 0x42, PAGE_SIZE);
>  	memset(dst, 0x43, PAGE_SIZE);
>  	sie(&vm);
> @@ -96,8 +96,7 @@ static void setup_guest(void)
>  
>  	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
>  
> -	vm.sblk->gpsw.addr = PAGE_SIZE * 4;
> -	vm.sblk->gpsw.mask = PSW_MASK_64;
> +	vm.sblk->gpsw = snippet_psw;
>  	vm.sblk->ictl = ICTL_OPEREXC | ICTL_PINT;
>  	/* Enable MVPG interpretation as we want to test KVM and not ourselves */
>  	vm.sblk->eca = ECA_MVPGI;

