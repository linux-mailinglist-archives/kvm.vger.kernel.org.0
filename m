Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC9D268BFDA
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 15:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjBFORN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 09:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjBFORK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 09:17:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8176C5FFC
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 06:16:53 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 316EC1Ue021856;
        Mon, 6 Feb 2023 14:16:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9V4+1bTBlOyRGeFmTE8PIGfvSYZcaPGmJTmVyyL8gFA=;
 b=dk3l0ZQCLC9RazrIF1B8Hso6IShjDyFAaPpOYROWXP6JFshuYdp0dN4Iv0QXooFmeGnL
 ik2Yt/K8E1zmNB2r1SzM8PSbHa6j4EjbOORodiR0cMWge7QBNJLpxqKCGpJTZ0J1l1MT
 DsI+FRI4EfkRjk/xvsfKNF1wNRBjr9iKnxwaLY64h+jhAvtRo8gBIup8vfnjsKmLWcrC
 6YOzLTzRZYilxU8y+6kRg6XLPnKmAyhmjEr/d2AIKmc84VMpOe0Tj34RWjfGbGi54VAH
 VbAIgMG2tOILkX7DZPxvLJ8ZWCARwlxH+Cx2Cshz5yTAcqO5MkkmvBEGa8c4awM+0T6D tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk33p83uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 14:16:14 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 316EDWf9027601;
        Mon, 6 Feb 2023 14:16:14 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk33p83t4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 14:16:14 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31601N2t023807;
        Mon, 6 Feb 2023 14:16:11 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3nhf06tgge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 14:16:11 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 316EG8kC25428428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Feb 2023 14:16:08 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27E1620040;
        Mon,  6 Feb 2023 14:16:08 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD8DC20049;
        Mon,  6 Feb 2023 14:16:06 +0000 (GMT)
Received: from [9.171.30.242] (unknown [9.171.30.242])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Feb 2023 14:16:06 +0000 (GMT)
Message-ID: <38f86aa5-c2bb-8a06-5f5c-7e512aca655f@linux.ibm.com>
Date:   Mon, 6 Feb 2023 15:16:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v15 09/11] machine: adding s390 topology to query-cpu-fast
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-10-pmorel@linux.ibm.com>
 <a7a235d5-4ded-b83d-dcb6-2cf81ad5f283@redhat.com>
 <Y+D3PH0EkUPshIMO@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <Y+D3PH0EkUPshIMO@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bEJz2pT2mOH3ioUEyYVCZileEWUTukjK
X-Proofpoint-ORIG-GUID: vt0Hv6tDQwyKk0aDVXMwmqTFmWqK7hBO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_07,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 spamscore=0 impostorscore=0 priorityscore=1501
 clxscore=1015 mlxscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302060121
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/6/23 13:49, Daniel P. Berrangé wrote:
> On Mon, Feb 06, 2023 at 01:41:44PM +0100, Thomas Huth wrote:
>> On 01/02/2023 14.20, Pierre Morel wrote:
>>> S390x provides two more topology containers above the sockets,
>>> books and drawers.
>>>
>>> Let's add these CPU attributes to the QAPI command query-cpu-fast.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>    qapi/machine.json          | 13 ++++++++++---
>>>    hw/core/machine-qmp-cmds.c |  2 ++
>>>    2 files changed, 12 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/qapi/machine.json b/qapi/machine.json
>>> index 3036117059..e36c39e258 100644
>>> --- a/qapi/machine.json
>>> +++ b/qapi/machine.json
>>> @@ -53,11 +53,18 @@
>>>    #
>>>    # Additional information about a virtual S390 CPU
>>>    #
>>> -# @cpu-state: the virtual CPU's state
>>> +# @cpu-state: the virtual CPU's state (since 2.12)
>>> +# @dedicated: the virtual CPU's dedication (since 8.0)
>>> +# @polarity: the virtual CPU's polarity (since 8.0)
>>>    #
>>>    # Since: 2.12
>>>    ##
>>> -{ 'struct': 'CpuInfoS390', 'data': { 'cpu-state': 'CpuS390State' } }
>>> +{ 'struct': 'CpuInfoS390',
>>> +    'data': { 'cpu-state': 'CpuS390State',
>>> +              'dedicated': 'bool',
>>> +              'polarity': 'int'
>>
>> I think it would also be better to mark the new fields as optional and only
>> return them if the guest has the topology enabled, to avoid confusing
>> clients that were written before this change.
> 
> FWIW, I would say that the general expectation of QMP clients is that
> they must *always* expect new fields to appear in dicts that are
> returned in QMP replies. We add new fields at will on a frequent basis.
> 
> So personally I'd keep life simple and unconditionally report the new
> fields.
> 
> With regards,
> Daniel

OK, thanks both of you.
I will then keep the simple way.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
