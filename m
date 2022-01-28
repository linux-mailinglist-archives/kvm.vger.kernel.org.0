Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F01949F5D0
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 10:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbiA1JAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 04:00:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23106 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231588AbiA1JAf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 04:00:35 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20S8i1rg013238;
        Fri, 28 Jan 2022 09:00:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gvzsCLVLCYGj8fasg6EJL4uHRzyblBs5v4QSJnKcAKU=;
 b=hjxFNRG34t0GbkY/H7zQ9zPTbyMzjI0eKljsSGff7Sj+aQg2lyFj5OlY7PwHfIlyK3fa
 At/t76I+zWi++t1LX0fo6Ny+jjvNpN8A4dM2gGmltHILimw24jv2AiBLb1k2QPlP/9eR
 fk4td7lNkmqVbVOmvB+I3eUzyaaqrTtAu64rxQLtgir6rPfy5JUr6F4pcp2OtBuinvV6
 77chlXcCEMdN/esvjU8Vw8LfYjfcb/st5wm065NGazJVXDfq3rK3OBJjJB+Yi0DCe2H+
 ZVxsqV2oPh7gJS7GvxI8JicUwB6NUDKKVjHlMYtKwwzv2LQV6WK6M2XS3F9lyUOHEUdL bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dvd7rg8dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 09:00:34 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20S8rVd8017752;
        Fri, 28 Jan 2022 09:00:33 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dvd7rg8d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 09:00:33 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20S8wmqd002272;
        Fri, 28 Jan 2022 09:00:32 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3dr9j9yf9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 09:00:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20S90SSY34865634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jan 2022 09:00:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C27A6AE05A;
        Fri, 28 Jan 2022 09:00:28 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 754FAAE063;
        Fri, 28 Jan 2022 09:00:28 +0000 (GMT)
Received: from [9.145.170.148] (unknown [9.145.170.148])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jan 2022 09:00:28 +0000 (GMT)
Message-ID: <a11c343b-16e6-727c-dbec-1edfe5375fcf@linux.ibm.com>
Date:   Fri, 28 Jan 2022 10:00:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220127141559.35250-1-seiden@linux.ibm.com>
 <20220127141559.35250-2-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 1/4] s390x: uv-host: Add attestation test
In-Reply-To: <20220127141559.35250-2-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Fv4zMttJeHviLpoJwlEDgk8KrV0o7TdL
X-Proofpoint-ORIG-GUID: HrN4_Yipt9Ig0F5mNUVSZTlW0-Yf986A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_06,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201280051
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/27/22 15:15, Steffen Eiden wrote:
> Adds an invalid command test for attestation in the uv-host.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   lib/s390x/asm/uv.h | 24 +++++++++++++++++++++++-
>   s390x/uv-host.c    |  3 ++-
>   2 files changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 97c90e81..38c322bf 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -1,10 +1,11 @@
>   /*
>    * s390x Ultravisor related definitions
>    *
> - * Copyright (c) 2020 IBM Corp
> + * Copyright (c) 2020, 2022 IBM Corp

I'm not sure when we actually need/want to update this.

>    *
>    * Authors:
>    *  Janosch Frank <frankja@linux.ibm.com>
> + *  Steffen Eiden <seiden@linux.ibm.com>

I usually add myself to this list once I made significant contributions 
to the file (or if I create the file). If you have a look at the 
kernel's kvm-s390.c you'll see that I'm not yet on the list of its authors.

But, as visible in other discussions we're currently having, I'm not 
aware of a definite guideline for this. Looks like we should find an 
agreement within IBM and write it down.

>    *
>    * This code is free software; you can redistribute it and/or modify it
>    * under the terms of the GNU General Public License version 2.
> @@ -47,6 +48,7 @@
>   #define UVC_CMD_UNPIN_PAGE_SHARED	0x0342
>   #define UVC_CMD_SET_SHARED_ACCESS	0x1000
>   #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
> +#define UVC_CMD_ATTESTATION		0x1020
>   
>   /* Bits in installed uv calls */
>   enum uv_cmds_inst {
> @@ -71,6 +73,7 @@ enum uv_cmds_inst {
>   	BIT_UVC_CMD_UNSHARE_ALL = 20,
>   	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
>   	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
> +	BIT_UVC_CMD_ATTESTATION = 28,
>   };
>   
>   struct uv_cb_header {
> @@ -178,6 +181,25 @@ struct uv_cb_cfs {
>   	u64 paddr;
>   }  __attribute__((packed))  __attribute__((aligned(8)));
>   
> +/* Retrieve Attestation Measurement */
> +struct uv_cb_attest {
> +	struct uv_cb_header header;	/* 0x0000 */
> +	u64 reserved08[2];		/* 0x0008 */
> +	u64 arcb_addr;			/* 0x0018 */
> +	u64 continuation_token;		/* 0x0020 */
> +	u8  reserved28[6];		/* 0x0028 */
> +	u16 user_data_length;		/* 0x002e */
> +	u8  user_data[256];		/* 0x0030 */
> +	u32 reserved130[3];		/* 0x0130 */
> +	u32 measurement_length;		/* 0x013c */
> +	u64 measurement_address;	/* 0x0140 */
> +	u8 config_uid[16];		/* 0x0148 */
> +	u32 reserved158;		/* 0x0158 */
> +	u32 add_data_length;		/* 0x015c */
> +	u64 add_data_address;		/* 0x0160 */
> +	u64 reserved168[4];		/* 0x0168 */
> +}  __attribute__((packed))  __attribute__((aligned(8)));
> +
>   /* Set Secure Config Parameter */
>   struct uv_cb_ssc {
>   	struct uv_cb_header header;
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 92a41069..0f8ab94a 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -2,7 +2,7 @@
>   /*
>    * Guest Ultravisor Call tests
>    *
> - * Copyright (c) 2021 IBM Corp
> + * Copyright (c) 2021, 2022 IBM Corp
>    *
>    * Authors:
>    *  Janosch Frank <frankja@linux.ibm.com>
> @@ -418,6 +418,7 @@ static struct cmd_list invalid_cmds[] = {
>   	{ "bogus", 0x4242, sizeof(struct uv_cb_header), -1},
>   	{ "share", UVC_CMD_SET_SHARED_ACCESS, sizeof(struct uv_cb_share), BIT_UVC_CMD_SET_SHARED_ACCESS },
>   	{ "unshare", UVC_CMD_REMOVE_SHARED_ACCESS, sizeof(struct uv_cb_share), BIT_UVC_CMD_REMOVE_SHARED_ACCESS },
> +	{ "attest", UVC_CMD_ATTESTATION, sizeof(struct uv_cb_attest), BIT_UVC_CMD_ATTESTATION },
>   	{ NULL, 0, 0 },
>   };
>   
> 

