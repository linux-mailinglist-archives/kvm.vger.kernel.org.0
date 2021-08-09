Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5CB3E43D1
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 12:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhHIKWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 06:22:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1498 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234346AbhHIKWq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 06:22:46 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179A5415100723;
        Mon, 9 Aug 2021 06:22:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=QK5HRCTT1Nau4AGVm7VBIHikOPPgNP/EKfouBTaB1J4=;
 b=sm0rW+j06IcpvD4V3rYNheYJ4cKjv24QkkBovEwDiPY8c1afOanHdPqXiRIaQyYivFnX
 rysUhd5wXl4XIEk4+66jDTUTqOGtch4kyTbIBZJMScAr9GZfjJRM3R4LH+YHsbvBckAM
 +KtBSY4CBvm4heK6gOdHAkwLZ+3cYItiIKsDe915y2tTsVAMWtIOPjLOVDnYhfbz8LW2
 axN+kYnv4shPtHlbq8//mqydf20mbat+QgXG6dLA3GuY4k+2O1K3QIR5UYTGbqPRIUwJ
 cKL6EXPnVMR1iFmxnfq5zyx58NV31DFNUSieuyEyX+j9Z0k3Ih/ARqIpGf1HSuh63OM0 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aa7fbudnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 06:22:25 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 179A5H4T101715;
        Mon, 9 Aug 2021 06:22:24 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aa7fbudnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 06:22:24 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 179AC32h014375;
        Mon, 9 Aug 2021 10:22:22 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3a9hehbtb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 10:22:22 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 179AJCoM61735172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 10:19:13 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6957552052;
        Mon,  9 Aug 2021 10:22:19 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.6.223])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2190652051;
        Mon,  9 Aug 2021 10:22:19 +0000 (GMT)
Date:   Mon, 9 Aug 2021 11:53:56 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/4] s390x: lib: Move stsi_get_fc to
 library
Message-ID: <20210809115356.2412ad87@p-imbrenda>
In-Reply-To: <1628498934-20735-3-git-send-email-pmorel@linux.ibm.com>
References: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
        <1628498934-20735-3-git-send-email-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2GXitp6G8B96B-vMlCkJfDSX3fNkp8FI
X-Proofpoint-GUID: uqjanAQRerCxgn7WKb77vnTEClVK7Ms3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_03:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 clxscore=1015 impostorscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  9 Aug 2021 10:48:52 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> It's needed in multiple tests now.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/arch_def.h | 16 ++++++++++++++++
>  s390x/stsi.c             | 16 ----------------
>  2 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 15cf7d48..57d7ddac 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -328,6 +328,22 @@ static inline int stsi(void *addr, int fc, int
> sel1, int sel2) return cc;
>  }
>  
> +static inline unsigned long stsi_get_fc(void *addr)
> +{
> +	register unsigned long r0 asm("0") = 0;
> +	register unsigned long r1 asm("1") = 0;
> +	int cc;
> +
> +	asm volatile("stsi	0(%[addr])\n"
> +		     "ipm	%[cc]\n"
> +		     "srl	%[cc],28\n"
> +		     : "+d" (r0), [cc] "=d" (cc)
> +		     : "d" (r1), [addr] "a" (addr)
> +		     : "cc", "memory");
> +	assert(!cc);
> +	return r0 >> 28;
> +}
> +
>  static inline int servc(uint32_t command, unsigned long sccb)
>  {
>  	int cc;
> diff --git a/s390x/stsi.c b/s390x/stsi.c
> index 87d48047..11986d13 100644
> --- a/s390x/stsi.c
> +++ b/s390x/stsi.c
> @@ -71,22 +71,6 @@ static void test_priv(void)
>  	report_prefix_pop();
>  }
>  
> -static inline unsigned long stsi_get_fc(void *addr)
> -{
> -	register unsigned long r0 asm("0") = 0;
> -	register unsigned long r1 asm("1") = 0;
> -	int cc;
> -
> -	asm volatile("stsi	0(%[addr])\n"
> -		     "ipm	%[cc]\n"
> -		     "srl	%[cc],28\n"
> -		     : "+d" (r0), [cc] "=d" (cc)
> -		     : "d" (r1), [addr] "a" (addr)
> -		     : "cc", "memory");
> -	assert(!cc);
> -	return r0 >> 28;
> -}
> -
>  static void test_fc(void)
>  {
>  	report(stsi(pagebuf, 7, 0, 0) == 3, "invalid fc");

