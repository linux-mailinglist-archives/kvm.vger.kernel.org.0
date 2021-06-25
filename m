Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAE73B3D68
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 09:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhFYHeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 03:34:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63048 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229616AbhFYHeU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 03:34:20 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15P7Dxh5155164;
        Fri, 25 Jun 2021 03:31:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IDse4mlKn3O1DilpW8Yn7wclC4QtKt4xUL+IMX9o84o=;
 b=VbZ6bJcyRyNUFKFZrxMKcMv6J/ifpKyEr2vkhZLPVXMGvhStAL/m4kEIpf35SUlyXCyP
 D92ERaJTymWGjwqNOkQSdnR9ihTJSsp2f+IW2RKXOu0TddunOP6mpSCvdt5vqGSNrL2Z
 XaqBmoMz5Pqu5D0ANjN5u3f6OCUOD+9Mx6QZvFBOa0jlX6h8xKGsPLL2a/qpuVwvfzvm
 KlLffMuO/dKBzMMo4FWk5SM9+upEgLMGSqqhFfI4HTGFz3T5piaf3eKVOXMQ8gA8P3wm
 quzxHgJ3dy5H3pr/ulpCY36xgeRTLhFvAQX5qRM7fdw6FVf29QaByPFU/JRWkyuNfCAG Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39daju0kb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 03:31:59 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15P7Ofwm002980;
        Fri, 25 Jun 2021 03:31:59 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39daju0kah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 03:31:58 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15P6wMel013434;
        Fri, 25 Jun 2021 07:04:09 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3997uhavje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 07:04:09 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15P746JN29032784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 07:04:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 641534C05A;
        Fri, 25 Jun 2021 07:04:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 037024C058;
        Fri, 25 Jun 2021 07:04:06 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.46.136])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Jun 2021 07:04:05 +0000 (GMT)
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, seiden@linux.ibm.com
References: <20210624120152.344009-1-frankja@linux.ibm.com>
 <20210624120152.344009-2-frankja@linux.ibm.com>
 <cd6d6ff0-82f1-269f-f826-56000431c5fb@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 1/3] s390x: snippets: Add gitignore as well as linker
 script and start assembly
Message-ID: <e0f1610e-efb9-e702-b45f-29f50bdf6a9e@linux.ibm.com>
Date:   Fri, 25 Jun 2021 09:04:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <cd6d6ff0-82f1-269f-f826-56000431c5fb@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qK_VHfVh9wTsmIDde4nxOI2Hf1dg1xGZ
X-Proofpoint-ORIG-GUID: jJ6bq0u2XFy1JZjvBULY6wZdQmD95z6Y
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_02:2021-06-24,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 priorityscore=1501 bulkscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250040
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/24/21 5:49 PM, Thomas Huth wrote:
> On 24/06/2021 14.01, Janosch Frank wrote:
>> Snippets are small guests That can be run under a unit test as the
>> hypervisor. They can be written in C or assembly. The C code needs a
>> linker script and a start assembly file that jumps to main to work
>> properly. So let's add that as well as a gitignore entry for the new
>> files.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   .gitignore                |  1 +
>>   s390x/snippets/c/cstart.S | 15 ++++++++++++
>>   s390x/snippets/c/flat.lds | 51 +++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 67 insertions(+)
>>   create mode 100644 s390x/snippets/c/cstart.S
>>   create mode 100644 s390x/snippets/c/flat.lds
>>
>> diff --git a/.gitignore b/.gitignore
>> index 8534fb7..b3cf2cb 100644
>> --- a/.gitignore
>> +++ b/.gitignore
>> @@ -23,3 +23,4 @@ cscope.*
>>   /api/dirty-log
>>   /api/dirty-log-perf
>>   /s390x/*.bin
>> +/s390x/snippets/*/*.gbin
>> diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
>> new file mode 100644
>> index 0000000..d7f6525
>> --- /dev/null
>> +++ b/s390x/snippets/c/cstart.S
>> @@ -0,0 +1,15 @@
>> +#include <asm/sigp.h>
>> +
>> +.section .init
>> +	.globl start
>> +start:
>> +	/* XOR all registers with themselves to clear them fully. */
>> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>> +	xgr \i,\i
>> +	.endr
>> +	/* 0x3000 is the stack page for now */
>> +	lghi	%r15, 0x4000 - 160
>> +	brasl	%r14, main
>> +	/* For now let's only use cpu 0 in snippets so this will always work. */
>> +	xgr	%r0, %r0
>> +	sigp    %r2, %r0, SIGP_STOP
>> diff --git a/s390x/snippets/c/flat.lds b/s390x/snippets/c/flat.lds
>> new file mode 100644
>> index 0000000..5e70732
>> --- /dev/null
>> +++ b/s390x/snippets/c/flat.lds
>> @@ -0,0 +1,51 @@
>> +SECTIONS
>> +{
>> +	.lowcore : {
>> +		/*
>> +		 * Initial short psw for disk boot, with 31 bit addressing for
>> +		 * non z/Arch environment compatibility and the instruction
>> +		 * address 0x10000 (cstart64.S .init).
> 
> I think this comment needs some adjustments (0x10000 => 0x4000 and do not 
> talk about cstart64.S)?

Right, will do

> 
> Also, what about switching to 64-bit mode in the snippets?

I thought about that for some time a while ago.
It's not really necessary since the host test can also decide which
guest PSW is used to start the snippet but it also doesn't hurt so I
just added a sam64.

> 
>   Thomas
> 
> 
>> +		 */
>> +		. = 0;
>> +		 LONG(0x00080000)
>> +		 LONG(0x80004000)
>> +		 /* Restart new PSW for booting via PSW restart. */
>> +		 . = 0x1a0;
>> +		 QUAD(0x0000000180000000)
>> +		 QUAD(0x0000000000004000)
>> +	}
>> +	. = 0x4000;
>> +	.text : {
>> +		*(.init)
>> +		*(.text)
>> +		*(.text.*)
>> +	}
>> +	. = ALIGN(64K);
>> +	etext = .;
>> +	.opd : { *(.opd) }
>> +	. = ALIGN(16);
>> +	.dynamic : {
>> +		dynamic_start = .;
>> +		*(.dynamic)
>> +	}
>> +	.dynsym : {
>> +		dynsym_start = .;
>> +		*(.dynsym)
>> +	}
>> +	.rela.dyn : { *(.rela*) }
>> +	. = ALIGN(16);
>> +	.data : {
>> +		*(.data)
>> +		*(.data.rel*)
>> +	}
>> +	. = ALIGN(16);
>> +	.rodata : { *(.rodata) *(.rodata.*) }
>> +	. = ALIGN(16);
>> +	__bss_start = .;
>> +	.bss : { *(.bss) }
>> +	__bss_end = .;
>> +	. = ALIGN(64K);
>> +	edata = .;
>> +	. += 64K;
>> +	. = ALIGN(64K);
>> +}
>>
> 

