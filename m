Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E770A2F9C9C
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 11:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388758AbhARKA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 05:00:26 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48766 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389168AbhARJom (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 04:44:42 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10I94Z7q066679;
        Mon, 18 Jan 2021 04:43:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=g5bTtGK4YsiH4lgIBhWyxvLyKLrqrfOq5ojp65ETm+A=;
 b=sN4tlDaADIvsD4RVoT+4r+K+UlJt5wssGOjL116Yxb1hepv+DpwCFuXIYaWpHePA0vLg
 RvzJdJdbDrs4WtzehuE9Z/F4uL7/vWwM3+0X8ITD9hHHWHepNVMcxOxaeHUrRuC7iSWk
 7xyllHCV3waPnmQHUNPpKhS+j1UJwYdp2kVpMSBrfbY7vIA9pr/hCNmFKPc2Si8BQ2pR
 nGPgRlt1J/gN5mRDzh33zMvgux1NhrnFa+CiQq8ry7axuBjqBT2WSc66nhJ3zNDgfZum
 K1e6JLu/uFGHfkBduZBX8W+9gJg/xNJITmYlqwrCvrpQb1RXciar6p8Uexy62KNRqIWf oA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3657a697rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 04:43:59 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10I9H79P113936;
        Mon, 18 Jan 2021 04:43:59 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3657a697qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 04:43:59 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10I9Qtw4000832;
        Mon, 18 Jan 2021 09:43:56 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 363qs88ydh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 09:43:56 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10I9hr7323724490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 09:43:53 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C47D7AE053;
        Mon, 18 Jan 2021 09:43:53 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56446AE045;
        Mon, 18 Jan 2021 09:43:53 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.77.2])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 18 Jan 2021 09:43:53 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 0/9] s390x: Add SIE library and simple
 tests
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20210112132054.49756-1-frankja@linux.ibm.com>
Message-ID: <45420c5f-cf5f-a3bc-d555-6093d88a0c59@linux.ibm.com>
Date:   Mon, 18 Jan 2021 10:43:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210112132054.49756-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-18_07:2021-01-15,2021-01-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101180053
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/12/21 2:20 PM, Janosch Frank wrote:
> This is the absolute minimum needed to run VMs inside the KVM Unit
> Tests. It's more of a base for other tests that I can't (yet) publish
> than an addition of tests that check KVM functionality. However, I
> wanted to decrease the number of WIP patches in my private
> branch. Once the library is available maybe others will come and
> extend the SIE test itself.
> 
> Yes, I have added VM management functionality like VM create/destroy,
> etc but as it is not needed right now, I'd like to exclude it from
> this patch set for now.

I've picked patches 1-8.
Patch 9 is dropped for now, it's only a comment anyway.

Thanks for all of your review comments!

> 
> v4:
> 	* Removed asm directory and moved all asm files into s390x/ (I changed my view)
> 	* Review fixes
> 	* Removed a stray newline in the asm offsets file
> 
> v3:
> 	* Rebased on re-license patches
> 	* Split assembly
> 	* Now using ICPT_* constants
> 	* Added read_info asserts
> 	* Fixed missing spin_lock() in smp.c lib
> 	* Replaced duplicated code in sie test with generic intercept test
> 	* Replaced uv-guest.x bit testing with test_bit_inv()
> 	* Some other minor cleanups
> 
> Gitlab:
> https://gitlab.com/frankja/kvm-unit-tests/-/tree/sie
> 
> CI:
> https://gitlab.com/frankja/kvm-unit-tests/-/pipelines/240506525
> 
> 
> Janosch Frank (9):
>   s390x: Add test_bit to library
>   s390x: Consolidate sclp read info
>   s390x: SCLP feature checking
>   s390x: Split assembly into multiple files
>   s390x: sie: Add SIE to lib
>   s390x: sie: Add first SIE test
>   s390x: Add diag318 intercept test
>   s390x: Fix sclp.h style issues
>   s390x: sclp: Add CPU entry offset comment
> 
>  lib/s390x/asm-offsets.c  |  11 +++
>  lib/s390x/asm/arch_def.h |   9 ++
>  lib/s390x/asm/bitops.h   |  26 ++++++
>  lib/s390x/asm/facility.h |   3 +-
>  lib/s390x/interrupt.c    |   7 ++
>  lib/s390x/io.c           |   2 +
>  lib/s390x/sclp.c         |  57 +++++++++--
>  lib/s390x/sclp.h         | 181 +++++++++++++++++++----------------
>  lib/s390x/sie.h          | 197 +++++++++++++++++++++++++++++++++++++++
>  lib/s390x/smp.c          |  27 +++---
>  s390x/Makefile           |   7 +-
>  s390x/cstart64.S         | 119 +----------------------
>  s390x/intercept.c        |  19 ++++
>  s390x/lib.S              | 121 ++++++++++++++++++++++++
>  s390x/macros.S           |  77 +++++++++++++++
>  s390x/sie.c              | 113 ++++++++++++++++++++++
>  s390x/unittests.cfg      |   3 +
>  s390x/uv-guest.c         |   6 +-
>  18 files changed, 761 insertions(+), 224 deletions(-)
>  create mode 100644 lib/s390x/sie.h
>  create mode 100644 s390x/lib.S
>  create mode 100644 s390x/macros.S
>  create mode 100644 s390x/sie.c
> 

