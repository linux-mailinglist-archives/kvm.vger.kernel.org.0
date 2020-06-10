Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609D21F5755
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 17:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbgFJPKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 11:10:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22644 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728108AbgFJPKP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 11:10:15 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05AF4Yq2028244;
        Wed, 10 Jun 2020 11:10:14 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31k02bmb2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jun 2020 11:10:14 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05AF4WWQ028178;
        Wed, 10 Jun 2020 11:10:14 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31k02bmb1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jun 2020 11:10:13 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05AF5DSk006958;
        Wed, 10 Jun 2020 15:10:12 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 31g2s7yx6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jun 2020 15:10:12 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05AFAAOD65077410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jun 2020 15:10:10 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E06605207A;
        Wed, 10 Jun 2020 15:10:09 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.158.19])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9D1045204E;
        Wed, 10 Jun 2020 15:10:09 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v8 09/12] s390x: Library resources for CSS
 tests
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-10-git-send-email-pmorel@linux.ibm.com>
 <ef5e71b6-9c4d-ac3f-7946-f67db73d740b@redhat.com>
 <17e5ccdd-f2b2-00bd-4ee2-c0a0b78a669a@linux.ibm.com>
 <e2b1ac8d-f2cb-d913-a64d-a8237633d804@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <fc730d3f-20b0-37b8-cda9-c738315c4f85@linux.ibm.com>
Date:   Wed, 10 Jun 2020 17:10:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <e2b1ac8d-f2cb-d913-a64d-a8237633d804@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-10_09:2020-06-10,2020-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 cotscore=-2147483648
 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006100111
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-10 16:51, Thomas Huth wrote:
> On 09/06/2020 17.01, Pierre Morel wrote:
>>
>>
>> On 2020-06-09 09:09, Thomas Huth wrote:
>>> On 08/06/2020 10.12, Pierre Morel wrote:
>>>> Provide some definitions and library routines that can be used by
>>
>> ...snip...
>>
>>>> +static inline int ssch(unsigned long schid, struct orb *addr)
>>>> +{
>>>> +    register long long reg1 asm("1") = schid;
>>>> +    int cc;
>>>> +
>>>> +    asm volatile(
>>>> +        "    ssch    0(%2)\n"
>>>> +        "    ipm    %0\n"
>>>> +        "    srl    %0,28\n"
>>>> +        : "=d" (cc)
>>>> +        : "d" (reg1), "a" (addr), "m" (*addr)
>>>
>>> Hmm... What's the "m" (*addr) here good for? %3 is not used in the
>>> assembly code?
>>
>> addr is %2
>> "m" (*addr) means memory pointed by addr is read
>>
>>>
>>>> +        : "cc", "memory");
>>>
>>> Why "memory" ? Can this instruction also change the orb?
>>
>> The orb not but this instruction modifies memory as follow:
>> orb -> ccw -> data
>>
>> The CCW can be a READ or a WRITE instruction and the data my be anywhere
>> in memory (<2G)
>>
>> A compiler memory barrier is need to avoid write instructions started
>> before the SSCH instruction to occur after for a write
>> and memory read made after the instruction to be executed before for a
>> read.
> 
> Ok, makes sense now, thanks!
> 
>>>> +static inline int msch(unsigned long schid, struct schib *addr)
>>>> +{
>>>> +    register unsigned long reg1 asm ("1") = schid;
>>>> +    int cc;
>>>> +
>>>> +    asm volatile(
>>>> +        "    msch    0(%3)\n"
>>>> +        "    ipm    %0\n"
>>>> +        "    srl    %0,28"
>>>> +        : "=d" (cc), "=m" (*addr)
>>>> +        : "d" (reg1), "a" (addr)
>>>
>>> I'm not an expert with these IO instructions, but this looks wrong to me
>>> ... Is MSCH reading or writing the SCHIB data?
>>
>> MSCH is reading the SCHIB data in memory.
> 
> So if it is reading, you don't need the  "=m" (*addr) in the output
> list, do you? You should rather use "m" (*addr) in the input list instead?

Yes, absolutely, it should be the oposite of stsch(), not the same!

I change it to:

         asm volatile(
                 "       msch    0(%3)\n"
                 "       ipm     %0\n"
                 "       srl     %0,28"
                 : "=d" (cc)
                 : "d" (reg1), "m" (*addr), "a" (addr)
                 : "cc");

Thanks,

Pierre

> 
>   Thomas
> 

-- 
Pierre Morel
IBM Lab Boeblingen
