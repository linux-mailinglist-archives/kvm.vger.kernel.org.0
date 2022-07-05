Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D8C566EEC
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 15:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbiGENHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 09:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiGENHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 09:07:08 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837B32E9DE;
        Tue,  5 Jul 2022 05:33:44 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265CKTll005802;
        Tue, 5 Jul 2022 12:33:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bgoq8EPII743EkYcofatWiYppbAxA+BLYrQBrrDoKjw=;
 b=bKSO1s9tZgwi4AiP63WAoH2ZIuAFvtr7VTSS7dOP7iB392Wf9ZBtWCxgYFYbXc4cl0oo
 9YKTlwOIdeYoTHCcuRNy+IOYuo+kVTcmxf/2puEBvOG/Cm0oR2JA6U1iEqG5TFhMWxev
 pe1eRDbiKEKE0Ji2IS9dgNTPlsU5fM2U7ZRAIvXbn5dMdsj1rWPvKxrHyZRzwa8cJVLn
 2rbC+mHkG6x9D9FvMjsYQvSHe/xIIxBwST53gFkMagjcA4c+/jlQuXBtkUKL3Dsiptls
 f8wwFX2qo9O9Gswwhqiy1my3Pe0adWRh1m3C7DlHK8HSRy6LHocRK3w+91NM69s4Sczi Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4n7908bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 12:33:43 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 265CWIDt031713;
        Tue, 5 Jul 2022 12:33:43 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4n7908b8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 12:33:42 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 265CLhPJ021433;
        Tue, 5 Jul 2022 12:33:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3h2dn9416e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 12:33:41 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 265CXbxJ25821466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jul 2022 12:33:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB15211C05C;
        Tue,  5 Jul 2022 12:33:37 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10B2711C050;
        Tue,  5 Jul 2022 12:33:36 +0000 (GMT)
Received: from [9.171.60.127] (unknown [9.171.60.127])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Jul 2022 12:33:35 +0000 (GMT)
Message-ID: <6d7514f4-8df1-c9b2-d4ca-a4830e9695b6@linux.ibm.com>
Date:   Tue, 5 Jul 2022 14:38:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v11 3/3] KVM: s390: resetting the Topology-Change-Report
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220701162559.158313-1-pmorel@linux.ibm.com>
 <20220701162559.158313-4-pmorel@linux.ibm.com>
 <d90e2aaa-05ad-6f3a-83f8-428677256673@linux.ibm.com>
 <1f3b404f-0bd6-31cb-57de-591d2e03dd76@linux.ibm.com>
 <d8033b41-ca12-8d28-3482-c716838f05d7@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <d8033b41-ca12-8d28-3482-c716838f05d7@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0gPu4w9yWVy9wZ2TlQjeEpgMu-AeMaiH
X-Proofpoint-ORIG-GUID: sKnWUam3BcEi3K-94wDEkoufbz6zYhWD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 spamscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2207050052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/5/22 10:09, Janis Schoetterl-Glausch wrote:
> On 7/4/22 15:56, Pierre Morel wrote:
>>
>>
>> On 7/4/22 11:35, Janis Schoetterl-Glausch wrote:
>>> On 7/1/22 18:25, Pierre Morel wrote:
>>>> During a subsystem reset the Topology-Change-Report is cleared.
>>>>
>>>> Let's give userland the possibility to clear the MTCR in the case
>>>> of a subsystem reset.
>>>>
>>>> To migrate the MTCR, we give userland the possibility to
>>>> query the MTCR state.
>>>>
>>>> We indicate KVM support for the CPU topology facility with a new
>>>> KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>    Documentation/virt/kvm/api.rst   | 25 +++++++++++++++
>>>>    arch/s390/include/uapi/asm/kvm.h | 10 ++++++
>>>>    arch/s390/kvm/kvm-s390.c         | 53 ++++++++++++++++++++++++++++++++
>>>>    include/uapi/linux/kvm.h         |  1 +
>>>>    4 files changed, 89 insertions(+)
>>>>
>>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>>>> index 11e00a46c610..5e086125d8ad 100644
>>>> --- a/Documentation/virt/kvm/api.rst
>>>> +++ b/Documentation/virt/kvm/api.rst
>>>> @@ -7956,6 +7956,31 @@ should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
>>>>    When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
>>>>    type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
>>>>    +8.37 KVM_CAP_S390_CPU_TOPOLOGY
>>>> +------------------------------
>>>> +
>>>> +:Capability: KVM_CAP_S390_CPU_TOPOLOGY
>>>> +:Architectures: s390
>>>> +:Type: vm
>>>> +
>>>> +This capability indicates that KVM will provide the S390 CPU Topology
>>>> +facility which consist of the interpretation of the PTF instruction for
>>>> +the function code 2 along with interception and forwarding of both the
>>>> +PTF instruction with function codes 0 or 1 and the STSI(15,1,x)
>>>> +instruction to the userland hypervisor.
>>> The latter only if the user STSI capability is also enabled.
>>
>> Hum, not sure about this.
>> we can not set facility 11 and return 3 to STSI(15) for valid selectors.
> 
> I think the PoP allows for this:
> 
> When the specified function-code, selector-1, and
> selector-2 combination is invalid (is other than as
> shown in Figure 10-84),

> or if it is valid but the
> requested information is not available because the
> specified level does not implement or does not fully
> implement the instruction or because a necessary
> part of the level is uninstalled or not initialized, and
> provided that an exception is not recognized (see
> “Special Conditions”), the condition code is set to 3.


> When the function code is nonzero, the combination
> is valid, the requested information is available, and
> there is no exception, the requested information is
> stored in a system-information block (SYSIB) at the
> second-operand address.
> 
> So if user_stsi is off the information is not available because the level does not fully implement the instruction.
> But I'm fine with KVM_CAP_S390_CPU_TOPOLOGY implying KVM_CAP_S390_USER_STSI, too.

OK, I do like you say, return CC3 if no user_stsi is available

Thanks,
Pierre

> 
>>
>> I think that it was right before, KVM_CAP_S390_CPU_TOPOLOGY and KVM_CAP_S390_USER_STSI are independent in KVM, userland can turn on one and not the other.
>> But KVM proposes both.
>>
>> Of course it is stupid to turn on only KVM_CAP_S390_CPU_TOPOLOGY but KVM is not responsible for this userland is.
>>
>> Otherwise, we need to check on KVM_CAP_S390_USER_STSI before authorizing  KVM_CAP_S390_CPU_TOPOLOGY and that looks even more complicated for me,
>> or we suppress the KVM_CAP_S390_CPU_TOPOLOGY and implement the all stsi(15) in the kernel what I really do not think is good because of the complexity of the userland API
> 
> [...]
> 

-- 
Pierre Morel
IBM Lab Boeblingen
