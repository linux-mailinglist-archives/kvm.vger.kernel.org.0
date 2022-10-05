Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BC25F571D
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 17:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiJEPI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 11:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiJEPI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 11:08:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D80631C3
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 08:08:56 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295EM5H1008074
        for <kvm@vger.kernel.org>; Wed, 5 Oct 2022 15:08:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=2QmXvYTvfnTJbNVgdEw51V08yALEiV0nqgF7yYdCfnU=;
 b=jBR6VYr25HI+1msFzguNZ9sHb5L9aomXZjGnAWOKJzOQyeQTrbUajK4PsgQDeDJPUQx1
 pu8AEfdyQxEi6sDy2BIJ8gfdAeLwKL2LEtwV7iDqXYrk5tCsVrGZ/CUKl18Uo4GagafR
 8yaqiQL1A44YRXCaTjyamOz/EhDgO12yQ0g7NXinp9j2MrdrU9dTxXb5FWZaFzbv2KGW
 vxTfFKia1EZumMb2gxqnN8294EdogTC9K5Udmb8Q24c/i2GmgsuMhyBbrGRqI+BM5MZU
 /199eN2+MUJpQrsqtRS1ZF2SSaCkD3fYROnf+ZcRrK+pajn++8uUyzHac0mLVNPSPuC4 TA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1bmjhpj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 15:08:55 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 295F64JT021969
        for <kvm@vger.kernel.org>; Wed, 5 Oct 2022 15:08:54 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3jxctj5r2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 15:08:54 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 295F8pJ86095426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Oct 2022 15:08:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14021A405B;
        Wed,  5 Oct 2022 15:08:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D965BA4054;
        Wed,  5 Oct 2022 15:08:50 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.242])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Oct 2022 15:08:50 +0000 (GMT)
Date:   Wed, 5 Oct 2022 17:08:48 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: Re: [RFC PATCH v2 1/1] KVM: s390: pv: don't allow userspace to set
 the clock under PV
Message-ID: <20221005170848.1385e673@p-imbrenda>
In-Reply-To: <20220829075602.6611-2-nrb@linux.ibm.com>
References: <20220829075602.6611-1-nrb@linux.ibm.com>
        <20220829075602.6611-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pxtj4QLy_tVn9ASqoIelo0vbpwZqudUT
X-Proofpoint-GUID: pxtj4QLy_tVn9ASqoIelo0vbpwZqudUT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_01,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210050094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 29 Aug 2022 09:56:02 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> When running under PV, the guest's TOD clock is under control of the
> ultravisor and the hypervisor isn't allowed to change it. Hence, don't
> allow userspace to change the guest's TOD clock by returning
> -EOPNOTSUPP.
> 
> When userspace changes the guest's TOD clock, KVM updates its
> kvm.arch.epoch field and, in addition, the epoch field in all state
> descriptions of all VCPUs.
> 
> But, under PV, the ultravisor will ignore the epoch field in the state
> description and simply overwrite it on next SIE exit with the actual
> guest epoch. This leads to KVM having an incorrect view of the guest's
> TOD clock: it has updated its internal kvm.arch.epoch field, but the
> ultravisor ignores the field in the state description.
> 
> Whenever a guest is now waiting for a clock comparator, KVM will
> incorrectly calculate the time when the guest should wake up, possibly
> causing the guest to sleep for much longer than expected.
> 
> With this change, kvm_s390_set_tod() will now take the kvm->lock to be
> able to call kvm_s390_pv_is_protected(). Since kvm_s390_set_tod_clock()
> also takes kvm->lock, use __kvm_s390_set_tod_clock() instead.
> 
> Fixes: 0f3035047140 ("KVM: s390: protvirt: Do only reset registers that are accessible")
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index edfd4bbd0cba..f4ee88e787fe 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1207,6 +1207,8 @@ static int kvm_s390_vm_get_migration(struct kvm *kvm,
>  	return 0;
>  }
>  
> +static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);

are there any users of kvm_s390_set_tod_clock left after this patch?

maybe that wrapper can be removed (also from the headers), and we can
keep the function with the __

it's perhaps cleaner to have a second patch to remove the unused stuff

> +
>  static int kvm_s390_set_tod_ext(struct kvm *kvm, struct kvm_device_attr *attr)
>  {
>  	struct kvm_s390_vm_tod_clock gtod;
> @@ -1216,7 +1218,7 @@ static int kvm_s390_set_tod_ext(struct kvm *kvm, struct kvm_device_attr *attr)
>  
>  	if (!test_kvm_facility(kvm, 139) && gtod.epoch_idx)
>  		return -EINVAL;
> -	kvm_s390_set_tod_clock(kvm, &gtod);
> +	__kvm_s390_set_tod_clock(kvm, &gtod);
>  
>  	VM_EVENT(kvm, 3, "SET: TOD extension: 0x%x, TOD base: 0x%llx",
>  		gtod.epoch_idx, gtod.tod);
> @@ -1247,7 +1249,7 @@ static int kvm_s390_set_tod_low(struct kvm *kvm, struct kvm_device_attr *attr)
>  			   sizeof(gtod.tod)))
>  		return -EFAULT;
>  
> -	kvm_s390_set_tod_clock(kvm, &gtod);
> +	__kvm_s390_set_tod_clock(kvm, &gtod);
>  	VM_EVENT(kvm, 3, "SET: TOD base: 0x%llx", gtod.tod);
>  	return 0;
>  }
> @@ -1259,6 +1261,12 @@ static int kvm_s390_set_tod(struct kvm *kvm, struct kvm_device_attr *attr)
>  	if (attr->flags)
>  		return -EINVAL;
>  
> +	mutex_lock(&kvm->lock);
> +	if (kvm_s390_pv_is_protected(kvm)) {
> +		ret = -EOPNOTSUPP;
> +		goto out_unlock;
> +	}
> +
>  	switch (attr->attr) {
>  	case KVM_S390_VM_TOD_EXT:
>  		ret = kvm_s390_set_tod_ext(kvm, attr);
> @@ -1273,6 +1281,9 @@ static int kvm_s390_set_tod(struct kvm *kvm, struct kvm_device_attr *attr)
>  		ret = -ENXIO;
>  		break;
>  	}
> +
> +out_unlock:
> +	mutex_unlock(&kvm->lock);
>  	return ret;
>  }
>  

