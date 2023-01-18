Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6454667171A
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 10:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjARJIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 04:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjARJHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 04:07:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5237E46716
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 00:27:56 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30I7nv95032047
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:27:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Fe+/utfDvTgR5auipsiAgbBYHpMehoHKazfmwIQGFo4=;
 b=HmnfRopCNHLGqj2GZ4SM4iLTSP1XId8OksMx/UtD4+F1MPjM/k1P9mf1LmQXeHdInzAQ
 qleZPDOTAbUidSqUoSx0fXlEN9xUKRUyiNN6gafNRj7fHOLNlzCA8SCnozOWxC44zKpl
 iPjf0CD8gd/xCV82diyv6Ft2rSLD+4qkPesqfg7MnydA/MC53BrhPqOETynCwCp1Pzvj
 OrR7vLxnbD90u/hrNBh+Lig7S8/OhRjySDZZG/mVR6o4MmFFwLczLUFZFYUewI1IhzZS
 hFMQ7Qanq8q3alG8Ptbh8Pw8ohCSoVjmA1voDHDIVJAguiAnwLx6Adom1224oVXNxtU6 Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6cqprtwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:27:33 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30I7wmL0029847
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:27:33 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6cqprtw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 08:27:33 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30HLxYSh023792;
        Wed, 18 Jan 2023 08:27:30 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16myfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 08:27:30 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30I8RQX628639494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 08:27:26 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9069620040;
        Wed, 18 Jan 2023 08:27:26 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 321E12004B;
        Wed, 18 Jan 2023 08:27:26 +0000 (GMT)
Received: from [9.171.68.162] (unknown [9.171.68.162])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 08:27:26 +0000 (GMT)
Message-ID: <87ace2e2-8c0f-e4b7-addc-6ef04e8d29c4@linux.ibm.com>
Date:   Wed, 18 Jan 2023 09:27:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [kvm-unit-tests PATCH 6/9] s390x: define a macro for the stack
 frame size
Content-Language: en-US
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
 <20230116175757.71059-7-mhartmay@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230116175757.71059-7-mhartmay@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ssdaUQIv0BodCzI9RxB66CcjGOmDvWuC
X-Proofpoint-GUID: wG7N3Q44RyGrIwfmmhA56sH6PP_dG6w0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_03,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 adultscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301180070
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/16/23 18:57, Marc Hartmayer wrote:
> Define and use a macro for the stack frame size.

There are two more instances in s390x/macros.S and there might be some 
in s390x/gs.c.

> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>   lib/s390x/asm-offsets.c | 1 +
>   s390x/cstart64.S        | 2 +-
>   2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
> index f612f3277a95..188dd2e51181 100644
> --- a/lib/s390x/asm-offsets.c
> +++ b/lib/s390x/asm-offsets.c
> @@ -87,6 +87,7 @@ int main(void)
>   	OFFSET(STACK_FRAME_INT_GRS0, stack_frame_int, grs0);
>   	OFFSET(STACK_FRAME_INT_GRS1, stack_frame_int, grs1);
>   	DEFINE(STACK_FRAME_INT_SIZE, sizeof(struct stack_frame_int));
> +	DEFINE(STACK_FRAME_SIZE, sizeof(struct stack_frame));

I'm wondering why we didn't do this when Pierre introduced the int stacks...

>   
>   	return 0;
>   }
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index 6f83da2a6c0a..468ace3ea4df 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -38,7 +38,7 @@ start:
>   	/* setup stack */
>   	larl	%r15, stackptr
>   	/* Clear first stack frame */
> -	xc      0(160,%r15), 0(%r15)
> +	xc      0(STACK_FRAME_SIZE,%r15), 0(%r15)
>   	/* setup initial PSW mask + control registers*/
>   	larl	%r1, initial_psw
>   	lpswe	0(%r1)

