Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A663D3E95
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 19:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhGWQpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 12:45:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59318 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231166AbhGWQpI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Jul 2021 12:45:08 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16NH4Xtb141333;
        Fri, 23 Jul 2021 13:25:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=4fiIJ040t0eMXX2fU4CGCFRsRNnfNkAuXyjTAhbPuJ0=;
 b=om7p6PN59Bck0/x/fG8XADNGmzH9ASSu+HN1w2EAVTQPxlOTSXyid4pctcwoAj1bFdW4
 QOQGSSMyzQePbDaikhMFntb3YI1Y0/ey43TCKmSLOBmIAcazqw6iy/Q9VIdC4pzhmuzL
 tmUdtcEXNEGJ/+B9fXd393N1EJpi7aPoBz+GurI2fqvIGHgWGQXPjIzY3TZMCGhBOL9O
 FdEdpV3JdeCYPrTRcOvTgo641C2DosGf25SfPxNBABXNo7Is6/6UCNL5nCPKKP6pu6vi
 30ID6TE5TqpLyckeE5Q9pPT5CcwW/PqoI+BoaWEl7alQfCKkFcp39DfKYmf+L8hQA1zd Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a017thgwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 13:25:41 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16NH4ajY141733;
        Fri, 23 Jul 2021 13:25:40 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a017thgw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 13:25:40 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16NHHjE0026095;
        Fri, 23 Jul 2021 17:25:38 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 39vng72sfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 17:25:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16NHPZlx28049678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Jul 2021 17:25:35 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 935FA52050;
        Fri, 23 Jul 2021 17:25:35 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.87])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4AC995204E;
        Fri, 23 Jul 2021 17:25:35 +0000 (GMT)
Date:   Fri, 23 Jul 2021 19:25:29 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 5/5] lib: s390x: Print if a pgm happened
 while in SIE
Message-ID: <20210723192529.3dcca78b@p-imbrenda>
In-Reply-To: <20210629133322.19193-6-frankja@linux.ibm.com>
References: <20210629133322.19193-1-frankja@linux.ibm.com>
        <20210629133322.19193-6-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LENLWiVdtQH9ViBMGZ5T4uaouVeDwONQ
X-Proofpoint-GUID: rMovdXwtpTQlZE7Wv1qH7bMuniydocmq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-23_09:2021-07-23,2021-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2107230102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 29 Jun 2021 13:33:22 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> For debugging it helps if you know if the PGM happened while being in
> SIE or not.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

I agree with Conny regarding the style, unless you want to extend the
SIE printf to provide more information (maybe about the guest?)

> ---
>  lib/s390x/interrupt.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index b627942..76015b1 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -141,10 +141,21 @@ static void print_int_regs(struct
> stack_frame_int *stack) static void print_pgm_info(struct
> stack_frame_int *stack) 
>  {
> +	bool in_sie;
> +
> +	in_sie = (lc->pgm_old_psw.addr >= (uintptr_t)sie_entry &&
> +		  lc->pgm_old_psw.addr <= (uintptr_t)sie_exit);
> +
>  	printf("\n");
> -	printf("Unexpected program interrupt: %d on cpu %d at %#lx,
> ilen %d\n",
> -	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
> -	       lc->pgm_int_id);
> +	if (!in_sie)
> +		printf("Unexpected program interrupt: %d on cpu %d
> at %#lx, ilen %d\n",
> +		       lc->pgm_int_code, stap(),
> lc->pgm_old_psw.addr,
> +		       lc->pgm_int_id);
> +	else
> +		printf("Unexpected program interrupt in SIE: %d on
> cpu %d at %#lx, ilen %d\n",
> +		       lc->pgm_int_code, stap(),
> lc->pgm_old_psw.addr,
> +		       lc->pgm_int_id);
> +
>  	print_int_regs(stack);
>  	dump_stack();
>  	report_summary();

