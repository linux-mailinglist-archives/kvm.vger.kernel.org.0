Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9661754C542
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 11:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347295AbiFOJ7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 05:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347294AbiFOJ7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 05:59:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340A83B2B2;
        Wed, 15 Jun 2022 02:59:44 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25F8dYot026177;
        Wed, 15 Jun 2022 09:59:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TeixsNQbLwvMEPn7lXyqsgYrOwtvRiNkoBG8rNo/Uyo=;
 b=Z5OL978gJou6Pi1lFx4Bd56r9yJTZhXXIsjIBNmJtyWYS10xh11soFwftnkvSoghcO2g
 CiW7kECkkdwUgQOQ963DKB+WAx1/wRB452VENuNZPfVP6ISIrWvXRu4Rf30rTUVsM94O
 9IjF22eFPuHBfHOHEm+8JTbzvYITuwLVhjWHbMI3+CTAOLUAGfePjD6m687pFHgYxjKW
 9BfEqWVpmZ5oUjpZ98QVIbl9Jq5pLSLiRiYtKu+SDHlusiU/ATpRNXha3Zr8uQU2xIKu
 kYVWjriG3UjWcGsU7H3RG9QjYKMg+DNaypTRNJGtBNNuxW8Y1PdHDfYAjWm0mTjNASB9 PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpp6jeawp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 09:59:43 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25F9Zhor032082;
        Wed, 15 Jun 2022 09:59:43 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpp6jeavr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 09:59:43 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25F9obD8025993;
        Wed, 15 Jun 2022 09:59:40 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3gmjajdmh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 09:59:40 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25F9xbCS17367330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 09:59:37 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52E51AE04D;
        Wed, 15 Jun 2022 09:59:37 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFB6AAE045;
        Wed, 15 Jun 2022 09:59:36 +0000 (GMT)
Received: from [9.145.158.83] (unknown [9.145.158.83])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 Jun 2022 09:59:36 +0000 (GMT)
Message-ID: <0a13397a-86e0-7c25-0044-7a5733f61730@linux.ibm.com>
Date:   Wed, 15 Jun 2022 11:59:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
References: <20220603065645.10019-1-imbrenda@linux.ibm.com>
 <20220603065645.10019-15-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v11 14/19] KVM: s390: pv: cleanup leftover protected VMs
 if needed
In-Reply-To: <20220603065645.10019-15-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1y0irkH7GOV4QmrrioXjVZZCp9xey4Kd
X-Proofpoint-ORIG-GUID: i1uOJL1657KvTC5fPOjJaFvTtKAZxMES
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-15_03,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206150036
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/22 08:56, Claudio Imbrenda wrote:
> In upcoming patches it will be possible to start tearing down a
> protected VM, and finish the teardown concurrently in a different
> thread.

s/,/
s/the/its/

> 
> Protected VMs that are pending for tear down ("leftover") need to be
> cleaned properly when the userspace process (e.g. qemu) terminates.
> 
> This patch makes sure that all "leftover" protected VMs are always
> properly torn down.

So we're handling the kvm_arch_destroy_vm() case here, right?
Maybe add that in a more prominent way and rework the subject:

KVM: s390: pv: cleanup leftover PV VM shells on VM shutdown

> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h |   2 +
>   arch/s390/kvm/kvm-s390.c         |   2 +
>   arch/s390/kvm/pv.c               | 109 ++++++++++++++++++++++++++++---
>   3 files changed, 104 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 5824efe5fc9d..cca8e05e0a71 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -924,6 +924,8 @@ struct kvm_s390_pv {
>   	u64 guest_len;
>   	unsigned long stor_base;
>   	void *stor_var;
> +	void *prepared_for_async_deinit;
> +	struct list_head need_cleanup;
>   	struct mmu_notifier mmu_notifier;
>   };
>   
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index fe1fa896def7..369de8377116 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2890,6 +2890,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	kvm_s390_vsie_init(kvm);
>   	if (use_gisa)
>   		kvm_s390_gisa_init(kvm);
> +	INIT_LIST_HEAD(&kvm->arch.pv.need_cleanup);
> +	kvm->arch.pv.prepared_for_async_deinit = NULL;
>   	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
>   
>   	return 0;
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 6cffea26c47f..8471c17d538c 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -17,6 +17,19 @@
>   #include <linux/mmu_notifier.h>
>   #include "kvm-s390.h"
>   
> +/**
> + * @struct leftover_pv_vm

Any other ideas on naming these VMs?
Also I'd turn that around: pv_vm_leftover

> + * Represents a "leftover" protected VM that is still registered with the
> + * Ultravisor, but which does not correspond any longer to an active KVM VM.
> + */
> +struct leftover_pv_vm {
> +	struct list_head list;
> +	unsigned long old_gmap_table;
> +	u64 handle;
> +	void *stor_var;
> +	unsigned long stor_base;
> +};
> +

I think we should switch this patch and the next one and add this struct 
to the next patch. The list work below makes more sense once the next 
patch has been read.

>   static void kvm_s390_clear_pv_state(struct kvm *kvm)
>   {
>   	kvm->arch.pv.handle = 0;
> @@ -158,23 +171,88 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
>   	return -ENOMEM;
>   }
>   

>   

