Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 249B111CE9E
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 14:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbfLLNnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 08:43:16 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18456 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729516AbfLLNnQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 08:43:16 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBCDh6j6193638
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 08:43:15 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wu1fnh4q1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 08:43:15 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 12 Dec 2019 13:43:12 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Dec 2019 13:43:10 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBCDh94n43122952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 13:43:09 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3B78A4054;
        Thu, 12 Dec 2019 13:43:08 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD089A405C;
        Thu, 12 Dec 2019 13:43:08 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Dec 2019 13:43:08 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 5/9] s390x: Library resources for CSS
 tests
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
 <1576079170-7244-6-git-send-email-pmorel@linux.ibm.com>
 <dd5b82c6-f5bd-ff3d-b65f-300cacfee8a3@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Thu, 12 Dec 2019 14:43:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <dd5b82c6-f5bd-ff3d-b65f-300cacfee8a3@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19121213-0020-0000-0000-00000397769C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121213-0021-0000-0000-000021EE7FAD
Message-Id: <71d58ae9-2a43-733e-847a-5db1a289eb5f@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_03:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 bulkscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 phishscore=0
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912120104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-12 10:51, Janosch Frank wrote:
> On 12/11/19 4:46 PM, Pierre Morel wrote:
>> These are the include and library utilities for the css tests patch
>> series.
>>
>> Debug function can be activated by defining DEBUG_CSS before the
>> inclusion of the css.h header file.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h      | 259 +++++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/css_dump.c | 157 ++++++++++++++++++++++++++
>>   2 files changed, 416 insertions(+)
>>   create mode 100644 lib/s390x/css.h
>>   create mode 100644 lib/s390x/css_dump.c
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> new file mode 100644
>> index 0000000..fd086aa
>> --- /dev/null
>> +++ b/lib/s390x/css.h
>> @@ -0,0 +1,259 @@
>> +/*
>> + * CSS definitions
>> + *
>> + * Copyright IBM, Corp. 2019
>> + * Author: Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
>> + * your option) any later version. See the COPYING file in the top-level
>> + * directory.
>> + */
>> +
>> +#ifndef CSS_H
>> +#define CSS_H
>> +
>> +#define CCW_F_CD	0x80
>> +#define CCW_F_CC	0x40
>> +#define CCW_F_SLI	0x20
>> +#define CCW_F_SKP	0x10
>> +#define CCW_F_PCI	0x08
>> +#define CCW_F_IDA	0x04
>> +#define CCW_F_S		0x02
>> +#define CCW_F_MIDA	0x01
>> +
>> +#define CCW_C_NOP	0x03
>> +#define CCW_C_TIC	0x08
>> +
>> +struct ccw1 {
>> +	unsigned char code;
>> +	unsigned char flags;
>> +	unsigned short count;
>> +	uint32_t data_address;
>> +} __attribute__ ((aligned(4)));
>> +
>> +#define ORB_M_KEY	0xf0000000
>> +#define ORB_F_SUSPEND	0x08000000
>> +#define ORB_F_STREAMING	0x04000000
>> +#define ORB_F_MODIFCTRL	0x02000000
>> +#define ORB_F_SYNC	0x01000000
>> +#define ORB_F_FORMAT	0x00800000
>> +#define ORB_F_PREFETCH	0x00400000
>> +#define ORB_F_INIT_IRQ	0x00200000
>> +#define ORB_F_ADDRLIMIT	0x00100000
>> +#define ORB_F_SUSP_IRQ	0x00080000
>> +#define ORB_F_TRANSPORT	0x00040000
>> +#define ORB_F_IDAW2	0x00020000
>> +#define ORB_F_IDAW_2K	0x00010000
>> +#define ORB_M_LPM	0x0000ff00
>> +#define ORB_F_LPM_DFLT	0x00008000
>> +#define ORB_F_ILSM	0x00000080
>> +#define ORB_F_CCW_IND	0x00000040
>> +#define ORB_F_ORB_EXT	0x00000001
> 
> That looks weird.
> 
>> +
>> +struct orb {
>> +	uint32_t intparm;
>> +	uint32_t ctrl;
>> +	uint32_t cpa;
>> +	uint32_t prio;
>> +	uint32_t reserved[4];
>> +} __attribute__ ((aligned(4)));
> 
> Are any of these ever stack allocated and therefore need alignment?

ORB can be eventually allocated on the stack.

scsw and pmcw not but the SCHIB or the IRB could.

