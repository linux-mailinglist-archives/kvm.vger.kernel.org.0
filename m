Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8B1689C0B
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 15:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbjBCOkx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 09:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjBCOkv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 09:40:51 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CC754558
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 06:40:51 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 313Dg1IA031324;
        Fri, 3 Feb 2023 14:40:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rR5EitcEJ67N1aIWfIHundVXybReQBBNv8h3jMMJ+xc=;
 b=FAhUrBZ65Lik3h7HfSfB4d+FuWkNI9vL549t/VACN/RirGFwbsnwi1nHlvFPXVSdt/jF
 +oZPbRVBxEfwtVbi1YtkoBWLNrYaM+Sw6nkdB08hhM3nAbo5dwxu3gUC2qg0H3GLmwkS
 OPfBsH/9N/0SZOiKDtH45Dhvx5M1oCRwS90MZuq0oVWMgCrtFCZuWYnCrrmeKhg+PCSO
 JtmB0b077/vn8Iw2kh865YYfbDHW7/y+GE+3C7Jrmr97/dYbULdFqvYCVGySOTK2sGgS
 0nfWvPMYm3VVlvUoLZKOqXC02RPgcTAq9KAMbSKKV8gLu+iq0B4/RZc/dnEpxJ0bvOcr yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nh3cm1np4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 14:40:38 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 313EABq7001348;
        Fri, 3 Feb 2023 14:40:37 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nh3cm1nmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 14:40:37 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3137p9id014675;
        Fri, 3 Feb 2023 14:40:35 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ncvttyh63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 14:40:34 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 313EeVAg47972738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Feb 2023 14:40:31 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 650AE20043;
        Fri,  3 Feb 2023 14:40:31 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EADB120040;
        Fri,  3 Feb 2023 14:40:29 +0000 (GMT)
Received: from [9.171.57.15] (unknown [9.171.57.15])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  3 Feb 2023 14:40:29 +0000 (GMT)
Message-ID: <5ad1cc6a-5d2d-57fc-f082-ec6f843c877e@linux.ibm.com>
Date:   Fri, 3 Feb 2023 15:40:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v15 02/11] s390x/cpu topology: add topology entries on CPU
 hotplug
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
 <20230201132051.126868-3-pmorel@linux.ibm.com>
 <6345131acfb04e353ca2eba620bf27609bfeb535.camel@linux.ibm.com>
 <c2c502ca-2a1f-d29f-8931-4be7389557ee@linux.ibm.com>
 <45bb29fcb3629a857577e50378adab1f5598644e.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <45bb29fcb3629a857577e50378adab1f5598644e.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: huOAq1nggo9el_54z4_vk1_UfzsjKLTZ
X-Proofpoint-GUID: sYSBRxqBGkhzGE9EuRKm2XbvViLrcReb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-03_13,2023-02-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 phishscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 malwarescore=0
 impostorscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302030134
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/3/23 14:22, Nina Schoetterl-Glausch wrote:
> On Fri, 2023-02-03 at 10:21 +0100, Pierre Morel wrote:
>>
>> On 2/2/23 17:42, Nina Schoetterl-Glausch wrote:
>>> On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
>>>> The topology information are attributes of the CPU and are
>>>> specified during the CPU device creation.
>>>>
>>>> On hot plug we:
>>>> - calculate the default values for the topology for drawers,
>>>>     books and sockets in the case they are not specified.
>>>> - verify the CPU attributes
>>>> - check that we have still room on the desired socket
>>>>
>>>> The possibility to insert a CPU in a mask is dependent on the
>>>> number of cores allowed in a socket, a book or a drawer, the
>>>> checking is done during the hot plug of the CPU to have an
>>>> immediate answer.
>>>>
>>>> If the complete topology is not specified, the core is added
>>>> in the physical topology based on its core ID and it gets
>>>> defaults values for the modifier attributes.
>>>>
>>>> This way, starting QEMU without specifying the topology can
>>>> still get some advantage of the CPU topology.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>    include/hw/s390x/cpu-topology.h |  24 +++
>>>>    hw/s390x/cpu-topology.c         | 256 ++++++++++++++++++++++++++++++++
>>>>    hw/s390x/s390-virtio-ccw.c      |  23 ++-
>>>>    hw/s390x/meson.build            |   1 +
>>>>    4 files changed, 302 insertions(+), 2 deletions(-)
>>>>    create mode 100644 hw/s390x/cpu-topology.c
>>>>
> [...]
>>>
>>>> +/**
>>>> + * s390_set_core_in_socket:
>>>> + * @cpu: the new S390CPU to insert in the topology structure
>>>> + * @drawer_id: new drawer_id
>>>> + * @book_id: new book_id
>>>> + * @socket_id: new socket_id
>>>> + * @creation: if is true the CPU is a new CPU and there is no old socket
>>>> + *            to handle.
>>>> + *            if is false, this is a moving the CPU and old socket count
>>>> + *            must be decremented.
>>>> + * @errp: the error pointer
>>>> + *
>>>> + */
>>>> +static void s390_set_core_in_socket(S390CPU *cpu, int drawer_id, int book_id,
>>>
>>> Maybe name it s390_(topology_)?add_core_to_socket instead.
>>
>> OK, it is better
>>
>>>
>>>> +                                    int socket_id, bool creation, Error **errp)
>>>> +{
>>>> +    int old_socket = s390_socket_nb(cpu);
>>>> +    int new_socket;
>>>> +
>>>> +    if (creation) {
>>>> +        new_socket = old_socket;
>>>> +    } else {
>>>
>>> You need parentheses here.
>>>
>>>> +        new_socket = drawer_id * s390_topology.smp->books +
>>>                          (
>>>> +                     book_id * s390_topology.smp->sockets +
>>>                                  )
>>>> +                     socket_id;
>>
>> If you prefer I can us parentheses.
> 
> It's necessary, otherwise the multiplication of book_id and smp->sockets takes precedence.
>>
>>

Right, I did not understand where you want the parenthesis.
I think you mean:

         new_socket = (drawer_id * s390_topology.smp->books + book_id) *
                      s390_topology.smp->sockets + socket_id;

thanks,

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
