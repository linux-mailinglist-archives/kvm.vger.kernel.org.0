Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE31182A7D
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 09:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgCLII0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 04:08:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44420 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726390AbgCLII0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Mar 2020 04:08:26 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02C83QJr100337
        for <kvm@vger.kernel.org>; Thu, 12 Mar 2020 04:08:25 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yqh7wr916-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 Mar 2020 04:08:24 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 12 Mar 2020 08:08:23 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Mar 2020 08:08:19 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02C88I2652559954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 08:08:18 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C905952052;
        Thu, 12 Mar 2020 08:08:18 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.141])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8E65252051;
        Thu, 12 Mar 2020 08:08:18 +0000 (GMT)
Subject: Re: kvm/queue demand paging test and s390
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <c845637e-d662-993e-2184-fa34bae79495@de.ibm.com>
 <20200310172744.36lawcszzjbebz6d@kamzik.brq.redhat.com>
 <2d1fbe47-75fe-f57c-ab7a-65702e1ea23d@de.ibm.com>
 <20200311062653.yczihmgrnfqyrwa3@kamzik.brq.redhat.com>
 <8733ba0b-7722-3ab2-39e5-3a6a01efb571@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Thu, 12 Mar 2020 09:08:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <8733ba0b-7722-3ab2-39e5-3a6a01efb571@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20031208-4275-0000-0000-000003AB0893
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031208-4276-0000-0000-000038C0267B
Message-Id: <820e7afd-bc58-dd9a-9430-90833a7fef30@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-11_15:2020-03-11,2020-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 phishscore=0 spamscore=0
 mlxlogscore=913 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2003120042
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12.03.20 09:00, Christian Borntraeger wrote:
> 
> 
> On 11.03.20 07:26, Andrew Jones wrote:
>> On Tue, Mar 10, 2020 at 09:18:16PM +0100, Christian Borntraeger wrote:
>>>
>>>
>>> On 10.03.20 18:27, Andrew Jones wrote:
>>>> On Tue, Mar 10, 2020 at 05:54:59PM +0100, Christian Borntraeger wrote:
>>>>> For s390 the guest memory size must be 1M aligned. I need something like the following to make this work:
>>>>>
>>>>> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
>>>>> index c1e326d3ed7f..f85ec3f01a35 100644
>>>>> --- a/tools/testing/selftests/kvm/demand_paging_test.c
>>>>> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
>>>>> @@ -164,6 +164,10 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, int vcpus,
>>>>>         pages += ((2 * vcpus * vcpu_memory_bytes) >> PAGE_SHIFT_4K) /
>>>>>                  PTES_PER_4K_PT;
>>>>>         pages = vm_adjust_num_guest_pages(mode, pages);
>>>>> +#ifdef __s390x__
>>>>> +       /* s390 requires 1M aligned guest sizes */
>>>>> +       pages = (pages + 255) & ~0xff;
>>>>> +#endif
>>>>>  
>>>>>         pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
>>>>>  
>>>>>
>>>>> any better idea how to do that?
>>>>>
>>>>
>>>> For this one we could patch[*] vm_adjust_num_guest_pages(). That would
>>>> also allow the one on line 382, and another one at dirty_log_test.c:300
>>>> to be hidden.
>>>
>>> I tried that first but then I ran into several other asserts that checked for
>>> num_pages = vm_adjust_num_guest_pages(num_pages)
>>>
>>> See kvm_util.c:     TEST_ASSERT(vm_adjust_num_guest_pages(vm->mode, npages) == npages
>>>
>>> So it seems like a bigger rework is necessary to avoid this little hack :-/
>>
>> There's just this one other assert, and it'll only fire if the number of
>> guest pages aren't selectect correctly. One must just be sure they
>> always select the number correctly or do
>>
>>  adjusted_num_pages = vm_adjust_num_guest_pages(mode, guessed_num_pages);
>>  vm_userspace_mem_region_add(..., adjusted_num_pages, ...);
>>
>> to ensure it. If we patch vm_adjust_num_guest_pages() as suggested below
>> then the assert should never fire when the number is already correct,
>> because vm_adjust_num_guest_pages() doesn't change an already correct
>> number, i.e.
>>
>>  adjusted_num_pages == vm_adjust_num_guest_pages(mode, adjusted_num_pages)
>>
>> If an assert is firing after making that change, then I wonder if not
>> all s390 memregions are 1M aligned?
> 
> I just checked your patch and it seems to work fine. No idea what I did wrong
> in my test. Can you respin this as a proper patch against kvm/queue?

And yes, we can then remove the following:


diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index c1e326d3ed7f..ae086c5dc118 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -378,10 +378,6 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
        guest_num_pages = (vcpus * vcpu_memory_bytes) / guest_page_size;
        guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
 
-#ifdef __s390x__
-       /* Round up to multiple of 1M (segment size) */
-       guest_num_pages = (guest_num_pages + 0xff) & ~0xffUL;
-#endif
        /*
         * If there should be more memory in the guest test region than there
         * can be pages in the guest, it will definitely cause problems.
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 518a94a7a8b5..aaa6ff361f52 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -296,10 +296,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
        guest_num_pages = (1ul << (DIRTY_MEM_BITS -
                                   vm_get_page_shift(vm))) + 3;
        guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
-#ifdef __s390x__
-       /* Round up to multiple of 1M (segment size) */
-       guest_num_pages = (guest_num_pages + 0xff) & ~0xffUL;
-#endif
        host_page_size = getpagesize();
        host_num_pages = vm_num_host_pages(mode, guest_num_pages);
 

