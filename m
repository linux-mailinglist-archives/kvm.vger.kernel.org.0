Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D7D55C1E6
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbiF0KxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 06:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233895AbiF0KxX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 06:53:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8251B5F97;
        Mon, 27 Jun 2022 03:53:22 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RAhMf2019844;
        Mon, 27 Jun 2022 10:53:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=3IRlnAJYe42MaE8wX20wh84p0BpF0hdTcbnb0R0z344=;
 b=m9eL/xIsW8W4C5JYH+V6BcM50lCKCBEEnZ+imak7IwxJL/LQ3wu55fKr0d1Duy84GjOP
 2i0IvK7OAtRd2QRpBeVJUGWbnK6o7V2MAFKMWjvs3gitzjxWkDBHEOhcoPUkn84/KqRj
 G5teDdkMVoOEjVffKjG+Z1MuzUyxAG+BTBMeA88GEF3MfEN4nqebsEOpYqFKVwtbOAZi
 ecayShb63JzbU8iLHuwtT/+PUajansT3bJpOS5RpzPeVohW0Hyv0kVAjQyMb+12ifREk
 JT/ytG1McDH4RmRda3bayqttwjFzOPHkm1VLZlIPU66tJRu49N0bAMGcvytFJC/UO5HQ yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyb1wr78e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 10:53:21 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25RArLpS027634;
        Mon, 27 Jun 2022 10:53:21 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyb1wr77q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 10:53:21 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25RAolXE022864;
        Mon, 27 Jun 2022 10:53:19 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3gwt08ts67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 10:53:19 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25RArGYC24969624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 10:53:16 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7461F4C040;
        Mon, 27 Jun 2022 10:53:16 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CF174C046;
        Mon, 27 Jun 2022 10:53:16 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jun 2022 10:53:16 +0000 (GMT)
Date:   Mon, 27 Jun 2022 12:53:14 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        scgl@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 3/3] lib: s390x: better smp interrupt
 checks
Message-ID: <20220627125314.599cc580@p-imbrenda>
In-Reply-To: <19169d83-ad31-da70-b3bb-bd7ba43e6484@linux.ibm.com>
References: <20220624144518.66573-1-imbrenda@linux.ibm.com>
        <20220624144518.66573-4-imbrenda@linux.ibm.com>
        <19169d83-ad31-da70-b3bb-bd7ba43e6484@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1zuNgim6Kj6CQ-9TTW3cO79SCEaUehHH
X-Proofpoint-GUID: HWz4_nd9nBLK_uqpslf-r68nf9vcnyBQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206270046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Jun 2022 11:28:18 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 6/24/22 16:45, Claudio Imbrenda wrote:
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
> > Both program interrupts and extern interrupts are now CPU-bound, even
> > though some extern interrupts are floating (notably, the SCLP
> > interrupt). In those cases, the testcases should mask interrupts and/or
> > expect them appropriately according to need.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   lib/s390x/asm/arch_def.h | 17 +++++++++++-
> >   lib/s390x/smp.h          |  8 +-----
> >   lib/s390x/interrupt.c    | 57 +++++++++++++++++++++++++++++-----------
> >   lib/s390x/smp.c          | 11 ++++++++
> >   4 files changed, 70 insertions(+), 23 deletions(-)  
> [...]
> >   
> > +struct lowcore *smp_get_lowcore(uint16_t idx)
> > +{
> > +	if (THIS_CPU->idx == idx)
> > +		return &lowcore;
> > +
> > +	check_idx(idx);
> > +	return cpus[idx].lowcore;
> > +}  
> 
> This function is unused.

not currently, but it's useful to have in lib

should I split this into a separate patch?

> 
> > +
> >   int smp_sigp(uint16_t idx, uint8_t order, unsigned long parm, uint32_t *status)
> >   {
> >   	check_idx(idx);
> > @@ -253,6 +262,7 @@ static int smp_cpu_setup_nolock(uint16_t idx, struct psw psw)
> >   
> >   	/* Copy all exception psws. */
> >   	memcpy(lc, cpus[0].lowcore, 512);
> > +	lc->this_cpu = cpus + idx;  
> 
> Why not:
> lc->this_cpu = &cpus[idx];

it's equivalent, do you have a reason for changing it?

> 
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

