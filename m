Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7A72FC060
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 20:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbhASTwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 14:52:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21630 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389772AbhASTwH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 14:52:07 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JJck0L168511;
        Tue, 19 Jan 2021 14:51:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BxXBIXJnvfZTrNbxlXhUYC8NRl1+h8yacc27BDHmeCw=;
 b=PbLXzJdFWLXtZNDMfv0yS0goCt0g2gJ7SGfFFfCuwfT4X95arjPBttxMvv+igx1Ho+mU
 HpKS6JRClaFF5plKYqd+fjS6aLOaYno+ExpCJN2rOVB0JpPHOm9Z/2sKoXc4jsN2yBME
 kCLZke21EknNfIDPPt8orQhz7YrIj/dfPEgO4VEizOLuj9qT2KeskhnKW1MKtmblBd/z
 Vi5QUUIm3a4ogDYoyR6WAgOr3LiWFAEnnfuQUx0hXwMiiyNW6DA3I9P3hgI7ezpKp12o
 st11kpceUg7nQ+Pwi6bWW4eekB5H+EjC1XdIFDzKgT13wZ2hfIbl4gw1A4iTnjYvjgel 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36656us0cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 14:51:26 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JJcmBs168627;
        Tue, 19 Jan 2021 14:51:26 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36656us08t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 14:51:26 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JJkxgx025163;
        Tue, 19 Jan 2021 19:51:20 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 363qs8bdq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 19:51:20 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JJpBRb18678218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 19:51:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8866A4040;
        Tue, 19 Jan 2021 19:51:17 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C52FA404D;
        Tue, 19 Jan 2021 19:51:17 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.38.46])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 19:51:17 +0000 (GMT)
Subject: Re: [PATCH 1/1] KVM: s390: diag9c forwarding
To:     Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>
References: <20210118131739.7272-1-borntraeger@de.ibm.com>
 <20210118131739.7272-2-borntraeger@de.ibm.com>
 <20210119175359.1a5ea5be.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <ee6fef19-78b5-c897-0210-fedc52984369@linux.ibm.com>
Date:   Tue, 19 Jan 2021 20:51:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210119175359.1a5ea5be.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_07:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015 malwarescore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/19/21 5:53 PM, Cornelia Huck wrote:
> On Mon, 18 Jan 2021 14:17:39 +0100
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> From: Pierre Morel <pmorel@linux.ibm.com>
>>
>> When we receive intercept a DIAG_9C from the guest we verify
>> that the target real CPU associated with the virtual CPU
>> designated by the guest is running and if not we forward the
>> DIAG_9C to the target real CPU.
>>
>> To avoid a diag9c storm we allow a maximal rate of diag9c forwarding.
>>
>> The rate is calculated as a count per second defined as a
>> new parameter of the s390 kvm module: diag9c_forwarding_hz .
>>
>> The default value is to not forward diag9c.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h |  1 +
>>   arch/s390/include/asm/smp.h      |  1 +
>>   arch/s390/kernel/smp.c           |  1 +
>>   arch/s390/kvm/diag.c             | 31 ++++++++++++++++++++++++++++---
>>   arch/s390/kvm/kvm-s390.c         |  6 ++++++
>>   arch/s390/kvm/kvm-s390.h         |  8 ++++++++
>>   6 files changed, 45 insertions(+), 3 deletions(-)
>>
> 
> (...)
> 
>> @@ -167,9 +180,21 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
>>   	if (!tcpu)
>>   		goto no_yield;
>>   
>> -	/* target already running */
>> -	if (READ_ONCE(tcpu->cpu) >= 0)
>> -		goto no_yield;
>> +	/* target VCPU already running */
> 
> Maybe make this /* target guest VPCU already running */...
> 
>> +	if (READ_ONCE(tcpu->cpu) >= 0) {
>> +		if (!diag9c_forwarding_hz || diag9c_forwarding_overrun())
>> +			goto no_yield;
>> +
>> +		/* target CPU already running */
> 
> ...and this /* target host CPU already running */? I just read this
> several times and was confused before I spotted the difference :)

I can only agree then :) .

...


-- 
Pierre Morel
IBM Lab Boeblingen
