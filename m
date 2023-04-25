Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4456EE2E5
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 15:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbjDYNYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 09:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233329AbjDYNYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 09:24:19 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED4D273D;
        Tue, 25 Apr 2023 06:24:17 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33PD8ePt026191;
        Tue, 25 Apr 2023 13:24:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pBowSoRnru/40kD78nMiv0Wdb/il1KBmeJ0c/lue9tE=;
 b=SzOzxjETfWVojAe0CMioUydcWGVu0uJoUuVNwqJKGRLpNDQUDDpXZXznxNMz+yNEQU0x
 RbfhuIukX7qHk+oJnKj9MgDMWvmGhgm5M+TdHV2/mMUVR1+LC40gV6147g8TK9mUTPVr
 90BPIkmHmch6n6wUbLY7R8VQDMayx3xvtSTrY4OUo5VSSpwMfGVpg3slnn9LthydLesV
 484YJxygqI0Aw3Iptzwh+D6KqMvp4aHvKnCgzMjZuJ9437abSIgx9+73n4cHc3JLSSgt
 pIpAWtdgh3UaG6GGNcLCEA+a+xRQ5fMvS+M2IGXbTgxinvG5qn+tEYLz9f9n5MMVi1NN AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6eyra8hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 13:24:16 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33PD9w7a002984;
        Tue, 25 Apr 2023 13:24:16 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6eyra8fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 13:24:16 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33P2PMkG030306;
        Tue, 25 Apr 2023 13:24:14 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3q47771s7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 13:24:13 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33PDOA9p59113902
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 13:24:10 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6275E2004B;
        Tue, 25 Apr 2023 13:24:10 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21B7020040;
        Tue, 25 Apr 2023 13:24:10 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 25 Apr 2023 13:24:10 +0000 (GMT)
Message-ID: <5847b356-918b-364c-6324-441c258a2204@linux.ibm.com>
Date:   Tue, 25 Apr 2023 15:24:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH 1/1] s390x: sclp: consider monoprocessor on
 read_info error
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org,
        thuth@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        nrb@linux.ibm.com, nsg@linux.ibm.com, cohuck@redhat.com
References: <20230424174218.64145-1-pmorel@linux.ibm.com>
 <20230424174218.64145-2-pmorel@linux.ibm.com>
 <20230425102606.4e9bc606@p-imbrenda>
 <5572f655-4cc8-500f-97fd-068c9f06a90b@linux.ibm.com>
 <738a8001-a651-8e69-7985-511c28fb0485@linux.ibm.com>
 <bc3cf8c5-1aa9-0db3-c212-9c09554d4ab2@linux.ibm.com>
 <20230425141634.1e18b172@p-imbrenda>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20230425141634.1e18b172@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: n-YgILQOOmg16UDBfmfaz8jk2dvYUc3Y
X-Proofpoint-ORIG-GUID: xl2iiBRLfcNnvxhCHCugbmPVO6eKHMmm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_05,2023-04-25_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304250117
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/25/23 14:16, Claudio Imbrenda wrote:
> On Tue, 25 Apr 2023 13:45:13 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
>
>> On 4/25/23 13:33, Janosch Frank wrote:
>>> On 4/25/23 12:53, Pierre Morel wrote:
>>>> On 4/25/23 10:26, Claudio Imbrenda wrote:
>>>>> On Mon, 24 Apr 2023 19:42:18 +0200
>>>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>>>   
>>> How is this considered to be a fix and not a workaround?
>>>
>>>
>>> Set the variable response bit in the control mask and vary the length
>>> based on stfle 140. See __init sclp_early_read_info() in
>>> drivers/s390/char/sclp_early_core.c
> I agree that the SCLP needs to be fixed
>
>>
>> Yes it is something to do anyway.
>>
>> Still in case of error we will need this fix or workaround.
> and I agree that we need this fix anyway
>
> therefore the comment should be more generic and just mention the fact
> that the test would hang if an abort happens before SCLP Read SCP
> Information has completed.

OK


>
>>
>>>   
>>>>>   
>>>>>> Fixes: 52076a63d569 ("s390x: Consolidate sclp read info")
>>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>>> ---
>>>>>>     lib/s390x/sclp.c | 5 +++--
>>>>>>     1 file changed, 3 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>>>>>> index acdc8a9..c09360d 100644
>>>>>> --- a/lib/s390x/sclp.c
>>>>>> +++ b/lib/s390x/sclp.c
>>>>>> @@ -119,8 +119,9 @@ void sclp_read_info(void)
>>>>>>        int sclp_get_cpu_num(void)
>>>>>>     {
>>>>>> -    assert(read_info);
>>>>>> -    return read_info->entries_cpu;
>>>>>> +    if (read_info)
>>>>>> +        return read_info->entries_cpu;
>>>>>> +    return 1;
>>>>>>     }
>>>>>>        CPUEntry *sclp_get_cpu_entries(void)
>>>   
