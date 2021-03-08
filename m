Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08E1330C11
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 12:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhCHLOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 06:14:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6572 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231601AbhCHLOa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 06:14:30 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128B457Z032164
        for <kvm@vger.kernel.org>; Mon, 8 Mar 2021 06:14:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JQQ+pfsxADTED4XQUetVnNfFyi4Q6iQqLcfIBeZHV+o=;
 b=TLnd1lfYmNeHIooXnS75+9rnm7obAg0+DZpMS0iwBBpwRzvESoa5fTTj7y3hylyIP5sH
 oEL4qGYzY76ISQ6QmHI15MTUfeBB6bBum60XVzoAM+r81V1ljltU//ILHhOCCABZ2AqP
 AJt77L4FZPiNA9Zep8UJl3n0u9scjLoO7VEZJXZyi0wW+x380BxnsoE+0o9ffzsFXvHk
 vGKvfsvfcVeaAmLDXFmBTNN8PZY+Ct1D/avM+cx0tTpG/oFbxS3xvUjVRXjqOuue6+bm
 /E+a/e+6xzE5hMZEC4gNPzF4njF/o4qkd/oHOsD35bNW/EY7HE/p0Ap2nIBTmjWhs05v 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 375j1hsdnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 06:14:29 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128B4aZH037331
        for <kvm@vger.kernel.org>; Mon, 8 Mar 2021 06:14:29 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 375j1hsdn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 06:14:28 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128B7wsW022491;
        Mon, 8 Mar 2021 11:14:27 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 37410h8wsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 11:14:27 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128BEOqC61735374
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 11:14:24 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11E754C044;
        Mon,  8 Mar 2021 11:14:24 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC15D4C046;
        Mon,  8 Mar 2021 11:14:23 +0000 (GMT)
Received: from [9.145.7.187] (unknown [9.145.7.187])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 11:14:23 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 0/3] s390x: mvpg test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com
References: <20210302114107.501837-1-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <19312596-d09a-41a1-95e9-992b6a307bfa@linux.ibm.com>
Date:   Mon, 8 Mar 2021 12:14:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210302114107.501837-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_04:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103080059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/2/21 12:41 PM, Claudio Imbrenda wrote:
> A simple unit test for the MVPG instruction.
> 
> The timeout is set to 10 seconds because the test should complete in a
> fraction of a second even on busy machines. If the test is run in VSIE
> and the host of the host is not handling MVPG properly, the test will
> probably hang.
> 
> Testing MVPG behaviour in VSIE is the main motivation for this test.
> 
> Anything related to storage keys is not tested.

Thanks, picked.

> 
> v3->v4
> * add memset after the first successful mvpg to make sure memory is really
>   copied successfully
> * add a comment and an additional prefix to the tests skipped when running
>   in TCG
> 
> v2->v3
> * fix copyright (2020 is over!)
> * add the third patch to skip some known issues when running in TCG
> 
> v1->v2
> * droppped patch 2 which introduced is_pgm();
> * patch 1: replace a hardcoded value with the new macro SVC_LEAVE_PSTATE
> * patch 2: clear_pgm_int() returns the old value, use that instad of is_pgm()
> 
> Claudio Imbrenda (3):
>   s390x: introduce leave_pstate to leave userspace
>   s390x: mvpg: simple test
>   s390x: mvpg: skip some tests when using TCG
> 
>  s390x/Makefile           |   1 +
>  lib/s390x/asm/arch_def.h |   7 +
>  lib/s390x/interrupt.c    |  12 +-
>  s390x/mvpg.c             | 277 +++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg      |   4 +
>  5 files changed, 299 insertions(+), 2 deletions(-)
>  create mode 100644 s390x/mvpg.c
> 

