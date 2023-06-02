Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A747A71FE7C
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 12:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbjFBKCh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 06:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234402AbjFBKCf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 06:02:35 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50B4C0;
        Fri,  2 Jun 2023 03:02:34 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3529ricx019690;
        Fri, 2 Jun 2023 10:02:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bcI9EYoXOfKLJNiGzrA+vY8Ir7lRw8JYLS6qmEkeLdc=;
 b=Tmj8jqNvo+Ad3lYh0Gtc4uGYxyKZmh8ymGtlXPVp9UWt8Zjd1hlnKcpz3x1n6ZH7hk6F
 Lg6CdUFoKrqQPnIjPk3XBg5DIq7zUk0W4Rtakfexyok8XFTcBiMQyfFGCfw6dHGpnt5U
 Xxdh4gJ906mqXftwbcSxaLcCXNBODrju6Dfgaj6kajPAHd35EW9rkMaXNFsGZbzIVNvr
 dJAUTjUNplcmGjr3a/zFRlGVnXl8RIpk8SqycRnWAHJs18xZysJbipmwm8NOkO60Z335
 kd4fMgJB8CTcpEJVua+LMGVnA9KMuuNLLqCGTUJVlqa4ujX4nXS1SU3botW0+hvNsC3P Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qye6r05qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 10:02:33 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3529rmxP020312;
        Fri, 2 Jun 2023 10:02:33 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qye6r05pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 10:02:33 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3525RQl1008675;
        Fri, 2 Jun 2023 10:02:31 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3qu94eafg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 10:02:31 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 352A2Rcs46924206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Jun 2023 10:02:27 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 834C42006E;
        Fri,  2 Jun 2023 10:02:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B08720065;
        Fri,  2 Jun 2023 10:02:27 +0000 (GMT)
Received: from [9.179.1.27] (unknown [9.179.1.27])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri,  2 Jun 2023 10:02:26 +0000 (GMT)
Message-ID: <9df570c5-ed72-6803-7686-6649f7194f35@linux.ibm.com>
Date:   Fri, 2 Jun 2023 12:02:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v9 2/2] s390x: topology: Checking
 Configuration Topology Information
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     kvm@vger.kernel.org, imbrenda@linux.ibm.com, david@redhat.com,
        nsg@linux.ibm.com
References: <20230519112236.14332-1-pmorel@linux.ibm.com>
 <20230519112236.14332-3-pmorel@linux.ibm.com>
 <fa415627-bfff-cc18-af94-cf55632973d5@linux.ibm.com>
 <168569490681.252746.1049350277526238686@t14-nrb>
 <308278c8-aae2-52ba-15f0-7dffa312b200@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <308278c8-aae2-52ba-15f0-7dffa312b200@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6e0TEJg7bpuHcokON_VK1hql9dBNKs1P
X-Proofpoint-ORIG-GUID: muPuQmrgTWKiC-TuJS0srrYtJJRQwiGw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_06,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306020071
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/2/23 11:20, Thomas Huth wrote:
> On 02/06/2023 10.35, Nico Boehr wrote:
>> Quoting Janosch Frank (2023-06-01 11:38:37)
>> [...]
>>>>    [topology]
>>>>    file = topology.elf
>>>> +# 3 CPUs on socket 0 with different CPU TLE (standard, dedicated, 
>>>> origin)
>>>> +# 1 CPU on socket 2
>>>> +extra_params = -smp 
>>>> 1,drawers=3,books=3,sockets=4,cores=4,maxcpus=144 -cpu z14,ctop=on 
>>>> -device z14-s390x-cpu,core-id=1,entitlement=low -device 
>>>> z14-s390x-cpu,core-id=2,dedicated=on -device 
>>>> z14-s390x-cpu,core-id=10 -device z14-s390x-cpu,core-id=20 -device 
>>>> z14-s390x-cpu,core-id=130,socket-id=0,book-id=0,drawer-id=0 -append 
>>>> '-drawers 3 -books 3 -sockets 4 -cores 4'
>>>> +
>>>> +[topology-2]
>>>> +file = topology.elf
>>>> +extra_params = -smp 
>>>> 1,drawers=2,books=2,sockets=2,cores=30,maxcpus=240  -append 
>>>> '-drawers 2 -books 2 -sockets 2 -cores 30' -cpu z14,ctop=on -device 
>>>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=2,entitlement=low 
>>>> -device 
>>>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=3,entitlement=medium 
>>>> -device 
>>>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=4,entitlement=high 
>>>> -device 
>>>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=5,entitlement=high,dedicated=on 
>>>> -device 
>>>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=65,entitlement=low 
>>>> -device 
>>>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=66,entitlement=medium 
>>>> -device 
>>>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=67,entitlement=high 
>>>> -device 
>>>> z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=68,entitlement=high,dedicated=on
>>>
>>> Pardon my ignorance but I see z14 in there, will this work if we run on
>>> a z13?
>>
>> It causes a skip, I reproduced this on a z14 by changing to z15:
>> SKIP topology (qemu-system-s390x: unable to find CPU model 'z15')
>>
>> If we can make this more generic so the tests run on older machines 
>> it would be
>> good, but if we can't it wouldn't break (i.e. FAIL) on older machines.
>
> Can't we simply use "-cpu max,ctop=on" ?
>
>  Thomas
>
Yes we can thanks.

Pierre

