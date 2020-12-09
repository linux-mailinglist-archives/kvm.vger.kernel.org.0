Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A771E2D3FBD
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 11:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbgLIKRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 05:17:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51944 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729704AbgLIKRE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 05:17:04 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B9A3Q30118622;
        Wed, 9 Dec 2020 05:16:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=bGiPYYxyDtT5R796mwASU04D4pAGXLZxlqEIB30IpLg=;
 b=jIAyMk1LzT2ZCA8xWOSq1+wd5KWIo82Y86mY+jhf4dS7/A3UZkSH2Jaj3F/sB8GdbzUP
 lG/W3rkuPrGHCttJzo+sWKd0PtskMKDAOX99hmhCFwm+wcKBH2Ief8b030lPGnPWikVq
 2rpPEaYr5wdXNtXQ2GKJllGKiI+X7/OoKz7guqQY4LRsiKAWxLh6S/HJ8qEbkLkiO/zo
 ImdQ3MzhfgZbCu/KO4IPlr0HC2jX5HKW9+vv13g6NJciiRUEd6mwsgwEN69p5qnu1syA
 9JPYrK03e8xbDdxbabARI/Pcp2wEdrSJaeMZcROne60Pj+BV3vJugLHKPomIa3eYRMU7 2w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35afekcks8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 05:16:22 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B9A3oSh121357;
        Wed, 9 Dec 2020 05:16:22 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35afekckr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 05:16:21 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B9ADWu0000541;
        Wed, 9 Dec 2020 10:16:19 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3581fhmfu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 10:16:19 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B9AGHaj5440170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 10:16:17 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C1B64C058;
        Wed,  9 Dec 2020 10:16:17 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 107434C044;
        Wed,  9 Dec 2020 10:16:17 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.3.233])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Dec 2020 10:16:16 +0000 (GMT)
Date:   Wed, 9 Dec 2020 11:16:15 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 0/2] s390x: Move from LGPL 2 to GPL 2
Message-ID: <20201209111615.730e7789@ibm-vm>
In-Reply-To: <20201208150902.32383-1-frankja@linux.ibm.com>
References: <20201208150902.32383-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_08:2020-12-08,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 impostorscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  8 Dec 2020 10:09:00 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> KVM and the KVM unit tests should be able to share code to improve
> development speed and the LGPL is currently preventing us from doing
> exactly that. Additionally we have a multitude of different licenses
> in s390x files: GPL 2 only, GPL 2 or greater, LGPL 2 and LGPL 2.1 or
> later.
> 
> This patch set tries to move the licenses to GPL 2 where
> possible. Also we introduce the SPDX identifiers so the file headers
> are more readable.

whole series:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
 
> Janosch Frank (2):
>   s390x: Move to GPL 2 and SPDX license identifiers
>   s390x: lib: Move to GPL 2 and SPDX license identifiers
> 
>  lib/s390x/asm-offsets.c     | 4 +---
>  lib/s390x/asm/arch_def.h    | 4 +---
>  lib/s390x/asm/asm-offsets.h | 4 +---
>  lib/s390x/asm/barrier.h     | 4 +---
>  lib/s390x/asm/cpacf.h       | 1 +
>  lib/s390x/asm/facility.h    | 4 +---
>  lib/s390x/asm/float.h       | 4 +---
>  lib/s390x/asm/interrupt.h   | 4 +---
>  lib/s390x/asm/io.h          | 4 +---
>  lib/s390x/asm/mem.h         | 4 +---
>  lib/s390x/asm/page.h        | 4 +---
>  lib/s390x/asm/pgtable.h     | 4 +---
>  lib/s390x/asm/sigp.h        | 4 +---
>  lib/s390x/asm/spinlock.h    | 4 +---
>  lib/s390x/asm/stack.h       | 4 +---
>  lib/s390x/asm/time.h        | 4 +---
>  lib/s390x/css.h             | 4 +---
>  lib/s390x/css_dump.c        | 4 +---
>  lib/s390x/css_lib.c         | 4 +---
>  lib/s390x/interrupt.c       | 4 +---
>  lib/s390x/io.c              | 4 +---
>  lib/s390x/mmu.c             | 4 +---
>  lib/s390x/mmu.h             | 4 +---
>  lib/s390x/sclp-console.c    | 5 +----
>  lib/s390x/sclp.c            | 4 +---
>  lib/s390x/sclp.h            | 5 +----
>  lib/s390x/smp.c             | 4 +---
>  lib/s390x/smp.h             | 4 +---
>  lib/s390x/stack.c           | 4 +---
>  lib/s390x/vm.c              | 3 +--
>  lib/s390x/vm.h              | 3 +--
>  s390x/cmm.c                 | 4 +---
>  s390x/cpumodel.c            | 4 +---
>  s390x/css.c                 | 4 +---
>  s390x/cstart64.S            | 4 +---
>  s390x/diag10.c              | 4 +---
>  s390x/diag288.c             | 4 +---
>  s390x/diag308.c             | 5 +----
>  s390x/emulator.c            | 4 +---
>  s390x/gs.c                  | 4 +---
>  s390x/iep.c                 | 4 +---
>  s390x/intercept.c           | 4 +---
>  s390x/pfmf.c                | 4 +---
>  s390x/sclp.c                | 4 +---
>  s390x/selftest.c            | 4 +---
>  s390x/skey.c                | 4 +---
>  s390x/skrf.c                | 4 +---
>  s390x/smp.c                 | 4 +---
>  s390x/sthyi.c               | 4 +---
>  s390x/sthyi.h               | 4 +---
>  s390x/stsi.c                | 4 +---
>  s390x/uv-guest.c            | 4 +---
>  s390x/vector.c              | 4 +---
>  53 files changed, 53 insertions(+), 157 deletions(-)
> 

