Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398916E5E29
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 12:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjDRKDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 06:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjDRKDi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 06:03:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56E93AA0
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 03:03:35 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33I8aPOq014825;
        Tue, 18 Apr 2023 10:03:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nbsxf3kjHO1yzQ6qVB8qIZ+cJr9iVRLawC/fz0N1cGU=;
 b=sA85iRXdbM9GqcJ+DJBNqMrFwYolbSCcOxER1UgJ5huZo6cRyFKfba8zukON7b2sXLK5
 IbrlBPUMhsnBX5MWsLRY6euX6PeojE6wJYunyLrKRnwmLqkdAyic2B6v/YUwz7IPJOdv
 rqvNxZ9t/iq+Xlzpen5ZFLauQX1PmMrUaz7mjhDmTIHzX9+s40gs6iZHln943SF3uNJ/
 QHPNGL8A2ctS5opz/1IgGSmDnrqkS+V7E49u5Z7SBVDpYs28Qn6z9IojkRWsTBSbgngm
 bmSmBMCxq7uNUz0shxyrQGVc0icLkbsNz7tH4rI3FMuKLpQXP1A+cwRAZFTHa+fmM2XY TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1pm14ngx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 10:03:18 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33I9MDsS010275;
        Tue, 18 Apr 2023 10:03:15 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1pm14mh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 10:03:15 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33I0Tvfr014470;
        Tue, 18 Apr 2023 10:01:52 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pykj6hx36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 10:01:51 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33IA1mmU28705330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 10:01:48 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B1D62004D;
        Tue, 18 Apr 2023 10:01:48 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1892A2004B;
        Tue, 18 Apr 2023 10:01:47 +0000 (GMT)
Received: from [9.171.38.31] (unknown [9.171.38.31])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 18 Apr 2023 10:01:47 +0000 (GMT)
Message-ID: <d7a0263f-4b27-387d-bf6c-fde71df3feb4@linux.ibm.com>
Date:   Tue, 18 Apr 2023 12:01:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v19 01/21] s390x/cpu topology: add s390 specifics to CPU
 topology
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
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <e96e60dade206cb970b55bfc9d2a77643bd14d98.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WM54DEyMwDAF6V0_BkGk31R0316_wC_R
X-Proofpoint-ORIG-GUID: PYPNcmML0yPmYOHSZKtwKebMknm2xb0t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_06,2023-04-17_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304180087
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/18/23 10:53, Nina Schoetterl-Glausch wrote:
> On Mon, 2023-04-03 at 18:28 +0200, Pierre Morel wrote:
>> S390 adds two new SMP levels, drawers and books to the CPU
>> topology.
>> The S390 CPU have specific topology features like dedication
>> and entitlement to give to the guest indications on the host
>> vCPUs scheduling and help the guest take the best decisions
>> on the scheduling of threads on the vCPUs.
>>
>> Let us provide the SMP properties with books and drawers levels
>> and S390 CPU with dedication and entitlement,
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   MAINTAINERS                     |  5 ++++
>>   qapi/machine-common.json        | 22 ++++++++++++++
>>   qapi/machine-target.json        | 12 ++++++++
>>   qapi/machine.json               | 17 +++++++++--
>>   include/hw/boards.h             | 10 ++++++-
>>   include/hw/s390x/cpu-topology.h | 15 ++++++++++
> Is hw/s390x the right path for cpu-topology?
> I haven't understood the difference between hw/s390x and target/s390x
> but target/s390x feels more correct, I could be mistaken though.

AFAIK target/s390 is for CPU emulation code while hw/s390 is for other 
emulation.

So it depends how we classify the CPU topology, it is related to CPU but 
it is no emulation.

Since Thomas approved this layout I would like to keep it like this.


>
>>   target/s390x/cpu.h              |  5 ++++
>>   hw/core/machine-smp.c           | 53 ++++++++++++++++++++++++++++-----
>>   hw/core/machine.c               |  4 +++
>>   hw/s390x/s390-virtio-ccw.c      |  2 ++
>>   softmmu/vl.c                    |  6 ++++
>>   target/s390x/cpu.c              |  7 +++++
>>   qapi/meson.build                |  1 +
>>   qemu-options.hx                 |  7 +++--
>>   14 files changed, 152 insertions(+), 14 deletions(-)
>>   create mode 100644 qapi/machine-common.json
>>   create mode 100644 include/hw/s390x/cpu-topology.h
>>
> [...]
>
>> diff --git a/qapi/machine-common.json b/qapi/machine-common.json
>> new file mode 100644
>> index 0000000000..73ea38d976
>> --- /dev/null
>> +++ b/qapi/machine-common.json
>> @@ -0,0 +1,22 @@
>> +# -*- Mode: Python -*-
>> +# vim: filetype=python
>> +#
>> +# This work is licensed under the terms of the GNU GPL, version 2 or later.
>> +# See the COPYING file in the top-level directory.
>> +
>> +##
>> +# = Machines S390 data types
>> +##
>> +
>> +##
>> +# @CpuS390Entitlement:
>> +#
>> +# An enumeration of cpu entitlements that can be assumed by a virtual
>> +# S390 CPU
>> +#
>> +# Since: 8.1
>> +##
>> +{ 'enum': 'CpuS390Entitlement',
>> +  'prefix': 'S390_CPU_ENTITLEMENT',
>> +  'data': [ 'horizontal', 'low', 'medium', 'high' ] }
> You can get rid of the horizontal value now that the entitlement is ignored if the
> polarization is vertical.


Right, horizontal is not used, but what would you like?

- replace horizontal with 'none' ?

- add or substract 1 when we do the conversion between enum string and 
value ?

frankly I prefer to keep horizontal here which is exactly what is given 
in the documentation for entitlement = 0



>
> [...]
>
>> diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
>> index b10a8541ff..57165fa3a0 100644
>> --- a/target/s390x/cpu.c
>> +++ b/target/s390x/cpu.c
>> @@ -37,6 +37,7 @@
>>   #ifndef CONFIG_USER_ONLY
>>   #include "sysemu/reset.h"
>>   #endif
>> +#include "hw/s390x/cpu-topology.h"
>>   
>>   #define CR0_RESET       0xE0UL
>>   #define CR14_RESET      0xC2000000UL;
>> @@ -259,6 +260,12 @@ static gchar *s390_gdb_arch_name(CPUState *cs)
>>   static Property s390x_cpu_properties[] = {
>>   #if !defined(CONFIG_USER_ONLY)
>>       DEFINE_PROP_UINT32("core-id", S390CPU, env.core_id, 0),
>> +    DEFINE_PROP_INT32("socket-id", S390CPU, env.socket_id, -1),
>> +    DEFINE_PROP_INT32("book-id", S390CPU, env.book_id, -1),
>> +    DEFINE_PROP_INT32("drawer-id", S390CPU, env.drawer_id, -1),
>> +    DEFINE_PROP_BOOL("dedicated", S390CPU, env.dedicated, false),
>> +    DEFINE_PROP_UINT8("entitlement", S390CPU, env.entitlement,
>> +                      S390_CPU_ENTITLEMENT__MAX),
> I would define an entitlement PropertyInfo in qdev-properties-system.[ch],
> then one can use e.g.
>
> -device z14-s390x-cpu,core-id=11,entitlement=high


Don't you think it is an enhancement we can do later?


>
> on the command line and cpu hotplug.
>
> I think setting the default entitlement to medium here should be fine.
>
> [...]

right, I had medium before and should not have change it.

Anyway what ever the default is, it must be changed later depending on 
dedication.



