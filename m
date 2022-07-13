Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093545736D7
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 15:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbiGMNHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 09:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235790AbiGMNHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 09:07:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1108F;
        Wed, 13 Jul 2022 06:07:16 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DCwa2h012353;
        Wed, 13 Jul 2022 13:07:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0BCCtbZk8N5BljwI+eRMc1UYfOnogER6gDpOOzIX9h0=;
 b=jEbGZOghPgHGzILH3nbCpp1Ww9MJevxHvd8HwqqlYwv5xGUdI90OAzkAJVL1cCkmOTGj
 oyILBVS4zbFqibDf/zZPkcZd8vjqDjonu1q1j+vz8VB473efMDQJkq++DGVAkPhhkpaM
 +wKdBwMK+RLwDpOgzLclc/DKMqPn+8aLpqrBULOXN4eMnH9whMIMc59WI7xj2d/2DtxP
 kSPxicZMVfZzBN5XyEgxlNXauj6cRhTbCz3fCB2VaDagLU9YVcpx01l2yS1nLL5hLw48
 cifEyKqGFs5DpBIUxzWlwBQTRgxv31vo/AAL0aov/PL/30sljCT8y/hJNb1FMhwkeIs/ 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9w6aanx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 13:07:16 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26DD0muP013044;
        Wed, 13 Jul 2022 13:07:16 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9w6aanvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 13:07:16 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26DCnZRQ027903;
        Wed, 13 Jul 2022 13:07:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3h71a8v9ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 13:07:13 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26DD7LCd30015764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 13:07:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 785D94C04A;
        Wed, 13 Jul 2022 13:07:10 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 211E74C044;
        Wed, 13 Jul 2022 13:07:10 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.75])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jul 2022 13:07:10 +0000 (GMT)
Date:   Wed, 13 Jul 2022 15:07:07 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        scgl@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 3/3] lib: s390x: better smp interrupt
 checks
Message-ID: <20220713150707.5b5e9825@p-imbrenda>
In-Reply-To: <36962c60-a7db-a5f6-2ecf-c7dcc0152e74@linux.ibm.com>
References: <20220713104557.168113-1-imbrenda@linux.ibm.com>
        <20220713104557.168113-4-imbrenda@linux.ibm.com>
        <36962c60-a7db-a5f6-2ecf-c7dcc0152e74@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0Ag2qdeJv4d6Kx6vPtzMUhngXhwAsrEI
X-Proofpoint-ORIG-GUID: hZnNwGkcLJnEVYWuVPoRVODMMgUsGCQc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-13_01,2022-07-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 spamscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0 bulkscore=0
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207130053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Jul 2022 14:24:57 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 7/13/22 12:45, Claudio Imbrenda wrote:
> > Use per-CPU flags and callbacks for Program and Extern interrupts,
> > instead of global variables.
> > 
> > This allows for more accurate error handling; a CPU waiting for an
> > interrupt will not have it "stolen" by a different CPU that was not
> > supposed to wait for one, and now two CPUs can wait for interrupts at
> > the same time.
> > 
> > This will significantly improve error reporting and debugging when
> > things go wrong.
> > 
> > Both program interrupts and external interrupts are now CPU-bound, even
> > though some external interrupts are floating (notably, the SCLP
> > interrupt). In those cases, the testcases should mask interrupts and/or
> > expect them appropriately according to need.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   lib/s390x/asm/arch_def.h | 16 ++++++++++-
> >   lib/s390x/smp.h          |  8 +-----
> >   lib/s390x/interrupt.c    | 57 +++++++++++++++++++++++++++++-----------
> >   lib/s390x/smp.c          | 11 ++++++++
> >   4 files changed, 69 insertions(+), 23 deletions(-)
> > 
> > diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> > index b3282367..03578277 100644
> > --- a/lib/s390x/asm/arch_def.h
> > +++ b/lib/s390x/asm/arch_def.h
> > @@ -41,6 +41,17 @@ struct psw {
> >   	uint64_t	addr;
> >   };
> >   
> > +struct cpu {
> > +	struct lowcore *lowcore;
> > +	uint64_t *stack;
> > +	void (*pgm_cleanup_func)(void);  
> 
> We should change the parameter to include the stack frame for easier 
> manipulation of the pre-exception registers, especially the CRs.

will do

> 
> > +	uint16_t addr;
> > +	uint16_t idx;
> > +	bool active;
> > +	bool pgm_int_expected;
> > +	bool ext_int_expected;
> > +};  
> 
> And I'd opt for also integrating the io handling function and getting 
> rid of the unset function to make them all look the same.

I/O is usually floating, though, I don't think it makes sense to have
it per-cpu

> 
> Looking at Nico's patches the external handler will follow soon anyway.

should I add the external handler here?

> 
> 
> I'm not 100% happy with having this struct in this file, what kept you 
> from including smp.h?

smp.h depends on arch_def.h, which then would depend on smp.h

> 
> > +struct lowcore *smp_get_lowcore(uint16_t idx)
> > +{
> > +	if (THIS_CPU->idx == idx)
> > +		return &lowcore;
> > +
> > +	check_idx(idx);
> > +	return cpus[idx].lowcore;
> > +}  
> 
> I'm waiting for the moment where we need locking in the struct cpu.
> 
> > +
> >   int smp_sigp(uint16_t idx, uint8_t order, unsigned long parm, uint32_t *status)
> >   {
> >   	check_idx(idx);
> > @@ -253,6 +262,7 @@ static int smp_cpu_setup_nolock(uint16_t idx, struct psw psw)
> >   
> >   	/* Copy all exception psws. */
> >   	memcpy(lc, cpus[0].lowcore, 512);
> > +	lc->this_cpu = &cpus[idx];
> >   
> >   	/* Setup stack */
> >   	cpus[idx].stack = (uint64_t *)alloc_pages(2);
> > @@ -325,6 +335,7 @@ void smp_setup(void)
> >   	for (i = 0; i < num; i++) {
> >   		cpus[i].addr = entry[i].address;
> >   		cpus[i].active = false;
> > +		cpus[i].idx = i;
> >   		/*
> >   		 * Fill in the boot CPU. If the boot CPU is not at index 0,
> >   		 * swap it with the one at index 0. This guarantees that the  
> 

