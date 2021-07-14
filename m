Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88EA43C8258
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 12:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238984AbhGNKGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 06:06:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4282 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238638AbhGNKGS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Jul 2021 06:06:18 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E9Y37w187546;
        Wed, 14 Jul 2021 06:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UcWK9hzYtIlZ2xu+1XxoYkwxuD0Nno1rAeSE0xEcjkM=;
 b=NIf0l28BnoA6gQOLE5+WvOw/fDAoHLfs3aG7GgwmtzYFLY5Twg51uYPDpT37yF/6W1EF
 J+zZ82zkGEAWaCZvmKjDoa7RisMnGmTVWJZ80+b8dSdLLwFvMYiORcjiyDfEnhPDY6B/
 k+8t7t74SaDoeGsaqQuZxsDf5tclexbjP3SYHmisx052NkJXoNIbJcaXraFMWN+QEGLm
 xsq0yR43LKcKHdVyei2hB/PHIrk3WhgqiB+0TpOI/cN2GOaxaKP+E4O8v/vwar/ij3XR
 D+kAgz3s6d/lSvjm1w0PMh0M7tA7aqLmkmZgPamibZ4dKziZoRk1vmuD2NWB7eYvPt58 eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39sde1jg1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 06:03:26 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16E9ZIbu191165;
        Wed, 14 Jul 2021 06:03:26 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39sde1jg0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 06:03:26 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16EA3Ooh025926;
        Wed, 14 Jul 2021 10:03:24 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 39q2th9qdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 10:03:24 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16EA1BUk36241762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 10:01:11 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2889BA4064;
        Wed, 14 Jul 2021 10:03:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF271A4067;
        Wed, 14 Jul 2021 10:03:20 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.81.11])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 14 Jul 2021 10:03:20 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: generate kvm hypercall functions
To:     Heiko Carstens <hca@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210713145713.2815167-1-hca@linux.ibm.com>
 <20210714113843.6daa7e09@p-imbrenda> <YO6zadbavNXs4Z3+@osiris>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <ad7dfe27-cc38-5832-6d43-01b6014d841a@de.ibm.com>
Date:   Wed, 14 Jul 2021 12:03:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YO6zadbavNXs4Z3+@osiris>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wrLYDBjlsTf6u6SRVCPkTVLyNPFPtgco
X-Proofpoint-ORIG-GUID: 09jYMmNxojsxhCBnZKRXI3aDG_Yte7Pg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-14_04:2021-07-14,2021-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 spamscore=0 clxscore=1015 mlxlogscore=999 impostorscore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14.07.21 11:50, Heiko Carstens wrote:
> On Wed, Jul 14, 2021 at 11:38:43AM +0200, Claudio Imbrenda wrote:
>> On Tue, 13 Jul 2021 16:57:13 +0200
>> Heiko Carstens <hca@linux.ibm.com> wrote:
>>
>> [snip]
>>
>>> +#define HYPERCALL_ARGS_0
>>> +#define HYPERCALL_ARGS_1 , arg1
>>> +#define HYPERCALL_ARGS_2 HYPERCALL_ARGS_1, arg2
>>> +#define HYPERCALL_ARGS_3 HYPERCALL_ARGS_2, arg3
>>> +#define HYPERCALL_ARGS_4 HYPERCALL_ARGS_3, arg4
>>> +#define HYPERCALL_ARGS_5 HYPERCALL_ARGS_4, arg5
>>> +#define HYPERCALL_ARGS_6 HYPERCALL_ARGS_5, arg6
>>> +
>>> +#define GENERATE_KVM_HYPERCALL_FUNC(args)
>>> 	\ +static inline
>>> 			\ +long __kvm_hypercall##args(unsigned long
>>> nr HYPERCALL_PARM_##args)	\ +{
>>> 					\
>>> +	register unsigned long __nr asm("1") = nr;
>>> 	\
>>> +	register long __rc asm("2");
>>> 	\
>>
>> didn't we want to get rid of asm register allocations?
>>
>> this would have been a nice time to do such a cleanup
> 
> I see only two ways to get rid them, both are suboptimal, therefore I
> decided to keep them at very few places; one of them this one.
> 
> Alternatively to this approach it would be possible to:
> 
> a) write the function entirely in assembler (instead of inlining it).

I would like to keep this as is, unless we know that this could break.
Maybe we should add something like nokasan or whatever?

> b) pass a structure with all parameters to the inline assembly and
>     clobber a large amount of registers, which _might_ even lead to
>     compile errors since the compiler might run out of registers when
>     allocating registers for the inline asm.
> 
> Given that hypercall is slow anyway a) might be an option. But that's
> up to you guys. Otherwise I would consider this the "final" solution
> until we get compiler support which allows for something better.

