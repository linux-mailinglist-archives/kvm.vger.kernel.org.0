Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229F3532440
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 09:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiEXHjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 03:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbiEXHjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 03:39:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D406FD26;
        Tue, 24 May 2022 00:39:40 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24O7TUbp011629;
        Tue, 24 May 2022 07:39:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=T7A1gXwazRwOzVz9nl8LmHHFt4+wV+gsvbENM/elEAo=;
 b=XIYclXdQ9/+UjQHW+uzsFgVFB5k7JX4QpOz1p4waZqphwFKTYrw01uI+Bc052hGRWp2i
 6Ama+ogk7Ezu0QgJ4QzgMUdAYuJOIu/sQSXamAaW13VJ02m4X5BcDvy2TpAnITSf9bNm
 9BvkZiS6sXu2qSivrpZmycEUKv2u9BAWCmXQ6NDy8chgqYhGHrfVZ/YO/90Sbn20Nm74
 HCnAuqnIEgIFpiNDiMFqnkoF/dtvsrZZDmKvCSojAWUKM4CXCyntlvxPjqTtmi6irqPH
 s+iKwCD4gX8CW85n77hfVsWbmaL4TEani9fbeIZJEbBwUb3huRw/NgnyWer2NXgsdTus vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8r4g3pxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 07:39:40 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24O6vFdP015746;
        Tue, 24 May 2022 07:39:40 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8r4g3px1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 07:39:39 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24O7WAim011762;
        Tue, 24 May 2022 07:39:37 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3g6qq9bady-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 07:39:37 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24O7PSjb54133008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 07:25:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B33142041;
        Tue, 24 May 2022 07:39:34 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B75D24203F;
        Tue, 24 May 2022 07:39:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.98])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 07:39:33 +0000 (GMT)
Date:   Tue, 24 May 2022 09:39:31 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 0/2] s390x: Avoid gcc 12 warnings
Message-ID: <20220524093931.623f9a2c@p-imbrenda>
In-Reply-To: <20220520140546.311193-1-scgl@linux.ibm.com>
References: <20220520140546.311193-1-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TvXVEiQP9gIuZIL_gyLnnVPgiRKJQ_8h
X-Proofpoint-ORIG-GUID: j7UP3fx3mBvbx3bGTTvrcPwISrxGihnx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_05,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1015 impostorscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205240041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 May 2022 16:05:44 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> gcc 12 warns if a memory operand to inline asm points to memory in the
> first 4k bytes. However, in our case, these operands are fine, either
> because we actually want to use that memory, or expect and handle the
> resulting exception.
> 
> v1 -> v2
>  * replace mechanism, don't use pragmas, instead use an extern symbol so
>    gcc cannot conclude that the pointer is <4k

this is a hack, but it's a nice hack

it gets rid of the compiler warning, and it also simplifies the
existing code.

> 
>    This new extern symbol refers to the lowcore. As a result, code
>    generation for lowcore accesses becomes worse.
> 
>    Alternatives:
>     * Don't use extern symbol for lowcore, just for problematic pointers
>     * Hide value from gcc via inline asm
>     * Disable the warning globally
>     * Use memory clobber instead of memory output
>       Use address in register input instead of memory input
>           (may require WRITE_ONCE)
>     * Don't use gcc 12.0, with newer versions --param=min-pagesize=0 might
>       avoid the problem
> 
> Janis Schoetterl-Glausch (2):
>   s390x: Introduce symbol for lowcore and use it
>   s390x: Fix gcc 12 warning about array bounds
> 
>  lib/s390x/asm/arch_def.h   |  2 ++
>  lib/s390x/asm/facility.h   |  4 +--
>  lib/s390x/asm/mem.h        |  4 +++
>  lib/s390x/css.h            |  2 --
>  lib/s390x/css_lib.c        | 12 ++++----
>  lib/s390x/fault.c          | 10 +++----
>  lib/s390x/interrupt.c      | 61 +++++++++++++++++++-------------------
>  lib/s390x/mmu.c            |  3 +-
>  s390x/flat.lds             |  1 +
>  s390x/snippets/c/flat.lds  |  1 +
>  s390x/css.c                |  4 +--
>  s390x/diag288.c            |  4 +--
>  s390x/edat.c               |  5 ++--
>  s390x/emulator.c           | 15 +++++-----
>  s390x/mvpg.c               |  7 ++---
>  s390x/sclp.c               |  3 +-
>  s390x/skey.c               |  2 +-
>  s390x/skrf.c               | 11 +++----
>  s390x/smp.c                | 23 +++++++-------
>  s390x/snippets/c/spec_ex.c |  5 ++--
>  20 files changed, 83 insertions(+), 96 deletions(-)
> 
> 
> base-commit: 8719e8326101c1be8256617caf5835b57e819339

