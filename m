Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C1542BCEA
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 12:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhJMKiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 06:38:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58454 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229711AbhJMKiW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 06:38:22 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19D85WsW014828;
        Wed, 13 Oct 2021 06:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=SSZ/jrU3OB7iUJFqimHv4kKAAbs7QbwOfLn/WMZtIO4=;
 b=d+0xpBzu29wiD+WOInbqF/54gkr5W63gfqg1/poJBuQ0xKRhAZXi1ZCxPL28drMX9nwa
 7Iaz/8BCfJmLwzJBT6w4KK0m2g+o8ftrn43xefSrCWur6DZT4v5gXWpK5AKdE1S1u/Tn
 gwXoqckhdEZrdHN9cG5T5fHHAceY1ytSFVt0B9ns8ky5KufRrgs0uPJOsP2VxDOuo7Ns
 WyoWK5we1G/L5bwuqg03iBFkBkE8Ry7hBBgD9k16C8SoRNTG4Mv89vut5CLyG7Bmcy1D
 h4ULpb8dpOXuwMZhDzI153KF0Evc16EFpAgkcq6JNi0phk2ieTR9SM56YQgLMAS1lH35 qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnnvfspts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 06:36:18 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19D9So68025245;
        Wed, 13 Oct 2021 06:36:17 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnnvfspte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 06:36:17 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19DAZYTB024399;
        Wed, 13 Oct 2021 10:36:16 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3bk2bjqkc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 10:36:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19DAa4hx55968024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 10:36:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 898C111C075;
        Wed, 13 Oct 2021 10:36:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4295711C074;
        Wed, 13 Oct 2021 10:36:04 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.81])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Oct 2021 10:36:04 +0000 (GMT)
Date:   Wed, 13 Oct 2021 12:35:58 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 2/2] lib: s390x: snippet.h: Add a few
 constants that will make our life easier
Message-ID: <20211013123558.40433784@p-imbrenda>
In-Reply-To: <20211013102722.17160-3-frankja@linux.ibm.com>
References: <20211013102722.17160-1-frankja@linux.ibm.com>
        <20211013102722.17160-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LmgVc07ih8WYwJokxYKoUHTEaJ3E5S05
X-Proofpoint-ORIG-GUID: 50ac8eH4AAGtLDRTtCd1AMAb_T6FYCY4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_04,2021-10-13_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110130071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Oct 2021 10:27:22 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The variable names for the snippet objects are of gigantic length so
> let's define a few macros to make them easier to read.
> 
> Also add a standard PSW which should be used to start the snippet.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/snippet.h | 40 ++++++++++++++++++++++++++++++++++++++++
>  s390x/mvpg-sie.c    | 13 ++++++-------
>  2 files changed, 46 insertions(+), 7 deletions(-)
>  create mode 100644 lib/s390x/snippet.h
> 
> diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
> new file mode 100644
> index 00000000..9ead4fe3
> --- /dev/null
> +++ b/lib/s390x/snippet.h
> @@ -0,0 +1,40 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Snippet definitions
> + *
> + * Copyright IBM, Corp. 2021
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
> +	(uintptr_t)SNIPPET_NAME_END(type, file) - (uintptr_t)SNIPPET_NAME_START(type, file)

parentheses around the expansion:
	((uintptr_t)SNIPPET_NAME_END(type, file) - (uintptr_t)SNIPPET_NAME_START(type, file))

> +
> +/*
> + * C snippet instructions start at 0x4000 due to the prefix and the
> + * stack being before that.
> + */
> +#define SNIPPET_C_ENTRY_ADDR 0x4000
> +/* ASM snippets only have the prefix and hence start at 0x2000 */

wouldn't it be possible to make both start at the same address?
would make everything easier.

ASM snippets would have a couple of unused pages, but who cares?

> +#define SNIPPET_ASM_ENTRY_ADDR 0x2000
> +
> +/* Standard entry PSWs for snippets which can simply be copied into the guest PSW */
> +static const struct psw snippet_c_psw = {
> +	.mask = PSW_MASK_64,
> +	.addr = SNIPPET_C_ENTRY_ADDR,
> +};
> +
> +static const struct psw snippet_asm_psw = {
> +	.mask = PSW_MASK_64,
> +	.addr = SNIPPET_ASM_ENTRY_ADDR,
> +};
> +#endif
> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
> index 5adcec1e..46170d02 100644
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
> +	vm.sblk->gpsw = snippet_c_psw;
>  	vm.sblk->ictl = ICTL_OPEREXC | ICTL_PINT;
>  	/* Enable MVPG interpretation as we want to test KVM and not ourselves */
>  	vm.sblk->eca = ECA_MVPGI;

