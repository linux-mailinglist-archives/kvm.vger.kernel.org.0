Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1FA42C2A4
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235884AbhJMORW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:17:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37692 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236499AbhJMORU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 10:17:20 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DCfDGr008993;
        Wed, 13 Oct 2021 10:15:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=927uTHklffc9dfdHbdG9ELcykUv/pH6sdbKZxfLYaq4=;
 b=r7Ff4icN74LG46HQg/xRf7N9UdYoZmUzCSN0uyUbPmnxA2SggKVT32MojQ/+q8/+QPTm
 IeyDTvZAExnNgj5UkLBdprIOucxkPcrB8r+xKR1FgomiJHx0nvIyisGyIRtoUVUfxsir
 9fa1dMkuktydMOfJXcJI9CXMvyefaxF02NBKl5IrCuqceQjGs1zwFCGFnBqRheiYTCxD
 2/VxjrJ9TO0GcnuiFG5foxLTjl1nx+l6/VY//XXxwNc2eCzmU4eNw282NjQxDiGlfEzC
 r7OwgPRcPla+B7/k5Mvoh1RwgnMcrEGsLKgxURZi3jZyUZkW+1SlsUGJNIdqLCadoBjv iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnpf3dwpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 10:15:16 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19DDikg6008975;
        Wed, 13 Oct 2021 10:15:15 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnpf3dwnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 10:15:15 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19DEDVHf026977;
        Wed, 13 Oct 2021 14:15:14 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3bk2qabkp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 14:15:13 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19DE9NQd58655222
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 14:09:23 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EAF04C05A;
        Wed, 13 Oct 2021 14:15:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9251C4C058;
        Wed, 13 Oct 2021 14:15:00 +0000 (GMT)
Received: from [9.145.94.172] (unknown [9.145.94.172])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Oct 2021 14:15:00 +0000 (GMT)
Message-ID: <0d7bd4a7-48df-b515-f7c0-9248ba20e154@linux.ibm.com>
Date:   Wed, 13 Oct 2021 16:14:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v3 4/9] lib: s390x: uv: Add UVC_ERR_DEBUG
 switch
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com
References: <20211007085027.13050-1-frankja@linux.ibm.com>
 <20211007085027.13050-5-frankja@linux.ibm.com>
In-Reply-To: <20211007085027.13050-5-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: J5tjhsoj_tSMBMN33O0xSVrJZhIMn3u0
X-Proofpoint-ORIG-GUID: e-IROQ979PRd_BhevQTyUyk3hKSMdCdS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_05,2021-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110130096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/7/21 10:50, Janosch Frank wrote:
> Every time something goes wrong in a way we don't expect, we need to
> add debug prints to some UVC to get the unexpected return code.
> 
> Let's just put the printing behind a macro so we can enable it if
> needed via a simple switch.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/s390x/asm/uv.h | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 2f099553..16db086d 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -12,6 +12,11 @@
>   #ifndef _ASMS390X_UV_H_
>   #define _ASMS390X_UV_H_
>   
> +/* Enables printing of command code and return codes for failed UVCs */
> +#ifndef UVC_ERR_DEBUG
> +#define UVC_ERR_DEBUG	0
> +#endif
> +
>   #define UVC_RC_EXECUTED		0x0001
>   #define UVC_RC_INV_CMD		0x0002
>   #define UVC_RC_INV_STATE	0x0003
> @@ -194,6 +199,13 @@ static inline int uv_call_once(unsigned long r1, unsigned long r2)
>   		: [cc] "=d" (cc)
>   		: [r1] "a" (r1), [r2] "a" (r2)
>   		: "memory", "cc");
> +
> +	if (UVC_ERR_DEBUG && cc)

That needs to check cc == 1...

> +		printf("UV call error: call %x rc %x rrc %x\n",
> +		       ((struct uv_cb_header *)r2)->cmd,
> +		       ((struct uv_cb_header *)r2)->rc,
> +		       ((struct uv_cb_header *)r2)->rrc);
> +
>   	return cc;
>   }
>   
> 

