Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3CA04D2329
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 22:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350339AbiCHVTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 16:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234950AbiCHVTU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 16:19:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DF547576;
        Tue,  8 Mar 2022 13:18:22 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228KeF43017861;
        Tue, 8 Mar 2022 21:18:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=0otWy61A4HHa5Gm40+RSCj99Ylge/sVe9ZMO6TK24zc=;
 b=aG8z5s3tndto8o2VfqnnOmYgA/XHEElzwNJH4o5bo/MzB494SPh4k3qF5LSmRtH2+GAK
 VNGo5NFB9FF4TMY9igz1G1AgvLhEOjo0QUczSImv0spJ3jMh0rOXHJTSc4gKERsgn0Kg
 9DVeWHxKCZTOR0rXkiSPl+xnIMsTUjMZZl0GlaOdwSQOcjCVgYmtCqvZEaBepTAuVsGz
 HtPlnT+O2wCN/gJxR0yrZv0zfMVPDjJg4cNGeclj1TjogOc5voBtuFXTWcU6voe++wd8
 +ddsNxo0ppYQaGZQyrF6EQXF8d3N7RMZfYhSr6e6aYd/0oeEM+IVyMJvk6DxeIrWlnbM Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3entt8gqt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 21:18:21 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 228L1LGX029780;
        Tue, 8 Mar 2022 21:18:21 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3entt8gqsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 21:18:21 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 228LH1nE018020;
        Tue, 8 Mar 2022 21:18:20 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 3ekyg9qr5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 21:18:20 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 228LII5f36897146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Mar 2022 21:18:18 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E6AC6E04E;
        Tue,  8 Mar 2022 21:18:18 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56AFC6E053;
        Tue,  8 Mar 2022 21:18:17 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.148.123])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  8 Mar 2022 21:18:17 +0000 (GMT)
Message-ID: <555b6644b4a1003991f778a6b3e2ba12962d1571.camel@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests v1 4/6] s390x: smp: Create and use a
 non-waiting CPU stop
From:   Eric Farman <farman@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Tue, 08 Mar 2022 16:18:16 -0500
In-Reply-To: <20220308113155.24c7a5f4@p-imbrenda>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
         <20220303210425.1693486-5-farman@linux.ibm.com>
         <20220307163007.0213714e@p-imbrenda>
         <2066eb382d42a27db9417ea47d79f2fbee0a2af0.camel@linux.ibm.com>
         <20220308113155.24c7a5f4@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: w5CvsnnMmCmXMeffLbNA_-LqZSaGDNlQ
