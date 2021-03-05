Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD6032EDEA
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 16:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhCEPJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 10:09:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18826 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229749AbhCEPIv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Mar 2021 10:08:51 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 125F44V3072482;
        Fri, 5 Mar 2021 10:08:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RWhl6t9iddsgIIGFtjbP86KDfclS79MfmIlMtxt6fYM=;
 b=gRt2RJg3yF42E5cm+KM7lLOK+aPugoF7KYU9JA9lF5Tl6WXltLNmDGF/6bnTxTmH0BO4
 jUETkdvyDu/1RFqQs03lDUIbZJiPSX+FGQnhYJ/ZfDFK6v/K1Ahm7InehyZxPIzCiutH
 5cN3TurYnHsOxRLZvYFP7/8GrziHi9DCy18anSCgL3J8IRCvUQDO+Bn4mHT/LrQrDl7F
 2zkLOJ2m3GMVh7Ry1D86B/588sNIm9OTnlFOEuMjaAoZRvkWNeP4Tn6edbCs50YtCFjl
 MUjvHCNirn3eIk2nlPAIktGgw75PJ60dUf2rU+XPhC6sNILXqwu+q6W/ZroiiS7QxUtY jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 373nsyjncn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 10:08:50 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 125F4EFt073502;
        Fri, 5 Mar 2021 10:08:50 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 373nsyjnbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 10:08:50 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 125F28E5017121;
        Fri, 5 Mar 2021 15:08:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 371162kv01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Mar 2021 15:08:48 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 125F8jXE36307322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Mar 2021 15:08:45 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6ABC642047;
        Fri,  5 Mar 2021 15:08:45 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C15242041;
        Fri,  5 Mar 2021 15:08:45 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.57.80])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  5 Mar 2021 15:08:45 +0000 (GMT)
Subject: Re: [PATCH v5 1/3] s390/kvm: split kvm_s390_logical_to_effective
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20210302174443.514363-1-imbrenda@linux.ibm.com>
 <20210302174443.514363-2-imbrenda@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <a2148aca-6663-4d7e-af71-e7dcac6e54ea@de.ibm.com>
Date:   Fri, 5 Mar 2021 16:08:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210302174443.514363-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-05_08:2021-03-03,2021-03-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 mlxscore=0 suspectscore=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103050077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02.03.21 18:44, Claudio Imbrenda wrote:
> Split kvm_s390_logical_to_effective to a generic function called
> _kvm_s390_logical_to_effective. The new function takes a PSW and an address
> and returns the address with the appropriate bits masked off. The old
> function now calls the new function with the appropriate PSW from the vCPU.
> 
> This is needed to avoid code duplication for vSIE.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

We might need cc stable here as well for patch 3?

Otherwise this looks good.
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>   arch/s390/kvm/gaccess.h | 29 ++++++++++++++++++++++++-----
>   1 file changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
> index f4c51756c462..107fdfd2eadd 100644
> --- a/arch/s390/kvm/gaccess.h
> +++ b/arch/s390/kvm/gaccess.h
> @@ -36,6 +36,29 @@ static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
>   	return gra;
>   }
>   
> +/**
> + * _kvm_s390_logical_to_effective - convert guest logical to effective address
> + * @psw: psw of the guest
> + * @ga: guest logical address
> + *
> + * Convert a guest logical address to an effective address by applying the
> + * rules of the addressing mode defined by bits 31 and 32 of the given PSW
> + * (extendended/basic addressing mode).
> + *
> + * Depending on the addressing mode, the upper 40 bits (24 bit addressing
> + * mode), 33 bits (31 bit addressing mode) or no bits (64 bit addressing
> + * mode) of @ga will be zeroed and the remaining bits will be returned.
> + */
> +static inline unsigned long _kvm_s390_logical_to_effective(psw_t *psw,
> +							   unsigned long ga)
> +{
> +	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_64BIT)
> +		return ga;
> +	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_31BIT)
> +		return ga & ((1UL << 31) - 1);
> +	return ga & ((1UL << 24) - 1);
> +}
> +
>   /**
>    * kvm_s390_logical_to_effective - convert guest logical to effective address
>    * @vcpu: guest virtual cpu
> @@ -54,11 +77,7 @@ static inline unsigned long kvm_s390_logical_to_effective(struct kvm_vcpu *vcpu,
>   {
>   	psw_t *psw = &vcpu->arch.sie_block->gpsw;
>   
> -	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_64BIT)
> -		return ga;
> -	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_31BIT)
> -		return ga & ((1UL << 31) - 1);
> -	return ga & ((1UL << 24) - 1);
> +	return _kvm_s390_logical_to_effective(&vcpu->arch.sie_block->gpsw, ga);
>   }
>   
>   /*
> 
