Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221443D3E9B
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 19:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbhGWQpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 12:45:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14904 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231430AbhGWQpO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Jul 2021 12:45:14 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16NH2hlF190869;
        Fri, 23 Jul 2021 13:25:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=eNnJ/5emcfnDBhrk4JIebYFYPC+yNW2Sd3g+5A51fNA=;
 b=GROCmspVHU0yyLrG9sgsLCAWo1cfDyRNQ0M7dDRdaobFvGlUOr1mfgppuCr8mI0x5tS+
 whSg5KPtHKkNN6pQKKH7QD7r1mM/0HXMVoQpUdFL2HXN9s3qU9UUrC5hoTCw60mK9dMq
 Eaj/pRGl10n6sP/HsT1NT1NfZaP1fxP4X+thGBVc1FKVcnoYRVfg22iHPOPH4UjDIlyJ
 cSPB3NUse8FmI83eiTmsOC7n8uxANmgPqpU+x2m7pSwCNsosSBYKcZM519Pe0jtI3U4D
 4KgWZi7LTVfGJkZyLo8Yh562I4qcdx+Xgb0Bjc3Znome9lMHssHnZ6qq8VX/S/+0PbF5 mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a014h1t25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 13:25:47 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16NHKjl2062979;
        Fri, 23 Jul 2021 13:25:47 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a014h1t1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 13:25:47 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16NHJOAD027221;
        Fri, 23 Jul 2021 17:25:45 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 39upu89x7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 17:25:45 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16NHPgUe20971786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Jul 2021 17:25:42 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B4FC52057;
        Fri, 23 Jul 2021 17:25:42 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.87])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 55E1052050;
        Fri, 23 Jul 2021 17:25:42 +0000 (GMT)
Date:   Fri, 23 Jul 2021 19:10:33 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 1/5] s390x: sie: Add missing includes
Message-ID: <20210723191033.65e8c3b5@p-imbrenda>
In-Reply-To: <20210629133322.19193-2-frankja@linux.ibm.com>
References: <20210629133322.19193-1-frankja@linux.ibm.com>
        <20210629133322.19193-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KJgWMdIi5oMEBaqQNkSbjZRJ68UpXymj
X-Proofpoint-ORIG-GUID: 2rUjP39kdaoebrPvRuSK9c-Fj9WVO7wv
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-23_09:2021-07-23,2021-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107230102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 29 Jun 2021 13:33:18 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> arch_def.h is needed for struct psw.
> stdint.h is needed for the uint*_t types.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/sie.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index db30d61..b4bb78c 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -2,6 +2,9 @@
>  #ifndef _S390X_SIE_H_
>  #define _S390X_SIE_H_
>  
> +#include <stdint.h>
> +#include <asm/arch_def.h>
> +
>  #define CPUSTAT_STOPPED    0x80000000
>  #define CPUSTAT_WAIT       0x10000000
>  #define CPUSTAT_ECALL_PEND 0x08000000

