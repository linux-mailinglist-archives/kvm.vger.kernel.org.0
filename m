Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C36574BB6
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 13:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237501AbiGNLVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 07:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiGNLVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 07:21:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF46A481DE
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 04:21:14 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26EAqiDS004039;
        Thu, 14 Jul 2022 11:21:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=m6cWFl3Hik2P5p9wusVYLgzyLUQU9xvTeNQlHIeYYiA=;
 b=OqVrJMAAKgxmpvuwnL6vaGldem/Y7XCmSCoSrDQSqCgh8qDTKE5vyDN99bgtav2hAry2
 fSbDvoKZvs6yStI8QT5i123AwHATi9kskI0FZXnlwNkDQUtG9VzuMt3NL9b8nrQshZt7
 XravwpvhN2eBHx+2zTitcSSxAshnj+pj1L3+nH4+2Tg5FOKV37gHUT0fDgNIeRPXIJEE
 VXL6OH2DeBPE9DAXQBjo4dufmpKudZFFlf9B+OCgasuIcSDBJNmll9wlvLAMhSppZtFa
 cdTRSLGGIPg+u79gaLoIfw7LejCirH6vsg3lY2nvi2sMNaTjOttHYUp9uj3aIxSTl3qQ OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hahsd8mxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 11:21:06 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26EBL6Kv003505;
        Thu, 14 Jul 2022 11:21:06 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hahsd8mx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 11:21:06 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26EBKKwm005152;
        Thu, 14 Jul 2022 11:21:04 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3h70xhy0vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 11:21:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26EBL16C21430714
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 11:21:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31ADDAE04D;
        Thu, 14 Jul 2022 11:21:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B04AAE045;
        Thu, 14 Jul 2022 11:21:00 +0000 (GMT)
Received: from [9.171.80.107] (unknown [9.171.80.107])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jul 2022 11:21:00 +0000 (GMT)
Message-ID: <4fef46f1-f43f-665f-47dc-89107385572e@linux.ibm.com>
Date:   Thu, 14 Jul 2022 13:25:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v8 02/12] s390x/cpu_topology: CPU topology objects and
 structures
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
 <20220620140352.39398-3-pmorel@linux.ibm.com>
 <de92ef17-3a17-df44-97aa-19e67d1d5b3d@linux.ibm.com>
 <5215ca74-e71c-73df-69c9-d2522e082706@linux.ibm.com>
 <53698be8-0eab-8dc2-2d54-df2a89e1092f@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <53698be8-0eab-8dc2-2d54-df2a89e1092f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SPfpJbwU5bhYAW07ijRPeap34uDVie7e
X-Proofpoint-ORIG-GUID: yc8nGrP8dbYNJGiQQYxyA2ER08ms3JOz
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_08,2022-07-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207140046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/14/22 12:38, Janis Schoetterl-Glausch wrote:
> On 7/13/22 16:59, Pierre Morel wrote:
>>
>>
>> On 7/12/22 17:40, Janis Schoetterl-Glausch wrote:
>>> On 6/20/22 16:03, Pierre Morel wrote:

