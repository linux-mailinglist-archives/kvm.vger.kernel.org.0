Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F043157BC8E
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 19:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbiGTRYv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 13:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiGTRYu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 13:24:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C3462489
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 10:24:49 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26KHDgu4022475;
        Wed, 20 Jul 2022 17:24:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GFPuIJ6wjwzVjF+xgJnE1mUjlOx7qoUJqh0Ipd6wiKI=;
 b=qhKuaHMBEvnvqyFVxOSEShZCcpi8RIWTLnObjfGDWikG3NxgFGbNHFB6+IYqezOSMx5r
 NvmVOCEHgBJryn/Hycan85cw1wUQXuq0LcEQUww8mg4CG3jwHSiqNk/xTZhbHHE5txUn
 1DzF2nNqArG5N6gPkuwufdYeqEEq7pYNBYBKJtpThzpqUBb+9Bee4eu0sqdncwv88UMM
 uyVykpx58IFSsOJQvZ4qc9ksBKcPYlynQHoz+gIPWMUma77qIKtLBYX5XTEikDSTGaCe
 DykPunsEC4/vbR8Cu1nbq9pBjXNVralX1cfG/jtkn5i5YHGQDm7+nF0gYyeR+XDnfIRS dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3henwxr9pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 17:24:43 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26KHE1Gw023680;
        Wed, 20 Jul 2022 17:24:43 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3henwxr9ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 17:24:42 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26KHNovd028246;
        Wed, 20 Jul 2022 17:24:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3hbmkj5w62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 17:24:41 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26KHObFc19726694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jul 2022 17:24:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF6A111C050;
        Wed, 20 Jul 2022 17:24:37 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 095A611C04A;
        Wed, 20 Jul 2022 17:24:36 +0000 (GMT)
Received: from [9.171.85.19] (unknown [9.171.85.19])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jul 2022 17:24:34 +0000 (GMT)
Message-ID: <e497396a-eadf-15ae-e11c-d6a2bbbff7c7@linux.ibm.com>
Date:   Wed, 20 Jul 2022 19:24:34 +0200
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
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <14afa5dc-80de-c5a2-b57d-867c692b29cf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lzwOWa2DdlMOoeQzAGc6_LBLZRXBtN6a
X-Proofpoint-ORIG-GUID: pAISXU3MGE_M-19vlYi_5k2Wz583TRLS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-20_10,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 impostorscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 malwarescore=0 adultscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207200070
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/15/22 15:07, Pierre Morel wrote:
> 
> 
> On 7/15/22 11:11, Janis Schoetterl-Glausch wrote:
>> On 7/14/22 22:17, Pierre Morel wrote:
>>>
>>>
>>> On 7/14/22 16:57, Janis Schoetterl-Glausch wrote:
>>>> On 6/20/22 16:03, Pierre Morel wrote:
>>>>> S390x CPU Topology allows a non uniform repartition of the CPU
>>>>> inside the topology containers, sockets, books and drawers.
>>>>>
>>>>> We use numa to place the CPU inside the right topology container
>>>>> and report the non uniform topology to the guest.
>>>>>
>>>>> Note that s390x needs CPU0 to belong to the topology and consequently
>>>>> all topology must include CPU0.
>>>>>
>>>>> We accept a partial QEMU numa definition, in that case undefined CPUs
>>>>> are added to free slots in the topology starting with slot 0 and going
>>>>> up.
>>>>
>>>> I don't understand why doing it this way, via numa, makes sense for us.
>>>> We report the topology to the guest via STSI, which tells the guest
>>>> what the topology "tree" looks like. We don't report any numa distances to the guest.
>>>> The natural way to specify where a cpu is added to the vm, seems to me to be
>>>> by specify the socket, book, ... IDs when doing a device_add or via -device on
>>>> the command line.
>>>>
>>>> [...]
>>>>
>>>
>>> It is a choice to have the core-id to determine were the CPU is situated in the topology.
>>>
>>> But yes we can chose the use drawer-id,book-id,socket-id and use a core-id starting on 0 on each socket.
>>>
>>> It is not done in the current implementation because the core-id implies the socket-id, book-id and drawer-id together with the smp parameters.
>>>
>>>
>> Regardless of whether the core-id or the combination of socket-id, book-id .. is used to specify where a CPU is
>> located, why use the numa framework and not just device_add or -device ?
> 
> You are right, at least we should be able to use both.
> I will work on this.
> 
>>
>> That feels way more natural since it should already just work if you can do hotplug.
>> At least with core-id and I suspect with a subset of your changes also with socket-id, etc.
> 
> yes, it already works with core-id
> 
>>
>> Whereas numa is an awkward fit since it's for specifying distances between nodes, which we don't do,
>> and you have to use a hack to get it to specify which CPUs to plug (via setting arch_id to -1).
>>
> 
> Is it only for this?
> 
That's what it looks like to me, but I'm not an expert by any means.
x86 reports distances and more via ACPI, riscv via device tree and power appears to
calculate hierarchy values which the linux kernel will turn into distances again.
That's maybe closest to s390x. However, as far as I can tell all of that is static
and cannot be reconfigured. If we want to have STSI dynamically reflect the topology
at some point in the future, we should have a roadmap for how to achieve that.

