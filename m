Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1067C1D9
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 14:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbfGaMnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 08:43:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24480 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727136AbfGaMns (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Jul 2019 08:43:48 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6VChckM136415
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:43:48 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2u390hp5h0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:43:45 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Wed, 31 Jul 2019 13:43:31 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 31 Jul 2019 13:43:27 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6VChQjh48824540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Jul 2019 12:43:26 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A3364C044;
        Wed, 31 Jul 2019 12:43:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C25BE4C04A;
        Wed, 31 Jul 2019 12:43:25 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.71])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 31 Jul 2019 12:43:25 +0000 (GMT)
Subject: Re: [PATCH 3/3] i386/kvm: initialize struct at full before ioctl call
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-block@nongnu.org" <qemu-block@nongnu.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "berto@igalia.com" <berto@igalia.com>,
        "mdroth@linux.vnet.ibm.com" <mdroth@linux.vnet.ibm.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        Denis Lunev <den@virtuozzo.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
References: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
 <1564502498-805893-4-git-send-email-andrey.shinkevich@virtuozzo.com>
 <14b60c5b-6ed4-0f4d-17a8-6ec861115c1e@redhat.com>
 <30f40221-d2d2-780b-3375-910e9f755edd@de.ibm.com>
 <08958a7e-1952-caf7-ab45-2fd503db418c@virtuozzo.com>
 <bdbee2e0-62a7-8906-8076-408922511146@de.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 syiRa+UVlsKmx1hsEg==
Date:   Wed, 31 Jul 2019 14:43:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <bdbee2e0-62a7-8906-8076-408922511146@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19073112-0028-0000-0000-00000389A3C9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19073112-0029-0000-0000-00002449F4A5
Message-Id: <f9346216-a4e9-4882-4a36-33580529b75e@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 31.07.19 14:28, Christian Borntraeger wrote:
> 
> 
> On 31.07.19 14:04, Andrey Shinkevich wrote:
>> On 31/07/2019 10:24, Christian Borntraeger wrote:
>>>
>>>
>>> On 30.07.19 21:20, Paolo Bonzini wrote:
>>>> On 30/07/19 18:01, Andrey Shinkevich wrote:
>>>>> Not the whole structure is initialized before passing it to the KVM.
>>>>> Reduce the number of Valgrind reports.
>>>>>
>>>>> Signed-off-by: Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>
>>>>
>>>> Christian, is this the right fix?  It's not expensive so it wouldn't be
>>>> an issue, just checking if there's any better alternative.
>>>
>>> I think all of these variants are valid with pros and cons
>>> 1. teach valgrind about this:
>>> Add to coregrind/m_syswrap/syswrap-linux.c (and the relevant header files)
>>> knowledge about which parts are actually touched.
>>> 2. use designated initializers
>>> 3. use memset
>>> 3. use a valgrind callback VG_USERREQ__MAKE_MEM_DEFINED to tell that this memory is defined
>>>
>>
>> Thank you all very much for taking part in the discussion.
>> Also, one may use the Valgrind technology to suppress the unwanted 
>> reports by adding the Valgrind specific format file valgrind.supp to the 
>> QEMU project. The file content is extendable for future needs.
>> All the cases we like to suppress will be recounted in that file.
>> A case looks like the stack fragments. For instance, from QEMU block:
>>
>> {
>>     hw/block/hd-geometry.c
>>     Memcheck:Cond
>>     fun:guess_disk_lchs
>>     fun:hd_geometry_guess
>>     fun:blkconf_geometry
>>     ...
>>     fun:device_set_realized
>>     fun:property_set_bool
>>     fun:object_property_set
>>     fun:object_property_set_qobject
>>     fun:object_property_set_bool
>> }
>>
>> The number of suppressed cases are reported by the Valgrind with every 
>> run: "ERROR SUMMARY: 5 errors from 3 contexts (suppressed: 0 from 0)"
>>
>> Andrey
> 
> Yes, indeed that would be another variant. How performance critical are
> the fixed locations? That might have an impact on what is the best solution.
> From a cleanliness approach doing 1 (adding the ioctl definition to valgrind)
> is certainly the most beautiful way. I did that in the past, look for example at
> 
> https://sourceware.org/git/?p=valgrind.git;a=commitdiff;h=c2baee9b7bf043702c130de0771a4df439fcf403
> or 
> https://sourceware.org/git/?p=valgrind.git;a=commitdiff;h=00a31dd3d1e7101b331c2c83fca6c666ba35d910
> 
> for examples. 
> 
> 
>>
>>>>
>>>> Paolo
>>>>
>>>>> ---
>>>>>   target/i386/kvm.c | 3 +++
>>>>>   1 file changed, 3 insertions(+)
>>>>>
>>>>> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
>>>>> index dbbb137..ed57e31 100644
>>>>> --- a/target/i386/kvm.c
>>>>> +++ b/target/i386/kvm.c
>>>>> @@ -190,6 +190,7 @@ static int kvm_get_tsc(CPUState *cs)
>>>>>           return 0;
>>>>>       }
>>>>>   
>>>>> +    memset(&msr_data, 0, sizeof(msr_data));
>>>>>       msr_data.info.nmsrs = 1;
>>>>>       msr_data.entries[0].index = MSR_IA32_TSC;
>>>>>       env->tsc_valid = !runstate_is_running();
>>>>> @@ -1706,6 +1707,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>>>>   
>>>>>       if (has_xsave) {
>>>>>           env->xsave_buf = qemu_memalign(4096, sizeof(struct kvm_xsave));
>>>>> +        memset(env->xsave_buf, 0, sizeof(struct kvm_xsave));

This is memsetting 4k? 
Yet another variant would be to use the RUNNING_ON_VALGRIND macro from
valgrind/valgrind.h to only memset for valgrind. But just using MAKE_MEM_DEFINED
from memcheck.h is simpler. 

