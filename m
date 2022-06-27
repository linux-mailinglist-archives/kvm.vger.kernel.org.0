Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B57055C314
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235685AbiF0Nak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 09:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235667AbiF0Naj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 09:30:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281D26453;
        Mon, 27 Jun 2022 06:30:38 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RDDZ3v030734;
        Mon, 27 Jun 2022 13:30:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=oUBDG1cP9dlRbKbkkpWlI6iQvBOWtTrF/brBMXTFU1M=;
 b=ihRMPF4Sfi8HVZgFJ2x9FdllJQboFmu2kVU3dYc9MBw103itoaxyCOgiunCZXaVuZspp
 /H8r/6yTwuHK2Qzos5hj3hvZK6LvHpJSUI/UvutdDVcigw37z3Dddt7v6CGhZTNoT+8+
 tZ7TJOABlwqJKaMUOShpQBXNnxZo7H5SnOpFrXrgg5VBZn4qixz7ovW/9a5aov6WEFjG
 IKTQPeAXuOEboJJiPjxCrinCIIo0w9PCDdSjUQl8IM28uGgsCQBntrFrEoe/+T7Z274W
 ZULs8HJHxaEqAqMPVmSpVzOPH4tByhIarRNd9G4g/oc+OFEdISXLVm6ndF1+3wgVtuKi WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyd89geqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 13:30:37 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25RDE49Q031483;
        Mon, 27 Jun 2022 13:30:36 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyd89gept-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 13:30:36 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25RDKYWR018009;
        Mon, 27 Jun 2022 13:30:35 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3gwt08ta1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 13:30:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25RDUVdc19071258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 13:30:31 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B85111C058;
        Mon, 27 Jun 2022 13:30:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CBB2411C04C;
        Mon, 27 Jun 2022 13:30:30 +0000 (GMT)
Received: from [9.171.84.214] (unknown [9.171.84.214])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jun 2022 13:30:30 +0000 (GMT)
Message-ID: <48c10cf4-98c7-9203-3edc-ad88fdd1c7bf@linux.ibm.com>
Date:   Mon, 27 Jun 2022 15:34:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v10 3/3] KVM: s390: resetting the Topology-Change-Report
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
References: <20220620125437.37122-1-pmorel@linux.ibm.com>
 <20220620125437.37122-4-pmorel@linux.ibm.com>
 <7d50c2df-7cad-dbc6-baa0-ab647f8dde4e@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <7d50c2df-7cad-dbc6-baa0-ab647f8dde4e@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tlq26awHELpvgqGZh5IHmOVRGU3mM--r
X-Proofpoint-GUID: ww3NyujDHFH_NWuqPDhyWpHXkvrrPDtj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 malwarescore=0 phishscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206270058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/24/22 08:50, Janosch Frank wrote:
> On 6/20/22 14:54, Pierre Morel wrote:
>> During a subsystem reset the Topology-Change-Report is cleared.
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
>> ---
>>   Documentation/virt/kvm/api.rst   | 31 +++++++++++
>>   arch/s390/include/uapi/asm/kvm.h | 10 ++++
>>   arch/s390/kvm/kvm-s390.c         | 96 ++++++++++++++++++++++++++++++++
>>   include/uapi/linux/kvm.h         |  1 +
>>   4 files changed, 138 insertions(+)
>>
>> diff --git a/Documentation/virt/kvm/api.rst 
>> b/Documentation/virt/kvm/api.rst
>> index 11e00a46c610..326f8b7e7671 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -7956,6 +7956,37 @@ should adjust CPUID leaf 0xA to reflect that 
>> the PMU is disabled.
>>   When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
>>   type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
>> +8.37 KVM_CAP_S390_CPU_TOPOLOGY
>> +------------------------------
>> +
>> +:Capability: KVM_CAP_S390_CPU_TOPOLOGY
>> +:Architectures: s390
>> +:Type: vm
>> +
>> +This capability indicates that KVM will provide the S390 CPU Topology
>> +facility which consist of the interpretation of the PTF instruction for
>> +the Function Code 2 along with interception and forwarding of both the
> 
> Making function code capital surprises me when reading.

wanted to highlight FC.
I remove it.

> 
>> +PTF instruction with Function Codes 0 or 1 and the STSI(15,1,x)
>> +instruction to the userland hypervisor.
>> +
>> +The stfle facility 11, CPU Topology facility, should not be provided
> 
> s/provided/indicated
> 
OK

>> +to the guest without this capability.
>> +
>> +When this capability is present, KVM provides a new attribute group
>> +on vm fd, KVM_S390_VM_CPU_TOPOLOGY.
>> +This new attribute allows to get, set or clear the Modified Change
>> +Topology Report (MTCR) bit of the SCA through the kvm_device_attr
>> +structure.
>> +
>> +Getting the MTCR bit is realized by using a kvm_device_attr attr
>> +entry value of KVM_GET_DEVICE_ATTR and with kvm_device_attr addr
>> +entry pointing to the address of a struct kvm_cpu_topology.
>> +The value of the MTCR is return by the bit mtcr of the structure. > +
>> +When using KVM_SET_DEVICE_ATTR the MTCR is set by using the
>> +attr->attr value KVM_S390_VM_CPU_TOPO_MTCR_SET and cleared by
>> +using KVM_S390_VM_CPU_TOPO_MTCR_CLEAR.
> 
> I have the feeling that we can drop the two blocks above and we won't 
> loose information.
> 
>> +/**
>> + * kvm_s390_sca_clear_mtcr
>> + * @kvm: guest KVM description
>> + *
>> + * Is only relevant if the topology facility is present,
>> + * the caller should check KVM facility 11
>> + *
>> + * Updates the Multiprocessor Topology-Change-Report to signal
>> + * the guest with a topology change.
>> + */
>> +static void kvm_s390_sca_clear_mtcr(struct kvm *kvm)
> 
> This is a set operation with the value 0 and that's clearly visible by 
> the copied code. If you make the utility entry a bitfield you can easily 
> set 0/1 via one function without doing the bit manipulation by hand.

