Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE8F6EDD9D
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 12:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbfKDLUA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 4 Nov 2019 06:20:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728506AbfKDLUA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 06:20:00 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA4BJrvQ036898
        for <kvm@vger.kernel.org>; Mon, 4 Nov 2019 06:19:58 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w2hubtemc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 06:19:55 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Mon, 4 Nov 2019 11:19:09 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 4 Nov 2019 11:19:05 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA4BJ4p765667072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Nov 2019 11:19:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2AB6D11C054;
        Mon,  4 Nov 2019 11:19:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF64C11C04C;
        Mon,  4 Nov 2019 11:19:03 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.39])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Nov 2019 11:19:03 +0000 (GMT)
Date:   Mon, 4 Nov 2019 12:19:01 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 5/5] s390x: SCLP unit test
In-Reply-To: <191dbc7f-74b2-6f78-a721-aaac49895948@linux.ibm.com>
References: <1572023194-14370-1-git-send-email-imbrenda@linux.ibm.com>
        <1572023194-14370-6-git-send-email-imbrenda@linux.ibm.com>
        <191dbc7f-74b2-6f78-a721-aaac49895948@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-TM-AS-GCONF: 00
x-cbid: 19110411-0016-0000-0000-000002C083E3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110411-0017-0000-0000-00003321F3D7
Message-Id: <20191104121901.3b3ab68b@p-imbrenda.boeblingen.de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-04_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911040113
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 4 Nov 2019 10:45:07 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

[...]

> > +/**
> > + * Enable SCLP interrupt.
> > + */
> > +static void sclp_setup_int_test(void)
> > +{
> > +	uint64_t mask;
> > +
> > +	ctl_set_bit(0, 9);
> > +	mask = extract_psw_mask();
> > +	mask |= PSW_MASK_EXT;
> > +	load_psw_mask(mask);
> > +}  
> 
> Or you could just export the definition in sclp.c...

I could, but is it worth it to export the definition just for this
one use?


[...]