X-Proofpoint-ORIG-GUID: cPqcVLE3CB09NF14tpwCJXFFbPey7hWt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_08,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203080107
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-08 at 11:31 +0100, Claudio Imbrenda wrote:
> On Mon, 07 Mar 2022 14:03:45 -0500
> Eric Farman <farman@linux.ibm.com> wrote:
> 
> > On Mon, 2022-03-07 at 16:30 +0100, Claudio Imbrenda wrote:
> > > On Thu,  3 Mar 2022 22:04:23 +0100
> > > Eric Farman <farman@linux.ibm.com> wrote:
> > >   
> > > > When stopping a CPU, kvm-unit-tests serializes/waits for
> > > > everything
> > > > to finish, in order to get a consistent result whenever those
> > > > functions are used.
> > > > 
> > > > But to test the SIGP STOP itself, these additional measures
> > > > could
> > > > mask other problems. For example, did the STOP work, or is the
> > > > CPU
> > > > still operating?
> > > > 
> > > > Let's create a non-waiting SIGP STOP and use it here, to ensure
> > > > that
> > > > the CPU is correctly stopped. A smp_cpu_stopped() call will
> > > > still
> > > > be used to see that the SIGP STOP has been processed, and the
> > > > state
> > > > of the CPU can be used to determine whether the test
> > > > passes/fails.
> > > > 
> > > > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > > > ---
> > > >  lib/s390x/smp.c | 25 +++++++++++++++++++++++++
> > > >  lib/s390x/smp.h |  1 +
> > > >  s390x/smp.c     | 10 ++--------
> > > >  3 files changed, 28 insertions(+), 8 deletions(-)
> > > > 
> > > > diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> > > > index 368d6add..84e536e8 100644
> > > > --- a/lib/s390x/smp.c
> > > > +++ b/lib/s390x/smp.c
> > > > @@ -119,6 +119,31 @@ int smp_cpu_stop(uint16_t idx)
> > > >  	return rc;
> > > >  }
> > > >  
> > > > +/*
> > > > + * Functionally equivalent to smp_cpu_stop(), but without the
> > > > + * elements that wait/serialize matters itself.
> > > > + * Used to see if KVM itself is serialized correctly.
> > > > + */
> > > > +int smp_cpu_stop_nowait(uint16_t idx)
> > > > +{
> > > > +	/* refuse to work on the boot CPU */
> > > > +	if (idx == 0)
> > > > +		return -1;
> > > > +
> > > > +	spin_lock(&lock);
> > > > +
> > > > +	/* Don't suppress a CC2 with sigp_retry() */
> > > > +	if (smp_sigp(idx, SIGP_STOP, 0, NULL)) {
> > > > +		spin_unlock(&lock);
> > > > +		return -1;
> > > > +	}
> > > > +
> > > > +	cpus[idx].active = false;
> > > > +	spin_unlock(&lock);
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  int smp_cpu_stop_store_status(uint16_t idx)
> > > >  {
> > > >  	int rc;
> > > > diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
> > > > index 1e69a7de..bae03dfd 100644
> > > > --- a/lib/s390x/smp.h
> > > > +++ b/lib/s390x/smp.h
> > > > @@ -44,6 +44,7 @@ bool smp_sense_running_status(uint16_t idx);
> > > >  int smp_cpu_restart(uint16_t idx);
> > > >  int smp_cpu_start(uint16_t idx, struct psw psw);
> > > >  int smp_cpu_stop(uint16_t idx);
> > > > +int smp_cpu_stop_nowait(uint16_t idx);
> > > >  int smp_cpu_stop_store_status(uint16_t idx);
> > > >  int smp_cpu_destroy(uint16_t idx);
> > > >  int smp_cpu_setup(uint16_t idx, struct psw psw);
> > > > diff --git a/s390x/smp.c b/s390x/smp.c
> > > > index 50811bd0..11c2c673 100644
> > > > --- a/s390x/smp.c
> > > > +++ b/s390x/smp.c
> > > > @@ -76,14 +76,8 @@ static void test_restart(void)
> > > >  
> > > >  static void test_stop(void)
> > > >  {
> > > > -	smp_cpu_stop(1);
> > > > -	/*
> > > > -	 * The smp library waits for the CPU to shut down, but
> > > > let's
> > > > -	 * also do it here, so we don't rely on the library
> > > > -	 * implementation
> > > > -	 */
> > > > -	while (!smp_cpu_stopped(1)) {}
> > > > -	report_pass("stop");
> > > > +	smp_cpu_stop_nowait(1);  
> > > 
> > > can it happen that the SIGP STOP order is accepted, but the
> > > target
> > > CPU
> > > is still running (and not even busy)?  
> > 
> > Of course. A SIGP that's processed by userspace (which is many of
> > them)
> > injects a STOP IRQ back to the kernel, which means the CPU might
> > not be
> > stopped for some time. But...
> > 
> > >   
> > > > +	report(smp_cpu_stopped(1), "stop");  
> > > 
> > > e.g. can this ^ check race with the actual stopping of the CPU?  
> > 
> > ...the smp_cpu_stopped() routine now loops on the CC2 that SIGP
> > SENSE
> > returns because of that pending IRQ. If SIGP SENSE returns CC0/1,
> > then
> > the CPU can correctly be identified stopped/operating, and the test
> > can
> > correctly pass/fail.
> 
> my question was: is it possible architecturally that there is a
> window
> where the STOP order is accepted, but a SENSE on the target CPU still
> successfully returns that the CPU is running?

Not to my knowledge. The "Conditions Determining Response" section of
POPS (v12, page 4-95; also below) specifically states that the SIGP
SENSE will return CC2 when a SIGP STOP order is outstanding.

In our implementation, the stop IRQ will be injected before the STOP
order gets accepted, such that a SIGP SENSE would see it immediately.

"""
A previously issued start, stop, restart, stop-
and-store-status, set-prefix, store-status-at-
address order, or store-additional-status-at-
address has been accepted by the
addressed CPU, and execution of the func-
tion requested by the order has not yet been
completed.
...
If the currently specified order is sense, external
call, emergency signal, start, stop, restart, stop
and store status, set prefix, store status at
address, set architecture, set multithreading, or
store additional status at address, then the order
is rejected, and condition code 2 is set.
"""

> 
> in other words: is it specified architecturally that, once an order
> is
> accepted for a target CPU, that CPU can't accept any other order (and
> will return CC2), including SENSE, until the order has been completed
> successfully?

The POPS quote I placed above excludes store-extended-status-address,
conditional-emergency-signal, and sense-running-status orders as
returning a CC2. That's something Janosch and I have chatted about
offline, but don't have an answer to at this time. Besides that, any
other order would get a CC2 until the STOP has been completed.

> 
> > >   
> > > >  }
> > > >  
> > > >  static void test_stop_store_status(void)  

