Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265DC71FE8C
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 12:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbjFBKHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 06:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234996AbjFBKHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 06:07:47 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3718C196;
        Fri,  2 Jun 2023 03:07:43 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3529JYIs011682;
        Fri, 2 Jun 2023 10:07:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=PVuKXKThOmGBHaktAqnQ6BKyCjA4TbklPrmIokFCwic=;
 b=T9z4MgJwBSfBSlVvwIqKDW7LxnPJ8sZATWrSazY4why0VTf2xqo1PpYb39EQ/ty3tDgt
 BQAZl7QVal279FnPUBRRz4Z+vR95hJe+em9cnbFwe86maKR+l3MjtZQid+TANk5v1bpI
 6YBkbYORY0SpDEc0rMdfvy6oG+eDqb753IJbk2fkiv6hJFuUfxwFU9/jmD5neVMFmIzJ
 rvNAuOjV/ZmssV23WF32lfZvpxjlK1TGi2M9XDmJtlc+XKBkjk7sNiAAajhhOl3ChAfC
 OgeZj3M2OcIuKpljR4lG2pgxDgxeiYLCf4dMSJoiG3pMa/frnaKFrs3Tmd3Zd7Gq+KMj yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qydphs5yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 10:07:42 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3529xsNk010260;
        Fri, 2 Jun 2023 10:07:38 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qydphs4x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 10:07:37 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3522h0Ek008204;
        Fri, 2 Jun 2023 10:02:00 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qu9g5aypr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 10:02:00 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 352A1vC119530276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Jun 2023 10:01:57 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E59F720065;
        Fri,  2 Jun 2023 10:01:56 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D88F20063;
        Fri,  2 Jun 2023 10:01:56 +0000 (GMT)
Received: from [9.179.1.27] (unknown [9.179.1.27])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri,  2 Jun 2023 10:01:56 +0000 (GMT)
Message-ID: <c56c04e4-8140-5d5d-6793-8faa63958cc0@linux.ibm.com>
Date:   Fri, 2 Jun 2023 12:01:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v9 2/2] s390x: topology: Checking
 Configuration Topology Information
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nsg@linux.ibm.com
References: <20230519112236.14332-1-pmorel@linux.ibm.com>
 <20230519112236.14332-3-pmorel@linux.ibm.com>
 <fa415627-bfff-cc18-af94-cf55632973d5@linux.ibm.com>
 <168569490681.252746.1049350277526238686@t14-nrb>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <168569490681.252746.1049350277526238686@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: G47afggXF0boc8ZQwJBSk3p3OVdJi1yy
X-Proofpoint-ORIG-GUID: SvSw6_zy16cetJ1xGoqxthDs_IlJXhOl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_06,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxscore=0 adultscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306020076
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/2/23 10:35, Nico Boehr wrote:
> Quoting Janosch Frank (2023-06-01 11:38:37)
> [...]
>>>    [topology]
>>>    file = topology.elf
>>> +# 3 CPUs on socket 0 with different CPU TLE (standard, dedicated, origin)
>>> +# 1 CPU on socket 2
>>> +extra_params = -smp 1,drawers=3,books=3,sockets=4,cores=4,maxcpus=144 -cpu z14,ctop=on -device z14-s390x-cpu,core-id=1,entitlement=low -device z14-s390x-cpu,core-id=2,dedicated=on -device z14-s390x-cpu,core-id=10 -device z14-s390x-cpu,core-id=20 -device z14-s390x-cpu,core-id=130,socket-id=0,book-id=0,drawer-id=0 -append '-drawers 3 -books 3 -sockets 4 -cores 4'
>>> +
>>> +[topology-2]
>>> +file = topology.elf
>>> +extra_params = -smp 1,drawers=2,books=2,sockets=2,cores=30,maxcpus=240  -append '-drawers 2 -books 2 -sockets 2 -cores 30' -cpu z14,ctop=on -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=2,entitlement=low -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=3,entitlement=medium -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=4,entitlement=high -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=5,entitlement=high,dedicated=on -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=65,entitlement=low -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=66,entitlement=medium -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=67,entitlement=high -device z14-s390x-cpu,drawer-id=1,book-id=0,socket-id=0,core-id=68,entitlement=high,dedicated=on
>> Pardon my ignorance but I see z14 in there, will this work if we run on
>> a z13?
> It causes a skip, I reproduced this on a z14 by changing to z15:
> SKIP topology (qemu-system-s390x: unable to find CPU model 'z15')
>
> If we can make this more generic so the tests run on older machines it would be
> good, but if we can't it wouldn't break (i.e. FAIL) on older machines.
>
>> Also, will this work/fail gracefully if the test is run with a quemu
>> that doesn't know about topology or will it crash?
> Just tried on my box, skips with:
> SKIP topology (qemu-system-s390x: Parameter 'smp.books' is unexpected)
>
> So I think we're good here.


Right, I answered about QEMU and not for kvm-unit-tests

