Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65C93D8BD6
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 12:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235946AbhG1Kcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 06:32:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5368 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232114AbhG1Kcl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 06:32:41 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SAE5OK099007;
        Wed, 28 Jul 2021 06:32:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=40NrGq23oGUfnUI6nlECkRT76bmGN3Yt3EMWIVvwu+k=;
 b=fa95nJDV4+o3Hpl/+CdjWnEVd2H4y6Gfzlhb2j1Gs2VYZCZlkrlIbtLcp2FUM3+iHv5B
 XHQlqVd85K7Jmryh2CD/DUQ9gUptJRKJQ/wbL/zFnhKBDSrb+EktE8BMYQeDM0PN/vfK
 pOHAmgdU/CSb+HYdonHCJeIeIQifif37bnkFLaxFfjCErzrWg6WllwcpK8N+/XWGXtmr
 ULsaacIzE/EMTsDoYTHciNIGZ+QYMbO/6+aX5wb3/97Jz2A3N52Bf56YarbecNGLC0V8
 5lJ6PH8gwxu7fPXln0XOvYjPL546VinjHdRerhfUksQDU+1ZBWn/x0U8kqLPaknAs1A7 IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a34xtgvs4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 06:32:33 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SAEIPB099612;
        Wed, 28 Jul 2021 06:32:33 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a34xtgvrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 06:32:33 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SACfAh026275;
        Wed, 28 Jul 2021 10:32:31 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3a235kgyxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:32:31 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SATk6732833966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 10:29:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7390011C077;
        Wed, 28 Jul 2021 10:32:28 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2959211C05B;
        Wed, 28 Jul 2021 10:32:28 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.9.194])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 10:32:28 +0000 (GMT)
Date:   Wed, 28 Jul 2021 12:28:53 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: Add SPDX and header comments
 for the snippets folder
Message-ID: <20210728122853.4f7e90ba@p-imbrenda>
In-Reply-To: <20210728101328.51646-3-frankja@linux.ibm.com>
References: <20210728101328.51646-1-frankja@linux.ibm.com>
        <20210728101328.51646-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 25z8vXDclGtaZE1yuw5n8XLBrrPqtfHG
X-Proofpoint-ORIG-GUID: L2RJXLTrqVaKMk2HnkC7hVLoc_STv_8L
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_07:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 clxscore=1015 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Jul 2021 10:13:27 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Seems like I missed adding them.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/snippets/c/cstart.S       | 9 +++++++++
>  s390x/snippets/c/mvpg-snippet.c | 9 +++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
> index 242568d6..a1754808 100644
> --- a/s390x/snippets/c/cstart.S
> +++ b/s390x/snippets/c/cstart.S
> @@ -1,3 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Start assembly for snippets
> + *
> + * Copyright (c) 2021 IBM Corp.
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
>  #include <asm/sigp.h>
>  
>  .section .init
> diff --git a/s390x/snippets/c/mvpg-snippet.c
> b/s390x/snippets/c/mvpg-snippet.c index c1eb5d77..e55caab4 100644
> --- a/s390x/snippets/c/mvpg-snippet.c
> +++ b/s390x/snippets/c/mvpg-snippet.c
> @@ -1,3 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Snippet used by the mvpg-sie.c test to check SIE PEI intercepts.
> + *
> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
>  #include <libcflat.h>
>  
>  static inline void force_exit(void)

