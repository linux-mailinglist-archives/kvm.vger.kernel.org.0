Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D76E6E6666
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 15:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbjDRNwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 09:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjDRNwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 09:52:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5642A9EDE
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 06:52:48 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33ICosjY013954;
        Tue, 18 Apr 2023 13:52:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=N/k4/nmWtVZqHK6G6a4vZtV2dFqAUdfOGBqNIv6a97A=;
 b=W8WHPGZjLu+z+o+jWNV2PI7BbctLwM8xkx6X6YOdFPirjizkYNm2ORTRxaF4B6TjbikF
 Wt9yuLKN7oSTY3VYXoyJoJkJxwhW9dBRep1tBXxFVE/bgfJDzeSSaVaAuwo6b5TiN9dL
 zebVdXGcZnU85iFM3vHJO8JCCT6Tag+sIuCoWA5B3VCb1ZAtVNIcmg3M8eSid8k3qUmj
 brutMaxtQYlcNBgMzf0BzeaHdJJQ6zW2QhhSm/PBBdX6M2qmwBuXrmHUYE+XO53ehcj9
 XY2C41OiKBQAiaTl2s8v2m5LZLv8orAQUgy1dPU9qdVWsFZLhqV4D/pGogWZ7IlxYwOf 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1psxk82v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 13:52:39 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33ICVFhO003949;
        Tue, 18 Apr 2023 13:52:37 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1psxk81t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 13:52:37 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33HNbr4p001751;
        Tue, 18 Apr 2023 13:52:34 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3pykj6hqgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 13:52:34 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33IDqUa123790166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 13:52:31 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1AB62004D;
        Tue, 18 Apr 2023 13:52:30 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C6052004B;
        Tue, 18 Apr 2023 13:52:29 +0000 (GMT)
Received: from [9.171.38.31] (unknown [9.171.38.31])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 18 Apr 2023 13:52:29 +0000 (GMT)
Message-ID: <9874d48f-dd04-6636-fd36-96a62ad01551@linux.ibm.com>
Date:   Tue, 18 Apr 2023 15:52:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v19 01/21] s390x/cpu topology: add s390 specifics to CPU
 topology
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
 <20230403162905.17703-2-pmorel@linux.ibm.com>
 <e96e60dade206cb970b55bfc9d2a77643bd14d98.camel@linux.ibm.com>
 <d7a0263f-4b27-387d-bf6c-fde71df3feb4@linux.ibm.com>
 <872b2cba2d76b2c635c65a1d2b301dab80866e30.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <872b2cba2d76b2c635c65a1d2b301dab80866e30.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: v4OCVy16VLVmNjtBiSvhcFP4y8hi1Tiq
X-Proofpoint-ORIG-GUID: XaEhpN5k-2lryqwZBIp9hwuuRBmacGuP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_09,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0 impostorscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304180118
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/18/23 14:38, Nina Schoetterl-Glausch wrote:
> On Tue, 2023-04-18 at 12:01 +0200, Pierre Morel wrote:
>> On 4/18/23 10:53, Nina Schoetterl-Glausch wrote:
>>> On Mon, 2023-04-03 at 18:28 +0200, Pierre Morel wrote:
>>>> S390 adds two new SMP levels, drawers and books to the CPU
>>>> topology.
>>>> The S390 CPU have specific topology features like dedication
>>>> and entitlement to give to the guest indications on the host
>>>> vCPUs scheduling and help the guest take the best decisions
>>>> on the scheduling of threads on the vCPUs.
>>>>
>>>> Let us provide the SMP properties with books and drawers levels
>>>> and S390 CPU with dedication and entitlement,
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>>>> ---
> [...]
>>>> diff --git a/qapi/machine-common.json b/qapi/machine-common.json
>>>> new file mode 100644
>>>> index 0000000000..73ea38d976
>>>> --- /dev/null
>>>> +++ b/qapi/machine-common.json
>>>> @@ -0,0 +1,22 @@
>>>> +# -*- Mode: Python -*-
>>>> +# vim: filetype=python
>>>> +#
>>>> +# This work is licensed under the terms of the GNU GPL, version 2 or later.
>>>> +# See the COPYING file in the top-level directory.
>>>> +
>>>> +##
>>>> +# = Machines S390 data types
>>>> +##
>>>> +
>>>> +##
>>>> +# @CpuS390Entitlement:
>>>> +#
>>>> +# An enumeration of cpu entitlements that can be assumed by a virtual
>>>> +# S390 CPU
>>>> +#
>>>> +# Since: 8.1
>>>> +##
>>>> +{ 'enum': 'CpuS390Entitlement',
>>>> +  'prefix': 'S390_CPU_ENTITLEMENT',
>>>> +  'data': [ 'horizontal', 'low', 'medium', 'high' ] }
>>> You can get rid of the horizontal value now that the entitlement is ignored if the
>>> polarization is vertical.
>>
>> Right, horizontal is not used, but what would you like?
>>
>> - replace horizontal with 'none' ?
>>
>> - add or substract 1 when we do the conversion between enum string and
>> value ?
> Yeah, I would completely drop it because it is a meaningless value
> and adjust the conversion to the cpu value accordingly.
>> frankly I prefer to keep horizontal here which is exactly what is given
>> in the documentation for entitlement = 0
> Not sure what you mean with this.

