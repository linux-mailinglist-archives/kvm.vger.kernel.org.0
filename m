Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE6331FF35
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 20:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhBSTFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 14:05:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58990 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229515AbhBSTFb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 14:05:31 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11JJ4cM4117044;
        Fri, 19 Feb 2021 14:04:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=V++HInL+fG9Loz7roCaYPW58rjJbI5biGuRajsl610w=;
 b=gw+cayFi3tZkz4MIbRDsb5ZPVVFLCaSUHrkyimWHa9BNGDLSO+YszZE7mWKfM2FF7fJe
 zc19MceNVHp/DvSyDIIE3apeC4l9jTMRbj5NFcuOjyTRbyZPKxt8WbtwIEuIwBP3xcep
 +HUP2aaj0tTD0Bb1Oky3lFkLVkMr6OZsu3WjzNJ5czXW1YB74lGUnUnEXtq9KBihj4EU
 bN4tecgLvqSjxSrLn1IKOI68KKeq92BVHAkHlzR6pk3HQUbemZyCTiq5lsenUpLjrrHE
 +QOaudlbm+5vonxoAXGZKtDgLXLBKmA2eDbegYxmif/nLcbu+CVnE8sGh6iVh72MGT1F ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36tk4kg1rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Feb 2021 14:04:50 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11JJ4oJh118209;
        Fri, 19 Feb 2021 14:04:50 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36tk4kg166-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Feb 2021 14:04:50 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11JJ1m7K028565;
        Fri, 19 Feb 2021 19:03:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 36p6d8b1v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Feb 2021 19:03:53 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11JJ3oa239846278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 19:03:50 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31DD0A4040;
        Fri, 19 Feb 2021 19:03:50 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0954A4053;
        Fri, 19 Feb 2021 19:03:49 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.23.206])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Feb 2021 19:03:49 +0000 (GMT)
Subject: Re: [PATCH v3 1/1] s390:kvm: diag9c forwarding
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com
References: <1613405210-16532-1-git-send-email-pmorel@linux.ibm.com>
 <1613405210-16532-2-git-send-email-pmorel@linux.ibm.com>
 <20210219170949.6300c056.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <f3502275-c223-f3d5-01e7-513e51961123@linux.ibm.com>
Date:   Fri, 19 Feb 2021 20:03:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210219170949.6300c056.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-19_08:2021-02-18,2021-02-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190149
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/19/21 5:09 PM, Cornelia Huck wrote:
> On Mon, 15 Feb 2021 17:06:50 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
> Make $SUBJECT
> 
> "KVM: s390: diag9c (directed yield) forwarding" ?
> 
>> When we receive intercept a DIAG_9C from the guest we verify
> 
> Either 'receive' or 'intercept', I guess :)

right.

...snip...

>> +DIAG 'X'9C forwarding
>> ++++++++++++++++++++++
>> +
>> +Under KVM, the guest operating system may send a DIAGNOSE code 'X'9C to
>> +the host when it fails to acquire a spinlock for a virtual CPU
>> +and detects that the host CPU on which the virtual guest CPU owner is
>> +assigned to is not running to try to get this host CPU running and
>> +consequently the guest virtual CPU running and freeing the lock.
> 
> What about:
> 
> "The guest may send a DIAGNOSE 0x9c in order to yield to a certain
> other vcpu. An example is a Linux guest that tries to yield to the vcpu
> that is currently holding a spinlock, but not running."

Yes, thanks.

> 
>> +
>> +However, on the logical partition the real CPU on which the previously
>> +targeted host CPU is assign may itself not be running.
> 
> "However, on the host the real cpu backing the vcpu may itself not be
> running."

Yes, better too, thanks.

> 
>> +By forwarding the DIAGNOSE code 'X'9C, initially sent by the guest,
>> +from the host to LPAR hypervisor, this one will hopefully schedule
>> +the host CPU which will let KVM run the target guest CPU.
> 
> "Forwarding the DIAGNOSE 0x9c initially sent by the guest to yield to
> the backing cpu will hopefully cause that cpu, and thus subsequently
> the guest's vcpu, to be scheduled."

yes.

> 
> [I don't think we should explicitly talk about LPAR here, as the same
> should apply if we are running second-or-deeper level, right?]

yes right.

> 
>> +
>> +diag9c_forwarding_hz
>> +    KVM kernel parameter allowing to specify the maximum number of DIAGNOSE
>> +    'X'9C forwarding per second in the purpose of avoiding a DIAGNOSE 'X'9C
>> +    forwarding storm.
> 
> I think 0x9c is the more common way to write the hex code.

yes it is the purpose was to keep it consistent with the existing 
documentation

> 
> Also,
> 
> "A value of 0 turns the forwarding off" ?

yes, I can add this explicitly.

> 
> (...)
> 
>> diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
>> index 27c763014114..15e207a671fd 100644
>> --- a/arch/s390/kernel/smp.c
>> +++ b/arch/s390/kernel/smp.c
>> @@ -422,6 +422,7 @@ void notrace smp_yield_cpu(int cpu)
>>   	asm volatile("diag %0,0,0x9c"
>>   		     : : "d" (pcpu_devices[cpu].address));
>>   }
>> +EXPORT_SYMBOL(smp_yield_cpu);
> 
> EXPORT_SYMBOL_GPL?

OK, clear.

> 
>>   
>>   /*
>>    * Send cpus emergency shutdown signal. This gives the cpus the
> 
> (...)
> 
>> @@ -190,6 +191,11 @@ static bool use_gisa  = true;
>>   module_param(use_gisa, bool, 0644);
>>   MODULE_PARM_DESC(use_gisa, "Use the GISA if the host supports it.");
>>   
>> +/* maximum diag9c forwarding per second */
>> +unsigned int diag9c_forwarding_hz;
>> +module_param(diag9c_forwarding_hz, uint, 0644);
>> +MODULE_PARM_DESC(diag9c_forwarding_hz, "Maximum diag9c forwarding per second");
> 
> Maybe also add "(0 to turn off forwarding)" here?

OK, I will add it.

Thanks for the comments,
Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
