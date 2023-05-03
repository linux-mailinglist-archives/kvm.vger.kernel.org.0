Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081DB6F5842
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 14:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjECMyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 08:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjECMy0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 08:54:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5E85FC6;
        Wed,  3 May 2023 05:54:17 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 343CsAxw032116;
        Wed, 3 May 2023 12:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OdSBNL0rhlJgQI1Pz50BBgSkLWOJFO6nfzapJux5ses=;
 b=ZHun1Z/9gby50irMk4jF/AGrFVdvvzDoRDmNF14wBMp0UNqv7ZRaJMGZlCphm/lEyPZk
 CYi/WUXhR2aVpzKezAi7T6heNcuYbNXje4YKie+fguAPdSUlJHqdeA7UIk4LiNit4JFY
 yTGOAmP1ZR56SKcJ5/SRJGT2enbf8uFwBtjMNrWUXqCnUS80rbasO7ymk7sSFkH4i1rG
 E45Q9c+bx0Fe/AUmDYA3z8nhVn2JaNZ2nRZ3BGWj2RtmQNQqn/z/yY8XrpjfMBuNhOLU
 vtqmhptVfIaIWZcCiePQseSNbIQ0Ss9+KP5haCz+LXTunLHtofhONYXvpe2EvQnzKSMb 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbqmwgwv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 12:54:16 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 343CrL6g029005;
        Wed, 3 May 2023 12:53:26 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbqmwgw0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 12:53:25 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3434TI1l014099;
        Wed, 3 May 2023 12:52:24 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3q8tv6sue3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 12:52:24 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 343CqKct15139226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 May 2023 12:52:20 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFAB92004B;
        Wed,  3 May 2023 12:52:20 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AD7820040;
        Wed,  3 May 2023 12:52:20 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed,  3 May 2023 12:52:20 +0000 (GMT)
Message-ID: <af6e9b44-ac14-904e-6d37-043a5c8a9357@linux.ibm.com>
Date:   Wed, 3 May 2023 14:52:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v8 2/2] s390x: topology: Checking
 Configuration Topology Information
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
References: <20230426083426.6806-1-pmorel@linux.ibm.com>
 <20230426083426.6806-3-pmorel@linux.ibm.com>
 <168258524358.99032.14388431972069131423@t14-nrb>
 <25a9c3d6-43be-6a08-a32e-5abc520e8c62@linux.ibm.com>
 <168266833708.15302.621201335459420614@t14-nrb>
 <8122e0de-7cbb-83f2-4c3a-7a50f0d5b205@linux.ibm.com>
 <168311498507.14421.10981394117035080962@t14-nrb>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <168311498507.14421.10981394117035080962@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: H7nqEhuvLLrAa-QgSU0zky6FAZOWS_L-
X-Proofpoint-ORIG-GUID: nZ9UcLINrI82faCR9rB_Kmd7oFr8xirg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_08,2023-05-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 suspectscore=0 phishscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305030106
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/3/23 13:56, Nico Boehr wrote:
> Quoting Pierre Morel (2023-04-28 15:10:07)
>> On 4/28/23 09:52, Nico Boehr wrote:
>>> Quoting Pierre Morel (2023-04-27 16:50:16)
>>> [...]
>>>>>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>>>>>> index fc3666b..375e6ce 100644
>>>>>> --- a/s390x/unittests.cfg
>>>>>> +++ b/s390x/unittests.cfg
>>>>>> @@ -221,3 +221,6 @@ file = ex.elf
>>>>>>     
>>>>>>     [topology]
>>>>>>     file = topology.elf
>>>>>> +# 3 CPUs on socket 0 with different CPU TLE (standard, dedicated, origin)
>>>>>> +# 1 CPU on socket 2
>>>>>> +extra_params = -smp 1,drawers=3,books=3,sockets=4,cores=4,maxcpus=144 -cpu z14,ctop=on -device z14-s390x-cpu,core-id=1,entitlement=low -device z14-s390x-cpu,core-id=2,dedicated=on -device z14-s390x-cpu,core-id=10 -device z14-s390x-cpu,core-id=20 -device z14-s390x-cpu,core-id=130,socket-id=0,book-id=0,drawer-id=0 -append '-drawers 3 -books 3 -sockets 4 -cores 4'
>>>>> If I got the command line right, all CPUs are on the same drawer with this command line, aren't they? If so, does it make sense to run with different combinations, i.e. CPUs on different drawers, books etc?
>>>> OK, I will add some CPU on different drawers and books.
>>> just to clarify: What I meant is adding an *additional* entry to unittests.cfg. Does it make sense in your opinion? I just want more coverage for different scenarios we may have.
>> Ah OK, yes even better.
>>
>> In this test I chose the values randomly, I can add 2 other tests like
>>
>> - once with the maximum of CPUs like:
>>
>> [topology-2]
>> file = topology.elf
>> extra_params = -smp drawers=3,books=4,sockets=5,cores=4,maxcpus=240
>> -append '-drawers 3 -books 4 -sockets 5 -cores 4'
>>
>>
>> or having 8 different TLE on the same socket
>>
>> [topology-2]
>>
>> file = topology.elf
>> extra_params = -smp 1,drawers=2,books=2,sockets=2,cores=30,maxcpus=240
>> -append '-drawers 2 -books 2 -sockets 2 -cores 30' -cpu z14,ctop=on
>> -device
>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=2,entitlement=low
>> -device
>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=3,entitlement=medium
>> -device
>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=4,entitlement=high
>> -device
>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=5,entitlement=high,dedicated=on
>> -device
>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=65,entitlement=low
>> -device
>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=66,entitlement=medium
>> -device
>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=67,entitlement=high
>> -device
>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=68,entitlement=high,dedicated=on
>>
>>
>> What do you think is the best ?
> I think both do make sense, since they cover differenct scenarios, don't they?


Yes,

also

[topology-2]
file = topology.elf
extra_params = -smp books=2,sockets=31,cores=4,maxcpus=248
-append '-drawers 1 -books 2 -sockets 31 -cores 4'

Could make sense too, it is the way I found the sclp problem, but it will fail until sclp is fixed using facility 140.




