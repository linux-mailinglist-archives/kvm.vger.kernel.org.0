Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77DBD3D3E97
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 19:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhGWQpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 12:45:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32948 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231166AbhGWQpK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Jul 2021 12:45:10 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16NHBWML066441;
        Fri, 23 Jul 2021 13:25:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0HNOkOn4KF9zz7NWPcTrn6xFb2yfH2EDadBff11Rwzc=;
 b=N+//1g8I4+1AQm2P/c2rl6WLIRgmvGAq9TmX3gwVwCS3JbsgbYkn4DYh4ifYXegQDovE
 v3AUcSYZFiHEDRQQqeEZLYKRu7dQ3iKgtn7kLJFj07Hs+vOj8tvrcGyX7um/O+RyDA2c
 C/X/YYHcdVJ+shCgEF9BmqkOTdA/s2nG1D9V1fnpeI13m34RkfXCZjJNvk1FiQa171L3
 Zlg0z+xnjUkX/nm74/SVzBEg8PAYFEgVcQHyW7fT1Fpbf4pIwqqXSZXE9WQAfjn0gWOk
 HMFSJgQx8dtrvqB1hxYTWjx1bsjDqJ+0JHmbK/0VsuMKI9mZHmwvmlLZYb2MQCmsxpcc Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a01j1gssx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 13:25:43 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16NHBbrZ066555;
        Fri, 23 Jul 2021 13:25:42 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a01j1gsq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 13:25:42 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16NHJ1FE027207;
        Fri, 23 Jul 2021 17:25:40 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 39vng72sff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 17:25:40 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16NHPcnN32178662
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Jul 2021 17:25:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F05F252052;
        Fri, 23 Jul 2021 17:25:37 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.87])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B2A0152050;
        Fri, 23 Jul 2021 17:25:37 +0000 (GMT)
Date:   Fri, 23 Jul 2021 19:10:43 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/5] s390x: sie: Fix sie.h integer types
Message-ID: <20210723191043.6f1fb823@p-imbrenda>
In-Reply-To: <20210629133322.19193-3-frankja@linux.ibm.com>
References: <20210629133322.19193-1-frankja@linux.ibm.com>
        <20210629133322.19193-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NwHpxeNCWiLaUwXT7XARfsV3T-l56gLn
X-Proofpoint-ORIG-GUID: 4RyxAeX0NwEdANQdD1Zb1dDkAMqL2RXM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-23_09:2021-07-23,2021-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 mlxscore=0 phishscore=0 impostorscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107230102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 29 Jun 2021 13:33:19 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's only use the uint*_t types.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/sie.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index b4bb78c..6ba858a 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -173,9 +173,9 @@ struct kvm_s390_sie_block {
>  } __attribute__((packed));
>  
>  struct vm_save_regs {
> -	u64 grs[16];
> -	u64 fprs[16];
> -	u32 fpc;
> +	uint64_t grs[16];
> +	uint64_t fprs[16];
> +	uint32_t fpc;
>  };
>  
>  /* We might be able to nestle all of this into the stack frame. But
> @@ -191,7 +191,7 @@ struct vm {
>  	struct kvm_s390_sie_block *sblk;
>  	struct vm_save_area save_area;
>  	/* Ptr to first guest page */
> -	u8 *guest_mem;
> +	uint8_t *guest_mem;
>  };
>  
>  extern void sie_entry(void);

