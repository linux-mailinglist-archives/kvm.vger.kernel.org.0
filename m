Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364CE4D072B
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 20:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241909AbiCGTEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 14:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237523AbiCGTEq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 14:04:46 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4DB6E4FD;
        Mon,  7 Mar 2022 11:03:51 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227J1eRt030622;
        Mon, 7 Mar 2022 19:03:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=sPfKpKHEyLW2jMgLS8m3sRhl6qac+M+l40gOhC4dmtA=;
 b=YgR30NpJHj53gVzcLVOz4xkTdQn5Lach52EAGdidf4XJ6vQROySqTtgxqwzb7nT8Y1yH
 M/d2/AcwmugAm0YOpKm6tCgjC6JHrWTxCz9DfVvPSXulEstCx/S4Zg/5FwWu94XE84Ow
 IJSVpAVus/LbwalodrnFsAi+qAqW0M19ZdCuKIhBytwcyZBVHe3i6XwZcNkclvFq2S1e
 tt4Ptvun26+1223cDfL0Bdc4tQyGvq9VcWXwE5Ieq/vOtaN/tOTbKDsISNcnbBPX0fwW
 Ax8xObPYuI1avxYXNW8xRwS9ziq81RhboHZ7jn/R+0lPGfXbdTqUln+3twnaytqonP2c LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3end6g65dg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 19:03:50 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 227J32Qt009699;
        Mon, 7 Mar 2022 19:03:50 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3end6g65da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 19:03:50 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 227J2APj000866;
        Mon, 7 Mar 2022 19:03:49 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03dal.us.ibm.com with ESMTP id 3emy8gsgfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 19:03:49 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 227J3mIQ56754476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Mar 2022 19:03:48 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D2A6112063;
        Mon,  7 Mar 2022 19:03:48 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6CCE112062;
        Mon,  7 Mar 2022 19:03:46 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.148.123])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  7 Mar 2022 19:03:46 +0000 (GMT)
Message-ID: <2066eb382d42a27db9417ea47d79f2fbee0a2af0.camel@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests v1 4/6] s390x: smp: Create and use a
 non-waiting CPU stop
From:   Eric Farman <farman@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Mon, 07 Mar 2022 14:03:45 -0500
In-Reply-To: <20220307163007.0213714e@p-imbrenda>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
         <20220303210425.1693486-5-farman@linux.ibm.com>
         <20220307163007.0213714e@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FCoKtFZVAh4-Fm90u0522DlLz_shSL9Q
X-Proofpoint-GUID: OtmzEOp1bCTROyZFjLSkCh6McJgU-ENc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_10,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070106
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-03-07 at 16:30 +0100, Claudio Imbrenda wrote:
> On Thu,  3 Mar 2022 22:04:23 +0100
> Eric Farman <farman@linux.ibm.com> wrote:
> 
> > When stopping a CPU, kvm-unit-tests serializes/waits for everything
> > to finish, in order to get a consistent result whenever those
> > functions are used.
> > 
> > But to test the SIGP STOP itself, these additional measures could
> > mask other problems. For example, did the STOP work, or is the CPU
> > still operating?
> > 
> > Let's create a non-waiting SIGP STOP and use it here, to ensure
> > that
> > the CPU is correctly stopped. A smp_cpu_stopped() call will still
> > be used to see that the SIGP STOP has been processed, and the state
> > of the CPU can be used to determine whether the test passes/fails.
> > 
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> >  lib/s390x/smp.c | 25 +++++++++++++++++++++++++
> >  lib/s390x/smp.h |  1 +
> >  s390x/smp.c     | 10 ++--------
> >  3 files changed, 28 insertions(+), 8 deletions(-)
> > 
> > diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> > index 368d6add..84e536e8 100644
> > --- a/lib/s390x/smp.c
> > +++ b/lib/s390x/smp.c
> > @@ -119,6 +119,31 @@ int smp_cpu_stop(uint16_t idx)
> >  	return rc;
> >  }
> >  
> > +/*
> > + * Functionally equivalent to smp_cpu_stop(), but without the
> > + * elements that wait/serialize matters itself.
> > + * Used to see if KVM itself is serialized correctly.
> > + */
> > +int smp_cpu_stop_nowait(uint16_t idx)
> > +{
> > +	/* refuse to work on the boot CPU */
> > +	if (idx == 0)
> > +		return -1;
> > +
> > +	spin_lock(&lock);
> > +
> > +	/* Don't suppress a CC2 with sigp_retry() */
> > +	if (smp_sigp(idx, SIGP_STOP, 0, NULL)) {
> > +		spin_unlock(&lock);
> > +		return -1;
> > +	}
> > +
> > +	cpus[idx].active = false;
> > +	spin_unlock(&lock);
> > +
> > +	return 0;
> > +}
> > +
> >  int smp_cpu_stop_store_status(uint16_t idx)
> >  {
> >  	int rc;
> > diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
> > index 1e69a7de..bae03dfd 100644
> > --- a/lib/s390x/smp.h
> > +++ b/lib/s390x/smp.h
> > @@ -44,6 +44,7 @@ bool smp_sense_running_status(uint16_t idx);
> >  int smp_cpu_restart(uint16_t idx);
> >  int smp_cpu_start(uint16_t idx, struct psw psw);
> >  int smp_cpu_stop(uint16_t idx);
> > +int smp_cpu_stop_nowait(uint16_t idx);
> >  int smp_cpu_stop_store_status(uint16_t idx);
> >  int smp_cpu_destroy(uint16_t idx);
> >  int smp_cpu_setup(uint16_t idx, struct psw psw);
> > diff --git a/s390x/smp.c b/s390x/smp.c
> > index 50811bd0..11c2c673 100644
> > --- a/s390x/smp.c
> > +++ b/s390x/smp.c
> > @@ -76,14 +76,8 @@ static void test_restart(void)
> >  
> >  static void test_stop(void)
> >  {
> > -	smp_cpu_stop(1);
> > -	/*
> > -	 * The smp library waits for the CPU to shut down, but let's
> > -	 * also do it here, so we don't rely on the library
> > -	 * implementation
> > -	 */
> > -	while (!smp_cpu_stopped(1)) {}
> > -	report_pass("stop");
> > +	smp_cpu_stop_nowait(1);
> 
> can it happen that the SIGP STOP order is accepted, but the target
> CPU
> is still running (and not even busy)?

Of course. A SIGP that's processed by userspace (which is many of them)
injects a STOP IRQ back to the kernel, which means the CPU might not be
stopped for some time. But...

> 
> > +	report(smp_cpu_stopped(1), "stop");
> 
> e.g. can this ^ check race with the actual stopping of the CPU?

...the smp_cpu_stopped() routine now loops on the CC2 that SIGP SENSE
returns because of that pending IRQ. If SIGP SENSE returns CC0/1, then
the CPU can correctly be identified stopped/operating, and the test can
correctly pass/fail.

> 
> >  }
> >  
> >  static void test_stop_store_status(void)

