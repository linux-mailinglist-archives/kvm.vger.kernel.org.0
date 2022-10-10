Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4155FA104
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 17:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJJPUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 11:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiJJPUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 11:20:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F3A543F2
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 08:20:17 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29AEhKQZ008514
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 15:20:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cKkZU7ZuGWbcA0GpqUtE7E1BQcHgvDQg2D+sMvJ/XHM=;
 b=jVsIYBfwy6MTYjmRqSgGEwCk5xvs+6IpOwHEfm6vKvkEgz1Fr4ghqpdHNjWOdY7dOsYM
 hMEOrmoqaqSSLFrULu38xlgusiFJ86OGvmlIwZigb0aZs6K4YApZyil7MdCgrVsUAwPK
 q/ktEA4P785/widfFIxctUHGoKo7IOx0BSHgWl/AGhkG58AqNINPbnqKDm5qTMEfJTXC
 8v2nIMn9Xvsi/K7jq2DjTxBGKpX0ikI+g0e74qHQSGEipL7tnZDgqwjV+TS+plpfuFrl
 xTut83Q/ibMxjnCTCwYT7n/BL/Pf2B8zl0+IMRI2mbuo+GamoQ/44IvOQXSVPfKPVKRN Sw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3k98h604-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 15:20:16 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29AFKFCP031978
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 15:20:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3k30u8t736-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 15:20:14 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29AFKBUf5767682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Oct 2022 15:20:11 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C2B711C052;
        Mon, 10 Oct 2022 15:20:11 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C5A011C050;
        Mon, 10 Oct 2022 15:20:11 +0000 (GMT)
Received: from [9.171.5.210] (unknown [9.171.5.210])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Oct 2022 15:20:10 +0000 (GMT)
Message-ID: <f982f740-1227-8033-a9bd-4830db8e5b6b@linux.ibm.com>
Date:   Mon, 10 Oct 2022 17:20:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, borntraeger@linux.ibm.com
References: <20221005163258.117232-1-nrb@linux.ibm.com>
 <20221005163258.117232-2-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v3 1/2] KVM: s390: pv: don't allow userspace to set the
 clock under PV
In-Reply-To: <20221005163258.117232-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S7hrRsO9x2Zd-Reno364FeF6Vj4DCfAn
X-Proofpoint-ORIG-GUID: S7hrRsO9x2Zd-Reno364FeF6Vj4DCfAn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-10_08,2022-10-10_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 mlxscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210100089
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/22 18:32, Nico Boehr wrote:
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
> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   arch/s390/kvm/kvm-s390.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)

This will ONLY result in a warning and there's no way that this can 
result in QEMU crashing, right?


> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index b7ef0b71014d..0a8019b14c8f 100644
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

Add comment:
For a protected guest the TOD is managed by the Ultravisor so trying to 
change it will never bring the expected results.

-EOPNOTSUPP is a new return code for the tod attribute, therefore 
programs using it might need a fix to be able to handle it.




And as -EOPNOTSUPP has never been used before you'll also need to 
update: Documentation/virt/kvm/devices/vm.rst



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

