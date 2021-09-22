Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86183414541
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 11:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbhIVJhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 05:37:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5624 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234428AbhIVJhR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 05:37:17 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M80aN4029237;
        Wed, 22 Sep 2021 05:35:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Jc+yrN3iX9HOGp9i+voSmsZ5bGCf+5OLvIIOZbWOZ2k=;
 b=ltJNG6CEkf8aW3dQTBUYfSAIMH8Bz9ufY5ipKDtm+Wc+ODT55qq1x6/0pyj5sm2/xq/p
 mlkrc45Mj8NKG80aGuQWpn7YMf0Cp08Ak2R/3Y2Kb7XGQpatt5ZpJN9y5WNaZHqSyQOf
 Y94fNI0aiLQHEvx9KC+BJRWhfDEvQL6Aj4Kpd6e9DHDW9+eKqAqY9VWQZdm/xgg8GakG
 p9EwTgdjcVm4oQxWqzzJ40Egw2GULr5gTlw4jAZniwIqFu9treyooUSEZ60UcP2AwFL+
 zYRtp9Btmx8KC1Jv/pPR4295B9UXxxv8CrpiMNbuddNnxRqtUc0eWo4hoSdZn6J0RY9x iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b80kr9yru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 05:35:47 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M91XXP030024;
        Wed, 22 Sep 2021 05:35:47 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b80kr9yr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 05:35:47 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18M9Vfb2026383;
        Wed, 22 Sep 2021 09:35:45 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3b7q6jckph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 09:35:44 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18M9ZfP554198660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 09:35:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93C84AE045;
        Wed, 22 Sep 2021 09:35:41 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B3C3AE051;
        Wed, 22 Sep 2021 09:35:41 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.24])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 09:35:41 +0000 (GMT)
Date:   Wed, 22 Sep 2021 11:31:52 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        linux-s390@vger.kernel.org, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 8/9] s390x: Add sthyi cc==0 r2+1
 verification
Message-ID: <20210922113152.2489e72a@p-imbrenda>
In-Reply-To: <20210922071811.1913-9-frankja@linux.ibm.com>
References: <20210922071811.1913-1-frankja@linux.ibm.com>
        <20210922071811.1913-9-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JPc7P8T61Fz1-wsB_vRiqjotvoL3LNdV
X-Proofpoint-ORIG-GUID: J6Uc5GfylHdWRazH84KBm715PZnukn3V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_03,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Sep 2021 07:18:10 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> On success r2 + 1 should be 0, let's also check for that.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

but see comment below

> ---
>  s390x/sthyi.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/s390x/sthyi.c b/s390x/sthyi.c
> index db90b56f..4b153bf4 100644
> --- a/s390x/sthyi.c
> +++ b/s390x/sthyi.c
> @@ -24,16 +24,16 @@ static inline int sthyi(uint64_t vaddr, uint64_t fcode, uint64_t *rc,
>  {
>  	register uint64_t code asm("0") = fcode;
>  	register uint64_t addr asm("2") = vaddr;
> -	register uint64_t rc3 asm("3") = 0;
> +	register uint64_t rc3 asm("3") = 42;

I am not a big fan of the asm constraints, in the kernel we are
trying to move away from them, but I guess as long as it works it's ok

>  	int cc = 0;
>  
> -	asm volatile(".insn rre,0xB2560000,%[r1],%[r2]\n"
> -		     "ipm	 %[cc]\n"
> -		     "srl	 %[cc],28\n"
> -		     : [cc] "=d" (cc)
> -		     : [code] "d" (code), [addr] "a" (addr), [r1] "i" (r1),
> -		       [r2] "i" (r2)
> -		     : "memory", "cc", "r3");
> +	asm volatile(
> +		".insn   rre,0xB2560000,%[r1],%[r2]\n"
> +		"ipm     %[cc]\n"
> +		"srl     %[cc],28\n"
> +		: [cc] "=d" (cc), "+d" (rc3)
> +		: [code] "d" (code), [addr] "a" (addr), [r1] "i" (r1), [r2] "i" (r2)
> +		: "memory", "cc");
>  	if (rc)
>  		*rc = rc3;
>  	return cc;
> @@ -139,16 +139,18 @@ static void test_fcode0(void)
>  	struct sthyi_hdr_sctn *hdr;
>  	struct sthyi_mach_sctn *mach;
>  	struct sthyi_par_sctn *par;
> +	uint64_t rc = 42;
>  
>  	/* Zero destination memory. */
>  	memset(pagebuf, 0, PAGE_SIZE);
>  
>  	report_prefix_push("fcode 0");
> -	sthyi((uint64_t)pagebuf, 0, NULL, 0, 2);
> +	sthyi((uint64_t)pagebuf, 0, &rc, 0, 2);
>  	hdr = (void *)pagebuf;
>  	mach = (void *)pagebuf + hdr->INFMOFF;
>  	par = (void *)pagebuf + hdr->INFPOFF;
>  
> +	report(!rc, "r2 + 1 == 0");
>  	test_fcode0_hdr(hdr);
>  	test_fcode0_mach(mach);
>  	test_fcode0_par(par);

