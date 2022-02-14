Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F094B50F3
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242087AbiBNNEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:04:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353867AbiBNNEo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:04:44 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051B54E398;
        Mon, 14 Feb 2022 05:04:36 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21ECpd7T011255;
        Mon, 14 Feb 2022 13:04:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FMWzaTJXRrGBJi1FUbvAo3f2Gs05BJSDjHdhP6H1xuw=;
 b=rbfWZj3WkMgLOSPVbwn4tzx8sXpT5XtEPmGOzPWHgHiDpPMcOoMA5Y7pSW4dcJrEvjlJ
 r1BvZh9HnFgK8xZzi34eihWI3/RW80g/TJTDvzDa53C6oj066VwCZY9NjVEcxuVG5UDV
 XpsfsTNOHPAvQatWiLTDQW8fqmWTTWUHKZ3Y8ej/offPqPxYlBmuLNGTMPKF6y7LEi2/
 kAmQ5kk8KrxKwMcZW62d0l4CpD4Vik+D5sOxbbHXCroPDmAyZvkYopJZs/fcMGT8l8JS
 0JYahynCW+SdNoAez4RpZcx7eU8e3tC0vUxCf33R2afq8qBRzEZpDbEyS46q3sBo3PZX pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e6thxkdf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 13:04:36 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21ECfEh0015734;
        Mon, 14 Feb 2022 13:04:35 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e6thxkden-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 13:04:35 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21ED3lSx029719;
        Mon, 14 Feb 2022 13:04:34 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3e64h9nhr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 13:04:33 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21ED4TrF43319602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 13:04:29 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1D40A4065;
        Mon, 14 Feb 2022 13:04:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB271A4062;
        Mon, 14 Feb 2022 13:04:27 +0000 (GMT)
Received: from [9.171.42.254] (unknown [9.171.42.254])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Feb 2022 13:04:27 +0000 (GMT)
Message-ID: <0fce8189-8a02-16d2-6f37-7e435c6b8024@linux.ibm.com>
Date:   Mon, 14 Feb 2022 14:06:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v3 18/30] KVM: s390: mechanism to enable guest zPCI
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
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-19-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220204211536.321475-19-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wvX9Z-lcXqz_-Jolf_8p63MTrlG8QPsK
X-Proofpoint-ORIG-GUID: jrjA06zhDR9356g7ZVOFpCzNqlvEQbgl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_06,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501
 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/4/22 22:15, Matthew Rosato wrote:
> The guest must have access to certain facilities in order to allow
> interpretive execution of zPCI instructions and adapter event
> notifications.  However, there are some cases where a guest might
> disable interpretation -- provide a mechanism via which we can defer
> enabling the associated zPCI interpretation facilities until the guest
> indicates it wishes to use them.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Didn't you forget my ACK?


Acked-by: Pierre Morel <pmorel@linux.ibm.com>

> ---
>   arch/s390/include/asm/kvm_host.h |  4 ++++
>   arch/s390/kvm/kvm-s390.c         | 40 ++++++++++++++++++++++++++++++++
>   arch/s390/kvm/kvm-s390.h         | 10 ++++++++
>   3 files changed, 54 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index b468d3a2215e..bf61ab05f98c 100644
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
> index 24837d6050dc..208b09d08385 100644
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
> +}
> +
> +void kvm_s390_vcpu_pci_enable_interp(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
> +
> +	/*
> +	 * If host is configured for PCI and the necessary facilities are
> +	 * available, turn on interpretation for the life of this guest
> +	 */
> +	if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV) || !sclp.has_zpci_lsi ||
> +	    !sclp.has_aisii || !sclp.has_aeni || !sclp.has_aisi)
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
>   	unsigned long cx;
> @@ -3236,6 +3274,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>   
>   	kvm_s390_vcpu_crypto_setup(vcpu);
>   
> +	kvm_s390_vcpu_pci_setup(vcpu);
> +
>   	mutex_lock(&vcpu->kvm->lock);
>   	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>   		rc = kvm_s390_pv_create_cpu(vcpu, &uvrc, &uvrrc);
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 098831e815e6..14bb2539f837 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -496,6 +496,16 @@ void kvm_s390_reinject_machine_check(struct kvm_vcpu *vcpu,
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
