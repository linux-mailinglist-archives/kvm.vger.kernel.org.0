Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E7757C601
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 10:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbiGUIQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 04:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbiGUIQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 04:16:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB9F7D78C
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 01:16:27 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26L7ftfU003392;
        Thu, 21 Jul 2022 08:16:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=g9GEWB8ZgVO6f8qkZn5NPJE6rKndmetNpcFdr8G5cQw=;
 b=JRVaBHJpQRD/IddiKt03hIhj79v1yOe+C2oNac47OmNtHUwHrYFr9De/ItEIWtiMTIwz
 cyp+v7PbcPJ3B4TzUzmG6+p8hTDd5bq4M+v5dmas+CIdqtjTahtSfBzy980liQFhKNMb
 CvmV/8lMf7g8P3i4mentLu362u7tIZ9Y/mxTyQGC9P3c2w9DMEgm7arz639A+k62fXkI
 QGL8tdo0PGgJbJADeraAVrzBBA/EYWpQC2tVHvLBF9nu+sT7lOb3fh09GWMjOu3shIXH
 IvPLXoZPFLX6q9uJ6To48j0tsNiQSwmkMx75jPb0NB7HAkdW9jXdktVWMj6h+AiLrpvs 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf2mvrwha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 08:16:19 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26L85AJt020052;
        Thu, 21 Jul 2022 08:16:18 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf2mvrwga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 08:16:18 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26L86k6L000802;
        Thu, 21 Jul 2022 08:16:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3hbmkj6mfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 08:16:16 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26L8GC8p16515374
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 08:16:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D648711C050;
        Thu, 21 Jul 2022 08:16:12 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22E6811C04C;
        Thu, 21 Jul 2022 08:16:11 +0000 (GMT)
Received: from [9.171.85.131] (unknown [9.171.85.131])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 08:16:10 +0000 (GMT)
Message-ID: <4d0d25e9-fedf-728c-12e9-70e4dc04d6b7@linux.ibm.com>
Date:   Thu, 21 Jul 2022 10:16:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v8 08/12] s390x/cpu_topology: implementing numa for the
 s390x topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
 <20220620140352.39398-9-pmorel@linux.ibm.com>
 <3a821cd1-b8a0-e737-5279-8ef55e58a77f@linux.ibm.com>
 <b1e89718-232c-2b0b-2133-102ab7b4dad4@linux.ibm.com>
 <b30eb75a-5a0b-3428-b812-95a2884914e4@linux.ibm.com>
 <14afa5dc-80de-c5a2-b57d-867c692b29cf@linux.ibm.com>
 <e497396a-eadf-15ae-e11c-d6a2bbbff7c7@linux.ibm.com>
 <3b2f62a7-b526-adfd-e791-f2bc2cae3ccf@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <3b2f62a7-b526-adfd-e791-f2bc2cae3ccf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TV6CKNsHAs8wzZW_gbgH6fCjbBkjjZKb
X-Proofpoint-GUID: VMam7kBNcuHf6bPdOvJS7Vgqbx8iMiDW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-20_12,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210031
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/21/22 09:58, Pierre Morel wrote:
> 
> 
> On 7/20/22 19:24, Janis Schoetterl-Glausch wrote:
>> On 7/15/22 15:07, Pierre Morel wrote:
>>>
>>>
>>> On 7/15/22 11:11, Janis Schoetterl-Glausch wrote:
>>>> On 7/14/22 22:17, Pierre Morel wrote:
>>>>>
>>>>>
>>>>> On 7/14/22 16:57, Janis Schoetterl-Glausch wrote:
>>>>>> On 6/20/22 16:03, Pierre Morel wrote:
>>>>>>> S390x CPU Topology allows a non uniform repartition of the CPU
>>>>>>> inside the topology containers, sockets, books and drawers.
>>>>>>>
>>>>>>> We use numa to place the CPU inside the right topology container
>>>>>>> and report the non uniform topology to the guest.
>>>>>>>
>>>>>>> Note that s390x needs CPU0 to belong to the topology and consequently
>>>>>>> all topology must include CPU0.
>>>>>>>
>>>>>>> We accept a partial QEMU numa definition, in that case undefined CPUs
>>>>>>> are added to free slots in the topology starting with slot 0 and going
>>>>>>> up.
>>>>>>
>>>>>> I don't understand why doing it this way, via numa, makes sense for us.
>>>>>> We report the topology to the guest via STSI, which tells the guest
>>>>>> what the topology "tree" looks like. We don't report any numa distances to the guest.
>>>>>> The natural way to specify where a cpu is added to the vm, seems to me to be
>>>>>> by specify the socket, book, ... IDs when doing a device_add or via -device on
>>>>>> the command line.
>>>>>>
>>>>>> [...]
>>>>>>
>>>>>
>>>>> It is a choice to have the core-id to determine were the CPU is situated in the topology.
>>>>>
>>>>> But yes we can chose the use drawer-id,book-id,socket-id and use a core-id starting on 0 on each socket.
>>>>>
>>>>> It is not done in the current implementation because the core-id implies the socket-id, book-id and drawer-id together with the smp parameters.
>>>>>
>>>>>
>>>> Regardless of whether the core-id or the combination of socket-id, book-id .. is used to specify where a CPU is
>>>> located, why use the numa framework and not just device_add or -device ?
>>>
>>> You are right, at least we should be able to use both.
>>> I will work on this.
>>>
>>>>
>>>> That feels way more natural since it should already just work if you can do hotplug.
>>>> At least with core-id and I suspect with a subset of your changes also with socket-id, etc.
>>>
>>> yes, it already works with core-id
>>>
>>>>
>>>> Whereas numa is an awkward fit since it's for specifying distances between nodes, which we don't do,
>>>> and you have to use a hack to get it to specify which CPUs to plug (via setting arch_id to -1).
>>>>
>>>
>>> Is it only for this?
>>>
>> That's what it looks like to me, but I'm not an expert by any means.
>> x86 reports distances and more via ACPI, riscv via device tree and power appears to
>> calculate hierarchy values which the linux kernel will turn into distances again.
>> That's maybe closest to s390x. However, as far as I can tell all of that is static
>> and cannot be reconfigured. If we want to have STSI dynamically reflect the topology
>> at some point in the future, we should have a roadmap for how to achieve that.
>>
>>
> 
> 
> You are right, numa is redundant for us as we specify the topology using the core-id.
> The roadmap I would like to discuss is using a new:
> 
> (qemu) cpu_move src dst
> 
> where src is the current core-id and dst is the destination core-id.
> 
> I am aware that there are deep implication on current cpu code but I do not think it is not possible.
> If it is unpossible then we would need a new argument to the device_add for cpu to define the "effective_core_id"
> But we will still need the new hmp command to update the topology.
> 
I don't think core-id is the right one, that's the guest visible CPU address, isn't it?
Although it seems badly named then, since multiple threads are part of the same core (ok, we don't support threads).
Instead socket-id, book-id could be changed dynamically instead of being computed from the core-id.
