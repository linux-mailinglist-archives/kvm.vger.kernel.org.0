Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4051C672450
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 17:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjARQ6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 11:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjARQ6Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 11:58:16 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A574458BD
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:58:13 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IGbAWN014066;
        Wed, 18 Jan 2023 16:57:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dzlSEeAfY8NNSGB/eV3aJBRFsate//OGlkMsXlmrM9I=;
 b=PhTAS/6wh/R+L4/1czy077Y0HxqRg571//xI/XQCRkWFvL0k+3vgPYvBOP5UtHYuaIg/
 ebvmLDH32+86AvTmh2kZPRGfvtXXZdERMR51syiBzNEyYtB6ckYMQmvKpmXuZmLH7/M3
 4Rq5EoVEqcCtJjcyVnagd/XMOtfVM8FNVD1jdRqLce173zJDpLX/59990HO10A/k+fsg
 f3W2scypH3lm0qyVSPC8+moZRGJAi8YIQ3jO9QddHGm85s57mpeAQPxGY05WFQONTEeb
 ErzJ4SwsI8SzbSXxs1MSCLhGor2c519ax2+D1Wqa7EXCWtqtxHPS0CLECHAF4KVKk54y oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6hvn4u7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 16:57:30 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30IGu76p003433;
        Wed, 18 Jan 2023 16:57:29 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6hvn4u6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 16:57:29 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30IA9wbe028466;
        Wed, 18 Jan 2023 16:57:26 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3n3m16m2gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 16:57:26 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IGvMY323724426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 16:57:23 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB13B20079;
        Wed, 18 Jan 2023 16:57:22 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 710C82007A;
        Wed, 18 Jan 2023 16:57:21 +0000 (GMT)
Received: from [9.179.13.15] (unknown [9.179.13.15])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 16:57:21 +0000 (GMT)
Message-ID: <a220ead7-c3ff-3cf2-bbde-8b5be30b9ac7@linux.ibm.com>
Date:   Wed, 18 Jan 2023 17:57:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 09/11] qapi/s390/cpu topology: monitor query topology
 information
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-10-pmorel@linux.ibm.com> <Y7/4rm9JYihUpLS1@redhat.com>
 <d97d0a6a-a87e-e0d2-5d95-0645c09d9730@linux.ibm.com>
 <Y8gZg/+k04+LPEd4@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <Y8gZg/+k04+LPEd4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YeDcEPAkzEWX6iLokrQ89QYO4u192-6p