> 
> [...]
> 
>>>> +}
>>>> +
>>>> +/*
>>>> + * s390_topology_new_cpu:
>>>> + * @core_id: the core ID is machine wide
>>>> + *
>>>> + * We have a single book returned by s390_get_topology(),
>>>> + * then we build the hierarchy on demand.
>>>> + * Note that we do not destroy the hierarchy on error creating
>>>> + * an entry in the topology, we just keep it empty.
>>>> + * We do not need to worry about not finding a topology level
>>>> + * entry this would have been caught during smp parsing.
>>>> + */
>>>> +bool s390_topology_new_cpu(MachineState *ms, int core_id, Error **errp)
>>>> +{
>>>> +    S390TopologyBook *book;
>>>> +    S390TopologySocket *socket;
>>>> +    S390TopologyCores *cores;
>>>> +    int nb_cores_per_socket;
>>>
>>> num_cores_per_socket instead?
>>>
>>>> +    int origin, bit;
>>>> +
>>>> +    book = s390_get_topology();
>>>> +
>>>> +    nb_cores_per_socket = ms->smp.cores * ms->smp.threads;
>>>
>>> We don't support the multithreading facility, do we?
>>> So, I think we should assert smp.threads == 1 somewhere.
>>> In any case I think the correct expression would round the threads up to the next power of 2,
>>> because the core_id has the thread id in the lower bits, but threads per core doesn't need to be
>>> a power of 2 according to the architecture.
>>
>> That is right.
>> I will add that.
> 
> Add the assert?
> It should probably be somewhere else.

That is sure.
I thought about put a fatal error report during the initialization in 
the s390_topology_setup()

> And you can set thread > 1 today, so we'd need to handle that. (increase the number of cpus instead and print a warning?)
> 
> [...]

this would introduce arch dependencies in the hw/core/
I think that the error report for Z is enough.

So once we support Multithreading in the guest we can adjust it easier 
without involving the common code.

Or we can introduce a thread_supported in SMPCompatProps, which would be 
good.
I would prefer to propose this outside of the series and suppress the 
fatal error once it is adopted.

> 
>>>> +
>>>> +/*
>>>> + * Setting the first topology: 1 book, 1 socket
>>>> + * This is enough for 64 cores if the topology is flat (single socket)
>>>> + */
>>>> +void s390_topology_setup(MachineState *ms)
>>>> +{
>>>> +    DeviceState *dev;
>>>> +
>>>> +    /* Create BOOK bridge device */
>>>> +    dev = qdev_new(TYPE_S390_TOPOLOGY_BOOK);
>>>> +    object_property_add_child(qdev_get_machine(),
>>>> +                              TYPE_S390_TOPOLOGY_BOOK, OBJECT(dev));
>>>
>>> Why add it to the machine instead of directly using a static?
>>
>> For my opinion it is a characteristic of the machine.
>>
>>> So it's visible to the user via info qtree or something?
>>
>> It is already visible to the user on info qtree.
>>
>>> Would that even be the appropriate location to show that?
>>
>> That is a very good question and I really appreciate if we discuss on the design before diving into details.
>>
>> The idea is to have the architecture details being on qtree as object so we can plug new drawers/books/socket/cores and in the future when the infrastructure allows it unplug them.
> 
> Would it not be more accurate to say that we plug in new cpus only?
> Since you need to specify the topology up front with -smp and it cannot change after.

smp specify the maximum we can have.
I thought we can add dynamically elements inside this maximum set.

> So that all is static, books/sockets might be completely unpopulated, but they still exist in a way.
> As far as I understand, STSI only allows for cpus to change, nothing above it.

I thought we want to plug new books or drawers but I may be wrong.

>>
>> There is a info numa (info cpus does not give a lot info) to give information on nodes but AFAIU, a node is more a theoritical that can be used above the virtual architecture, sockets/cores, to specify characteristics like distance and associated memory.
> 
> https://qemu.readthedocs.io/en/latest/interop/qemu-qmp-ref.html#qapidoc-2391
> shows that the relevant information can be queried via qmp.
> When I tried it on s390x it only showed the core_id, but we should be able to add the rest.

yes, sure.

> 
> 
> Am I correct in my understanding, that there are two reasons to have the hierarchy objects:
> 1. Caching the topology instead of computing it when STSI is called
> 2. So they show up in info qtree
> 
> ?

and have the possibility to add the objects dynamically. yes


> [...]
> 
>>
>>>> +    /*
>>>> +     * Each CPU inside a socket will be represented by a bit in a 64bit
>>>> +     * unsigned long. Set on plug and clear on unplug of a CPU.
>>>> +     * All CPU inside a mask share the same dedicated, polarity and
>>>> +     * cputype values.
>>>> +     * The origin is the offset of the first CPU in a mask.
>>>> +     */
>>>> +struct S390TopologyCores {
>>>> +    DeviceState parent_obj;
>>>> +    int id;
>>>> +    bool dedicated;
>>>> +    uint8_t polarity;
>>>> +    uint8_t cputype;
>>>
>>> Why not snake_case for cpu type?
>>
>> I do not understand what you mean.
> 
> I'm suggesting s/cputype/cpu_type/

ok


Thanks,

regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
