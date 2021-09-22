Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799DE414545
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 11:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbhIVJhX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 05:37:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24894 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234435AbhIVJhW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 05:37:22 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M9G1X7018993;
        Wed, 22 Sep 2021 05:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=yM0QeVnKU2TB+ZHYsuCMd+ITxc+I8A9sKm3IABYIr5U=;
 b=bXRmAydhwDqY+LLRfwNqRxlnRwqZDIvJak1LAHmfXRbb72ucaB01ZafmsxNd8ow85yDt
 j8HryoT0QIKHv2MjRHg0pElOqCWmRxHTzW8zBQHdcknyjKIXOTYITW2tLogQggJ7pyoS
 iKKvo/qGB73gCZK1MndtxYEbhWSssvnisAfiSOZIdPckfxCA8zVSR6co6xEUKh125QtS
 nh43moSevmjSRj5VxfwaewPPO5bztxaK02iJPp9I6JeVZ6b/kcLKKD0UlDaW0wcDfAsZ
 gtbrCgYemk3KjV1OfsZGGQZqrWyPPk40LRvEvAlx2yO47DtjrxDppgwlsncsUjMj+bVc Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7y93ur3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 05:35:52 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M7idqN008336;
        Wed, 22 Sep 2021 05:35:52 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7y93ur30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 05:35:51 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18M9VxY0008026;
        Wed, 22 Sep 2021 09:35:50 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3b7q6pmvhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 09:35:50 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18M9Zktp64487800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 09:35:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2C61AE055;
        Wed, 22 Sep 2021 09:35:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A8A7AE045;
        Wed, 22 Sep 2021 09:35:46 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.24])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 09:35:46 +0000 (GMT)
Date:   Wed, 22 Sep 2021 11:23:59 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        linux-s390@vger.kernel.org, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 5/9] lib: s390x: uv: Add UVC_ERR_DEBUG
 switch
Message-ID: <20210922112359.3907c54c@p-imbrenda>
In-Reply-To: <20210922071811.1913-6-frankja@linux.ibm.com>
References: <20210922071811.1913-1-frankja@linux.ibm.com>
        <20210922071811.1913-6-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nZ6kgXmNu8teGm3KcbxWx0o8FX1wxS0d
X-Proofpoint-GUID: p9KxH36V8KeMvXmG56xDu2zZs11wDfZV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_03,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Sep 2021 07:18:07 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Every time something goes wrong in a way we don't expect, we need to
> add debug prints to some UVC to get the unexpected return code.
> 
> Let's just put the printing behind a macro so we can enable it if
> needed via a simple switch.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

but see a nit below

> ---
>  lib/s390x/asm/uv.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 2f099553..0e958ad7 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -12,6 +12,9 @@
>  #ifndef _ASMS390X_UV_H_
>  #define _ASMS390X_UV_H_
>  
> +/* Enables printing of command code and return codes for failed UVCs
> */ +#define UVC_ERR_DEBUG	0
> +
>  #define UVC_RC_EXECUTED		0x0001
>  #define UVC_RC_INV_CMD		0x0002
>  #define UVC_RC_INV_STATE	0x0003
> @@ -194,6 +197,15 @@ static inline int uv_call_once(unsigned long r1,
> unsigned long r2) : [cc] "=d" (cc)
>  		: [r1] "a" (r1), [r2] "a" (r2)
>  		: "memory", "cc");
> +
> +#if UVC_ERR_DEBUG
> +	if (cc)

it probably looks cleaner like this:

	if (UVC_ERR_DEBUG && cc)

and without the #if; the compiler should be smart enough to remove the
dead code. In practice it doesn't really matter in the end, so feel free
to ignore this comment :)

> +		printf("UV call error: call %x rc %x rrc %x\n",
> +		       ((struct uv_cb_header *)r2)->cmd,
> +		       ((struct uv_cb_header *)r2)->rc,
> +		       ((struct uv_cb_header *)r2)->rrc);
> +#endif
> +
>  	return cc;
>  }
>  

