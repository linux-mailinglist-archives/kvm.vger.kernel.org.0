Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25729153086
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 13:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgBEMZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 07:25:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14652 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726809AbgBEMZt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 07:25:49 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 015CHppw078452
        for <kvm@vger.kernel.org>; Wed, 5 Feb 2020 07:25:47 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xyhmm5qf6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 07:25:47 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Wed, 5 Feb 2020 12:25:45 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 5 Feb 2020 12:25:42 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 015CPf0J58064968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Feb 2020 12:25:41 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07D2E5205F;
        Wed,  5 Feb 2020 12:25:41 +0000 (GMT)
Received: from [9.152.99.235] (unknown [9.152.99.235])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8E8FA52051;
        Wed,  5 Feb 2020 12:25:40 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [RFCv2 15/37] KVM: s390: protvirt: Implement interruption
 injection
To:     Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-16-borntraeger@de.ibm.com>
 <20200205123133.34ac71a2.cohuck@redhat.com>
 <512413a4-196e-5acb-9583-561c061e40ee@linux.ibm.com>
 <20200205131146.611a0d78.cohuck@redhat.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Wed, 5 Feb 2020 13:26:52 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20200205131146.611a0d78.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20020512-0008-0000-0000-0000034FEC90
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020512-0009-0000-0000-00004A707CD7
Message-Id: <d5878d81-38c5-3147-0da4-573e56610c9c@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-05_03:2020-02-04,2020-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=563 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002050100
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05.02.20 13:11, Cornelia Huck wrote:
> On Wed, 5 Feb 2020 12:46:39 +0100
> Michael Mueller <mimu@linux.ibm.com> wrote:
> 
>> On 05.02.20 12:31, Cornelia Huck wrote:
>>> On Mon,  3 Feb 2020 08:19:35 -0500
>>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>>>    
>>>> From: Michael Mueller <mimu@linux.ibm.com>
>>>>
>>>> The patch implements interruption injection for the following
>>>> list of interruption types:
>>>>
>>>>     - I/O
>>>>       __deliver_io (III)
>>>>
>>>>     - External
>>>>       __deliver_cpu_timer (IEI)
>>>>       __deliver_ckc (IEI)
>>>>       __deliver_emergency_signal (IEI)
>>>>       __deliver_external_call (IEI)
>>>>
>>>>     - cpu restart
>>>>       __deliver_restart (IRI)
>>>
>>> Hm... what do 'III', 'IEI', and 'IRI' stand for?
>>
>> that's the kind of interruption injection being used:
>>
>> inject io interruption
>> inject external interruption
>> inject restart interruption
> 
> So, maybe make this:
> 
> - I/O (uses inject io interruption)
>    __ deliver_io
> 
> - External (uses inject external interruption)
> (and so on)
> 
> I find using the acronyms without explanation very confusing.

Make a guess from where they are coming...

Christian, would you please update the description accordingly.


   - I/O (uses inject io interruption)
     __deliver_io

   - External (uses inject external interruption)
     __deliver_cpu_timer
     __deliver_ckc
     __deliver_emergency_signal
     __deliver_external_call

   - cpu restart (uses inject restart interruption)
     __deliver_restart



thanks

Michael

> 
>>
>>>    
>>>>
>>>> The service interrupt is handled in a followup patch.
>>>>
>>>> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
>>>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>> [fixes]
>>>> ---
>>>>    arch/s390/include/asm/kvm_host.h |  8 +++
>>>>    arch/s390/kvm/interrupt.c        | 93 ++++++++++++++++++++++----------
>>>>    2 files changed, 74 insertions(+), 27 deletions(-)
> 

