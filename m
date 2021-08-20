Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F1C3F2B84
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 13:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238238AbhHTLuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 07:50:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41788 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237633AbhHTLuO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Aug 2021 07:50:14 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17KBYaev040532;
        Fri, 20 Aug 2021 07:49:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=fjFlxc1cZ7kyLpUfI/9QuzhdKyGTWdauafcazmdaVNw=;
 b=B/aid60WcPOjPOMY06KcmVXyev9QpHXA0Et+bMSHBhXJB5m0HdR4rKPcZPNT4ahuoisJ
 H/Lecs1Ugj7AV9b7DSHlQ3HClzAk21c8jzCPuQT2o29dBi2iIwkBfopYiODOtkAEf+sZ
 A58GtzlCXsTY5ZhwUj0Z923BGmeOZbqc1a1UCSwzRVmqsvThMV4KG/uULaDre5Nyu51i
 O18H9nhamyXL4a0C6pYU6JuT8b7UNnU75HMtW6Svrd89WSWz3oPqs0dPdi1BLO1z+iU7
 dawmAgD95Pg3p+hAGoDh5l88h0MJvf9hNFwZOPlhtR5V/eigPPj/j1qY5F1hZ2eYLGPS tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ahkac8j67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 07:49:36 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17KBYqke041824;
        Fri, 20 Aug 2021 07:49:36 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ahkac8j59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 07:49:36 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17KBhHfu008004;
        Fri, 20 Aug 2021 11:49:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3ae5f8hr7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 11:49:34 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17KBnVTE55705908
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Aug 2021 11:49:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A825DAE04D;
        Fri, 20 Aug 2021 11:49:31 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F0B8AE056;
        Fri, 20 Aug 2021 11:49:31 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.193])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Aug 2021 11:49:31 +0000 (GMT)
Date:   Fri, 20 Aug 2021 13:49:23 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 3/3] lib: s390x: Control register
 constant cleanup
Message-ID: <20210820134923.1c59f4ec@p-imbrenda>
In-Reply-To: <20210820114000.166527-4-frankja@linux.ibm.com>
References: <20210820114000.166527-1-frankja@linux.ibm.com>
        <20210820114000.166527-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1oXtlDIIvTPTFAJ8j4ZEATzTmiQ-eMmC
X-Proofpoint-ORIG-GUID: bPC4SMXVN8w15A2diAxrrMeLYweIphoV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-20_03:2021-08-20,2021-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 clxscore=1015 mlxlogscore=999 suspectscore=0
 impostorscore=0 priorityscore=1501 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108200062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Aug 2021 11:40:00 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> We had bits and masks defined and don't necessarily need both.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/arch_def.h | 28 ++++++++++++----------------
>  lib/s390x/smp.c          |  3 ++-
>  s390x/skrf.c             |  3 ++-
>  3 files changed, 16 insertions(+), 18 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index ab5a9043..aa80d840 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -55,10 +55,18 @@ struct psw {
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
> +#define CR0_EXTM_MASK			0x0000000000006200UL /* Combined external masks */
> +
> +#define CTL2_GUARDED_STORAGE		(63 - 59)
>  
>  struct lowcore {
>  	uint8_t		pad_0x0000[0x0080 - 0x0000];	/* 0x0000 */
> @@ -240,18 +248,6 @@ static inline uint64_t stctg(int cr)
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
> index 228fe667..da6d32f3 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -10,6 +10,7 @@
>   *  Janosch Frank <frankja@linux.ibm.com>
>   */
>  #include <libcflat.h>
> +#include <bitops.h>
>  #include <asm/arch_def.h>
>  #include <asm/sigp.h>
>  #include <asm/page.h>
> @@ -204,7 +205,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
>  	cpu->lowcore->sw_int_grs[15] = (uint64_t)cpu->stack + (PAGE_SIZE * 4);
>  	lc->restart_new_psw.mask = PSW_MASK_64;
>  	lc->restart_new_psw.addr = (uint64_t)smp_cpu_setup_state;
> -	lc->sw_int_crs[0] = 0x0000000000040000UL;
> +	lc->sw_int_crs[0] = BIT_ULL(CTL0_AFP);
>  
>  	/* Start processing */
>  	smp_cpu_restart_nolock(addr, NULL);
> diff --git a/s390x/skrf.c b/s390x/skrf.c
> index 9488c32b..8ca7588c 100644
> --- a/s390x/skrf.c
> +++ b/s390x/skrf.c
> @@ -8,6 +8,7 @@
>   *  Janosch Frank <frankja@linux.ibm.com>
>   */
>  #include <libcflat.h>
> +#include <bitops.h>
>  #include <asm/asm-offsets.h>
>  #include <asm-generic/barrier.h>
>  #include <asm/interrupt.h>
> @@ -125,8 +126,8 @@ static void ecall_cleanup(void)
>  {
>  	struct lowcore *lc = (void *)0x0;
>  
> -	lc->sw_int_crs[0] = 0x0000000000040000;
>  	lc->ext_new_psw.mask = PSW_MASK_64;
> +	lc->sw_int_crs[0] = BIT_ULL(CTL0_AFP);
>  
>  	/*
>  	 * PGM old contains the ext new PSW, we need to clean it up,

