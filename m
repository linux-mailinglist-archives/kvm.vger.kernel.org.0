Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493E5117214
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 17:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbfLIQou (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 11:44:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34312 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbfLIQou (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Dec 2019 11:44:50 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB9GMLLI030007
        for <kvm@vger.kernel.org>; Mon, 9 Dec 2019 11:44:49 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wrt1yda9u-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2019 11:44:48 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 9 Dec 2019 16:44:46 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 9 Dec 2019 16:44:43 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB9GigpC31391998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Dec 2019 16:44:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37EE5AE058;
        Mon,  9 Dec 2019 16:44:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 008A2AE055;
        Mon,  9 Dec 2019 16:44:42 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Dec 2019 16:44:41 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 3/9] s390: interrupt registration
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, cohuck@redhat.com
References: <1575649588-6127-1-git-send-email-pmorel@linux.ibm.com>
 <1575649588-6127-4-git-send-email-pmorel@linux.ibm.com>
 <864d5ba5-7b06-4880-3d0c-131ef76b8488@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Mon, 9 Dec 2019 17:44:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <864d5ba5-7b06-4880-3d0c-131ef76b8488@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19120916-0016-0000-0000-000002D3372A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120916-0017-0000-0000-000033354A6E
Message-Id: <b1e378bb-19ab-c2ba-e975-352ff6d3e019@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_04:2019-12-09,2019-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 phishscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 impostorscore=0 mlxscore=0 adultscore=0
 mlxlogscore=932 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912090141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-09 12:48, David Hildenbrand wrote:
> On 06.12.19 17:26, Pierre Morel wrote:
>> Define two functions to register and to unregister a call back for IO
>> Interrupt handling.
>>
>> Per default we keep the old behavior, so does a successful unregister
>> of the callback.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/interrupt.c | 23 ++++++++++++++++++++++-
>>   lib/s390x/interrupt.h |  7 +++++++
>>   2 files changed, 29 insertions(+), 1 deletion(-)
>>   create mode 100644 lib/s390x/interrupt.h
>>
>> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
>> index 3e07867..e0eae4d 100644
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
>>   
>>   static bool pgm_int_expected;
>>   static bool ext_int_expected;
>> @@ -140,12 +140,33 @@ void handle_mcck_int(void)
>>   		     lc->mcck_old_psw.addr);
>>   }
>>   
>> +static void (*io_int_func)(void);
>> +
>>   void handle_io_int(void)
>>   {
>> +	if (*io_int_func)
>> +		return (*io_int_func)();
>> +
>>   	report_abort("Unexpected io interrupt: at %#lx",
>>   		     lc->io_old_psw.addr);
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
>> +
>>   void handle_svc_int(void)
>>   {
>>   	report_abort("Unexpected supervisor call interrupt: at %#lx",
>> diff --git a/lib/s390x/interrupt.h b/lib/s390x/interrupt.h
>> new file mode 100644
>> index 0000000..e945ef7
>> --- /dev/null
>> +++ b/lib/s390x/interrupt.h
>> @@ -0,0 +1,7 @@
>> +#ifndef __INTERRUPT_H
>> +#include <asm/interrupt.h>
>> +
>> +int register_io_int_func(void (*f)(void));
>> +int unregister_io_int_func(void (*f)(void));
>> +
>> +#endif
>>
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