> 
>> +
>> +struct scsw {
>> +	uint32_t ctrl;
>> +	uint32_t ccw_addr;
>> +	uint8_t  dev_stat;
>> +	uint8_t  sch_stat;
>> +	uint16_t count;
>> +};
>> +
>> +struct pmcw {
>> +	uint32_t intparm;
>> +#define PMCW_DNV        0x0001
>> +#define PMCW_ENABLE     0x0080
>> +	uint16_t flags;
>> +	uint16_t devnum;
>> +	uint8_t  lpm;
>> +	uint8_t  pnom;
>> +	uint8_t  lpum;
>> +	uint8_t  pim;
>> +	uint16_t mbi;
>> +	uint8_t  pom;
>> +	uint8_t  pam;
>> +	uint8_t  chpid[8];
>> +	uint32_t flags2;
>> +};
>> +
>> +struct schib {
>> +	struct pmcw pmcw;
>> +	struct scsw scsw;
>> +	uint8_t  md[12];
>> +} __attribute__ ((aligned(4)));
>> +
>> +struct irb {
>> +	struct scsw scsw;
>> +	uint32_t esw[5];
>> +	uint32_t ecw[8];
>> +	uint32_t emw[8];
>> +} __attribute__ ((aligned(4)));
>> +
>> +/* CSS low level access functions */
>> +
>> +static inline int ssch(unsigned long schid, struct orb *addr)
>> +{
>> +	register long long reg1 asm("1") = schid;
>> +	int cc = -1;
> 
> Why is this one initialized but no other cc is?

it does not need to.
will disapear.

> 
>> +
>> +	asm volatile(
>> +		"	   ssch	0(%2)\n"
>> +		"0:	 ipm	 %0\n"
>> +		"	   srl	 %0,28\n"
> 
> Formatting?
> 
>> +		"1:\n"
> 
> What do these jump labels do?

forgotten from a previous implementation.
will disapear

> 
>> +		: "+d" (cc)
>> +		: "d" (reg1), "a" (addr), "m" (*addr)
>> +		: "cc", "memory");
>> +	return cc;
>> +}
>> +

...

>> +extern unsigned long stacktop;
> 
> That should be exported somewhere else, we also use it in
> lib/s390x/sclp.c. Btw. why is it in here at all?

also forgotten from a previous implementation.

> 
>> +#endif
>> diff --git a/lib/s390x/css_dump.c b/lib/s390x/css_dump.c
>> new file mode 100644
>> index 0000000..ff1a812
>> --- /dev/null
>> +++ b/lib/s390x/css_dump.c
>> @@ -0,0 +1,157 @@
>> +/*
>> + * Channel subsystem structures dumping
>> + *
>> + * Copyright (c) 2019 IBM Corp.
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + * This code is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU Library General Public License version 2.
>> + *
>> + * Description:
>> + * Provides the dumping functions for various structures used by subchannels:
>> + * - ORB  : Operation request block, describes the I/O operation and points to
>> + *          a CCW chain
>> + * - CCW  : Channel Command Word, describes the data and flow control
>> + * - IRB  : Interuption response Block, describes the result of an operation
>> + *          holds a SCSW and model-dependent data.
>> + * - SCHIB: SubCHannel Information Block composed of:
>> + *   - SCSW: SubChannel Status Word, status of the channel.
>> + *   - PMCW: Path Management Control Word
>> + * You need the QEMU ccw-pong device in QEMU to answer the I/O transfers.
>> + */
>> +
>> +#include <unistd.h>
>> +#include <stdio.h>
>> +#include <stdint.h>
>> +#include <string.h>
>> +
>> +#undef DEBUG_CSS
>> +#include <css.h>
>> +
>> +/*
>> + * Try to have a more human representation of the SCSW flags:
>> + * each letter in the two strings he under represent the first
> 
> s/he under//

yes, thanks.

> 
>> + * letter of the associated bit in the flag.
> 
> in the flag fields?

OK

> 
>> + */
>> +static const char *scsw_str = "kkkkslccfpixuzen";
>> +static const char *scsw_str2 = "1SHCrshcsdsAIPSs";
>> +static char scsw_line[64] = {};
>> +
>> +char *dump_scsw_flags(uint32_t f)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < 16; i++) {
>> +		if ((f << i) & 0x80000000)
>> +			scsw_line[i] = scsw_str[i];
>> +		else
>> +			scsw_line[i] = '_';
>> +	}
>> +	scsw_line[i] = ' ';
>> +	for (; i < 32; i++) {
>> +		if ((f << i) & 0x80000000)
>> +			scsw_line[i + 1] = scsw_str2[i - 16];
>> +		else
>> +			scsw_line[i + 1] = '_';
>> +	}
>> +	return scsw_line;
>> +}
>> +
>> +/*
>> + * Try o have a more human representation of the PMCW flags
>> + * each letter in the two strings he under represent the first
>> + * letter of the associated bit in the flag.
> 
> Please rephrase
> 
OK.

Thanks.
regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

