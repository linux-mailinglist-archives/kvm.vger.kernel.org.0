Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927A736B4C1
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 16:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbhDZOUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 10:20:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12874 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233471AbhDZOUu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 10:20:50 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13QEAqAu158944;
        Mon, 26 Apr 2021 10:20:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UkX+jxaIjL6r3eCi7OQPK6j/jmRrd30zBScO5ROtJIU=;
 b=nozjYVQKACQF39+o2HJtgdH6AdXj+RRJHnEW4vzea8p/2tp9JemOgUhZ6FkvYteSYFlL
 58PFEHZR4Zk65ZBJS+cCHF/koLOuObsGpL/+HPaFEXEDbKpv4iMm9YjDQ8Af6n5oUYRv
 QMyDe1fizEzPUB5Srl8S8ys7ZbdRkA8nSybh4LsxnA57ccQc+fCq2OyH8Xy2TwciF5yz
 +WFXNdVakeuyvn/B4/r/755YJD+Hytyvk7iCB8p37+b+RUXPJyTuasF3YeAUrE+BiPkb
 7E56J2x9zVU6r0iLOOb9XSFGEm2Rn/oFfGx6xyHomi4C9NeqalJN9JtRIiB330FHwlij 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 385y2389wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Apr 2021 10:20:08 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13QEBmbl161013;
        Mon, 26 Apr 2021 10:20:07 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 385y2389vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Apr 2021 10:20:07 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13QEGqU9005974;
        Mon, 26 Apr 2021 14:20:06 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 384ay8guv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Apr 2021 14:20:06 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13QEK2h739125428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Apr 2021 14:20:02 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A22E052051;
        Mon, 26 Apr 2021 14:20:02 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.12.8])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5026B5204E;
        Mon, 26 Apr 2021 14:20:02 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com
References: <20210316091654.1646-1-frankja@linux.ibm.com>
 <20210316091654.1646-4-frankja@linux.ibm.com>
 <20210420161527.615fb8f6@ibm-vm>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 3/6] s390x: uv: Add UV lib
Message-ID: <708fd75e-ace4-f580-40a9-32952052b11b@linux.ibm.com>
Date:   Mon, 26 Apr 2021 16:20:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210420161527.615fb8f6@ibm-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: n1q4jQKtI7H3lx_LPhTBla0Y3oUrFkrz
X-Proofpoint-GUID: hCqKtWh4oA5a_tCvR13uFBS8U5DvDE9u
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-26_07:2021-04-26,2021-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104260110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/20/21 4:15 PM, Claudio Imbrenda wrote:
> On Tue, 16 Mar 2021 09:16:51 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Let's add a UV library to make checking the UV feature bit easier.
>> In the future this library file can take care of handling UV
>> initialization and UV guest creation.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Thanks

> 
> but see some comments below
> 
>> ---
>>  lib/s390x/asm/uv.h |  4 ++--
>>  lib/s390x/io.c     |  2 ++
>>  lib/s390x/uv.c     | 48
>> ++++++++++++++++++++++++++++++++++++++++++++++ lib/s390x/uv.h     |
>> 10 ++++++++++ s390x/Makefile     |  1 +
>>  5 files changed, 63 insertions(+), 2 deletions(-)
>>  create mode 100644 lib/s390x/uv.c
>>  create mode 100644 lib/s390x/uv.h
>>
>> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
>> index 11f70a9f..b22cbaa8 100644
>> --- a/lib/s390x/asm/uv.h
>> +++ b/lib/s390x/asm/uv.h
>> @@ -9,8 +9,8 @@
>>   * This code is free software; you can redistribute it and/or modify
>> it
>>   * under the terms of the GNU General Public License version 2.
>>   */
>> -#ifndef UV_H
>> -#define UV_H
>> +#ifndef ASM_S390X_UV_H
>> +#define ASM_S390X_UV_H
>>  
>>  #define UVC_RC_EXECUTED		0x0001
>>  #define UVC_RC_INV_CMD		0x0002
>> diff --git a/lib/s390x/io.c b/lib/s390x/io.c
>> index ef9f59e3..a4f1b113 100644
>> --- a/lib/s390x/io.c
>> +++ b/lib/s390x/io.c
>> @@ -14,6 +14,7 @@
>>  #include <asm/facility.h>
>>  #include <asm/sigp.h>
>>  #include "sclp.h"
>> +#include "uv.h"
>>  #include "smp.h"
>>  
>>  extern char ipl_args[];
>> @@ -38,6 +39,7 @@ void setup(void)
>>  	sclp_facilities_setup();
>>  	sclp_console_setup();
>>  	sclp_memory_setup();
>> +	uv_setup();
>>  	smp_setup();
>>  }
>>  
>> diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
>> new file mode 100644
>> index 00000000..a84a85fc
>> --- /dev/null
>> +++ b/lib/s390x/uv.c
>> @@ -0,0 +1,48 @@
>> +#include <libcflat.h>
>> +#include <bitops.h>
>> +#include <alloc.h>
>> +#include <alloc_page.h>
>> +#include <asm/page.h>
>> +#include <asm/arch_def.h>
>> +
>> +#include <asm/facility.h>
>> +#include <asm/uv.h>
>> +#include <uv.h>
>> +
>> +static struct uv_cb_qui uvcb_qui = {
>> +	.header.cmd = UVC_CMD_QUI,
>> +	.header.len = sizeof(uvcb_qui),
>> +};
>> +
>> +bool uv_os_is_guest(void)
>> +{
>> +	return uv_query_test_feature(BIT_UVC_CMD_SET_SHARED_ACCESS)
>> +		&&
>> uv_query_test_feature(BIT_UVC_CMD_REMOVE_SHARED_ACCESS); +}
>> +
>> +bool uv_os_is_host(void)
>> +{
>> +	return uv_query_test_feature(BIT_UVC_CMD_INIT_UV);
>> +}
>> +
>> +bool uv_query_test_feature(int nr)
>> +{
>> +	/* Query needs to be called first */
>> +	if (!uvcb_qui.header.rc)
>> +		return false;
> 
> why not an assert?

I'd guess I had some weird reservation.
I'll add one though

> 
>> +
>> +	return test_bit_inv(nr, uvcb_qui.inst_calls_list);
>> +}
>> +
>> +int uv_setup(void)
>> +{
>> +	int cc;
>> +
>> +	if (!test_facility(158))
>> +		return 0;
>> +
>> +	cc = uv_call(0, (u64)&uvcb_qui);
>> +	assert(cc == 0);
>> +
>> +	return cc == 0;
> 
> sooo... return 1?

Yes

> 
>> +}
>> diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
>> new file mode 100644
>> index 00000000..159bf8e5
>> --- /dev/null
>> +++ b/lib/s390x/uv.h
>> @@ -0,0 +1,10 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> +#ifndef UV_H
>> +#define UV_H
>> +
>> +bool uv_os_is_guest(void);
>> +bool uv_os_is_host(void);
>> +bool uv_query_test_feature(int nr);
>> +int uv_setup(void);
>> +
>> +#endif /* UV_H */
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index b92de9c5..bbf177fa 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -67,6 +67,7 @@ cflatobjs += lib/s390x/vm.o
>>  cflatobjs += lib/s390x/css_dump.o
>>  cflatobjs += lib/s390x/css_lib.o
>>  cflatobjs += lib/s390x/malloc_io.o
>> +cflatobjs += lib/s390x/uv.o
>>  
>>  OBJDIRS += lib/s390x
>>  
> 

