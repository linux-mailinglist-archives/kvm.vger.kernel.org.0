Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA15495E18
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 12:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380067AbiAULDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 06:03:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33174 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237704AbiAULD1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 06:03:27 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LACCNX007431;
        Fri, 21 Jan 2022 11:03:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=y8jn7GOjnBTuB4MXch/H+MB3VICr/4md59S5KN0WZd0=;
 b=Us6XO2a32e/n07VhtaqoABIa8I+3U5P7XdChW1W/uDybLuUtk1CsOzqJKWZw15rv9fUD
 ACV6KbOjlf+iPganox1gYaIh4uSRSTHiaHI/D/sylqUWuSDPDktS2Lz0Yau+loSBHHPv
 zAN/PgYh0P9EcYxlWxh4iDXMJxpkdRWY6t8EkLnwcZtlshFQuJTMiw+AXCIQ+XUzfYVq
 e7qSk1chmFX7D1FPHNjTS4XDTTEmnXo/6b579MbWoagmrIntTh7tKrpIYxcS/1RO5ODl
 9CwEUtsTvh4O9iyDTMdF12XHSS8gqDEBp/iqSnXM/ChmtBPoZzHB76aZ8g3UGMpX9siZ cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dqtv5gxma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 11:03:26 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20LAuBnn014228;
        Fri, 21 Jan 2022 11:03:26 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dqtv5gxka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 11:03:26 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20LB22XA008080;
        Fri, 21 Jan 2022 11:03:24 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3dqjegbmb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 11:03:24 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20LB3LW940567196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 11:03:21 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01F22AE075;
        Fri, 21 Jan 2022 11:03:21 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F7E9AE056;
        Fri, 21 Jan 2022 11:03:20 +0000 (GMT)
Received: from [9.171.77.40] (unknown [9.171.77.40])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jan 2022 11:03:20 +0000 (GMT)
Message-ID: <06422388-8389-6954-00c7-7b582b4cf1bb@linux.ibm.com>
Date:   Fri, 21 Jan 2022 12:03:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH v1 04/10] KVM: s390: selftests: Test TEST PROTECTION
 emulation
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
 <20220118095210.1651483-5-scgl@linux.ibm.com>
 <c5ce5d0b-444b-ba33-a670-3bd3893af475@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <c5ce5d0b-444b-ba33-a670-3bd3893af475@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: x7TvIuWWYXp6rKHQbDUtkfCgk1VsQrLv
X-Proofpoint-ORIG-GUID: x92-oExbEBb_K8aSyDkuxF9n0AUN3cPe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_06,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/22 16:40, Janosch Frank wrote:
> On 1/18/22 10:52, Janis Schoetterl-Glausch wrote:
>> Test the emulation of TEST PROTECTION in the presence of storage keys.
>> Emulation only occurs under certain conditions, one of which is the host
>> page being protected.
>> Trigger this by protecting the test pages via mprotect.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>   tools/testing/selftests/kvm/.gitignore    |   1 +
>>   tools/testing/selftests/kvm/Makefile      |   1 +
>>   tools/testing/selftests/kvm/s390x/tprot.c | 184 ++++++++++++++++++++++
>>   3 files changed, 186 insertions(+)
>>   create mode 100644 tools/testing/selftests/kvm/s390x/tprot.c
>>
>> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
>> index 3763105029fb..82c0470b6849 100644
>> --- a/tools/testing/selftests/kvm/.gitignore
>> +++ b/tools/testing/selftests/kvm/.gitignore
>> @@ -7,6 +7,7 @@
>>   /s390x/memop
>>   /s390x/resets
>>   /s390x/sync_regs_test
>> +/s390x/tprot
>>   /x86_64/cr4_cpuid_sync_test
>>   /x86_64/debug_regs
>>   /x86_64/evmcs_test
>> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
>> index c4e34717826a..df6de8d155e8 100644
>> --- a/tools/testing/selftests/kvm/Makefile
>> +++ b/tools/testing/selftests/kvm/Makefile
>> @@ -109,6 +109,7 @@ TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
>>   TEST_GEN_PROGS_s390x = s390x/memop
>>   TEST_GEN_PROGS_s390x += s390x/resets
>>   TEST_GEN_PROGS_s390x += s390x/sync_regs_test
>> +TEST_GEN_PROGS_s390x += s390x/tprot
>>   TEST_GEN_PROGS_s390x += demand_paging_test
>>   TEST_GEN_PROGS_s390x += dirty_log_test
>>   TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
>> diff --git a/tools/testing/selftests/kvm/s390x/tprot.c b/tools/testing/selftests/kvm/s390x/tprot.c
>> new file mode 100644
>> index 000000000000..8b52675307f6
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/s390x/tprot.c

