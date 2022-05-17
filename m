Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D5252A118
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 14:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345783AbiEQMCv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 08:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345902AbiEQMC2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 08:02:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC254C7BB;
        Tue, 17 May 2022 05:02:14 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HBpL9i009117;
        Tue, 17 May 2022 12:02:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=1V3qfMP7nL4ZfrTHyCIqeTrezolsXmzb8QQIo/8ab6U=;
 b=tWXBIh7osC18oY6ZpfwtYfSo/KVPmQKC2CAXqelt+0PPAa9glwKtAsTr0kGhdCOyJkk9
 t5DVSJT5FjsiHZkTYRQd6jGPGX1hgqouOpHo36/8W1U14dhuGHd60jJN645w1YcZdrxX
 LWWLytCNiDgkCPJKuGHqFzQWbAy0WFKi/B2WCzSWPFSdEZjDjueap2DYlp6CAb1VSFb7
 4vDotSIzKlaiLBAaQMDu+Y2S2V0eo3RTgrDOGp0UU3q3TAudCyNgh/F2nVXzvIldMTrl
 IOyyD9NaX1WMelC5rpM7oKhQeWCLKZW0ptmcP4UEdQ6coqT9Rnv10YaJolp3qCcB/A/k 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4b6vr76e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 12:02:13 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HBu2R1026918;
        Tue, 17 May 2022 12:02:13 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4b6vr75t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 12:02:13 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HBpuUa020311;
        Tue, 17 May 2022 12:02:11 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3g23pjc5yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 12:02:11 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HC281K27001226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 12:02:08 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63CD0A4040;
        Tue, 17 May 2022 12:02:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F1B4A404D;
        Tue, 17 May 2022 12:02:08 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 12:02:08 +0000 (GMT)
Date:   Tue, 17 May 2022 14:02:06 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] s390x: Ignore gcc 12 warnings for low
 addresses
Message-ID: <20220517140206.6a58760f@p-imbrenda>
In-Reply-To: <20220516144332.3785876-1-scgl@linux.ibm.com>
References: <20220516144332.3785876-1-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: S6wcivYHsrfSMnsIM9FvogSnCEsTtOp5
X-Proofpoint-GUID: aqXL7ILivGjSW_8kEp0YXmp6YMTftlpd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_02,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015 mlxlogscore=999
 suspectscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 May 2022 16:43:32 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> gcc 12 warns if a memory operand to inline asm points to memory in the
> first 4k bytes. However, in our case, these operands are fine, either
> because we actually want to use that memory, or expect and handle the
> resulting exception.
> Therefore, silence the warning.

I really dislike this

> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
> 
> Alternatives:
>  * Use memory clobber instead of memory output
>    Use address in register input instead of memory input
>        (may require WRITE_ONCE)

this sounds better. would you also get rid of the asm("0") annotations
on the variables? I really dislike those too

>  * Disable the warning globally
>  * Don't use gcc 12.0, with newer versions --param=min-pagesize=0 might
>    avoid the problem
> 
>  lib/s390x/asm/cpacf.h | 7 +++++++
>  s390x/skey.c          | 7 +++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/lib/s390x/asm/cpacf.h b/lib/s390x/asm/cpacf.h
> index 685262b0..02e603c8 100644
> --- a/lib/s390x/asm/cpacf.h
> +++ b/lib/s390x/asm/cpacf.h
> @@ -152,6 +152,12 @@ static __always_inline void __cpacf_query(unsigned int opcode, cpacf_mask_t *mas
>  	register unsigned long r0 asm("0") = 0;	/* query function */
>  	register unsigned long r1 asm("1") = (unsigned long) mask;
>  
> +/*
> + * gcc 12.0.1 warns if mask is < 4k.
> + * We use such addresses to test invalid or protected mask arguments.
> + */
> +#pragma GCC diagnostic push
> +#pragma GCC diagnostic ignored "-Warray-bounds"
>  	asm volatile(
>  		"	spm 0\n" /* pckmo doesn't change the cc */
>  		/* Parameter regs are ignored, but must be nonzero and unique */
> @@ -160,6 +166,7 @@ static __always_inline void __cpacf_query(unsigned int opcode, cpacf_mask_t *mas
>  		: "=m" (*mask)
>  		: [fc] "d" (r0), [pba] "a" (r1), [opc] "i" (opcode)
>  		: "cc");
> +#pragma GCC diagnostic pop
>  }
>  
>  static inline int __cpacf_check_opcode(unsigned int opcode)
> diff --git a/s390x/skey.c b/s390x/skey.c
> index 32bf1070..7aa91d19 100644
> --- a/s390x/skey.c
> +++ b/s390x/skey.c
> @@ -242,12 +242,19 @@ static void test_store_cpu_address(void)
>   */
>  static void set_prefix_key_1(uint32_t *prefix_ptr)
>  {
> +/*
> + * gcc 12.0.1 warns if prefix_ptr is < 4k.
> + * We need such addresses to test fetch protection override.
> + */
> +#pragma GCC diagnostic push
> +#pragma GCC diagnostic ignored "-Warray-bounds"
>  	asm volatile (
>  		"spka	0x10\n\t"
>  		"spx	%0\n\t"
>  		"spka	0\n"
>  	     :: "Q" (*prefix_ptr)
>  	);
> +#pragma GCC diagnostic pop
>  }
>  
>  /*
> 
> base-commit: c315f52b88b967cfb4cd58f3b4e1987378c47f3b

