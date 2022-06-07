Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C4B53FD0C
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 13:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242615AbiFGLLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 07:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243075AbiFGLKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 07:10:38 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B30986D0;
        Tue,  7 Jun 2022 04:09:06 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257A0G2h012945;
        Tue, 7 Jun 2022 11:09:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=QMmAXMc3VpP+QXpAwauYdGXx9BAL9Qwb9B7xZ1fJumo=;
 b=s/I6bjF40Jil1/eBUh7LFXcGy4H/qIxLcW1NTKAuDREunDifdH038gpDObV2o+ej8wUW
 Y/V2qTALczMygMeFu7rZIewv8buFqFQU4HEfpScCOT1A6mud7K2ZwZi0db7lqxVLHQ/C
 pClB2v/37hQG6OT1BQ+3p/B+GtwqcoZZojPGwl5pQ3B/9pOLIzXHrG60VOoJqa8EA7NQ
 z24J9niiTyrH5YttrURkOJ72AXL3apYpnkdvAJMUvvPpLOv/DljIvi1GF4u5TwsqqKnW
 /I54QCdnG1AqFtOm4qKtVRDAtOXQwncw/nm0azTwM30dY9nobStFJ/AFnsEYm4WIiK/j Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gj4hu183f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 11:09:05 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 257AmBHI013102;
        Tue, 7 Jun 2022 11:09:05 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gj4hu1830-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 11:09:05 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 257B7wxH022528;
        Tue, 7 Jun 2022 11:09:03 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3gfy19bne9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 11:09:03 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 257B90EF22348140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jun 2022 11:09:00 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 345A3AE05A;
        Tue,  7 Jun 2022 11:09:00 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECBFDAE057;
        Tue,  7 Jun 2022 11:08:59 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Jun 2022 11:08:59 +0000 (GMT)
Date:   Tue, 7 Jun 2022 13:08:57 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, pmorel@linux.ibm.com, nrb@linux.ibm.com,
        thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] lib: s390x: better smp interrupt
 checks
Message-ID: <20220607130857.391ddfc6@p-imbrenda>
In-Reply-To: <5552dc4a-4c1f-2f01-eaa7-fa42042d4455@linux.ibm.com>
References: <20220603154037.103733-1-imbrenda@linux.ibm.com>
        <20220603154037.103733-3-imbrenda@linux.ibm.com>
        <5552dc4a-4c1f-2f01-eaa7-fa42042d4455@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -anTONY1mqwWQDWF5ElwxLjqL0tKtiUz
X-Proofpoint-GUID: ZBzMvsa_Qx18YYZfo0T1KP26WmseXc3n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_04,2022-06-07_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206070044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Jun 2022 12:01:11 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> On 6/3/22 17:40, Claudio Imbrenda wrote:
> > Use per-CPU flags and callbacks for Program, Extern, and I/O interrupts
> > instead of global variables.
> > 
> > This allows for more accurate error handling; a CPU waiting for an
> > interrupt will not have it "stolen" by a different CPU that was not
> > supposed to wait for one, and now two CPUs can wait for interrupts at
> > the same time.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  lib/s390x/asm/arch_def.h |  7 ++++++-
> >  lib/s390x/interrupt.c    | 38 ++++++++++++++++----------------------
> >  2 files changed, 22 insertions(+), 23 deletions(-)
> > 
> > diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> > index 72553819..3a0d9c43 100644
> > --- a/lib/s390x/asm/arch_def.h
> > +++ b/lib/s390x/asm/arch_def.h
> > @@ -124,7 +124,12 @@ struct lowcore {
> >  	uint8_t		pad_0x0280[0x0308 - 0x0280];	/* 0x0280 */
> >  	uint64_t	sw_int_crs[16];			/* 0x0308 */
> >  	struct psw	sw_int_psw;			/* 0x0388 */
> > -	uint8_t		pad_0x0310[0x11b0 - 0x0398];	/* 0x0398 */
> > +	uint32_t	pgm_int_expected;		/* 0x0398 */
> > +	uint32_t	ext_int_expected;		/* 0x039c */
> > +	void		(*pgm_cleanup_func)(void);	/* 0x03a0 */
> > +	void		(*ext_cleanup_func)(void);	/* 0x03a8 */
> > +	void		(*io_int_func)(void);		/* 0x03b0 */  
> 
> If you switch the function pointers and the *_expected around,
> you can use bools for the latter, right?
> I think, since they're names suggest that they're bools, they should
> be. Additionally I prefer true/false over 1/0, since the latter raises
> the questions if other values are also used.

that's exactly what I wanted to avoid. uint32_t can easily be accessed
atomically and/or compare-and-swapped if needed.

I don't like using true/false for things that are not bools

> 
> > +	uint8_t		pad_0x03b8[0x11b0 - 0x03b8];	/* 0x03b8 */
> >  	uint64_t	mcck_ext_sa_addr;		/* 0x11b0 */
> >  	uint8_t		pad_0x11b8[0x1200 - 0x11b8];	/* 0x11b8 */
> >  	uint64_t	fprs_sa[16];			/* 0x1200 */
> > diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> > index 27d3b767..e57946f0 100644
> > --- a/lib/s390x/interrupt.c
> > +++ b/lib/s390x/interrupt.c
> > @@ -15,14 +15,11 @@
> >  #include <fault.h>
> >  #include <asm/page.h>
> >  
> > -static bool pgm_int_expected;
> > -static bool ext_int_expected;
> > -static void (*pgm_cleanup_func)(void);
> >  static struct lowcore *lc;
> >  
> >  void expect_pgm_int(void)
> >  {
> > -	pgm_int_expected = true;
> > +	lc->pgm_int_expected = 1;
> >  	lc->pgm_int_code = 0;
> >  	lc->trans_exc_id = 0;
> >  	mb();  
> 
> [...]
> 
> >  void handle_pgm_int(struct stack_frame_int *stack)
> >  {
> > -	if (!pgm_int_expected) {
> > +	if (!lc->pgm_int_expected) {
> >  		/* Force sclp_busy to false, otherwise we will loop forever */
> >  		sclp_handle_ext();
> >  		print_pgm_info(stack);
> >  	}
> >  
> > -	pgm_int_expected = false;
> > +	lc->pgm_int_expected = 0;
> >  
> > -	if (pgm_cleanup_func)
> > -		(*pgm_cleanup_func)();
> > +	if (lc->pgm_cleanup_func)
> > +		(*lc->pgm_cleanup_func)();  
> 
> [...]
> 
> > +	if (lc->io_int_func)
> > +		return lc->io_int_func();  
> Why is a difference between the function pointer usages here?
> 

because that is how it was before; both have the same semantics anyway

