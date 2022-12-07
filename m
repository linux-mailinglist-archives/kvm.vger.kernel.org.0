Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74958645959
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 12:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiLGLyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 06:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiLGLxv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 06:53:51 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAC2192B3
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 03:52:47 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7BV5i7032642;
        Wed, 7 Dec 2022 11:52:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YzLpQcRCEUpJoSKEQfOZPHKHCPz2cbT9RjlIODsYn/8=;
 b=Kgt8dRWGj9qwenb+ODgYRvBkpTrCcTXUxCjn6K6vGChdKpNZ5PcwS6yZtHXDdg/EFtTi
 GbckPbsaegYQNDWZo4MyJrftEcqulh/mvVMKeB79U8w9kWjnjVzDw39pQv4/0484o8yK
 lf8oOAeJbTotcCLkSuaQiKBMnd3exB6hkHS1L4p1gt+7IqzEAcr3tVxKR+rkA4p7vDN/
 yAI/WkOnn/1KgJXEJ6ZXDU3iVeb/SdQ8jSZfUV7H2u3DbtKyEaL9PMSQFFXWbiL0NQgF
 XQpV74jvjQ33/ypcxaaQWOk1QIP0//bMOYzpXoeioh/LCcnenhqiJVNKvpJAC0N6FQtS IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mat1c0f3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 11:52:30 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B7BjK2U029226;
        Wed, 7 Dec 2022 11:52:29 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mat1c0f31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 11:52:29 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7BjguX010845;
        Wed, 7 Dec 2022 11:52:27 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3m9kvbavu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 11:52:27 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B7BqMJA42008860
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Dec 2022 11:52:23 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72BA12006E;
        Wed,  7 Dec 2022 11:52:22 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 561E82009F;
        Wed,  7 Dec 2022 11:52:21 +0000 (GMT)
Received: from [9.171.6.120] (unknown [9.171.6.120])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  7 Dec 2022 11:52:21 +0000 (GMT)
Message-ID: <a7fcbcce-91db-5097-a3f6-ce6b29ae9f6a@linux.ibm.com>
Date:   Wed, 7 Dec 2022 12:52:21 +0100
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
 <ffb9b474-e29d-c790-611e-549846b939e4@linux.ibm.com>
 <34e774fc372e41f352ccf03761a78eff22728f89.camel@linux.ibm.com>
 <1c63d7e3-008b-5347-02eb-538e091f3639@linux.ibm.com>
 <b0055a81c8266a77843eead531c0b188ceea0abf.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <b0055a81c8266a77843eead531c0b188ceea0abf.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xHqWnjxVAPK_Vyet3c5zmgrVREuIqDLh
X-Proofpoint-GUID: zOsXy4Egorv8BdWZ3mxdNNYAOYUJeNWh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_05,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 impostorscore=0 mlxscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212070099
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/7/22 12:38, Janis Schoetterl-Glausch wrote:
>   * On Wed, 2022-12-07 at 11:00 +0100, Pierre Morel wrote:
>>
>> On 12/6/22 22:06, Janis Schoetterl-Glausch wrote:
>>> On Tue, 2022-12-06 at 15:35 +0100, Pierre Morel wrote:
>>>>
>>>> On 12/6/22 14:35, Janis Schoetterl-Glausch wrote:
>>>>> On Tue, 2022-12-06 at 11:32 +0100, Pierre Morel wrote:
>>>>>>
>>>>>> On 12/6/22 10:31, Janis Schoetterl-Glausch wrote:
>>>>>>> On Tue, 2022-11-29 at 18:42 +0100, Pierre Morel wrote:
>>>>>>>> We will need a Topology device to transfer the topology
>>>>>>>> during migration and to implement machine reset.
>>>>>>>>
>>>>>>>> The device creation is fenced by s390_has_topology().
>>>>>>>>
>>>>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>>>>> ---
>>>>>>>>   include/hw/s390x/cpu-topology.h | 44 +++++++++++++++
>>>>>>>>   include/hw/s390x/s390-virtio-ccw.h | 1 +
>>>>>>>>   hw/s390x/cpu-topology.c | 87 ++++++++++++++++++++++++++++++
>>>>>>>>   hw/s390x/s390-virtio-ccw.c | 25 +++++++++
>>>>>>>>   hw/s390x/meson.build | 1 +
>>>>>>>>   5 files changed, 158 insertions(+)
>>>>>>>>   create mode 100644 include/hw/s390x/cpu-topology.h
>>>>>>>>   create mode 100644 hw/s390x/cpu-topology.c
>>>>>>>
> [...]
> 
>>>>>>>> + object_property_set_int(OBJECT(dev), "num-cores",
>>>>>>>> + machine->smp.cores * machine->smp.threads, errp);
>>>>>>>> + object_property_set_int(OBJECT(dev), "num-sockets",
>>>>>>>> + machine->smp.sockets, errp);
>>>>>>>> +
>>>>>>>> + sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), errp);
>>>>>>>
>>>>>>> I must admit that I haven't fully grokked qemu's memory management yet.
>>>>>>> Is the topology devices now owned by the sysbus?
>>>>>>
>>>>>> Yes it is so we see it on the qtree with its properties.
>>>>>>
>>>>>>
>>>>>>> If so, is it fine to have a pointer to it S390CcwMachineState?
>>>>>>
>>>>>> Why not?
>>>>>
>>>>> If it's owned by the sysbus and the object is not explicitly referenced
>>>>> for the pointer, it might be deallocated and then you'd have a dangling pointer.
>>>>
>>>> Why would it be deallocated ?
>>>
>>> That's beside the point, if you transfer ownership, you have no control over when
>>> the deallocation happens.
>>> It's going to be fine in practice, but I don't think you should rely on it.
>>> I think you could just do sysbus_realize instead of ..._and_unref,
>>> but like I said, I haven't fully understood qemu memory management.
>>> (It would also leak in a sense, but since the machine exists forever that should be fine)
>>
>> If I understand correctly:
>>
>> - qdev_new adds a reference count to the new created object, dev.
>>
>> - object_property_add_child adds a reference count to the child also
>> here the new created device dev so the ref count of dev is 2 .
>>
>> after the unref on dev, the ref count of dev get down to 1
>>
>> then it seems OK. Did I miss something?
> 
> The properties ref belongs to the property, if the property were removed,
> it would be unref'ed. There is no extra ref for the pointer in S390CcwMachineState.
> I'm coming from a clean code perspective, I don't think we'd run into this problem in practice.

OK, I understand, you are right.
My original code used object_resolve_path() to retrieve the object what 
made things cleaner I think.

For performance reason, Cedric proposed during the review of V10 to add 
the pointer to the machine state instead.

I must say that I am not very comfortable to argument on this.
@Cedric what do you think?


Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
