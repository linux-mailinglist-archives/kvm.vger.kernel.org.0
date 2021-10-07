Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FE8424E19
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 09:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240386AbhJGHdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 03:33:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36434 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232512AbhJGHdI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 03:33:08 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1975cJFa030078;
        Thu, 7 Oct 2021 03:31:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=B0qkFTd6g4Std0IKONpDuBg40uOotITlTj7dqZmFdYA=;
 b=SqM/+1CfhM6XTE0OZ+yLWEpWrB75+nK8JCHr3jtG3JDEZRwI9BkmF4a5Xb7ZXBEsOzdf
 Xfjjt8+66vA2e4eBCJPdIjKoAfSKLQRDRwpg60mc4OZT+ENjM3PJOWRHeJsoJq0nSX1R
 ftZkLUcv4SEOTbk4O1sfs/PZr3dqy1Dt7WBxL5Ma8AnDq1HeZqKOKMsBtF5ylBZ9CGre
 mmBilRkhcMePTJr5Q44s1a5BfLgHM6ntkoGMb2vthZp/AN3cVaR1F9xGMDKtd6N71KCr
 51qjXIe/IPStJDxL0EwXbTlvniYemBusYPC+S5/T6X/vGEwZVX+XyLThHDPBOeNSQvhr lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhgqj6cvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 03:31:13 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1976ZOih016809;
        Thu, 7 Oct 2021 03:31:13 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhgqj6cut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 03:31:13 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1977INUx032572;
        Thu, 7 Oct 2021 07:31:11 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3bef2a9tnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 07:31:11 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1977V8NB62783862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 07:31:08 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65E03A408E;
        Thu,  7 Oct 2021 07:31:08 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3759A4082;
        Thu,  7 Oct 2021 07:31:07 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.155])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Oct 2021 07:31:07 +0000 (GMT)
Date:   Thu, 7 Oct 2021 09:31:05 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] s390x/mvpg-sie: Remove unused variable
Message-ID: <20211007093105.1a2515a9@p-imbrenda>
In-Reply-To: <20211007072136.768459-1-thuth@redhat.com>
References: <20211007072136.768459-1-thuth@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uq_n96lgltQfXuK8I79wdbOxBkgqSlNl
X-Proofpoint-ORIG-GUID: 4thShTug2aKddah5KUDVbOrJ5aiuSlNj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  7 Oct 2021 09:21:36 +0200
Thomas Huth <thuth@redhat.com> wrote:

> The guest_instr variable is not used, which was likely a
> copy-n-paste issue from the s390x/sie.c test.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/mvpg-sie.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
> index ccc273b..5adcec1 100644
> --- a/s390x/mvpg-sie.c
> +++ b/s390x/mvpg-sie.c
> @@ -21,7 +21,6 @@
>  #include <sie.h>
>  
>  static u8 *guest;
> -static u8 *guest_instr;
>  static struct vm vm;
>  
>  static uint8_t *src;
> @@ -94,8 +93,6 @@ static void setup_guest(void)
>  
>  	/* Allocate 1MB as guest memory */
>  	guest = alloc_pages(8);
> -	/* The first two pages are the lowcore */
> -	guest_instr = guest + PAGE_SIZE * 2;
>  
>  	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
>  

