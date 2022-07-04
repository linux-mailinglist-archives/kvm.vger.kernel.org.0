Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D055657B8
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 15:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234447AbiGDNrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 09:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234839AbiGDNrY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 09:47:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EBB2DF9;
        Mon,  4 Jul 2022 06:47:21 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 264DFlYX009113;
        Mon, 4 Jul 2022 13:47:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+LjafqIl6ufNnZavIhZnTDAgjD5W0x75R45ESPFwwzM=;
 b=ZPOcqK9Zj6ok2FKojYrbNCVe0W64o7HpBZ32Ad6nZAxI9tN2ojA89PCJKPaFjr89F05x
 4BhE60Y8Tnlm+Oa6kwv62AomVCck8nMzQBi4h/8vfBlVRnsP3eLmIECES8Pz9cToqMgy
 sWVKbpQevvB8C6E3VT6LfUss8YfVNzaFHxTZLUFFSZkKr87KWYNRVpBsD1sUbUkzlcnM
 SSdUjPj/CMEF/BIcGMYRcAcOj49CzhqKY+k42n+JMIVF/BadYYdipl1ogsK8yEQ4Fl9f
 tBgQ9xMJHx1SQj5rV2sYujcp5wKKz9HhWemrv64aty5Tg8ZWtMCix+xjzQZ6va3EwiFC QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h40xfrtuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 13:47:20 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 264DWZXg011764;
        Mon, 4 Jul 2022 13:47:20 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h40xfrtth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 13:47:20 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 264DhOTb000857;
        Mon, 4 Jul 2022 13:47:18 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3h2dn92s48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 13:47:18 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 264DlFT024445256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jul 2022 13:47:15 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 317EAA4040;
        Mon,  4 Jul 2022 13:47:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C7DCA404D;
        Mon,  4 Jul 2022 13:47:14 +0000 (GMT)
Received: from [9.171.11.185] (unknown [9.171.11.185])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Jul 2022 13:47:14 +0000 (GMT)
Message-ID: <d0bfa9a5-0ca5-dc2e-061b-e88d713abe2f@linux.ibm.com>
Date:   Mon, 4 Jul 2022 15:51:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v11 2/3] KVM: s390: guest support for topology function
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
References: <20220701162559.158313-1-pmorel@linux.ibm.com>
 <20220701162559.158313-3-pmorel@linux.ibm.com>
 <579337ac-d040-197f-3553-7c8ff202623a@linux.ibm.com>
 <038d7c59-0c9a-7667-cf74-83009e186b42@linux.ibm.com>
 <5e7848ff-f2d9-cf2c-ee5e-5c2765cb2d21@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <5e7848ff-f2d9-cf2c-ee5e-5c2765cb2d21@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Z98G510iVWgOaf6T5tYTcrrDwavRTyYF
X-Proofpoint-GUID: zRORlXp0vqfow-O5XdnkR9kpWeePnog8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-04_13,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 phishscore=0 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2207040057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/4/22 13:17, Janosch Frank wrote:
> On 7/4/22 13:02, Pierre Morel wrote:
>>
>>
>> On 7/4/22 11:08, Janis Schoetterl-Glausch wrote:
>>> On 7/1/22 18:25, Pierre Morel wrote:
>>>> We report a topology change to the guest for any CPU hotplug.
>>>>
>>>> The reporting to the guest is done using the Multiprocessor
>>>> Topology-Change-Report (MTCR) bit of the utility entry in the guest's
>>>> SCA which will be cleared during the interpretation of PTF.
>>>>
>>>> On every vCPU creation we set the MCTR bit to let the guest know the
>>>> next time he uses the PTF with command 2 instruction that the> 
>>>> topology changed and that he should use the STSI(15.1.x) instruction
>>> s/he/it (twice)
>>>> to get the topology details.
>>>>
>>>> STSI(15.1.x) gives information on the CPU configuration topology.
>>>> Let's accept the interception of STSI with the function code 15 and
>>>> let the userland part of the hypervisor handle it when userland
>>>> support the CPU Topology facility.And the user STSI capability.
>>> Also: supportS.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
>>>> ---
>>>>    arch/s390/include/asm/kvm_host.h | 18 +++++++++++++---
>>>>    arch/s390/kvm/kvm-s390.c         | 36 
>>>> ++++++++++++++++++++++++++++++++
>>>>    arch/s390/kvm/priv.c             | 16 ++++++++++----
>>>>    arch/s390/kvm/vsie.c             |  8 +++++++
>>>>    4 files changed, 71 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/arch/s390/include/asm/kvm_host.h 
>>>> b/arch/s390/include/asm/kvm_host.h
>>>> index 766028d54a3e..ae6bd3d607de 100644
>>>> --- a/arch/s390/include/asm/kvm_host.h
>>>> +++ b/arch/s390/include/asm/kvm_host.h
>>>> @@ -93,19 +93,30 @@ union ipte_control {
>>>>        };
>>>>    };
>>> [...]
>>>
>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>> index 8fcb56141689..ee59b03f2e45 100644
>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>> @@ -1691,6 +1691,31 @@ static int kvm_s390_get_cpu_model(struct kvm 
>>>> *kvm, struct kvm_device_attr *attr)
>>>>        return ret;
>>>>    }
>>>> +/**
>>>> + * kvm_s390_update_topology_change_report - update CPU topology 
>>>> change report
>>>> + * @kvm: guest KVM description
>>>> + * @val: set or clear the MTCR bit
>>>> + *
>>>> + * Updates the Multiprocessor Topology-Change-Report bit to signal
>>>> + * the guest with a topology change.
>>>> + * This is only relevant if the topology facility is present.
>>>> + *
>>>> + * The SCA version, bsca or esca, doesn't matter as offset is the 
>>>> same.
>>>> + */
>>>> +static void kvm_s390_update_topology_change_report(struct kvm *kvm, 
>>>> bool val)
>>>> +{
>>>> +    struct bsca_block *sca = kvm->arch.sca;
>>>> +    union sca_utility new, old;
>>>> +
>>>> +    read_lock(&kvm->arch.sca_lock);
>>>
>>> You forgot to put the assignment of sca under the lock.
>>
>> Should I really?
>> What we want to protect here is the content of the sca.
>> The sca itself does not change during the life of the KVM AFAIK.
> 
> The SCA origin as well as the SCA contents can change within the 
> lifetime of a KVM VM.
> 
> When we switch from bsca to esca we'll use new pages.
> When we add/remove cpus we'll update the MCN and the CPU entry.
> 
> 

Oh! then Yes, right.
thanks


-- 
Pierre Morel
IBM Lab Boeblingen
