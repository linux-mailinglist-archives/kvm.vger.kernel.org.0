Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA2210EE3E
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 18:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbfLBRdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 12:33:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22650 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727793AbfLBRdr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 12:33:47 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB2HSVW4048656
        for <kvm@vger.kernel.org>; Mon, 2 Dec 2019 12:33:45 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wn3pcjc9q-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 12:33:45 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 2 Dec 2019 17:33:43 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 2 Dec 2019 17:33:39 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB2HXcHf34668782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Dec 2019 17:33:38 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46F8BA4053;
        Mon,  2 Dec 2019 17:33:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06A6EA4055;
        Mon,  2 Dec 2019 17:33:38 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.75])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 Dec 2019 17:33:37 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 5/9] s390x: Library resources for CSS
 tests
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
 <1574945167-29677-6-git-send-email-pmorel@linux.ibm.com>
 <20191202150623.627730ad.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Mon, 2 Dec 2019 18:33:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191202150623.627730ad.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19120217-0016-0000-0000-000002CFD445
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120217-0017-0000-0000-00003331C9EE
Message-Id: <78616d28-2d49-cea1-0d25-54f5fb710b16@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-02_04:2019-11-29,2019-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 adultscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912020147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-02 15:06, Cornelia Huck wrote:
> On Thu, 28 Nov 2019 13:46:03 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> These are the include and library utilities for the css tests patch
>> series.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h      | 269 +++++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/css_dump.c | 147 +++++++++++++++++++++++
>>   2 files changed, 416 insertions(+)
>>   create mode 100644 lib/s390x/css.h
>>   create mode 100644 lib/s390x/css_dump.c
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> new file mode 100644
>> index 0000000..95dec72
>> --- /dev/null
>> +++ b/lib/s390x/css.h
>> @@ -0,0 +1,269 @@
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
>> +struct ccw {
> 
> ccw1, to make it clear that this is a format-1 ccw?
> 
> (Do you have any plans to test this with format-0 ccws as well?)

not in a near future

> 
>> +	unsigned char code;
>> +	unsigned char flags;
>> +	unsigned short count;
>> +	unsigned int data;
> 
> data_address?

OK

> 
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
>> +
>> +struct orb {
>> +	unsigned int	intparm;
>> +	unsigned int	ctrl;
>> +	unsigned int	cpa;
>> +	unsigned int	prio;
>> +	unsigned int	reserved[4];
>> +} __attribute__ ((aligned(4)));
>> +
>> +struct scsw {
>> +	uint32_t ctrl;
>> +	uint32_t addr;
> 
> ccw_addr?

OK

> 
>> +	uint8_t  devs;
>> +	uint8_t  schs;
> 
> Maybe dev_stat/sch_stat?

OK

> 
>> +	uint16_t count;
>> +};
> 
> Out of curiousity (I'm not familiar with the conventions in
> kvm-unit-tests): You use the explicit uint32_t et al. types here, while
> you used unsigned int et al. in the other definitions... maybe it would
> be better to use one or the other?

OK, I suppose that if we want to be working with TCG uintxxx_t is better.
So I will take care to be coherent.

> 
> Also, you probably always want to test against a QEMU-provided device
> anyway, so you can probably ignore transport mode and stick with
> command mode only, right?

Yes

> 
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
>> +	struct {
>> +		uint8_t res0;
>> +		uint8_t st:3;
>> +		uint8_t :5;
>> +		uint16_t :13;
>> +		uint16_t f:1;
>> +		uint16_t x:1;
>> +		uint16_t s:1;
>> +	};
> 
> Hm... you used masks for the other fields, any reason you didn't here?

Here too , I must be coherent.
Reason was that I use the flags differently, the test of the bit fields 
is easier to read than shift & mask but ... anyway I prefer masks for 
hardware close programing.

> 
>> +};
>> +
>> +struct schib {
>> +	struct pmcw pmcw;
>> +	struct scsw scsw;
>> +	uint32_t  md0;
>> +	uint32_t  md1;
>> +	uint32_t  md2;
> 
> Hm, both Linux and QEMU express the fields you called md<n> as a 64 bit
> measurement-block address and a four bytes model-dependent area...
> would it make sense to do so here as well? If the extended measurement
> block facility is not installed, we'd get a 12 bytes model-dependent
> area, which IMHO would also look better here.

OK, IMHO too

> 
>> +} __attribute__ ((aligned(4)));
>> +
>> +struct irb {
>> +	struct scsw scsw;
>> +	uint32_t esw[5];
>> +	uint32_t ecw[8];
>> +	uint32_t emw[8];
> 
> If I read the PoP correctly, esw, ecw, and emw are defined bytewise,
> not u32-wise.

Hum, I found them referenced u32-wise.
I intended to define them as a structure at the moment they are used.
If you really prefer I can use uint8_t esw[40] uint8_t ecw[64] etc.
but I like better word aligned structures.

> 
>> +} __attribute__ ((aligned(4)));
>> +
>> +/* CSS low level access functions */
>> +
>> +static inline int ssch(unsigned long schid, struct orb *addr)
>> +{
>> +	register long long reg1 asm("1") = schid;
>> +	int cc = -1;
>> +
>> +	asm volatile(
>> +		"	   ssch	0(%2)\n"
>> +		"0:	 ipm	 %0\n"
>> +		"	   srl	 %0,28\n"
>> +		"1:\n"
>> +		: "+d" (cc)
>> +		: "d" (reg1), "a" (addr), "m" (*addr)
>> +		: "cc", "memory");
>> +	return cc;
>> +}
> 
> Looking at the Linux code, stsch, msch, and ssch all set up an
> exception handler. IIRC, I had introduced that for stsch for multiple
> subchannels sets, not sure about the others. Are we sure we never need
> to catch exceptions here?

