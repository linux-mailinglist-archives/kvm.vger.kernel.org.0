Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF43C52A70D
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 17:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349842AbiEQPir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 11:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350334AbiEQPiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 11:38:25 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB1151E41;
        Tue, 17 May 2022 08:37:32 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HFNImF023815;
        Tue, 17 May 2022 15:37:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=EDNJE/cXEUZMfgBjlRbLOJasE+Xi7Iz3E2G7Nfo6ppE=;
 b=hswCeqZmVHSJu4hUEVIVJYCU4XDnL5idi/j8/fPkblgSM0H/J6QM13dxl9u/xSwW3+vx
 m/MBZOqqDMjOx6j5JHGLctloc/J3IBj0GALZxg3B8vP9C0jugzso9a/SHlJzPEWIRDKq
 Nui/O4emNhbYxT+lTSHvunGMcQ1IWrz6BnzqERH6yUXLyopoCgh4dIdoEKKseWpoShtW
 Su6fCtZtPkt38V2h7LRqrmFIwuKW4AE+xVgd86E4p+hiWXb1H344Vv6merjKaNNSkK1l
 nqH+H9WsIYMg0zO9nnBiOCF7srwYjJZTfv975EtSPZDYSyPlcQiqgfx7wOetyHfGcYRs qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4cpku5w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 15:37:31 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HFOh2k031614;
        Tue, 17 May 2022 15:37:31 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4cpku5v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 15:37:31 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HFUK6N003766;
        Tue, 17 May 2022 15:32:29 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3g2429cekr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 15:32:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HFWQlf49545630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 15:32:26 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 167D6AE04D;
        Tue, 17 May 2022 15:32:26 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6FA9AE045;
        Tue, 17 May 2022 15:32:25 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 15:32:25 +0000 (GMT)
Date:   Tue, 17 May 2022 17:32:23 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 2/4] s390x: Test TEID values in
 storage key test
Message-ID: <20220517173223.5042996a@p-imbrenda>
In-Reply-To: <5a0a7d03e11c8c4e379ac1a7198a8d965812fd63.camel@linux.ibm.com>
References: <20220517115607.3252157-1-scgl@linux.ibm.com>
        <20220517115607.3252157-3-scgl@linux.ibm.com>
        <20220517154603.6c7b9af5@p-imbrenda>
        <5a0a7d03e11c8c4e379ac1a7198a8d965812fd63.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nQOrSTyloCttCIVZZeI6M9MU4Ev9KGpH
X-Proofpoint-GUID: G-7lz0qiBfjfJdHpviC8D0QG3YloWpKK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 clxscore=1015 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 May 2022 17:11:37 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> On Tue, 2022-05-17 at 15:46 +0200, Claudio Imbrenda wrote:
> > On Tue, 17 May 2022 13:56:05 +0200
> > Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> >   
> > > On a protection exception, test that the Translation-Exception
> > > Identification (TEID) values are correct given the circumstances of the
> > > particular test.
> > > The meaning of the TEID values is dependent on the installed
> > > suppression-on-protection facility.
> > > 
> > > Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> > > ---
> > >  lib/s390x/asm/facility.h | 21 ++++++++++++++
> > >  lib/s390x/sclp.h         |  4 +++
> > >  lib/s390x/sclp.c         |  2 ++
> > >  s390x/skey.c             | 60 ++++++++++++++++++++++++++++++++++++----
> > >  4 files changed, 81 insertions(+), 6 deletions(-)
> > >   
> [...]
> 
> > > +static void check_key_prot_exc(enum access access, enum protection prot)
> > > +{
> > > +	struct lowcore *lc = 0;
> > > +	union teid teid;
> > > +
> > > +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> > > +	report_prefix_push("TEID");
> > > +	teid.val = lc->trans_exc_id;
> > > +	switch (get_supp_on_prot_facility()) {
> > > +	case SOP_NONE:
> > > +	case SOP_BASIC:
> > > +		break;
> > > +	case SOP_ENHANCED_1:
> > > +		if ((teid.val & (BIT(63 - 61))) == 0)  
> > 
> > can you at least replace the hardcoded values with a macro or a const
> > variable?  
> 
> I'll see if maybe I can come up with a nice way to extend the teid, but
> I'll use a const if not.
> > 
> > like:
> > 
> > 	const unsigned long esop_bit = BIT(63 - 61);
> > 
> > 	...
> > 
> > 		if (!(teid.val & esop_bit))
> >   
> > > +			report_pass("key-controlled protection");  
> > 
> > actually, now that I think of it, aren't we expecting the bit to be
> > zero? should that not be like this?
> > 
> > report (!(teid.val & esop_bit), ...);  
> 
> Indeed.
> >   
> > > +		break;
> > > +	case SOP_ENHANCED_2:
> > > +		if ((teid.val & (BIT(63 - 56) | BIT(63 - 61))) == 0) {  
> > 
> > const unsigned long esop2_bits = 0x8C;	/* bits 56, 60, and 61 */
> > const unsigned long esop2_key_prot = BIT(63 - 60);
> > 
> > if ((teid.val & esop2_bits) == 0) {
> > 	report_pass(...);
> >   
> > > +			report_pass("key-controlled protection");
> > > +			if (teid.val & BIT(63 - 60)) {  
> > 
> > } else if ((teid.val & esop2_bits) == esop_key_prot) {  
> 
> 010 binary also means key protection, so we should pass that test here,
> too. The access code checking is an additional test, IMO.

yes, my idea was to pass it only once when checking the fetch/store
indication (if any)

> >   
> > > +				int access_code = teid.fetch << 1 | teid.store;
> > > +
> > > +				if (access_code == 2)
> > > +					report((access & 2) && (prot & 2),
> > > +					       "exception due to fetch");
> > > +				if (access_code == 1)
> > > +					report((access & 1) && (prot & 1),
> > > +					       "exception due to store");
> > > +				/* no relevant information if code is 0 or 3 */  
> > 
> > here you should check for the access-exception-fetch/store-indi-
> > cation facility, then you can check the access code  
> 
> Oh, yes. By the way, can we get rid of magic numbers for facility
> checking? Just defining an enum in lib/asm/facility.h and doing
> test_facility(FCLTY_ACCESS_EXC_FETCH_STORE_INDICATION) would be an
> improvement.

not sure, that name looks very ugly

although that would definitely make future review easier, as you say

but that would be something for another patchseries :)

> Well, I guess you'd end up with quite horribly long names, but at least
> you have to review the values only once and not for every patch that
> tests a facility. 
> > 
> > and at this point you should check for 0 explicitly (always pass) and 3
> > (always fail)  
> 
> I'm fine with passing 0, but I'm not so sure about 3.
> The value is reserved, so the correct thing to do is to not attribute
> *any* meaning to it. But kvm currently really should not set it either.

fine

> > > +			}
> > > +		}  
> > 
> > } else {
> > 	/* not key protection */
> > 	report_fail(...);
> > }  
> > > +		break;
> > > +	}
> > > +	report_prefix_pop();
> > > +}
> > > +  
> [...]
> 

