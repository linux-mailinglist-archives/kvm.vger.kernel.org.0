Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F36135A18
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 14:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbgAIN3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 08:29:34 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3796 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729854AbgAIN3d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 08:29:33 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 009DDBQ1028451
        for <kvm@vger.kernel.org>; Thu, 9 Jan 2020 08:29:32 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xe2kfx6x3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 08:29:32 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Thu, 9 Jan 2020 13:29:31 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 9 Jan 2020 13:29:27 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 009DTPn052035764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jan 2020 13:29:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D973EA4060;
        Thu,  9 Jan 2020 13:29:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92671A4054;
        Thu,  9 Jan 2020 13:29:25 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.108])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jan 2020 13:29:25 +0000 (GMT)
Date:   Thu, 9 Jan 2020 14:29:24 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v5 4/4] s390x: SCLP unit test
In-Reply-To: <2ca46041-2135-3847-4f22-e1cdebe01936@redhat.com>
References: <20200108161317.268928-1-imbrenda@linux.ibm.com>
        <20200108161317.268928-5-imbrenda@linux.ibm.com>
        <2ca46041-2135-3847-4f22-e1cdebe01936@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20010913-0016-0000-0000-000002DBE978
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20010913-0017-0000-0000-0000333E68A8
Message-Id: <20200109142924.09ccda6e@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-09_02:2020-01-09,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 adultscore=0
 phishscore=0 malwarescore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001090117
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jan 2020 13:42:34 +0100
Thomas Huth <thuth@redhat.com> wrote:

> On 08/01/2020 17.13, Claudio Imbrenda wrote:
> > SCLP unit test. Testing the following:
> > 
> > * Correctly ignoring instruction bits that should be ignored
> > * Privileged instruction check
> > * Check for addressing exceptions
> > * Specification exceptions:
> >   - SCCB size less than 8
> >   - SCCB unaligned
> >   - SCCB overlaps prefix or lowcore
> >   - SCCB address higher than 2GB
> > * Return codes for
> >   - Invalid command
> >   - SCCB too short (but at least 8)
> >   - SCCB page boundary violation
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  s390x/Makefile      |   1 +
> >  s390x/sclp.c        | 462
> > ++++++++++++++++++++++++++++++++++++++++++++ s390x/unittests.cfg |
> >  8 + 3 files changed, 471 insertions(+)
> >  create mode 100644 s390x/sclp.c  
> [...]
> > +/**
> > + * Test SCCBs whose address is in the lowcore or prefix area.
> > + */
> > +static void test_sccb_prefix(void)
> > +{
> > +	uint8_t scratch[2 * PAGE_SIZE];
> > +	uint32_t prefix, new_prefix;
> > +	int offset;
> > +
> > +	/*
> > +	 * copy the current lowcore to the future new location,
> > otherwise we
> > +	 * will not have a valid lowcore after setting the new
> > prefix.
> > +	 */
> > +	memcpy(prefix_buf, 0, 2 * PAGE_SIZE);
> > +	/* save the current prefix (it's probably going to be 0) */
> > +	prefix = stpx();
> > +	/*
> > +	 * save the current content of absolute pages 0 and 1, so
> > we can
> > +	 * restore them after we trash them later on
> > +	 */
> > +	memcpy(scratch, (void *)(intptr_t)prefix, 2 * PAGE_SIZE);
> > +	/* set the new prefix to prefix_buf */
> > +	new_prefix = (uint32_t)(intptr_t)prefix_buf;
> > +	spx(new_prefix);
> > +
> > +	/*
> > +	 * testing with SCCB addresses in the lowcore; since we
> > can't
> > +	 * actually trash the lowcore (unsurprisingly, things
> > break if we
> > +	 * do), this will be a read-only test.
> > +	 */
> > +	for (offset = 0; offset < 2 * PAGE_SIZE; offset += 8)
> > +		if (!test_one_sccb(valid_code, MKPTR(offset), 0,
> > PGM_BIT_SPEC, 0))
> > +			break;
> > +	report(offset == 2 * PAGE_SIZE, "SCCB low pages");
> > +
> > +	/*
> > +	 * this will trash the contents of the two pages at
> > absolute
> > +	 * address 0; we will need to restore them later.
> > +	 */  
> 
> I'm still a bit confused by this comment - will SCLP really trash the
> contents here, or will there be a specification exception (since
> PGM_BIT_SPEC is given below)? ... maybe you could clarify the comment

the SCLP will not touch the pages, because we will receive a
specification exception, as you noticed.

on the other hand... WE will trash the area, because WE will write the
SCCB at those addresses before calling the SCLP. test_one_simple() will
create an SCCB and write it at the address indicated (in our case,
starting at PREFIX, thus ending up starting from absolute address 0)

If you look closely, I used a different function for the lowcore,
because we can't trash that without crashing everything. this means
that the first half of test_sccb_prefix is not as thorough as it could
be (we could be more clever and trash only those parts that are not
vital for the system, but that's probably overkill for now)

I will add some more comments to explain what is happening, and a new
test_one_ro() wrapper to make it more obvious when we are doing a
"read-only" test

> in case you respin again (or it could be fixed when picking up the
> patch)?

I'll need to respin anyway because I noticed a small but important
mistake in the test_addressing function

> > +	for (offset = 0; offset < 2 * PAGE_SIZE; offset += 8)
> > +		if (!test_one_simple(valid_code, MKPTR(new_prefix
> > + offset), 8, 8, PGM_BIT_SPEC, 0))
> > +			break;
> > +	report(offset == 2 * PAGE_SIZE, "SCCB prefix pages");
> > +
> > +	/* restore the previous contents of absolute pages 0 and 1
> > */
> > +	memcpy(prefix_buf, 0, 2 * PAGE_SIZE);
> > +	/* restore the prefix to the original value */
> > +	spx(prefix);
> > +}  
> 
> Remaining parts look ok to me now, so with the comment clarified:
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

