Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3212D4272
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 13:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731855AbgLIMwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 07:52:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40798 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728059AbgLIMwY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 07:52:24 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B9CbYWW100942;
        Wed, 9 Dec 2020 07:51:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hZ9Z2h64jsneGC5d3KZ3KxZY2mKxk2AXXQoBvEI4la0=;
 b=kkr1PeDIhqj1ryGIv0+QXMzikdX+I3wNeWC0PqxUSBG6sQpf1+J/qemsp9oPefLjh3Aw
 AsNgfMkf+n72VuR7EbPO011SL6sdQ/j7QC/hdgNbOxTLD5SCsjWV6tCDDbeR3gjILLnJ
 K7IIWGoLAq/W21mpV9dRX40DOGCJQSKB0BfArXr8nORjGCn3mmj753VbL5xBRNQ5Aqhc
 Riz/iOtAQnsT+gxfyZKo4Lv8sShXVL3jrf/CFbzNH9jEKr+GqU0NOeGu1mZr77E2O1vt
 5O+jEmi25/DuhfmKfXJEJOlvOtoy6ovRaX8HoIkMjHq90JfpTSSeA33kAExbTDjdayqw OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35avp1bu5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 07:51:44 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B9C39XR100963;
        Wed, 9 Dec 2020 07:51:43 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35avp1bu4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 07:51:43 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B9CiEUH015037;
        Wed, 9 Dec 2020 12:51:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3581u8ptjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 12:51:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B9CoOTL33817060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 12:50:24 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52C9E42045;
        Wed,  9 Dec 2020 12:50:24 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06D0B4203F;
        Wed,  9 Dec 2020 12:50:24 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.56.167])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Dec 2020 12:50:23 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: lib: Move to GPL 2 and SPDX
 license identifiers
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20201208150902.32383-1-frankja@linux.ibm.com>
 <20201208150902.32383-3-frankja@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <b385350a-5946-f3cd-b04c-a7eee2df52bf@linux.ibm.com>
Date:   Wed, 9 Dec 2020 13:50:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201208150902.32383-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_09:2020-12-09,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 mlxscore=0 spamscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090085
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/8/20 4:09 PM, Janosch Frank wrote:
> In the past we had some issues when developers wanted to use code
> snippets or constants from the kernel in a test or in the library. To
> remedy that the s390x maintainers decided to move all files to GPL 2
> (if possible).
> 
> At the same time let's move to SPDX identifiers as they are much nicer
> to read.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/asm-offsets.c     | 4 +---
>   lib/s390x/asm/arch_def.h    | 4 +---
>   lib/s390x/asm/asm-offsets.h | 4 +---
>   lib/s390x/asm/barrier.h     | 4 +---
>   lib/s390x/asm/cpacf.h       | 1 +
>   lib/s390x/asm/facility.h    | 4 +---
>   lib/s390x/asm/float.h       | 4 +---
>   lib/s390x/asm/interrupt.h   | 4 +---
>   lib/s390x/asm/io.h          | 4 +---
>   lib/s390x/asm/mem.h         | 4 +---
>   lib/s390x/asm/page.h        | 4 +---
>   lib/s390x/asm/pgtable.h     | 4 +---
>   lib/s390x/asm/sigp.h        | 4 +---
>   lib/s390x/asm/spinlock.h    | 4 +---
>   lib/s390x/asm/stack.h       | 4 +---
>   lib/s390x/asm/time.h        | 4 +---
>   lib/s390x/css.h             | 4 +---
>   lib/s390x/css_dump.c        | 4 +---
>   lib/s390x/css_lib.c         | 4 +---
>   lib/s390x/interrupt.c       | 4 +---
>   lib/s390x/io.c              | 4 +---
>   lib/s390x/mmu.c             | 4 +---
>   lib/s390x/mmu.h             | 4 +---
>   lib/s390x/sclp-console.c    | 5 +----
>   lib/s390x/sclp.c            | 4 +---
>   lib/s390x/sclp.h            | 5 +----
>   lib/s390x/smp.c             | 4 +---
>   lib/s390x/smp.h             | 4 +---
>   lib/s390x/stack.c           | 4 +---
>   lib/s390x/vm.c              | 3 +--
>   lib/s390x/vm.h              | 3 +--
>   31 files changed, 31 insertions(+), 90 deletions(-)
> 

Acked-by: Pierre Morel <pmorel@linux.ibm.com>

-- 
Pierre Morel
IBM Lab Boeblingen
