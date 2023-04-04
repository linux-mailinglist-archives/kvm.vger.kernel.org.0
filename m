Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10F26D672D
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbjDDPXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbjDDPXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:23:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348AF3C15;
        Tue,  4 Apr 2023 08:23:08 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334Enil9007888;
        Tue, 4 Apr 2023 15:23:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=auDp6nZ/2bWY6W6kMlKoA6hUq3gGrq7LIuFCPYZSSbU=;
 b=jShV80Ob6Q1f5k2ItXhjsHI7ETEEqFFX4kNLrqlsxiE4Py+3rgiWhDWiu+ZBN9zTUHoi
 zppjKBpGpEgYjjap2ldC4VK9Umz2gTBHU+nNsZWEv1AYF8XgNiUaDZib1FuNqQFwZLqS
 Dwmk/Z34ggzMPQajGTkypczNNUCtHODDUvb6r37/wY7GNIpvazLtugaRbeTkeqfOieTA
 k8j46h9vYPu9nvysyFekbisDhUiIKABM/PYMV0P9/g0UfPrnefs+CNi17oRhE6PVeqA1
 pZtneyNjtIqsbgmMhA44jio4O9My/O+hojtYOPyigABVEE6fwp8RptHC619c2yUW4cgZ iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prp0cs7wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 15:23:07 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334F04kn011738;
        Tue, 4 Apr 2023 15:23:06 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prp0cs7w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 15:23:06 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3342xntS015581;
        Tue, 4 Apr 2023 15:23:05 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ppc87amkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 15:23:04 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334FN10R29295312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 15:23:01 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 627A220043;
        Tue,  4 Apr 2023 15:23:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34A7F20040;
        Tue,  4 Apr 2023 15:23:01 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue,  4 Apr 2023 15:23:01 +0000 (GMT)
Message-ID: <c6fa68e4-74ed-62a6-ce81-299d39475c64@linux.ibm.com>
Date:   Tue, 4 Apr 2023 17:23:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH 5/5] s390x: ap: Add reset tests
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        linux-s390@vger.kernel.org
References: <20230330114244.35559-1-frankja@linux.ibm.com>
 <20230330114244.35559-6-frankja@linux.ibm.com>
 <25d92c71-b495-9c0a-790d-d310710060d9@linux.ibm.com>
 <65b71334-3f8f-d750-d5be-4d4860af8398@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <65b71334-3f8f-d750-d5be-4d4860af8398@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vspNqGgnRqGGMgOc41I8Il46lypEoF-O
X-Proofpoint-ORIG-GUID: MPhIx4DjsgetpICsCdfCmmbT3g3jBI3x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_06,2023-04-04_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040139
X-Spam-Status: No, score=-2.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/4/23 13:40, Janosch Frank wrote:
> On 4/3/23 16:57, Pierre Morel wrote:
>>
>> On 3/30/23 13:42, Janosch Frank wrote:
>>> Test if the IRQ enablement is turned off on a reset or zeroize PQAP.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>    lib/s390x/ap.c | 68 
>>> ++++++++++++++++++++++++++++++++++++++++++++++++++
>>>    lib/s390x/ap.h |  4 +++
>>>    s390x/ap.c     | 52 ++++++++++++++++++++++++++++++++++++++
>>>    3 files changed, 124 insertions(+)
>>>
>>> diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
>>> index aaf5b4b9..d969b2a5 100644
>>> --- a/lib/s390x/ap.c
>>> +++ b/lib/s390x/ap.c
>>> @@ -113,6 +113,74 @@ int ap_pqap_qci(struct ap_config_info *info)
>>>        return cc;
>>>    }
>>>    +static int pqap_reset(uint8_t ap, uint8_t qn, struct 
>>> ap_queue_status *r1,
>>> +              bool zeroize)
>>
>>
>> NIT. Personal opinion, I find using this bool a little obfuscating and I
>> would have prefer 2 different functions.
>>
>> I see you added a ap_pqap_reset() and ap_pqap_zeroize() next in the 
>> code.
>
> Yes, because the names of the functions include the zeroize parts 
> which makes it easier for developers to understand how they work 
> instead of having a bool argument where they need to look up at which 
> argument position it is.
>
>>
>> Why this intermediate level?
>
> So I don't need to repeat the function below for a different r0.fc, no?


question of taste anyway.


[...]


>>
>>
>>> +    } while (cc == 0 && apqsw.irq_enabled == 0);
>>> +    report(apqsw.irq_enabled == 1, "IRQs enabled");
>>> +
>>> +    ap_pqap_reset(apn, qn, &apqsw);
>>> +    cc = ap_pqap_tapq(apn, qn, &apqsw, &r2);
>>> +    assert(!cc);
>>> +    report(apqsw.irq_enabled == 0, "IRQs have been disabled");
>>
>> shouldn't we check that the APQ is fine apqsw.rc == 0 ?
>
> Isn't that covered by the assert above?

May be.

This is the kind of thing where I find the implementation and 
documentation not very logical.

- CC = 0 means that the instruction was processed correctly.

- APQSW reports the status of the AP queue

For any operation but TAPQ I understand that CC=3 if APQSW is != 0

but for TAPQ, if it is processed correctly it should give back the 
APQSW. Isn't it exactly what we ask the TAPQ to do?

I am probably not the only one to think that CC for TAPQ is at least not 
useful, the Linux implementation ignores it.

You are probably right but in doubt I would do as in Linux 
implementation and ignore CC,



