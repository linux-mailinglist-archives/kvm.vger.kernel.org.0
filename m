Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0953BC76A
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 09:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhGFHsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 03:48:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28836 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230223AbhGFHsD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 03:48:03 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1667WmAT158949;
        Tue, 6 Jul 2021 03:45:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=T6QO7X6CF36Nbfp19HCHv55ZKSdwwhgubqPY+cDVeJY=;
 b=l2zVz4M/HumC/GWxvic2lVvU7JSWBND/qDGQG5ofmpuBkaMXpSjvxUY5b+a5y1eybhqY
 e8FLUTx0Kh9mISxU40yfCJ8RoExg+Cecx7VHRfmVusF0nuN9qSgHQH2ZTKd98C00t4JL
 SyB6tdRkToLVF2vMu/sJ0Z+iIyIj7iXIP12LISuVEbJRZrTInEDscoLkDLlFQxgNslXD
 7u7LFnqJp41BxDRG/eImbvYCbQusuImAefrmMpmuCgnjwQauzWQOCPKbGtP3dldMY46j
 sNe+pRlgcE39P1/FZrPJg8O4S4gi8K21QHfwD4Z/V5VvfUxLgNFq3iS717ZZ0i3//S/7 Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mjkk8r2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 03:45:25 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1667Wuvf159405;
        Tue, 6 Jul 2021 03:45:25 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mjkk8r1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 03:45:24 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1667gqfW015948;
        Tue, 6 Jul 2021 07:45:22 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 39jfh8gkk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 07:45:22 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1667jKxV26935782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 07:45:20 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E588F4C04A;
        Tue,  6 Jul 2021 07:45:19 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 748D14C044;
        Tue,  6 Jul 2021 07:45:19 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.59.107])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jul 2021 07:45:19 +0000 (GMT)
Subject: Re: [PATCH/RFC] KVM: selftests: introduce P44V64 for z196 and EC12
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        KVM <kvm@vger.kernel.org>
References: <20210701153853.33063-1-borntraeger@de.ibm.com>
 <3a7be99a-5438-cc5b-ec6e-938832e7ab5a@de.ibm.com>
Message-ID: <91b4c894-b04a-1d28-b57e-6496b166186b@de.ibm.com>
Date:   Tue, 6 Jul 2021 09:45:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3a7be99a-5438-cc5b-ec6e-938832e7ab5a@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dG6Xxah1g9NMQE8ZX83qeQyybYPbbR7N
X-Proofpoint-ORIG-GUID: mFpWRY3yDco_xlGy5sXrZ340U9riEDpS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_02:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060037
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.07.21 09:40, Christian Borntraeger wrote:
> Paolo,
> 
> since you have not yet pulled my queue for 5.14. Shall I add the two selftest patches and send a new
> pull request?

Hmm, I cant put it on top of the next queue since I would need to rebase.
So lets do the original pull request and I will do another one
on top of kvm/master for the 2 selftest patches.
> 
> On 01.07.21 17:38, Christian Borntraeger wrote:
>> Older machines likes z196 and zEC12 do only support 44 bits of physical
>> addresses. Make this the default and check via IBC if we are on a later
>> machine. We then add P47V64 as an additional model.
>>
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> Fixes: 1bc603af73dd ("KVM: selftests: introduce P47V64 for s390x")
>> ---
>>   tools/testing/selftests/kvm/include/kvm_util.h |  3 ++-
>>   tools/testing/selftests/kvm/lib/guest_modes.c  | 16 ++++++++++++++++
>>   tools/testing/selftests/kvm/lib/kvm_util.c     |  5 +++++
>>   3 files changed, 23 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
>> index 35739567189e..74d73532fce9 100644
>> --- a/tools/testing/selftests/kvm/include/kvm_util.h
>> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
>> @@ -44,6 +44,7 @@ enum vm_guest_mode {
>>       VM_MODE_P40V48_64K,
>>       VM_MODE_PXXV48_4K,    /* For 48bits VA but ANY bits PA */
>>       VM_MODE_P47V64_4K,
>> +    VM_MODE_P44V64_4K,
>>       NUM_VM_MODES,
>>   };
>> @@ -61,7 +62,7 @@ enum vm_guest_mode {
>>   #elif defined(__s390x__)
>> -#define VM_MODE_DEFAULT            VM_MODE_P47V64_4K
>> +#define VM_MODE_DEFAULT            VM_MODE_P44V64_4K
>>   #define MIN_PAGE_SHIFT            12U
>>   #define ptes_per_page(page_size)    ((page_size) / 16)
>> diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
>> index 25bff307c71f..c330f414ef96 100644
>> --- a/tools/testing/selftests/kvm/lib/guest_modes.c
>> +++ b/tools/testing/selftests/kvm/lib/guest_modes.c
>> @@ -22,6 +22,22 @@ void guest_modes_append_default(void)
>>           }
>>       }
>>   #endif
>> +#ifdef __s390x__
>> +    {
>> +        int kvm_fd, vm_fd;
>> +        struct kvm_s390_vm_cpu_processor info;
>> +
>> +        kvm_fd = open_kvm_dev_path_or_exit();
>> +        vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);
>> +        kvm_device_access(vm_fd, KVM_S390_VM_CPU_MODEL,
>> +                  KVM_S390_VM_CPU_PROCESSOR, &info, false);
>> +        close(vm_fd);
>> +        close(kvm_fd);
>> +        /* Starting with z13 we have 47bits of physical address */
>> +        if (info.ibc >= 0x30)
>> +            guest_mode_append(VM_MODE_P47V64_4K, true, true);
>> +    }
>> +#endif
>>   }
>>   void for_each_guest_mode(void (*func)(enum vm_guest_mode, void *), void *arg)
>> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
>> index a2b732cf96ea..8606000c439e 100644
>> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
>> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
>> @@ -176,6 +176,7 @@ const char *vm_guest_mode_string(uint32_t i)
>>           [VM_MODE_P40V48_64K]    = "PA-bits:40,  VA-bits:48, 64K pages",
>>           [VM_MODE_PXXV48_4K]    = "PA-bits:ANY, VA-bits:48,  4K pages",
>>           [VM_MODE_P47V64_4K]    = "PA-bits:47,  VA-bits:64,  4K pages",
>> +        [VM_MODE_P44V64_4K]    = "PA-bits:44,  VA-bits:64,  4K pages",
>>       };
>>       _Static_assert(sizeof(strings)/sizeof(char *) == NUM_VM_MODES,
>>                  "Missing new mode strings?");
>> @@ -194,6 +195,7 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
>>       { 40, 48, 0x10000, 16 },
>>       {  0,  0,  0x1000, 12 },
>>       { 47, 64,  0x1000, 12 },
>> +    { 44, 64,  0x1000, 12 },
>>   };
>>   _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
>>              "Missing new mode params?");
>> @@ -282,6 +284,9 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
>>       case VM_MODE_P47V64_4K:
>>           vm->pgtable_levels = 5;
>>           break;
>> +    case VM_MODE_P44V64_4K:
>> +        vm->pgtable_levels = 5;
>> +        break;
>>       default:
>>           TEST_FAIL("Unknown guest mode, mode: 0x%x", mode);
>>       }
>>
