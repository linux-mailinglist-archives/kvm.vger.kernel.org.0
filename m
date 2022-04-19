Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7BD5067B0
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 11:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241691AbiDSJaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 05:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241574AbiDSJaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 05:30:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4AC2289A6;
        Tue, 19 Apr 2022 02:27:33 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23J8iJTP023210;
        Tue, 19 Apr 2022 09:27:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0tKn3hDvFvxg183TNhXn/GmxoRV+KWkNdRcOGgR6kIQ=;
 b=b2nr/Ls9ksvTUAepv5nfvGzNfCFi+trbAcuMeIwRZNYsNWrvuXwfdtxaF4wv1daP14AU
 +l9GwyAIIL28uEu2grDXrGaZqk9iIhoocDCoQGoqztzAST/XpnfP6pkxnz61+OUs79sA
 4HWeNuX90mJCMjVm2hoGTGiLfXG0du434XFS1QExTHnzHUahQbNKGX92MbZ0HPQ13Kbb
 h8gq7LZ4tz4wdSj0H8iUOf6rN2b/2cC/076zoJ52NNBOFxEs4/sYPjSMFL1aJqF0IrY3
 eVtYw+ClkUYBV0iaUriFY2ylCiMYw+7ni3/qgOXWeg7aBL/O4OLqjBEztMAlxRQNMZVn yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7btjeqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 09:27:33 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23J9R0Fr013444;
        Tue, 19 Apr 2022 09:27:32 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7btjeph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 09:27:32 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23J9D2LX016256;
        Tue, 19 Apr 2022 09:27:29 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ffne8m310-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 09:27:28 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23J9RPsX41091488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 09:27:25 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B830442041;
        Tue, 19 Apr 2022 09:27:25 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 755894203F;
        Tue, 19 Apr 2022 09:27:24 +0000 (GMT)
Received: from [9.171.88.57] (unknown [9.171.88.57])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Apr 2022 09:27:24 +0000 (GMT)
Message-ID: <6f229041-4ee4-664a-26ac-6e36cddecef4@linux.ibm.com>
Date:   Tue, 19 Apr 2022 11:30:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v5 13/21] KVM: s390: mechanism to enable guest zPCI
 Interpretation
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
 <20220404174349.58530-14-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220404174349.58530-14-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Y5NkNbTdg9bp5oW7wfQOMKzv8k8bRyn8
X-Proofpoint-ORIG-GUID: ds5rU1w4g_HazOPf83KeoGglUcWedkWE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-19_03,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204190051
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/4/22 19:43, Matthew Rosato wrote:
> The guest must have access to certain facilities in order to allow
> interpretive execution of zPCI instructions and adapter event
> notifications.  However, there are some cases where a guest might
> disable interpretation -- provide a mechanism via which we can defer
> enabling the associated zPCI interpretation facilities until the guest
> indicates it wishes to use them.
> 
> Acked-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

You can change the ACK with a RB (I think it already was a RB)

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>


> ---
>   arch/s390/include/asm/kvm_host.h |  4 ++++
>   arch/s390/kvm/kvm-s390.c         | 37 ++++++++++++++++++++++++++++++++
>   arch/s390/kvm/kvm-s390.h         | 10 +++++++++
>   3 files changed, 51 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index c1518a505060..8e381603b6a7 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -254,7 +254,10 @@ struct kvm_s390_sie_block {
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
> @@ -940,6 +943,7 @@ struct kvm_arch{
>   	int use_cmma;
>   	int use_pfmfi;
>   	int use_skf;
> +	int use_zpci_interp;
>   	int user_cpu_state_ctrl;
>   	int user_sigp;
>   	int user_stsi;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index a9eb8b75af93..327649ddddce 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1029,6 +1029,41 @@ static int kvm_s390_vm_set_crypto(struct kvm *kvm, struct kvm_device_attr *attr)
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
> +/* Must be called with kvm->lock held */
> +void kvm_s390_vcpu_pci_enable_interp(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
> +
> +	/*
> +	 * If host is configured for PCI and the necessary facilities are
> +	 * available, turn on interpretation for the life of this guest
> +	 */
> +	if (!kvm_s390_pci_interp_allowed())
> +		return;
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
> +}
> +
>   static void kvm_s390_sync_request_broadcast(struct kvm *kvm, int req)
>   {
>   	unsigned long cx;
> @@ -3329,6 +3364,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>   
>   	kvm_s390_vcpu_crypto_setup(vcpu);
>   
> +	kvm_s390_vcpu_pci_setup(vcpu);
> +
>   	mutex_lock(&vcpu->kvm->lock);
>   	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
>   		rc = kvm_s390_pv_create_cpu(vcpu, &uvrc, &uvrrc);
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 497d52a83c78..975cffaf13de 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -507,6 +507,16 @@ void kvm_s390_reinject_machine_check(struct kvm_vcpu *vcpu,
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
