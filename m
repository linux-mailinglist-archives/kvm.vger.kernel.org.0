Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A284864BAEB
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 18:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbiLMRYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 12:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235691AbiLMRYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 12:24:32 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB670193D2
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 09:24:31 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDGmq3G021334;
        Tue, 13 Dec 2022 17:24:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=I5DsAHxySOFbQ6UPxtibjll6ymLMQNj7RXOMQ6BkILk=;
 b=EEeFDIdZTweZ3drVLbaZ6vjIVreE2ctOT1cgTArXoXuqJhlbDZpt49EFxWa1BP1e8nPe
 ooxqt3xpYxbuOJ4cuULuZxbxpNB3pCHtt102973cPeR8tZ7+b8uRShzdkEW62F78nBCR
 +A+WhhunAiQASALzM+ITG3cqlK5xxhQcApQNPdWJGldSPMRgJmv3+xmphIhpO9YdY8QJ
 f4yayZWdrwOBPbO2B/KdzfoKXRLQ2GapIhNhkrplN+a4AIvHTSVZvjdhdJcWRY6QtdVB
 UX0ce2R9wsowWPY1rHzVIVZlVQw9Iec7PE/WR+dPIN5jvWEMns2JK4wbfPJMTpzRwmOL Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mew8cguug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 17:24:18 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDH6n50035820;
        Tue, 13 Dec 2022 17:24:17 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mew8cguu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 17:24:17 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDH9naK030834;
        Tue, 13 Dec 2022 17:24:15 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3mchr5vgks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 17:24:15 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDHOCCJ21430696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 17:24:12 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08E1220043;
        Tue, 13 Dec 2022 17:24:12 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C279A20040;
        Tue, 13 Dec 2022 17:24:10 +0000 (GMT)
Received: from [9.171.23.219] (unknown [9.171.23.219])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 17:24:10 +0000 (GMT)
Message-ID: <5f609d94-52c5-7505-6bce-79103aa9a789@linux.ibm.com>
Date:   Tue, 13 Dec 2022 18:24:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v13 0/7] s390x: CPU Topology
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org, Halil Pasic <pasic@linux.ibm.com>
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
 <8c0777d2-7b70-51ce-e64a-6aff5bdea8ae@redhat.com>
 <60f006f4-d29e-320a-d656-600b2fd4a11a@linux.ibm.com>
 <864cc127-2dbd-3792-8851-937ef4689503@redhat.com>
 <90514038-f10c-33e7-3600-e3131138a44d@linux.ibm.com>
 <73238c6c-a9dc-9d18-8ffb-92c8a41922d3@redhat.com>
 <b36eef2e-92ed-a0ea-0728-4a5ea5bf25d9@de.ibm.com>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <b36eef2e-92ed-a0ea-0728-4a5ea5bf25d9@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6H_frAEGPgHXC45q2LJxb3S7_Rt4NcB_
X-Proofpoint-GUID: kySFxaaz2pjdDjxzffKADB-kNg2eK-WI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 spamscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212130151
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/13/22 14:41, Christian Borntraeger wrote:
> 
> 
> Am 12.12.22 um 11:17 schrieb Thomas Huth:
>> On 12/12/2022 11.10, Pierre Morel wrote:
>>>
>>>
>>> On 12/12/22 10:07, Thomas Huth wrote:
>>>> On 12/12/2022 09.51, Pierre Morel wrote:
>>>>>
>>>>>
>>>>> On 12/9/22 14:32, Thomas Huth wrote:
>>>>>> On 08/12/2022 10.44, Pierre Morel wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> Implementation discussions
>>>>>>> ==========================
>>>>>>>
>>>>>>> CPU models
>>>>>>> ----------
>>>>>>>
>>>>>>> Since the S390_FEAT_CONFIGURATION_TOPOLOGY is already in the CPU 
>>>>>>> model
>>>>>>> for old QEMU we could not activate it as usual from KVM but needed
>>>>>>> a KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>>>>>> Checking and enabling this capability enables
>>>>>>> S390_FEAT_CONFIGURATION_TOPOLOGY.
>>>>>>>
>>>>>>> Migration
>>>>>>> ---------
>>>>>>>
>>>>>>> Once the S390_FEAT_CONFIGURATION_TOPOLOGY is enabled in the source
>>>>>>> host the STFL(11) is provided to the guest.
>>>>>>> Since the feature is already in the CPU model of older QEMU,
>>>>>>> a migration from a new QEMU enabling the topology to an old QEMU
>>>>>>> will keep STFL(11) enabled making the guest get an exception for
>>>>>>> illegal operation as soon as it uses the PTF instruction.
>>>>>>
>>>>>> I now thought that it is not possible to enable "ctop" on older 
>>>>>> QEMUs since the don't enable the KVM capability? ... or is it 
>>>>>> still somehow possible? What did I miss?
>>>>>>
>>>>>>   Thomas
>>>>>
>>>>> Enabling ctop with ctop=on on old QEMU is not possible, this is right.
>>>>> But, if STFL(11) is enable in the source KVM by a new QEMU, I can 
>>>>> see that even with -ctop=off the STFL(11) is migrated to the 
>>>>> destination.
> 
> This does not make sense. the cpu model and stfle values are not 
> migrated. This is re-created during startup depending on the command 
> line parameters of -cpu.
> Thats why source and host have the same command lines for -cpu. And 
> STFLE.11 must not be set on the SOURCE of ctop is off.

OK, so it is a feature

> 
> 
>>>>
>>>> Is this with the "host" CPU model or another one? And did you 
>>>> explicitly specify "ctop=off" at the command line, or are you just 
>>>> using the default setting by not specifying it?
>>>
>>> With explicit cpumodel and using ctop=off like in
>>>
>>> sudo /usr/local/bin/qemu-system-s390x_master \
>>>       -m 512M \
>>>       -enable-kvm -smp 4,sockets=4,cores=2,maxcpus=8 \
>>>       -cpu z14,ctop=off \
>>>       -machine s390-ccw-virtio-7.2,accel=kvm \
>>>       ...
>>
>> Ok ... that sounds like a bug somewhere in your patches or in the 
>> kernel code ... the guest should never see STFL bit 11 if ctop=off, 
>> should it?
> 
> Correct. If ctop=off then QEMU should disable STFLE.11 for the CPU model.

Sorry but not completely correct in the case of migration.

After a migration if the source host specifies ctop=on and target host 
specifies ctop=off it does see the STFL bit 11.

The admin should not, but can, specify ctop=off on target if the source 
set ctop=on. Then the target will start and run in a degraded mode.

Admin should specify the same flags on both ends, as you said above the 
STFL bits are not migrated and target QEMU can not verify what the 
original flags were.

However, isn't it a bug?
Is there a reason to not prevent QEMU to start with a wrong cpu model 
like specifying different flags on both ends or even different cpu?

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
