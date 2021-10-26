Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9FD43B4EB
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 16:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbhJZO6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 10:58:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55666 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231178AbhJZO6W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 10:58:22 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QDkAc6027055;
        Tue, 26 Oct 2021 14:55:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=a227DL1MWcEzOfb2kTBHeBAcS29Z6xXBRzh8+Ji87Sc=;
 b=ddn1Fz6PxH8IskPaXG87uj8ARVbNRM6cIYoh7oltu5G4IdcV995SijnCcSWgnSqJwz2A
 eb2Id+SzxdVY1skUcW1wsqNjwn7rkLTlc6is68NT5arHT9ciZIfM40vOALOFQ7ojbgAw
 gCvAKdWKRhuh3fphx4Ywofnm1TcgTpFr4YQQCzNqjGlcazMOeSJFx/Vf/+bBSti7Rx/f
 KeBziAmvpVfQw6xc+RV7D5D/NQboFLwPvG1Bvwif+i5HQsP2L6pxNg7nji9gegPgzaed
 P97aJosdead1gDftFJSyfjM2wtXOBRmTZ0QPXZNPtZEaf/egQ2XmJwBJnhNhoPnnloJn IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bx59720x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 14:55:58 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19QEs6si029466;
        Tue, 26 Oct 2021 14:55:57 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bx59720w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 14:55:57 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19QEldQI018554;
        Tue, 26 Oct 2021 14:55:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3bx4edpq0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 14:55:55 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19QEtqXr60096922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 14:55:52 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73B8242041;
        Tue, 26 Oct 2021 14:55:52 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 072B342049;
        Tue, 26 Oct 2021 14:55:52 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.93])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 Oct 2021 14:55:51 +0000 (GMT)
Date:   Tue, 26 Oct 2021 16:55:49 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 2/2] s390x: Test specification
 exceptions during transaction
Message-ID: <20211026165549.18137134@p-imbrenda>
In-Reply-To: <32dfb400-4191-44f8-354e-809fac890b63@linux.vnet.ibm.com>
References: <20211022120156.281567-1-scgl@linux.ibm.com>
        <20211022120156.281567-3-scgl@linux.ibm.com>
        <20211025193012.3be31938@p-imbrenda>
        <32dfb400-4191-44f8-354e-809fac890b63@linux.vnet.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wdEehobYG5_gpyFnbzDJXDmCr5eLUD92
X-Proofpoint-GUID: J0G5_THnQQG-wa7zgtIgUNYxo3Q2pOhc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_04,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110260083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Oct 2021 16:22:40 +0200
Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com> wrote:

> On 10/25/21 19:30, Claudio Imbrenda wrote:
> > On Fri, 22 Oct 2021 14:01:56 +0200
> > Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> >   
> >> Program interruptions during transactional execution cause other
> >> interruption codes.
> >> Check that we see the expected code for (some) specification exceptions.
> >>
> >> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> >> ---  
> 
> [...]
> 
> >> +#define TRANSACTION_MAX_RETRIES 5
> >> +
> >> +/* NULL must be passed to __builtin_tbegin via constant, forbid diagnose from
> >> + * being NULL to keep things simple
> >> + */
> >> +static int __attribute__((nonnull))
> >> +with_transaction(void (*trigger)(void), struct __htm_tdb *diagnose)
> >> +{
> >> +	int cc;
> >> +  
> > 
> > if you want to be extra sure, put an assert here (although I'm not sure
> > how nonnull works, I have never seen it before)  
> 
> Ok, with nonnull, the compiler might warn you if you pass NULL.

fair enough

> >   
> >> +	cc = __builtin_tbegin(diagnose);
> >> +	if (cc == _HTM_TBEGIN_STARTED) {
> >> +		trigger();
> >> +		__builtin_tend();
> >> +		return -TRANSACTION_COMPLETED;
> >> +	} else {
> >> +		return -cc;
> >> +	}
> >> +}
> >> +
> >> +static int retry_transaction(const struct spec_ex_trigger *trigger, unsigned int max_retries,
> >> +			     struct __htm_tdb *tdb, uint16_t expected_pgm)
> >> +{
> >> +	int trans_result, i;
> >> +	uint16_t pgm;
> >> +
> >> +	for (i = 0; i < max_retries; i++) {
> >> +		expect_pgm_int();
> >> +		trans_result = with_transaction(trigger->func, tdb);
> >> +		if (trans_result == -_HTM_TBEGIN_TRANSIENT) {
> >> +			mb();
> >> +			pgm = lc->pgm_int_code;
> >> +			if (pgm == 0)
> >> +				continue;
> >> +			else if (pgm == expected_pgm)
> >> +				return 0;
> >> +		}
> >> +		return trans_result;
> >> +	}
> >> +	return -TRANSACTION_MAX_RETRIES;  
> > 
> > so this means that a test will be considered failed if the transaction
> > failed too many times?  
> 
> Yes.
> > 
> > this means that could fail if the test is run on busy system, even if
> > the host running the unit test is correct  
> 
> I suppose so, don't know how likely that is.

I don't like the idea of failing a test when the implementation is
correct, just because the system might be a little more busy than
expected.

if you can't find a way to refactor the test so that it doesn't fail if
there are too many retries, then at least make it a skip?

but I'd really like to see something that does not fail on a correctly
implemented system just because the test machine was too busy.

> > 
> > also, do you really need to use negative values? it's probably easier
> > to read if you stick to positive values, and less prone to mistakes if
> > you accidentally forget a - somewhere.  
> 
> Ok.
> >   
> >> +}
> >> +
> >> +static void test_spec_ex_trans(struct args *args, const struct spec_ex_trigger *trigger)
> >> +{
> >> +	const uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION
> >> +			      | PGM_INT_CODE_TX_ABORTED_EVENT;
> >> +	union {
> >> +		struct __htm_tdb tdb;
> >> +		uint64_t dwords[sizeof(struct __htm_tdb) / sizeof(uint64_t)];
> >> +	} diag;
> >> +	unsigned int i, failures = 0;
> >> +	int trans_result;
> >> +
> >> +	if (!test_facility(73)) {
> >> +		report_skip("transactional-execution facility not installed");
> >> +		return;
> >> +	}
> >> +	ctl_set_bit(0, CTL0_TRANSACT_EX_CTL); /* enable transactional-exec */
> >> +
> >> +	for (i = 0; i < args->iterations && failures <= args->max_failures; i++) {
> >> +		register_pgm_cleanup_func(trigger->fixup);
> >> +		trans_result = retry_transaction(trigger, args->max_retries, &diag.tdb, expected_pgm);  
> > 
> > so you retry each iteration up to args->max_retries times, and if a
> > transaction aborts too many times (maybe because the host system is
> > very busy), then you consider it a fail
> >   
> 
> [...]

