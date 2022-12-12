Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6471649BC7
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 11:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbiLLKMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 05:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiLLKL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 05:11:27 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7BEEE13
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 02:10:28 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BC8KaxB024640;
        Mon, 12 Dec 2022 10:10:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lxLtjmrvAbbmAhNFMQykLPMrN+QULFSwJyNvCNlSIuY=;
 b=Y6+s8/fUGzKf5bN9D6g8BuZGoi1ngNGvoxMcuUUU/5P/yejj9IWUTNW7jz8NNGFZRzzJ
 9JkGWROLF5KTb+11gvk3i0XtpWo7rG5gYRlxqueb0C0Gc7eWCyjFgAr44RyAs/YOMctk
 6pW8GxFi4fZgGcxWKHpboAAAOY0PZmlACG4h7SkTuyuI0GlTcEtEHS5vRfZCqHru6eYt
 5IsCnQKnJzZCE5Fc2h3NyWAfx5JR3Mhd19I+ti2Oo/8/KjKmXQorjUWqfr/K8rvNT3Jg
 vqjps+Zkvxb8J/Thz5SDNp956lZ4VmlVCbFNYRY7ADPG01l241WTE0u8qo/ZCBQKOYmM eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3md3ynw8am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 10:10:16 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BC9ePjG014771;
        Mon, 12 Dec 2022 10:10:16 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3md3ynw89y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 10:10:16 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BC4Bt5J015546;
        Mon, 12 Dec 2022 10:10:14 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3mchr5srgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 10:10:14 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BCAAAqr22348080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 10:10:10 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F254D20075;
        Mon, 12 Dec 2022 10:10:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72F4D20076;
        Mon, 12 Dec 2022 10:10:08 +0000 (GMT)
Received: from [9.171.10.222] (unknown [9.171.10.222])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 12 Dec 2022 10:10:08 +0000 (GMT)
Message-ID: <90514038-f10c-33e7-3600-e3131138a44d@linux.ibm.com>
Date:   Mon, 12 Dec 2022 11:10:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v13 0/7] s390x: CPU Topology
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
 <8c0777d2-7b70-51ce-e64a-6aff5bdea8ae@redhat.com>
 <60f006f4-d29e-320a-d656-600b2fd4a11a@linux.ibm.com>
 <864cc127-2dbd-3792-8851-937ef4689503@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <864cc127-2dbd-3792-8851-937ef4689503@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 93y19EgCRjDDbrcCqqO7S42pYRllNucu
X-Proofpoint-ORIG-GUID: lQosFleFsNh1dqakp7j29M05ub0nX8QF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212120088
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/12/22 10:07, Thomas Huth wrote:
> On 12/12/2022 09.51, Pierre Morel wrote:
>>
>>
>> On 12/9/22 14:32, Thomas Huth wrote:
>>> On 08/12/2022 10.44, Pierre Morel wrote:
>>>> Hi,
>>>>
>>>> Implementation discussions
>>>> ==========================
>>>>
>>>> CPU models
>>>> ----------
>>>>
>>>> Since the S390_FEAT_CONFIGURATION_TOPOLOGY is already in the CPU model
>>>> for old QEMU we could not activate it as usual from KVM but needed
>>>> a KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>>> Checking and enabling this capability enables
>>>> S390_FEAT_CONFIGURATION_TOPOLOGY.
>>>>
>>>> Migration
>>>> ---------
>>>>
>>>> Once the S390_FEAT_CONFIGURATION_TOPOLOGY is enabled in the source
>>>> host the STFL(11) is provided to the guest.
>>>> Since the feature is already in the CPU model of older QEMU,
>>>> a migration from a new QEMU enabling the topology to an old QEMU
>>>> will keep STFL(11) enabled making the guest get an exception for
>>>> illegal operation as soon as it uses the PTF instruction.
>>>
>>> I now thought that it is not possible to enable "ctop" on older QEMUs 
>>> since the don't enable the KVM capability? ... or is it still somehow 
>>> possible? What did I miss?
>>>
>>>   Thomas
>>
>> Enabling ctop with ctop=on on old QEMU is not possible, this is right.
>> But, if STFL(11) is enable in the source KVM by a new QEMU, I can see 
>> that even with -ctop=off the STFL(11) is migrated to the destination.
> 
> Is this with the "host" CPU model or another one? And did you explicitly 
> specify "ctop=off" at the command line, or are you just using the 
> default setting by not specifying it?

With explicit cpumodel and using ctop=off like in

sudo /usr/local/bin/qemu-system-s390x_master \
      -m 512M \
      -enable-kvm -smp 4,sockets=4,cores=2,maxcpus=8 \
      -cpu z14,ctop=off \
      -machine s390-ccw-virtio-7.2,accel=kvm \
      ...


regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
