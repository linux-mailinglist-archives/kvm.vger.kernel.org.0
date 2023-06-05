Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20EF722230
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 11:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbjFEJas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 05:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjFEJaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 05:30:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EFBA7;
        Mon,  5 Jun 2023 02:30:44 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3559KwCR029837;
        Mon, 5 Jun 2023 09:30:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nnFmlSPcS+xchhXxCXzdOQtU1A6t1VR9jgnrh4Of91U=;
 b=KUrruGMzFIGkJASRz9dxGmN+uH5yCbuctIMp6I+pDpR6HF2dunbxPBjiCQEySP1FrpWm
 mteW2wBKsGvjAue1MtxWFsfdGP7gPqoXlUIdeANHT3pNjkRNW421T2hwz2GmgZxA9i6K
 E9ksMGWS02CQdTCXG/oVy70VpgeW12AtmEKgUACFG3tGMIP3UYLlaZuOyvvoRo2gpepU
 x9SQBmyreQg0I7Tcy/xIdieMg8MBPPSwO2bXC4EzMv14H0rchvLB1AdzDInD5+Mf9GZ2
 h+qqYf7gRTrWdeQo+WBqcW5/nA8Y+ka/uMfAOcMpWHVUZaKXsjQ3Fdr+mm0GuDJ5olMh UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1d0dr721-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 09:30:43 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3559Lch8001310;
        Mon, 5 Jun 2023 09:30:43 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1d0dr717-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 09:30:43 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3555Wg1t025024;
        Mon, 5 Jun 2023 09:30:41 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3qyxdfh08g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 09:30:40 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3559Ub8R16450064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Jun 2023 09:30:37 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51CFD2004F;
        Mon,  5 Jun 2023 09:30:37 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0621C2004E;
        Mon,  5 Jun 2023 09:30:37 +0000 (GMT)
Received: from [9.171.39.161] (unknown [9.171.39.161])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  5 Jun 2023 09:30:36 +0000 (GMT)
Message-ID: <baf4bb04-b258-f8b4-e49d-5d400e498bbf@linux.ibm.com>
Date:   Mon, 5 Jun 2023 11:30:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230601070202.152094-1-nrb@linux.ibm.com>
 <20230601070202.152094-6-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 5/6] s390x: lib: sie: don't reenter SIE
 on pgm int
In-Reply-To: <20230601070202.152094-6-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PrdkkASx7ji4uL5MjpdxhwRm8pTIUsbj
X-Proofpoint-GUID: zE249KAgQTTRN2Dj5Mm5g0B7LAr4Soqf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0
 phishscore=0 mlxscore=0 mlxlogscore=496 impostorscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/23 09:02, Nico Boehr wrote:
> At the moment, when a PGM int occurs while in SIE, we will just reenter
> SIE after the interrupt handler was called.
> 
> This is because sie() has a loop which checks icptcode and re-enters SIE
> if it is zero.
> 
> However, this behaviour is quite undesirable for SIE tests, since it
> doesn't give the host the chance to assert on the PGM int. Instead, we
> will just re-enter SIE, on nullifing conditions even causing the
> exception again.

That's the reason why we set an invalid PGM PSW new for the assembly 
snippets. Seems like I didn't add it for C snippets for some reason -_-

This code is fine but it doesn't fully fix the usability aspect and 
leaves a few questions open:
  - Do we want to stick to the code 8 handling?
  - Do we want to assert like with validities and PGMs outside of SIE?
  - Should sie() have a int return code like in KVM?

> 
> In sie(), check whether a pgm int code is set in lowcore. If it has,
> exit the loop so the test can react to the interrupt. Add a new function
> read_pgm_int_code() to obtain the interrupt code.
> 
> Note that this introduces a slight oddity with sie and pgm int in
> certain cases: If a PGM int occurs between a expect_pgm_int() and sie(),
> we will now never enter SIE until the pgm_int_code is cleared by e.g.
> clear_pgm_int().
> 
> Also add missing include of facility.h to mem.h.

?

> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   lib/s390x/asm/interrupt.h | 14 ++++++++++++++
>   lib/s390x/asm/mem.h       |  1 +
>   lib/s390x/sie.c           |  4 +++-
>   3 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index 55759002dce2..fb4283a40a1b 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -99,4 +99,18 @@ static inline void low_prot_disable(void)
>   	ctl_clear_bit(0, CTL0_LOW_ADDR_PROT);
>   }
>   
> +/**
> + * read_pgm_int_code - Get the program interruption code of the last pgm int
> + * on the current CPU.

All of the other functions are in the c file.

> + *
> + * This is similar to clear_pgm_int(), except that it doesn't clear the
> + * interruption information from lowcore.
> + *
> + * Returns 0 when none occured.

s/r/rr/

> + */
> +static inline uint16_t read_pgm_int_code(void)
> +{

No mb()?

> +	return lowcore.pgm_int_code;
> +}
> +
>   #endif
> diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
> index 64ef59b546a4..94d58c34f53f 100644
> --- a/lib/s390x/asm/mem.h
> +++ b/lib/s390x/asm/mem.h
> @@ -8,6 +8,7 @@
>   #ifndef _ASMS390X_MEM_H_
>   #define _ASMS390X_MEM_H_
>   #include <asm/arch_def.h>
> +#include <asm/facility.h>
>   
>   /* create pointer while avoiding compiler warnings */
>   #define OPAQUE_PTR(x) ((void *)(((uint64_t)&lowcore) + (x)))
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index ffa8ec91a423..632740edd431 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -13,6 +13,7 @@
>   #include <libcflat.h>
>   #include <sie.h>
>   #include <asm/page.h>
> +#include <asm/interrupt.h>
>   #include <libcflat.h>
>   #include <alloc_page.h>
>   
> @@ -65,7 +66,8 @@ void sie(struct vm *vm)
>   	/* also handle all interruptions in home space while in SIE */
>   	irq_set_dat_mode(IRQ_DAT_ON, AS_HOME);
>   
> -	while (vm->sblk->icptcode == 0) {
> +	/* leave SIE when we have an intercept or an interrupt so the test can react to it */
> +	while (vm->sblk->icptcode == 0 && !read_pgm_int_code()) {
>   		sie64a(vm->sblk, &vm->save_area);
>   		sie_handle_validity(vm);
>   	}

