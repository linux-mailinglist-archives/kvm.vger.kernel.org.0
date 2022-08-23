Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD69559EAA7
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 20:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiHWSNQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 14:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbiHWSMq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 14:12:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128DD6E88A
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 09:25:37 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NFu8Ps006185;
        Tue, 23 Aug 2022 16:25:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dKKTSoCQoxAzlBp5InzbrVdC8gWCSSSReSO6OvEbnYw=;
 b=oX/ug9DfMwdI+FHKok/4oD87RIr6X6hcKMoOmRGjvkWOr3NQP6+QAO86F1JuS17mn7Rf
 jQLRUd0e4ZevnM14hXh00yKFX5Th6UfiJzkaE0+e0nQSI0VRb3AB34i1RL5g97+TAS57
 c4GwduOtfHU7/MtyUcnC0kgl0Z1fx6YlTB4QI14wUTisyKjJZPt60Ojly5b+1RuoIA2+
 FNJCyudo1dtPVdhHxkBHtbNgLtX9cmrn6CTEyowVR2E1aFmGhN9ljwuDBh94tpWBfCkp
 2mvW5Gp7hNf6pIl7dEQczUhGPqgE0nu76UrITu7o7hRuOHLfjZ+O/H12YaNHCB7NZvRr 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j51yd906v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 16:25:22 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27NFvn6s014010;
        Tue, 23 Aug 2022 16:25:22 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j51yd905v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 16:25:22 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NG6mDP021381;
        Tue, 23 Aug 2022 16:25:20 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3j2q892y56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 16:25:20 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NGPHeG33816852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 16:25:17 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55B90A405F;
        Tue, 23 Aug 2022 16:25:17 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F84BA4054;
        Tue, 23 Aug 2022 16:25:16 +0000 (GMT)
Received: from [9.171.74.130] (unknown [9.171.74.130])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 16:25:16 +0000 (GMT)
Message-ID: <f7665657-83bb-511c-faf8-792dab3e9ab9@linux.ibm.com>
Date:   Tue, 23 Aug 2022 18:25:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v8 08/12] s390x/cpu_topology: implementing numa for the
 s390x topology
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
 <20220620140352.39398-9-pmorel@linux.ibm.com>
 <3a821cd1-b8a0-e737-5279-8ef55e58a77f@linux.ibm.com>
 <b1e89718-232c-2b0b-2133-102ab7b4dad4@linux.ibm.com>
 <b30eb75a-5a0b-3428-b812-95a2884914e4@linux.ibm.com>
 <14afa5dc-80de-c5a2-b57d-867c692b29cf@linux.ibm.com>
 <e497396a-eadf-15ae-e11c-d6a2bbbff7c7@linux.ibm.com>
 <3b2f62a7-b526-adfd-e791-f2bc2cae3ccf@linux.ibm.com>
 <4d0d25e9-fedf-728c-12e9-70e4dc04d6b7@linux.ibm.com>
 <2c0b3926-482a-9c3f-1937-1be672ba7aeb@linux.ibm.com>
 <15df7e57-0126-850d-4ab6-309ec03a2130@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <15df7e57-0126-850d-4ab6-309ec03a2130@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: J5vGEJbFB68RPxx12ncJqECb1K66rYDM
X-Proofpoint-GUID: J8vZi60WXAThqKeQKVb2A4CcAG7tIyUH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_07,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 clxscore=1011 impostorscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/22/22 14:08, Janis Schoetterl-Glausch wrote:
> On 7/21/22 13:41, Pierre Morel wrote:
>>
>>
>> On 7/21/22 10:16, Janis Schoetterl-Glausch wrote:
>>> On 7/21/22 09:58, Pierre Morel wrote:
>>>>
>>>>
>>
>> ...snip...
>>
>>>>
>>>> You are right, numa is redundant for us as we specify the topology using the core-id.
>>>> The roadmap I would like to discuss is using a new:
>>>>
>>>> (qemu) cpu_move src dst
>>>>
>>>> where src is the current core-id and dst is the destination core-id.
>>>>
>>>> I am aware that there are deep implication on current cpu code but I do not think it is not possible.
>>>> If it is unpossible then we would need a new argument to the device_add for cpu to define the "effective_core_id"
>>>> But we will still need the new hmp command to update the topology.
> 
> Why the requirement for a hmp command specifically? Would qom-set on a cpu property work?


We will work on modifying the topology in another series.
Let's discuss this at that moment.

>>>>
>>> I don't think core-id is the right one, that's the guest visible CPU address, isn't it?
>>
>> Yes, the topology is the one seen by the guest.
>>
>>> Although it seems badly named then, since multiple threads are part of the same core (ok, we don't support threads).
>>
>> I guess that threads will always move with the core or... we do not support threads.
>>
>>> Instead socket-id, book-id could be changed dynamically instead of being computed from the core-id.
>>>
>>
>> What becomes of the core-id ?
> 
> It would stay the same. It has to, right? Can't change the address as reported by STAP.
> I would just be completely independent of the other ids.
> 

We will work on modifying the topology in another series.

-- 
Pierre Morel
IBM Lab Boeblingen
