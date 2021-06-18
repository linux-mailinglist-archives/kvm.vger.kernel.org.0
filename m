Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F9F3AC512
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 09:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhFRHjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 03:39:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52822 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230413AbhFRHjC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 03:39:02 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15I7WpRP046053;
        Fri, 18 Jun 2021 03:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=DlYrtjWBHzw+KmSquw4v2hHh+QcBMyWfjJXzYe402nk=;
 b=JnzRdKpM2n8BH5HWIyZsAM03mhUNkNBkXNuVmR9jpJV3ywkAwKLRosJ6NdbxiUt9TkEw
 B2dSLObjAqFzVHF9VT4yMH5Lj6Hc8gwTy5SWyfED2VcQXNr3Fbt9aKoB8l861VCVgMRq
 Pi9qLQLHq1BklzSoiWOe1IHFVZGT9kvg8BmXRHoUUHiu370AL/9az3tWbC0PK0UpivvX
 Y2e3B5ARmCgTBRJHm9+XQ6m5dqjB2s4JU/vxRjjD12w9QJQXkKtcLvifONtpfjWjDx76
 5f8328vbN4nsnQCg2k8tkxWuA7Ni1A7AicNzStHT2GrfSW94+JMrhrVJaiJe7dcBcSFO +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 398nvatju4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Jun 2021 03:36:52 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15I7aQIw060893;
        Fri, 18 Jun 2021 03:36:52 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 398nvatjte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Jun 2021 03:36:52 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15I7Nfgn027110;
        Fri, 18 Jun 2021 07:36:50 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 394mj8hrbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Jun 2021 07:36:50 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15I7ZbFf29360562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 07:35:37 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 292C542042;
        Fri, 18 Jun 2021 07:36:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9A7342049;
        Fri, 18 Jun 2021 07:36:47 +0000 (GMT)
Received: from linux.fritz.box (unknown [9.145.172.21])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Jun 2021 07:36:47 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 0/7] s390: Add support for large pages
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <20210611140705.553307-1-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <4adc92a9-d252-49e5-7877-079c9239a017@linux.ibm.com>
Date:   Fri, 18 Jun 2021 09:36:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210611140705.553307-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Nevv5YPVRvEZtMbhE9QeXWLJXfpoiP1p
X-Proofpoint-ORIG-GUID: hPTgHxbqyRKOFIb9ZQdImMddTsHY23Zc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_17:2021-06-15,2021-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106180042
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/11/21 4:06 PM, Claudio Imbrenda wrote:
> Introduce support for large (1M) and huge (2G) pages.
> 
> Add a simple testcase for EDAT1 and EDAT2.
> 
> v4->v5
> * fixed some typos and comment style issues
> * introduced enum pgt_level, switched all functions to use it
> 
> v3->v4
> * replace macros in patch 5 with a union representing TEID fields
> * clear the teid in expect_pgm_int and clear_pgm_int
> * update testcase to use expect_pgm_int, remove expect_dat_fault
> * update testcase to use teid union
> 
> v2->v3
> * Add proper macros for control register bits
> * Improved patch titles and descriptions
> * Moved definition of TEID bits to library
> * Rebased on the lastest upstream branch
> 
> v1->v2
> 
> * split patch 2 -> new patch 2 and new patch 3
> * patch 2: fixes pgtable.h, also fixes wrong usage of REGION_TABLE_LENGTH
>   instead of SEGMENT_TABLE_LENGTH
> * patch 3: introduces new macros and functions for large pages
> * patch 4: remove erroneous double call to pte_alloc in get_pte
> * patch 4: added comment in mmu.c to bridge the s390x architecural names
>   with the Linux ones used in the kvm-unit-tests
> * patch 5: added and fixed lots of comments to explain what's going on
> * patch 5: set FC for region 3 after writing the canary, like for segments
> * patch 5: use uintptr_t instead of intptr_t for set_prefix
> * patch 5: introduce new macro PGD_PAGE_SHIFT instead of using magic value 41
> * patch 5: use VIRT(0) instead of mem to make it more clear what we are
>   doing, even though VIRT(0) expands to mem


Thanks, picked

> 
> 
> Claudio Imbrenda (7):
>   s390x: lib: add and use macros for control register bits
>   libcflat: add SZ_1M and SZ_2G
>   s390x: lib: fix pgtable.h
>   s390x: lib: Add idte and other huge pages functions/macros
>   s390x: lib: add teid union and clear teid from lowcore
>   s390x: mmu: add support for large pages
>   s390x: edat test
> 
>  s390x/Makefile            |   1 +
>  lib/s390x/asm/arch_def.h  |  12 ++
>  lib/s390x/asm/float.h     |   4 +-
>  lib/s390x/asm/interrupt.h |  28 +++-
>  lib/s390x/asm/pgtable.h   |  44 +++++-
>  lib/libcflat.h            |   2 +
>  lib/s390x/mmu.h           |  84 +++++++++++-
>  lib/s390x/interrupt.c     |   2 +
>  lib/s390x/mmu.c           | 262 ++++++++++++++++++++++++++++++++----
>  lib/s390x/sclp.c          |   4 +-
>  s390x/diag288.c           |   2 +-
>  s390x/edat.c              | 274 ++++++++++++++++++++++++++++++++++++++
>  s390x/gs.c                |   2 +-
>  s390x/iep.c               |   4 +-
>  s390x/skrf.c              |   2 +-
>  s390x/smp.c               |   8 +-
>  s390x/vector.c            |   2 +-
>  s390x/unittests.cfg       |   3 +
>  18 files changed, 691 insertions(+), 49 deletions(-)
>  create mode 100644 s390x/edat.c
> 

