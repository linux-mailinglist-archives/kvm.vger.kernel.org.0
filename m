Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B596A6FC667
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 14:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbjEIMb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 08:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234704AbjEIMbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 08:31:55 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943FD40DB
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 05:31:54 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 349CGxGj024086;
        Tue, 9 May 2023 12:31:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UjDeIGXwvkRfdc5WVoZon46BLUv2RODnqijZ3sWvMnQ=;
 b=ML0NeCiePEQEWyH4jGGjGxHUzekqYD0Y+WKne27Ep0xSFkPuL55qO07IgKN8W9SROSmz
 Sdy/6vyH7IE6SUnqGnqF8bEQPYNZCURjl/ETuLll5S0zmGhZ6XhSKQrsQMPYbqM3rgCv
 PBxpFtwPYrPmphi+vqF6bKuxjLHVJuVUy0R2AYXzapWywzu+BbYTI6wlrqp3/mbBY+Lt
 hRxu+9MRF+/Dni0Wh4ZOVjcWExX56JZv0pERRRYTyVSEiHyepCaNFG+uPZY9tB9hK0JH
 1qfIqvw3JblOTkbhal0UN1Fj7WLoneQYFYUotbCNUtMNrz6pFtekPygmBGHGAbMu3TUC Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfnn4h45n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 12:31:48 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 349CTxOF013592;
        Tue, 9 May 2023 12:31:47 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfnn4h44s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 12:31:47 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3494oH54006449;
        Tue, 9 May 2023 12:31:45 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3qf7s8gbsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 12:31:45 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 349CVdM44784866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 May 2023 12:31:39 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9A232004D;
        Tue,  9 May 2023 12:31:39 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16CC820040;
        Tue,  9 May 2023 12:31:39 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue,  9 May 2023 12:31:39 +0000 (GMT)
Message-ID: <316aab44-7bba-001b-b80b-019af97e9e76@linux.ibm.com>
Date:   Tue, 9 May 2023 14:31:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v20 11/21] qapi/s390x/cpu topology:
 CPU_POLARIZATION_CHANGE qapi event
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
 <20230425161456.21031-12-pmorel@linux.ibm.com>
 <3a79538637fc8e8f226290c9ba833face1784c29.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <3a79538637fc8e8f226290c9ba833face1784c29.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7ZNS1ReELsABF9ESWzs9DWi4SQ0gTZ52
X-Proofpoint-ORIG-GUID: rygWCqN6wEyPr2pDVTw5nP3npKbC9uC5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 mlxscore=0 adultscore=0 priorityscore=1501 spamscore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305090097
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/8/23 23:47, Nina Schoetterl-Glausch wrote:
> On Tue, 2023-04-25 at 18:14 +0200, Pierre Morel wrote:
>> When the guest asks to change the polarization this change
>> is forwarded to the upper layer using QAPI.
>> The upper layer is supposed to take according decisions concerning
>> CPU provisioning.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   qapi/machine-target.json | 33 +++++++++++++++++++++++++++++++++
>>   hw/s390x/cpu-topology.c  |  2 ++
>>   2 files changed, 35 insertions(+)
>>
>> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
>> index 3b7a0b77f4..ffde2e9cbd 100644
>> --- a/qapi/machine-target.json
>> +++ b/qapi/machine-target.json
>> @@ -391,3 +391,36 @@
>>     'features': [ 'unstable' ],
>>     'if': { 'all': [ 'TARGET_S390X' , 'CONFIG_KVM' ] }
>>   }
>> +
>> +##
>> +# @CPU_POLARIZATION_CHANGE:
>> +#
>> +# Emitted when the guest asks to change the polarization.
>> +#
>> +# @polarization: polarization specified by the guest
>> +#
>> +# Features:
>> +# @unstable: This command may still be modified.
>> +#
>> +# The guest can tell the host (via the PTF instruction) whether the
>> +# CPUs should be provisioned using horizontal or vertical polarization.
>> +#
>> +# On horizontal polarization the host is expected to provision all vCPUs
>> +# equally.
>> +# On vertical polarization the host can provision each vCPU differently.
>> +# The guest will get information on the details of the provisioning
>> +# the next time it uses the STSI(15) instruction.
>> +#
>> +# Since: 8.1
>> +#
>> +# Example:
>> +#
>> +# <- { "event": "CPU_POLARIZATION_CHANGE",
>> +#      "data": { "polarization": 0 },
> I think you'd be getting "horizontal" instead of 0.


you are right.


>
>> +#      "timestamp": { "seconds": 1401385907, "microseconds": 422329 } }
>> +##
>> +{ 'event': 'CPU_POLARIZATION_CHANGE',
>> +  'data': { 'polarization': 'CpuS390Polarization' },
>> +  'features': [ 'unstable' ],
>> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>> +}
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> index e5fb976594..e8b140d623 100644
>> --- a/hw/s390x/cpu-topology.c
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -17,6 +17,7 @@
>>   #include "hw/s390x/s390-virtio-ccw.h"
>>   #include "hw/s390x/cpu-topology.h"
>>   #include "qapi/qapi-commands-machine-target.h"
>> +#include "qapi/qapi-events-machine-target.h"
>>   
>>   /*
>>    * s390_topology is used to keep the topology information.
>> @@ -138,6 +139,7 @@ void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra)
>>           } else {
>>               s390_topology.vertical_polarization = !!fc;
>>               s390_cpu_topology_set_changed(true);
>> +            qapi_event_send_cpu_polarization_change(fc);
> I'm not sure I like the implicit conversation of the function code to the enum value.
> How about you do qapi_event_send_cpu_polarization_change(s390_topology.polarization);
> and rename vertical_polarization and change it's type to the enum.
> You can then also do
>
> +    CpuS390Polarization polarization = S390_CPU_POLARIZATION_HORIZONTAL;
> +    switch (fc) {
> +    case S390_CPU_POLARIZATION_VERTICAL:
> +        polarization = S390_CPU_POLARIZATION_VERTICAL;
> +        /* fallthrough */
> +    case S390_CPU_POLARIZATION_HORIZONTAL:
> +        if (s390_topology.polarization == polarization) {
>
> and use the value for the assignment further down, too.

OK, that look good.

I guess I have to modify the patch 8 on handle_ptf ,





>>               setcc(cpu, 0);
>>           }
>>           break;
