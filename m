Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962023BE877
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 14:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhGGNCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 09:02:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42262 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229757AbhGGNCB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 09:02:01 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167Caola031070;
        Wed, 7 Jul 2021 08:59:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Hu5JvV0RcwAGjdNlvIsxDjA827gyXbQEAkt5ntYd2H0=;
 b=eagdbECAXL0NwIvY6ibWscKSuH4hCvYEzeypG/xlb1XMEUSJ8GR7O/RxNZAFqRudD4Wq
 5S2iA8xZJiBY0Y0E/puoxDrYtWMQrrNLExdJulgIIp44Lj1NO+MsXvHhlTPDVqs81p4t
 EDkypU5ER5sD0jEdKlorm2t+bwIXpQ0BGiSej4IlPBBtVqFRQV8MZJtPS+OP6Zz7qPnm
 7GGmBibeBTQ1U200v1U4vEgA+cltTBAFxFEltW33iz/2gwmBWT/7VZhGs75PEkgItUHg
 ec7eQvwZL8Kl6l5ajZvIvOLlMZSST4cQigmFsspU9ZValHpFUQVtkjSfKUIfzQkBHSA7 oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39m8xttevu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 08:59:20 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 167CariR031283;
        Wed, 7 Jul 2021 08:59:20 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39m8xttev7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 08:59:20 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 167Cx6kx017019;
        Wed, 7 Jul 2021 12:59:18 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 39jfh8srrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 12:59:18 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 167CvNIp31588686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 12:57:23 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 683C411C05E;
        Wed,  7 Jul 2021 12:59:15 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97DF811C05C;
        Wed,  7 Jul 2021 12:59:14 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.89.68])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jul 2021 12:59:14 +0000 (GMT)
Subject: Re: [PATCH v2] KVM: s390: Enable specification exception
 interpretation
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210707120745.531571-1-scgl@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <1714920e-7e18-9cab-9a5d-15888b70f8ba@de.ibm.com>
Date:   Wed, 7 Jul 2021 14:59:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210707120745.531571-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hghc_jylCkHw_Yq3zKGXtVIM5szRGdaX
X-Proofpoint-GUID: HXFIOsWbfT9L-elcAD7E1ttE9RBAf5TD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_06:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07.07.21 14:07, Janis Schoetterl-Glausch wrote:
> When this feature is enabled the hardware is free to interpret
> specification exceptions generated by the guest, instead of causing
> program interruption interceptions, but it is not required to.
> There is no indication if this feature is available or not,
> so we can simply set this bit and if the hardware ignores it
> we fall back to intercept 8 handling.
> The same applies to vSIE, we forward the guest hypervisor's bit
> and fall back to injection if interpretation does not occur.
> 
> This benefits (test) programs that generate a lot of specification
> exceptions (roughly 4x increase in exceptions/sec).
> 
> Interceptions will occur as before if ICTL_PINT is set,
> i.e. if guest debug is enabled.
> A specification exception detected on the program new PSW
> will also always cause an interception.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Thanks, applied.

> ---
> v1 -> v2
> 	Rephrase commit message
> 	Add comment about opting into interpretation
> 
>   arch/s390/include/asm/kvm_host.h | 1 +
>   arch/s390/kvm/kvm-s390.c         | 5 +++++
>   arch/s390/kvm/vsie.c             | 2 ++
>   3 files changed, 8 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 9b4473f76e56..3a5b5084cdbe 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -244,6 +244,7 @@ struct kvm_s390_sie_block {
>   	__u8	fpf;			/* 0x0060 */
>   #define ECB_GS		0x40
>   #define ECB_TE		0x10
> +#define ECB_SPECI	0x08
>   #define ECB_SRSI	0x04
>   #define ECB_HOSTPROTINT	0x02
>   	__u8	ecb;			/* 0x0061 */
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index b655a7d82bf0..7675b72a3ddf 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3200,6 +3200,11 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>   		vcpu->arch.sie_block->ecb |= ECB_SRSI;
>   	if (test_kvm_facility(vcpu->kvm, 73))
>   		vcpu->arch.sie_block->ecb |= ECB_TE;
> +	/* no facility bit, can opt in because we do not need
> +	 * to observe specification exception intercepts
> +	 */
> +	if (!kvm_is_ucontrol(vcpu->kvm))
> +		vcpu->arch.sie_block->ecb |= ECB_SPECI;
>   
>   	if (test_kvm_facility(vcpu->kvm, 8) && vcpu->kvm->arch.use_pfmfi)
>   		vcpu->arch.sie_block->ecb2 |= ECB2_PFMFI;
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 4002a24bc43a..acda4b6fc851 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -510,6 +510,8 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   			prefix_unmapped(vsie_page);
>   		scb_s->ecb |= ECB_TE;
>   	}
> +	/* specification exception interpretation */
> +	scb_s->ecb |= scb_o->ecb & ECB_SPECI;
>   	/* branch prediction */
>   	if (test_kvm_facility(vcpu->kvm, 82))
>   		scb_s->fpf |= scb_o->fpf & FPF_BPBC;
> 
