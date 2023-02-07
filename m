Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8A068D370
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 11:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbjBGKBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 05:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbjBGKAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 05:00:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186047EE7
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 02:00:20 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31790YIF013189;
        Tue, 7 Feb 2023 10:00:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7hkDNQFzrXqgdOpBCNX1R6HlLeqMSdGYKI3nrnddJfA=;
 b=bPwXFM5E0ppH7pUGmB4oto5WqbZywqf4X0imEY6ql82CfUtkt9fTRPMoO2HQcQ60Tj6S
 //J2iLOk36LJgi169Czj/06gXyckCHZ4WIkb14olBk6ems1KXuQ7TT7p2sLX6qN68egH
 F+a3j9Zm3896ivQs2yR6JJnsJkkcLp4+Psk+ePUL3UVd4z+xRSkeY/HfxO1Rt36sc9TZ
 ND6p0Hh14LyXzcAYk/WJI9x80dYAABvQ+7c0Io+Ylzq9ac9ARXsVn56CFRXiCLQV0mR5
 oTID9PBkIP9jIP1X61seD/unYjd8nkl6Tx81vlZns3VVsuflnlDK8hCIkmjeuqQf7hOs FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nkkmuhgch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 10:00:07 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3179xDdJ027084;
        Tue, 7 Feb 2023 10:00:07 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nkkmuhgba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 10:00:07 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31775Lua021137;
        Tue, 7 Feb 2023 09:59:33 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3nhf06ke6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 09:59:33 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3179xTKh53150064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Feb 2023 09:59:30 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C68D020043;
        Tue,  7 Feb 2023 09:59:29 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62C8D20040;
        Tue,  7 Feb 2023 09:59:29 +0000 (GMT)
Received: from [9.152.224.241] (unknown [9.152.224.241])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  7 Feb 2023 09:59:29 +0000 (GMT)
Message-ID: <f5c6b04a-0faa-ba36-9019-468662b9fbb2@linux.ibm.com>
Date:   Tue, 7 Feb 2023 10:59:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v15 06/11] s390x/cpu topology: interception of PTF
 instruction
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-7-pmorel@linux.ibm.com>
 <5c15ccde659a9849ab3529e08f5e1278508406c8.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <5c15ccde659a9849ab3529e08f5e1278508406c8.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jjM6hP-2bkB90CsR_RC6OfDXj10sQR4o
X-Proofpoint-ORIG-GUID: FKyWqLecR5BFEXdPn7NMUEHa0eRGcgat
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-07_02,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 clxscore=1015 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302070085
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/6/23 19:34, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
>> When the host supports the CPU topology facility, the PTF
>> instruction with function code 2 is interpreted by the SIE,
>> provided that the userland hypervizor activates the interpretation
>> by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.
>>
>> The PTF instructions with function code 0 and 1 are intercepted
>> and must be emulated by the userland hypervizor.
>>
>> During RESET all CPU of the configuration are placed in
>> horizontal polarity.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/s390x/s390-virtio-ccw.h |   6 ++
>>   target/s390x/cpu.h                 |   1 +
>>   hw/s390x/cpu-topology.c            | 103 +++++++++++++++++++++++++++++
>>   target/s390x/cpu-sysemu.c          |  14 ++++
>>   target/s390x/kvm/kvm.c             |  11 +++
>>   5 files changed, 135 insertions(+)
>>
> [...]
> 
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> index cf63f3dd01..1028bf4476 100644
>> --- a/hw/s390x/cpu-topology.c
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -85,16 +85,104 @@ static void s390_topology_init(MachineState *ms)
>>       QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
>>   }
>>   
>> +/**
>> + * s390_topology_set_cpus_polarity:
>> + * @polarity: polarity requested by the caller
>> + *
>> + * Set all CPU entitlement according to polarity and
>> + * dedication.
>> + * Default vertical entitlement is POLARITY_VERTICAL_MEDIUM as
>> + * it does not require host modification of the CPU provisioning
>> + * until the host decide to modify individual CPU provisioning
>> + * using QAPI interface.
>> + * However a dedicated vCPU will have a POLARITY_VERTICAL_HIGH
>> + * entitlement.
>> + */
>> +static void s390_topology_set_cpus_polarity(int polarity)
> 
> Since you set the entitlement field I'd prefer _set_cpus_entitlement or similar.

OK if you prefer.

> 
>> +{
>> +    CPUState *cs;
>> +
>> +    CPU_FOREACH(cs) {
>> +        if (polarity == POLARITY_HORIZONTAL) {
>> +            S390_CPU(cs)->env.entitlement = 0;
>> +        } else if (S390_CPU(cs)->env.dedicated) {
>> +            S390_CPU(cs)->env.entitlement = POLARITY_VERTICAL_HIGH;
>> +        } else {
>> +            S390_CPU(cs)->env.entitlement = POLARITY_VERTICAL_MEDIUM;
>> +        }
>> +    }
>> +}
>> +
> [...]
>>   
>>   /**
>> @@ -137,6 +225,21 @@ static void s390_topology_cpu_default(S390CPU *cpu, Error **errp)
>>                             (smp->books * smp->sockets * smp->cores)) %
>>                            smp->drawers;
>>       }
> 
> Why are the changes below in this patch?

Because before thos patch we have only horizontal polarization.

> 
>> +
>> +    /*
>> +     * Machine polarity is set inside the global s390_topology structure.
>> +     * In the case the polarity is set as horizontal set the entitlement

Sorry here an error in the comment should be :
"In the case the polarity is NOT set as horizontal..."

>> +     * to POLARITY_VERTICAL_MEDIUM which is the better equivalent when
>> +     * machine polarity is set to vertical or POLARITY_VERTICAL_HIGH if
>> +     * the vCPU is dedicated.
>> +     */
>> +    if (s390_topology.polarity && !env->entitlement) {
> 
> It'd be more readable if you compared against enum values by name.

Right, I will change this to

     if (s390_topology.polarity != S390_POLARITY_HORIZONTAL &&
         env->entitlement == S390_ENTITLEMENT_UNSET) {

> 
> I don't see why you check s390_topology.polarity. If it is horizontal
> then the value of the entitlement doesn't matter at all, so you can set it
> to whatever.

Right, that is why it is done only for vertical polarization (sorry for 
the wrong comment)

> All you want to do is enforce dedicated -> VERTICAL_HIGH, right?
> So why don't you just add
> 
> +    if (cpu->env.dedicated && cpu->env.entitlement != POLARITY_VERTICAL_HIGH) {
> +        error_setg(errp, "A dedicated cpu implies high entitlement");
> +        return;
> +    } >
> to s390_topology_check?

Here it is to set the default in the case the values are not provided.

But where you are right is that I should add a verification to the check 
function.

> 
>> +        if (env->dedicated) {
>> +            env->entitlement = POLARITY_VERTICAL_HIGH;
>> +        } else {
>> +            env->entitlement = POLARITY_VERTICAL_MEDIUM;
>> +        }
> 
> If it is horizontal, then setting the entitlement is pointless as it will be
> reset to medium on PTF.

That is why the polarity is tested (sorry for the bad comment)

> So the current polarization is vertical and a cpu is being hotplugged,
> but setting the entitlement of the cpu being added is also pointless, because
> it's determined by the dedication. That seems weird.

No it is not determined by the dedication, if there is no dedication the 
3 vertical values are possible.


Regards,
Pierre

> 
>> +    }
>>   }
>>   
> 
> [...]

-- 
Pierre Morel
IBM Lab Boeblingen
