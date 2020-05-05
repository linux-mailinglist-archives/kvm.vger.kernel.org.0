Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5491C554D
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 14:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbgEEMSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 08:18:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43294 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728512AbgEEMS3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 08:18:29 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045C3jrM027719;
        Tue, 5 May 2020 08:18:29 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s5d50q2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 08:18:28 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 045C3ogC027950;
        Tue, 5 May 2020 08:18:28 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s5d50q1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 08:18:28 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045CAl4E020686;
        Tue, 5 May 2020 12:18:25 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 30s0g62ssc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 12:18:25 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045CIMDj64029152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 12:18:22 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0FAD52059;
        Tue,  5 May 2020 12:18:22 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.23.208])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3BDB452050;
        Tue,  5 May 2020 12:18:22 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: Remove false WARN_ON_ONCE for the PQAP
 instruction
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Qian Cai <cailca@icloud.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
References: <20200505073525.2287-1-borntraeger@de.ibm.com>
 <20200505095332.528254e5.cohuck@redhat.com>
 <f3512a63-91dc-ab9a-a9ab-3e2a6e24fea3@de.ibm.com>
 <59f1b90c-47d6-2661-0e99-548a53c9bcd6@redhat.com>
 <480b0bff-8eb5-f75c-a3ce-2555e38917ee@de.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <1ef464b8-bba7-4ec6-558f-7f76c6690fb2@linux.ibm.com>
Date:   Tue, 5 May 2020 14:18:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <480b0bff-8eb5-f75c-a3ce-2555e38917ee@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_07:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 impostorscore=0 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-05 10:27, Christian Borntraeger wrote:
> 
> 
> On 05.05.20 10:04, David Hildenbrand wrote:
>> On 05.05.20 09:55, Christian Borntraeger wrote:
>>>
>>>
>>> On 05.05.20 09:53, Cornelia Huck wrote:
>>>> On Tue,  5 May 2020 09:35:25 +0200
>>>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>>>>
>>>>> In LPAR we will only get an intercept for FC==3 for the PQAP
>>>>> instruction. Running nested under z/VM can result in other intercepts as
>>>>> well, for example PQAP(QCI). So the WARN_ON_ONCE is not right. Let
>>>>> us simply remove it.
>>>>
>>>> While I agree with removing the WARN_ON_ONCE, I'm wondering why z/VM
>>>> gives us intercepts for those fcs... is that just a result of nesting
>>>> (or the z/VM implementation), or is there anything we might want to do?
>>>
>>> Yes nesting.
>>> The ECA bit for interpretion is an effective one. So if the ECA bit is off
>>> in z/VM (no crypto cards) our ECA bit is basically ignored as these bits
>>> are ANDed.
>>> I asked Tony to ask the z/VM team if that is the case here.
>>>
>>
>> So we can't detect if we have support for ECA_APIE, because there is no
>> explicit feature bit, right? Rings a bell. Still an ugly
>> hardware/firmware specification.

Sorry to be late but you were really too fast for me. :)

AFAIK we detect if we have AP instructions enabled by ECA_APIE for the 
host by probing with a PQAP(TESTQ) during the boot.
If the hypervizor accept this instruction it is supposed to work as if 
it has set APIE present for the Linux host.
If the instruction is rejected we do not enable AP instructions for the 
guest

We also detect if we can use QCI by testing the facility bit and 
propagate only the facility bits we have earned or emulate don't we?

So here I am curious why we got an interception.

Did we give false information to the guest?
Is the guest right to issue the instruction intercepted?
Did z/VM provide the host with false facility information?
Did z/VM dynamically change the virtualization scheme after the boot?

I did not find evidence of the first assumption which would have been a 
legitimate warning.
The next 3 are, IMHO, misbehavior from the guest or z/VM, and do not 
justify a warning there so I find right to remove it.

consider it as a "late" reviewed-by.

Regards,
Pierre


> 
> Yes, no matter if this is the case here, we cannot rely on ECA_APIE to not
> trigger intercepts. So we must remove the WARN_ON.




> 
> cc stable?
> 
>>
>> Seems to be the right thing to do
>>
>> Reviewed-by: David Hildenbrand <david@redhat.com>
>>

-- 
Pierre Morel
IBM Lab Boeblingen
