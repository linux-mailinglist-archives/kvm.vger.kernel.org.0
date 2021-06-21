Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC133AEB8F
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 16:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhFUOl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 10:41:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21542 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230212AbhFUOl5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 10:41:57 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15LEWnPW125386;
        Mon, 21 Jun 2021 10:39:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=z/DFzT+YOC9dsZVLuO9g0lDmsi0PoQNKqK2skObeE6s=;
 b=rovFXbbv+wsEpK2Vm4t16ZDY7H5Cq5k7HZyoyM2NnkFCfH1l6ia5szWiLRq/aphoGTmh
 p1I28dDlIxtIUB2gIJGyoNwNhjF8IKd5dHQQsaCx9/boDgkw/z9GSfdctE48+xNdmYQu
 Ct7LumG6pLT2/EY/TLEY2oY5FkORn2Y+xMo3AVdvTRmisAMFwPMx4mG2dFAOsGIs2KR4
 DMm3H65p91+22Zuqftg/IBCQ8sXn/7r1dueZySOKF/p+r9I3+R/xp8DLgjhwxeCv7wO8
 MIF55P++oJBoXf8EKedLLGBxztujp5vhHO+szEIjgrQghjOccBZevSaltjn08gqlYH91 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39avbj0vrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 10:39:43 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15LEXpvJ128948;
        Mon, 21 Jun 2021 10:39:42 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39avbj0vqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 10:39:42 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15LEV45d009103;
        Mon, 21 Jun 2021 14:39:41 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 399878rh2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 14:39:40 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15LEdbCv9503162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 14:39:37 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38A1F4204F;
        Mon, 21 Jun 2021 14:39:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF00142042;
        Mon, 21 Jun 2021 14:39:36 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.9.205])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Jun 2021 14:39:36 +0000 (GMT)
Date:   Mon, 21 Jun 2021 16:39:35 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: get rid of register asm usage
Message-ID: <20210621163935.143dd14a@ibm-vm>
In-Reply-To: <20210621140356.1210771-1-hca@linux.ibm.com>
References: <20210621140356.1210771-1-hca@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: inAKNl4Un0-jkzLLE9IsHowPRx83J7Li
X-Proofpoint-ORIG-GUID: phXaZnB9DaYvxCjT8uyms4UQmsNMk-j-
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-21_06:2021-06-21,2021-06-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 clxscore=1015 mlxlogscore=999 priorityscore=1501 spamscore=0
 malwarescore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106210086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Jun 2021 16:03:56 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> Using register asm statements has been proven to be very error prone,
> especially when using code instrumentation where gcc may add function
> calls, which clobbers register contents in an unexpected way.
> 
> Therefore get rid of register asm statements in kvm code, even though
> there is currently nothing wrong with them. This way we know for sure
> that this bug class won't be introduced here.
> 
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 1296fc10f80c..4b7b24f07790 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -329,31 +329,31 @@ static void allow_cpu_feat(unsigned long nr)
>  
>  static inline int plo_test_bit(unsigned char nr)
>  {
> -	register unsigned long r0 asm("0") = (unsigned long) nr |
> 0x100;
> +	unsigned long function = (unsigned long) nr | 0x100;
>  	int cc;
>  
>  	asm volatile(
> +		"	lgr	0,%[function]\n"
>  		/* Parameter registers are ignored for "test bit" */
>  		"	plo	0,0,0,0(0)\n"
>  		"	ipm	%0\n"
>  		"	srl	%0,28\n"
>  		: "=d" (cc)
> -		: "d" (r0)
> -		: "cc");
> +		: [function] "d" (function)
> +		: "cc", "0");
>  	return cc == 0;
>  }
>  
>  static __always_inline void __insn32_query(unsigned int opcode, u8
> *query) {
> -	register unsigned long r0 asm("0") = 0;	/* query
> function */
> -	register unsigned long r1 asm("1") = (unsigned long) query;
> -
>  	asm volatile(
> -		/* Parameter regs are ignored */
> +		"	lghi	0,0\n"
> +		"	lgr	1,%[query]\n"
> +		/* Parameter registers are ignored */
>  		"	.insn	rrf,%[opc] << 16,2,4,6,0\n"
>  		:
> -		: "d" (r0), "a" (r1), [opc] "i" (opcode)
> -		: "cc", "memory");
> +		: [query] "d" ((unsigned long)query), [opc] "i"
> (opcode)
> +		: "cc", "memory", "0", "1");
>  }
>  
>  #define INSN_SORTL 0xb938

