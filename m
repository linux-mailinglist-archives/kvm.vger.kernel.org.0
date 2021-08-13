Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE30B3EB2EE
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 10:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239799AbhHMIvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 04:51:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30616 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239804AbhHMIvS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 04:51:18 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D8h9JS020996;
        Fri, 13 Aug 2021 04:50:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=BWGB7X9OcJa6ubwWo4MM4rQ8reo+u8r0cTb51WRy3W0=;
 b=ihLYcpO3aV/aTvwG9uUjd1nesWBYVulFFA2+yofYO13/X1r3ZPtnxdbkK+uaz/KOobws
 GFvU9QzEFKQnfrUfNuLLHAma73Y2wJSR3rHpLMXslhofRBM7pbo9cvoKF6AlTw5a5/9t
 cIbS3WQQ6QBcmQ3syY97LQ5E5tDAom4YziZ/LMswzyPSvNXXr7jf63oM6OHUGY5toMV1
 im/pkqM4K+3azEG/6MB3DjuseGsGrEFtdqGaLVMr8qpdxMoETkBJWh91zHRfWiDPLHtM
 2mqb8A/ka+UuBNzj6pfXyUvHF9nUQeg7UirGOH0VxeWFa3rOBfeTLqAPaaHqKqqQu5Ng Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3acy93wwkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 04:50:51 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D8ZiRN140820;
        Fri, 13 Aug 2021 04:50:51 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3acy93wwjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 04:50:51 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17D8kVDP011507;
        Fri, 13 Aug 2021 08:50:48 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3ada8sgp59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 08:50:48 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17D8lUv146989726
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 08:47:30 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 405AA52050;
        Fri, 13 Aug 2021 08:50:46 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.9.6])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1091452075;
        Fri, 13 Aug 2021 08:50:46 +0000 (GMT)
Date:   Fri, 13 Aug 2021 10:46:21 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 6/8] lib: s390x: Add PSW_MASK_64
Message-ID: <20210813104621.08568cd9@p-imbrenda>
In-Reply-To: <20210813073615.32837-7-frankja@linux.ibm.com>
References: <20210813073615.32837-1-frankja@linux.ibm.com>
        <20210813073615.32837-7-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aUlfE-qcpRKubA8Hulx2nX6s5pkO-pmP
X-Proofpoint-ORIG-GUID: mquEULhgSw2Zo0O25Auqb0LWDOUf_g8z
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_03:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Aug 2021 07:36:13 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's replace the magic 0x0000000180000000ULL numeric constants with
> PSW_MASK_64 as it's used more often since the introduction of smp and
> sie.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/arch_def.h | 3 +++
>  lib/s390x/smp.c          | 2 +-
>  s390x/mvpg-sie.c         | 2 +-
>  s390x/sie.c              | 2 +-
>  s390x/skrf.c             | 6 +++---
>  5 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 39c5ba99..245453c3 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -50,6 +50,9 @@ struct psw {
>  #define PSW_MASK_DAT			0x0400000000000000UL
>  #define PSW_MASK_WAIT			0x0002000000000000UL
>  #define PSW_MASK_PSTATE			0x0001000000000000UL
> +#define PSW_MASK_EA			0x0000000100000000UL
> +#define PSW_MASK_BA			0x0000000080000000UL
> +#define PSW_MASK_64			PSW_MASK_BA | PSW_MASK_EA;
>  
>  #define CR0_EXTM_SCLP			0x0000000000000200UL
>  #define CR0_EXTM_EXTC			0x0000000000002000UL
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index ee68d676..228fe667 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -202,7 +202,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
>  	cpu->lowcore->sw_int_psw.addr = psw.addr;
>  	cpu->lowcore->sw_int_grs[14] = psw.addr;
>  	cpu->lowcore->sw_int_grs[15] = (uint64_t)cpu->stack +
> (PAGE_SIZE * 4);
> -	lc->restart_new_psw.mask = 0x0000000180000000UL;
> +	lc->restart_new_psw.mask = PSW_MASK_64;
>  	lc->restart_new_psw.addr = (uint64_t)smp_cpu_setup_state;
>  	lc->sw_int_crs[0] = 0x0000000000040000UL;
>  
> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
> index 70d2fcfa..ccc273b4 100644
> --- a/s390x/mvpg-sie.c
> +++ b/s390x/mvpg-sie.c
> @@ -100,7 +100,7 @@ static void setup_guest(void)
>  	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
>  
>  	vm.sblk->gpsw.addr = PAGE_SIZE * 4;
> -	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
> +	vm.sblk->gpsw.mask = PSW_MASK_64;
>  	vm.sblk->ictl = ICTL_OPEREXC | ICTL_PINT;
>  	/* Enable MVPG interpretation as we want to test KVM and not
> ourselves */ vm.sblk->eca = ECA_MVPGI;
> diff --git a/s390x/sie.c b/s390x/sie.c
> index ed2c3263..87575b29 100644
> --- a/s390x/sie.c
> +++ b/s390x/sie.c
> @@ -27,7 +27,7 @@ static struct vm vm;
>  static void test_diag(u32 instr)
>  {
>  	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
> -	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
> +	vm.sblk->gpsw.mask = PSW_MASK_64;
>  
>  	memset(guest_instr, 0, PAGE_SIZE);
>  	memcpy(guest_instr, &instr, 4);
> diff --git a/s390x/skrf.c b/s390x/skrf.c
> index 94e906a6..9488c32b 100644
> --- a/s390x/skrf.c
> +++ b/s390x/skrf.c
> @@ -125,15 +125,15 @@ static void ecall_cleanup(void)
>  {
>  	struct lowcore *lc = (void *)0x0;
>  
> -	lc->ext_new_psw.mask = 0x0000000180000000UL;
>  	lc->sw_int_crs[0] = 0x0000000000040000;
> +	lc->ext_new_psw.mask = PSW_MASK_64;
>  
>  	/*
>  	 * PGM old contains the ext new PSW, we need to clean it up,
>  	 * so we don't get a special operation exception on the lpswe
>  	 * of pgm old.
>  	 */
> -	lc->pgm_old_psw.mask = 0x0000000180000000UL;
> +	lc->pgm_old_psw.mask = PSW_MASK_64;
>  
>  	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>  	set_flag(1);
> @@ -148,7 +148,7 @@ static void ecall_setup(void)
>  	register_pgm_cleanup_func(ecall_cleanup);
>  	expect_pgm_int();
>  	/* Put a skey into the ext new psw */
> -	lc->ext_new_psw.mask = 0x00F0000180000000UL;
> +	lc->ext_new_psw.mask = 0x00F0000000000000UL | PSW_MASK_64;
>  	/* Open up ext masks */
>  	ctl_set_bit(0, CTL0_EXTERNAL_CALL);
>  	mask = extract_psw_mask();