X-Proofpoint-ORIG-GUID: 2wYUVzHQPOIM64-ma2ToNQaZQYSB3o3l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180138
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/18/23 17:08, Daniel P. Berrangé wrote:
> On Wed, Jan 18, 2023 at 04:58:05PM +0100, Pierre Morel wrote:
>>
>>
>> On 1/12/23 13:10, Daniel P. Berrangé wrote:
>>> On Thu, Jan 05, 2023 at 03:53:11PM +0100, Pierre Morel wrote:
>>>> Reporting the current topology informations to the admin through
>>>> the QEMU monitor.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>    qapi/machine-target.json | 66 ++++++++++++++++++++++++++++++++++
>>>>    include/monitor/hmp.h    |  1 +
>>>>    hw/s390x/cpu-topology.c  | 76 ++++++++++++++++++++++++++++++++++++++++
>>>>    hmp-commands-info.hx     | 16 +++++++++
>>>>    4 files changed, 159 insertions(+)
>>>>
>>>> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
>>>> index 75b0aa254d..927618a78f 100644
>>>> --- a/qapi/machine-target.json
>>>> +++ b/qapi/machine-target.json
>>>> @@ -371,3 +371,69 @@
>>>>      },
>>>>      'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>>>>    }
>>>> +
>>>> +##
>>>> +# @S390CpuTopology:
>>>> +#
>>>> +# CPU Topology information
>>>> +#
>>>> +# @drawer: the destination drawer where to move the vCPU
>>>> +#
>>>> +# @book: the destination book where to move the vCPU
>>>> +#
>>>> +# @socket: the destination socket where to move the vCPU
>>>> +#
>>>> +# @polarity: optional polarity, default is last polarity set by the guest
>>>> +#
>>>> +# @dedicated: optional, if the vCPU is dedicated to a real CPU
>>>> +#
>>>> +# @origin: offset of the first bit of the core mask
>>>> +#
>>>> +# @mask: mask of the cores sharing the same topology
>>>> +#
>>>> +# Since: 8.0
>>>> +##
>>>> +{ 'struct': 'S390CpuTopology',
>>>> +  'data': {
>>>> +      'drawer': 'int',
>>>> +      'book': 'int',
>>>> +      'socket': 'int',
>>>> +      'polarity': 'int',
>>>> +      'dedicated': 'bool',
>>>> +      'origin': 'int',
>>>> +      'mask': 'str'
>>>> +  },
>>>> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>>>> +}
>>>> +
>>>> +##
>>>> +# @query-topology:
>>>> +#
>>>> +# Return information about CPU Topology
>>>> +#
>>>> +# Returns a @CpuTopology instance describing the CPU Toplogy
>>>> +# being currently used by QEMU.
>>>> +#
>>>> +# Since: 8.0
>>>> +#
>>>> +# Example:
>>>> +#
>>>> +# -> { "execute": "cpu-topology" }
>>>> +# <- {"return": [
>>>> +#     {
>>>> +#         "drawer": 0,
>>>> +#         "book": 0,
>>>> +#         "socket": 0,
>>>> +#         "polarity": 0,
>>>> +#         "dedicated": true,
>>>> +#         "origin": 0,
>>>> +#         "mask": 0xc000000000000000,
>>>> +#     },
>>>> +#    ]
>>>> +#   }
>>>> +#
>>>> +##
>>>> +{ 'command': 'query-topology',
>>>> +  'returns': ['S390CpuTopology'],
>>>> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>>>> +}
>>>
>>> IIUC, you're using @mask as a way to compress the array returned
>>> from query-topology, so that it doesn't have any repeated elements
>>> with the same data. I guess I can understand that desire when the
>>> core count can get very large, this can have a large saving.
>>>
>>> The downside of using @mask, is that now you require the caller
>>> to parse the string to turn it into a bitmask and expand the
>>> data. Generally this is considered a bit of an anti-pattern in
>>> QAPI design - we don't want callers to have to further parse
>>> the data to extract information, we want to directly consumable
>>> from the parsed JSON doc.
>>
>> Not exactly, the mask is computed by the firmware to provide it to the guest
>> and is already available when querying the topology.
>> But I understand that for the QAPI user the mask is not the right solution,
>> standard coma separated values like (1,3,5,7-11) would be much easier to
>> read.
> 
> That is still inventing a second level data format for an attribute
> that needs to be parsed, and its arguably more complex.

OK, I think I am too focused on my vision of the topology.
I add the new attributes to the query-cpus-fast

> 
>>> We already have 'query-cpus-fast' wich returns one entry for
>>> each CPU. In fact why do we need to add query-topology at all.
>>> Can't we just add book-id / drawer-id / polarity / dedicated
>>> to the query-cpus-fast result ?
>>
>> Yes we can, I think we should, however when there are a lot of CPU it will
>> be complicated to find the CPU sharing the same socket and the same
>> attributes.
> 
> It shouldn't be that hard to populate a hash table, using the set of
> socket + attributes you want as the hash key.

It is not a problem.

> 
>> I think having both would be interesting.
> 
> IMHO this is undesirable if we can make query-cpus-fast report
> sufficient information, as it gives a maint burden to QEMU and
> is confusing to consumers to QEMU to have multiple commands with
> largely overlapping functionality.

right.

Thanks Daniel.

Regards,
Pierre

> 
> 
> With regards,
> Daniel

-- 
Pierre Morel
IBM Lab Boeblingen
