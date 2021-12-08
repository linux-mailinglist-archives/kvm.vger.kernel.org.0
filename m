Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E0146D3DF
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 13:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbhLHNB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 08:01:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38352 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233894AbhLHNBW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 08:01:22 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8Cs4Xd016069;
        Wed, 8 Dec 2021 12:57:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=BOXe4RtpJGLobrWonrcYC0XwA/sdxy/XNEk+7xFpuQQ=;
 b=SmCDo8NQY3eA6k6I+tb6LvIVcJDpXmndK/Q/Jbb2t5Msi0L36EhaAfWArgqTnsTAWjbG
 KLcEv7+/M33VCb3xtMTZfT39u7kcfwjVa6SuTC7a1UWmZ56ORQFSdCdxuUPj8krUKuKj
 qCtFbCxIO6ogIJxLJ5vOKpEZc0DA15oUYB28U2Q1IKdXpMobGHR2ig9j54ld65MfBiDm
 TEFZTKI7FdO13yuAmkNCaRlLsAuLMDiiMxERRwzeVNEwrR4H2in+HUQ3YeJEiYmeXagi
 5PJX4GBI26d4tDLVuMQavoT3ClHHZfhbXP1w2JwFIU6mSD1KKyU5305pu7VzVSr56w7F 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctw3v81vx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 12:57:50 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8CsO5P017512;
        Wed, 8 Dec 2021 12:57:50 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctw3v81v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 12:57:50 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8Crr1X026249;
        Wed, 8 Dec 2021 12:57:47 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3cqyya7rh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 12:57:47 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8Cvhrk31588834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 12:57:43 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8FBD11C052;
        Wed,  8 Dec 2021 12:57:43 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E31A11C04C;
        Wed,  8 Dec 2021 12:57:43 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.179])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 12:57:43 +0000 (GMT)
Date:   Wed, 8 Dec 2021 12:19:18 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 09/10] s390x: mvpg-sie: Use snippet
 helpers
Message-ID: <20211208121918.2fd79983@p-imbrenda>
In-Reply-To: <20211207160005.1586-10-frankja@linux.ibm.com>
References: <20211207160005.1586-1-frankja@linux.ibm.com>
        <20211207160005.1586-10-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Wu9XUIjolwUGkfasRLndLGWNsYl3uSK2
X-Proofpoint-GUID: 3h0xaRQuvMiFzmSb2chU8uGhciWZIgPw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_04,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 adultscore=0 malwarescore=0 impostorscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Dec 2021 16:00:04 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Time to use our shiny new snippet helpers.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/mvpg-sie.c | 24 ++++++++----------------
>  1 file changed, 8 insertions(+), 16 deletions(-)
> 
> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
> index d526069d..8ae9a52a 100644
> --- a/s390x/mvpg-sie.c
> +++ b/s390x/mvpg-sie.c
> @@ -21,17 +21,12 @@
>  #include <sie.h>
>  #include <snippet.h>
>  
> -static u8 *guest;
>  static struct vm vm;
>  
>  static uint8_t *src;
>  static uint8_t *dst;
>  static uint8_t *cmp;
>  
> -extern const char SNIPPET_NAME_START(c, mvpg_snippet)[];
> -extern const char SNIPPET_NAME_END(c, mvpg_snippet)[];
> -int binary_size;
> -
>  static void test_mvpg_pei(void)
>  {
>  	uint64_t **pei_dst = (uint64_t **)((uintptr_t) vm.sblk + 0xc0);
> @@ -78,9 +73,6 @@ static void test_mvpg_pei(void)
>  
>  static void test_mvpg(void)
>  {
> -	int binary_size = SNIPPET_LEN(c, mvpg_snippet);
> -
> -	memcpy(guest, SNIPPET_NAME_START(c, mvpg_snippet), binary_size);
>  	memset(src, 0x42, PAGE_SIZE);
>  	memset(dst, 0x43, PAGE_SIZE);
>  	sie(&vm);
> @@ -89,20 +81,20 @@ static void test_mvpg(void)
>  
>  static void setup_guest(void)
>  {
> +	extern const char SNIPPET_NAME_START(c, mvpg_snippet)[];
> +	extern const char SNIPPET_NAME_END(c, mvpg_snippet)[];
> +
>  	setup_vm();
>  
> -	/* Allocate 1MB as guest memory */
> -	guest = alloc_pages(8);
> +	snippet_setup_guest(&vm, false);
> +	snippet_init(&vm, SNIPPET_NAME_START(c, mvpg_snippet),
> +		     SNIPPET_LEN(c, mvpg_snippet), SNIPPET_OFF_C);
>  
> -	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
> -
> -	vm.sblk->gpsw = snippet_psw;
> -	vm.sblk->ictl = ICTL_OPEREXC | ICTL_PINT;
>  	/* Enable MVPG interpretation as we want to test KVM and not ourselves */
>  	vm.sblk->eca = ECA_MVPGI;
>  
> -	src = guest + PAGE_SIZE * 6;
> -	dst = guest + PAGE_SIZE * 5;
> +	src = (uint8_t *) vm.sblk->mso + PAGE_SIZE * 6;
> +	dst = (uint8_t *) vm.sblk->mso + PAGE_SIZE * 5;
>  	cmp = alloc_page();
>  	memset(cmp, 0, PAGE_SIZE);
>  }

