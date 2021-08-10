Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA633E2CF5
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 16:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhHFOxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 10:53:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47824 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230302AbhHFOxf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Aug 2021 10:53:35 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 176EYBVd109100;
        Fri, 6 Aug 2021 10:53:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=K81u1sXeXTng2fnrgtRrGKD4KNmSjMIC8eOMEgTvc5M=;
 b=tJTIiD5Tg5SDMpDuor9c56wVMTI7eoe+QjAZ3WZCYcx7Ryxu5F25RHZBZ0jsII0xguoz
 TfgnBoD15xNzVQyTHfpuDrjwlAFeNvRTStUMzmKH6AulsJQw9DU7nxF2cr8UsLr+zLw8
 aO0+zkg/fYj4nyYu0RZ9u01WOki9tQw0NNju73ahY/seslJN7hnPRFm4SrLGbdPmPwt5
 FGdXPWYct3oOgzUEBllX10fyHV8FGMbO4wLjTD8sorp0qyLdZvDFPUPhEqNuqGwirO7G
 ZZ8kvGEKIg+xxsAqI9YaUh0ad7B8fWqYPIQXFPc1Kvf/ffdUjn75gqhlHZzNt6e4z+0P GA== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a89fnspds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 10:53:11 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 176EhIrq006768;
        Fri, 6 Aug 2021 14:53:10 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma01wdc.us.ibm.com with ESMTP id 3a8gwuc9e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 14:53:10 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 176Er9pD34472258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Aug 2021 14:53:09 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 888E678060;
        Fri,  6 Aug 2021 14:53:09 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3A7778067;
        Fri,  6 Aug 2021 14:53:08 +0000 (GMT)
Received: from localhost (unknown [9.211.46.8])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Fri,  6 Aug 2021 14:53:08 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>, kvm@vger.kernel.org
Subject: Re: [PATCH kernel v2] KVM: PPC: Use arch_get_random_seed_long
 instead of powernv variant
In-Reply-To: <20210805075649.2086567-1-aik@ozlabs.ru>
References: <20210805075649.2086567-1-aik@ozlabs.ru>
Date:   Fri, 06 Aug 2021 11:53:06 -0300
Message-ID: <87bl6atyjx.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _RGfA1NBZULcggjYMmEN8jXIAQ_1UMzZ
X-Proofpoint-GUID: _RGfA1NBZULcggjYMmEN8jXIAQ_1UMzZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-06_05:2021-08-05,2021-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 adultscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 mlxlogscore=843 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alexey Kardashevskiy <aik@ozlabs.ru> writes:

> The powernv_get_random_long() does not work in nested KVM (which is
> pseries) and produces a crash when accessing in_be64(rng->regs) in
> powernv_get_random_long().
>
> This replaces powernv_get_random_long with the ppc_md machine hook
> wrapper.
>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

> ---
>
> Changes:
> v2:
> * replaces [PATCH kernel] powerpc/powernv: Check if powernv_rng is initialized
>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index be0cde26f156..ecfd133e0ca8 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -1165,7 +1165,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
>  		break;
>  #endif
>  	case H_RANDOM:
> -		if (!powernv_get_random_long(&vcpu->arch.regs.gpr[4]))
> +		if (!arch_get_random_seed_long(&vcpu->arch.regs.gpr[4]))
>  			ret = H_HARDWARE;
>  		break;
>  	case H_RPT_INVALIDATE:
