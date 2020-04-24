Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84741B7250
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 12:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgDXKoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 06:44:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54064 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726289AbgDXKoX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 06:44:23 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03OAWPAi109970
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 06:44:22 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmubcf9d-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 06:44:22 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 24 Apr 2020 11:43:32 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 24 Apr 2020 11:43:29 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03OAiHXg59113696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 10:44:17 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2272FA405B;
        Fri, 24 Apr 2020 10:44:17 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2984A4064;
        Fri, 24 Apr 2020 10:44:16 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.79.138])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Apr 2020 10:44:16 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 04/10] s390x: interrupt registration
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1582200043-21760-1-git-send-email-pmorel@linux.ibm.com>
 <1582200043-21760-5-git-send-email-pmorel@linux.ibm.com>
 <c8d1081a-8e94-f28e-66e7-fe98aea31837@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Fri, 24 Apr 2020 12:44:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <c8d1081a-8e94-f28e-66e7-fe98aea31837@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20042410-4275-0000-0000-000003C5B09A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042410-4276-0000-0000-000038DB3E1D
Message-Id: <b5c02122-68a7-31e7-11e4-5f05403feb08@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_04:2020-04-23,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-04-24 10:27, Janosch Frank wrote:
> On 2/20/20 1:00 PM, Pierre Morel wrote:
>> Let's make it possible to add and remove a custom io interrupt handler,
>> that can be used instead of the normal one.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> Reviewed-by: David Hildenbrand <david@redhat.com>
>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/interrupt.c | 22 +++++++++++++++++++++-
>>   lib/s390x/interrupt.h |  7 +++++++
>>   2 files changed, 28 insertions(+), 1 deletion(-)
>>   create mode 100644 lib/s390x/interrupt.h
>>
>> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
>> index 3a40cac..f6f0665 100644
>> --- a/lib/s390x/interrupt.c
>> +++ b/lib/s390x/interrupt.c
>> @@ -10,9 +10,9 @@
>>    * under the terms of the GNU Library General Public License version 2.
>>    */
>>   #include <libcflat.h>
>> -#include <asm/interrupt.h>
>>   #include <asm/barrier.h>
>>   #include <sclp.h>
>> +#include <interrupt.h>
> 
> Hrm
> 
>>   
>>   static bool pgm_int_expected;
>>   static bool ext_int_expected;
>> @@ -144,12 +144,32 @@ void handle_mcck_int(void)
>>   		     stap(), lc->mcck_old_psw.addr);
>>   }
>>   
>> +static void (*io_int_func)(void);
>> +
>>   void handle_io_int(void)
>>   {
>> +	if (*io_int_func)
>> +		return (*io_int_func)();
>>   	report_abort("Unexpected io interrupt: on cpu %d at %#lx",
>>   		     stap(), lc->io_old_psw.addr);
>>   }
>>   
>> +int register_io_int_func(void (*f)(void))
>> +{
>> +	if (io_int_func)
>> +		return -1;
>> +	io_int_func = f;
>> +	return 0;
>> +}
>> +
>> +int unregister_io_int_func(void (*f)(void))
>> +{
>> +	if (io_int_func != f)
>> +		return -1;
>> +	io_int_func = NULL;
>> +	return 0;
>> +}
> 
> I'm currently working on something similar for PGMs and I see no
> additional value in two functions for this. Unregistering can be done by
> doing register_io_int_func(NULL)
> 
> This should be enough:
> 
> int register_io_int_func(void (*f)(void))
> {
> 	io_int_func = f;
> }
> 
There are several ways to do this and I really don't mind how it is done.
Since it has been reviewed by, I would like to have the others reviewers 
opinion.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

