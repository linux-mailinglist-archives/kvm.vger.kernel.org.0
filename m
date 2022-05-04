Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336EB519916
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 10:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345998AbiEDIFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 04:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345990AbiEDIFi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 04:05:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8291FA7E;
        Wed,  4 May 2022 01:02:03 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2447g8aS001977;
        Wed, 4 May 2022 08:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zYiugQCEbla+glZIGRjMD7avsHWg9fVoRjn5c5kH9KE=;
 b=O+Dbpehv5mJrV0lnlmXn6Db7EpBhRoImkVai5GkRQZm4T1T+vR6WKZBCznpbEU+rufXz
 ImnN+uqXHBoORjA3Rmpnl0Zw+IZHgLzcG5aFO52KVK+tkk4zjBzjYiAqcIp2aCmeS8W+
 58lvWyUhPAwYwvMRsieW56zH6THc2gHjh7CXAb27o8tzYQQOPe1D+A/ulSCp1JNWnE/x
 UQawT3u3tH+n3YoQK3ExT4Fr5wwRTFrDsVXNQ+m3Zi1nBE9lwHKsT4Z1ykImE8eHLAUu
 w69g8Jpj+qAZhU8/81Wy9+5pRbcWS1/itiTJIZIJ3TlVo3oHecjFSzQQqZIY7htXFS8B qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3funaw09j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 08:02:02 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2447kUFb016011;
        Wed, 4 May 2022 08:02:02 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3funaw09h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 08:02:02 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2447qIWl031744;
        Wed, 4 May 2022 08:02:00 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3frvr8v7yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 08:01:59 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24481uDM32899378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 May 2022 08:01:56 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CFD011C050;
        Wed,  4 May 2022 08:01:56 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A357C11C04A;
        Wed,  4 May 2022 08:01:55 +0000 (GMT)
Received: from [9.171.18.44] (unknown [9.171.18.44])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 May 2022 08:01:55 +0000 (GMT)
Message-ID: <a76353f4-9bad-ba8d-a899-4b0fbdc9ef5a@linux.ibm.com>
Date:   Wed, 4 May 2022 10:05:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v8 2/2] s390x: KVM: resetting the Topology-Change-Report
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
References: <20220420113430.11876-1-pmorel@linux.ibm.com>
 <20220420113430.11876-3-pmorel@linux.ibm.com>
 <22f7742e-c009-c53b-8f14-34156ea1d135@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <22f7742e-c009-c53b-8f14-34156ea1d135@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: slEGLsjrGK4X8D1OnusW0gGVtBf4dm3q
X-Proofpoint-ORIG-GUID: XwqTH82HUKAcqqNrrE0uKwsXTvckVLRK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-04_02,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 spamscore=0 impostorscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205040054
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/28/22 15:50, David Hildenbrand wrote:
> On 20.04.22 13:34, Pierre Morel wrote:
>> During a subsystem reset the Topology-Change-Report is cleared.
>> Let's give userland the possibility to clear the MTCR in the case
>> of a subsystem reset.
>>
>> To migrate the MTCR, let's give userland the possibility to
>> query the MTCR state.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   arch/s390/include/uapi/asm/kvm.h |   9 +++
>>   arch/s390/kvm/kvm-s390.c         | 103 +++++++++++++++++++++++++++++++
>>   2 files changed, 112 insertions(+)
>>
>> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
>> index 7a6b14874d65..bb3df6d49f27 100644
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
>> @@ -171,6 +172,14 @@ struct kvm_s390_vm_cpu_subfunc {
>>   #define KVM_S390_VM_MIGRATION_START	1
>>   #define KVM_S390_VM_MIGRATION_STATUS	2
>>   
>> +/* kvm attributes for cpu topology */
>> +#define KVM_S390_VM_CPU_TOPO_MTR_CLEAR	0
>> +#define KVM_S390_VM_CPU_TOPO_MTR_SET	1
>> +
>> +struct kvm_s390_cpu_topology {
>> +	__u16 mtcr;
>> +};
> 
> Just wondering:
> 
> 1) Do we really need a struct for that
> 2) Do we want to leave some room for later expansion?

Yes it is the goal, if we want to report more topology information for 
the case the vCPUs are not pin on the real CPUs.
In this case I think we need to report more information on the vCPU 
topology to the guest.
For now I explicitly limited the case to pinned vCPUs.

But the change from a u16 to a structure can be done at that moment.

> 
>> +
>>   /* for KVM_GET_REGS and KVM_SET_REGS */
>>   struct kvm_regs {
>>   	/* general purpose regs for s390 */
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 925ccc59f283..755f325c9e70 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -1756,6 +1756,100 @@ static int kvm_s390_sca_set_mtcr(struct kvm *kvm)
>>   	return 0;
>>   }
>>   
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
>> +static int kvm_s390_sca_clear_mtcr(struct kvm *kvm)
>> +{
>> +	struct bsca_block *sca = kvm->arch.sca;
>> +	struct kvm_vcpu *vcpu;
>> +	int val;
>> +
>> +	vcpu = kvm_s390_get_first_vcpu(kvm);
>> +	if (!vcpu)
>> +		return -ENODEV;
> 
> It would be cleaner to have ipte_lock/ipte_unlock variants that are
> independent of a vcpu.
> 
> Instead of checking for "vcpu->arch.sie_block->eca & ECA_SII" we might
> just check for sclp.has_siif. Everything else that performs the
> lock/unlock should be contained in "struct kvm" directly, unless I am
> missing something.

No you are right, ipte_lock/unlock are independent of the vcpu.
I already had a patch on this but I did not think about sclp.has_siif 
and it was still heavy.

> 
> [...]
> 
>> +
>> +static int kvm_s390_get_topology(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +	struct kvm_s390_cpu_topology *topology;
>> +	int ret = 0;
>> +
>> +	if (!test_kvm_facility(kvm, 11))
>> +		return -ENXIO;
>> +
>> +	topology = kzalloc(sizeof(*topology), GFP_KERNEL);
>> +	if (!topology)
>> +		return -ENOMEM;
> 
> I'm confused. We're allocating a __u16 to then free it again below? Why
> not simply use a value on the stack like in kvm_s390_vm_get_migration()?

comes from the idea to bring up more information.
But done like this it has no point.


> 
> 
> 
> u16 mtcr;
> ...
> mtcr = kvm_s390_sca_get_mtcr(kvm);
> 
> if (copy_to_user((void __user *)attr->addr, &mtcr, sizeof(mtcr)))
> 	return -EFAULT;
> return 0;

yes, thanks.

> 
> 
> 
>> +
>> +	topology->mtcr =  kvm_s390_sca_get_mtcr(kvm);
> 
> s/  / /

yes too

> 
>> +	if (copy_to_user((void __user *)attr->addr, topology,
>> +			 sizeof(struct kvm_s390_cpu_topology)))
>> +		ret = -EFAULT;
>> +
>> +	kfree(topology);
>> +	return ret;
>> +}
>> +
> 
> 


Thanks a lot David,

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
