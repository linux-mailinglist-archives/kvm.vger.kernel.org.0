Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C015F5BFE12
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 14:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiIUMjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 08:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiIUMjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 08:39:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86A47F250;
        Wed, 21 Sep 2022 05:38:58 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28LCCKBI027419;
        Wed, 21 Sep 2022 12:38:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=EgORz8l0ZXMSrUgjXCg/g/TtPIFGRXyMqjuE+EA8wNM=;
 b=chSLohu9guq9ZQYz6XwH8s6VhDuzJw881g1S8Z/WWnUF5iR+LoE7iVbfPMOGmiseJPs2
 9xHru9AkIciYOqn1xaGarOqthPaBP0V6/NnaNw7/MxDgg3fWGi1xvQDgIYeCiPoNK2Yq
 AMSiZglHPbN5VzVYrcZfB/LqDIpKhpwBgzaMP6aRnGUyrfNF6wWxxShjWJ5A0SbFHMlm
 SWeHAtXhbl7oIA7FH7rGTOsuCNx4/d4ZLZq9YM1j2LnzFJu8sfDp1Vgu4RfBNrs+hOuK
 XqjPu/iDmdhqoxx3XSM+eQmvlCpmWE0SQc6Kzxet0ooU+3UIgktVm+AAabEPKT4mTt0w 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jr2df8x34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Sep 2022 12:38:58 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28LCDBGq031357;
        Wed, 21 Sep 2022 12:38:58 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jr2df8x2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Sep 2022 12:38:57 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28LCZKk4010346;
        Wed, 21 Sep 2022 12:38:55 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3jn5gj57pd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Sep 2022 12:38:55 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28LCcqS143516370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 12:38:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57E08A405C;
        Wed, 21 Sep 2022 12:38:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7914A4054;
        Wed, 21 Sep 2022 12:38:51 +0000 (GMT)
Received: from [9.171.94.233] (unknown [9.171.94.233])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 21 Sep 2022 12:38:51 +0000 (GMT)
Message-ID: <1271c956-a39c-fc2c-2c00-c1bc9d6cf8a4@linux.ibm.com>
Date:   Wed, 21 Sep 2022 14:38:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] KVM: s390: pci: register pci hooks without interpretation
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     farman@linux.ibm.com, schnelle@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220920193025.135655-1-mjrosato@linux.ibm.com>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220920193025.135655-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7bXY6XpcY8Wj5eFDzi6CvcLbrDx8U-5y
X-Proofpoint-GUID: tIB-Ef5IHCmuPXG5S8IOOHLGfaLc8SQl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_06,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 spamscore=0 impostorscore=0 mlxscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209210086
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/20/22 21:30, Matthew Rosato wrote:
> The kvm registration hooks must be registered even if the facilities
> necessary for zPCI interpretation are unavailable, as vfio-pci-zdev will
> expect to use the hooks regardless.
> This fixes an issue where vfio-pci-zdev will fail its open function
> because of a missing kvm_register when running on hardware that does not
> support zPCI interpretation.
> 
> Fixes: ca922fecda6c ("KVM: s390: pci: Hook to access KVM lowlevel from VFIO")
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>

> ---
>   arch/s390/kvm/kvm-s390.c |  4 ++--
>   arch/s390/kvm/pci.c      | 14 +++++++++++---
>   2 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index e20e126944aa..5c7f5f97ea09 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -510,7 +510,7 @@ int kvm_arch_init(void *opaque)
>   		goto out;
>   	}
>   
> -	if (kvm_s390_pci_interp_allowed()) {
> +	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)) {
>   		rc = kvm_s390_pci_init();
>   		if (rc) {
>   			pr_err("Unable to allocate AIFT for PCI\n");
> @@ -532,7 +532,7 @@ int kvm_arch_init(void *opaque)
>   void kvm_arch_exit(void)
>   {
>   	kvm_s390_gib_destroy();
> -	if (kvm_s390_pci_interp_allowed())
> +	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
>   		kvm_s390_pci_exit();
>   	debug_unregister(kvm_s390_dbf);
>   	debug_unregister(kvm_s390_dbf_uv);
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index 90aaba80696a..c50c1645c0ae 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -672,23 +672,31 @@ int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op *args)
>   
>   int kvm_s390_pci_init(void)
>   {
> +	zpci_kvm_hook.kvm_register = kvm_s390_pci_register_kvm;
> +	zpci_kvm_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
> +
> +	if (!kvm_s390_pci_interp_allowed())
> +		return 0;
> +
>   	aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
>   	if (!aift)
>   		return -ENOMEM;
>   
>   	spin_lock_init(&aift->gait_lock);
>   	mutex_init(&aift->aift_lock);
> -	zpci_kvm_hook.kvm_register = kvm_s390_pci_register_kvm;
> -	zpci_kvm_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
>   
>   	return 0;
>   }
>   
>   void kvm_s390_pci_exit(void)
>   {
> -	mutex_destroy(&aift->aift_lock);
>   	zpci_kvm_hook.kvm_register = NULL;
>   	zpci_kvm_hook.kvm_unregister = NULL;
>   
> +	if (!kvm_s390_pci_interp_allowed())
> +		return;
> +
> +	mutex_destroy(&aift->aift_lock);
> +
>   	kfree(aift);
>   }

-- 
Pierre Morel
IBM Lab Boeblingen
