Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927BF3D37AF
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 11:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhGWIsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 04:48:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32436 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229949AbhGWIsH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Jul 2021 04:48:07 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16N9FWep126772;
        Fri, 23 Jul 2021 05:28:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FWhckn2QmUBUuvc+zxmTC8ZxdPrw/XzmpyK+wnIrgPM=;
 b=eQHEsWiFg7w2+y2P0g28p8hxF8TECETn82lBIIZPyppyPL5AdIgFRUyxG5RtVQ+FlA3S
 umYG2zc2a76faR8nrHKdoyvDD3SfxpIo0ZhTQkO8q+QNFCN3Txu9uv3ekrGTvSya6A7n
 HBrlMtj5p3ZIM7RTTLmq07D2NmQED7a8+tVWCblVA5SrQNVS4kfBUxBag0qSF+7roRBc
 b47U91N2kx/j9sNhKr1CQxGVWpf0MF6GdDrC0/JF8kQlCFFnTPam5+0jDPXgOirR+QI2
 L5j6JNLfsRDHbuMjYgVtMarwodvFrzjD1xDoelFZbxt9HawrUCG05KeFYphg/Jq3KPQ3 CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39ytykr8t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 05:28:40 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16N9HBnV134605;
        Fri, 23 Jul 2021 05:28:39 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39ytykr8sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 05:28:39 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16N9HUcM009316;
        Fri, 23 Jul 2021 09:28:38 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 39upfh9ta5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 09:28:37 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16N9SYmk29360480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Jul 2021 09:28:34 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0B6311C050;
        Fri, 23 Jul 2021 09:28:34 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 589E211C04C;
        Fri, 23 Jul 2021 09:28:34 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.25.128])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Jul 2021 09:28:34 +0000 (GMT)
Subject: Re: [PATCH v2 2/2] s390:kvm: Topology expose TOPOLOGY facility
To:     Cornelia Huck <cohuck@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <1626973353-17446-1-git-send-email-pmorel@linux.ibm.com>
 <1626973353-17446-3-git-send-email-pmorel@linux.ibm.com>
 <7163cf4a-479a-3121-2261-cfb6e4024d0c@de.ibm.com> <87wnph5rz7.fsf@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <46229585-507d-70a2-cc60-c06fb172fbfd@de.ibm.com>
Date:   Fri, 23 Jul 2021 11:28:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87wnph5rz7.fsf@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5dXANetEhahmKsP6LH3aogLXKf6BnP9u
X-Proofpoint-ORIG-GUID: Ed1U4fYetx9-euYQM4bOFrYoqD3MUbLP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-23_04:2021-07-23,2021-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107230051
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23.07.21 10:55, Cornelia Huck wrote:
> On Fri, Jul 23 2021, Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> On 22.07.21 19:02, Pierre Morel wrote:
>>> We add a KVM extension KVM_CAP_S390_CPU_TOPOLOGY to tell the
>>> userland hypervisor it is safe to activate the CPU Topology facility.
>>
>> I think the old variant of using the CPU model was actually better.
>> It was just the patch description that was wrong.
> 
> I thought we wanted a cap that userspace can enable to get ptf
> intercepts? I'm confused.
> 

PTF goes to userspace in any case as every instruction that is
not handled by kvm and where interpretion is not enabled.
Now, having said that, we actually want PTF interpretion to be enabled
for "Check topology-change status" as this is supposed to be a fast
operation. Some OSes do query that in their interrupt handlers.


>>    
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>    arch/s390/kvm/kvm-s390.c | 1 +
>>>    include/uapi/linux/kvm.h | 1 +
>>>    2 files changed, 2 insertions(+)
>>>
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index b655a7d82bf0..8c695ee79612 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -568,6 +568,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>>    	case KVM_CAP_S390_VCPU_RESETS:
>>>    	case KVM_CAP_SET_GUEST_DEBUG:
>>>    	case KVM_CAP_S390_DIAG318:
>>> +	case KVM_CAP_S390_CPU_TOPOLOGY:
>>>    		r = 1;
>>>    		break;
>>>    	case KVM_CAP_SET_GUEST_DEBUG2:
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index d9e4aabcb31a..081ce0cd44b9 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
>>>    #define KVM_CAP_BINARY_STATS_FD 203
>>>    #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
>>>    #define KVM_CAP_ARM_MTE 205
>>> +#define KVM_CAP_S390_CPU_TOPOLOGY 206
>>>    
>>>    #ifdef KVM_CAP_IRQ_ROUTING
>>>    
>>>
> 
> Regardless of what we end up with: we need documentation for any new cap
> :)
> 
