Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD57E64C733
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 11:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237757AbiLNKeM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 05:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiLNKeJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 05:34:09 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD3D1EAEE
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 02:34:07 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BE9wiZA005597;
        Wed, 14 Dec 2022 10:34:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=kPcXrygndSb/4NTs69q/NXjOrhF5JSg9EX6pHRxuIWo=;
 b=g+rwxEqPW7qvPiH7SE6Wj1EiqYUQHtBPrj0KJpxgX6Y6Wc8qq1ttpVLlNFte9X7yIlZ9
 Dr/5+OLqfwI9w4HfsHG1bA1YXY/+L8A6kRIYNqxf/cLnE05YfHT0m7EgMfZ92cCpYZEM
 sIMBCvEIBenzLYMj4IZGXYHMBIKZKLtKwzAB54NofS1bedIadK3z0pt36T7YGreqK1SO
 76Z71D/G9FHuRXNepHV3Z9EFCKLr1Afb3fauAMmKj7NqKT1EXi25gjhdzGTrWA0Sqz95
 sLraK5nyMkYcIWjjgqG8H0UFF2UhyFxhxTTBKIv8yA+mLAPvJYgZPmymPRcd+cifXIRR 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mfcb4gwrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 10:34:03 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BEARCM6004627;
        Wed, 14 Dec 2022 10:34:03 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mfcb4gwpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 10:34:03 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEA9UOL001267;
        Wed, 14 Dec 2022 10:33:59 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3meyyegwwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 10:33:59 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BEAXuf248955754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 10:33:56 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1527D20043;
        Wed, 14 Dec 2022 10:33:56 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEC3D20040;
        Wed, 14 Dec 2022 10:33:55 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 14 Dec 2022 10:33:55 +0000 (GMT)
Date:   Wed, 14 Dec 2022 11:33:54 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Alex =?UTF-8?B?QmVubsOpZQ==?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 11/27] lib: Add random number
 generator
Message-ID: <20221214113354.46a6a505@p-imbrenda>
In-Reply-To: <f27f5791caaf01d379027c6802fdeb953bd59c22.camel@redhat.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
        <20221122161152.293072-12-mlevitsk@redhat.com>
        <20221123102850.08df4bd9@p-imbrenda>
        <f27f5791caaf01d379027c6802fdeb953bd59c22.camel@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uO7wWTbkRf_89wrLmtM2Ob7D1CsuzK5R
X-Proofpoint-ORIG-GUID: L4oINMBDU4e2wirzgi5qMZFA5bp_6ePO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_04,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 impostorscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 06 Dec 2022 16:07:39 +0200
Maxim Levitsky <mlevitsk@redhat.com> wrote:

> On Wed, 2022-11-23 at 10:28 +0100, Claudio Imbrenda wrote:
> > On Tue, 22 Nov 2022 18:11:36 +0200
> > Maxim Levitsky <mlevitsk@redhat.com> wrote:
> >   
> > > Add a simple pseudo random number generator which can be used
> > > in the tests to add randomeness in a controlled manner.  
> > 
> > ahh, yes I have wanted something like this in the library for quite some
> > time! thanks!
> > 
> > I have some comments regarding the interfaces (see below), and also a
> > request, if you could split the x86 part in a different patch, so we
> > can have a "pure" lib patch, and then you can have an x86-only patch
> > that uses the new interface
> >   
> > > For x86 add a wrapper which initializes the PRNG with RDRAND,
> > > unless RANDOM_SEED env variable is set, in which case it is used
> > > instead.
> > > 
> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > ---
> > >  Makefile              |  3 ++-
> > >  README.md             |  1 +
> > >  lib/prng.c            | 41 +++++++++++++++++++++++++++++++++++++++++
> > >  lib/prng.h            | 23 +++++++++++++++++++++++
> > >  lib/x86/random.c      | 33 +++++++++++++++++++++++++++++++++
> > >  lib/x86/random.h      | 17 +++++++++++++++++
> > >  scripts/arch-run.bash |  2 +-
> > >  x86/Makefile.common   |  1 +
> > >  8 files changed, 119 insertions(+), 2 deletions(-)
> > >  create mode 100644 lib/prng.c
> > >  create mode 100644 lib/prng.h
> > >  create mode 100644 lib/x86/random.c
> > >  create mode 100644 lib/x86/random.h
> > > 
> > > diff --git a/Makefile b/Makefile
> > > index 6ed5deac..384b5acf 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -29,7 +29,8 @@ cflatobjs := \
> > >  	lib/string.o \
> > >  	lib/abort.o \
> > >  	lib/report.o \
> > > -	lib/stack.o
> > > +	lib/stack.o \
> > > +	lib/prng.o
> > >  
> > >  # libfdt paths
> > >  LIBFDT_objdir = lib/libfdt
> > > diff --git a/README.md b/README.md
> > > index 6e82dc22..5a677a03 100644
> > > --- a/README.md
> > > +++ b/README.md
> > > @@ -91,6 +91,7 @@ the framework.  The list of reserved environment variables is below
> > >      QEMU_ACCEL                   either kvm, hvf or tcg
> > >      QEMU_VERSION_STRING          string of the form `qemu -h | head -1`
> > >      KERNEL_VERSION_STRING        string of the form `uname -r`
> > > +    TEST_SEED                    integer to force a fixed seed for the prng
> > >  
> > >  Additionally these self-explanatory variables are reserved
> > >  
> > > diff --git a/lib/prng.c b/lib/prng.c
> > > new file mode 100644
> > > index 00000000..d9342eb3
> > > --- /dev/null
> > > +++ b/lib/prng.c
> > > @@ -0,0 +1,41 @@
> > > +
> > > +/*
> > > + * Random number generator that is usable from guest code. This is the
> > > + * Park-Miller LCG using standard constants.
> > > + */
> > > +
> > > +#include "libcflat.h"
> > > +#include "prng.h"
> > > +
> > > +struct random_state new_random_state(uint32_t seed)
> > > +{
> > > +	struct random_state s = {.seed = seed};
> > > +	return s;
> > > +}
> > > +
> > > +uint32_t random_u32(struct random_state *state)
> > > +{
> > > +	state->seed = (uint64_t)state->seed * 48271 % ((uint32_t)(1 << 31) - 1);  
> > 
> > why not:
> > 
> > state->seed = state->seed * 48271ULL % (BIT_ULL(31) - 1);
> > 
> > I think it's more readable  
> 
> I copied this code vertabium from a patch that was send to in-kernel selftests
> as Sean suggested me to do.

fair enough :)

