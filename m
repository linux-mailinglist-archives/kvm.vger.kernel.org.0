Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FA14B67E4
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 10:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236000AbiBOJmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 04:42:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236004AbiBOJmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 04:42:15 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A482B13E1E;
        Tue, 15 Feb 2022 01:42:04 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21F7p8Mp012017;
        Tue, 15 Feb 2022 09:42:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=EmWaz7dhqqZXDZm8ymMZma2ZY6tJZ/Wp14zJ5u7LqJw=;
 b=NMjt+pJw1tZO5C3MUkOHFWGr4DmqvPcggkSl0ABHi4FRAGj1B9p3zmgIu+6/usO/5GIi
 9b+4osj5+px+dp0Lxg1Bh5M6w+JGaYpVcYuWREkjwv/aPbrHy3oNq/1iyYbhvPOBs2uK
 5Piww9RLvZECy8cz2qSmjeeWVv9zHzQSPLkyA6HHrMX1PebIzY8o7Q7AwzcE+6p6j4yU
 db8F21tK1RJi5+Xy6B30gTCG7gh/RDSrgvQc+rjiMIqug/J+5G5HHsEB2BgnKe6QwfUo
 TY6Q3Q8n4dx/DlypEETZEvRuNT3tb/ilwWzaMFKoXC2AIzz0tzmiGOLvIbiW1+2CpDWH Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8850j9ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 09:42:03 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21F9fxlu003937;
        Tue, 15 Feb 2022 09:42:03 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8850j9ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 09:42:03 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21F9bZLh009083;
        Tue, 15 Feb 2022 09:42:01 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3e645jkx7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 09:42:01 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21F9fvJ634472228
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 09:41:57 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6224A405F;
        Tue, 15 Feb 2022 09:41:57 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 542D8A4054;
        Tue, 15 Feb 2022 09:41:57 +0000 (GMT)
Received: from [9.171.31.140] (unknown [9.171.31.140])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 09:41:57 +0000 (GMT)
Message-ID: <1e9cfea2-c48c-fe2d-3e26-52ff0db1225b@linux.ibm.com>
Date:   Tue, 15 Feb 2022 10:44:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v4 3/4] s390x: topology: Check the Perform
 Topology Function
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
References: <20220208132709.48291-1-pmorel@linux.ibm.com>
 <20220208132709.48291-4-pmorel@linux.ibm.com>
 <8dd704d23f8a14907ed2a7f28ec3ac52685ab96c.camel@linux.ibm.com>
 <c2dfd5c7-2602-e780-1f2b-402bff3c7c00@linux.ibm.com>
 <72d2bb5a-c0aa-6136-0900-58a0474334d9@linux.ibm.com>
In-Reply-To: <72d2bb5a-c0aa-6136-0900-58a0474334d9@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jUrw8g_ExEHH8GvpvvlQb1w0wQ7rJIH8
X-Proofpoint-ORIG-GUID: 6W8ZdgsgrAhfV6W8yPDq544zZ0DUa6zu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_03,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 clxscore=1015 mlxlogscore=977
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/15/22 10:21, Pierre Morel wrote:
> 
> 
> On 2/15/22 09:50, Pierre Morel wrote:
>>
>>
>> On 2/9/22 12:37, Nico Boehr wrote:
>>> On Tue, 2022-02-08 at 14:27 +0100, Pierre Morel wrote:
>>>> We check the PTF instruction.
>>>
>>> You could test some very basic things as well:
>>>
>>> - you get a privileged pgm int in problem state,
>>> - reserved bits in first operand cause specification pgm int,
>>> - reserved FC values result in a specification pgm int,
>>> - second operand is ignored.
>>
>> Which second operand?
> 
> Sorry got it

I was a little fast in my answer, twice.
If the second operand is ignored, how would you like to check something 
like that?
We can check that the result of the instruction is identical for the 
known effects the user can check what ever we put in there but how can 
we know if it is really ignored?



>>
>>>
>>>>
>>>> - We do not expect to support vertical polarization.
>>>>
>>>> - We do not expect the Modified Topology Change Report to be
>>> [...]
>>>
>>> Forgive me if I'm missing something, but why _Modified_ Topology Change
>>> Report?
>>>
>>>> diff --git a/s390x/topology.c b/s390x/topology.c
>>>> new file mode 100644
>>>> index 00000000..a1f9ce51
>>>> --- /dev/null
>>>> +++ b/s390x/topology.c
>>>
>>> [...]
>>>
>>>> +static int ptf(unsigned long fc, unsigned long *rc)
>>>> +{
>>>> +       int cc;
>>>> +
>>>> +       asm volatile(
>>>> +               "       .insn   rre,0xb9a20000,%1,0\n"
>>>> +               "       ipm     %0\n"
>>>> +               "       srl     %0,28\n"
>>>> +               : "=d" (cc), "+d" (fc)
>>>> +               : "d" (fc)
>>>
>>> Why list fc here again?
>>>
>>>
>>
> 

-- 
Pierre Morel
IBM Lab Boeblingen
