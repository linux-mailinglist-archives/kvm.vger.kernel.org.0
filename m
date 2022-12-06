Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C2F6445C7
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 15:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbiLFOfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 09:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbiLFOf3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 09:35:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2242E27155
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 06:35:28 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6E1cLG004030;
        Tue, 6 Dec 2022 14:35:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pagec0KhFI8l5e5B+TcqfM5r2U3sybxRNuEZxZHHbL4=;
 b=P1aaQCevjUPGxVU9OIyPQiQYPz+neJlcR0s+zgB5sTg0uDLDD+btBf05gIFswMyKUFas
 sUZinvPoogAAdr6lq+m0piITA5+ykRjS2kRg4SCoM+6FAGr7aoGmnW65B5qnY5O3Exc/
 V88sCmzSz+ZxgomOEdyBwKF0zmeczDuNZdoWj/enQ/vme6Ln6ydD7QTVIJ1PDerYd5it
 2RSMZnMsSPjdKXkCz4hIAeorDnBnXXZx9rNX0TQNokpUKWGFvjKIf7jydu0aICHBx6j4
 8QZtAUI1iy/oYEK3Agd2PEhntJzwQsnrlvXebyMPDK1y7urDWCH5A0sLzREDIXZxvYVt xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m9wybpg45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 14:35:09 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6Dcp3m020457;
        Tue, 6 Dec 2022 14:35:09 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m9wybpg3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 14:35:09 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B696Tot008300;
        Tue, 6 Dec 2022 14:35:07 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3m9m5y1hsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 14:35:06 +0000
Received: from d06av22.portsmouth.uk.ibm.com ([9.149.105.58])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B6EZ34L16056634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Dec 2022 14:35:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1905A4C044;
        Tue,  6 Dec 2022 14:35:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2735B4C040;
        Tue,  6 Dec 2022 14:35:02 +0000 (GMT)
Received: from [9.171.52.4] (unknown [9.171.52.4])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Dec 2022 14:35:02 +0000 (GMT)
Message-ID: <ffb9b474-e29d-c790-611e-549846b939e4@linux.ibm.com>
Date:   Tue, 6 Dec 2022 15:35:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v12 1/7] s390x/cpu topology: Creating CPU topology device
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
 <20221129174206.84882-2-pmorel@linux.ibm.com>
 <92e30cf1f091329b2076195e9c159be16c13f7f9.camel@linux.ibm.com>
 <cb4abea1-b585-2753-12e9-6b75999d7d2e@linux.ibm.com>
 <3f6f1ab828c9608fabf7ad855098cd6cae1874c4.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <3f6f1ab828c9608fabf7ad855098cd6cae1874c4.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -v69IescT0-oysd5BMCMPgSPNC7V_TK1
X-Proofpoint-ORIG-GUID: 5K4K68cXQ1RLqKISNIpNeA2qyNRBvSAk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_09,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212060115
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/6/22 14:35, Janis Schoetterl-Glausch wrote:
> On Tue, 2022-12-06 at 11:32 +0100, Pierre Morel wrote:
>>
>> On 12/6/22 10:31, Janis Schoetterl-Glausch wrote:
>>> On Tue, 2022-11-29 at 18:42 +0100, Pierre Morel wrote:
>>>> We will need a Topology device to transfer the topology
>>>> during migration and to implement machine reset.
>>>>
>>>> The device creation is fenced by s390_has_topology().
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>    include/hw/s390x/cpu-topology.h    | 44 +++++++++++++++
>>>>    include/hw/s390x/s390-virtio-ccw.h |  1 +
>>>>    hw/s390x/cpu-topology.c            | 87 ++++++++++++++++++++++++++++++
>>>>    hw/s390x/s390-virtio-ccw.c         | 25 +++++++++
>>>>    hw/s390x/meson.build               |  1 +
>>>>    5 files changed, 158 insertions(+)
>>>>    create mode 100644 include/hw/s390x/cpu-topology.h
>>>>    create mode 100644 hw/s390x/cpu-topology.c
>>>>
>>> [...]
>>>
>>>> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
>>>> index 9bba21a916..47ce0aa6fa 100644
>>>> --- a/include/hw/s390x/s390-virtio-ccw.h
>>>> +++ b/include/hw/s390x/s390-virtio-ccw.h
>>>> @@ -28,6 +28,7 @@ struct S390CcwMachineState {
>>>>        bool dea_key_wrap;
>>>>        bool pv;
>>>>        uint8_t loadparm[8];
>>>> +    DeviceState *topology;
>>>
>>> Why is this a DeviceState, not S390Topology?
>>> It *has* to be a S390Topology, right? Since you cast it to one in patch 2.
>>
>> Yes, currently it is the S390Topology.
>> The idea of Cedric was to have something more generic for future use.
> 
> But it still needs to be a S390Topology otherwise you cannot cast it to one, can you?

May be I did not understand correctly what Cedric wants.
For my part I agree with you I do not see the point to have something 
different than a S390Topology pointer.

Also doing that is more secure as we do not need cast... which reveals a 
bug I have in setup_stsi().... !!!!

Let's do that and see what Cedric says.

>>
>>>
>>>>    };
>>>>    
>>>>    struct S390CcwMachineClass {
>>>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>>>> new file mode 100644
>>>> index 0000000000..bbf97cd66a
>>>> --- /dev/null
>>>> +++ b/hw/s390x/cpu-topology.c
>>>>
>>> [...]
>>>>    
>>>> +static DeviceState *s390_init_topology(MachineState *machine, Error **errp)
>>>> +{
>>>> +    DeviceState *dev;
>>>> +
>>>> +    dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
>>>> +
>>>> +    object_property_add_child(&machine->parent_obj,
>>>> +                              TYPE_S390_CPU_TOPOLOGY, OBJECT(dev));
>>>
>>> Why set this property, and why on the machine parent?
>>
>> For what I understood setting the num_cores and num_sockets as
>> properties of the CPU Topology object allows to have them better
>> integrated in the QEMU object framework.
> 
> That I understand.
>>
>> The topology is added to the S390CcwmachineState, it is the parent of
>> the machine.
> 
> But why? And is it added to the S390CcwMachineState, or its parent?

it is added to the S390CcwMachineState.
We receive the MachineState as the "machine" parameter here and it is 
added to the "machine->parent_obj" which is the S390CcwMachineState.



>>
>>
>>>
>>>> +    object_property_set_int(OBJECT(dev), "num-cores",
>>>> +                            machine->smp.cores * machine->smp.threads, errp);
>>>> +    object_property_set_int(OBJECT(dev), "num-sockets",
>>>> +                            machine->smp.sockets, errp);
>>>> +
>>>> +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), errp);
>>>
>>> I must admit that I haven't fully grokked qemu's memory management yet.
>>> Is the topology devices now owned by the sysbus?
>>
>> Yes it is so we see it on the qtree with its properties.
>>
>>
>>> If so, is it fine to have a pointer to it S390CcwMachineState?
>>
>> Why not?
> 
> If it's owned by the sysbus and the object is not explicitly referenced
> for the pointer, it might be deallocated and then you'd have a dangling pointer.

Why would it be deallocated ?
as long it is not unrealized it belongs to the sysbus doesn't it?

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
