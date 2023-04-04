Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602F26D5EDD
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 13:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbjDDLVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 07:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbjDDLVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 07:21:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8042EDC;
        Tue,  4 Apr 2023 04:21:31 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3349h24A013214;
        Tue, 4 Apr 2023 11:21:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MazeW6KjrWmiiFfjWeD9nX3wSyqA9tZfhSee1lfVrjk=;
 b=l0/rSxGfg6PmYhgYlgvACHwyo704lv9bqNn4oaBPcVut8zRB301TbM79GsC4/FhVcGsU
 jWYohWM/XnDMpzKiTFPp9cCMrrrNyoe6nlVMWyV3Mhbd0QOel4jL87JBFiUOlxEfMfxR
 VHq4ekatgFIvOOa4cZinDNBjlLy0d0TTWxCLydFAqCprcEIpJH9RSXEtKk+fjkx3H4q6
 vhJMhCm8YqGAfU8CaXr6EPjnH6KC7PzlIKOqplvyKCmZwlfFoIwx1BWWuRu2TvzWOwwX
 h6SdeuVbnaoCSwkSijtgqKrpVbjVeY9bBqJ+ocgtsjaAOdVZ1VN51rviHY3dkOd7wJ5M rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr3gs5ehy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:21:30 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334BHNel031069;
        Tue, 4 Apr 2023 11:21:30 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr3gs5ehh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:21:30 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3342m6tB012545;
        Tue, 4 Apr 2023 11:21:28 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ppc872f7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:21:28 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334BLOOL13501010
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 11:21:24 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B02E920049;
        Tue,  4 Apr 2023 11:21:24 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B05220040;
        Tue,  4 Apr 2023 11:21:24 +0000 (GMT)
Received: from [9.171.0.184] (unknown [9.171.0.184])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 11:21:24 +0000 (GMT)
Message-ID: <e41812d7-068a-200d-a816-cc933330462c@linux.ibm.com>
Date:   Tue, 4 Apr 2023 13:21:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [kvm-unit-tests PATCH] s390x/snippets: Fix compilation with Clang
 15
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nico Boehr <nrb@linux.ibm.com>
References: <20230404101434.172721-1-thuth@redhat.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230404101434.172721-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qaaiowAkqudrQ49q1_g052dMy9Gex27L
X-Proofpoint-ORIG-GUID: BvBWc3oKT8gxg_8c8ttb3OMZ8Idft8Jt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_04,2023-04-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 mlxlogscore=941 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040097
X-Spam-Status: No, score=-2.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/4/23 12:14, Thomas Huth wrote:
> Clang complains:
> 
>   s390x/snippets/c/cstart.S:22:13: error: invalid operand for instruction
>    lghi %r15, stackptr
>               ^
> Let's load the address with "larl" instead, like we already do
> it in s390x/cstart64.S. For this we should also switch to 64-bit
> mode first, then we also don't have to clear r15 right in front
> of this anymore.
> 
> Changing the code here triggered another problem: initial_cr0
> must be aligned on a double-word boundary, otherwise the lctlg
> instruction will fail with an specification exception. This was
> just working by accident so far - add an ".align 8" now to avoid
> the problem.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   s390x/snippets/c/cstart.S | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
> index a7d4cd42..c80ccfed 100644
> --- a/s390x/snippets/c/cstart.S
> +++ b/s390x/snippets/c/cstart.S
> @@ -15,12 +15,12 @@ start:
>   	larl	%r1, initial_cr0
>   	lctlg	%c0, %c0, 0(%r1)
>   	/* XOR all registers with themselves to clear them fully. */
> -	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14

Eh, I would have left that in, it doesn't hurt us after all.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

>   	xgr \i,\i
>   	.endr
> -	/* 0x3000 is the stack page for now */
> -	lghi	%r15, stackptr
>   	sam64
> +	/* 0x3000 is the stack page for now */
> +	larl	%r15, stackptr
>   	brasl	%r14, main
>   	/*
>   	 * If main() returns, we stop the CPU with the code below. We also
> @@ -37,6 +37,7 @@ exit:
>   	xgr	%r0, %r0
>   	sigp    %r2, %r0, SIGP_STOP
>   
> +	.align 8
>   initial_cr0:
>   	/* enable AFP-register control, so FP regs (+BFP instr) can be used */
>   	.quad	0x0000000000040000