> > +static void test_toolong(void)
> > +{
> > +	uint32_t cmd = SCLP_CMD_WRITE_EVENT_DATA;
> > +	uint16_t res = SCLP_RC_SCCB_BOUNDARY_VIOLATION;  
> 
> Why use variables for constants that are never touched?

readability mostly. the names of the constants are rather long.
the compiler will notice it and do the Right Thing™

> > +	WriteEventData *sccb = (WriteEventData *)sccb_template;
> > +	int cx;
> > +
> > +	memset(sccb_template, 0, sizeof(sccb_template));
> > +	sccb->h.function_code = SCLP_FC_NORMAL_WRITE;
> > +	for (cx = 4097; cx < 8192; cx++) {
> > +		sccb->h.length = cx;
> > +		if (!test_one_sccb(cmd, pagebuf, PAGE_SIZE, 0,
> > res))
> > +			break;
> > +	}
> > +	report("SCCB bigger than 4k", cx == 8192);
> > +}
> > +
> > +/**
> > + * Test privileged operation.
> > + */
> > +static void test_priv(void)
> > +{
> > +	report_prefix_push("Privileged operation");
> > +	pagebuf[0] = 0;
> > +	pagebuf[1] = 8;  
> 
> Id much rather have a proper cast using the header struct.

ok, will fix

> > +	expect_pgm_int();
> > +	enter_pstate();
> > +	servc(valid_code, __pa(pagebuf));
> > +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> > +	report_prefix_pop();
> > +}
> > +
> > +/**
> > + * Test addressing exceptions. We need to test SCCB addresses
> > between the
> > + * end of available memory and 2GB, because after 2GB a
> > specification
> > + * exception is also allowed.
> > + * Only applicable if the VM has less than 2GB of memory
> > + */
> > +static void test_addressing(void)
> > +{
> > +	unsigned long cx, maxram = get_ram_size();
> > +
> > +	if (maxram >= 0x80000000) {
> > +		report_skip("Invalid SCCB address");
> > +		return;
> > +	}
> > +	for (cx = maxram; cx < MIN(maxram + 65536, 0x80000000); cx
> > += 8)
> > +		if (!test_one_sccb(valid_code, (void *)cx, 0,
> > PGM_BIT_ADDR, 0))
> > +			goto out;
> > +	for (; cx < MIN((maxram + 0x7fffff) & ~0xfffff,
> > 0x80000000); cx += 4096)
> > +		if (!test_one_sccb(valid_code, (void *)cx, 0,
> > PGM_BIT_ADDR, 0))
> > +			goto out;
> > +	for (; cx < 0x80000000; cx += 1048576)
> > +		if (!test_one_sccb(valid_code, (void *)cx, 0,
> > PGM_BIT_ADDR, 0))
> > +			goto out;
> > +out:
> > +	report("Invalid SCCB address", cx == 0x80000000);
> > +}
> > +
> > +/**
> > + * Test some bits in the instruction format that are specified to
> > be ignored.
> > + */
> > +static void test_instbits(void)
> > +{
> > +	SCCBHeader *h = (SCCBHeader *)pagebuf;
> > +	unsigned long mask;
> > +	int cc;
> > +
> > +	sclp_mark_busy();
> > +	h->length = 8;
> > +
> > +	ctl_set_bit(0, 9);
> > +	mask = extract_psw_mask();
> > +	mask |= PSW_MASK_EXT;
> > +	load_psw_mask(mask);  
> 
> Huh, you already got a function for that at the top.

oops. will fix
 
> > +
> > +	asm volatile(
> > +		"       .insn   rre,0xb2204200,%1,%2\n"  /* servc
> > %1,%2 */
> > +		"       ipm     %0\n"
> > +		"       srl     %0,28"
> > +		: "=&d" (cc) : "d" (valid_code),
> > "a" (__pa(pagebuf))
> > +		: "cc", "memory");
> > +	sclp_wait_busy();
> > +	report("Instruction format ignored bits", cc == 0);
> > +}
> > +
> > +/**
> > + * Find a valid SCLP command code; not all codes are always
> > allowed, and
> > + * probing should be performed in the right order.
> > + */
> > +static void find_valid_sclp_code(void)
> > +{
> > +	unsigned int commands[] = { SCLP_CMDW_READ_SCP_INFO_FORCED,
> > +				    SCLP_CMDW_READ_SCP_INFO };
> > +	SCCBHeader *h = (SCCBHeader *)pagebuf;
> > +	int i, cc;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(commands); i++) {
> > +		sclp_mark_busy();
> > +		memset(h, 0, sizeof(pagebuf));  
> 
> pagebuf is 8k, but you can only use 4k in sclp.
> We don't need to clear 2 pages.

well, technically I don't even need to clear the whole buffer at all.
I should probably simply clear just the header.

> > +		h->length = 4096;
> > +
> > +		valid_code = commands[i];
> > +		cc = sclp_service_call(commands[i], h);
> > +		if (cc)
> > +			break;
> > +		if (h->response_code ==
> > SCLP_RC_NORMAL_READ_COMPLETION)
> > +			return;
> > +		if (h->response_code !=
> > SCLP_RC_INVALID_SCLP_COMMAND)
> > +			break;  
> 
> Depending on line length you could add that to the cc check.
> Maybe you could also group the error conditions before the success
> conditions or the other way around.

yeah it woud fit, but I'm not sure it would be more readable:

if (cc || (h->response_code != SCLP_RC_INVALID_SCLP_COMMAND))
                        break;

I think readability is more important that saving lines of source code,
especially when the compiler will be smart enough to do the Right Thing™

also, that is copy-pasted directly from lib/s390x/sclp.c

> > +	}
> > +	valid_code = 0;
> > +	report_abort("READ_SCP_INFO failed");
> > +}
> > +
> > +int main(void)
> > +{
> > +	report_prefix_push("sclp");
> > +	find_valid_sclp_code();
> > +
> > +	/* Test some basic things */
> > +	test_instbits();
> > +	test_priv();
> > +	test_addressing();
> > +
> > +	/* Test the specification exceptions */
> > +	test_sccb_too_short();
> > +	test_sccb_unaligned();
> > +	test_sccb_prefix();
> > +	test_sccb_high();
> > +
> > +	/* Test the expected response codes */
> > +	test_inval();
> > +	test_short();
> > +	test_boundary();
> > +	test_toolong();
> > +
> > +	return report_summary();
> > +}
> > diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> > index f1b07cd..75e3d37 100644
> > --- a/s390x/unittests.cfg
> > +++ b/s390x/unittests.cfg
> > @@ -75,3 +75,6 @@ file = stsi.elf
> >  [smp]
> >  file = smp.elf
> >  extra_params =-smp 2
> > +
> > +[sclp]
> > +file = sclp.elf  
> 
> Don't we need a newline here?

no, the file ended already with a newline, the three lines are added
above the final newline, so there is always a newline at the end of the
file.

