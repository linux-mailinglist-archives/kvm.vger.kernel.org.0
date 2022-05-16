Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA38528221
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 12:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236110AbiEPKcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 06:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234217AbiEPKcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 06:32:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A44419C2C;
        Mon, 16 May 2022 03:32:20 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G9GC45022936;
        Mon, 16 May 2022 10:32:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=akLgE8JmtI978ECDEba7uWKzQivTvZxU+oj4apcHYgU=;
 b=Q41Fg0DUFTDDN+oa4GGQ3caABT4ovWd4zf90XaiwTE2LS9TR5sVTvZyq5z9gGwCusjMA
 Ddvj2GGVNqge0ZgluefcFlaXY6/UZ0E06V2OAlEa5SZ2BMo21ncRi/bsW1Pd2U+w1G53
 o+ZfVj7g85ay0pinzR1SvuHSHLGAuZTmn7rCni/JLtgSInWWxx2x8JU1z8uQNtGtsaPA
 /ahY29L8cvkdUVkguyYAUJbrVRqY9xpCHmT21CB3C8WCZT2oWo5558FfsxKupih7omvC
 SGExt7Jve8H4bYilg8ThdO2UgvuMO/PFED/paB4M4u8zxhkDDxMBDB6nvkh6suHXkpdt 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3ku5hd1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 10:32:19 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GATXCs001083;
        Mon, 16 May 2022 10:32:19 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3ku5hd0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 10:32:19 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GAJlHr010951;
        Mon, 16 May 2022 10:32:16 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3g2428swth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 10:32:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GAWDGG49873180
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 10:32:13 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82598A4057;
        Mon, 16 May 2022 10:32:13 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD22AA4055;
        Mon, 16 May 2022 10:32:12 +0000 (GMT)
Received: from [9.171.15.172] (unknown [9.171.15.172])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 10:32:12 +0000 (GMT)
Message-ID: <adb213f6-728f-65c1-8afd-3afd0c9a40c9@linux.ibm.com>
Date:   Mon, 16 May 2022 12:36:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v9 3/3] s390x: KVM: resetting the Topology-Change-Report
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
References: <20220506092403.47406-1-pmorel@linux.ibm.com>
 <20220506092403.47406-4-pmorel@linux.ibm.com>
 <76fd0c11-5b9b-0032-183b-54db650f13b1@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <76fd0c11-5b9b-0032-183b-54db650f13b1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IA1QXhJbV6JHVF0uUDIt9rHCLDO5bPWE
X-Proofpoint-GUID: crkt81Jk07ExuRTOKhjmCa7G-XYl234c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_06,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205160062
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/12/22 11:31, David Hildenbrand wrote:
> On 06.05.22 11:24, Pierre Morel wrote:
>> During a subsystem reset the Topology-Change-Report is cleared.
>> Let's give userland the possibility to clear the MTCR in the case
>> of a subsystem reset.
>>
>> To migrate the MTCR, let's give userland the possibility to
>> query the MTCR state.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   arch/s390/include/uapi/asm/kvm.h |  5 ++
>>   arch/s390/kvm/kvm-s390.c         | 79 ++++++++++++++++++++++++++++++++
>>   2 files changed, 84 insertions(+)
>>
>> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
>> index 7a6b14874d65..abdcf4069343 100644
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
>> @@ -171,6 +172,10 @@ struct kvm_s390_vm_cpu_subfunc {
>>   #define KVM_S390_VM_MIGRATION_START	1
>>   #define KVM_S390_VM_MIGRATION_STATUS	2
>>   
>> +/* kvm attributes for cpu topology */
>> +#define KVM_S390_VM_CPU_TOPO_MTR_CLEAR	0
>> +#define KVM_S390_VM_CPU_TOPO_MTR_SET	1
>> +
>>   /* for KVM_GET_REGS and KVM_SET_REGS */
>>   struct kvm_regs {
>>   	/* general purpose regs for s390 */
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index c8bdce31464f..80a1244f0ead 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -1731,6 +1731,76 @@ static void kvm_s390_sca_set_mtcr(struct kvm *kvm)
>>   	ipte_unlock(kvm);
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
>> +static void kvm_s390_sca_clear_mtcr(struct kvm *kvm)
>> +{
>> +	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
>> +
>> +	ipte_lock(kvm);
>> +	sca->utility  &= ~SCA_UTILITY_MTCR;
> 
> 
> One space too much.
> 
> sca->utility &= ~SCA_UTILITY_MTCR;
> 
>> +	ipte_unlock(kvm);
>> +}
>> +
>> +static int kvm_s390_set_topology(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +	if (!test_kvm_facility(kvm, 11))
>> +		return -ENXIO;
>> +
>> +	switch (attr->attr) {
>> +	case KVM_S390_VM_CPU_TOPO_MTR_SET:
>> +		kvm_s390_sca_set_mtcr(kvm);
>> +		break;
>> +	case KVM_S390_VM_CPU_TOPO_MTR_CLEAR:
>> +		kvm_s390_sca_clear_mtcr(kvm);
>> +		break;
>> +	}
>> +	return 0;
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
>> +	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
>> +	int val;
>> +
>> +	ipte_lock(kvm);
>> +	val = !!(sca->utility & SCA_UTILITY_MTCR);
>> +	ipte_unlock(kvm);
>> +
>> +	return val;
>> +}
>> +
>> +static int kvm_s390_get_topology(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +	int mtcr;
> 
> I think we prefer something like u16 when copying to user space.

If you prefer.
The original idea was to have something like a bool but then I should 
have change get_mtcr to has_mtcr.


> 
>> +
>> +	if (!test_kvm_facility(kvm, 11))
>> +		return -ENXIO;
>> +
>> +	mtcr = kvm_s390_sca_get_mtcr(kvm);
>> +	if (copy_to_user((void __user *)attr->addr, &mtcr, sizeof(mtcr)))
>> +		return -EFAULT;
>> +
>> +	return 0;
>> +}
> 
> You should probably add documentation, and document that only the last
> bit (0x1) has a meaning.
> 
> Apart from that LGTM.
> 

-- 
Pierre Morel
IBM Lab Boeblingen
