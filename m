Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0048342BCEC
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 12:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhJMKiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 06:38:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56038 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229711AbhJMKiX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 06:38:23 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19D9Hdwq023947;
        Wed, 13 Oct 2021 06:36:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=3dv+nI4cVM2cDTN+xOP9NOBj5m+MfJ0LJkWBEis7Nbc=;
 b=iF1QTfZeiO4ZjVQhplXRC/55+6XMPlL0LA77hqXu9+Ylu6MT5as5kaW2vr9rrpjzh5yC
 U8xFY+0nBO16VweWSKSjxHGkfAOoyKYDc2DE8gbVbYoJdqKdDcgunnp88ssF+RDM/svS
 dE+4guHDrQuKnj4AuLiy++ls+L+BxqFtIoqyppdBNRWh7KcW7ulfe/ISLGo0hEchwisq
 /ZiVwjnAwnr7A/3tXGrY6GL1r4hE4tuRdXuhMznTssBttC7CKn5XU7byhD5ntOEuPEBn
 c06NNxHFjNJcabHTxBPldLVB33yqK5CdNi6S8szG7x4icyIVuJ21XZfbXKF4EPw/puIK XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnpw70svr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 06:36:20 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19DAE7QW011060;
        Wed, 13 Oct 2021 06:36:20 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnpw70sv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 06:36:20 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19DAaC68018721;
        Wed, 13 Oct 2021 10:36:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3bk2bjhu5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 10:36:17 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19DAUTrw51708364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 10:30:29 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84DFE11C069;
        Wed, 13 Oct 2021 10:36:07 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB9E211C071;
        Wed, 13 Oct 2021 10:36:06 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.81])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Oct 2021 10:36:06 +0000 (GMT)
Date:   Wed, 13 Oct 2021 12:32:00 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/2] lib: s390x: Fix PSW constant
Message-ID: <20211013123200.19c55ea0@p-imbrenda>
In-Reply-To: <20211013102722.17160-2-frankja@linux.ibm.com>
References: <20211013102722.17160-1-frankja@linux.ibm.com>
        <20211013102722.17160-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9f7NJMbl69UEumKVCU9MkCKzJSvZBCb5
X-Proofpoint-GUID: msGbpa8nG6Y4udeCmjb5tX_5tHGcBUMr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_03,2021-10-13_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 clxscore=1015 phishscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110130071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Oct 2021 10:27:21 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Somehow the ";" got into that patch and now complicates compilation.
> Let's remove it and put the constant in braces.

ouch

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index b34aa792..40626d72 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -53,7 +53,7 @@ struct psw {
>  #define PSW_MASK_PSTATE			0x0001000000000000UL
>  #define PSW_MASK_EA			0x0000000100000000UL
>  #define PSW_MASK_BA			0x0000000080000000UL
> -#define PSW_MASK_64			PSW_MASK_BA | PSW_MASK_EA;
> +#define PSW_MASK_64			(PSW_MASK_BA | PSW_MASK_EA)
>  
>  #define CTL0_LOW_ADDR_PROT		(63 - 35)
>  #define CTL0_EDAT			(63 - 40)

