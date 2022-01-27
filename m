Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C4049E786
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 17:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243731AbiA0Q3w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 11:29:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51760 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229836AbiA0Q3w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 11:29:52 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20RF1Vbh014720;
        Thu, 27 Jan 2022 16:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QRHwdS+O0P4AwaeD//j7fqwXy+BFyufI30ShTbqJIHs=;
 b=YaCS9LJwVySEnInrAomSFzpcyw81vneV16+qmCEc7M+yTW6VatC89Pbynqyqpfw9lX+j
 ai6O6fXaQ6Ld9r9lOzkyKJnfo5LUB/u2vbgZUr+BKV5hM9zj6cRLXItnXffuYfXDlRSk
 MOytNLgaGbaApyKxApumyJqijYF6bELdeyBoXZrHRajzm+hnsE9mdprFGZND5SIT0mwQ
 jBiBa3oucQsoirbSvWKgF3SRDOVxDvxeQOt1pVdkNhM7DejWqg0bFDqT3l23dbkLFp+K
 NGmhjtPAuFsROXgstOb9VQbnA+0JstIeDAmMUEUBk0ZJ7/EN9FrmOhHQ20197TpSRf65 JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3duv2pv30m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 16:29:51 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20RGQZIM009265;
        Thu, 27 Jan 2022 16:29:50 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3duv2pv2yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 16:29:50 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20RGTIgT011009;
        Thu, 27 Jan 2022 16:29:49 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3dr9j9yuf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 16:29:48 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20RGTjrn44302838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 16:29:46 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B39CFA4053;
        Thu, 27 Jan 2022 16:29:45 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 380F7A406D;
        Thu, 27 Jan 2022 16:29:45 +0000 (GMT)
Received: from [9.171.21.201] (unknown [9.171.21.201])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jan 2022 16:29:45 +0000 (GMT)
Message-ID: <71eb83a1-131d-f667-b1ef-ae214c724ba4@linux.ibm.com>
Date:   Thu, 27 Jan 2022 17:29:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH v1 06/10] KVM: s390: Add vm IOCTL for key checked
 guest absolute memory access
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
 <20220118095210.1651483-7-scgl@linux.ibm.com>
 <069c72b6-457f-65c7-652e-e6eca7235fca@redhat.com>
 <8647fcaf-6d8a-4678-0695-4b1cc797b3b1@linux.ibm.com>
 <3035e023-d71a-407b-2ba6-45ad0ae85a9e@redhat.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <3035e023-d71a-407b-2ba6-45ad0ae85a9e@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qpeqCdasn89-kMasZXX8qkAOFxv1OBX6
X-Proofpoint-ORIG-GUID: 28lLeN22rCFYQXUirL-9av7Wv98FifD0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201270098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 13:00, Thomas Huth wrote:
> On 20/01/2022 13.23, Janis Schoetterl-Glausch wrote:
>> On 1/20/22 11:38, Thomas Huth wrote:
>>> On 18/01/2022 10.52, Janis Schoetterl-Glausch wrote:
>>>> Channel I/O honors storage keys and is performed on absolute memory.
>>>> For I/O emulation user space therefore needs to be able to do key
>>>> checked accesses.
>>>> The vm IOCTL supports read/write accesses, as well as checking
>>>> if an access would succeed.
>>> ...
>>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>>> index e3f450b2f346..dd04170287fd 100644
>>>> --- a/include/uapi/linux/kvm.h
>>>> +++ b/include/uapi/linux/kvm.h
>>>> @@ -572,6 +572,8 @@ struct kvm_s390_mem_op {
>>>>    #define KVM_S390_MEMOP_LOGICAL_WRITE    1
>>>>    #define KVM_S390_MEMOP_SIDA_READ    2
>>>>    #define KVM_S390_MEMOP_SIDA_WRITE    3
>>>> +#define KVM_S390_MEMOP_ABSOLUTE_READ    4
>>>> +#define KVM_S390_MEMOP_ABSOLUTE_WRITE    5
>>>
>>> Not quite sure about this - maybe it is, but at least I'd like to see this discussed: Do we really want to re-use the same ioctl layout for both, the VM and the VCPU file handles? Where the userspace developer has to know that the *_ABSOLUTE_* ops only work with VM handles, and the others only work with the VCPU handles? A CPU can also address absolute memory, so why not adding the *_ABSOLUTE_* ops there, too? And if we'd do that, wouldn't it be sufficient to have the VCPU ioctls only - or do you want to call these ioctls from spots in QEMU where you do not have a VCPU handle available? (I/O instructions are triggered from a CPU, so I'd assume that you should have a VCPU handle around?)
>>
>> There are some differences between the vm and the vcpu memops.
>> No storage or fetch protection overrides apply to IO/vm memops, after all there is no control register to enable them.
>> Additionally, quiescing is not required for IO, tho in practice we use the same code path for the vcpu and the vm here.
>> Allowing absolute accesses with a vcpu is doable, but I'm not sure what the use case for it would be, I'm not aware of
>> a precedence in the architecture. Of course the vcpu memop already supports logical=real accesses.
> 
> Ok. Maybe it then would be better to call new ioctl and the new op defines differently, to avoid confusion? E.g. call it "vmmemop" and use:
> 
> #define KVM_S390_VMMEMOP_ABSOLUTE_READ    1
> #define KVM_S390_VMMEMOP_ABSOLUTE_WRITE   2
> 
> ?
> 
>  Thomas
> 

Thanks for the suggestion, I had to think about it for a while :). Here are my thoughts:
The ioctl type (vm/vcpu) and the operations cannot be completely orthogonal (vm + logical cannot work),
but with regards to the absolute operations they could be. We don't have a use case for that
right now and the semantics are a bit unclear, so I think we should choose a design now that
leaves us space for future extension. If we need to, we can add a NON_QUIESCING flag backwards compatibly
(tho it seems a rather unlikely requirement to me), that would behave the same for vm/vcpu memops.
We could also have a NO_PROT_OVERRIDE flag, which the vm memop would ignore.
Whether override is possible is dependent on the vcpu state, so user space leaves the exact behavior to KVM anyway.
If you wanted to enforce that protection override occurs, you would have to adjust
the vcpu state and therefore there should be no confusion about whether to use a vcpu or vm ioctl.

So I'm inclined to have one ioctl code and keep the operations as they are.
I moved the key to the union. One question that remains is whether to enforce that reserved bytes must be 0.
In general I think that it is a good idea, since it leaves a bigger design space for future extensions.
However the vcpu memop has not done that. I think it should be enforced for new functionality (operations, flags),
any objections?

I'll try to be thorough in documenting the currently supported behavior.