> 
> I to be honest would have picked some more complex random generator like the
> Mersenne Twister or something like that, since performance is not an issue here,
> and this generator is I think geared toward beeing as fast as possible.

I think that the important thing is that the generator is random enough
to confuse the various branch predictors and prefetchers. If the code
is simple, it's even better, because it's easier to understand.

> 
> But againg I don't care much about this, any source of randomness is better
> that nothing.

exactly

> 
> >   
> > > +	return state->seed;
> > > +}
> > > +
> > > +
> > > +uint32_t random_range(struct random_state *state, uint32_t min, uint32_t max)
> > > +{
> > > +	uint32_t val = random_u32(state);
> > > +
> > > +	return val % (max - min + 1) + min;  
> > 
> > what happens if max == UINT_MAX and min = 0 ?
> > 
> > maybe:
> > 
> > if (max - min == UINT_MAX)
> > 	return val;  
> 
> Makes sense.
> >   
> > > +}
> > > +
> > > +/*
> > > + * Returns true randomly in 'percent_true' cases (e.g if percent_true = 70.0,
> > > + * it will return true in 70.0% of cases)
> > > + */
> > > +bool random_decision(struct random_state *state, float percent_true)  
> > 
> > I'm not a fan of floats in the lib...
> >   
> > > +{
> > > +	if (percent_true == 0)
> > > +		return 0;
> > > +	if (percent_true == 100)
> > > +		return 1;
> > > +	return random_range(state, 1, 10000) < (uint32_t)(percent_true * 100);  
> > 
> > ...especially when you are only using 2 decimal places anyway  
> 
> I was thinking the same about this, there are pros and cons,
> Using a fixed point integer is a bit less usable but overall I don't mind
> using it.

maybe you can add a wrapper macro?

#define RANDOM_DECISION_F(state, percent) \
	random_decision((state), 100 * (percent))

would be functionally equivalent (I think), but only generate fp code
when actually used. (feel free to chose a nicer name for it)

> 
> 
> 
> > 
> > can you rewrite it to take an unsigned int? 
> > e.g. if percent_true = 7123, it will return true in 71.23% of the cases
> > 
> > then you can rewrite the last line like this:
> > 
> > return random_range(state, 1, 10000) < percent_true;
> >   
> > > +}
> > > diff --git a/lib/prng.h b/lib/prng.h
> > > new file mode 100644
> > > index 00000000..61d3a48b
> > > --- /dev/null
> > > +++ b/lib/prng.h
> > > @@ -0,0 +1,23 @@
> > > +
> > > +#ifndef SRC_LIB_PRNG_H_
> > > +#define SRC_LIB_PRNG_H_
> > > +
> > > +struct random_state {
> > > +	uint32_t seed;
> > > +};
> > > +
> > > +struct random_state new_random_state(uint32_t seed);
> > > +uint32_t random_u32(struct random_state *state);
> > > +
> > > +/*
> > > + * return a random number from min to max (included)
> > > + */
> > > +uint32_t random_range(struct random_state *state, uint32_t min, uint32_t max);
> > > +
> > > +/*
> > > + * Returns true randomly in 'percent_true' cases (e.g if percent_true = 70.0,
> > > + * it will return true in 70.0% of cases)
> > > + */
> > > +bool random_decision(struct random_state *state, float percent_true);
> > > +
> > > +#endif /* SRC_LIB_PRNG_H_ */  
> > 
> > and then put the rest below in a new patch  
> 
> No problem. Note that x86 specific bits can be minimized
> but that requires plumbing in several things that you would
> take for granted, and in particular, env vars
> are x86 specific, and apic id is x86 specific.

