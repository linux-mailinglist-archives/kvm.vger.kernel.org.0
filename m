Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B9F3D8EFD
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 15:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235354AbhG1NZ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 09:25:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57340 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233315AbhG1NZ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 09:25:57 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SD4VA7051580;
        Wed, 28 Jul 2021 09:25:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=tETwx1HiJFqXuGJxZwBIxosNjZsPUYQELVSzXv+VzDw=;
 b=WdFv8PhZHH66sbdbCBAhkwodgmb84JpSMzz4ee67JZwPEClsdQj/eu+iThna/P77uxBr
 x2pu344AGy7MVsxRnzTh3zo3WGhdjlml+Y2Whaj2PzNJEVOnGOfqTnXXR5NN4l+SyqD/
 ZVGK3XCvElwVJZe0Ecy/H5a2ZY0c0yFVl38+M86odiNIuTS0QVC3GElXT+ebd2XUshXs
 6fdJTHjY5VrOFY75BQh6esNDbRNziuJV/eBFMq3np8mRFf2/H/NW9PDg5HwFSmlXatZ/
 AO7emElrVtNb1QF6p4MoD9xtjJtffVWjoZE3jbR2upD/BVS9GReE/6lnSfyEf6gVwPDm eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a372wahd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 09:25:55 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SD4WoV051683;
        Wed, 28 Jul 2021 09:25:55 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a372wahbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 09:25:55 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SD88O2026644;
        Wed, 28 Jul 2021 13:25:53 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3a235krq03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 13:25:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SDN8cC26345868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 13:23:08 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCB20A4060;
        Wed, 28 Jul 2021 13:25:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77B13A405C;
        Wed, 28 Jul 2021 13:25:50 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.9.194])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 13:25:50 +0000 (GMT)
Date:   Wed, 28 Jul 2021 15:25:48 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2] s390x: Add SPDX and header comments
 for s390x/* and lib/s390x/*
Message-ID: <20210728152548.6cf880d7@p-imbrenda>
In-Reply-To: <20210728125643.80840-1-frankja@linux.ibm.com>
References: <20210728101328.51646-2-frankja@linux.ibm.com>
        <20210728125643.80840-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _71ffqBGe9WdfapVMohUmxnw5VaoLdbo
X-Proofpoint-GUID: y4yV236b8bMnvRxhJOdtklCqNkAt51gu
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_08:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 mlxscore=0 impostorscore=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2107280074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Jul 2021 12:56:43 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Seems like I missed adding them.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
> 
> Dropped the sieve.c change.
> 
> ---
>  lib/s390x/uv.c   |  9 +++++++++
>  s390x/mvpg-sie.c |  9 +++++++++
>  s390x/sie.c      | 10 ++++++++++
>  3 files changed, 28 insertions(+)
> 
> diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
> index 0d8c141c..fd9de944 100644
> --- a/lib/s390x/uv.c
> +++ b/lib/s390x/uv.c
> @@ -1,3 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Ultravisor related functionality
> + *
> + * Copyright 2020 IBM Corp.
> + *
> + * Authors:
> + *    Janosch Frank <frankja@linux.ibm.com>
> + */
>  #include <libcflat.h>
>  #include <bitops.h>
>  #include <alloc.h>
> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
> index 9bcd15a2..5e70f591 100644
> --- a/s390x/mvpg-sie.c
> +++ b/s390x/mvpg-sie.c
> @@ -1,3 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Tests mvpg SIE partial execution intercepts.
> + *
> + * Copyright 2021 IBM Corp.
> + *
> + * Authors:
> + *    Janosch Frank <frankja@linux.ibm.com>
> + */
>  #include <libcflat.h>
>  #include <asm/asm-offsets.h>
>  #include <asm-generic/barrier.h>
> diff --git a/s390x/sie.c b/s390x/sie.c
> index cfc746f3..134d3c4f 100644
> --- a/s390x/sie.c
> +++ b/s390x/sie.c
> @@ -1,3 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Tests SIE diagnose intercepts.
> + * Mainly used as a template for SIE tests.
> + *
> + * Copyright 2021 IBM Corp.
> + *
> + * Authors:
> + *    Janosch Frank <frankja@linux.ibm.com>
> + */
>  #include <libcflat.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/arch_def.h>

