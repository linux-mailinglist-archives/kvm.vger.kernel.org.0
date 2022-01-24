Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450704981F8
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 15:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237684AbiAXOXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 09:23:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58464 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233777AbiAXOXJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 09:23:09 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OEHn9d024040;
        Mon, 24 Jan 2022 14:23:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3Gi2hLt+bNgz5tm+Bi1697AiriDVx9I1AVurtmodAV4=;
 b=oZQoeoVlYFzq6XEK3fSHVHJWUNlQC49I0yWF/ZCSzZKNwv1IOvOKKqGQipdSMV73zCyj
 GbnH8NmQqqnEhdCpTPJvq9oz5+lA+j35oEV4tkEQ7gUN5cJwynogzAwz8EYCAaeq3F7b
 jnnE8a4MTmEnrGymQNb0M4n56yFblyScZCvmiv4GokS3orwPbaaDFbARqI5fRpF06n/f
 xzQxYGpk7r2hs5XEaw5VVo1MkgQ92zW7z+VCMis7K5eSBycVO8IVXOnnXgGXEM7Hpx/i
 YoKHmnLG3D4vN0g79CDxRr7lL9FCIFCK++IiL+cKl/cImjbCBsPwsr1+CIcXi0sJRPw2 Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dsuwab4yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 14:23:09 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20OEHwvX025092;
        Mon, 24 Jan 2022 14:23:08 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dsuwab4xd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 14:23:08 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20OEIFDY030997;
        Mon, 24 Jan 2022 14:23:06 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3dr96j5a84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 14:23:06 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20OEN2vL45875592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jan 2022 14:23:02 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74E0252051;
        Mon, 24 Jan 2022 14:23:02 +0000 (GMT)
Received: from [9.171.67.78] (unknown [9.171.67.78])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6C67652052;
        Mon, 24 Jan 2022 14:23:01 +0000 (GMT)
Message-ID: <7125d611-5440-09ae-429a-7a087dd77868@linux.ibm.com>
Date:   Mon, 24 Jan 2022 15:24:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 17/30] KVM: s390: mechanism to enable guest zPCI
 Interpretation
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-18-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-18-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 69c1T2xJGaRDDGl2HI-Ja3HIsCn4C4Ic
X-Proofpoint-GUID: 4JjUKej3LRprS32yTqfFsSkk-vnLuGGj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-24_07,2022-01-24_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201240094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> The guest must have access to certain facilities in order to allow
> interpretive execution of zPCI instructions and adapter event
> notifications.  However, there are some cases where a guest might
> disable interpretation -- provide a mechanism via which we can defer
> enabling the associated zPCI interpretation facilities until the guest
> indicates it wishes to use them.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h |  4 ++++
>   arch/s390/kvm/kvm-s390.c         | 40 ++++++++++++++++++++++++++++++++
>   arch/s390/kvm/kvm-s390.h         | 10 ++++++++
>   3 files changed, 54 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 3f147b8d050b..38982c1de413 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -252,7 +252,10 @@ struct kvm_s390_sie_block {
>   #define ECB2_IEP	0x20
>   #define ECB2_PFMFI	0x08
>   #define ECB2_ESCA	0x04
> +#define ECB2_ZPCI_LSI	0x02
>   	__u8    ecb2;                   /* 0x0062 */
> +#define ECB3_AISI	0x20
> +#define ECB3_AISII	0x10
>   #define ECB3_DEA 0x08
>   #define ECB3_AES 0x04
>   #define ECB3_RI  0x01
> @@ -938,6 +941,7 @@ struct kvm_arch{
>   	int use_cmma;
>   	int use_pfmfi;
>   	int use_skf;
> +	int use_zpci_interp;
>   	int user_cpu_state_ctrl;
>   	int user_sigp;
>   	int user_stsi;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index ab8b56deed11..b6c32fc3b272 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1029,6 +1029,44 @@ static int kvm_s390_vm_set_crypto(struct kvm *kvm, struct kvm_device_attr *attr)
>   	return 0;
>   }
>   
> +static void kvm_s390_vcpu_pci_setup(struct kvm_vcpu *vcpu)
> +{
> +	/* Only set the ECB bits after guest requests zPCI interpretation */
> +	if (!vcpu->kvm->arch.use_zpci_interp)
> +		return;
> +
> +	vcpu->arch.sie_block->ecb2 |= ECB2_ZPCI_LSI;
> +	vcpu->arch.sie_block->ecb3 |= ECB3_AISII + ECB3_AISI;

As far as I understood, the interpretation is only possible if a gisa 
designation is associated with the PCI function via CLP enable.

Why do we setup the SIE ECB only when the guest requests for 
interpretation and not systematically in vcpu_setup?

If ECB2_ZPCI_LSI, ECB3_AISII or ECB3_AISI have an effect when the gisa 
designation is not specified shouldn't we have a way to clear these bits?

> +}
> +
> +void kvm_s390_vcpu_pci_enable_interp(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int i;
> +
> +	/*
> +	 * If host is configured for PCI and the necessary facilities are
> +	 * available, turn on interpretation for the life of this guest
> +	 */
> +	if (!IS_ENABLED(CONFIG_PCI) || !sclp.has_zpci_lsi || !sclp.has_aisii ||
> +	    !sclp.has_aeni || !sclp.has_aisi)
> +		return;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	kvm->arch.use_zpci_interp = 1;
> +
> +	kvm_s390_vcpu_block_all(kvm);
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		kvm_s390_vcpu_pci_setup(vcpu);
> +		kvm_s390_sync_request(KVM_REQ_VSIE_RESTART, vcpu);
> +	}
> +
> +	kvm_s390_vcpu_unblock_all(kvm);
> +	mutex_unlock(&kvm->lock);
> +}
> +
>   static void kvm_s390_sync_request_broadcast(struct kvm *kvm, int req)
>   {
>   	int cx;
> @@ -3282,6 +3320,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>   
>   	kvm_s390_vcpu_crypto_setup(vcpu);
>   
> +	kvm_s390_vcpu_pci_setup(vcpu);
> +
>   	mutex_lock(&vcpu->kvm->lock);
>   	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>   		rc = kvm_s390_pv_create_cpu(vcpu, &uvrc, &uvrrc);
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index c07a050d757d..a2eccb8b977e 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -481,6 +481,16 @@ void kvm_s390_reinject_machine_check(struct kvm_vcpu *vcpu,
>    */
>   void kvm_s390_vcpu_crypto_reset_all(struct kvm *kvm);
>   
> +/**
> + * kvm_s390_vcpu_pci_enable_interp
> + *
> + * Set the associated PCI attributes for each vcpu to allow for zPCI Load/Store
> + * interpretation as well as adapter interruption forwarding.
> + *
> + * @kvm: the KVM guest
> + */
> +void kvm_s390_vcpu_pci_enable_interp(struct kvm *kvm);
> +
>   /**
>    * diag9c_forwarding_hz
>    *
> 

-- 
Pierre Morel
IBM Lab Boeblingen