I'm not sure I understand your point. The lib code above does not depend
on the arch code below, so you can split this into a non-arch patch, and
an arch patch that uses the non-arch patch. I think it's cleaner to not
mix common code and arch code.

> 
> When a random number generator is wired to a new arch,
> this can be fixed.
> 
> Best regards,
> 	Maxim Levitsky
> 
> >   
> > > diff --git a/lib/x86/random.c b/lib/x86/random.c
> > > new file mode 100644
> > > index 00000000..fcdd5fe8
> > > --- /dev/null
> > > +++ b/lib/x86/random.c
> > > @@ -0,0 +1,33 @@
> > > +
> > > +#include "libcflat.h"
> > > +#include "processor.h"
> > > +#include "prng.h"
> > > +#include "smp.h"
> > > +#include "asm/spinlock.h"
> > > +#include "random.h"
> > > +
> > > +static u32 test_seed;
> > > +static bool initialized;
> > > +
> > > +void init_prng(void)
> > > +{
> > > +	char *test_seed_str = getenv("TEST_SEED");
> > > +
> > > +	if (test_seed_str && strlen(test_seed_str))
> > > +		test_seed = atol(test_seed_str);
> > > +	else
> > > +#ifdef __x86_64__
> > > +		test_seed =  (u32)rdrand();
> > > +#else
> > > +		test_seed = (u32)(rdtsc() << 4);
> > > +#endif
> > > +	initialized = true;
> > > +
> > > +	printf("Test seed: %u\n", (unsigned int)test_seed);
> > > +}
> > > +
> > > +struct random_state get_prng(void)
> > > +{
> > > +	assert(initialized);
> > > +	return new_random_state(test_seed + this_cpu_read_smp_id());
> > > +}
> > > diff --git a/lib/x86/random.h b/lib/x86/random.h
> > > new file mode 100644
> > > index 00000000..795b450b
> > > --- /dev/null
> > > +++ b/lib/x86/random.h
> > > @@ -0,0 +1,17 @@
> > > +/*
> > > + * prng.h
> > > + *
> > > + *  Created on: Nov 9, 2022
> > > + *      Author: mlevitsk
> > > + */
> > > +
> > > +#ifndef SRC_LIB_X86_RANDOM_H_
> > > +#define SRC_LIB_X86_RANDOM_H_
> > > +
> > > +#include "libcflat.h"
> > > +#include "prng.h"
> > > +
> > > +void init_prng(void);
> > > +struct random_state get_prng(void);
> > > +
> > > +#endif /* SRC_LIB_X86_RANDOM_H_ */
> > > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > > index 51e4b97b..238d19f8 100644
> > > --- a/scripts/arch-run.bash
> > > +++ b/scripts/arch-run.bash
> > > @@ -298,7 +298,7 @@ env_params ()
> > >  	KERNEL_EXTRAVERSION=${KERNEL_EXTRAVERSION%%[!0-9]*}
> > >  	! [[ $KERNEL_SUBLEVEL =~ ^[0-9]+$ ]] && unset $KERNEL_SUBLEVEL
> > >  	! [[ $KERNEL_EXTRAVERSION =~ ^[0-9]+$ ]] && unset $KERNEL_EXTRAVERSION
> > > -	env_add_params KERNEL_VERSION_STRING KERNEL_VERSION KERNEL_PATCHLEVEL KERNEL_SUBLEVEL KERNEL_EXTRAVERSION
> > > +	env_add_params KERNEL_VERSION_STRING KERNEL_VERSION KERNEL_PATCHLEVEL KERNEL_SUBLEVEL KERNEL_EXTRAVERSION TEST_SEED
> > >  }
> > >  
> > >  env_file ()
> > > diff --git a/x86/Makefile.common b/x86/Makefile.common
> > > index 698a48ab..fa0a50e6 100644
> > > --- a/x86/Makefile.common
> > > +++ b/x86/Makefile.common
> > > @@ -23,6 +23,7 @@ cflatobjs += lib/x86/stack.o
> > >  cflatobjs += lib/x86/fault_test.o
> > >  cflatobjs += lib/x86/delay.o
> > >  cflatobjs += lib/x86/pmu.o
> > > +cflatobjs += lib/x86/random.o
> > >  ifeq ($(CONFIG_EFI),y)
> > >  cflatobjs += lib/x86/amd_sev.o
> > >  cflatobjs += lib/efi.o  
> 
> 

