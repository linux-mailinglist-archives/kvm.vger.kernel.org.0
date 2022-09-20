Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C9E5BE41F
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 13:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiITLIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 07:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiITLI2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 07:08:28 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD662D1F3
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 04:08:27 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAwVcL025696
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 11:08:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sGwVgD4NM4y+koYc8zu5G5aCj1nlfzPMHQYi91gHybw=;
 b=g0bdkgvwE2Kg8joHvMCrDvYmXz58vtRyDJ9JdIVvuBu5IpTWuMYPU+hpojfblOfm6JRr
 xLz0uf0zK0no9hi049Q3oYjLGy4JXLGS26/mfAxRREssyFXn37Cm/nynVZTdRD8oPkuk
 bIWzQFmMpTaDDa/n2+07dV7nYB0/pRxWZ5RZk1ChiKSP2VIIzoR2ymSdBnhF+v4qdE6P
 EoZdji3qOfaerYzmqmswXs6ZvOKZ37Klp7BXQCq4pt1DMODn11iHV4hnw9n5Pjy4hV2+
 n2wM2n/r14Y+ythpeukhWgmaEFluu62bnH4Knwsa4CLTodl4PjlJZoSFq4HgMbMXEfIm qw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jqc820cw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 11:08:25 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28KB7L5D013491
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 11:08:01 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3jn5v8krqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 11:08:01 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28KB7waY43647290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 11:07:58 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E3C011C074;
        Tue, 20 Sep 2022 11:07:58 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5984211C06E;
        Tue, 20 Sep 2022 11:07:58 +0000 (GMT)
Received: from [9.171.64.251] (unknown [9.171.64.251])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Sep 2022 11:07:58 +0000 (GMT)
Message-ID: <e0f29156-6862-478b-4918-583cbe6adaeb@linux.ibm.com>
Date:   Tue, 20 Sep 2022 13:07:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC PATCH v2 1/1] KVM: s390: pv: don't allow userspace to set
 the clock under PV
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220829075602.6611-1-nrb@linux.ibm.com>
 <20220829075602.6611-2-nrb@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220829075602.6611-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8n8SCYmSYuni0902FcgJAapcbQ0rZA2H
X-Proofpoint-ORIG-GUID: 8n8SCYmSYuni0902FcgJAapcbQ0rZA2H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_02,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 impostorscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209200064
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 29.08.22 um 09:56 schrieb Nico Boehr:
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

Has this patch already been sent to the upstream list yet and have we solved all existing problems of the previous version?
> ---
>   arch/s390/kvm/kvm-s390.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index edfd4bbd0cba..f4ee88e787fe 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1207,6 +1207,8 @@ static int kvm_s390_vm_get_migration(struct kvm *kvm,
>   	return 0;
>   }
>   
> +static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
> +
>   static int kvm_s390_set_tod_ext(struct kvm *kvm, struct kvm_device_attr *attr)
>   {
>   	struct kvm_s390_vm_tod_clock gtod;
> @@ -1216,7 +1218,7 @@ static int kvm_s390_set_tod_ext(struct kvm *kvm, struct kvm_device_attr *attr)
>   
>   	if (!test_kvm_facility(kvm, 139) && gtod.epoch_idx)
>   		return -EINVAL;
> -	kvm_s390_set_tod_clock(kvm, &gtod);
> +	__kvm_s390_set_tod_clock(kvm, &gtod);
>   
>   	VM_EVENT(kvm, 3, "SET: TOD extension: 0x%x, TOD base: 0x%llx",
>   		gtod.epoch_idx, gtod.tod);
> @@ -1247,7 +1249,7 @@ static int kvm_s390_set_tod_low(struct kvm *kvm, struct kvm_device_attr *attr)
>   			   sizeof(gtod.tod)))
>   		return -EFAULT;
>   
> -	kvm_s390_set_tod_clock(kvm, &gtod);
> +	__kvm_s390_set_tod_clock(kvm, &gtod);
>   	VM_EVENT(kvm, 3, "SET: TOD base: 0x%llx", gtod.tod);
>   	return 0;
>   }
> @@ -1259,6 +1261,12 @@ static int kvm_s390_set_tod(struct kvm *kvm, struct kvm_device_attr *attr)
>   	if (attr->flags)
>   		return -EINVAL;
>   
> +	mutex_lock(&kvm->lock);
> +	if (kvm_s390_pv_is_protected(kvm)) {
> +		ret = -EOPNOTSUPP;
> +		goto out_unlock;
> +	}
> +
>   	switch (attr->attr) {
>   	case KVM_S390_VM_TOD_EXT:
>   		ret = kvm_s390_set_tod_ext(kvm, attr);
> @@ -1273,6 +1281,9 @@ static int kvm_s390_set_tod(struct kvm *kvm, struct kvm_device_attr *attr)
>   		ret = -ENXIO;
>   		break;
>   	}
> +
> +out_unlock:
> +	mutex_unlock(&kvm->lock);
>   	return ret;
>   }
>   
