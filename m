Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC5C391497
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 12:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbhEZKOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 06:14:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33468 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233869AbhEZKOJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 06:14:09 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QA3Rr8088854;
        Wed, 26 May 2021 06:12:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5zToOrEQp17qLS7K+dsBb1hOdp/BouDlOTq1R/wZNRc=;
 b=bu26H2JC244yjx63t1f2cZNIBKW3Uc16HXzxDA1MEjWWiRF/lx8XXo6qMzJD4EMSgiYw
 VhVh1563peLzuFlguu5ms+5pHoZ2WzvqRFfwk+khPw2hJqh6Ba/XdFccBfCTxYq1dXp3
 j488zHsnPGqCNHGf2p6G9amhiauv0mXAJw+p/QJXKO4yoyAeVfJS4W98Kp76TlDp32Im
 EYWFm3autN9ytLJs+RPmGn0HUuemDkP3P9iCDIvUJWwJAgRAyDn4sUgJKjDmlX+nIxHx
 YUiIEfqm2qq6X+Jxz15MaK5qgML2v4lHQKn225oC1++nfiPKm10cvhr4/c6sPaD16QKI tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38sh3m61rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 06:12:37 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14QA3Sft089015;
        Wed, 26 May 2021 06:12:37 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38sh3m61r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 06:12:37 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14QAA4Db004322;
        Wed, 26 May 2021 10:12:35 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 38s1r508cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 10:12:35 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14QACWZb26673596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 10:12:32 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C27A34C04A;
        Wed, 26 May 2021 10:12:32 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 913D64C046;
        Wed, 26 May 2021 10:12:31 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.174.11])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 May 2021 10:12:31 +0000 (GMT)
Subject: Re: [kvm-unit-tests RFC 1/2] s390x: Add guest snippet support
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
References: <20210520094730.55759-1-frankja@linux.ibm.com>
 <20210520094730.55759-2-frankja@linux.ibm.com>
 <20210525184454.2d0693ef@ibm-vm>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <0b971b37-ce5c-74ba-1a59-0863ee2f8354@linux.ibm.com>
Date:   Wed, 26 May 2021 12:12:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210525184454.2d0693ef@ibm-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zEBvuHQTJwE9S-D-xLa_0qluNtdKV-8g
X-Proofpoint-GUID: w7aufgTLbCG4jc2SXz70kWkuWf4T-3oz
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_06:2021-05-26,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/25/21 6:44 PM, Claudio Imbrenda wrote:
> On Thu, 20 May 2021 09:47:29 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Snippets can be used to easily write and run guest (SIE) tests.
>> The snippet is linked into the test binaries and can therefore be
>> accessed via a ptr.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  .gitignore                |  2 ++
>>  s390x/Makefile            | 28 ++++++++++++++++++---
>>  s390x/snippets/c/cstart.S | 13 ++++++++++
>>  s390x/snippets/c/flat.lds | 51
>> +++++++++++++++++++++++++++++++++++++++ 4 files changed, 91
>> insertions(+), 3 deletions(-) create mode 100644
>> s390x/snippets/c/cstart.S create mode 100644 s390x/snippets/c/flat.lds
>>
>> diff --git a/.gitignore b/.gitignore
>> index 784cb2dd..29d3635b 100644
>> --- a/.gitignore
>> +++ b/.gitignore
>> @@ -22,3 +22,5 @@ cscope.*
>>  /api/dirty-log
>>  /api/dirty-log-perf
>>  /s390x/*.bin
>> +/s390x/snippets/*/*.bin
>> +/s390x/snippets/*/*.gbin
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 8de926ab..fe267011 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -75,11 +75,33 @@ OBJDIRS += lib/s390x
>>  asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
>>  
>>  FLATLIBS = $(libcflat)
>> -%.elf: %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
>> +
>> +SNIPPET_DIR = $(TEST_DIR)/snippets
>> +
>> +# C snippets that need to be linked
>> +snippets-c =
>> +
>> +# ASM snippets that are directly compiled and converted to a *.gbin
>> +snippets-a =
>> +
>> +snippets = $(snippets-a)$(snippets-c)
>                           ↑↑
> I'm not a Makefile expert, but, don't you need a space between the two
> variable expansions?
> 

Yup, I already fixed that one

>> +snippets-o += $(patsubst %.gbin,%.o,$(snippets))
>> +
>> +$(snippets-a): $(snippets-o) $(FLATLIBS)
>> +	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
>> +	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
>> +
>> +$(snippets-c): $(snippets-o) $(SNIPPET_DIR)/c/cstart.o  $(FLATLIBS)
>> +	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds \
>> +		$(filter %.o, $^) $(FLATLIBS)
>> +	$(OBJCOPY) -O binary $@ $@
>> +	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
>> +
>> +%.elf: $(snippets) %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
> 
> I would keep the %.o as the first in the list>
>>  	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) \
>>  		$(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
>>  	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
>> -		$(filter %.o, $^) $(FLATLIBS) $(@:.elf=.aux.o)
>> +		$(filter %.o, $^) $(FLATLIBS) $(snippets)
> 
> so all the snippets are always baked in every test?

Currently yes.
Do you have better ideas?

> 
>> $(@:.elf=.aux.o) $(RM) $(@:.elf=.aux.o)
>>  	@chmod a-x $@
>>  
>> @@ -93,7 +115,7 @@ FLATLIBS = $(libcflat)
>>  	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT)
>> --no-verify --image $< -o $@ 
>>  arch_clean: asm_offsets_clean
>> -	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d
>> lib/s390x/.*.d
>> +	$(RM) $(TEST_DIR)/*.{o,elf,bin}
>> $(SNIPPET_DIR)/c/*.{o,elf,bin,gbin} $(SNIPPET_DIR)/.*.d
>> $(TEST_DIR)/.*.d lib/s390x/.*.d generated-files = $(asm-offsets)
>>  $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
>> diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
>> new file mode 100644
>> index 00000000..02a3338b
>> --- /dev/null
>> +++ b/s390x/snippets/c/cstart.S
>> @@ -0,0 +1,13 @@
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
>> +	lghi	%r15, 0x4000
>> +	brasl	%r14, main
>> +	sigp    %r1, %r0, SIGP_STOP
>> diff --git a/s390x/snippets/c/flat.lds b/s390x/snippets/c/flat.lds
>> new file mode 100644
>> index 00000000..5e707325
>> --- /dev/null
>> +++ b/s390x/snippets/c/flat.lds
>> @@ -0,0 +1,51 @@
>> +SECTIONS
>> +{
>> +	.lowcore : {
>> +		/*
>> +		 * Initial short psw for disk boot, with 31 bit
>> addressing for
>> +		 * non z/Arch environment compatibility and the
>> instruction
>> +		 * address 0x10000 (cstart64.S .init).
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
> 

