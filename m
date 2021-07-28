Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA5E3D8BDB
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 12:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbhG1Kcv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 06:32:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32082 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235912AbhG1Kcl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 06:32:41 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SAF9m4095622;
        Wed, 28 Jul 2021 06:32:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=C6oGXZJ6mxY5BPsAPVwMRv6quBScC99oZb8kkDlYfaE=;
 b=GK/XV5orLcCM8TjKQHhnzG0eGhBsFKwV/IhzfvdWCanvxTsW3B1eN1GHchKRAweRRZoh
 Go4d7y18e89pSCneyrpp2upadHVa2lsUWuhcUGcNOIesrH7LcCnK6hIWngMY9gIbyYwj
 yfVaD8aDEKM3TJMeiwKl9p1jIJnDuZeVHQrgJYv0gYColpXa0k9FnsRoV6HMP5he2xC5
 Bu2CCAtYqoQCA94oaqcvMN8f8KfM3p271R7B01VQtw9Fc/OeBQUw17Ob/c/lY6s6up6G
 FOY/QyzJ2o+Go+zJB0ZsNX8oWK+8YkCJFQvrJTkg3ssFQ/jK4okWGk13KttrDzLglH4f 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a35am8ea5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 06:32:38 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SAFjQt097015;
        Wed, 28 Jul 2021 06:32:37 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a35am8e91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 06:32:37 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SAWYc6010326;
        Wed, 28 Jul 2021 10:32:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3a235kgyxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:32:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SAWVfw29360388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 10:32:31 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1D6511C075;
        Wed, 28 Jul 2021 10:32:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DB5011C070;
        Wed, 28 Jul 2021 10:32:31 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.9.194])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 10:32:31 +0000 (GMT)
Date:   Wed, 28 Jul 2021 12:28:36 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: Fix my mail address in the
 headers
Message-ID: <20210728122836.74d9051e@p-imbrenda>
In-Reply-To: <20210728101328.51646-4-frankja@linux.ibm.com>
References: <20210728101328.51646-1-frankja@linux.ibm.com>
        <20210728101328.51646-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0SK4azKaeJwi3PwKt6y-h1BY9mzTtA2U
X-Proofpoint-ORIG-GUID: LWPCiX7SfNw0FZuPoZHbHZSTBotDBQnJ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_07:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 spamscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Jul 2021 10:13:28 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> I used the wrong one once and then copied it over...
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/mem.h | 2 +-
>  lib/s390x/mmu.h     | 2 +-
>  lib/s390x/stack.c   | 2 +-
>  s390x/gs.c          | 2 +-
>  s390x/iep.c         | 2 +-
>  s390x/vector.c      | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
> index 1963cef7..40b22b63 100644
> --- a/lib/s390x/asm/mem.h
> +++ b/lib/s390x/asm/mem.h
> @@ -3,7 +3,7 @@
>   * Physical memory management related functions and definitions.
>   *
>   * Copyright IBM Corp. 2018
> - * Author(s): Janosch Frank <frankja@de.ibm.com>
> + * Author(s): Janosch Frank <frankja@linux.ibm.com>
>   */
>  #ifndef _ASMS390X_MEM_H_
>  #define _ASMS390X_MEM_H_
> diff --git a/lib/s390x/mmu.h b/lib/s390x/mmu.h
> index ab35d782..15f88e4f 100644
> --- a/lib/s390x/mmu.h
> +++ b/lib/s390x/mmu.h
> @@ -5,7 +5,7 @@
>   * Copyright (c) 2018 IBM Corp
>   *
>   * Authors:
> - *	Janosch Frank <frankja@de.ibm.com>
> + *	Janosch Frank <frankja@linux.ibm.com>
>   */
>  #ifndef _S390X_MMU_H_
>  #define _S390X_MMU_H_
> diff --git a/lib/s390x/stack.c b/lib/s390x/stack.c
> index 4cf80dae..e714e07c 100644
> --- a/lib/s390x/stack.c
> +++ b/lib/s390x/stack.c
> @@ -8,7 +8,7 @@
>   * Authors:
>   *  Thomas Huth <thuth@redhat.com>
>   *  David Hildenbrand <david@redhat.com>
> - *  Janosch Frank <frankja@de.ibm.com>
> + *  Janosch Frank <frankja@linux.ibm.com>
>   */
>  #include <libcflat.h>
>  #include <stack.h>
> diff --git a/s390x/gs.c b/s390x/gs.c
> index a017a97d..7567bb78 100644
> --- a/s390x/gs.c
> +++ b/s390x/gs.c
> @@ -6,7 +6,7 @@
>   *
>   * Authors:
>   *    Martin Schwidefsky <schwidefsky@de.ibm.com>
> - *    Janosch Frank <frankja@de.ibm.com>
> + *    Janosch Frank <frankja@linux.ibm.com>
>   */
>  #include <libcflat.h>
>  #include <asm/page.h>
> diff --git a/s390x/iep.c b/s390x/iep.c
> index 906c77b3..8d5e044b 100644
> --- a/s390x/iep.c
> +++ b/s390x/iep.c
> @@ -5,7 +5,7 @@
>   * Copyright (c) 2018 IBM Corp
>   *
>   * Authors:
> - *	Janosch Frank <frankja@de.ibm.com>
> + *	Janosch Frank <frankja@linux.ibm.com>
>   */
>  #include <libcflat.h>
>  #include <vmalloc.h>
> diff --git a/s390x/vector.c b/s390x/vector.c
> index fdb0eee2..c8c14e33 100644
> --- a/s390x/vector.c
> +++ b/s390x/vector.c
> @@ -5,7 +5,7 @@
>   * Copyright 2018 IBM Corp.
>   *
>   * Authors:
> - *    Janosch Frank <frankja@de.ibm.com>
> + *    Janosch Frank <frankja@linux.ibm.com>
>   */
>  #include <libcflat.h>
>  #include <asm/page.h>

