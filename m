Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313B63EB2EA
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 10:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239823AbhHMIvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 04:51:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23716 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239744AbhHMIvQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 04:51:16 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D8gbaL065529;
        Fri, 13 Aug 2021 04:50:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=a6xpE8+wEbJ4fLo9Aqj5y0gBkQi/5E0SGzcFICG0ez8=;
 b=FK0eKbtzXHdDJHXFXIFQVpjrczpUsjRQUrDJxv9svs5nNk0sleyvjXuwFrk5on21cIdb
 7RVJGuetrb5vD6eEIeysp6NOMKTwkvUbYxG7kH5V/j9QDwfkqZcfgn2sr+Jyl2hZgCTJ
 1Dbchu78idmZ58L0J/7w9vqmWqVhvWhgwQ6BBH5l9Umk3mXAQKI33XO9gyZLC0Nzp+io
 bS4c4Vt262tvPKCXq/YBa84xOzsy6/3/i56PKZmXlwcpCanoGVAKkHftHUJcvQtI5+qq
 yAmtTTaRmykWo01+VN6xzXJuZp2oas5e94DSrs09LIXhvqt+KZEsGcPr/bSX7/P1GLh5 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad0qythjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 04:50:49 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D8ho24074231;
        Fri, 13 Aug 2021 04:50:49 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad0qythhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 04:50:49 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17D8l0bP005857;
        Fri, 13 Aug 2021 08:50:47 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3acf0kutdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 08:50:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17D8oiPr56492422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 08:50:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44FFC52057;
        Fri, 13 Aug 2021 08:50:44 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.9.6])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0910F52050;
        Fri, 13 Aug 2021 08:50:44 +0000 (GMT)
Date:   Fri, 13 Aug 2021 10:49:46 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 7/8] lib: s390x: Control register
 constant cleanup
Message-ID: <20210813104946.7e5b426f@p-imbrenda>
In-Reply-To: <20210813073615.32837-8-frankja@linux.ibm.com>
References: <20210813073615.32837-1-frankja@linux.ibm.com>
        <20210813073615.32837-8-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Kiz6We419HazvX76twhb5NVNDZloxH39
X-Proofpoint-ORIG-GUID: zDsqQbGmgf92pEjYhTddyNFVrMDYO-5F
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_01:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0
 clxscore=1015 phishscore=0 impostorscore=0 mlxscore=0 bulkscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108130050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Aug 2021 07:36:14 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> We had bits and masks defined and don't necessarily need both.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h | 29 +++++++++++++----------------
>  lib/s390x/smp.c          |  2 +-
>  s390x/skrf.c             |  2 +-
>  3 files changed, 15 insertions(+), 18 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 245453c3..4574a166 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -54,10 +54,19 @@ struct psw {
>  #define PSW_MASK_BA			0x0000000080000000UL
>  #define PSW_MASK_64			PSW_MASK_BA | PSW_MASK_EA;
>  
> -#define CR0_EXTM_SCLP			0x0000000000000200UL
> -#define CR0_EXTM_EXTC			0x0000000000002000UL
> -#define CR0_EXTM_EMGC			0x0000000000004000UL
> -#define CR0_EXTM_MASK			0x0000000000006200UL
> +#define CTL0_LOW_ADDR_PROT		(63 - 35)
> +#define CTL0_EDAT			(63 - 40)
> +#define CTL0_IEP			(63 - 43)
> +#define CTL0_AFP			(63 - 45)
> +#define CTL0_VECTOR			(63 - 46)
> +#define CTL0_EMERGENCY_SIGNAL		(63 - 49)
> +#define CTL0_EXTERNAL_CALL		(63 - 50)
> +#define CTL0_CLOCK_COMPARATOR		(63 - 52)
> +#define CTL0_SERVICE_SIGNAL		(63 - 54)
> +#define CR0_EXTM_MASK			0x0000000000006200UL /*
> Combined external masks */
> +#define BIT_TO_MASK64(x)		1UL << x

don't we already have BIT and BIT_ULL?

> +#define CTL2_GUARDED_STORAGE		(63 - 59)
>  
>  struct lowcore {
>  	uint8_t		pad_0x0000[0x0080 - 0x0000];
> /* 0x0000 */ @@ -239,18 +248,6 @@ static inline uint64_t stctg(int cr)
>  	return value;
>  }
>  
> -#define CTL0_LOW_ADDR_PROT	(63 - 35)
> -#define CTL0_EDAT		(63 - 40)
> -#define CTL0_IEP		(63 - 43)
> -#define CTL0_AFP		(63 - 45)
> -#define CTL0_VECTOR		(63 - 46)
> -#define CTL0_EMERGENCY_SIGNAL	(63 - 49)
> -#define CTL0_EXTERNAL_CALL	(63 - 50)
> -#define CTL0_CLOCK_COMPARATOR	(63 - 52)
> -#define CTL0_SERVICE_SIGNAL	(63 - 54)
> -
> -#define CTL2_GUARDED_STORAGE	(63 - 59)
> -
>  static inline void ctl_set_bit(int cr, unsigned int bit)
>  {
>          uint64_t reg;
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index 228fe667..c2c6ffec 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -204,7 +204,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
>  	cpu->lowcore->sw_int_grs[15] = (uint64_t)cpu->stack +
> (PAGE_SIZE * 4); lc->restart_new_psw.mask = PSW_MASK_64;
>  	lc->restart_new_psw.addr = (uint64_t)smp_cpu_setup_state;
> -	lc->sw_int_crs[0] = 0x0000000000040000UL;
> +	lc->sw_int_crs[0] = BIT_TO_MASK64(CTL0_AFP);
>  
>  	/* Start processing */
>  	smp_cpu_restart_nolock(addr, NULL);
> diff --git a/s390x/skrf.c b/s390x/skrf.c
> index 9488c32b..a350ada6 100644
> --- a/s390x/skrf.c
> +++ b/s390x/skrf.c
> @@ -125,8 +125,8 @@ static void ecall_cleanup(void)
>  {
>  	struct lowcore *lc = (void *)0x0;
>  
> -	lc->sw_int_crs[0] = 0x0000000000040000;
>  	lc->ext_new_psw.mask = PSW_MASK_64;
> +	lc->sw_int_crs[0] = BIT_TO_MASK64(CTL0_AFP);
>  
>  	/*
>  	 * PGM old contains the ext new PSW, we need to clean it up,

