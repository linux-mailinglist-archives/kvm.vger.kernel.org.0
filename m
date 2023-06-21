Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D57D7385A6
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 15:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbjFUNtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 09:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjFUNtT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 09:49:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D564219B
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 06:49:17 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LDc1lf001525;
        Wed, 21 Jun 2023 13:49:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1KYgQ5nuJ7ikSIxJ0Sw+BcNWQZZUHOps7pSA7hMzbg4=;
 b=X4igH8Dz7gPT3zikcFlFvM1//5c8sSn0J1zdRYrk+sZdBWp+roE/DucPMoEe0ChecVZA
 0ZODtcb2+o1E2y72je8oEwTRUfiL4IUA6OA/7Re+yMyfywm2ugJOJebjg/gvcrvVoYxq
 Zq4iD3MANfBkx3XMFs2wcCPgTW3PB7P8Z9RKDPIGoKY3rQeDmOMlYXJm/Uv6WOIdxAls
 xcDXIyGPvoxQH7DGtVrrNjCC7O8JRBgyNL60Fl7Y0Jz4daSDpPrDIo6Ay4HmFHMtwxEQ
 Nr8KuL8NBJyYbAn9qdG8UvAvS80GFGplWMhubeMkYaKRIBj14rA8bmIJcJeMqMn6FLNI 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc0bg3cxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 13:48:59 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35LDcpnX005323;
        Wed, 21 Jun 2023 13:48:59 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc0bg3cwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 13:48:59 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35L3Agpe029539;
        Wed, 21 Jun 2023 13:48:56 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3r94f52smq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 13:48:56 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35LDmo3d41943450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jun 2023 13:48:50 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6794720043;
        Wed, 21 Jun 2023 13:48:50 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE99D20040;
        Wed, 21 Jun 2023 13:48:49 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 21 Jun 2023 13:48:49 +0000 (GMT)
Message-ID: <faf2d79d-a993-48a2-11cc-a229d0dbc17b@linux.ibm.com>
Date:   Wed, 21 Jun 2023 15:48:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v20 02/21] s390x/cpu topology: add topology entries on CPU
 hotplug
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
 <20230425161456.21031-3-pmorel@linux.ibm.com>
 <1a919123-f07b-572e-8a33-0e5f9a6ed75c@redhat.com>
 <e233756c-52f6-547c-4c06-708459a98075@linux.ibm.com>
 <0d983d5f-f511-8e8f-0762-99f83e41171f@redhat.com>
 <83be3f5a-0df4-0b7d-9be3-5bf9a30ab709@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <83be3f5a-0df4-0b7d-9be3-5bf9a30ab709@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LMWgfax_dC0_Y2j7YsmaENlpcMmNpU1R
X-Proofpoint-ORIG-GUID: WedStPnIEkKq_tmHLSn9YYwIQJPU7N7p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_08,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2306210114
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/3/23 12:23, Cédric Le Goater wrote:
> Hello,
>
> On 5/3/23 11:12, Thomas Huth wrote:
>> On 28/04/2023 14.35, Pierre Morel wrote:
>>>
>>> On 4/27/23 15:38, Thomas Huth wrote:
>>>> On 25/04/2023 18.14, Pierre Morel wrote:
>>>>> The topology information are attributes of the CPU and are
>>>>> specified during the CPU device creation.
>>>>>
>>>>> On hot plug we:
>>>>> - calculate the default values for the topology for drawers,
>>>>>    books and sockets in the case they are not specified.
>>>>> - verify the CPU attributes
>>>>> - check that we have still room on the desired socket
>>>>>
>>>>> The possibility to insert a CPU in a mask is dependent on the
>>>>> number of cores allowed in a socket, a book or a drawer, the
>>>>> checking is done during the hot plug of the CPU to have an
>>>>> immediate answer.
>>>>>
>>>>> If the complete topology is not specified, the core is added
>>>>> in the physical topology based on its core ID and it gets
>>>>> defaults values for the modifier attributes.
>>>>>
>>>>> This way, starting QEMU without specifying the topology can
>>>>> still get some advantage of the CPU topology.
>>>>>
>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>> ---
>>>> ...
>>>>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>>>>> new file mode 100644
>>>>> index 0000000000..471e0e7292
>>>>> --- /dev/null
>>>>> +++ b/hw/s390x/cpu-topology.c
>>>>> @@ -0,0 +1,259 @@
>>>>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>>>>> +/*
>>>>> + * CPU Topology
>>>>
>>>> Since you later introduce a file with almost the same name in the 
>>>> target/s390x/ folder, it would be fine to have some more 
>>>> explanation here what this file is all about (especially with 
>>>> regards to the other file in target/s390x/).
>>>
>>>
>>> I first did put the interceptions in target/s390/ then moved them in 
>>> target/s390x/kvm because it is KVM related then again only let STSI 
>>> interception.
>>>
>>> But to be honest I do not see any reason why not put everything in 
>>> hw/s390x/ if CPU topology is implemented for TCG I think the code 
>>> will call insert_stsi_15_1_x() too.
>>>
>>> no?
>>
>> Oh well, it's all so borderline ... whether you rather think of this 
>> as part of the CPU (like the STSI instruction) or rather part of the 
>> machine (drawers, books, ...).
>> I don't mind too much, as long as we don't have two files around with 
>> almost the same name (apart from "_" vs. "-"). So either keep the 
>> stsi part in target/s390x and use a better file name for that, or put 
>> everything together in one "cpu-topology.c" file.
>> Or what do others think about it?
>
> Would it make sense to have a target/s390x/stsi.c file with the stsi
> routines to be called from TCG insn helpers and from the KVM backend ?
> This suggestion is based on the services found in the ioinst.c file.
>
> So, target/s390x/kvm/cpu_topology.c would become target/s390x/stsi.c
> and stsi services would be moved there, if that makes sense.
>
> Or target/s390x/kvm/stsi.c to start with because services are only
> active for KVM targets.
>
>
> Looking at hw/s390x/meson.build :
>
>   s390x_ss.add(when: 'CONFIG_KVM', if_true: files(
>     'tod-kvm.c',
>     's390-skeys-kvm.c',
>     's390-stattrib-kvm.c',
>     'pv.c',
>     's390-pci-kvm.c',
>     'cpu-topology.c',
>   ))
>
> It seems cpu-topology.c should be named cpu-topology-kvm.c to follow
> the same convention.
>
> However, I don't see much reason for the KVM condition, apart from
> the new polarization definitions in machine-target.json which depend
> on KVM. cpu-topology.c could well be compiled without the KVM #ifdef,
> all seems in place to detect support at runtime.
>
> In this file, we find a s390_handle_ptf() which is called from
> kvm_handle_ptf() in target/s390x/kvm/kvm.c. Is it the right place for
> it ? Shouldn't we move the service under target/s390x/kvm/kvm.c ?
>
> Thanks,
>
> C.
>
>
Hello Cédric,

The reason to have the s390_handle_ptf() here is to be ready for TCG.

We have the choice to let the cpu-topology.c file inside the KVM list of 
meson.build until TCG provides the CPU_TOPOLOGY facility and then move 
it to the general list
or
to move it now to the general list inside meson.build and keep code that 
will only be useful when TCG provides the CPU_TOPOLOGY facility

The option taken here is to not let the code active if it is not in use.

Did I answered the question or forgot something?

Regards,

Pierre




