Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C2E48E90E
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 12:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240762AbiANLUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 06:20:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57242 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231167AbiANLUD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 06:20:03 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EARUWK012117;
        Fri, 14 Jan 2022 11:20:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=MhFSHn+JpaSdPL3NMabiVZW1branBjILEJeL4SuQafY=;
 b=MZctEt1pDq9NvW5l6xP6vIm56nv+UfWkYMVOYGn+4d3pEksHPmAqSb2O4VOiG8Sar0P/
 CCEf77p3BopmROTLjPY+StHc+i5fInXaEghAXprTm7IwsgB8TlB88d1mbpbbnGTQ690Z
 P2KLjDj2HjVE3asCD12U0L5x/SXIelG9xuw2hk9i3isZebD9VywMZ1PrpfXSPLQY8fTj
 D0t4D2Ns7eA7ciO8EemWbM+D44Vs6eA1Bwl2Nn6o0lhGhZFDH1sMGutqFTcL3QZAZLe4
 admMeTBrUUhtajE0IudGKOXjsY3LFgX5biOfeCId15zllairg1nZEyuOpo/fki4azeL8 Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk620jbbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 11:20:02 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EAgO0Q032305;
        Fri, 14 Jan 2022 11:20:02 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk620jbb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 11:20:02 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EBDTUc015325;
        Fri, 14 Jan 2022 11:20:00 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3df28a2pkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 11:20:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EBJvBE45744602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 11:19:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB3164C05C;
        Fri, 14 Jan 2022 11:19:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B5454C04E;
        Fri, 14 Jan 2022 11:19:56 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.156])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 11:19:56 +0000 (GMT)
Date:   Fri, 14 Jan 2022 12:18:47 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 4/5] s390x: smp: Allocate memory in DMA31
 space
Message-ID: <20220114121847.6db88e1f@p-imbrenda>
In-Reply-To: <20220114100245.8643-5-frankja@linux.ibm.com>
References: <20220114100245.8643-1-frankja@linux.ibm.com>
        <20220114100245.8643-5-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 56FOyW1-7nTgSR8qw6LjRc5f0C-2gPMN
X-Proofpoint-GUID: WDzwJpNlNHzon9SoPFhWPP_FLz9ivYQj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_04,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 phishscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201140074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jan 2022 10:02:44 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The store status at address order works with 31 bit addresses so let's
> use them.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/smp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 32f128b3..c91f170b 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -124,7 +124,7 @@ static void test_stop_store_status(void)
>  
>  static void test_store_status(void)
>  {
> -	struct cpu_status *status = alloc_pages(1);
> +	struct cpu_status *status = alloc_pages_flags(1, AREA_DMA31);
>  	uint32_t r;
>  
>  	report_prefix_push("store status at address");
> @@ -244,7 +244,7 @@ static void test_func_initial(void)
>  
>  static void test_reset_initial(void)
>  {
> -	struct cpu_status *status = alloc_pages(0);
> +	struct cpu_status *status = alloc_pages_flags(1, AREA_DMA31);
>  	struct psw psw;
>  	int i;
>  

