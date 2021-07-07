Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232543BE476
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 10:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhGGIdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 04:33:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31442 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230109AbhGGIdn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 04:33:43 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167842Ur050730;
        Wed, 7 Jul 2021 04:31:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=q6p3Uu8XXPiR1yO3TuBzoxSTC08J9NsacLDx/7ChigA=;
 b=tutfvHWbwL8sSqjYRrE0Qxp8SlRw9EgIKWcBlRcgpvGodHozkG6402UEcK/jTdHXiHj7
 U+LdpOS8Ke991QB2Kwc9gaIHNqAbw3OcveJIV3iqV3jfoGe+iUjhY/2JiEEmU4f+5dU8
 WDsS9TVOzZ4E3UWOaMsA8UP5aUO9tQr49qlJm1h0PW0aBiw2lAxZ93TrPFSlBYE2iTJp
 fACMPg2+Rz+93f/EuWBnCuJVp6Je+fnL5PRmv8oLFQnEsIXMB2d8bByMe5G0Ct8NIry0
 zjjl1RA/GKPOcJVaSYIKURyBsr4VU8zTdGPPJMgZ6jeh83MXxIEMyTotVm1VWJYYj90D wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mc15ts1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 04:31:03 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16785u00060134;
        Wed, 7 Jul 2021 04:31:02 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mc15ts0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 04:31:02 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1678Rdw1017528;
        Wed, 7 Jul 2021 08:31:00 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 39jfh8smw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 08:31:00 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1678T31p31392192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 08:29:03 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F606AE05D;
        Wed,  7 Jul 2021 08:30:57 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 896D7AE061;
        Wed,  7 Jul 2021 08:30:56 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.89.68])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jul 2021 08:30:56 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: Enable specification exception interpretation
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "open list:KERNEL VIRTUAL MACHINE for s390 (KVM/s390)" 
        <kvm@vger.kernel.org>,
        "open list:S390" <linux-s390@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210706114714.3936825-1-scgl@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <05430c91-6a84-0fc9-0af4-89f408eb691f@de.ibm.com>
Date:   Wed, 7 Jul 2021 10:30:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706114714.3936825-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Q4pBwqXdtnCML2A60p96duplFt6B2Ltv
X-Proofpoint-GUID: -7MLDd5yQqExhVoX0xLmJuLp5JqS90cB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_02:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070047
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06.07.21 13:47, Janis Schoetterl-Glausch wrote:
> When this feature is enabled the hardware is free to interpret
> specification exceptions generated by the guest, instead of causing
> program interruption interceptions.
> 
> This benefits (test) programs that generate a lot of specification
> exceptions (roughly 4x increase in exceptions/sec).
> 
> Interceptions will occur as before if ICTL_PINT is set,
> i.e. if guest debug is enabled.

I think I will add

There is no indication if this feature is available or not and the hardware
is free to interpret or not. So we can simply set this bit and if the
hardware ignores it we fall back to intercept 8 handling.


With that

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
> I'll additionally send kvm-unit-tests for testing this feature.
> 
>   arch/s390/include/asm/kvm_host.h | 1 +
>   arch/s390/kvm/kvm-s390.c         | 2 ++
>   arch/s390/kvm/vsie.c             | 2 ++
>   3 files changed, 5 insertions(+)
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
> index b655a7d82bf0..aadd589a3755 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3200,6 +3200,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>   		vcpu->arch.sie_block->ecb |= ECB_SRSI;
>   	if (test_kvm_facility(vcpu->kvm, 73))
>   		vcpu->arch.sie_block->ecb |= ECB_TE;
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
