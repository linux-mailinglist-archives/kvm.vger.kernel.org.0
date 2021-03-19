Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE3A3418C7
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 10:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhCSJur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 05:50:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49726 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229849AbhCSJuQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 05:50:16 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12J9XGBW045542
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 05:50:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Zxrd1J2FOLv48g8E9CkzQnqKdR0rXVqE6afvTTI5idU=;
 b=cr/y6NG+4hlZWOMjr+3WPjOjGIB7c5VqfKlOMu7WJPykGyZzI9dP7FWw3JY90dlg6yWL
 WkrGP5VfUAIjyo3YwTR++mRtxFQ2unToaPkWLHF0Yq4p1bxgJfSel7mICU/8PLYK4iU7
 mRMPJJ3LpGbqbLf5wi6NV1e8KymGmkyebulJ3UZVc3+u82ISVDWWWlr1bm3MfKo7Q/Qc
 tADFpK+eHgCKK39bXPzJuKfy8G+5BkzJsupINzq5Yiepm3AiAAAS/OzFloibrfDui0Dd
 olrchOR+c8Sgt9ejTviVoMGRheRSyVRQIF8aMYsAkBM4kbPRTRg4c0bOGRWmLVZG+TjW IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37c10ggvq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 05:50:15 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12J9Yolb054040
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 05:50:15 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37c10ggvp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 05:50:15 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12J9gnMd029729;
        Fri, 19 Mar 2021 09:50:13 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 378n18ay84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 09:50:13 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12J9oA9p36635110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 09:50:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4837BA405B;
        Fri, 19 Mar 2021 09:50:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07752A405C;
        Fri, 19 Mar 2021 09:50:10 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.64.79])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Mar 2021 09:50:09 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 4/6] s390x: lib: css: add expectations
 to wait for interrupt
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
 <1616073988-10381-5-git-send-email-pmorel@linux.ibm.com>
 <c9a38bd8-f091-d3e4-dea5-0ffd9f1cdf12@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <02a90318-2af5-d4eb-7329-425585bf51d3@linux.ibm.com>
Date:   Fri, 19 Mar 2021 10:50:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <c9a38bd8-f091-d3e4-dea5-0ffd9f1cdf12@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_03:2021-03-17,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/19/21 10:09 AM, Janosch Frank wrote:
> On 3/18/21 2:26 PM, Pierre Morel wrote:
>> When waiting for an interrupt we may need to check the cause of
>> the interrupt depending on the test case.
>>
>> Let's provide the tests the possibility to check if the last valid
>> IRQ received is for the expected instruction.
> 
> s/instruction/command/?

Right, instruction may not be the optimal wording.
I/O architecture description have some strange (for me) wording, the 
best is certainly to stick on this.

Then I will use "the expected function" here.

> 
> We're checking for some value in an IO structure, right?
> Instruction makes me expect an actual processor instruction.
> 
> Is there another word that can be used to describe what we're checking
> here? If yes please also add it to the "pending" variable. "pending_fc"
> or "pending_scsw_fc" for example.

Pending is used to specify that the instruction has been accepted but 
the according function is still pending, i.e. not finished and will stay 
pending for a normal operation until the device active bit is set.

So pending is not the right word, what we check here is the function 
control, indicating the function the status refers too.

> 
>>
...snip...

>>    * Only report failures.
>>    */
>> -int wait_and_check_io_completion(int schid)
>> +int wait_and_check_io_completion(int schid, uint32_t pending)


Consequently I will change "pending" with "function_ctrl"

Thanks for forcing clarification
I hope Connie will agree with this :)

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
