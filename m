Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A9D3D8BD9
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 12:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235977AbhG1Kct (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 06:32:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34230 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235919AbhG1Kcl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 06:32:41 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SAAWDg119195;
        Wed, 28 Jul 2021 06:32:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=eZY36jSfZpVBUBU+6AAmO44IoMnc3S3NIfvovVleXaA=;
 b=bTaafcEQ5BUJ8O647x8DrwJkiq+lIU/S6SP23yqFTGLTGR+i0LzGz6aEZcZVYytQZ5YR
 YoIfA8F1lJWY33GfBwUhwmYEyU5UEFWrnfPshx3qwOpwJpkFPkNksIlAhnDkC1KSpBRI
 BueacvDvcWGPbeGtS8ykhoL1vXCwxMSvF/fyen2CXCfxhsrDDN8Df8DU/fR40RyfYy1Z
 OTuR8hrRcTQ6dhSbxcKnBcTt8YWaVNcAGf9WmWC9yDseXPhw9e/nxLXzrkeUh/B+8zDM
 41MI5MTvOQuEsZv9sWdnKQQckujESkrJWnwt2EedW4wRkNxtd5JCOB448rfBO3Y3CKRL wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a337c4jwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 06:32:39 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SAE04U136266;
        Wed, 28 Jul 2021 06:32:39 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a337c4juh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 06:32:39 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SAWaxG010329;
        Wed, 28 Jul 2021 10:32:36 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3a235kgyxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:32:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SAWYlQ29753606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 10:32:34 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F33ED11C074;
        Wed, 28 Jul 2021 10:32:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3D6011C06E;
        Wed, 28 Jul 2021 10:32:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.9.194])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 10:32:33 +0000 (GMT)
Date:   Wed, 28 Jul 2021 12:32:21 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 1/3] s390x: Add SPDX and header comments
 for s390x/* and lib/s390x/*
Message-ID: <20210728123221.7ca90b35@p-imbrenda>
In-Reply-To: <20210728101328.51646-2-frankja@linux.ibm.com>
References: <20210728101328.51646-1-frankja@linux.ibm.com>
        <20210728101328.51646-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AR81-lBdYeW23wcJqDlBOTAhuug74Rvy
X-Proofpoint-GUID: dArJxAhnq3dv9HgEWxPfPO-I5sDlcppt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_07:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 mlxlogscore=999 bulkscore=0 malwarescore=0
 suspectscore=0 spamscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107280054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Jul 2021 10:13:26 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Seems like I missed adding them.
> 
> The s390x/sieve.c one is a bit of a head scratcher since it came with
> the first commit but I assume it's lpgl2-only since that's what the
> COPYRIGHT file said then.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/uv.c   |  9 +++++++++
>  s390x/mvpg-sie.c |  9 +++++++++
>  s390x/sie.c      | 10 ++++++++++
>  x86/sieve.c      |  5 +++++
>  4 files changed, 33 insertions(+)
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
> diff --git a/x86/sieve.c b/x86/sieve.c
> index 8150f2d9..b89d5f80 100644
> --- a/x86/sieve.c
> +++ b/x86/sieve.c
> @@ -1,3 +1,8 @@
> +/* SPDX-License-Identifier: LGPL-2.0-only */

do you really need to fix something in the x86 directory? (even though
it is also used on other archs)

maybe you can split out this as a separate patch, so s390x stuff is
more self contained, and others can then discuss the sieve.c patch
separately if needed?

> +/*
> + * Implementation of the sieve of Eratosthenes
> + * Calculation and memory intensive workload for general stress
> testing.
> + */
>  #include "alloc.h"
>  #include "libcflat.h"
>  