[...]

>> +
>> +static int set_storage_key(void *addr, uint8_t key)
>> +{
>> +    int not_mapped = 0;
>> +
> 
> Maybe add a short comment:
> Check if address is mapped via lra and set the storage key if it is.
> 
>> +    asm volatile (
>> +               "lra    %[addr], 0(0,%[addr])\n"
>> +        "    jz    0f\n"
>> +        "    llill    %[not_mapped],1\n"
>> +        "    j    1f\n"
>> +        "0:    sske    %[key], %[addr]\n"
>> +        "1:"
>> +        : [addr] "+&a" (addr), [not_mapped] "+r" (not_mapped)
> 
> Shouldn't this be a "=r" instead of a "+r" for not_mapped?

I don't think so. We only write to it on one code path and the compiler mustn't conclude
that it can remove the = 0 assignment because the value gets overwritten anyway.

Initially I tried to implement the function like this:

static int set_storage_key(void *addr, uint8_t key)
{
        asm goto ("lra  %[addr], 0(0,%[addr])\n\t"
                  "jnz  %l[not_mapped]\n\t"
                  "sske %[key], %[addr]\n"
                : [addr] "+&a" (addr)
                : [key] "r" (key)
                : "cc", "memory"
                : not_mapped
        );
        return 0;
not_mapped:
        return -1;
}

Which I think is nicer, but the compiler just optimized that completely away.
I have no clue why it (thinks it) is allowed to do that.

> 
>> +        : [key] "r" (key)
>> +        : "cc"
>> +    );
>> +    return -not_mapped;
>> +}
>> +
>> +enum permission {
>> +    READ_WRITE = 0,
>> +    READ = 1,
>> +    NONE = 2,
>> +    UNAVAILABLE = 3,
> 
> TRANSLATION_NA ?
> I'm not completely happy with these names but I've yet to come up with a better naming scheme here.

Mentioning translation is a good idea. Don't think there is any harm in using
TRANSLATION_NOT_AVAILABLE or TRANSLATION_UNAVAILABLE.
> 
>> +};
>> +
>> +static enum permission test_protection(void *addr, uint8_t key)
>> +{
>> +    uint64_t mask;
>> +
>> +    asm volatile (
>> +               "tprot    %[addr], 0(%[key])\n"
>> +        "    ipm    %[mask]\n"
>> +        : [mask] "=r" (mask)
>> +        : [addr] "Q" (*(char *)addr),
>> +          [key] "a" (key)
>> +        : "cc"
>> +    );
>> +
>> +    return (enum permission)mask >> 28;
> 
> You could replace the shift with the "srl" that we normally do.

I prefer keeping the asm as small as possible, C is just so much easier to understand.

[...]

> It's __really__ hard to understand this since the state is changed both by the guest and host. Please add comments to this and maybe also add some to the test struct explaining why you expect the results for each test.
> 

I think I'll concentrate the comments at the tests array so we have one location
that lays out the complete logic and then one only has to check if the guest
and host match up with that, respectively, instead of having to model their interaction
in ones head.

I'll incorporate your other feedback, too.

Thanks!
