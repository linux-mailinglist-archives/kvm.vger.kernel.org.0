Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB6A1B2C0D
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 18:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgDUQNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 12:13:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32262 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725930AbgDUQNi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 12:13:38 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03LG2561083315
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 12:13:37 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmvh2h65-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 12:13:37 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Tue, 21 Apr 2020 17:13:00 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 21 Apr 2020 17:12:57 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03LGDU7k59506844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 16:13:31 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D74D7A405B;
        Tue, 21 Apr 2020 16:13:30 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C0D2A4054;
        Tue, 21 Apr 2020 16:13:30 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.93.219])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Apr 2020 16:13:30 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 00/10] s390x: Testing the Channel
 Subsystem I/O
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
References: <1582200043-21760-1-git-send-email-pmorel@linux.ibm.com>
Date:   Tue, 21 Apr 2020 18:13:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1582200043-21760-1-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20042116-0008-0000-0000-00000374D5D1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042116-0009-0000-0000-00004A969C3E
Message-Id: <028ece05-1429-7761-cf4e-6fabc34e6aa0@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_06:2020-04-20,2020-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 malwarescore=0 impostorscore=0 suspectscore=1 phishscore=0
 adultscore=0 mlxlogscore=938 clxscore=1015 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004210121
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-02-20 13:00, Pierre Morel wrote:

...snip...

> 
> 
> Pierre Morel (10):
>    s390x: saving regs for interrupts
>    s390x: Use PSW bits definitions in cstart
>    s390x: cr0: adding AFP-register control bit
>    s390x: export the clock get_clock_ms() utility

Please can you consider applying these 4 patches only.
I will send some changes I made for the patches on css tests.

I did not change the interrupt registration but since it is introduced 
for the css test patches I resend it with them.

Thanks,
Pierre

 >    s390x: interrupt registration

>    s390x: Library resources for CSS tests
>    s390x: css: stsch, enumeration test
>    s390x: css: msch, enable test
>    s390x: css: ssch/tsch with sense and interrupt
>    s390x: css: ping pong
> 
>   lib/s390x/asm/arch_def.h |  19 ++-
>   lib/s390x/asm/time.h     |  36 +++++
>   lib/s390x/css.h          | 277 +++++++++++++++++++++++++++++++
>   lib/s390x/css_dump.c     | 157 ++++++++++++++++++
>   lib/s390x/css_lib.c      |  55 +++++++
>   lib/s390x/interrupt.c    |  22 ++-
>   lib/s390x/interrupt.h    |   7 +
>   s390x/Makefile           |   3 +
>   s390x/css.c              | 341 +++++++++++++++++++++++++++++++++++++++
>   s390x/cstart64.S         |  40 +++--
>   s390x/intercept.c        |  11 +-
>   s390x/unittests.cfg      |   4 +
>   12 files changed, 946 insertions(+), 26 deletions(-)
>   create mode 100644 lib/s390x/asm/time.h
>   create mode 100644 lib/s390x/css.h
>   create mode 100644 lib/s390x/css_dump.c
>   create mode 100644 lib/s390x/css_lib.c
>   create mode 100644 lib/s390x/interrupt.h
>   create mode 100644 s390x/css.c
> 

-- 
Pierre Morel
IBM Lab Boeblingen

