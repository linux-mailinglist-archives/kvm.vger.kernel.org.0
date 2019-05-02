Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB90411FA2
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 17:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbfEBP7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 11:59:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50828 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726356AbfEBP7A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 May 2019 11:59:00 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x42FmKdP038251
        for <kvm@vger.kernel.org>; Thu, 2 May 2019 11:58:58 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2s824xcjrd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 11:58:58 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <walling@linux.ibm.com>;
        Thu, 2 May 2019 16:58:57 +0100
Received: from b03cxnp08026.gho.boulder.ibm.com (9.17.130.18)
        by e33.co.us.ibm.com (192.168.1.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 2 May 2019 16:58:55 +0100
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x42FwsVs4784584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 May 2019 15:58:54 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EBC6C605A;
        Thu,  2 May 2019 15:58:54 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D68CCC6059;
        Thu,  2 May 2019 15:58:53 +0000 (GMT)
Received: from [9.56.58.88] (unknown [9.56.58.88])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  2 May 2019 15:58:53 +0000 (GMT)
Subject: Re: [PATCH v4 2/2] s390/kvm: diagnose 318 handling
To:     David Hildenbrand <david@redhat.com>, cohuck@redhat.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <1556751063-21835-1-git-send-email-walling@linux.ibm.com>
 <1556751063-21835-3-git-send-email-walling@linux.ibm.com>
 <783ecdb4-3bc2-4bf3-55cb-9a902467aadd@redhat.com>
 <1988b4c3-e123-47dd-2008-15d8bec0171d@linux.ibm.com>
 <02bfe52f-95e7-b4a3-e8d3-a8a8fffc5dec@redhat.com>
From:   Collin Walling <walling@linux.ibm.com>
Date:   Thu, 2 May 2019 11:58:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <02bfe52f-95e7-b4a3-e8d3-a8a8fffc5dec@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19050215-0036-0000-0000-00000AB16BA3
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011035; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01197563; UDB=6.00628126; IPR=6.00978419;
 MB=3.00026698; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-02 15:58:56
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050215-0037-0000-0000-00004B9CDA49
Message-Id: <f550f424-01f0-0901-a410-18f7767d5978@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-02_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905020105
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/2/19 11:39 AM, David Hildenbrand wrote:
> On 02.05.19 17:25, Collin Walling wrote:
>> On 5/2/19 8:59 AM, David Hildenbrand wrote:
>>> On 02.05.19 00:51, Collin Walling wrote:
>>>> DIAGNOSE 0x318 (diag318) is a privileged s390x instruction that must
>>>> be intercepted by SIE and handled via KVM. Let's introduce some
>>>> functions to communicate between userspace and KVM via ioctls. These
>>>> will be used to get/set the diag318 related information (also known
>>>> as the "Control Program Code" or "CPC"), as well as check the system
>>>> if KVM supports handling this instruction.
>>>>
>>>> This information can help with diagnosing the OS the VM is running
>>>> in (Linux, z/VM, etc) if the OS calls this instruction.
>>>>
>>>> The get/set functions are introduced primarily for VM migration and
>>>> reset, though no harm could be done to the system if a userspace
>>>> program decides to alter this data (this is highly discouraged).
>>>>
>>>> The Control Program Name Code (CPNC) is stored in the SIE block and
>>>> a copy is retained in each VCPU. The Control Program Version Code
>>>> (CPVC) retains a copy in each VCPU as well.
>>>>
>>>> At this time, the CPVC is not reported as its format is yet to be
>>>> defined.
>>>>
>>>> Note that the CPNC is set in the SIE block iff the host hardware
>>>> supports it.
>>>
>>> For vSIE and SIE you only configure the CPNC. Is that sufficient?
>>> Shouldn't diag318 allow the guest to set both? (especially regarding vSIE)
>>>
>>
>> The SIE block only stores the CPNC. The CPVC is not designed to be
>> stored in the SIE block, so we store it in guest memory only.
> 
> How can the cpvc value be used? Who will access it? Right now, it is
> only written to some location in KVM, and only read/written during
> migration.
> 

Guest dump, ring dump, and call home are events where this data
would we observed to assist with debugging efforts ("what environment
/ OS is the guest running?")

> You mention "The Control Program Version Code (CPVC) retains a copy in
> each VCPU as well", this is wrong, no?
> 

The parent struct kvm_arch retains a copy of the CPVC, not the VCPUs
themselves. The commit message should be changed to reflect that.

>>
>>> [...]
>>>>
>>>> diff --git a/Documentation/virtual/kvm/devices/vm.txt b/Documentation/virtual/kvm/devices/vm.txt
>>>> index 95ca68d..9a8d934 100644
>>>> --- a/Documentation/virtual/kvm/devices/vm.txt
>>>> +++ b/Documentation/virtual/kvm/devices/vm.txt
>>>> @@ -267,3 +267,17 @@ Parameters: address of a buffer in user space to store the data (u64) to;
>>>>    	    if it is enabled
>>>>    Returns:    -EFAULT if the given address is not accessible from kernel space
>>>>    	    0 in case of success.
>>>> +
>>>> +6. GROUP: KVM_S390_VM_MISC
>>>> +Architectures: s390
>>>> +
>>>> +6.1. KVM_S390_VM_MISC_CPC (r/w)
>>>> +
>>>> +Allows userspace to access the "Control Program Code" which consists of a
>>>> +1-byte "Control Program Name Code" and a 7-byte "Control Program Version Code".
>>>> +This information is initialized during IPL and must be preserved during
>>>> +migration.
>>>
>>> Your implementation does not match this description. User space can only
>>> get/set the cpnc effectively for the HW to see it, not the CPVC, no?
>>>
>>
>> We retrieve the entire CPNC + CPVC. User space (i.e. QEMU) can retrieve
>> this 64-bit value and save / load it during live guest migration.
>>
>> I figured it would be best to set / get this entire value now, so that
>> we don't need to add extra handling for the version code later when its
>> format is properly decided.
>>
>>> Shouldn't you transparently forward that data to the SCB for vSIE/SIE,
>>> because we really don't care what the target format will be?
>>>
>>
>> Sorry, I'm not fully understanding what you mean by "we really don't
>> care what the target format will be?"
>>
>> Do you mean to shadow the CPNC without checking if diag318 is supported?
>> I imagine that would be harmless.
> 
> No, I was rather wondering about the CPVC format. But I think I am
> missing how that one will be used at all.
> 