This is the next and important step.
I want to surround each call with expect_pgm_int() / check_pgm_int_code()

Also testing each error case.
So we do not need exception handler here, we will use the kvm-test ones.

> 
>> +
>> +static inline int stsch(unsigned long schid, struct schib *addr)
>> +{
>> +	register unsigned long reg1 asm ("1") = schid;
>> +	int cc;
>> +
>> +	asm volatile(
>> +		"	   stsch	0(%3)\n"
>> +		"	   ipm	 %0\n"
>> +		"	   srl	 %0,28"
>> +		: "=d" (cc), "=m" (*addr)
>> +		: "d" (reg1), "a" (addr)
>> +		: "cc");
>> +	return cc;
>> +}
>> +
>> +static inline int msch(unsigned long schid, struct schib *addr)
>> +{
>> +	register unsigned long reg1 asm ("1") = schid;
>> +	int cc;
>> +
>> +	asm volatile(
>> +		"	   msch	0(%3)\n"
>> +		"	   ipm	 %0\n"
>> +		"	   srl	 %0,28"
>> +		: "=d" (cc), "=m" (*addr)
>> +		: "d" (reg1), "a" (addr)
>> +		: "cc");
>> +	return cc;
>> +}
> 
> (...)
> 
>> +static inline int rchp(unsigned long chpid)
>> +{
>> +	register unsigned long reg1 asm("1") = chpid;
>> +	int cc;
>> +
>> +	asm volatile(
>> +		"	rchp\n"
>> +		"	ipm	%0\n"
>> +		"	srl	%0,28"
>> +		: "=d" (cc)
>> +		: "d" (reg1)
>> +		: "cc");
>> +	return cc;
>> +}
> 
> Does rchp actually do anything useful on QEMU? Or is this mainly for
> completeness' sake?

It is for completness for this first series.
However I would like to do something with it in a following one.
to be ready for QEMU implementation or to test real hardware when the 
kvm-unit-test run on LPAR.

> 
>> +
>> +/* Debug functions */
>> +char *dump_pmcw_flags(uint16_t f);
>> +char *dump_scsw_flags(uint32_t f);
>> +#undef DEBUG
>> +#ifdef DEBUG
>> +void dump_scsw(struct scsw *);
>> +void dump_irb(struct irb *irbp);
>> +void dump_schib(struct schib *sch);
>> +struct ccw *dump_ccw(struct ccw *cp);
>> +#else
>> +static inline void dump_scsw(struct scsw *scsw){}
>> +static inline void dump_irb(struct irb *irbp){}
>> +static inline void dump_pmcw(struct pmcw *p){}
>> +static inline void dump_schib(struct schib *sch){}
>> +static inline void dump_orb(struct orb *op){}
>> +static inline struct ccw *dump_ccw(struct ccw *cp)
>> +{
>> +	return NULL;
>> +}
>> +#endif
>> +
>> +extern unsigned long stacktop;
>> +#endif
>> diff --git a/lib/s390x/css_dump.c b/lib/s390x/css_dump.c
>> new file mode 100644
>> index 0000000..5356df2
>> --- /dev/null
>> +++ b/lib/s390x/css_dump.c
>> @@ -0,0 +1,147 @@
>> +/*
>> + * Channel Sub-System structures dumping
> 
> I think "subsystem" is the more usual spelling.

OK, I found it much fun so :)

> 
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
>> + * - ORB  : Operation request block, describe the I/O operation and point to
> 
> s/describe/describes/
> s/point/points/

thanks

> 
>> + *          a CCW chain
>> + * - CCW  : Channel Command Word, describe the data and flow control
> 
> s/describe/describes/
> 
> but maybe better:
> 
> "contains the command, parameters, and a pointer to data"
> 
> ?

yes, thanks

> 
> Also this is format-1 only, isn't it?

yes, I add this

> 
>> + * - IRB  : Interuption response Block, describe the result of an operation
> 
> s/describe/describes/

again!
thanks :)

> 
>> + *          hold a SCSW and several channel type dependent fields.
> 
> s/hold/holds/
hum...
> 
> s/several channel type dependent fields/model-dependent data/ ?

yes

> 
>> + * - SCHIB: SubChannel Information Block composed of:
> 
> s/SubChannel/Subchannel/
> 
>> + *   - SCSW: SubChannel Status Word, status of the channel as a result of an
> 
> s/SubChannel/Subchannel/
OK
> 
>> + *           operation when in IRB.
> 
> I think that description is a bit confusing: An SCSW always contains
> the subchannel status; it's just when it is contained in an IRB that
> the status is associated to the last event on that subchannel (as the
> result of an operation, or as an unsolicited status.)

yes, the "when in IRB has nothing to do there" IRB defintion is above.
I will make it clearer

> 
>> + *   - PMCW: Path Management Control Word
>> + * You need the QEMU ccw-pong device in QEMU to answer the I/O transfers.
>> + */
>> +
>> +#include <unistd.h>
>> +#include <stdio.h>
>> +#include <stdint.h>
>> +#include <string.h>
>> +
>> +#include <css.h>
>> +
>> +static const char *scsw_str = "kkkkslccfpixuzen";
>> +static const char *scsw_str2 = "1SHCrshcsdsAIPSs";
> 
> Nice, random strings? :)

these are the bit definitions associated with the scsw flags.
Easier to read than a bit field ... as long as you have the 
documentation (Pop)


Thanks a lot for the review.
Seems I have some work for the v3

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen

