Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B5E5712FE
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 09:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiGLHUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 03:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbiGLHUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 03:20:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCC98AB2B;
        Tue, 12 Jul 2022 00:20:27 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26C6Is0o001394;
        Tue, 12 Jul 2022 07:20:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zy22s8pMhCNao5oM0vPQHgdMV8SVWT0+1NPYYtQspaw=;
 b=V5WkxMyzCi0Fb6W7AF4hkTm5Kvf8ZoXF5sASHEk+DJ3yJe6h0TIEtGNmKJGUZ8PH6m79
 phgOfuhHeBRmpxxI13+4RRSr8JLwyadR8b8kMN2fjyEGzFoMxs4EnY+2LnsDyIew53cC
 4DdK1nSXj3Z8oRomGxUzW54VbuM5Plc3fiQ0D7D+ubOo8v12AoywUaQ6xgL2+UMkC4qT
 outIpGvWk+JLIrmu67caKsEPYqG9VYtrg5cZPgzrGjEai1iPAO2y6QRQpPi5CnB/pj2f
 UAK7OqnLJA6d7MphTgopNjfbg4YfqjFIfBKBqFN8zpVjo3VN8iRLEH6+COwANwHcePcA lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h92qdagf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 07:20:26 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26C6oGQD006381;
        Tue, 12 Jul 2022 07:20:17 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h92qdagec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 07:20:17 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26C76t61012195;
        Tue, 12 Jul 2022 07:20:15 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3h71a8jtrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 07:20:15 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26C7KBcc19267868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 07:20:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2B0B52050;
        Tue, 12 Jul 2022 07:20:11 +0000 (GMT)
Received: from [9.171.74.72] (unknown [9.171.74.72])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2A91E5204E;
        Tue, 12 Jul 2022 07:20:11 +0000 (GMT)
Message-ID: <a268d8b7-bbd8-089d-896c-e4e3e4167e46@linux.ibm.com>
Date:   Tue, 12 Jul 2022 09:24:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v12 3/3] KVM: s390: resetting the Topology-Change-Report
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220711084148.25017-1-pmorel@linux.ibm.com>
 <20220711084148.25017-4-pmorel@linux.ibm.com>
 <58016efc-9053-b743-05d6-4ace4dcdc2a8@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <58016efc-9053-b743-05d6-4ace4dcdc2a8@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VBY5H5UHEDGKvVYOVMg4Q13ViJB7T7v5
X-Proofpoint-GUID: 3gwn3EBGftuTAQdU58_-cYVP8hzDRk8g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_05,2022-07-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207120028
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/11/22 15:22, Janis Schoetterl-Glausch wrote:
> On 7/11/22 10:41, Pierre Morel wrote:
>> During a subsystem reset the Topology-Change-Report is cleared.
>>
>> Let's give userland the possibility to clear the MTCR in the case
>> of a subsystem reset.
>>
>> To migrate the MTCR, we give userland the possibility to
>> query the MTCR state.
>>
>> We indicate KVM support for the CPU topology facility with a new
>> KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> 

Thanks!

> See nits/comments below.
> 
>> ---
>>   Documentation/virt/kvm/api.rst   | 25 ++++++++++++++
>>   arch/s390/include/uapi/asm/kvm.h |  1 +
>>   arch/s390/kvm/kvm-s390.c         | 56 ++++++++++++++++++++++++++++++++
>>   include/uapi/linux/kvm.h         |  1 +
>>   4 files changed, 83 insertions(+)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 11e00a46c610..5e086125d8ad 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -7956,6 +7956,31 @@ should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
>>   When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
>>   type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
>>   
>> +8.37 KVM_CAP_S390_CPU_TOPOLOGY
>> +------------------------------
>> +
>> +:Capability: KVM_CAP_S390_CPU_TOPOLOGY
>> +:Architectures: s390
>> +:Type: vm
>> +
>> +This capability indicates that KVM will provide the S390 CPU Topology
>> +facility which consist of the interpretation of the PTF instruction for
>> +the function code 2 along with interception and forwarding of both the
>> +PTF instruction with function codes 0 or 1 and the STSI(15,1,x)
> 
> Is the architecture allowed to extend STSI without a facility?
> If so, if we say here that STSI 15.1.x is passed to user space, then
> I think we should have a
> 
> if (sel1 != 1)
> 	goto out_no_data;
> 
> or maybe even
> 
> if (sel1 != 1 || sel2 < 2 || sel2 > 6)
> 	goto out_no_data;
> 
> in priv.c

I am not a big fan of doing everything in the kernel.
Here we have no performance issue since it is an error of the guest if 
it sends a wrong selector.

Even testing the facility or PV in the kernel is for my opinion arguable 
in the case we do not do any treatment in the kernel.

I do not see what it brings to us, it increase the LOCs and makes the 
implementation less easy to evolve.


> 
>> +instruction to the userland hypervisor.
>> +
>> +The stfle facility 11, CPU Topology facility, should not be indicated
>> +to the guest without this capability.
>> +
>> +When this capability is present, KVM provides a new attribute group
>> +on vm fd, KVM_S390_VM_CPU_TOPOLOGY.
>> +This new attribute allows to get, set or clear the Modified Change
> 
> get or set, now that there is no explicit clear anymore.

Yes now it is a set to 0 but the action of clearing remains.

> 
>> +Topology Report (MTCR) bit of the SCA through the kvm_device_attr
>> +structure.> +
>> +When getting the Modified Change Topology Report value, the attr->addr
> 
> When getting/setting the...
> 
>> +must point to a byte where the value will be stored.
> 
> ... will be stored/retrieved from.

OK


>> +
>>   9. Known KVM API problems
>>   =========================
>>   
>> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
>> index 7a6b14874d65..a73cf01a1606 100644
>> --- a/arch/s390/include/uapi/asm/kvm.h
>> +++ b/arch/s390/include/uapi/asm/kvm.h
>> @@ -74,6 +74,7 @@ struct kvm_s390_io_adapter_req {
>>   #define KVM_S390_VM_CRYPTO		2
>>   #define KVM_S390_VM_CPU_MODEL		3
>>   #define KVM_S390_VM_MIGRATION		4
>> +#define KVM_S390_VM_CPU_TOPOLOGY	5
>>   
>>   /* kvm attributes for mem_ctrl */
>>   #define KVM_S390_VM_MEM_ENABLE_CMMA	0
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 70436bfff53a..b18e0b940b26 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -606,6 +606,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>   	case KVM_CAP_S390_PROTECTED:
>>   		r = is_prot_virt_host();
>>   		break;
>> +	case KVM_CAP_S390_CPU_TOPOLOGY:
>> +		r = test_facility(11);
>> +		break;
>>   	default:
>>   		r = 0;
>>   	}
>> @@ -817,6 +820,20 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>>   		icpt_operexc_on_all_vcpus(kvm);
>>   		r = 0;
>>   		break;
>> +	case KVM_CAP_S390_CPU_TOPOLOGY:
>> +		r = -EINVAL;
>> +		mutex_lock(&kvm->lock);
>> +		if (kvm->created_vcpus) {
>> +			r = -EBUSY;
>> +		} else if (test_facility(11)) {
>> +			set_kvm_facility(kvm->arch.model.fac_mask, 11);
>> +			set_kvm_facility(kvm->arch.model.fac_list, 11);
>> +			r = 0;
>> +		}
>> +		mutex_unlock(&kvm->lock);
>> +		VM_EVENT(kvm, 3, "ENABLE: CAP_S390_CPU_TOPOLOGY %s",
>> +			 r ? "(not available)" : "(success)");
>> +		break;
>>   	default:
>>   		r = -EINVAL;
>>   		break;
>> @@ -1717,6 +1734,36 @@ static void kvm_s390_update_topology_change_report(struct kvm *kvm, bool val)
>>   	read_unlock(&kvm->arch.sca_lock);
>>   }
>>   
>> +static int kvm_s390_set_topology(struct kvm *kvm, struct kvm_device_attr *attr)
> 
> kvm_s390_set_topology_changed maybe?
> kvm_s390_get_topology_changed below then.

No strong opinion, if you prefer I change this.

> 
>> +{
>> +	if (!test_kvm_facility(kvm, 11))
>> +		return -ENXIO;
>> +
>> +	kvm_s390_update_topology_change_report(kvm, !!attr->attr);
>> +	return 0;
>> +}
>> +
>> +static int kvm_s390_get_topology(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +	union sca_utility utility;
>> +	struct bsca_block *sca;
>> +	__u8 topo;
>> +
>> +	if (!test_kvm_facility(kvm, 11))
>> +		return -ENXIO;
>> +
>> +	read_lock(&kvm->arch.sca_lock);
>> +	sca = kvm->arch.sca;
>> +	utility.val = READ_ONCE(sca->utility.val);
> 
> I don't think you need the READ_ONCE anymore, now that there is a lock it should act as a compile barrier.

I think you are right.

>> +	read_unlock(&kvm->arch.sca_lock);
>> +	topo = utility.mtcr;
>> +
>> +	if (copy_to_user((void __user *)attr->addr, &topo, sizeof(topo)))
> 
> Why void not u8?

I like to say we write on "topo" with the size of "topo".
So we do not need to verify the effective size of topo.
But I understand, it is a UAPI, setting u8 in the copy_to_user makes 
sense too.
For my personal opinion, I would have prefer that userland tell us the 
size it awaits even here, for this special case, since we use a byte, we 
can not do really wrong.

> 
>> +		return -EFAULT;
>> +
>> +	return 0;
>> +}
>> +
> [...]
> 

-- 
Pierre Morel
IBM Lab Boeblingen