I mean: Extract from the PoP:

----

The following values are used:
PP Meaning
0 The one or more CPUs represented by the TLE are
horizontally polarized.
1 The one or more CPUs represented by the TLE are
vertically polarized. Entitlement is low.
2 The one or more CPUs represented by the TLE are
vertically polarized. Entitlement is medium.
3 The one or more CPUs represented by the TLE are
vertically polarized. Entitlement is high.

----

Also I find that using an enum to systematically add/subtract a value is 
for me weird.

so I really prefer to keep "horizontal", "low", "medium", "high" event 
"horizontal" will never appear.

A mater of taste, it does not change anything to the functionality or 
the API.


>>
>>
>>> [...]
>>>
>>>> diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
>>>> index b10a8541ff..57165fa3a0 100644
>>>> --- a/target/s390x/cpu.c
>>>> +++ b/target/s390x/cpu.c
>>>> @@ -37,6 +37,7 @@
>>>>    #ifndef CONFIG_USER_ONLY
>>>>    #include "sysemu/reset.h"
>>>>    #endif
>>>> +#include "hw/s390x/cpu-topology.h"
>>>>    
>>>>    #define CR0_RESET       0xE0UL
>>>>    #define CR14_RESET      0xC2000000UL;
>>>> @@ -259,6 +260,12 @@ static gchar *s390_gdb_arch_name(CPUState *cs)
>>>>    static Property s390x_cpu_properties[] = {
>>>>    #if !defined(CONFIG_USER_ONLY)
>>>>        DEFINE_PROP_UINT32("core-id", S390CPU, env.core_id, 0),
>>>> +    DEFINE_PROP_INT32("socket-id", S390CPU, env.socket_id, -1),
>>>> +    DEFINE_PROP_INT32("book-id", S390CPU, env.book_id, -1),
>>>> +    DEFINE_PROP_INT32("drawer-id", S390CPU, env.drawer_id, -1),
>>>> +    DEFINE_PROP_BOOL("dedicated", S390CPU, env.dedicated, false),
>>>> +    DEFINE_PROP_UINT8("entitlement", S390CPU, env.entitlement,
>>>> +                      S390_CPU_ENTITLEMENT__MAX),
>>> I would define an entitlement PropertyInfo in qdev-properties-system.[ch],
>>> then one can use e.g.
>>>
>>> -device z14-s390x-cpu,core-id=11,entitlement=high
>>
>> Don't you think it is an enhancement we can do later?
> It's a user visible change, so no.


We could have kept both string and integer.


> But it's not complicated, should be just:
>
> const PropertyInfo qdev_prop_cpus390entitlement = {
>      .name = "CpuS390Entitlement",
>      .enum_table = &CpuS390Entitlement_lookup,
>      .get   = qdev_propinfo_get_enum,
>      .set   = qdev_propinfo_set_enum,
>      .set_default_value = qdev_propinfo_set_default_value_enum,
> };
>
> Plus a comment & build bug in qdev-properties-system.c
>
> and
>
> extern const PropertyInfo qdev_prop_cpus390entitlement;
> #define DEFINE_PROP_CPUS390ENTITLEMENT(_n, _s, _f, _d) \
>      DEFINE_PROP_SIGNED(_n, _s, _f, _d, qdev_prop_cpus390entitlement, \
>                         CpuS390Entitlement)
>
> in qdev-properties-system.h
>
> You need to change the type of env.entitlement and set the default to 1 for medium
> and that should be it.


OK, it does not change anything to the functionality but is a little bit 
more pretty.


>>
>>> on the command line and cpu hotplug.
>>>
>>> I think setting the default entitlement to medium here should be fine.
>>>
>>> [...]
>> right, I had medium before and should not have change it.
>>
>> Anyway what ever the default is, it must be changed later depending on
>> dedication.
> No, you can just set it to medium and get rid of the adjustment code.
> s390_topology_check will reject invalid changes and the default above
> is fine since dedication is false.


I do not want a default specification for the entitlement to depend on 
the polarization.

If we do as you propose, by horizontal polarization a default 
entitlement with dedication will be accepted but will be refused after 
the guest switched for vertical polarization.

So we need adjustment before the check in both cases.

I find it easier and more logical if there is no default value than to 
have a default we need to overwrite.




