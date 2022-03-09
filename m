Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0069C4D2BE9
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 10:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbiCIJ2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 04:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbiCIJ2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 04:28:49 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B1AEACA9;
        Wed,  9 Mar 2022 01:27:50 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2297AxTU007486;
        Wed, 9 Mar 2022 09:27:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=iiUjcAi2ykvAKHr+OQ67IHswc70CxDzOeKzoZ8ZJcJI=;
 b=GHUFdqnFscK75697nlBDrkpXjaNlX63bEYKftPB8bM+qLfTm1qq8TpouCtxVO6HD5MT7
 KC1fzYl0fJgD/q/qozpd2jxuuNTlY5iv1PBoMxIKLFjkPuTkwG5fmcNgY2X+EIJTtbdb
 SfwoWXPOvSQ0nbF7V3zqTlLfWEwLayREhzhnRA4+20QpFPMRFKyXEA9+6xPq+3SMdwh6
 YrKHmPX7UtBBj1t3jt1ZMCJJfh7qq2E4PGeTCKFza6ngtRj5p0+T/g4gS6B3/h986YdI
 T3AxhKYJAZIiXYTWpBB9dOdt//vn19+zSPK/gNrYt9BHhNAWl/hbLd0mqDfh4/iDAmK+ sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3env4uu2j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Mar 2022 09:27:49 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2299Jb3d000390;
        Wed, 9 Mar 2022 09:27:49 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3env4uu2hq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Mar 2022 09:27:49 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2299Bxwq025895;
        Wed, 9 Mar 2022 09:27:46 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3enqgnm8ux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Mar 2022 09:27:46 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2299Rhp841222428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Mar 2022 09:27:43 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7048E42045;
        Wed,  9 Mar 2022 09:27:43 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17C364203F;
        Wed,  9 Mar 2022 09:27:43 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.106])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Mar 2022 09:27:43 +0000 (GMT)
Date:   Wed, 9 Mar 2022 10:27:39 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests v1 4/6] s390x: smp: Create and use a
 non-waiting CPU stop
Message-ID: <20220309102739.3078e551@p-imbrenda>
In-Reply-To: <555b6644b4a1003991f778a6b3e2ba12962d1571.camel@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
        <20220303210425.1693486-5-farman@linux.ibm.com>
        <20220307163007.0213714e@p-imbrenda>
        <2066eb382d42a27db9417ea47d79f2fbee0a2af0.camel@linux.ibm.com>
        <20220308113155.24c7a5f4@p-imbrenda>
        <555b6644b4a1003991f778a6b3e2ba12962d1571.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -q3e87MjMqo5JnvsJi7HZJL1nH9lrsY-
X-Proofpoint-ORIG-GUID: gv8OPoPEaMCorpkKYP0TCLAn6F9fejnK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-09_04,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 08 Mar 2022 16:18:16 -0500
Eric Farman <farman@linux.ibm.com> wrote:

