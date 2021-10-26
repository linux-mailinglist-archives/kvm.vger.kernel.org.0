Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE1943B34D
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 15:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbhJZNns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 09:43:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50898 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230420AbhJZNnr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 09:43:47 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QBDGSk028151;
        Tue, 26 Oct 2021 13:41:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=mBnVd39ARGQmn0J2s+WZeR1cSaGtpazqERnbMFafk2k=;
 b=DKRgmi3b2CwcCN2D/3QE5FC80b6HVFk/0pZJZyzjdTKjavNz9Zgc9BxshTyOsBpbm4Gv
 3klPPHRr10s9bxFs5KczRstOHyLwWWvyMyqBnNexj8rbs0KYFg6mxmk/yW/d5M8bvyZb
 zmSsJx+y8L87rZbOzwbEdyPTPIRK5LAyQJhS20aQRCEO3VMDpRPuMjEMCjWf2CLRN1YP
 T0urnI/eOQSBHMfQHpG0MorzGP7Xf5/8Lph1xUy9t3nsYTWebuEEfh2vzf9g6NmbbWqO
 xmg+qNe+c8YKeeINix6QtfIiOiMz4EMzHZsaV03x+1+YHUi+/S4ERCKpTkW06PXrb44a 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bx4k2qyk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 13:41:23 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19QDfHnf030373;
        Tue, 26 Oct 2021 13:41:22 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bx4k2qyht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 13:41:22 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19QDcOOg017764;
        Tue, 26 Oct 2021 13:41:20 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3bx4esx3dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 13:41:20 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19QDfHAu54460690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 13:41:17 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36D8F42047;
        Tue, 26 Oct 2021 13:41:17 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F19342054;
        Tue, 26 Oct 2021 13:41:16 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.93])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 Oct 2021 13:41:16 +0000 (GMT)
Date:   Tue, 26 Oct 2021 15:41:13 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 1/2] s390x: Add specification
 exception test
Message-ID: <20211026154113.1a9ab666@p-imbrenda>
In-Reply-To: <d7b701ba-785f-5019-d2e4-a7eb30598c8f@linux.vnet.ibm.com>
References: <20211022120156.281567-1-scgl@linux.ibm.com>
        <20211022120156.281567-2-scgl@linux.ibm.com>
        <20211025191722.31cf7215@p-imbrenda>
        <d7b701ba-785f-5019-d2e4-a7eb30598c8f@linux.vnet.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KMKp9ioDJ2ZBM8ZrGnHZLcOFBoLkVlS3
X-Proofpoint-ORIG-GUID: Ee3PsXjW5OFs1ARfMFXPEfxyxjFU6gYr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_04,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 spamscore=0 bulkscore=0 impostorscore=0
 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110260078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Oct 2021 14:00:31 +0200
Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com> wrote:

[...]

> I don't think that would work, the compiler might inline the function,
> duplicating the label.

__attribute__((noinline))

:)

> I suppose I could replace the stg with an assignment in C, not sure if that's nicer.
> 
> >> +	fixup_psw.mask = extract_psw_mask();  
> > 
> > then you could add this here:
> > 	fixup_psw.addr = after_lpswe;
> >   
> >> +	asm volatile (
> >> +		"	larl	%[scratch],nop%=\n"
> >> +		"	stg	%[scratch],%[addr]\n"  
> > 	^ those two lines are no longer needed ^  
> >> +		"	lpswe	%[psw]\n"
> >> +		"nop%=:	nop\n"  
> > 	".global after_lpswe \n"
> > 	"after_lpswe:	nop"  
> >> +		: [scratch] "=&r"(scratch),
> >> +		  [addr] "=&T"(fixup_psw.addr)
> >> +		: [psw] "Q"(psw)
> >> +		: "cc", "memory"
> >> +	);
> >> +}

[...]
 
> That's nicer indeed.
> >   
> >> +	asm volatile ("lpq %0,%2"
> >> +		      : "=r"(r1), "=r"(r2)  
> > 
> > since you're ignoring the return value, can't you hardcode r6, and mark
> > it (and r7) as clobbered? like:
> > 		"lpq 6, %[bad]"
> > 		: : [bad] "T"(words[1])
> > 		: "%r6", "%r7" 
> >   
> Ok, btw. is there a reason bare register numbers seem to be more common
> compared to %%rN ?

I don't know, I guess laziness?

> 
> >> +		      : "T"(*bad_aligned)
> >> +	);
> >> +}
> >> +
> >> +static void not_even(void)
> >> +{
> >> +	uint64_t quad[2];
> >> +
> >> +	register uint64_t r1 asm("7");
> >> +	register uint64_t r2 asm("8");
> >> +	asm volatile (".insn	rxy,0xe3000000008f,%0,%2" //lpq
> >> %0,%2  
> > 
> > this is even uglier. I guess you had already tried this?
> >   
> Yes, the assembler won't let you do that.

yeah I thought so

> 
> > 		"lpq 7, %[good]"
> > 			: : [good] "T"(quad)
> > 			: "%r7", "%r8"
> > 
> > if that doesn't work, then the same but with .insn

I guess you can still try this ^ ?

> >   
> >> +		      : "=r"(r1), "=r"(r2)
> >> +		      : "T"(quad)
> >> +	);
> >> +}
> >> +
> >> +struct spec_ex_trigger {
> >> +	const char *name;
> >> +	void (*func)(void);
> >> +	void (*fixup)(void);
> >> +};
> >> +
> >> +static const struct spec_ex_trigger spec_ex_triggers[] = {
> >> +	{ "psw_bit_12_is_1", &psw_bit_12_is_1, &fixup_invalid_psw},
> >> +	{ "bad_alignment", &bad_alignment, NULL},
> >> +	{ "not_even", &not_even, NULL},
> >> +	{ NULL, NULL, NULL},
> >> +};
> >> +  
> > 
> > this is a lot of infrastructure for 3 tests... (or even for 5 tests,
> > since you will add the transactions in the next patch)  
> 
> Is it? I think we'd want a test for a "normal" specification exception,
> and one for an invalid PSW at least. Even for just those two, I don't
> think it would be nice to duplicate the test_spec_ex harness.

