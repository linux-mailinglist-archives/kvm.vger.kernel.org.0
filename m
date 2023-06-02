Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F133071FD5A
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 11:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235167AbjFBJNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 05:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234951AbjFBJMz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 05:12:55 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8DBE53;
        Fri,  2 Jun 2023 02:12:07 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3529C6lw007165;
        Fri, 2 Jun 2023 09:12:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BphDo7SYl4JXQoWm57B958TDvZRNRFZ9/el7jw7zdq0=;
 b=MPq9xYK/3zbZ6SBxhz+FWtw8VNUv/KfvoQ662tOFdg+kWU5wvSDZcvtUUW0R1C6zdfB7
 jV1E2Lmy01LiadHnEeiS1754wZExYCX8GN0CdeiL0TkD0VP7oxBHNhqOF/3P6t5ZSuZ0
 JHaUPDu9cCSs2VAfO9z7b9H1+ZlBZfAG82qsmqUUgG+hnYmx0bw3SMpvvpa/9cOlgEW1
 2vg9U75YAOL6RDFnfFSWdNHXCe1GUmr5Xxh+OrrpR3mfpP7fT19x+IJezQvu6osqpzla
 gYuQvUy7G3oCG/AUkNaLoHalmQDp4EmTHWnfletDjdzVKRNfZXjwplM3Ht6wHb0tUPkQ WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qyd0qrhxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 09:03:51 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3528kGY6025906;
        Fri, 2 Jun 2023 09:03:51 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qyd0qrhx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 09:03:51 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3523bPAx014117;
        Fri, 2 Jun 2023 09:03:49 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3qu94eaewj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 09:03:48 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35293jPx43778548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Jun 2023 09:03:45 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41BC820043;
        Fri,  2 Jun 2023 09:03:45 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC9F220040;
        Fri,  2 Jun 2023 09:03:44 +0000 (GMT)
Received: from [9.171.82.186] (unknown [9.171.82.186])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  2 Jun 2023 09:03:44 +0000 (GMT)
Message-ID: <1cbd5a01-6a7a-38a0-5d41-422317dbe2c7@linux.ibm.com>
Date:   Fri, 2 Jun 2023 11:03:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [kvm-unit-tests PATCH v9 2/2] s390x: topology: Checking
 Configuration Topology Information
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nsg@linux.ibm.com
References: <20230519112236.14332-1-pmorel@linux.ibm.com>
 <20230519112236.14332-3-pmorel@linux.ibm.com>
 <fa415627-bfff-cc18-af94-cf55632973d5@linux.ibm.com>
 <168569490681.252746.1049350277526238686@t14-nrb>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <168569490681.252746.1049350277526238686@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fdjl7mhQ-yMyMHlNbMVJKn1Pc2-1bzXB
X-Proofpoint-GUID: bI6_XymwVr4JVMT_6iv7MZjjuh7cBH5s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_06,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 suspectscore=0 malwarescore=0 spamscore=0 impostorscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306020068
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
>>
>> Pardon my ignorance but I see z14 in there, will this work if we run on
>> a z13?
> 
> It causes a skip, I reproduced this on a z14 by changing to z15:
> SKIP topology (qemu-system-s390x: unable to find CPU model 'z15')
> 
> If we can make this more generic so the tests run on older machines it would be
> good, but if we can't it wouldn't break (i.e. FAIL) on older machines.
> 
>> Also, will this work/fail gracefully if the test is run with a quemu
>> that doesn't know about topology or will it crash?
> 
> Just tried on my box, skips with:
> SKIP topology (qemu-system-s390x: Parameter 'smp.books' is unexpected)
> 
> So I think we're good here.

Perfect, thanks for checking!