> On Tue, 2022-03-08 at 11:31 +0100, Claudio Imbrenda wrote:
> > On Mon, 07 Mar 2022 14:03:45 -0500
> > Eric Farman <farman@linux.ibm.com> wrote:
> >   
> > > On Mon, 2022-03-07 at 16:30 +0100, Claudio Imbrenda wrote:  
> > > > On Thu,  3 Mar 2022 22:04:23 +0100
> > > > Eric Farman <farman@linux.ibm.com> wrote:
> > > >     
> > > > > When stopping a CPU, kvm-unit-tests serializes/waits for
> > > > > everything
> > > > > to finish, in order to get a consistent result whenever those
> > > > > functions are used.
> > > > > 
> > > > > But to test the SIGP STOP itself, these additional measures
> > > > > could
> > > > > mask other problems. For example, did the STOP work, or is the
> > > > > CPU
> > > > > still operating?
> > > > > 
> > > > > Let's create a non-waiting SIGP STOP and use it here, to ensure
> > > > > that
> > > > > the CPU is correctly stopped. A smp_cpu_stopped() call will
> > > > > still
> > > > > be used to see that the SIGP STOP has been processed, and the
> > > > > state
> > > > > of the CPU can be used to determine whether the test
> > > > > passes/fails.
> > > > > 
> > > > > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > > > > ---
> > > > >  lib/s390x/smp.c | 25 +++++++++++++++++++++++++
> > > > >  lib/s390x/smp.h |  1 +
> > > > >  s390x/smp.c     | 10 ++--------
> > > > >  3 files changed, 28 insertions(+), 8 deletions(-)
> > > > > 
> > > > > diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> > > > > index 368d6add..84e536e8 100644
> > > > > --- a/lib/s390x/smp.c
> > > > > +++ b/lib/s390x/smp.c
> > > > > @@ -119,6 +119,31 @@ int smp_cpu_stop(uint16_t idx)
> > > > >  	return rc;
> > > > >  }
> > > > >  
> > > > > +/*
> > > > > + * Functionally equivalent to smp_cpu_stop(), but without the
> > > > > + * elements that wait/serialize matters itself.
> > > > > + * Used to see if KVM itself is serialized correctly.
> > > > > + */
> > > > > +int smp_cpu_stop_nowait(uint16_t idx)
> > > > > +{
> > > > > +	/* refuse to work on the boot CPU */
> > > > > +	if (idx == 0)
> > > > > +		return -1;
> > > > > +
> > > > > +	spin_lock(&lock);
> > > > > +
> > > > > +	/* Don't suppress a CC2 with sigp_retry() */
> > > > > +	if (smp_sigp(idx, SIGP_STOP, 0, NULL)) {
> > > > > +		spin_unlock(&lock);
> > > > > +		return -1;
> > > > > +	}
> > > > > +
> > > > > +	cpus[idx].active = false;
> > > > > +	spin_unlock(&lock);
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > >  int smp_cpu_stop_store_status(uint16_t idx)
> > > > >  {
> > > > >  	int rc;
> > > > > diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
> > > > > index 1e69a7de..bae03dfd 100644
> > > > > --- a/lib/s390x/smp.h
> > > > > +++ b/lib/s390x/smp.h
> > > > > @@ -44,6 +44,7 @@ bool smp_sense_running_status(uint16_t idx);
> > > > >  int smp_cpu_restart(uint16_t idx);
> > > > >  int smp_cpu_start(uint16_t idx, struct psw psw);
> > > > >  int smp_cpu_stop(uint16_t idx);
> > > > > +int smp_cpu_stop_nowait(uint16_t idx);
> > > > >  int smp_cpu_stop_store_status(uint16_t idx);
> > > > >  int smp_cpu_destroy(uint16_t idx);
> > > > >  int smp_cpu_setup(uint16_t idx, struct psw psw);
> > > > > diff --git a/s390x/smp.c b/s390x/smp.c
> > > > > index 50811bd0..11c2c673 100644
> > > > > --- a/s390x/smp.c
> > > > > +++ b/s390x/smp.c
> > > > > @@ -76,14 +76,8 @@ static void test_restart(void)
> > > > >  
> > > > >  static void test_stop(void)
> > > > >  {
> > > > > -	smp_cpu_stop(1);
> > > > > -	/*
> > > > > -	 * The smp library waits for the CPU to shut down, but
> > > > > let's
> > > > > -	 * also do it here, so we don't rely on the library
> > > > > -	 * implementation
> > > > > -	 */
> > > > > -	while (!smp_cpu_stopped(1)) {}
> > > > > -	report_pass("stop");
> > > > > +	smp_cpu_stop_nowait(1);    
> > > > 
> > > > can it happen that the SIGP STOP order is accepted, but the
> > > > target
> > > > CPU
> > > > is still running (and not even busy)?    
> > > 
> > > Of course. A SIGP that's processed by userspace (which is many of
> > > them)
> > > injects a STOP IRQ back to the kernel, which means the CPU might
> > > not be
> > > stopped for some time. But...
> > >   
> > > >     
> > > > > +	report(smp_cpu_stopped(1), "stop");    
> > > > 
> > > > e.g. can this ^ check race with the actual stopping of the CPU?    
> > > 
> > > ...the smp_cpu_stopped() routine now loops on the CC2 that SIGP
> > > SENSE
> > > returns because of that pending IRQ. If SIGP SENSE returns CC0/1,
> > > then
> > > the CPU can correctly be identified stopped/operating, and the test
> > > can
> > > correctly pass/fail.  
> > 
> > my question was: is it possible architecturally that there is a
> > window
> > where the STOP order is accepted, but a SENSE on the target CPU still
> > successfully returns that the CPU is running?  
> 
> Not to my knowledge. The "Conditions Determining Response" section of
> POPS (v12, page 4-95; also below) specifically states that the SIGP
> SENSE will return CC2 when a SIGP STOP order is outstanding.
> 
> In our implementation, the stop IRQ will be injected before the STOP
> order gets accepted, such that a SIGP SENSE would see it immediately.
> 
> """
> A previously issued start, stop, restart, stop-
> and-store-status, set-prefix, store-status-at-
> address order, or store-additional-status-at-
> address has been accepted by the
> addressed CPU, and execution of the func-
> tion requested by the order has not yet been
> completed.
> ...
> If the currently specified order is sense, external
> call, emergency signal, start, stop, restart, stop
> and store status, set prefix, store status at
> address, set architecture, set multithreading, or
> store additional status at address, then the order
> is rejected, and condition code 2 is set.
> """
> 
> > 
> > in other words: is it specified architecturally that, once an order
> > is
> > accepted for a target CPU, that CPU can't accept any other order (and
> > will return CC2), including SENSE, until the order has been completed
> > successfully?  
> 
> The POPS quote I placed above excludes store-extended-status-address,
> conditional-emergency-signal, and sense-running-status orders as
> returning a CC2. That's something Janosch and I have chatted about
> offline, but don't have an answer to at this time. Besides that, any
> other order would get a CC2 until the STOP has been completed.

this is what I wanted to know, thanks

you can add

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>


> 
> >   
> > > >     
> > > > >  }
> > > > >  
> > > > >  static void test_stop_store_status(void)    
> 

