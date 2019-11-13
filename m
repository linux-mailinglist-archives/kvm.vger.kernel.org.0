Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 002A8FB3F1
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 16:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfKMPmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 10:42:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47832 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726422AbfKMPmE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 10:42:04 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xADFej5w061243
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 10:42:02 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w7qdd0x6d-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 10:42:01 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Wed, 13 Nov 2019 15:41:16 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 13 Nov 2019 15:41:14 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xADFfDJF57540648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 15:41:13 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18585A4064;
        Wed, 13 Nov 2019 15:41:13 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6BD5A405F;
        Wed, 13 Nov 2019 15:41:12 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.39])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Nov 2019 15:41:12 +0000 (GMT)
Date:   Wed, 13 Nov 2019 16:41:11 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 2/2] s390x: SCLP unit test
In-Reply-To: <87d5c8cb-f6d6-4034-629a-4bf26b349b5f@redhat.com>
References: <1573492826-24589-1-git-send-email-imbrenda@linux.ibm.com>
        <1573492826-24589-3-git-send-email-imbrenda@linux.ibm.com>
        <fe853e54-ef79-ed94-eaf8-18b2acfd95f5@redhat.com>
        <20191113134024.75beb67d@p-imbrenda.boeblingen.de.ibm.com>
        <87d5c8cb-f6d6-4034-629a-4bf26b349b5f@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19111315-0008-0000-0000-0000032EB62A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111315-0009-0000-0000-00004A4DC0B8
Message-Id: <20191113164111.0e9a340c@p-imbrenda.boeblingen.de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-13_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911130143
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Nov 2019 14:05:24 +0100
Thomas Huth <thuth@redhat.com> wrote:

[...]

> Hmm, ok, I guess some additional comments like this in the source code
> would be helpful.

ok, I'll add plenty

> >>> +	expect_pgm_int();
> >>> +	res = sclp_service_call_test(cmd, h);
> >>> +	if (res) {
> >>> +		report_info("SCLP not ready (command %#x, address
> >>> %p, cc %d)", cmd, addr, res);
> >>> +		return 0;
> >>> +	}
> >>> +	pgm = clear_pgm_int();
> >>> +	/* Check if the program exception was one of the expected
> >>> ones */
> >>> +	if (!((1ULL << pgm) & exp_pgm)) {
> >>> +		report_info("First failure at addr %p, size %d,
> >>> cmd %#x, pgm code %d", addr, len, cmd, pgm);
> >>> +		return 0;
> >>> +	}
> >>> +	/* Check if the response code is the one expected */
> >>> +	if (exp_rc && (exp_rc != h->response_code)) {    
> >>
> >> You can drop the parentheses around "exp_rc != h->response_code".  
> > 
> > fine, although I don't understand you hatred toward parentheses :)  
> 
> I took a LISP class at university once ... never quite recovered from
> that...
> 
> No, honestly, the problem is rather that these additional parentheses
> slow me down when I read the source code. If I see such if-statements,
> my brain starts to think something like "There are parentheses here,
> so there must be some additional non-trivial logic in this
> if-statement... let's try to understand that..." and it takes a
> second to realize that it's not the case and the parentheses are just
> superfluous.

on the other hand it helps people who don't remember the C operator
precedence by heart :)

but yeah won't be in v4

> >>> +/**
> >>> + * Test SCCBs whose address is in the lowcore or prefix area.
> >>> + */
> >>> +static void test_sccb_prefix(void)
> >>> +{
> >>> +	uint32_t prefix, new_prefix;
> >>> +	int offset;
> >>> +
> >>> +	/* can't actually trash the lowcore, unsurprisingly
> >>> things break if we do */
> >>> +	for (offset = 0; offset < 8192; offset += 8)
> >>> +		if (!test_one_sccb(valid_code, MKPTR(offset), 0,
> >>> PGM_BIT_SPEC, 0))
> >>> +			break;
> >>> +	report("SCCB low pages", offset == 8192);
> >>> +
> >>> +	memcpy(prefix_buf, 0, 8192);
> >>> +	new_prefix = (uint32_t)(intptr_t)prefix_buf;
> >>> +	asm volatile("stpx %0" : "=Q" (prefix));
> >>> +	asm volatile("spx %0" : : "Q" (new_prefix) : "memory");
> >>> +
> >>> +	for (offset = 0; offset < 8192; offset += 8)
> >>> +		if (!test_one_simple(valid_code, MKPTR(new_prefix
> >>> + offset), 8, 8, PGM_BIT_SPEC, 0))

here ^ (read below)

> >>> +			break;
> >>> +	report("SCCB prefix pages", offset == 8192);
> >>> +
> >>> +	memcpy(prefix_buf, 0, 8192);    
> >>
> >> What's that memcpy() good for? A comment would be helpful.  
> > 
> > we just moved the prefix to a temporary one, and thrashed the old
> > one. we can't simply set the old prefix and call it a day, things
> > will break.  
> 
> Did the test really trash the old one? ... hmm, I guess I got the code

yes, the default prefix is 0 and we are writing at absolute 0 (see
above where exactly). the SCLP call *should* not succeed anyway, but we
need to test it

I'm reworking this function because it possibly doesn't test all cases.
I added plenty of comments there too to explain what's going on

> wrong, that prefix addressing is always so confusing. Is SCLP working
> with absolute or real addresses?

yes.

both lowcore (real 0, absolute $PREFIX<<13) and absolute 0 (real
$PREFIX<<13, absolute 0) are forbidden for SCLP, so real or absolute
does not make a difference.

