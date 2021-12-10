Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4579470199
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241810AbhLJNar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:30:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40700 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235759AbhLJNaq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 08:30:46 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BAD6e4S013035;
        Fri, 10 Dec 2021 13:27:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=g8mjf7yT4sUfGXNRSVv2wV8bVE4YsrEFdhmLbtC9Roo=;
 b=lBTHH8LcWqBdALOpHkpuJvuj83LPTVivjK+SShvJBHiamSlDN1yRDXpkdtMm8eTtswUu
 sKXd49CV6B+DiJ8MqcbBSrMkDW7tgajVyv7Z5RvoZJOA39u/Ze0OEb5aO1H0cYyCM8bh
 Pt75VAweVAFWdE6rwVJrMjeuc37yTfj14mKFwt2bqleRtdty7Gs9BX54KKjcT5xV7br3
 STmIOq03dwuC8sLRNNyfTAEAUwmpYWvJQdamXf7nnBIpkTdZX8WD6kWRayHViOlri24O
 bitCmDaMWpn/Eb5g0bMfCThF/E1V5JCgJPQACel0CkyT3rvkQ7t1z6MtH72far4Ohiub QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cv7g1gch8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 13:27:10 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BAD6o8Q013252;
        Fri, 10 Dec 2021 13:27:10 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cv7g1gcgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 13:27:10 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BADNbsv006037;
        Fri, 10 Dec 2021 13:27:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3cqyybkc3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 13:27:07 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BADR2q625362914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 13:27:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F29D11C054;
        Fri, 10 Dec 2021 13:27:02 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AE9E11C04A;
        Fri, 10 Dec 2021 13:27:01 +0000 (GMT)
Received: from [9.171.76.123] (unknown [9.171.76.123])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 Dec 2021 13:27:01 +0000 (GMT)
Message-ID: <7df88bde-2b63-4a91-036c-28527f56e22d@linux.ibm.com>
Date:   Fri, 10 Dec 2021 14:27:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 19/32] KVM: s390: mechanism to enable guest zPCI
 Interpretation
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-20-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211207205743.150299-20-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ksrWEH1EFFtqOOcqEP_NuBHvBFQY07J_
X-Proofpoint-ORIG-GUID: Y0rX5weCRoKgLaaHvXVciBBR3QBT_NWQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_04,2021-12-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 adultscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> The guest must have access to certain facilities in order to allow
> interpretive execution of zPCI instructions and adapter event
> notifications.  However, there are some cases where a guest might
> disable interpretation -- provide a mechanism via which we can defer
> enabling the associated zPCI interpretation facilities until the guest
> indicates it wishes to use them.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h |  4 +++
>   arch/s390/kvm/kvm-s390.c         | 43 ++++++++++++++++++++++++++++++++
>   arch/s390/kvm/kvm-s390.h         | 10 ++++++++
>   3 files changed, 57 insertions(+)
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
> index a680f2a02b67..361d742cdf0d 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1023,6 +1023,47 @@ static int kvm_s390_vm_set_crypto(struct kvm *kvm, struct kvm_device_attr *attr)
>   	return 0;
>   }
>   
> +static void kvm_s390_vcpu_pci_setup(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * If the facilities aren't available for PCI interpretation and
> +	 * interrupt forwarding, we shouldn't be here.
> +	 */

This reads like we want a WARN_ON or BUG_ON, but as we call this uncoditionally this is
actually a valid check. So instead of "shouldn't be here" say something like "bail out
if interpretion is not active".  ?

> +	if (!vcpu->kvm->arch.use_zpci_interp)
> +		return;
> +
> +	vcpu->arch.sie_block->ecb2 |= ECB2_ZPCI_LSI;
> +	vcpu->arch.sie_block->ecb3 |= ECB3_AISII + ECB3_AISI;
> +}
> +
> +void kvm_s390_vcpu_pci_enable_interp(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int i;
> +
> +	/*
> +	 * If host facilities are available, turn on interpretation for the
> +	 * life of this guest
> +	 */
> +	if (!test_facility(69) || !test_facility(70) || !test_facility(71) ||
> +	    !test_facility(72))
> +		return;

Wouldnt that also enable interpretion for VSIE? I guess we should check for the
sclp facilities from patches 1,2,3, and 4 instead.


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
> @@ -3288,6 +3329,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>   h
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