OK

> 
> I.e. please only use one set function.
> 
>> +{
>> +    struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't 
>> matter */
>> +
>> +    ipte_lock(kvm);
>> +    sca->utility &= ~SCA_UTILITY_MTCR;
>> +    ipte_unlock(kvm);
>> +}
>> +
>> +static int kvm_s390_set_topology(struct kvm *kvm, struct 
>> kvm_device_attr *attr)
>> +{
>> +    if (!test_kvm_facility(kvm, 11))
>> +        return -ENXIO;
>> +
>> +    switch (attr->attr) {
>> +    case KVM_S390_VM_CPU_TOPO_MTCR_SET:
>> +        kvm_s390_sca_set_mtcr(kvm);
>> +        break;
>> +    case KVM_S390_VM_CPU_TOPO_MTCR_CLEAR:
>> +        kvm_s390_sca_clear_mtcr(kvm);
>> +        break;
>> +    }
> 
> By having two endpoints here we trade an easy check with having to 
> access process memory to grab the value we want to set.
> 
> I'm still torn about this.
> 
>> +    return 0;
>> +}
>> +
>> +/**
>> + * kvm_s390_sca_get_mtcr
>> + * @kvm: guest KVM description
>> + *
>> + * Is only relevant if the topology facility is present,
>> + * the caller should check KVM facility 11
>> + *
>> + * reports to QEMU the Multiprocessor Topology-Change-Report.
>> + */
>> +static int kvm_s390_sca_get_mtcr(struct kvm *kvm)
>> +{
>> +    struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't 
>> matter */
> 
> Same comments as with the set_mtcr()

OK

> 
>> +    int val;
>> +
>> +    ipte_lock(kvm);
>> +    val = sca->utility & SCA_UTILITY_MTCR;
>> +    ipte_unlock(kvm);
>> +
>> +    return val;
>> +}
>> +
>> +static int kvm_s390_get_topology(struct kvm *kvm, struct 
>> kvm_device_attr *attr)
>> +{
>> +    struct kvm_cpu_topology topo = {};
>> +
>> +    if (!test_kvm_facility(kvm, 11))
>> +        return -ENXIO;
>> +
>> +    topo.mtcr = kvm_s390_sca_get_mtcr(kvm) ? 1 : 0;
>> +    if (copy_to_user((void __user *)attr->addr, &topo, sizeof(topo)))
>> +        return -EFAULT;
>> +
>> +    return 0;
>> +}
>> +
>>   static int kvm_s390_vm_set_attr(struct kvm *kvm, struct 
>> kvm_device_attr *attr)
>>   {
>>       int ret;
>> @@ -1730,6 +1817,9 @@ static int kvm_s390_vm_set_attr(struct kvm *kvm, 
>> struct kvm_device_attr *attr)
>>       case KVM_S390_VM_MIGRATION:
>>           ret = kvm_s390_vm_set_migration(kvm, attr);
>>           break;
>> +    case KVM_S390_VM_CPU_TOPOLOGY:
>> +        ret = kvm_s390_set_topology(kvm, attr);
>> +        break;
>>       default:
>>           ret = -ENXIO;
>>           break;
>> @@ -1755,6 +1845,9 @@ static int kvm_s390_vm_get_attr(struct kvm *kvm, 
>> struct kvm_device_attr *attr)
>>       case KVM_S390_VM_MIGRATION:
>>           ret = kvm_s390_vm_get_migration(kvm, attr);
>>           break;
>> +    case KVM_S390_VM_CPU_TOPOLOGY:
>> +        ret = kvm_s390_get_topology(kvm, attr);
>> +        break;
>>       default:
>>           ret = -ENXIO;
>>           break;
>> @@ -1828,6 +1921,9 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, 
>> struct kvm_device_attr *attr)
>>       case KVM_S390_VM_MIGRATION:
>>           ret = 0;
>>           break;
>> +    case KVM_S390_VM_CPU_TOPOLOGY:
>> +        ret = test_kvm_facility(kvm, 11) ? 0 : -ENXIO;
>> +        break;
>>       default:
>>           ret = -ENXIO;
>>           break;
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 5088bd9f1922..33317d820032 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1157,6 +1157,7 @@ struct kvm_ppc_resize_hpt {
>>   #define KVM_CAP_VM_TSC_CONTROL 214
>>   #define KVM_CAP_SYSTEM_EVENT_DATA 215
>>   #define KVM_CAP_ARM_SYSTEM_SUSPEND 216
>> +#define KVM_CAP_S390_CPU_TOPOLOGY 217
>>   #ifdef KVM_CAP_IRQ_ROUTING
> 

-- 
Pierre Morel
IBM Lab Boeblingen