usually we do duplicate code for simple tests, so that reviewers have
an easier time understanding what's going on, on the other hand..

> > 
> > are you planning to significantly extend this test in the future?  
> 
> Not really, but I thought having it be easily extensible might be nice.

..fair enough

this way it will be easier to extend this in the future, even though we
don't have any immediate plans to do so

maybe add some words in the patch description, and some comments, to
explain what's going on, to make it easier for others to understand
this code

> >   
> >> +struct args {
> >> +	uint64_t iterations;
> >> +};
> >> +
> >> +static void test_spec_ex(struct args *args,
> >> +			 const struct spec_ex_trigger *trigger)
> >> +{
> >> +	uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION;
> >> +	uint16_t pgm;
> >> +	unsigned int i;
> >> +
> >> +	for (i = 0; i < args->iterations; i++) {
> >> +		expect_pgm_int();
> >> +		register_pgm_cleanup_func(trigger->fixup);
> >> +		trigger->func();
> >> +		register_pgm_cleanup_func(NULL);
> >> +		pgm = clear_pgm_int();
> >> +		if (pgm != expected_pgm) {
> >> +			report_fail("Program interrupt: expected(%d)
> >> == received(%d)",
> >> +				    expected_pgm,
> >> +				    pgm);
> >> +			return;
> >> +		}
> >> +	}
> >> +	report_pass("Program interrupt: always expected(%d) ==
> >> received(%d)",
> >> +		    expected_pgm,
> >> +		    expected_pgm);
> >> +}
> >> +
> >> +static struct args parse_args(int argc, char **argv)  
> > 
> > do we _really_ need commandline arguments?
> >   
> No, but they can be useful.
> The iterations argument can be used to check if interpretation happens.
> The transaction arguments can be useful while developing a test case.
> 
> > is it really so important to be able to control these parameters?
> > 
> > can you find some values for the parameters so that the test works (as
> > in, it actually tests what it's supposed to) and also so that the whole
> > unit test ends in less than 30 seconds?  
> 
> I think the defaults are fine for that, no?

ok so they are only for convenience in case things go wrong?

> >   
> >> +{
> >> +	struct args args = {
> >> +		.iterations = 1,
> >> +	};
> >> +	unsigned int i;
> >> +	long arg;
> >> +	bool no_arg;
> >> +	char *end;
> >> +
> >> +	for (i = 1; i < argc; i++) {
> >> +		no_arg = true;
> >> +		if (i < argc - 1) {
> >> +			no_arg = *argv[i + 1] == '\0';
> >> +			arg = strtol(argv[i + 1], &end, 10);
> >> +			no_arg |= *end != '\0';
> >> +			no_arg |= arg < 0;
> >> +		}
> >> +
> >> +		if (!strcmp("--iterations", argv[i])) {
> >> +			if (no_arg)
> >> +				report_abort("--iterations needs a
> >> positive parameter");
> >> +			args.iterations = arg;
> >> +			++i;
> >> +		} else {
> >> +			report_abort("Unsupported parameter '%s'",
> >> +				     argv[i]);
> >> +		}
> >> +	}

I wonder if we can factor out the parameter parsing

> >> +	return args;
> >> +}
> >> +
> >> +int main(int argc, char **argv)
> >> +{
> >> +	unsigned int i;
> >> +
> >> +	struct args args = parse_args(argc, argv);
> >> +
> >> +	report_prefix_push("specification exception");
> >> +	for (i = 0; spec_ex_triggers[i].name; i++) {
> >> +		report_prefix_push(spec_ex_triggers[i].name);
> >> +		test_spec_ex(&args, &spec_ex_triggers[i]);
> >> +		report_prefix_pop();
> >> +	}
> >> +	report_prefix_pop();
> >> +
> >> +	return report_summary();
> >> +}
> >> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> >> index 9e1802f..5f43d52 100644
> >> --- a/s390x/unittests.cfg
> >> +++ b/s390x/unittests.cfg
> >> @@ -109,3 +109,6 @@ file = edat.elf
> >>  
> >>  [mvpg-sie]
> >>  file = mvpg-sie.elf
> >> +
> >> +[spec_ex]
> >> +file = spec_ex.elf  
> >   
> 

