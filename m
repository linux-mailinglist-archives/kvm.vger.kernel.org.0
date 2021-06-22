Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DB33B0725
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 16:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbhFVOPE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 10:15:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51074 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231849AbhFVOPE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 10:15:04 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15ME3SEp054940
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:12:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Uy041wAazvcZzQz2V8WkYV4WVcUg7tqoEJvDEumB6SU=;
 b=bPnbQTJ7ezhZly6IbuM/PEsZOvRI8o/4gNl6TAF4oBML86vC6mjsPjvEi7hxCHig5O7O
 /9X1TjWFTZ6gWRGSnoe10rXeYtzqKl4lb6KVZ6PMwBUTljGSlEBMi/Uwp2dlPv/tUj28
 QKdqSysjyNdeAtVqyHoQq2NQhNPbs4NdyvVnFvxMWgpB4TMdGxtNNiRxdrOX8Nfc0qzr
 +Q8mQqBhoE+PVoQojNbQjkIHtCz/wV17aEVpwhxLKj+mlADS6yDG6u9drZK8uhurOIMg
 M7b9ShkeierMmM4c6652i3jcNHjTI8JvIHt8kE+T4cRcK+VFCBeVleT3yFwrI9gjlnl2 QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bfrh3mam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:12:47 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15ME4JTX060419
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:12:47 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bfrh3m9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 10:12:47 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15ME1ND4009719;
        Tue, 22 Jun 2021 14:12:45 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3997uh9gdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 14:12:45 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15MEChXQ25690398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 14:12:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36BFCA405E;
        Tue, 22 Jun 2021 14:12:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF58AA406D;
        Tue, 22 Jun 2021 14:12:42 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.9.205])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 14:12:42 +0000 (GMT)
Date:   Tue, 22 Jun 2021 16:12:40 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 3/4] lib/s390x: Fix the epsw inline
 assembly
Message-ID: <20210622161240.03098bce@ibm-vm>
In-Reply-To: <20210622135517.234801-4-thuth@redhat.com>
References: <20210622135517.234801-1-thuth@redhat.com>
        <20210622135517.234801-4-thuth@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IPFvmT8wf4l5FGrWa1xAlRpb61pWfNnu
X-Proofpoint-ORIG-GUID: Y-lYgfUKU0UW2mq8zb8wAZiZnFxWRN9p
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_08:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106220088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Jun 2021 15:55:16 +0200
Thomas Huth <thuth@redhat.com> wrote:

> According to the Principles of Operation, the epsw instruction
> does not touch the second register if it is r0. With GCC we were
> lucky so far that it never tried to use r0 here, but when compiling
> the kvm-unit-tests with Clang, this indeed happens and leads to
> very weird crashes. Thus let's make sure to never use r0 for the
> second operand of the epsw instruction.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

maybe also mention in the patch description why you changed + to =

> ---
>  lib/s390x/asm/arch_def.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 3aa5da9..15cf7d4 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -265,7 +265,7 @@ static inline uint64_t extract_psw_mask(void)
>  
>  	asm volatile(
>  		"	epsw	%0,%1\n"
> -		: "+r" (mask_upper), "+r" (mask_lower) : : );
> +		: "=r" (mask_upper), "=a" (mask_lower));
>  
>  	return (uint64_t) mask_upper << 32 | mask_lower;
>  }

