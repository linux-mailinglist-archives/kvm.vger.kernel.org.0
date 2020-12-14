Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D72E2D9665
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 11:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437118AbgLNKgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 05:36:55 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12648 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436572AbgLNKgz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 05:36:55 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BEAYQc2010671;
        Mon, 14 Dec 2020 05:36:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TL0E756GVDlYlkk14G7BJCT9SVvDQ61sP4GI8lSS11Q=;
 b=YNcPm+BgsFI9QUlIcRhnhIQtjoRrCbWuON83Bgs+2bpZj2HUtlErLgAm3kxwGO5n0dKg
 n0TzYlnA9r4rNOGSfZw45+JD5qTfJCHUqXlRH60rkd7Ph9vWE7fn5UfZ0CFGUszO9jy+
 50xPucUXdoEt1KvSUcOYBN9o746ITRdanIHw7FifNRC6KmiLe2JB4DbIXuk9Lck8D7Ys
 KPqXgpe2EpDHxemejMAs52EGCcmVWxlYGU/XaExSg9cFIvW4G6HS2CnRlqg0qwEy7H+S
 DJjws4nJ4cPhdm/cO7brGOsev0p5ZJ2/mH4Igh9IgRy1fNWX9AigSHRVvaQHuMQYWtA8 Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35e5c9hqw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 05:36:14 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BEAYasj011252;
        Mon, 14 Dec 2020 05:36:14 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35e5c9hqux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 05:36:13 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BEAWvr1026930;
        Mon, 14 Dec 2020 10:36:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 35cng8b1jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 10:36:11 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BEAYrVA57278910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 10:34:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 340214C058;
        Mon, 14 Dec 2020 10:34:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE4224C04E;
        Mon, 14 Dec 2020 10:34:52 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.40.101])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Dec 2020 10:34:52 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 4/8] s390x: Split assembly and move to
 s390x/asm/
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201211100039.63597-1-frankja@linux.ibm.com>
 <20201211100039.63597-5-frankja@linux.ibm.com>
 <5f1e9f51-86d9-4bb1-1dcf-09ec687419f4@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <34bf37fd-ba78-7cd4-7d46-dce1f27b8f62@linux.ibm.com>
Date:   Mon, 14 Dec 2020 11:34:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <5f1e9f51-86d9-4bb1-1dcf-09ec687419f4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_04:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 impostorscore=0 spamscore=0 mlxscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/11/20 1:18 PM, Thomas Huth wrote:
> On 11/12/2020 11.00, Janosch Frank wrote:
>> I've added too much to cstart64.S which is not start related
>> already. Now that I want to add even more code it's time to split
>> cstart64.S. lib.S has functions that are used in tests. macros.S
>> contains macros which are used in cstart64.S and lib.S
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  s390x/Makefile             |   8 +--
>>  s390x/{ => asm}/cstart64.S | 119 ++-----------------------------------
>>  s390x/asm/lib.S            |  65 ++++++++++++++++++++
>>  s390x/asm/macros.S         |  77 ++++++++++++++++++++++++
>>  4 files changed, 150 insertions(+), 119 deletions(-)
>>  rename s390x/{ => asm}/cstart64.S (50%)
>>  create mode 100644 s390x/asm/lib.S
>>  create mode 100644 s390x/asm/macros.S
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index b079a26..fb62e87 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -66,10 +66,10 @@ cflatobjs += lib/s390x/css_lib.o
>>  
>>  OBJDIRS += lib/s390x
>>  
>> -cstart.o = $(TEST_DIR)/cstart64.o
>> +asmlib = $(TEST_DIR)/asm/cstart64.o $(TEST_DIR)/asm/lib.o
>>  
>>  FLATLIBS = $(libcflat)
>> -%.elf: %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(cstart.o)
>> +%.elf: %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
>>  	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) \
>>  		$(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
>>  	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
>> @@ -87,7 +87,7 @@ FLATLIBS = $(libcflat)
>>  	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --image $< -o $@
>>  
>>  arch_clean: asm_offsets_clean
>> -	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d lib/s390x/.*.d
>> +	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d lib/s390x/.*.d $(TEST_DIR)/asm/*.{o,elf,bin} $(TEST_DIR)/asm/.*.d
>>  
>>  generated-files = $(asm-offsets)
>> -$(tests:.elf=.o) $(cstart.o) $(cflatobjs): $(generated-files)
>> +$(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
> 
> Did you check this with both, in-tree and out-of-tree builds?
> (I wonder whether that new asm directory needs some special handling for
> out-of-tree builds?)

I'm not a big fan of out-of-tree builds, so I didn't check.
To get those builds working we would need to create the asm directory in
the $testdir

> 
>> diff --git a/s390x/asm/lib.S b/s390x/asm/lib.S
>> new file mode 100644
>> index 0000000..4d78ec6
>> --- /dev/null
>> +++ b/s390x/asm/lib.S
>> @@ -0,0 +1,65 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * s390x assembly library
>> + *
>> + * Copyright (c) 2019 IBM Corp.
>> + *
>> + * Authors:
>> + *    Janosch Frank <frankja@linux.ibm.com>
>> + */
>> +#include <asm/asm-offsets.h>
>> +#include <asm/sigp.h>
>> +
>> +#include "macros.S"
>> +
>> +/*
>> + * load_reset calling convention:
>> + * %r2 subcode (0 or 1)
>> + */
>> +.globl diag308_load_reset
>> +diag308_load_reset:
> 
> Thinking about this twice ... this function is only used by s390x/diag308.c,
> so it's not really a library function, but rather part of a single test ...
> I think it would be cleaner to put it into a separate file instead, what do
> you think?

I don't really want to split this any further.
Moving the asm files into an own directory already improves readability
a lot for me and I don't need more files if they aren't absolutely
necessary.

> 
>  Thomas
> 
> 

