Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298574AB96C
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 12:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbiBGLKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 06:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243672AbiBGLFH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 06:05:07 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627A2C043188;
        Mon,  7 Feb 2022 03:05:06 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2178LT1j001365;
        Mon, 7 Feb 2022 11:05:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RD64Ji/IfEP734Rh2SZfk6LYte1PyTzLo0Dg4ga3DHA=;
 b=gqGRvgQEuQQjsMp7o4jDCmAUcws/3KeLI7LgrSlu961khy/4oKEKInmj1RVPjVA34Yic
 n/Oo02fX5szgxRWqsbox0Hdh6w2JKPgsl6lJVoxFkJzeN/MpUnoGoYfsqMvBMSEAHEex
 2CA0x1PdGGIzuWtruCgR1HFL8aUqiLASOGQmJGHUABgupsd95q0JPsuJV1TmDoMfUiRt
 L+aXEkWDKN33mw6FVbwE9KPydXRvFcSZ/EBSG3p5MCY03V55Ovxj8M9hq30CJ9kGj2ZT
 DaskVpxV4kJho8yLFxoJ6uP3Eih0GM2+Mi0YFOc96SHQquyZIYMa8z8ThwVSfrh8CiYw Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22u78y8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 11:05:05 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217AZjJx012205;
        Mon, 7 Feb 2022 11:05:05 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22u78y7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 11:05:05 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217B2VFI028113;
        Mon, 7 Feb 2022 11:05:02 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3e1gv93ahk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 11:05:02 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217B4vVk47710616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 11:04:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 220D44208B;
        Mon,  7 Feb 2022 11:04:57 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7EF842049;
        Mon,  7 Feb 2022 11:04:56 +0000 (GMT)
Received: from [9.145.9.42] (unknown [9.145.9.42])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 11:04:56 +0000 (GMT)
Message-ID: <28955238-1fac-ad9a-f2bb-2c6c0c2ed894@linux.ibm.com>
Date:   Mon, 7 Feb 2022 12:04:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
 <20220204155349.63238-11-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v7 10/17] KVM: s390: pv: add mmu_notifier
In-Reply-To: <20220204155349.63238-11-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bSvq6_uLlqeSZg-Xb77eu3LWPqNWRtHG
X-Proofpoint-GUID: K7kBAmbTB-296jSLZIZKMXN3UUOs5wJL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_03,2022-02-07_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 16:53, Claudio Imbrenda wrote:
> Add an mmu_notifier for protected VMs. The callback function is
> triggered when the mm is torn down, and will attempt to convert all
> protected vCPUs to non-protected. This allows the mm teardown to use
> the destroy page UVC instead of export.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h |  2 ++
>   arch/s390/kvm/pv.c               | 20 ++++++++++++++++++++
>   2 files changed, 22 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index a22c9266ea05..1bccb8561ba9 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -19,6 +19,7 @@
>   #include <linux/kvm.h>
>   #include <linux/seqlock.h>
>   #include <linux/module.h>
> +#include <linux/mmu_notifier.h>
>   #include <asm/debug.h>
>   #include <asm/cpu.h>
>   #include <asm/fpu/api.h>
> @@ -921,6 +922,7 @@ struct kvm_s390_pv {
>   	u64 guest_len;
>   	unsigned long stor_base;
>   	void *stor_var;
> +	struct mmu_notifier mmu_notifier;
>   };
>   
>   struct kvm_arch{
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index f1e812a45acb..d3b8fd9b5b3e 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -193,6 +193,21 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>   	return -EIO;
>   }
>   
> +static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
> +					     struct mm_struct *mm)
> +{
> +	struct kvm *kvm = container_of(subscription, struct kvm, arch.pv.mmu_notifier);

Are we sure that the kvm pointer is still valid at this point?

> +	u16 dummy;
> +
> +	mutex_lock(&kvm->lock);

Against what are we locking here?

> +	kvm_s390_cpus_from_pv(kvm, &dummy, &dummy);

I'd guess that we can't really have a second kvm_s390_cpus_from_pv() 
call in flight, right? If the mm is being torn down there would be no 
code left that can execute the IOCTL.

> +	mutex_unlock(&kvm->lock);
> +}
> +
> +static const struct mmu_notifier_ops kvm_s390_pv_mmu_notifier_ops = {
> +	.release = kvm_s390_pv_mmu_notifier_release,
> +};
> +
>   int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>   {
>   	struct uv_cb_cgc uvcb = {
> @@ -234,6 +249,11 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>   		return -EIO;
>   	}
>   	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
> +	/* Add the notifier only once. No races because we hold kvm->lock */
> +	if (kvm->arch.pv.mmu_notifier.ops != &kvm_s390_pv_mmu_notifier_ops) {
> +		kvm->arch.pv.mmu_notifier.ops = &kvm_s390_pv_mmu_notifier_ops;
> +		mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
> +	}
>   	return 0;
>   }
>   
> 

